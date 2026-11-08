import SwiftUI
import MapKit

struct SendRequestView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.openURL) private var openURL
    @State private var pickup: RidePoint?
    @State private var pickupLabel = ""
    @State private var dropoff: RidePoint?
    @State private var dropoffLabel = ""
    @State private var parcelSize = "medium"
    @State private var quoteResponse: ParcelQuoteResponse?
    @State private var paymentMethod = "cash"
    @State private var pickupMode = "now"
    @State private var scheduledAt = Date().addingTimeInterval(3600)
    @State private var senderName = ""
    @State private var senderPhone = ""
    @State private var recipientName = ""
    @State private var recipientPhone = ""
    @State private var parcelDescription = ""
    @State private var weight = ""
    @State private var declaredValue = ""
    @State private var instructions = ""
    @State private var acknowledged = false
    @State private var isQuoting = false
    @State private var isRequesting = false
    @State private var errorMessage: String?
    @State private var createdParcel: ParcelJob?
    @State private var createdParcelID: String?
    @State private var createdParcelError: String?
    @State private var requestOutcomeUncertain = false
    @State private var paymentIssue: String?
    @State private var quoteGeneration = UUID()
    @State private var lastQuotedIntent: SendQuoteIntent?

    var body: some View {
        Group {
            if let createdParcel {
                SendTrackingView(initialParcel: createdParcel)
                    .safeAreaInset(edge: .top) {
                        if let paymentIssue {
                            Label(paymentIssue, systemImage: "exclamationmark.triangle.fill")
                                .font(SpotlyFont.callout()).foregroundStyle(SpotlyColors.warning)
                                .padding(12).frame(maxWidth: .infinity)
                                .background(SpotlyColors.warningBg)
                        }
                    }
            } else if let createdParcelID {
                pendingParcel(id: createdParcelID)
            } else {
                Form {
                    Section {
                        VStack(alignment: .leading, spacing: 7) {
                            Label("Spotly Send", systemImage: "shippingbox.fill").font(SpotlyFont.caption(.semibold)).foregroundStyle(SpotlyServiceKind.send.tint)
                            Text("Send it across town.").font(SpotlyFont.title(.bold))
                            Text("Get a delivery price before requesting a courier, then follow the handoff in Activity.").font(SpotlyFont.callout()).foregroundStyle(SpotlyColors.textSecondary)
                        }
                        .padding(.vertical, 6)
                    }

                    Section("1. Route") {
                        NavigationLink { AddressPickerView(country: appState.selectedCountryCode, city: appState.selectedCity, selectedPoint: $pickup, selectedLabel: $pickupLabel) } label: {
                            LabeledContent("Pickup") { Text(pickupLabel.isEmpty ? "Choose" : pickupLabel).lineLimit(2) }
                        }
                        NavigationLink { AddressPickerView(country: appState.selectedCountryCode, city: appState.selectedCity, selectedPoint: $dropoff, selectedLabel: $dropoffLabel) } label: {
                            LabeledContent("Drop-off") { Text(dropoffLabel.isEmpty ? "Choose" : dropoffLabel).lineLimit(2) }
                        }
                    }
                    .onChange(of: pickup) { _, _ in Task { await getQuote() } }
                    .onChange(of: dropoff) { _, _ in Task { await getQuote() } }

                    if pickup != nil && dropoff != nil {
                        Section("2. Parcel") {
                            Picker("Size", selection: $parcelSize) {
                                ForEach(parcelSizes, id: \.self) { size in Text(parcelSizeLabel(size)).tag(size) }
                            }
                            .onChange(of: parcelSize) { _, _ in Task { await getQuote() } }
                            TextField("What are you sending?", text: $parcelDescription, axis: .vertical).lineLimit(2...4)
                            TextField("Estimated weight (kg, optional)", text: $weight).keyboardType(.decimalPad)
                            TextField("Declared value (optional)", text: $declaredValue).keyboardType(.decimalPad)
                        }
                    } else {
                        Section {
                            Label("Choose pickup and drop-off to continue", systemImage: "arrow.triangle.turn.up.right.diamond")
                                .foregroundStyle(SpotlyColors.textSecondary)
                        }
                    }

                    if pickup != nil && dropoff != nil && parcelDescription.trimmingCharacters(in: .whitespacesAndNewlines).count >= 2 {
                        Section("3. Sender & recipient") {
                            TextField("Sender name", text: $senderName).textContentType(.name)
                            TextField("Sender phone", text: $senderPhone).textContentType(.telephoneNumber).keyboardType(.phonePad)
                            TextField("Recipient name", text: $recipientName).textContentType(.name)
                            TextField("Recipient phone", text: $recipientPhone).textContentType(.telephoneNumber).keyboardType(.phonePad)
                            TextField("Delivery instructions (optional)", text: $instructions, axis: .vertical).lineLimit(2...5)
                        }

                        Section("4. Pickup & quote") {
                            Picker("When", selection: $pickupMode) {
                                Text("Now").tag("now")
                                if quoteResponse?.scheduledEnabled != false { Text("Schedule").tag("scheduled") }
                            }
                            .pickerStyle(.segmented)
                            if pickupMode == "scheduled" {
                                DatePicker("Pickup", selection: $scheduledAt, in: Date().addingTimeInterval(20 * 60)...Date().addingTimeInterval(7 * 86400), displayedComponents: [.date, .hourAndMinute])
                            }
                        }
                    }

                    if let quote = quoteResponse?.quote {
                        Section("Your estimate") {
                            LabeledContent("Delivery price", value: money(quote.total, currency: quote.currency))
                            LabeledContent("Distance", value: "\(String(format: "%.1f", quote.distanceKm)) km")
                            LabeledContent("Estimated time", value: "About \(quote.durationMinutes) min")
                            LabeledContent("Size", value: quote.parcelSizeLabel)
                            Picker("Payment", selection: $paymentMethod) {
                                ForEach(quoteResponse?.paymentMethods ?? ["cash"], id: \.self) { method in Text(method == "paynow" ? "Paynow" : method.capitalized).tag(method) }
                            }
                        }
                    } else if isQuoting {
                        Section { ProgressView("Calculating delivery price…") }
                    }

                    Section {
                        Toggle(isOn: $acknowledged) {
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Restricted-items acknowledgement").font(SpotlyFont.headline())
                                Text("I confirm the parcel does not contain prohibited, illegal, dangerous or undisclosed restricted items.").font(SpotlyFont.caption()).foregroundStyle(SpotlyColors.textSecondary)
                            }
                        }
                    }

                    if let errorMessage {
                        Section {
                            Label(errorMessage, systemImage: "exclamationmark.triangle.fill")
                                .foregroundStyle(SpotlyColors.error)
                        }
                    }
                    if requestOutcomeUncertain {
                        Section("Request status uncertain") {
                            Text("Your request may have been received. Check Activity before sending another one.")
                                .font(SpotlyFont.callout()).foregroundStyle(SpotlyColors.textSecondary)
                            Button("Open Activity to check for a request") { appState.selectedTab = .activity }
                            Button("I checked Activity — allow another request") { requestOutcomeUncertain = false }
                        }
                    }

                    Section {
                        Button { Task { await requestSend() } } label: {
                            HStack { Spacer(); if isRequesting { ProgressView().tint(.white) } else { Text(appState.isAuthenticated ? "Request courier" : "Sign in to request").font(SpotlyFont.headline(.bold)) }; Spacer() }
                        }
                        .listRowBackground(SpotlyServiceKind.send.tint).foregroundStyle(.white)
                        .disabled(isRequesting || isQuoting || requestOutcomeUncertain || quoteResponse == nil || lastQuotedIntent != currentQuoteIntent || !acknowledged)
                    }
                }
                .scrollContentBackground(.hidden)
                .background(SpotlyColors.background)
                .navigationTitle("Send")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(.hidden, for: .tabBar)
                .task {
                    senderName = appState.currentUser?.name ?? ""
                    senderPhone = appState.currentUser?.phone ?? ""
                    if let active = appState.activity.activeParcel { createdParcel = active }
                }
            }
        }
    }

    private var parcelSizes: [String] {
        let map = quoteResponse?.parcelSizes ?? [:]
        let base = ["small", "medium", "large", "bulky"]
        return map.isEmpty ? base : base.filter { map[$0] != nil } + map.keys.filter { !base.contains($0) }.sorted()
    }

    private func parcelSizeLabel(_ size: String) -> String { quoteResponse?.parcelSizes?[size]?.label ?? size.capitalized }

    private var currentQuoteIntent: SendQuoteIntent? {
        guard let pickup, let dropoff else { return nil }
        return SendQuoteIntent(pickup: pickup, dropoff: dropoff, size: parcelSize)
    }

    private func getQuote() async {
        quoteGeneration = UUID()
        let generation = quoteGeneration
        quoteResponse = nil
        lastQuotedIntent = nil
        errorMessage = nil
        guard let intent = currentQuoteIntent else { isQuoting = false; return }
        isQuoting = true
        defer { if quoteGeneration == generation { isQuoting = false } }
        do {
            let response = try await SpotlySendService.shared.quote(
                pickup: intent.pickup, dropoff: intent.dropoff, parcelSize: intent.size)
            guard generation == quoteGeneration, currentQuoteIntent == intent, !Task.isCancelled else { return }
            quoteResponse = response
            lastQuotedIntent = intent
            if response.paymentMethods?.contains(paymentMethod) != true {
                paymentMethod = response.paymentMethods?.first ?? "cash"
            }
        } catch {
            guard generation == quoteGeneration, currentQuoteIntent == intent, !Task.isCancelled else { return }
            errorMessage = error.localizedDescription
        }
    }

    private func requestSend() async {
        guard appState.isAuthenticated else { appState.hasCompletedEntryFlow = false; appState.isGuestMode = false; return }
        guard !isRequesting, !isQuoting, !requestOutcomeUncertain, createdParcelID == nil,
              let intent = currentQuoteIntent, lastQuotedIntent == intent,
              let quote = quoteResponse?.quote else {
            errorMessage = "Your route or parcel size changed. Refresh the delivery quote first."
            return
        }
        let pickup = intent.pickup
        let dropoff = intent.dropoff
        guard senderName.count >= 2, senderPhone.filter(\.isNumber).count >= 5, recipientName.count >= 2, recipientPhone.filter(\.isNumber).count >= 5, parcelDescription.count >= 2, acknowledged else {
            errorMessage = "Complete the sender, recipient, parcel and safety details."; return
        }
        isRequesting = true; errorMessage = nil
        defer { isRequesting = false }
        do {
            guard let size = SpotlyParcelSize(rawValue: parcelSize),
                  let payment = SpotlyPaymentMethod(rawValue: paymentMethod),
                  let mode = SpotlyPickupMode(rawValue: pickupMode),
                  let currency = SpotlyCurrencyCode(rawValue: quote.currency) else {
                throw SpotlyAPIError.server(status: 422, message: "The Send quote is not compatible with this app version.")
            }
            let body = ParcelRequestBody(
                pickup: pickup,
                dropoff: dropoff,
                parcelSize: size,
                paymentMethod: payment,
                senderName: senderName,
                senderPhone: senderPhone,
                recipientName: recipientName,
                recipientPhone: recipientPhone,
                parcelDescription: parcelDescription,
                estimatedWeightKg: Double(weight),
                declaredValue: Double(declaredValue),
                instructions: instructions.nilIfBlank,
                pickupMode: mode,
                scheduledPickupAt: pickupMode == "scheduled" ? ISO8601DateFormatter().string(from: scheduledAt) : nil,
                quotedTotal: quote.total,
                quotedCurrency: currency
            )
            let response = try await SpotlySendService.shared.request(body)
            createdParcelID = response.parcelJobId
            await refreshCreatedParcel()
        } catch {
            requestOutcomeUncertain = (error as? SpotlyAPIError)?.mayHaveCommittedWrite ?? true
            errorMessage = requestOutcomeUncertain
                ? "Couldn’t confirm your Send request. Check Activity before trying again. " + error.localizedDescription
                : error.localizedDescription
        }
    }

    private func refreshCreatedParcel() async {
        guard let id = createdParcelID else { return }
        createdParcelError = nil
        do {
            let parcel = try await appState.activity.parcel(id: id)
            createdParcel = parcel
            await appState.activity.load(user: appState.currentUser, force: true)
            if paymentMethod == "paynow", let orderID = parcel.orderId, paymentIssue == nil {
                do {
                    let payment = try await SpotlyCommerceService.shared.initiatePaynow(
                        orderId: orderID, channel: "web", phone: senderPhone)
                    if let value = payment.redirectUrl,
                       let url = URL(string: value), url.scheme?.lowercased() == "https" {
                        openURL(url)
                    } else {
                        paymentIssue = payment.instructions?.nilIfBlank ?? "Complete payment from Activity. Your Send request was created."
                    }
                } catch {
                    paymentIssue = "Send was requested, but payment could not start. Open Activity to retry payment."
                }
            }
        } catch {
            createdParcelError = "Your Send request was created, but tracking could not load. Retry or open Activity."
        }
    }

    private func pendingParcel(id: String) -> some View {
        ContentUnavailableView {
            Label("Send request received", systemImage: "shippingbox.fill")
        } description: {
            Text(createdParcelError ?? "Spotly received your Send request. Loading tracking…")
        } actions: {
            Button("Retry tracking") { Task { await refreshCreatedParcel() } }
                .buttonStyle(.borderedProminent)
            Button("Open Activity") { appState.selectedTab = .activity }
        }
    }
}
