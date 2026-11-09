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

    var preferredCountryCode: SpotlyCountryCode? = UserDefaults.standard.string(forKey: "spotly.country.code").flatMap(SpotlyCountryCode.init(rawValue:)) {
        didSet {
            if let preferredCountryCode { UserDefaults.standard.set(preferredCountryCode.rawValue, forKey: "spotly.country.code") }
            else { UserDefaults.standard.removeObject(forKey: "spotly.country.code") }
        }
    }
    var countryOverrideCode: SpotlyCountryCode?
    var selectedCity: String = UserDefaults.standard.string(forKey: "selectedCity") ?? "" {
        didSet { UserDefaults.standard.set(selectedCity, forKey: "selectedCity") }
    }

    var selectedCountryCode: SpotlyCountryCode? { countryOverrideCode ?? currentUser?.effectiveCountryCode ?? preferredCountryCode }
    var selectedCountry: SpotlyCountryDefinition? { SpotlyCountryEngine.definition(for: selectedCountryCode) }
    var availableCities: [SpotlyCountryCity] { selectedCountry?.cities ?? [] }
    var serviceAvailability: [SpotlyServiceID: SpotlyServiceAvailabilityDecision] = [:]
    var operationsContexts: [SpotlyServiceID: SpotlyOperationsContext] = [:]

    func serviceDecision(for service: SpotlyServiceID) -> SpotlyServiceAvailabilityDecision? {
        if let current = serviceAvailability[service] { return current }
        guard let country = selectedCountryCode else { return nil }
        return SpotlyServiceAvailabilityCatalog.decision(service: service, country: country, city: selectedCity)
    }

    func serviceIsVisible(_ service: SpotlyServiceID) -> Bool { serviceDecision(for: service)?.visible ?? true }
    func serviceIsDiscoverable(_ service: SpotlyServiceID) -> Bool { serviceDecision(for: service)?.discoverable ?? false }
    func serviceIsLive(_ service: SpotlyServiceID) -> Bool { serviceDecision(for: service)?.transactable ?? false }

    func operationsContext(for service: SpotlyServiceID) -> SpotlyOperationsContext {
        operationsContexts[service] ?? .empty
    }

    func refreshOperationsContext(for service: SpotlyServiceID) async {
        guard isAuthenticated, let country = selectedCountryCode else {
            operationsContexts[service] = .empty
            return
        }
        do {
            let value = try await FirebasePlatform.operationsContext(service: service, country: country, city: selectedCity)
            operationsContexts[service] = value.0
        } catch {
            operationsContexts[service] = .empty
        }
    }

    func refreshServiceAvailability() async {
        guard let country = selectedCountryCode else { serviceAvailability = [:]; return }
        do { serviceAvailability = try await FirebasePlatform.serviceAvailability(country: country, city: selectedCity) }
        catch {
            serviceAvailability = Dictionary(uniqueKeysWithValues: SpotlyServiceID.allCases.map { ($0, SpotlyServiceAvailabilityCatalog.decision(service: $0, country: country, city: selectedCity)) })
        }
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
        operationsContexts = [:]
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
            applyCountryContext(from: restored)
            await refreshServiceAvailability()
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
                    self.applyCountryContext(from: updated)
                    await self.refreshServiceAvailability()
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

    func completeProfile(name: String, phone: String, country: SpotlyCountryCode, city: String) {
        let cleanedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        preferredCountryCode = country
        selectedCity = city
        Task { await refreshServiceAvailability() }
        if isGuestMode {
            guestProfileName = cleanedName.isEmpty ? "Guest" : cleanedName
        } else if currentUser != nil {
            if !cleanedName.isEmpty {
                currentUser?.name = cleanedName
                currentUser?.firstName = cleanedName.split(separator: " ").first.map(String.init) ?? cleanedName
            }
            currentUser?.phone = phone
            currentUser?.location = city
            currentUser?.countryCode = country
            currentUser?.countrySource = "manual"
            currentUser?.preferredCity = city
        }
    }

    func setCountryPreference(_ country: SpotlyCountryCode, city: String = "") {
        guard countryOverrideCode == nil else { return }
        let changed = preferredCountryCode != country
        preferredCountryCode = country
        if changed { selectedCity = city } else if !city.isEmpty { selectedCity = city }
        Task { await refreshServiceAvailability() }
        if currentUser != nil {
            currentUser?.countryCode = country
            currentUser?.countrySource = "manual"
            if !city.isEmpty { currentUser?.preferredCity = city; currentUser?.location = city }
        }
    }

    func applyCountryContext(from user: SpotlyUser) {
        countryOverrideCode = user.countryOverrideCode
        if let code = user.countryCode { preferredCountryCode = code }
        if let city = user.preferredCity.nilIfBlank ?? user.location.nilIfBlank { selectedCity = city }
    }

    func resetOnboarding() { hasSeenOnboarding = false }
}
