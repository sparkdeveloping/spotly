import SwiftUI
import UIKit

struct MarketplaceCheckoutView: View {
    let item: RemoteItem
    let service: SpotlyServiceKind
    @Environment(AppState.self) private var appState
    @Environment(\.openURL) private var openURL

    @State private var detail: BusinessDetailResponse?
    @State private var selectedBranchID = ""
    @State private var quantity = 1
    @State private var contactName = ""
    @State private var contactPhone = ""
    @State private var notes = ""
    @State private var promoCode = ""
    @State private var paymentMethod = ""
    @State private var fulfilment = "pickup"
    @State private var pickupAvailability: PickupAvailabilityResponse?
    @State private var pickupDay: PickupAvailabilityDay?
    @State private var pickupSlot: PickupAvailabilitySlot?
    @State private var deliveryPoint: RidePoint?
    @State private var deliveryAddress = ""
    @State private var appointmentDate = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    @State private var appointmentTime = Date().addingTimeInterval(86400 + 3600)
    @State private var bookingStart = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    @State private var bookingEnd = Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date()
    @State private var guests = 1
    @State private var isLoading = true
    @State private var isSubmitting = false
    @State private var errorMessage: String?
    @State private var success: CheckoutSuccess?
    @State private var paymentIssue: String?
    @State private var paymentInstructions: String?
    @State private var isStartingPayment = false
    @State private var pickupLookupGeneration = UUID()
    @State private var checkoutID = "ios_" + UUID().uuidString.replacingOccurrences(of: "-", with: "_")

