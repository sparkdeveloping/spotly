import SwiftUI
import UserNotifications

struct ProductionProfileView: View {
    @Environment(AppState.self) private var appState
    @State private var verificationMessage: String?
    @State private var checkingEmail = false

    var body: some View {
        NavigationStack {
            List {
                accountHeader

                Section("Your Spotly") {
                    NavigationLink { NotificationCenterView() } label: { Label("Notifications", systemImage: "bell") }
                    NavigationLink { ProfileEditorView() } label: { Label("Profile & city", systemImage: "person.crop.circle") }
                    NavigationLink { NotificationPreferencesView() } label: { Label("Notification preferences", systemImage: "slider.horizontal.3") }
                    NavigationLink { SupportView() } label: { Label("Help & support", systemImage: "questionmark.circle") }
                }

                Section("App") {
                    NavigationLink { AppearanceSettingsView() } label: { Label("Appearance", systemImage: "circle.lefthalf.filled") }
                    Link(destination: URL(string: "https://spotlyafrica.com/privacy")!) { Label("Privacy notice", systemImage: "hand.raised") }
                    Link(destination: URL(string: "https://spotlyafrica.com/terms")!) { Label("Terms of service", systemImage: "doc.text") }
                    NavigationLink { AboutSpotlyProductionView() } label: { Label("About Spotly", systemImage: "info.circle") }
                }

                if appState.isAuthenticated {
                    if appState.currentUser?.isVerified == false {
                        Section("Email verification") {
                            Text("Verify your email to keep your Spotly account recoverable.")
                                .font(.footnote).foregroundStyle(.secondary)
                            Button("Resend verification email") { Task { await resendVerification() } }
                                .disabled(checkingEmail)
                            Button("I've verified — check again") { Task { await checkVerification() } }
                                .disabled(checkingEmail)
                            if let verificationMessage { Text(verificationMessage).font(.footnote) }
                        }
                    }
                    Section {
                        NavigationLink { AccountPrivacyView() } label: { Label("Privacy & account", systemImage: "lock.shield") }
                        Button(role: .destructive) { appState.signOut() } label: { Label("Sign out", systemImage: "rectangle.portrait.and.arrow.right") }
                    }
                }
            }
            .navigationTitle("Profile")
            .listStyle(.insetGrouped)
        }
    }

    @ViewBuilder private var accountHeader: some View {
        Section {
            HStack(spacing: 14) {
                ZStack {
                    Circle().fill(SpotlyColors.accent.opacity(0.12)).frame(width: 58, height: 58)
                    Text(initials).font(.title3.bold()).foregroundStyle(SpotlyColors.accent)
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text(appState.displayFullName.nilIfBlank ?? (appState.isAuthenticated ? "Spotly member" : "Guest"))
                        .font(SpotlyFont.title3(.bold))
                    Text(appState.isAuthenticated ? (appState.currentUser?.email ?? "Signed in") : "Browsing as guest")
                        .font(SpotlyFont.callout()).foregroundStyle(SpotlyColors.textSecondary)
                }
                Spacer()
            }
            .padding(.vertical, 6)

            if !appState.isAuthenticated {
                Button("Sign in or create account") {
                    appState.hasCompletedEntryFlow = false
                    appState.isGuestMode = false
                    appState.authState = .unauthenticated
                }
                .font(SpotlyFont.subheadline(.semibold))
                .foregroundStyle(SpotlyColors.accent)
            }
        }
    }

    private func resendVerification() async {
        checkingEmail = true
        defer { checkingEmail = false }
        do {
            try await SessionController.shared.sendVerificationEmail()
            verificationMessage = "Verification email requested. Check your inbox and spam folder."
        } catch { verificationMessage = error.localizedDescription }
    }

    private func checkVerification() async {
        checkingEmail = true
        defer { checkingEmail = false }
        do {
            let isVerified = try await SessionController.shared.reloadEmailVerificationStatus()
            if isVerified {
                appState.currentUser?.isVerified = true
                verificationMessage = nil
            } else {
                verificationMessage = "Not verified yet. Open the link in your email, then check again."
            }
        } catch { verificationMessage = error.localizedDescription }
    }

