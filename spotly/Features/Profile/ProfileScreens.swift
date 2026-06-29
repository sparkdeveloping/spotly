import SwiftUI

// MARK: - My Orders

struct MyOrdersView: View {
    @Environment(AppState.self) private var appState
    @State private var selectedOrder: SpotlyOrder?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SpotlySpacing.md) {
                Text("Food and grocery orders")
                    .font(SpotlyFont.title3(.bold))
                    .foregroundStyle(SpotlyColors.textPrimary)

                if appState.orders.isEmpty {
                    SpotlyEmptyState(
                        icon: "bag",
                        title: "No orders yet",
                        subtitle: "Order food or groceries from Spotly vendors and your demo orders will appear here.",
                        actionTitle: "Browse Spotly",
                        action: { appState.selectedTab = .home }
                    )
                } else {
                    ForEach(appState.orders) { order in
                        orderCard(order)
                            .contentShape(Rectangle())
                            .onTapGesture { selectedOrder = order }
                    }
                }

                Button {
                    appState.selectedTab = .home
                } label: {
                    Label("Order again", systemImage: "bag.fill")
                        .font(SpotlyFont.callout(.semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(SpotlyColors.accent)
                        .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.sm))
                }
                .buttonStyle(.plain)
            }
            .padding(SpotlySpacing.screenPadding)
        }
        .background(SpotlyColors.background)
        .navigationTitle("My Orders")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $selectedOrder) { order in
            OrderTrackingPreviewSheet(order: order)
        }
    }

    private func orderCard(_ order: SpotlyOrder) -> some View {
        VStack(alignment: .leading, spacing: SpotlySpacing.sm) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(order.businessName).font(SpotlyFont.headline(.semibold))
                    Text(order.itemsSummary).font(SpotlyFont.caption()).foregroundStyle(SpotlyColors.textSecondary)
                }
                Spacer()
                Text(order.totalText).font(SpotlyFont.callout(.bold)).foregroundStyle(SpotlyColors.accent)
            }
            HStack {
                Label(order.status, systemImage: "clock.fill")
                    .font(SpotlyFont.caption(.semibold))
                    .foregroundStyle(SpotlyColors.textSecondary)
                Spacer()
                Button("Track") { selectedOrder = order }
                    .font(SpotlyFont.caption(.semibold))
                    .foregroundStyle(SpotlyColors.accent)
            }
        }
        .padding(SpotlySpacing.md)
        .background(SpotlyColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.md))
        .overlay { RoundedRectangle(cornerRadius: SpotlyRadius.md).stroke(SpotlyColors.border, lineWidth: 0.5) }
    }
}

private struct OrderTrackingPreviewSheet: View {
    @Environment(\.dismiss) private var dismiss
    let order: SpotlyOrder
    private let steps = ["Order received", "Preparing", "Ready for pickup or delivery", "Completed"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: SpotlySpacing.lg) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(order.businessName)
                            .font(SpotlyFont.title3(.bold))
                        Text(order.itemsSummary)
                            .font(SpotlyFont.callout())
                            .foregroundStyle(SpotlyColors.textSecondary)
                    }

                    ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                        HStack(spacing: SpotlySpacing.sm) {
                            Image(systemName: index < completedStepCount ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(index < completedStepCount ? SpotlyColors.accent : SpotlyColors.textTertiary)
                            Text(step).font(SpotlyFont.callout(index < completedStepCount ? .semibold : .regular))
                            Spacer()
                        }
                    }

                    ZStack {
                        SpotlyColors.backgroundElevated
                        VStack(spacing: SpotlySpacing.xs) {
                            Image(systemName: "map")
                                .font(.system(size: 36, weight: .light))
                                .foregroundStyle(SpotlyColors.accent)
                            Text("Tracking preview")
                                .font(SpotlyFont.callout(.semibold))
                            Text("Real courier maps and store contact tools connect with launch partners.")
                                .font(SpotlyFont.caption())
                                .foregroundStyle(SpotlyColors.textSecondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                    }
                    .frame(height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.md))
                }
                .padding(SpotlySpacing.screenPadding)
            }
            .navigationTitle("Order tracking")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .confirmationAction) { Button("Done") { dismiss() } } }
        }
        .presentationDetents([.medium, .large])
    }

    private var completedStepCount: Int {
        let status = order.status.lowercased()
        if status.contains("completed") || status.contains("delivered") {
            return 4
        }
        if status.contains("out") || status.contains("ready") {
            return 3
        }
        if status.contains("preparing") {
            return 2
        }
        return 1
    }
}