    var body: some View {
        Group {
            if !appState.isAuthenticated {
                SignInRequiredView(title: "Sign in to checkout")
            } else if let success {
                CheckoutSuccessView(
                    success: success, paymentIssue: paymentIssue,
                    paymentInstructions: paymentInstructions, isStartingPayment: isStartingPayment,
                    retryPayment: { Task { await startPayment(orderID: success.orderID, required: success.paymentRequired) } }
                )
            } else if isLoading {
                ProgressView("Preparing checkout…").frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let detail, !detail.transactional {
                ContentUnavailableView("Booking and ordering unavailable", systemImage: "storefront", description: Text("This is a discovery listing. The business has not enabled verified transactions on Spotly yet."))
                    .padding(18)
            } else if let detail, let reason = item.checkoutUnavailableReason(for: service) {
                ContentUnavailableView(reason, systemImage: "bag.badge.questionmark", description: Text("Availability may have changed. Return to the business to see current options."))
                    .padding(18)
            } else if let detail {
                form(detail)
            } else {
                SpotlyNetworkStateView(title: "Checkout isn’t available", message: errorMessage ?? "This offering could not be loaded.", actionTitle: "Try again") {
                    Task { await load() }
                }
                .padding(18)
            }
        }
        .background(SpotlyColors.background)
        .navigationTitle("Checkout")
        .navigationBarTitleDisplayMode(.inline)
        .task { await load() }
    }

    private func form(_ detail: BusinessDetailResponse) -> some View {
        Form {
            Section {
                HStack(spacing: 12) {
                    SpotlyRemoteImage(url: item.imageURL, cornerRadius: 12, aspectRatio: 1, fallbackIcon: service.icon, tint: service.tint)
                        .frame(width: 62, height: 62)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.displayName).font(SpotlyFont.headline())
                        Text(detail.business.displayName).font(SpotlyFont.caption()).foregroundStyle(SpotlyColors.textSecondary)
                        Text(item.price(in: currency) == 0 ? "Free" : money(item.price(in: currency), currency: currency))
                            .font(SpotlyFont.callout(.bold))
                    }
                }
            }

            if detail.branches.count > 1 {
                Section("Location") {
                    Picker("Location", selection: $selectedBranchID) {
                        ForEach(detail.branches) { branch in Text(branch.displayName).tag(branch.id) }
                    }
                    .onChange(of: selectedBranchID) { _, _ in Task { await branchChanged() } }
                }
            } else if detail.branches.isEmpty {
                Section {
                    Label("No transaction locations are available yet.", systemImage: "mappin.slash")
                        .foregroundStyle(SpotlyColors.warning)
                }
            }

            if transactionKind == .order {
                orderSections(detail)
            } else {
                transactionSections(detail)
            }

            if let errorMessage {
                Section {
                    Label(errorMessage, systemImage: "exclamationmark.triangle.fill")
                        .font(SpotlyFont.callout()).foregroundStyle(SpotlyColors.error)
                }
            }

            Section {
                Button {
                    Task { await submit(detail) }
                } label: {
                    HStack {
                        Spacer()
                        if isSubmitting { ProgressView().tint(.white) }
                        else { Text(submitTitle).font(SpotlyFont.headline(.bold)) }
                        Spacer()
                    }
                }
                .listRowBackground(service.tint)
                .foregroundStyle(.white)
                .disabled(isSubmitting || !canSubmit)
                .opacity(canSubmit ? 1 : 0.55)
            }
        }
        .scrollContentBackground(.hidden)
    }

    @ViewBuilder
    private func orderSections(_ detail: BusinessDetailResponse) -> some View {
        Section("Quantity") {
            Stepper("\(quantity)", value: $quantity, in: 1...orderQuantityLimit)
        }

        Section("How do you want it?") {
            Picker("Fulfilment", selection: $fulfilment) {
                if selectedBranch?.fulfilment?.contains("pickup") != false { Text("Pickup").tag("pickup") }
                if selectedBranch?.delivery?.enabled == true && selectedBranch?.delivery?.paused != true { Text("Delivery").tag("delivery") }
            }
            .pickerStyle(.segmented)
            .onChange(of: fulfilment) { _, value in
                configurePayments()
                if value == "pickup", pickupAvailability == nil { Task { await branchChanged() } }
            }

            if fulfilment == "pickup" {
                if let availability = pickupAvailability, availability.available, availability.defaultSelection() != nil {
                    Picker("Pickup day", selection: Binding(get: { pickupDay?.date ?? "" }, set: { value in
                        pickupDay = availability.days.first(where: { $0.date == value })
                        pickupSlot = pickupDay?.slots.first(where: { ($0.remaining ?? 1) > 0 })
                    })) {
                        ForEach(availability.days.filter { $0.slots.contains(where: { ($0.remaining ?? 1) > 0 }) }) { day in Text(day.label).tag(day.date) }
                    }
                    if let pickupDay {
                        Picker("Pickup time", selection: Binding(get: { pickupSlot?.id ?? "" }, set: { value in pickupSlot = pickupDay.slots.first(where: { $0.id == value && ($0.remaining ?? 1) > 0 }) })) {
                            ForEach(pickupDay.slots.filter { ($0.remaining ?? 1) > 0 }) { slot in Text(slot.label).tag(slot.id) }
                        }
                    }
                } else if let availability = pickupAvailability {
                    Text(availability.reason ?? "No pickup times are available.").foregroundStyle(SpotlyColors.warning)
                } else {
                    ProgressView("Checking pickup times…")
                }
            } else {
                NavigationLink {
                    AddressPickerView(country: appState.selectedCountryCode, city: appState.selectedCity, selectedPoint: $deliveryPoint, selectedLabel: $deliveryAddress)
                } label: {
                    LabeledContent("Deliver to") {
                        Text(deliveryAddress.isEmpty ? "Choose address" : deliveryAddress).lineLimit(2).foregroundStyle(deliveryAddress.isEmpty ? SpotlyColors.accent : SpotlyColors.textSecondary)
                    }
                }
            }
        }

        contactSection
        paymentSection
    }

    @ViewBuilder
    private func transactionSections(_ detail: BusinessDetailResponse) -> some View {
        switch transactionKind {
        case .ticket:
            Section("Tickets") {
                Stepper("\(quantity) ticket\(quantity == 1 ? "" : "s")", value: $quantity, in: 1...ticketLimit)
            }
        case .appointment:
            Section("Appointment") {
                DatePicker("Date", selection: $appointmentDate, in: Date().addingTimeInterval(600)..., displayedComponents: .date)
                    .environment(\.timeZone, bookingTimeZone)
                DatePicker("Preferred time", selection: $appointmentTime, displayedComponents: .hourAndMinute)
                    .environment(\.timeZone, bookingTimeZone)
                Text("Dates and times use \(appState.selectedCountry?.name ?? "the selected country") local time.")
                    .font(SpotlyFont.caption()).foregroundStyle(SpotlyColors.textSecondary)
                Text("The business will review the request. Spotly will not label it confirmed until the backend confirms it.")
                    .font(SpotlyFont.caption()).foregroundStyle(SpotlyColors.textSecondary)
            }
        case .booking:
            Section("Booking") {
                DatePicker("Start", selection: $bookingStart, in: Date()..., displayedComponents: .date)
                    .environment(\.timeZone, bookingTimeZone)
                DatePicker("End", selection: $bookingEnd, in: bookingStart..., displayedComponents: .date)
                    .environment(\.timeZone, bookingTimeZone)
                Stepper("\(guests) guest\(guests == 1 ? "" : "s")", value: $guests, in: 1...30)
                Text("Booking dates use \(appState.selectedCountry?.name ?? "the selected country") local time.")
                    .font(SpotlyFont.caption()).foregroundStyle(SpotlyColors.textSecondary)
            }
        case .order:
            EmptyView()
        }
        contactSection
        paymentSection
    }

    private var contactSection: some View {
        Section("Contact") {
            TextField("Full name", text: $contactName).textContentType(.name)
            TextField("Phone", text: $contactPhone).textContentType(.telephoneNumber).keyboardType(.phonePad)
            TextField("Notes (optional)", text: $notes, axis: .vertical).lineLimit(2...5)
        }
    }

    private var paymentSection: some View {
        Section("Payment") {
            Picker("Method", selection: $paymentMethod) {
                ForEach(paymentMethods, id: \.self) { method in Text(paymentLabel(method)).tag(method) }
            }
            TextField("Promo code (optional)", text: $promoCode)
                .textInputAutocapitalization(.characters)
                .autocorrectionDisabled()
                .onChange(of: promoCode) { _, value in
                    if value.count > 40 { promoCode = String(value.prefix(40)) }
                }
            if paymentMethod == "pay_later" {
                Text("No payment is taken now. The request remains subject to the business’s confirmation and payment terms.")
                    .font(SpotlyFont.caption()).foregroundStyle(SpotlyColors.textSecondary)
            } else if ["paynow", "ecocash", "onemoney", "card"].contains(paymentMethod) {
                Text("Spotly creates the transaction first, then securely starts Paynow. Payment success is never fabricated on this device.")
                    .font(SpotlyFont.caption()).foregroundStyle(SpotlyColors.textSecondary)
            }
        }
    }

    private func load() async {
        guard let businessID = item.businessId ?? item.business?.id else {
            isLoading = false; errorMessage = "This item is missing its business reference."; return
        }
        isLoading = true; errorMessage = nil
        defer { isLoading = false }
        do {
            let value = try await appState.marketplace.business(id: businessID)
            detail = value
            selectedBranchID = value.branches.first?.id ?? ""
            contactName = appState.currentUser?.name ?? ""
            contactPhone = appState.currentUser?.phone ?? ""
            if transactionKindFor(value.business) != .order {
                configurePayments()
            } else {
                await branchChanged()
            }
        } catch { errorMessage = error.localizedDescription }
    }

    private func branchChanged() async {
        pickupLookupGeneration = UUID()
        let request = pickupLookupGeneration
        let branchID = selectedBranchID
        pickupAvailability = nil; pickupDay = nil; pickupSlot = nil
        if transactionKind == .order, let branch = selectedBranch {
            let canPickup = branch.fulfilment?.contains("pickup") != false
            let canDeliver = branch.delivery?.enabled == true && branch.delivery?.paused != true
            if fulfilment == "pickup" && !canPickup && canDeliver { fulfilment = "delivery" }
            if fulfilment == "delivery" && !canDeliver && canPickup { fulfilment = "pickup" }
        }
        configurePayments()
        guard !branchID.isEmpty, transactionKind == .order, fulfilment == "pickup" else { return }
        do {
            let value = try await SpotlyCommerceService.shared.pickupAvailability(branchID: branchID)
            guard pickupLookupGeneration == request, selectedBranchID == branchID, !Task.isCancelled else { return }
            pickupAvailability = value
            let selection = value.defaultSelection()
            pickupDay = selection?.day
            pickupSlot = selection?.slot
        } catch {
            guard pickupLookupGeneration == request, selectedBranchID == branchID, !Task.isCancelled else { return }
            pickupAvailability = PickupAvailabilityResponse(ok: false, branchId: branchID, available: false, reason: error.localizedDescription, days: [], earliest: nil)
        }
    }

    private func configurePayments() {
        let methods: [String]
        if transactionKind == .order {
            var values = selectedBranch?.paymentMethods ?? ["paynow"]
            if fulfilment == "delivery" { values.removeAll { ["cash", "bank_transfer"].contains($0) } }
            methods = values
        } else {
            methods = item.price(in: currency) <= 0 ? ["pay_later"] : ["pay_later", "paynow"]
        }
        if !methods.contains(paymentMethod) { paymentMethod = methods.first ?? "" }
    }

    private func submit(_ detail: BusinessDetailResponse) async {
        guard !isSubmitting, success == nil, validate() else { return }
        isSubmitting = true; errorMessage = nil
        defer { isSubmitting = false }
        do {
            if transactionKind == .order {
                try await submitOrder(detail)
            } else {
                try await submitTransaction(detail)
            }
            await appState.activity.load(user: appState.currentUser, force: true)
        } catch {
            // Both create routes are idempotent for this checkoutID. A timeout
            // may mean the server committed the request before the response was lost.
            // Keep the same checkoutID on retry, never generate a new one here.
            errorMessage = "Couldn’t confirm this request. Retry to check the same checkout safely, or open Activity. " + error.localizedDescription
        }
    }

    private func submitOrder(_ detail: BusinessDetailResponse) async throws {
        guard let contractCurrency = SpotlyCurrencyCode(rawValue: currency),
              let contractPayment = SpotlyPaymentMethod(rawValue: paymentMethod) else {
            throw SpotlyAPIError.server(status: 422, message: "This checkout uses a currency or payment method not supported by this app version.")
        }
        let pickup: CommerceOrderCreateBody.Pickup?
        let delivery: CommerceOrderCreateBody.Delivery?
        if fulfilment == "pickup" {
            guard let day = pickupDay, let slot = pickupSlot else { throw SpotlyAPIError.server(status: 422, message: "Choose an available pickup time.") }
            pickup = .init(date: day.date, slot: slot.label, slotId: slot.id, contactName: contactName, contactPhone: contactPhone, alternativePhone: nil, notes: notes.nilIfBlank, substitutionPreference: "contact_me")
            delivery = nil
        } else {
            guard let point = deliveryPoint else { throw SpotlyAPIError.server(status: 422, message: "Choose a delivery address.") }
            delivery = .init(contactName: contactName, contactPhone: contactPhone, address: deliveryAddress, suburb: point.area, landmark: nil, instructions: notes.nilIfBlank, lat: point.lat, lng: point.lng, substitutionPreference: "contact_me")
            pickup = nil
        }
        let body = CommerceOrderCreateBody(
            checkoutId: checkoutID,
            businessId: detail.business.id,
            branchId: selectedBranchID,
            items: [.init(productId: item.id, quantity: quantity)],
            currency: contractCurrency,
            promoCode: promoCode.nilIfBlank,
            paymentMethod: contractPayment,
            fulfilment: fulfilment,
            delivery: delivery,
            pickup: pickup
        )
        let result = try await SpotlyCommerceService.shared.createOrder(body)
        // The order is committed independently of the external payment attempt.
        // Present its reference BEFORE initiating Paynow, preventing duplicate orders.
        success = CheckoutSuccess(orderID: result.orderId, number: result.number, total: result.total,
                                  currency: result.currency, title: "Order created", paymentRequired: result.paymentRequired)
        await startPayment(orderID: result.orderId, required: result.paymentRequired)
    }

    private func submitTransaction(_ detail: BusinessDetailResponse) async throws {
        guard let contractCurrency = SpotlyCurrencyCode(rawValue: currency),
              let contractPayment = SpotlyPaymentMethod(rawValue: paymentMethod) else {
            throw SpotlyAPIError.server(status: 422, message: "This transaction uses a currency or payment method not supported by this app version.")
        }
        let kind = transactionKind
        let appointment: CustomerTransactionCreateBody.Appointment? = kind == .appointment
            ? .init(date: isoDay(appointmentDate, timeZone: bookingTimeZone), time: isoTime(appointmentTime, timeZone: bookingTimeZone), staffPreference: nil) : nil
        let booking: CustomerTransactionCreateBody.Booking? = kind == .booking
            ? .init(startDate: isoDay(bookingStart, timeZone: bookingTimeZone), endDate: isoDay(bookingEnd, timeZone: bookingTimeZone), guests: guests) : nil
        let body = CustomerTransactionCreateBody(
            checkoutId: checkoutID,
            businessId: detail.business.id,
            branchId: selectedBranchID,
            itemId: item.id,
            quantity: kind == .ticket ? quantity : 1,
            currency: contractCurrency,
            promoCode: promoCode.nilIfBlank,
            paymentMethod: contractPayment,
            contactName: contactName,
            contactPhone: contactPhone,
            notes: notes.nilIfBlank,
            appointment: appointment,
            booking: booking
        )
        let result = try await SpotlyCommerceService.shared.createTransaction(body)
        success = CheckoutSuccess(orderID: result.orderId, number: result.number, total: result.total,
                                  currency: result.currency,
                                  title: kind == .ticket ? "Ticket request created" : kind == .appointment ? "Appointment request sent" : "Booking request sent",
                                  paymentRequired: result.paymentRequired)
        await startPayment(orderID: result.orderId, required: result.paymentRequired)
    }

    /// Payment is a separate recoverable phase. A failed Paynow initiation must
    /// never reset the already committed order or offer to create another one.
    private func startPayment(orderID: String, required: Bool) async {
        guard required, success?.orderID == orderID, !isStartingPayment else { return }
        isStartingPayment = true
        paymentIssue = nil
        paymentInstructions = nil
        defer { isStartingPayment = false }
        do {
            let channel = ["ecocash", "onemoney"].contains(paymentMethod) ? paymentMethod : "web"
            let payment = try await SpotlyCommerceService.shared.initiatePaynow(
                orderId: orderID, channel: channel, phone: contactPhone)
            if let urlString = payment.redirectUrl,
               let url = URL(string: urlString), url.scheme?.lowercased() == "https" {
                openURL(url)
                paymentInstructions = "Complete payment in the secure browser. Then return to Activity to confirm its status."
            } else if let instructions = payment.instructions?.nilIfBlank {
                paymentInstructions = instructions
            } else {
                paymentIssue = "Your request exists, but Spotly could not open payment. Try starting payment again or open Activity."
            }
        } catch {
            paymentIssue = "Your request was created, but payment could not be started: " + error.localizedDescription
        }
    }

    private func validate() -> Bool {
        if detail?.transactional != true || item.checkoutUnavailableReason(for: service) != nil {
            errorMessage = "This offering is not currently accepting transactions."; return false
        }
        if selectedBranchID.isEmpty { errorMessage = "Choose a location."; return false }
        if transactionKind == .order && quantity > orderQuantityLimit { errorMessage = "The selected quantity is no longer available."; return false }
        if transactionKind == .ticket && quantity > ticketLimit { errorMessage = "There are not enough tickets available."; return false }
        if contactName.trimmingCharacters(in: .whitespaces).count < 2 { errorMessage = "Enter your full name."; return false }
        if contactPhone.filter(\.isNumber).count < 7 { errorMessage = "Enter a valid phone number."; return false }
        if paymentMethod.isEmpty || !paymentMethods.contains(paymentMethod) { errorMessage = "Choose an available payment method."; return false }
        if transactionKind == .order {
            if fulfilment == "pickup" && selectedBranch?.fulfilment?.contains("pickup") == false {
                errorMessage = "Pickup is not offered at this location."; return false
            }
            if fulfilment == "delivery" && (selectedBranch?.delivery?.enabled != true || selectedBranch?.delivery?.paused == true) {
                errorMessage = "Delivery is not offered at this location."; return false
            }
        }
        if transactionKind == .order && fulfilment == "pickup" {
            guard let day = pickupDay, let slot = pickupSlot,
                  pickupAvailability?.days.first(where: { $0.date == day.date })?.slots.contains(where: { $0.id == slot.id && ($0.remaining ?? 1) > 0 }) == true else {
                errorMessage = "Choose an available pickup day and time."; return false
            }
        }
        if transactionKind == .order && fulfilment == "delivery" && deliveryPoint == nil { errorMessage = "Choose a delivery address."; return false }
        return true
    }

    private var selectedBranch: RemoteBranch? { detail?.branches.first(where: { $0.id == selectedBranchID }) }
    private var orderQuantityLimit: Int {
        let stock = item.stockQuantity.map { Int(max(0, min($0, Double(Int32.max)))) } ?? 20
        return max(1, min(item.maxQuantity ?? 20, stock, 20))
    }
    private var currency: String { item.currencyFor(appState.selectedCountry?.currencyPriority.first?.rawValue ?? "USD") }
    private var bookingTimeZone: TimeZone { TimeZone(identifier: appState.selectedCountry?.timeZone ?? "UTC") ?? .current }
    private var transactionKind: CheckoutKind { detail.map { transactionKindFor($0.business) } ?? (service == .events ? .ticket : service == .book ? .appointment : .order) }
    private var ticketLimit: Int { max(1, min(item.maxQuantity ?? item.remainingCapacity ?? 10, item.remainingCapacity ?? 10, 20)) }
    private var paymentMethods: [String] {
        if transactionKind == .order {
            var values = selectedBranch?.paymentMethods ?? ["paynow"]
            if fulfilment == "delivery" { values.removeAll { ["cash", "bank_transfer"].contains($0) } }
            return values
        }
        return item.price(in: currency) <= 0 ? ["pay_later"] : ["pay_later", "paynow"]
    }
    private var canSubmit: Bool {
        item.checkoutUnavailableReason(for: service) == nil && detail?.transactional == true && !selectedBranchID.isEmpty &&
        contactName.trimmingCharacters(in: .whitespacesAndNewlines).count >= 2 &&
        contactPhone.filter(\.isNumber).count >= 7 && !paymentMethod.isEmpty &&
        (transactionKind != .order || (fulfilment == "delivery" ? deliveryPoint != nil : pickupDay != nil && pickupSlot != nil))
    }
    private var submitTitle: String { isSubmitting ? "Working…" : transactionKind == .order ? "Place order" : transactionKind == .ticket ? "Create ticket request" : "Send request" }

    private func transactionKindFor(_ business: RemoteBusiness) -> CheckoutKind {
        let type = business.businessType?.lowercased() ?? ""
        if type == "ticketing_events" || service == .events { return .ticket }
        if type == "accommodation_activities" { return .booking }
        if type == "appointments_services" || service == .book { return .appointment }
        return .order
    }

    private func paymentLabel(_ method: String) -> String {
        switch method {
        case "paynow": return "Paynow"
        case "ecocash": return "EcoCash"
        case "onemoney": return "OneMoney"
        case "card": return "Card"
        case "cash": return "Cash"
        case "bank_transfer": return "Bank transfer"
        case "pay_later": return "Pay later"
        default: return method.replacingOccurrences(of: "_", with: " ").capitalized
        }
    }
}