    private var initials: String {
        let source = appState.displayFullName.nilIfBlank ?? "S"
        return source.split(separator: " ").prefix(2).compactMap(\.first).map(String.init).joined().uppercased()
    }
}

struct ProfileEditorView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var phone = ""
    @State private var city = "Harare"
    @State private var saving = false
    @State private var errorMessage: String?

    var body: some View {
        Form {
            Section("Profile") {
                TextField("Full name", text: $name).textContentType(.name)
                TextField("Phone", text: $phone).textContentType(.telephoneNumber).keyboardType(.phonePad)
            }
            Section("City") {
                Picker("City", selection: $city) {
                    ForEach(["Harare", "Bulawayo", "Mutare", "Gweru", "Masvingo", "Victoria Falls"], id: \.self) { Text($0).tag($0) }
                }
                Text("City-level discovery always works. Precise location is requested only when a feature needs it.")
                    .font(.footnote).foregroundStyle(.secondary)
            }
            if let errorMessage { Section { Text(errorMessage).foregroundStyle(.red) } }
        }
        .navigationTitle("Profile & city")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") { Task { await save() } }.disabled(saving || name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .onAppear {
            name = appState.currentUser?.name ?? appState.guestProfileName
            phone = appState.currentUser?.phone ?? ""
            city = appState.currentUser?.location.nilIfBlank ?? appState.selectedCity
        }
    }

    private func save() async {
        saving = true; errorMessage = nil
        defer { saving = false }
        do {
            if let user = appState.currentUser, appState.isAuthenticated {
                guard let token = try await SessionController.shared.validIDToken() else { throw SpotlyAPIError.unauthenticated }
                try await FirestoreREST.shared.updateUserProfile(uid: user.id, displayName: name, phone: phone, city: city, token: token)
            }
            appState.completeProfile(name: name, phone: phone, city: city)
            dismiss()
        } catch { errorMessage = error.localizedDescription }
    }
}

struct NotificationPreferencesView: View {
    @Environment(AppState.self) private var appState
    @State private var orderUpdates = true
    @State private var bookingUpdates = true
    @State private var rideAndSend = true
    @State private var offers = false
    @State private var authorizationText = "Checking…"
    @State private var didLoad = false
    @State private var saving = false
    @State private var saveError: String?
    @State private var saveTask: Task<Void, Never>?

    private var selection: NotificationSelection {
        NotificationSelection(orders: orderUpdates, bookings: bookingUpdates,
                              operations: rideAndSend, offers: offers)
    }

