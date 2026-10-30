import SwiftUI

enum AuthState: Equatable {
    case unauthenticated, authenticated, guest
}

@MainActor
@Observable
final class AppState {
    var hasSeenOnboarding: Bool = UserDefaults.standard.bool(forKey: "hasSeenOnboarding") {
        didSet { UserDefaults.standard.set(hasSeenOnboarding, forKey: "hasSeenOnboarding") }
    }

    var hasCompletedEntryFlow: Bool = UserDefaults.standard.bool(forKey: "hasCompletedEntryFlow") {
        didSet { UserDefaults.standard.set(hasCompletedEntryFlow, forKey: "hasCompletedEntryFlow") }
    }

    var selectedAppearance: String = UserDefaults.standard.string(forKey: "preferredAppearance") ?? "system" {
        didSet {
            UserDefaults.standard.set(selectedAppearance, forKey: "preferredAppearance")
            UserDefaults.standard.set(selectedAppearance, forKey: "selectedAppearance")
        }
    }

    var preferredColorScheme: ColorScheme? {
        switch selectedAppearance {
        case "light": return .light
        case "dark": return .dark
        default: return nil
        }
    }

    var selectedCity: String = UserDefaults.standard.string(forKey: "selectedCity") ?? "Harare" {
        didSet { UserDefaults.standard.set(selectedCity, forKey: "selectedCity") }
    }

    var guestProfileName: String = UserDefaults.standard.string(forKey: "guestProfileName") ?? "Guest" {
        didSet { UserDefaults.standard.set(guestProfileName, forKey: "guestProfileName") }
    }

    var authState: AuthState = .unauthenticated
    var currentUser: SpotlyUser?
    var isGuestMode: Bool = UserDefaults.standard.bool(forKey: "spotly.isGuestMode") {
        didSet { UserDefaults.standard.set(isGuestMode, forKey: "spotly.isGuestMode") }
    }
    var isBootstrapping = true
    var bootError: String?
    var notificationPreference: Set<String> = []
    @ObservationIgnored private var warmStartTask: Task<Void, Never>?

    var isAuthenticated: Bool { authState == .authenticated }
    var displayName: String { currentUser?.firstName ?? (isGuestMode ? guestProfileName : "there") }
    var displayFullName: String { currentUser?.name ?? (isGuestMode ? guestProfileName : "") }

    var selectedTab: AppTab = .home
    var pendingDeepLink: DeepLinkRoute?

    let authService: any AuthServiceProtocol = ProductionAuthService()
    let marketplace = MarketplaceStore()
    let saved = SavedStore()
    let activity = ActivityStore()
    let locationService = LocationService()

    func signOut() {
        warmStartTask?.cancel()
        warmStartTask = nil
        // Sign out locally and clear account-scoped state synchronously. Never
        // retain previous customer data on screen while an APNs/FCM network call
        // waits for connectivity or times out.
        try? authService.signOut()
        currentUser = nil
        authState = .unauthenticated
        isGuestMode = false
        hasCompletedEntryFlow = false
        selectedTab = .home
        pendingDeepLink = nil
        activity.reset()
        saved.reset()
        marketplace.resetForAccountChange()
        marketplace.clearRecentSearches()
        notificationPreference = []
        UserDefaults.standard.removeObject(forKey: "spotly.notification.categories")
        Task { await PushCoordinator.shared.invalidateLocalFCMTokenAfterSignOut() }
    }

    func bootstrap() async {
        guard isBootstrapping else { return }
        bootError = nil
        if let service = authService as? ProductionAuthService, let restored = await service.restore() {
            currentUser = restored
            authState = .authenticated
            isGuestMode = false
            hasCompletedEntryFlow = true
            if let city = restored.location.nilIfBlank { selectedCity = city }
            // Open the main interface using the locally restored Firebase
            // identity. On slow networks, Saved/Activity/profile/FCM may take
            // several seconds; none should keep the launch screen visible.
            isBootstrapping = false
            warmStartTask?.cancel()
            warmStartTask = Task { [weak self] in
                guard let self else { return }
                async let profile = SessionController.shared.refreshRestoredProfile(for: restored.id)
                async let savedLoad: Void = self.saved.load(user: restored)
                async let activityLoad: Void = self.activity.load(user: restored, force: true)
                async let pushRegistration: Void = PushCoordinator.shared.registerCurrentTokenForSignedInUser()
                let updated = await profile
                _ = await (savedLoad, activityLoad, pushRegistration)
                guard !Task.isCancelled, self.currentUser?.id == restored.id else { return }
                if let updated {
                    self.currentUser = updated
                    if let city = updated.location.nilIfBlank { self.selectedCity = city }
                }
            }
            return
        } else if isGuestMode && hasCompletedEntryFlow {
            authState = .guest
        } else {
            authState = .unauthenticated
            if hasCompletedEntryFlow { hasCompletedEntryFlow = false }
        }
        isBootstrapping = false
    }

    func completeProfile(name: String, phone: String, city: String) {
        let cleanedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        selectedCity = city
        if isGuestMode {
            guestProfileName = cleanedName.isEmpty ? "Guest" : cleanedName
        } else if currentUser != nil {
            if !cleanedName.isEmpty {
                currentUser?.name = cleanedName
                currentUser?.firstName = cleanedName.split(separator: " ").first.map(String.init) ?? cleanedName
            }
            currentUser?.phone = phone
            currentUser?.location = city
        }
    }

    func resetOnboarding() { hasSeenOnboarding = false }
}