private enum CheckoutKind { case order, appointment, booking, ticket }
private struct CheckoutSuccess: Hashable {
    let orderID: String
    let number: String
    let total: Double
    let currency: String
    let title: String
    let paymentRequired: Bool
}

private struct CheckoutSuccessView: View {
    let success: CheckoutSuccess
    let paymentIssue: String?
    let paymentInstructions: String?
    let isStartingPayment: Bool
    let retryPayment: () -> Void
    @Environment(AppState.self) private var appState

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 52)).foregroundStyle(SpotlyColors.success)
                    .accessibilityHidden(true)
                Text(success.title).font(SpotlyFont.title2(.bold))
                Text("Reference \(success.number)")
                    .font(SpotlyFont.headline()).textSelection(.enabled)
                Text(money(success.total, currency: success.currency))
                    .font(SpotlyFont.title(.bold))
                if success.paymentRequired {
                    Label("Payment pending", systemImage: "creditcard.fill")
                        .font(SpotlyFont.headline(.semibold))
                        .foregroundStyle(SpotlyColors.warning)
                    Text(paymentIssue ?? paymentInstructions ?? "Your request is recorded. Complete payment to proceed; payment is not confirmed yet.")
                        .font(SpotlyFont.callout()).multilineTextAlignment(.center)
                        .foregroundStyle(paymentIssue == nil ? SpotlyColors.textSecondary : SpotlyColors.error)
                    if paymentIssue != nil {
                        Button {
                            retryPayment()
                        } label: {
                            if isStartingPayment { ProgressView() }
                            else { Label("Try starting payment again", systemImage: "arrow.clockwise") }
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(isStartingPayment)
                    }
                } else {
                    Text("Your request is recorded. See Activity for the authoritative status.")
                        .font(SpotlyFont.callout()).multilineTextAlignment(.center)
                        .foregroundStyle(SpotlyColors.textSecondary)
                }
                Button("Open Activity") { appState.selectedTab = .activity }
                    .buttonStyle(.borderedProminent).tint(SpotlyColors.accent)
                Text("Avoid placing the same request again. Payment and fulfilment updates appear in Activity.")
                    .font(SpotlyFont.caption()).foregroundStyle(SpotlyColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(24)
        }
    }
}

