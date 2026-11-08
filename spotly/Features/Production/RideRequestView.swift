import SwiftUI
import MapKit

struct RideRequestView: View {
    @Environment(AppState.self) private var appState
    @State private var pickup: RidePoint?
    @State private var pickupLabel = ""
    @State private var dropoff: RidePoint?
    @State private var dropoffLabel = ""
    @State private var serviceType = "economy"
    @State private var quoteResponse: RideQuoteResponse?
    @State private var paymentMethod = "cash"
    @State private var note = ""
    @State private var isQuoting = false
    @State private var isRequesting = false
    @State private var errorMessage: String?
    @State private var createdRide: RideTrip?
    @State private var createdRideID: String?
    @State private var createdRideError: String?
    @State private var requestOutcomeUncertain = false
    @State private var quoteGeneration = UUID()
    @State private var lastQuotedIntent: RideQuoteIntent?

    var body: some View {
        Group {
            if let createdRide {
                RideTrackingView(initialRide: createdRide)
            } else if let createdRideID {
                pendingRide(id: createdRideID)
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 22) {
                        hero
                        routeCard
                        if pickup != nil && dropoff != nil { quoteSection }
                        if let errorMessage, quoteResponse == nil, !isQuoting {
                            Label(errorMessage, systemImage: "exclamationmark.triangle.fill")
                                .font(SpotlyFont.callout()).foregroundStyle(SpotlyColors.error)
                        }
                        if requestOutcomeUncertain {
                            Button("Open Activity to check for a request") { appState.selectedTab = .activity }
                                .buttonStyle(.bordered)
                            Button("I checked Activity — allow another request") { requestOutcomeUncertain = false }
                                .font(SpotlyFont.caption())
                        }
                        safetyNote
                    }
                    .padding(18)
                    .padding(.bottom, 28)
                }
                .background(SpotlyColors.background)
                .navigationTitle("Ride")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .task {
            if let active = appState.activity.activeRide { createdRide = active }
        }
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 7) {
            Label("Spotly Ride", systemImage: "car.fill").font(SpotlyFont.caption(.semibold)).foregroundStyle(SpotlyServiceKind.ride.tint)
            Text("Where are you going?").font(SpotlyFont.title(.bold)).foregroundStyle(SpotlyColors.textPrimary)
            Text("See your fare before requesting a ride.").font(SpotlyFont.callout()).foregroundStyle(SpotlyColors.textSecondary)
        }
    }

    private var routeCard: some View {
        VStack(spacing: 0) {
            NavigationLink {
                AddressPickerView(country: appState.selectedCountryCode, city: appState.selectedCity, selectedPoint: $pickup, selectedLabel: $pickupLabel)
            } label: {
                routeRow(icon: "circle.fill", title: "Pickup", value: pickupLabel.isEmpty ? "Choose pickup" : pickupLabel, color: SpotlyColors.success)
            }
            .buttonStyle(.plain)

            Divider().padding(.leading, 52)

            NavigationLink {
                AddressPickerView(country: appState.selectedCountryCode, city: appState.selectedCity, selectedPoint: $dropoff, selectedLabel: $dropoffLabel)
            } label: {
                routeRow(icon: "mappin.circle.fill", title: "Destination", value: dropoffLabel.isEmpty ? "Where to?" : dropoffLabel, color: SpotlyServiceKind.ride.tint)
            }
            .buttonStyle(.plain)

            if pickup == nil {
                Divider().padding(.leading, 52)
                Button {
                    Task { await useCurrentLocation() }
                } label: {
                    Label("Use my current location", systemImage: "location.fill")
                        .font(SpotlyFont.callout(.semibold)).foregroundStyle(SpotlyColors.accent)
                        .frame(maxWidth: .infinity, alignment: .leading).padding(14)
                }
                .buttonStyle(.plain)
            }
        }
        .background(SpotlyColors.surface, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(SpotlyColors.border))
        .onChange(of: pickup) { _, _ in Task { await getQuote() } }
        .onChange(of: dropoff) { _, _ in Task { await getQuote() } }
    }

    private func routeRow(icon: String, title: String, value: String, color: Color) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon).foregroundStyle(color).frame(width: 24)
            VStack(alignment: .leading, spacing: 3) {
                Text(title).font(SpotlyFont.caption(.semibold)).foregroundStyle(SpotlyColors.textSecondary)
                Text(value).font(SpotlyFont.body(.semibold)).foregroundStyle(SpotlyColors.textPrimary).lineLimit(2)
            }
            Spacer()
            Image(systemName: "chevron.right").font(.caption.bold()).foregroundStyle(SpotlyColors.textTertiary)
        }
        .padding(14)
    }

    @ViewBuilder
    private var quoteSection: some View {
        if let pickup, let dropoff {
            Map {
                Marker("Pickup", coordinate: CLLocationCoordinate2D(latitude: pickup.lat, longitude: pickup.lng)).tint(SpotlyColors.success)
                Marker("Destination", coordinate: CLLocationCoordinate2D(latitude: dropoff.lat, longitude: dropoff.lng)).tint(SpotlyServiceKind.ride.tint)
            }
            .frame(height: 190)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .allowsHitTesting(false)
        }

        if isQuoting {
            ProgressView("Calculating your fare…").frame(maxWidth: .infinity).padding(.vertical, 24)
        } else if let errorMessage, quoteResponse == nil {
            Label(errorMessage, systemImage: "exclamationmark.triangle.fill").font(SpotlyFont.callout()).foregroundStyle(SpotlyColors.error)
        } else if let response = quoteResponse {
            VStack(alignment: .leading, spacing: 16) {
                Text("Choose your ride").font(SpotlyFont.title2())
                ForEach(rideTypes(response), id: \.key) { key, config in
                    let selected = serviceType == key
                    Button {
                        serviceType = key
                        Task { await getQuote() }
                    } label: {
                        HStack(spacing: 14) {
                            Image(systemName: key == "xl" ? "bus.fill" : "car.fill")
                                .font(.system(size: 21, weight: .semibold)).foregroundStyle(selected ? .white : SpotlyServiceKind.ride.tint)
                                .frame(width: 46, height: 46)
                                .background(selected ? SpotlyServiceKind.ride.tint : SpotlyServiceKind.ride.tint.opacity(0.10), in: RoundedRectangle(cornerRadius: 14))
                            VStack(alignment: .leading, spacing: 3) {
                                Text(config.label ?? key.capitalized).font(SpotlyFont.headline())
                                Text("Up to \(config.seats ?? 4) people").font(SpotlyFont.caption()).foregroundStyle(SpotlyColors.textSecondary)
                            }
                            Spacer()
                            if selected, let quote = response.quote as RideQuote? {
                                Text(money(quote.total, currency: quote.currency)).font(SpotlyFont.headline(.bold))
                            }
                        }
                        .foregroundStyle(SpotlyColors.textPrimary)
                        .padding(12)
                        .background(SpotlyColors.surface, in: RoundedRectangle(cornerRadius: 18))
                        .overlay(RoundedRectangle(cornerRadius: 18).stroke(selected ? SpotlyServiceKind.ride.tint : SpotlyColors.border, lineWidth: selected ? 1.5 : 1))
                    }
                    .buttonStyle(.plain)
                }

                if let quote = quoteResponse?.quote {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Estimated fare").font(SpotlyFont.caption()).foregroundStyle(SpotlyColors.textSecondary)
                            Text(money(quote.total, currency: quote.currency)).font(SpotlyFont.title(.bold))
                            Text("\(String(format: "%.1f", quote.distanceKm)) km · about \(quote.durationMinutes) min").font(SpotlyFont.caption()).foregroundStyle(SpotlyColors.textSecondary)
                        }
                        Spacer()
                        SpotlyStatusPill(text: quote.serviceLabel, color: SpotlyServiceKind.ride.tint)
                    }
                }

                paymentPicker

                TextField("Note for your driver (optional)", text: $note, axis: .vertical)
                    .textFieldStyle(.roundedBorder).lineLimit(2...4)

                if let errorMessage {
                    Label(errorMessage, systemImage: "exclamationmark.triangle.fill").foregroundStyle(SpotlyColors.error).font(SpotlyFont.callout())
                }

                Button { Task { await requestRide() } } label: {
                    HStack { Spacer(); if isRequesting { ProgressView().tint(.white) } else { Text(appState.isAuthenticated ? "Request \(response.quote.serviceLabel)" : "Sign in to request").font(SpotlyFont.headline(.bold)) }; Spacer() }
                        .frame(height: 52).background(SpotlyServiceKind.ride.tint, in: RoundedRectangle(cornerRadius: 16))
                }
                .buttonStyle(.plain).foregroundStyle(.white).disabled(isRequesting || isQuoting || requestOutcomeUncertain || lastQuotedIntent != currentQuoteIntent)
            }
        }
    }

    private var paymentPicker: some View {
        VStack(alignment: .leading, spacing: 9) {
            Text("Payment").font(SpotlyFont.caption(.semibold)).foregroundStyle(SpotlyColors.textSecondary)
            Picker("Payment", selection: $paymentMethod) {
                ForEach(quoteResponse?.paymentMethods ?? ["cash"], id: \.self) { method in Text(method == "paynow" ? "Paynow" : method.capitalized).tag(method) }
            }
            .pickerStyle(.segmented)
            Text(paymentMethod == "cash" ? "Cash is collected by your driver at drop-off." : "Paynow rides are paid from Activity according to the server payment state.")
                .font(SpotlyFont.caption()).foregroundStyle(SpotlyColors.textSecondary)
        }
    }

    private var safetyNote: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "shield.checkered").foregroundStyle(SpotlyServiceKind.ride.tint)
            VStack(alignment: .leading, spacing: 4) {
                Text("Verify before you ride").font(SpotlyFont.headline())
                Text("When a driver is assigned, match the driver and vehicle details in Spotly. Only share your pickup PIN when you’re with the correct driver.")
                    .font(SpotlyFont.callout()).foregroundStyle(SpotlyColors.textSecondary)
            }
        }
        .padding(15).background(SpotlyServiceKind.ride.tint.opacity(0.07), in: RoundedRectangle(cornerRadius: 18))
    }

    private var currentQuoteIntent: RideQuoteIntent? {
        guard let pickup, let dropoff else { return nil }
        return RideQuoteIntent(pickup: pickup, dropoff: dropoff, serviceType: serviceType)
    }

    private func getQuote() async {
        // The route/type may change while a previous network quote is in flight.
        // Only the latest matching request may change displayed fare or payment options.
        quoteGeneration = UUID()
        let generation = quoteGeneration
        lastQuotedIntent = nil
        quoteResponse = nil
        errorMessage = nil
        guard let intent = currentQuoteIntent else { isQuoting = false; return }
        isQuoting = true
        defer { if quoteGeneration == generation { isQuoting = false } }
        do {
            let response = try await SpotlyRideService.shared.quote(
                pickup: intent.pickup, dropoff: intent.dropoff, serviceType: intent.serviceType)
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

    private func requestRide() async {
        guard appState.isAuthenticated else {
            appState.hasCompletedEntryFlow = false; appState.isGuestMode = false; return
        }
        guard !isRequesting, !isQuoting, !requestOutcomeUncertain, createdRideID == nil,
              let intent = currentQuoteIntent, lastQuotedIntent == intent,
              let quote = quoteResponse?.quote else {
            errorMessage = "Your route changed. Refresh your fare before requesting."
            return
        }
        isRequesting = true; errorMessage = nil
        defer { isRequesting = false }
        do {
            let response = try await SpotlyRideService.shared.request(
                pickup: intent.pickup, dropoff: intent.dropoff, serviceType: intent.serviceType,
                paymentMethod: paymentMethod, quote: quote, riderName: appState.currentUser?.name,
                riderPhone: appState.currentUser?.phone, note: note.nilIfBlank)
            // A successful POST means the ride exists; a failed detail fetch must
            // not return to the request form and allow another ride to be created.
            createdRideID = response.rideId
            await refreshCreatedRide()
        } catch {
            requestOutcomeUncertain = (error as? SpotlyAPIError)?.mayHaveCommittedWrite ?? true
            errorMessage = requestOutcomeUncertain
                ? "Couldn’t confirm the ride request. Check Activity before trying again. " + error.localizedDescription
                : error.localizedDescription
        }
    }

    private func refreshCreatedRide() async {
        guard let id = createdRideID else { return }
        createdRideError = nil
        do {
            createdRide = try await appState.activity.ride(id: id)
            await appState.activity.load(user: appState.currentUser, force: true)
        } catch {
            createdRideError = "Ride \(id) was requested, but tracking could not load. Retry or open Activity."
        }
    }

    private func pendingRide(id: String) -> some View {
        ContentUnavailableView {
            Label("Ride request received", systemImage: "car.fill")
        } description: {
            Text(createdRideError ?? "Spotly received your ride request. Loading live tracking…")
        } actions: {
            Button("Retry tracking") { Task { await refreshCreatedRide() } }
                .buttonStyle(.borderedProminent)
            Button("Open Activity") { appState.selectedTab = .activity }
        }
    }

    private func useCurrentLocation() async {
        do {
            let location = try await appState.locationService.currentLocation()
            guard let selectedCountry = appState.selectedCountryCode else { throw NSError(domain: "SpotlyCountry", code: 4, userInfo: [NSLocalizedDescriptionKey: "Choose your country before requesting a ride."]) }
            guard SpotlyCountryEngine.country(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) == selectedCountry else { throw NSError(domain: "SpotlyCountry", code: 5, userInfo: [NSLocalizedDescriptionKey: "Your current location is outside the selected Spotly country. Switch country first."]) }
            pickup = RidePoint(lat: location.coordinate.latitude, lng: location.coordinate.longitude, accuracy: location.horizontalAccuracy, country: selectedCountry, label: "Current location", formattedAddress: "Current location", area: nil, city: appState.selectedCity)
            pickupLabel = "Current location"
        } catch { errorMessage = error.localizedDescription }
    }

    private func rideTypes(_ response: RideQuoteResponse) -> [(key: String, value: RideServiceType)] {
        let preferred = ["economy", "comfort", "xl"]
        let map = response.serviceTypes ?? [:]
        if map.isEmpty { return [(response.quote.serviceType, RideServiceType(label: response.quote.serviceLabel, seats: response.quote.seats, multiplier: nil, vehicleTypes: response.quote.requiredVehicleTypes))] }
        return map.sorted { (preferred.firstIndex(of: $0.key) ?? 99) < (preferred.firstIndex(of: $1.key) ?? 99) }
    }
}