// MARK: - My Bookings

struct MyBookingsView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        List {
            if appState.bookings.isEmpty {
                Section {
                    VStack(alignment: .leading, spacing: SpotlySpacing.xs) {
                        Text("No bookings yet")
                            .font(SpotlyFont.headline(.semibold))
                        Text("Restaurant reservations, spa treatments, activities, and tickets will appear here after confirmation.")
                            .font(SpotlyFont.caption())
                            .foregroundStyle(SpotlyColors.textSecondary)
                    }
                    .padding(.vertical, SpotlySpacing.xs)
                }
            } else {
                Section("All bookings") {
                    ForEach(appState.bookings) { booking in
                        NavigationLink(value: AppRoute.bookingDetail(booking.id)) {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(booking.businessName)
                                        .font(SpotlyFont.callout(.semibold))
                                    Spacer()
                                    Text(booking.status.displayText)
                                        .font(SpotlyFont.micro(.semibold))
                                        .foregroundStyle(booking.status.isActive ? SpotlyColors.accent : SpotlyColors.textSecondary)
                                }
                                Text(booking.serviceName)
                                    .font(SpotlyFont.caption())
                                    .foregroundStyle(SpotlyColors.textSecondary)
                                Text(booking.formattedDate + " · " + booking.time)
                                    .font(SpotlyFont.micro(.semibold))
                                    .foregroundStyle(SpotlyColors.textTertiary)
                            }
                            .frame(minHeight: 56, alignment: .leading)
                            .contentShape(Rectangle())
                        }
                    }
                }
            }
        }
        .navigationTitle("My Bookings")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }
}

// MARK: - My Reviews