struct AddressPickerView: View {
    let country: SpotlyCountryCode?
    let city: String
    @Binding var selectedPoint: RidePoint?
    @Binding var selectedLabel: String
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    @State private var query = ""
    @State private var results: [GeocodeResult] = []
    @State private var isSearching = false
    @State private var isLocating = false
    @State private var searchError: String?
    @State private var locationMessage: String?
    @State private var searchTask: Task<Void, Never>?

    var body: some View {
        List {
            Section {
                Button {
                    Task { await currentLocation() }
                } label: {
                    HStack(spacing: 12) {
                        Label("Use my current location", systemImage: "location.fill")
                        Spacer()
                        if isLocating { ProgressView() }
                    }
                }
                .disabled(isLocating)

                if let locationMessage {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Current location unavailable", systemImage: "location.slash")
                            .font(SpotlyFont.subheadline(.semibold))
                            .foregroundStyle(SpotlyColors.textPrimary)
                        Text(locationMessage)
                            .font(SpotlyFont.caption())
                            .foregroundStyle(SpotlyColors.textSecondary)
                        if appState.locationService.permissionState == .denied || appState.locationService.permissionState == .restricted {
                            Button("Open Settings") { openSettings() }
                                .font(SpotlyFont.caption(.semibold))
                        }
                    }
                    .padding(.vertical, 4)
                }
            }

            if !cleanQuery.isEmpty {
                Section("Results") {
                    if isSearching {
                        ProgressView("Searching \(city)…")
                    } else if let searchError {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(searchError).foregroundStyle(SpotlyColors.textSecondary)
                            Button("Try again") { scheduleSearch(query, immediate: true) }
                        }
                    } else if results.isEmpty && cleanQuery.count >= 3 {
                        ContentUnavailableView("No matches", systemImage: "mappin.slash", description: Text("Try a landmark, suburb or street in \(city)."))
                    } else {
                        ForEach(results) { result in
                            Button {
                                selectedPoint = result.point
                                selectedLabel = result.label
                                dismiss()
                            } label: {
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(result.label).foregroundStyle(SpotlyColors.textPrimary)
                                    let detail = AddressFormatter.joined([result.area, result.city])
                                    if !detail.isEmpty {
                                        Text(detail).font(SpotlyFont.caption()).foregroundStyle(SpotlyColors.textSecondary)
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                Section {
                    ContentUnavailableView("Search for a place", systemImage: "magnifyingglass", description: Text("Enter an address, suburb, landmark or business in \(city)."))
                }
            }
        }
        .navigationTitle("Choose address")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $query, prompt: "Search in \(city)")
        .onChange(of: query) { _, value in scheduleSearch(value) }
        .onSubmit(of: .search) { scheduleSearch(query, immediate: true) }
        .onDisappear { searchTask?.cancel() }
        .toolbar(.hidden, for: .tabBar)
    }

    private var cleanQuery: String { query.trimmingCharacters(in: .whitespacesAndNewlines) }

    private func scheduleSearch(_ value: String, immediate: Bool = false) {
        searchTask?.cancel()
        searchError = nil
        let clean = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard clean.count >= 3 else {
            results = []
            isSearching = false
            return
        }
        isSearching = true
        searchTask = Task {
            do {
                if !immediate { try await Task.sleep(for: .milliseconds(300)) }
                guard let country else { throw NSError(domain: "SpotlyCountry", code: 3, userInfo: [NSLocalizedDescriptionKey: "Choose your country before searching for an address."]) }
                let matches = try await appState.marketplace.geocode(clean, city: city, country: country)
                try Task.checkCancellation()
                guard clean == cleanQuery else { return }
                results = matches
                isSearching = false
            } catch is CancellationError {
                return
            } catch {
                guard !Task.isCancelled, clean == cleanQuery else { return }
                searchError = "Spotly couldn’t search that location. Try again."
                isSearching = false
            }
        }
    }

    private func currentLocation() async {
        isLocating = true
        locationMessage = nil
        defer { isLocating = false }
        do {
            let snapshot = try await appState.locationService.currentLocation()
            guard let selectedCountry = country else {
                locationMessage = "Choose your country before using current location."; return
            }
            guard let detectedCountry = SpotlyCountryEngine.country(latitude: snapshot.coordinate.latitude, longitude: snapshot.coordinate.longitude), detectedCountry == selectedCountry else {
                let detectedName = SpotlyCountryEngine.country(latitude: snapshot.coordinate.latitude, longitude: snapshot.coordinate.longitude).flatMap { SpotlyCountryEngine.definition(for: $0)?.name }
                locationMessage = detectedName.map { "Your current location is in \($0). Switch Spotly country before using this address." } ?? "This location is outside the selected Spotly country."
                return
            }
            let point = RidePoint(
                lat: snapshot.coordinate.latitude,
                lng: snapshot.coordinate.longitude,
                accuracy: snapshot.horizontalAccuracy,
                country: selectedCountry,
                label: "Current location",
                formattedAddress: "Current location",
                area: nil,
                city: city
            )
            selectedPoint = point
            selectedLabel = "Current location"
            dismiss()
        } catch {
            switch appState.locationService.permissionState {
            case .denied, .restricted:
                locationMessage = "Location access is off. Search for your pickup instead, or enable Location in Settings."
            default:
                locationMessage = "Search for your pickup instead. You can continue without using device location."
            }
        }
    }

    private func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        openURL(url)
    }
}

private func isoDay(_ date: Date, timeZone: TimeZone) -> String {
    let f = DateFormatter(); f.locale = Locale(identifier: "en_US_POSIX"); f.calendar = Calendar(identifier: .gregorian); f.timeZone = timeZone; f.dateFormat = "yyyy-MM-dd"; return f.string(from: date)
}
private func isoTime(_ date: Date, timeZone: TimeZone) -> String {
    let f = DateFormatter(); f.locale = Locale(identifier: "en_US_POSIX"); f.timeZone = timeZone; f.dateFormat = "HH:mm"; return f.string(from: date)
}
extension String {
    nonisolated var nilIfBlank: String? { let value = trimmingCharacters(in: .whitespacesAndNewlines); return value.isEmpty ? nil : value }
}