    var body: some View {
        Form {
            Section("On this device") {
                HStack { Text("Push notifications"); Spacer(); Text(authorizationText).foregroundStyle(.secondary) }
                Button("Enable notifications") { Task { await requestPermission() } }
            }
            Section("What Spotly can alert you about") {
                Toggle("Orders", isOn: Binding(get: { orderUpdates }, set: { orderUpdates = $0; persist() }))
                Toggle("Bookings & events", isOn: Binding(get: { bookingUpdates }, set: { bookingUpdates = $0; persist() }))
                Toggle("Ride & Send", isOn: Binding(get: { rideAndSend }, set: { rideAndSend = $0; persist() }))
                Toggle("Offers and discovery", isOn: Binding(get: { offers }, set: { offers = $0; persist() }))
                if saving { Label("Saving preferences…", systemImage: "arrow.triangle.2.circlepath").font(.footnote) }
                if let saveError {
                    Text(saveError).font(.footnote).foregroundStyle(SpotlyColors.error)
                    Button("Retry saving") { persist() }
                }
            }
            .disabled(!didLoad)
            Section {
                Text("In-app Activity remains authoritative even when push notifications are off.")
                    .font(.footnote).foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Notifications")
        .task(id: appState.currentUser?.id) {
            let owner = appState.currentUser?.id
            didLoad = false
            saveTask?.cancel()
            saving = false
            saveError = nil
            loadLocalPreferences()
            await loadRemotePreferences()
            guard !Task.isCancelled, owner == appState.currentUser?.id else { return }
            appState.notificationPreference = selection.categories
            didLoad = true
            await refreshAuthorization()
        }
    }

    private func apply(_ value: NotificationSelection) {
        orderUpdates = value.orders
        bookingUpdates = value.bookings
        rideAndSend = value.operations
        offers = value.offers
    }

    private func loadLocalPreferences() {
        let saved = Set(UserDefaults.standard.stringArray(forKey: "spotly.notification.categories") ?? ["orders", "bookings", "operations"])
        apply(NotificationSelection(orders: saved.contains("orders"), bookings: saved.contains("bookings"),
                                    operations: saved.contains("operations"), offers: saved.contains("offers")))
    }

    private func persist() {
        guard didLoad else { return }
        let chosen = selection
        let owner = appState.currentUser?.id
        UserDefaults.standard.set(chosen.categories.sorted(), forKey: "spotly.notification.categories")
        appState.notificationPreference = chosen.categories
        saveError = nil
        guard let owner, appState.isAuthenticated else { return }
        // Order writes: rapid toggling should not let an older request finish
        // after a newer one and silently overwrite the user's final choice.
        let preceding = saveTask
        preceding?.cancel()
        saving = true
        saveTask = Task {
            await preceding?.value
            do {
                try await Task.sleep(for: .milliseconds(350))
                try Task.checkCancellation()
                guard appState.currentUser?.id == owner else { return }
                guard let token = try await SessionController.shared.validIDToken() else { throw SpotlyAPIError.unauthenticated }
                try await FirestoreREST.shared.saveNotificationPreferences(
                    uid: owner, orderUpdates: chosen.orders, bookingUpdates: chosen.bookings,
                    rideSendUpdates: chosen.operations, marketing: chosen.offers, token: token)
                if !Task.isCancelled, appState.currentUser?.id == owner { saveError = nil }
            } catch is CancellationError {
                // Superseded by a newer selection.
            } catch {
                if !Task.isCancelled, appState.currentUser?.id == owner { saveError = "Couldn’t sync preferences to your account. Retry saving." }
            }
            if !Task.isCancelled { saving = false }
        }
    }

    private func loadRemotePreferences() async {
        guard let user = appState.currentUser, appState.isAuthenticated,
              let token = try? await SessionController.shared.validIDToken(),
              let document = try? await FirestoreREST.shared.readNotificationPreferences(uid: user.id, token: token),
              appState.currentUser?.id == user.id else { return }
        apply(NotificationSelection(
            orders: document.fields["orderUpdates"]?.boolValue ?? orderUpdates,
            bookings: document.fields["bookingUpdates"]?.boolValue ?? bookingUpdates,
            operations: document.fields["rideSendUpdates"]?.boolValue ?? rideAndSend,
            offers: document.fields["marketing"]?.boolValue ?? offers))
        UserDefaults.standard.set(selection.categories.sorted(), forKey: "spotly.notification.categories")
    }

    private func requestPermission() async {
        _ = await NotificationPermissionService().requestPermission()
        await PushCoordinator.shared.registerForRemoteNotificationsIfAuthorized()
        await refreshAuthorization()
    }

    private func refreshAuthorization() async {
        let status = await NotificationPermissionService().currentStatus()
        authorizationText = switch status {
        case .authorized, .provisional, .ephemeral: "Enabled"
        case .denied: "Off in Settings"
        case .notDetermined: "Not requested"
        @unknown default: "Unknown"
        }
    }
}

struct NotificationSelection: Equatable {
    let orders: Bool
    let bookings: Bool
    let operations: Bool
    let offers: Bool

    var categories: Set<String> {
        var values = Set<String>()
        if orders { values.insert("orders") }
        if bookings { values.insert("bookings") }
        if operations { values.insert("operations") }
        if offers { values.insert("offers") }
        return values
    }
}

struct NotificationCenterView: View {
    @Environment(AppState.self) private var appState
    @State private var notifications: [SpotlyNotificationRecord] = []
    @State private var loading = true
    @State private var errorMessage: String?
    @State private var requestID = UUID()

    var body: some View {
        Group {
            if !appState.isAuthenticated {
                SignInRequiredView(title: "Sign in for notifications", message: "Operational updates are tied to your Spotly account.")
            } else if loading && notifications.isEmpty {
                ProgressView("Loading notifications…")
            } else if notifications.isEmpty, let errorMessage {
                SpotlyNetworkStateView(title: "Notifications unavailable", message: errorMessage, actionTitle: "Try again") {
                    Task { await load() }
                }
            } else if notifications.isEmpty {
                ContentUnavailableView {
                    Label("You’re all caught up", systemImage: "bell")
                } description: {
                    Text("Order, booking, Ride, Send and support updates will appear here.")
                } actions: {
                    Button("Refresh") { Task { await load() } }
                }
            } else {
                List {
                    if let errorMessage {
                        Section {
                            Label(errorMessage, systemImage: "wifi.exclamationmark")
                                .font(.footnote).foregroundStyle(SpotlyColors.warning)
                            Button("Retry") { Task { await load() } }
                        }
                    }
                    ForEach(notifications) { notification in
                    Button { Task { await open(notification) } } label: {
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: notification.icon).foregroundStyle(SpotlyColors.accent).frame(width: 28, height: 28)
                            VStack(alignment: .leading, spacing: 5) {
                                HStack {
                                    Text(notification.title).font(.headline).foregroundStyle(.primary)
                                    if !notification.read { Circle().fill(SpotlyColors.accent).frame(width: 7, height: 7) }
                                }
                                Text(notification.body).font(.subheadline).foregroundStyle(.secondary).fixedSize(horizontal: false, vertical: true)
                                if let date = notification.createdAt { Text(date, style: .relative).font(.caption).foregroundStyle(.tertiary) }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .buttonStyle(.plain)
                    }
                }
                .refreshable { await load() }
            }
        }
        .navigationTitle("Notifications")
        .task(id: appState.currentUser?.id) {
            notifications = []
            await load()
        }
    }

    private func load() async {
        requestID = UUID()
        let request = requestID
        guard let user = appState.currentUser else { notifications = []; loading = false; return }
        loading = notifications.isEmpty
        errorMessage = nil
        do {
            guard let token = try await SessionController.shared.validIDToken() else { throw SpotlyAPIError.unauthenticated }
            let records = try await FirestoreREST.shared.queryNotifications(uid: user.id, token: token)
                .compactMap(SpotlyNotificationRecord.init)
                .filter(\.isCustomerVisible)
                .sorted { ($0.createdAt ?? .distantPast) > ($1.createdAt ?? .distantPast) }
            guard requestID == request, appState.currentUser?.id == user.id, !Task.isCancelled else { return }
            notifications = records
        } catch {
            guard requestID == request, appState.currentUser?.id == user.id, !Task.isCancelled else { return }
            errorMessage = error.localizedDescription
        }
        if requestID == request { loading = false }
    }

    private func open(_ notification: SpotlyNotificationRecord) async {
        if !notification.read, let token = try? await SessionController.shared.validIDToken() {
            try? await FirestoreREST.shared.markNotificationRead(id: notification.id, token: token)
            if let index = notifications.firstIndex(where: { $0.id == notification.id }) { notifications[index].read = true }
        }
        if let href = notification.href { DeepLinkCoordinator.shared.handle(href, appState: appState) }
    }
}

struct SpotlyNotificationRecord: Identifiable {
    let id: String
    let title: String
    let body: String
    let href: URL?
    let category: String
    let workspace: String?
    let eventType: String?
    let module: String?
    var read: Bool
    let createdAt: Date?

    init?(_ doc: FirestoreDocument) {
        guard let rawTitle = doc.fields["title"]?.stringValue else { return nil }
        id = doc.id
        workspace = doc.fields["workspace"]?.stringValue?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        eventType = doc.fields["eventType"]?.stringValue?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        module = doc.fields["module"]?.stringValue?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        category = doc.fields["category"]?.stringValue ?? "general"
        let rawBody = doc.fields["body"]?.stringValue ?? ""
        let normalized = Self.normalizedCopy(title: rawTitle, body: rawBody, eventType: eventType)
        title = normalized.title
        body = normalized.body
        href = URL(string: doc.fields["href"]?.stringValue ?? "")
        read = doc.fields["read"]?.boolValue ?? false
        createdAt = doc.fields["createdAt"]?.dateValue
    }

    var isCustomerVisible: Bool {
        if let workspace, !workspace.isEmpty { return workspace == "customer" }
        // Legacy records created before workspace scoping are admitted only when their domain
        // is clearly customer-facing. This prevents Driver/Business/Admin history from leaking
        // into the customer app while older order/support notifications remain visible.
        let signals = "\(category) \(eventType ?? "") \(module ?? "") \(title) \(body)".lowercased()
        let blocked = ["driver vehicle", "vehicle review", "settlement", "payout destination", "business payout", "business review", "admin queue", "staff review", "driver application"]
        if blocked.contains(where: { signals.contains($0) }) { return false }
        if ["driver", "business", "admin", "staff"].contains(where: { token in
            signals.split(whereSeparator: { !$0.isLetter && !$0.isNumber }).contains(Substring(token))
        }) { return false }
        return true
    }

    var icon: String {
        let signal = "\(category) \(eventType ?? "") \(module ?? "")".lowercased()
        if signal.contains("ride") { return "car.fill" }
        if signal.contains("send") || signal.contains("parcel") { return "shippingbox.fill" }
        if signal.contains("booking") || signal.contains("appointment") { return "calendar" }
        if signal.contains("event") || signal.contains("ticket") { return "ticket.fill" }
        if signal.contains("support") || signal.contains("conversation") { return "message.fill" }
        if signal.contains("order") || signal.contains("pickup") || signal.contains("delivery") { return "bag.fill" }
        return "bell.fill"
    }

    private static func normalizedCopy(title: String, body: String, eventType: String?) -> (title: String, body: String) {
        let event = eventType ?? ""
        if event.contains("pickup") && event.contains("complete") {
            return ("Order picked up", body.replacingOccurrences(of: "Complete pickup completed.", with: "Your order has been collected."))
        }
        if title.caseInsensitiveCompare("Complete pickup completed") == .orderedSame || body.caseInsensitiveCompare("Complete pickup completed.") == .orderedSame {
            return ("Order picked up", "Your order has been collected and is moving to the next step.")
        }
        return (title, body)
    }
}

struct SupportView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    var contextType: String? = nil
    var contextID: String? = nil
    var defaultSubject: String = ""
    var presetCategory: String? = nil

    @State private var subject = ""
    @State private var category = "account"
    @State private var message = ""
    @State private var sending = false
    @State private var sent = false
    @State private var errorMessage: String?

    private let categories = [
        ("account", "Account"), ("orders", "Orders"), ("payments", "Payments"),
        ("safety", "Safety"), ("privacy", "Privacy"), ("partnership", "Partnership")
    ]

    var body: some View {
        Group {
            if !appState.isAuthenticated {
                SignInRequiredView(title: "Sign in for account support", message: "Signing in lets support securely connect this request to your Spotly account and activity.")
            } else if sent {
                ContentUnavailableView {
                    Label("Request sent", systemImage: "checkmark.circle.fill")
                } description: {
                    Text("Spotly Support has your request. Replies and updates will be tied to your account.")
                } actions: {
                    Button("Done") { dismiss() }.buttonStyle(.borderedProminent).tint(SpotlyColors.accent)
                }
            } else {
                Form {
                    Section("What do you need help with?") {
                        Picker("Category", selection: $category) { ForEach(categories, id: \.0) { Text($0.1).tag($0.0) } }
                        TextField("Subject", text: $subject)
                        TextField("Describe what happened", text: $message, axis: .vertical).lineLimit(5...10)
                    }
                    if let contextType, let contextID {
                        Section("Connected activity") { Text("\(contextType.capitalized) · \(contextID)").font(.footnote).foregroundStyle(.secondary) }
                    }
                    if let errorMessage { Section { Text(errorMessage).foregroundStyle(.red) } }
                    Section {
                        Button { Task { await submit() } } label: {
                            HStack { Spacer(); if sending { ProgressView() } else { Text("Send to Spotly Support") }; Spacer() }
                        }
                        .disabled(sending || subject.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || message.trimmingCharacters(in: .whitespacesAndNewlines).count < 10)
                    }
                }
            }
        }
        .navigationTitle("Help & support")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            subject = defaultSubject
            category = presetCategory ?? category
        }
    }

    private func submit() async {
        sending = true; errorMessage = nil
        defer { sending = false }
        do {
            _ = try await SpotlyCommerceService.shared.createSupport(subject: subject, category: category, message: message, user: appState.currentUser, contextType: contextType, contextID: contextID)
            sent = true
        } catch { errorMessage = error.localizedDescription }
    }
}

struct AccountPrivacyView: View {
    @Environment(AppState.self) private var appState
    @State private var showDeleteConfirmation = false
    @State private var requestSent = false
    @State private var errorMessage: String?