struct MyReviewsView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        List {
            if appState.userReviews.isEmpty {
                Section {
                    VStack(alignment: .leading, spacing: SpotlySpacing.xs) {
                        Text("No reviews yet")
                            .font(SpotlyFont.headline(.semibold))
                        Text("Write a review from any place detail screen. Demo reviews stay local and update this count immediately.")
                            .font(SpotlyFont.caption())
                            .foregroundStyle(SpotlyColors.textSecondary)
                    }
                    .padding(.vertical, SpotlySpacing.xs)
                }
                Section("Review prompts") {
                    Text("Namaste Harare · Ready for review")
                    Text("Vertex Wellness Spa · Visit upcoming")
                    Text("Court Zero Padel · Review after your session")
                }
            } else {
                Section("Submitted reviews") {
                    ForEach(appState.userReviews) { review in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(review.placeName).font(SpotlyFont.callout(.semibold))
                                Spacer()
                                Label("\(review.rating)", systemImage: "star.fill")
                                    .font(SpotlyFont.caption(.semibold))
                                    .foregroundStyle(SpotlyColors.ratingGold)
                            }
                            Text(review.comment)
                                .font(SpotlyFont.caption())
                                .foregroundStyle(SpotlyColors.textSecondary)
                            Text(review.createdAt.formatted(date: .abbreviated, time: .omitted))
                                .font(SpotlyFont.micro())
                                .foregroundStyle(SpotlyColors.textTertiary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle("My Reviews")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Addresses

struct AddressesView: View {
    @Environment(AppState.self) private var appState
    @State private var showAddAddress = false
    @State private var editingAddress: SpotlyAddress?
    @State private var pendingDelete: SpotlyAddress?

    var body: some View {
        List {
            Section("Saved") {
                if appState.addresses.isEmpty {
                    Text("Add a delivery address for checkout demos.")
                        .foregroundStyle(SpotlyColors.textSecondary)
                } else {
                    ForEach(appState.addresses) { address in
                        Button { editingAddress = address } label: {
                            HStack(spacing: SpotlySpacing.sm) {
                                Image(systemName: address.isDefault ? "checkmark.circle.fill" : "mappin.circle")
                                    .foregroundStyle(address.isDefault ? SpotlyColors.accent : SpotlyColors.textTertiary)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(address.label).font(SpotlyFont.callout(.semibold))
                                    Text(address.line + " · " + address.city)
                                        .font(SpotlyFont.caption())
                                        .foregroundStyle(SpotlyColors.textSecondary)
                                }
                                Spacer()
                                Menu {
                                    Button("Edit") { editingAddress = address }
                                    Button("Set as default") { appState.setDefaultAddress(address.id) }
                                    Button("Delete", role: .destructive) { pendingDelete = address }
                                } label: {
                                    Image(systemName: "ellipsis.circle")
                                        .foregroundStyle(SpotlyColors.textSecondary)
                                        .frame(width: 44, height: 44)
                                }
                            }
                            .frame(minHeight: 56)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            Section { Button("Add address") { showAddAddress = true } }
            Section { Text("Map validation and saved delivery instructions will be connected before launch.") }
        }
        .navigationTitle("Addresses")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .sheet(isPresented: $showAddAddress) { AddAddressSheet() }
        .sheet(item: $editingAddress) { address in AddAddressSheet(existingAddress: address) }
        .confirmationDialog("Delete address?", isPresented: Binding(get: { pendingDelete != nil }, set: { if !$0 { pendingDelete = nil } }), titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                if let pendingDelete { appState.deleteAddress(pendingDelete.id) }
                pendingDelete = nil
            }
            Button("Cancel", role: .cancel) { pendingDelete = nil }
        }
    }
}

private struct AddAddressSheet: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    var existingAddress: SpotlyAddress? = nil
    @State private var label = ""
    @State private var area = ""
    @State private var street = ""
    @State private var deliveryInstructions = ""
    @State private var city = "Harare"
    @State private var makeDefault = false
    private let cities = ["Harare", "Bulawayo", "Victoria Falls", "Mutare", "Gweru"]

    var body: some View {
        NavigationStack {
            Form {
                Section("Address") {
                    TextField("Home, Work, etc.", text: $label)
                    TextField("Area / suburb", text: $area)
                    TextField("Street / address", text: $street)
                    Picker("City", selection: $city) {
                        ForEach(cities, id: \.self) { Text($0) }
                    }
                    TextField("Delivery instructions", text: $deliveryInstructions, axis: .vertical)
                        .lineLimit(2...4)
                    Toggle("Set as default", isOn: $makeDefault).tint(SpotlyColors.accent)
                }
                Section { Text("Full maps validation will be connected before launch.") }
            }
            .onAppear(perform: populate)
            .navigationTitle(existingAddress == nil ? "Add address" : "Edit address")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let line = [area, street, deliveryInstructions].filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }.joined(separator: " · ")
                        let cleanLabel = label.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Address" : label
                        let cleanLine = line.isEmpty ? "Address pending" : line
                        if var existingAddress {
                            existingAddress.label = cleanLabel
                            existingAddress.line = cleanLine
                            existingAddress.city = city
                            existingAddress.isDefault = makeDefault
                            appState.updateAddress(existingAddress)
                        } else {
                            appState.addAddress(label: cleanLabel, line: cleanLine, city: city, makeDefault: makeDefault)
                        }
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }

    private func populate() {
        guard let existingAddress else { return }
        label = existingAddress.label
        city = existingAddress.city
        makeDefault = existingAddress.isDefault
        let parts = existingAddress.line.components(separatedBy: " · ")
        area = parts.first ?? ""
        street = parts.dropFirst().first ?? ""
        deliveryInstructions = parts.dropFirst(2).joined(separator: " · ")
    }
}

// MARK: - Edit Profile

struct EditProfileSheet: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var phone = ""
    @State private var city = "Harare"
    @State private var interests = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Profile") {
                    TextField("Full name", text: $name)
                    TextField("Phone", text: $phone)
                        .keyboardType(.phonePad)
                    Picker("City", selection: $city) {
                        ForEach(["Harare", "Bulawayo", "Victoria Falls", "Mutare", "Gweru"], id: \.self) { Text($0) }
                    }
                }
                Section("Interests") {
                    TextField("Food, events, wellness", text: $interests)
                }
                Section { Text("This is a local prototype edit. Customer account sync will be connected before launch.") }
            }
            .onAppear {
                name = appState.displayFullName.isEmpty ? appState.displayName : appState.displayFullName
                phone = appState.currentUser?.phone ?? ""
                city = appState.selectedCity
                interests = appState.selectedInterests.joined(separator: ", ")
            }
            .navigationTitle("Edit profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        appState.completeProfile(name: name, phone: phone, city: city)
                        appState.selectedInterests = interests.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

// MARK: - Notifications

struct NotificationsView: View {
    @Environment(AppState.self) private var appState
    @State private var feedback: NotificationFeedback?

    private let notifications: [(icon: String, title: String, message: String, time: String, feedback: NotificationFeedback)] = [
        ("checkmark.seal.fill", "Booking confirmed", "Vertex Wellness Spa confirmed your Swedish massage for Tuesday at 2:00 PM.", "Now", .bookings),
        ("ticket.fill", "Event reminder", "Jazz at The Harare Club starts in 3 days. Your ticket reservation is ready.", "2h", .event),
        ("tag.fill", "Offer available", "Launch offer: 10% off selected wellness bookings this week.", "Today", .offers),
        ("bag.fill", "Order update", "Your Spar Avondale grocery basket is being prepared in the demo flow.", "Yesterday", .orders),
        ("storefront.fill", "Partner response", "Spotly launch team will follow up on business enquiries from this build.", "Fri", .business)
    ]

    var body: some View {
        List {
            Section("Updates") {
                ForEach(notifications, id: \.title) { item in
                    Button { handle(item.feedback) } label: {
                        notificationRow(item)
                    }
                    .buttonStyle(.plain)
                }
            }
            Section("Preferences") {
                Text("Notification toggles are available from Profile > Account > Notifications and remain local to this prototype.")
                    .font(SpotlyFont.caption())
                    .foregroundStyle(SpotlyColors.textSecondary)
            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $feedback) { item in
            SpotlyFeedbackSheet(icon: item.icon, title: item.title, message: item.message)
        }
    }

    private func notificationRow(_ item: (icon: String, title: String, message: String, time: String, feedback: NotificationFeedback)) -> some View {
        HStack(alignment: .top, spacing: SpotlySpacing.sm) {
            Image(systemName: item.icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(SpotlyColors.accent)
                .frame(width: 32, height: 32)
                .background(SpotlyColors.accentBg)
                .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.xs))
            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text(item.title).font(SpotlyFont.callout(.semibold))
                    Spacer()
                    Text(item.time).font(SpotlyFont.micro()).foregroundStyle(SpotlyColors.textTertiary)
                }
                Text(item.message)
                    .font(SpotlyFont.caption())
                    .foregroundStyle(SpotlyColors.textSecondary)
            }
        }
        .padding(.vertical, 4)
    }

    private func handle(_ item: NotificationFeedback) {
        switch item {
        case .bookings:
            appState.selectedTab = .bookings
        case .orders:
            feedback = item
        case .offers:
            feedback = item
        case .event:
            appState.selectedTab = .home
        case .business:
            feedback = item
        }
    }
}

private enum NotificationFeedback: String, Identifiable {
    case bookings, orders, offers, event, business
    var id: String { rawValue }
    var icon: String {
        switch self {
        case .bookings: return "calendar.badge.checkmark"
        case .orders: return "bag.fill"
        case .offers: return "tag.fill"
        case .event: return "ticket.fill"
        case .business: return "storefront.fill"
        }
    }
    var title: String {
        switch self {
        case .bookings: return "Booking opened"
        case .orders: return "Order tracking"
        case .offers: return "Launch offer"
        case .event: return "Event reminder"
        case .business: return "Partner response"
        }
    }
    var message: String {
        switch self {
        case .bookings: return "Bookings are available from the Bookings tab with local confirmation records."
        case .orders: return "Open Profile > My Orders to view food and grocery order tracking."
        case .offers: return "Offer redemption will be enabled with verified launch partners."
        case .event: return "Event ticketing will be enabled with verified event partners at launch."
        case .business: return "Business enquiry follow-up is saved for the Spotly launch team."
        }
    }
}

// MARK: - Account and Support Screens

struct PaymentMethodsView: View {
    var body: some View {
        List {
            Section("Available for demo") {
                Label("Cash / Pay at venue", systemImage: "banknote")
            }
            Section("Coming soon") {
                paymentRow("Paynow", icon: "p.circle.fill")
                paymentRow("EcoCash", icon: "e.circle.fill")
                paymentRow("OneMoney", icon: "1.circle.fill")
                paymentRow("Visa / Mastercard", icon: "creditcard")
            }
            Section { Text("Online payments will be enabled for verified launch partners. Cash and pay-at-venue options are available for demo orders.") }
        }
        .navigationTitle("Payment methods")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func paymentRow(_ title: String, icon: String) -> some View {
        Label(title + " · Coming soon", systemImage: icon)
            .foregroundStyle(SpotlyColors.textSecondary)
    }
}

struct PromotionsView: View {
    @Environment(AppState.self) private var appState
    private let offers = [
        ("Wellness launch offer", "10% off first spa booking", "Vertex Wellness Spa", "Book treatment"),
        ("Grocery delivery intro", "Free delivery preview on demo baskets", "Spar Avondale", "Shop groceries"),
        ("Early bird events", "Priority ticket holds for launch events", "Jazz at The Harare Club", "View events"),
        ("Restaurant tables", "Reserve demo tables at top Harare restaurants", "Namaste Harare", "Find food")
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SpotlySpacing.md) {
                ForEach(offers, id: \.0) { offer in
                    VStack(alignment: .leading, spacing: SpotlySpacing.xs) {
                        Text(offer.0).font(SpotlyFont.headline(.semibold))
                        Text(offer.1).font(SpotlyFont.callout()).foregroundStyle(SpotlyColors.textSecondary)
                        Text(offer.2).font(SpotlyFont.caption(.semibold)).foregroundStyle(SpotlyColors.accent)
                        Button(offer.3) { appState.selectedTab = .home }
                            .font(SpotlyFont.caption(.semibold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, SpotlySpacing.sm)
                            .padding(.vertical, SpotlySpacing.xxs)
                            .background(SpotlyColors.accent)
                            .clipShape(Capsule())
                    }
                    .padding(SpotlySpacing.md)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(SpotlyColors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.md))
                    .overlay { RoundedRectangle(cornerRadius: SpotlyRadius.md).stroke(SpotlyColors.border, lineWidth: 0.5) }
                }
            }
            .padding(SpotlySpacing.screenPadding)
        }
        .background(SpotlyColors.background)
        .navigationTitle("Promotions & Offers")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct NotificationsSettingsView: View {
    @State private var bookingReminders = true
    @State private var promotions = false
    @State private var newPlaces = true
    @State private var eventAlerts = true

    var body: some View {
        Form {
            Section("Booking") {
                Toggle("Booking reminders", isOn: $bookingReminders).tint(SpotlyColors.accent)
                Toggle("Event alerts", isOn: $eventAlerts).tint(SpotlyColors.accent)
            }
            Section("Discovery") {
                Toggle("New places near you", isOn: $newPlaces).tint(SpotlyColors.accent)
                Toggle("Deals & promotions", isOn: $promotions).tint(SpotlyColors.accent)
            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PreferencesView: View {
    @Environment(AppState.self) private var appState
    private let options = ["Restaurants", "Groceries", "Events", "Wellness", "Beauty", "Pharmacy", "Activities", "Staycations"]

    var body: some View {
        List {
            Section("Interests") {
                ForEach(options, id: \.self) { option in
                    Button {
                        if appState.selectedInterests.contains(option) {
                            appState.selectedInterests.removeAll { $0 == option }
                        } else {
                            appState.selectedInterests.append(option)
                        }
                    } label: {
                        HStack {
                            Text(option).foregroundStyle(SpotlyColors.textPrimary)
                            Spacer()
                            if appState.selectedInterests.contains(option) {
                                Image(systemName: "checkmark").foregroundStyle(SpotlyColors.accent)
                            }
                        }
                    }
                }
            }
            Section { Text("Preferences personalize discovery for restaurants, groceries, events, wellness, and more.") }
        }
        .navigationTitle("Preferences")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct HelpSupportView: View {
    private let faqs = [
        ("How do I cancel a booking?", "Open Bookings, choose the booking, then use the available actions."),
        ("When will payments be live?", "Paynow and EcoCash will be enabled with verified launch partners."),
        ("How do I contact Spotly?", "Email support@spotly.co.zw for customer support."),
        ("Can I buy prescription items?", "Prescription items require in-store verification.")
    ]

    var body: some View {
        List {
            Section("Contact") { Text("support@spotly.co.zw") }
            Section("FAQ") {
                ForEach(faqs, id: \.0) { item in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.0).font(SpotlyFont.callout(.semibold))
                        Text(item.1).font(SpotlyFont.caption()).foregroundStyle(SpotlyColors.textSecondary)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("Help & Support")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct InviteFriendsView: View {
    @State private var copied = false

    var body: some View {
        VStack(spacing: SpotlySpacing.xl) {
            SpotlyLogoMark(size: 80)
            Text("SPOTLY2026")
                .font(.system(size: 28, weight: .bold, design: .monospaced))
                .foregroundStyle(SpotlyColors.accent)
            Button(copied ? "Copied" : "Copy invite code") {
                UIPasteboard.general.string = "SPOTLY2026"
                copied = true
            }
            .buttonStyle(.borderedProminent)
            .tint(SpotlyColors.accent)
        }
        .padding(SpotlySpacing.screenPadding)
        .navigationTitle("Invite friends")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            Text("Spotly collects only the information needed to support discovery, bookings, orders, and launch partner demos. We do not sell personal data. A full privacy policy will be published before public launch in 2026.")
                .font(SpotlyFont.callout())
                .foregroundStyle(SpotlyColors.textSecondary)
                .lineSpacing(4)
                .padding(SpotlySpacing.screenPadding)
        }
        .background(SpotlyColors.background)
        .navigationTitle("Privacy")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TermsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SpotlySpacing.md) {
                Text("Spotly demo terms")
                    .font(SpotlyFont.title3(.bold))
                Text("This build is a customer marketplace demo for launch partner previews. Bookings, orders, tickets, addresses, reviews, and business enquiries are demo records only. Real payments, healthcare workflows, delivery integrations, and partner operations will be governed by launch terms in 2026.")
                    .font(SpotlyFont.callout())
                    .foregroundStyle(SpotlyColors.textSecondary)
                    .lineSpacing(4)
            }
            .padding(SpotlySpacing.screenPadding)
        }
        .background(SpotlyColors.background)
        .navigationTitle("Terms")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AboutSpotlyView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: SpotlySpacing.xl) {
                SpotlyLogoMark(size: 80)
                Text("Spotly")
                    .font(SpotlyFont.title2(.bold))
                Text("Zimbabwe's customer marketplace for food, groceries, healthcare, beauty, wellness, activities, staycations, and events. Planned launch: 2026.")
                    .font(SpotlyFont.callout())
                    .foregroundStyle(SpotlyColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                VStack(spacing: 0) {
                    aboutRow("Website", value: "spotly.co.zw")
                    Divider()
                    aboutRow("Email", value: "hello@spotly.co.zw")
                    Divider()
                    NavigationLink(value: AppRoute.businessInterest) {
                        HStack { Text("List your business"); Spacer(); Image(systemName: "chevron.right") }
                            .font(SpotlyFont.callout(.semibold))
                            .foregroundStyle(SpotlyColors.accent)
                            .padding(.vertical, SpotlySpacing.xs)
                    }
                }
                .padding(SpotlySpacing.md)
                .background(SpotlyColors.surface)
                .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.md))
            }
            .padding(SpotlySpacing.screenPadding)
        }
        .background(SpotlyColors.background)
        .navigationTitle("About Spotly")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func aboutRow(_ label: String, value: String) -> some View {
        HStack { Text(label); Spacer(); Text(value).foregroundStyle(SpotlyColors.accent) }
            .font(SpotlyFont.callout(.semibold))
            .padding(.vertical, SpotlySpacing.xs)
    }
}

// MARK: - Business Interest

struct BusinessInterestScreen: View {
    @Environment(AppState.self) private var appState
    @State private var businessName = ""
    @State private var category = "Restaurants"
    @State private var city = "Harare"
    @State private var contactName = ""
    @State private var contact = ""
    @State private var notes = ""
    @State private var submitted = false
    var initialBusinessName: String? = nil
    var initialCategory: String? = nil
    var initialCity: String? = nil
    private let categories = ["Restaurants", "Groceries", "Events", "Wellness & Spa", "Beauty", "Pharmacy", "Activities", "Staycations", "Flowers & Gifts"]
    private let cities = ["Harare", "Bulawayo", "Victoria Falls", "Mutare", "Gweru"]

    var body: some View {
        Form {
            if submitted {
                Section {
                    VStack(alignment: .leading, spacing: SpotlySpacing.sm) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 36, weight: .semibold))
                            .foregroundStyle(SpotlyColors.accent)
                        Text("Enquiry received")
                            .font(SpotlyFont.title3(.bold))
                        Text("The Spotly launch team will contact you about partner onboarding for 2026.")
                            .font(SpotlyFont.callout())
                            .foregroundStyle(SpotlyColors.textSecondary)
                    }
                    .padding(.vertical, SpotlySpacing.sm)
                }
            } else {
                Section("Business") {
                    TextField("Business name", text: $businessName)
                    Picker("Category", selection: $category) { ForEach(categories, id: \.self) { Text($0) } }
                    Picker("City", selection: $city) { ForEach(cities, id: \.self) { Text($0) } }
                }
                Section("Contact") {
                    TextField("Contact name", text: $contactName)
                    TextField("Phone or email", text: $contact)
                }
                Section("Notes") {
                    TextField("What should we know?", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
                Section {
                    Button("Submit enquiry") {
                        appState.addBusinessEnquiry(SpotlyBusinessEnquiry(id: UUID().uuidString, businessName: businessName.isEmpty ? "Unnamed business" : businessName, category: category, city: city, contactName: contactName.isEmpty ? "Contact pending" : contactName, contact: contact.isEmpty ? "Not provided" : contact, notes: notes, createdAt: Date()))
                        submitted = true
                    }
                    .font(SpotlyFont.callout(.semibold))
                }
            }
        }
        .navigationTitle("List your business")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if businessName.isEmpty, let initialBusinessName { businessName = initialBusinessName }
            if let initialCategory, categories.contains(initialCategory) { category = initialCategory }
            if let initialCity, cities.contains(initialCity) { city = initialCity }
        }
    }
}

struct BusinessEnquiriesView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        List {
            if appState.businessEnquiries.isEmpty {
                Section {
                    Text("No business enquiries yet. Submit one from List your business or a place detail screen.")
                        .foregroundStyle(SpotlyColors.textSecondary)
                }
            } else {
                Section("Submitted") {
                    ForEach(appState.businessEnquiries) { enquiry in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(enquiry.businessName).font(SpotlyFont.callout(.semibold))
                            Text(enquiry.category + " · " + enquiry.city)
                                .font(SpotlyFont.caption())
                                .foregroundStyle(SpotlyColors.textSecondary)
                            Text(enquiry.contactName + " · " + enquiry.contact)
                                .font(SpotlyFont.micro())
                                .foregroundStyle(SpotlyColors.textTertiary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle("Business enquiries")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Settings and City

struct SettingsView: View {
    @Environment(AppState.self) private var appState
    @State private var locationServices = true
    @State private var analytics = false
    @State private var showReset = false

    var body: some View {
        Form {
            Section("Preferences") {
                Toggle("Use location for nearby results", isOn: $locationServices).tint(SpotlyColors.accent)
                Toggle("Share anonymous demo analytics", isOn: $analytics).tint(SpotlyColors.accent)
            }
            Section("Demo data") {
                Button("Reset demo data", role: .destructive) { showReset = true }
                Text("Clears local orders, bookings, saved places, reviews, enquiries, and restores default city/profile demo state.")
                    .font(SpotlyFont.caption())
                    .foregroundStyle(SpotlyColors.textSecondary)
            }
            Section("Customer app scope") { Text("Business, driver, and admin tools are intentionally not included in this customer app build.") }
            Section("Version") { Text("Spotly 1.0 · Build 2 · 2026 launch demo") }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog("Reset demo data?", isPresented: $showReset, titleVisibility: .visible) {
            Button("Reset demo data", role: .destructive) { appState.resetDemoData() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This clears local demo activity and restores default sample data.")
        }
    }
}

struct CitySelectorView: View {
    @Environment(AppState.self) private var appState
    @State private var searchText = ""
    private let cities = ["Harare", "Bulawayo", "Victoria Falls", "Mutare", "Gweru"]

    var filteredCities: [String] {
        searchText.isEmpty ? cities : cities.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        List {
            Section {
                HStack(spacing: SpotlySpacing.sm) {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(SpotlyColors.textTertiary)
                    TextField("Search cities", text: $searchText)
                        .textInputAutocapitalization(.words)
                }
            }
            Section("Available cities") {
                ForEach(filteredCities, id: \.self) { city in
                    Button {
                        appState.selectedCity = city
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(city).foregroundStyle(SpotlyColors.textPrimary)
                                Text(city == appState.selectedCity ? "Current city" : "Switch marketplace location")
                                    .font(SpotlyFont.micro())
                                    .foregroundStyle(SpotlyColors.textTertiary)
                            }
                            Spacer()
                            if appState.selectedCity == city { Image(systemName: "checkmark").foregroundStyle(SpotlyColors.accent) }
                        }
                    }
                }
            }
            Section {
                Text("Spotly is launching city by city. Some categories may show fewer vendors outside Harare and Bulawayo while partner onboarding continues.")
                    .font(SpotlyFont.caption())
                    .foregroundStyle(SpotlyColors.textSecondary)
            }
        }
        .navigationTitle("City")
        .navigationBarTitleDisplayMode(.inline)
    }
}