    var body: some View {
        Form {
            Section("Your data") {
                NavigationLink { SupportView(defaultSubject: "Privacy request", presetCategory: "privacy") } label: { Label("Request my data", systemImage: "doc.text.magnifyingglass") }
                Link("Read the privacy notice", destination: URL(string: "https://spotlyafrica.com/privacy")!)
            }
            Section("Account deletion") {
                Text("You can initiate deletion here. Spotly records the request immediately and completes deletion after any active transaction or required identity check is resolved.")
                    .font(.footnote).foregroundStyle(.secondary)
                Button("Close my account", role: .destructive) { showDeleteConfirmation = true }
            }
            if requestSent { Section { Label("Account closure request sent", systemImage: "checkmark.circle").foregroundStyle(.green) } }
            if let errorMessage { Section { Text(errorMessage).foregroundStyle(.red) } }
        }
        .navigationTitle("Privacy & account")
        .confirmationDialog("Close your Spotly account?", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
            Button("Request account deletion", role: .destructive) { Task { await requestDeletion() } }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This starts the account deletion process. Spotly may need to verify identity or resolve active transactions before deletion completes.")
        }
    }

    private func requestDeletion() async {
        do {
            let response = try await SpotlyCommerceService.shared.requestAccountDeletion()
            requestSent = response.ok
            if let blockers = response.blockers, blockers.total > 0 {
                errorMessage = "Your closure request is recorded. Spotly will finish \(blockers.total) active transaction\(blockers.total == 1 ? "" : "s") before final deletion."
            }
        } catch {
            errorMessage = "Spotly couldn’t start account deletion. Try again, or contact Support if the problem continues."
        }
    }
}

struct AboutSpotlyProductionView: View {
    var body: some View {
        List {
            Section {
                VStack(spacing: 12) {
                    SpotlyLogoMark(size: 64)
                    Text("Spotly").font(.title2.bold())
                    Text("Everything around you, easier.").font(.subheadline).foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity).padding(.vertical, 16)
            }
            Section("Version") {
                LabeledContent("Version", value: SpotlyConfiguration.appVersion)
                LabeledContent("Build", value: SpotlyConfiguration.buildNumber)
            }
            Section("Web") {
                Link("spotlyafrica.com", destination: URL(string: "https://spotlyafrica.com")!)
            }
        }
        .navigationTitle("About Spotly")
    }
}


private struct AppearanceSettingsView: View {
    @Environment(AppState.self) private var appState
    var body: some View {
        @Bindable var state = appState
        Form {
            Section("Appearance") {
                SpotlyAppearancePicker(selection: $state.selectedAppearance)
                    .padding(.vertical, 6)
            }
            Section {
                Text("System follows your device appearance. Spotly keeps semantic contrast and native Liquid Glass behavior in either mode.")
                    .font(.footnote).foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Appearance")
    }
}
