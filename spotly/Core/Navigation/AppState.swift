import SwiftUI

// MARK: - Auth state

enum AuthState: Equatable {
    case unauthenticated, authenticated, guest
}

// MARK: - Local orders

struct SpotlyOrder: Identifiable, Hashable {
    let id: String
    let businessID: String
    let businessName: String
    let itemsSummary: String
    let total: Double
    var status: String
    let createdAt: Date

    var totalText: String { "US$\(String(format: "%.2f", total))" }
}

// MARK: - Local profile data

struct SpotlyAddress: Identifiable, Hashable {
    let id: String
    var label: String
    var line: String
    var city: String
    var isDefault: Bool
}

struct SpotlyUserReview: Identifiable, Hashable {
    let id: String
    let placeID: String
    let placeName: String
    var rating: Int
    var comment: String
    let createdAt: Date
}

struct SpotlyBusinessEnquiry: Identifiable, Hashable {
    let id: String
    var businessName: String
    var category: String
    var city: String
    var contactName: String
    var contact: String
    var notes: String
    let createdAt: Date
}

// MARK: - App-wide observable state

@Observable
final class AppState {

    // MARK: Persisted — Onboarding & Entry
    var hasSeenOnboarding: Bool = UserDefaults.standard.bool(forKey: "hasSeenOnboarding") {
        didSet { UserDefaults.standard.set(hasSeenOnboarding, forKey: "hasSeenOnboarding") }
    }

    var hasCompletedEntryFlow: Bool = UserDefaults.standard.bool(forKey: "hasCompletedEntryFlow") {
        didSet { UserDefaults.standard.set(hasCompletedEntryFlow, forKey: "hasCompletedEntryFlow") }
    }

    // MARK: Persisted — Appearance ("system" | "light" | "dark")
    var selectedAppearance: String = UserDefaults.standard.string(forKey: "preferredAppearance") ?? "system" {
        didSet {
            UserDefaults.standard.set(selectedAppearance, forKey: "preferredAppearance")
            UserDefaults.standard.set(selectedAppearance, forKey: "selectedAppearance")
        }
    }

    var preferredColorScheme: ColorScheme? {
        switch selectedAppearance {
        case "light": return .light
        case "dark":  return .dark
        default:      return nil
        }
    }

    // MARK: Persisted — Location
    var selectedCity: String = UserDefaults.standard.string(forKey: "selectedCity") ?? "Harare" {
        didSet { UserDefaults.standard.set(selectedCity, forKey: "selectedCity") }
    }

    var guestProfileName: String = UserDefaults.standard.string(forKey: "guestProfileName") ?? "Guest" {
        didSet { UserDefaults.standard.set(guestProfileName, forKey: "guestProfileName") }
    }

    // MARK: Persisted — Interests (comma-separated)
    var selectedInterests: [String] = {
        let raw = UserDefaults.standard.string(forKey: "selectedInterests") ?? ""
        return raw.isEmpty ? [] : raw.components(separatedBy: ",")
    }() {
        didSet { UserDefaults.standard.set(selectedInterests.joined(separator: ","), forKey: "selectedInterests") }
    }

    // MARK: Auth
    var authState: AuthState = .unauthenticated
    var currentUser: SpotlyUser? = nil
    var isGuestMode: Bool = false
    var notificationPreference: Set<String> = []

    var isAuthenticated: Bool { authState == .authenticated }
    var displayName: String { currentUser?.firstName ?? (isGuestMode ? guestProfileName : "there") }
    var displayFullName: String { currentUser?.name ?? (isGuestMode ? guestProfileName : "") }

    // MARK: Navigation
    var selectedTab: AppTab = .home
    var homeNavPath   = NavigationPath()
    var searchNavPath = NavigationPath()

    // MARK: Favourites
    var favouriteIDs: Set<String> = {
        let raw = UserDefaults.standard.string(forKey: "favouriteIDs") ?? ""
        return Set(raw.split(separator: ",").map(String.init))
    }() {
        didSet { UserDefaults.standard.set(favouriteIDs.sorted().joined(separator: ","), forKey: "favouriteIDs") }
    }

    // MARK: Bookings & Orders
    var bookings: [SpotlyBooking] = MockBookings.all
    var orders: [SpotlyOrder] = [
        SpotlyOrder(id: "ord-001", businessID: "b002", businessName: "The Braai House", itemsSummary: "Chicken combo, sadza & stew", total: 24.49, status: "Preparing", createdAt: Date().addingTimeInterval(-3600)),
        SpotlyOrder(id: "ord-002", businessID: "b009", businessName: "Spar Avondale", itemsSummary: "Bread, milk, eggs, tomatoes", total: 17.50, status: "Out for delivery", createdAt: Date().addingTimeInterval(-86400))
    ]
    var addresses: [SpotlyAddress] = [
        SpotlyAddress(id: "addr-home", label: "Home", line: "Hillside, Bulawayo", city: "Bulawayo", isDefault: true),
        SpotlyAddress(id: "addr-work", label: "Work", line: "Nelson Mandela Avenue, Harare CBD", city: "Harare", isDefault: false)
    ]
    var userReviews: [SpotlyUserReview] = []
    var businessEnquiries: [SpotlyBusinessEnquiry] = []

    // MARK: Repositories & services
    let listingRepo: any ListingRepositoryProtocol = MockListingRepository()
    let bookingRepo: any BookingRepositoryProtocol = MockBookingRepository()
    let authService: any AuthServiceProtocol       = MockAuthService()

    // MARK: - Favourites

    func isFavourited(_ id: String) -> Bool { favouriteIDs.contains(id) }
    func isSaved(spotID: String) -> Bool { isFavourited(spotID) }

    var savedSpots: [SpotlyBusiness] { favouriteBusinesses }
    var savedCount: Int { savedSpots.count }

    func toggleSaved(spotID: String) {
        toggleFavourite(spotID)
    }

    func toggleFavourite(_ id: String) {
        withAnimation(SpotlyMotion.successPop) {
            if favouriteIDs.contains(id) {
                favouriteIDs.remove(id)
            } else {
                favouriteIDs.insert(id)
                SpotlyHaptics.success()
            }
        }
    }

    // MARK: - Bookings

    func addBooking(_ booking: SpotlyBooking) {
        bookings.append(booking)
        SpotlyHaptics.success()
    }

    func cancelBooking(_ id: String) {
        withAnimation {
            guard let index = bookings.firstIndex(where: { $0.id == id }) else { return }
            bookings[index].status = .cancelled
        }
        SpotlyHaptics.medium()
    }

    func addOrder(_ order: SpotlyOrder) {
        orders.insert(order, at: 0)
        SpotlyHaptics.success()
    }

    func addAddress(label: String, line: String, city: String, makeDefault: Bool = false) {
        if makeDefault || addresses.isEmpty {
            addresses = addresses.map { address in
                var copy = address
                copy.isDefault = false
                return copy
            }
        }
        addresses.append(SpotlyAddress(id: UUID().uuidString, label: label, line: line, city: city, isDefault: makeDefault || addresses.isEmpty))
    }

    func updateAddress(_ address: SpotlyAddress) {
        if address.isDefault {
            setDefaultAddress(address.id)
        }
        guard let index = addresses.firstIndex(where: { $0.id == address.id }) else { return }
        addresses[index] = address
        if !addresses.contains(where: { $0.isDefault }), let firstID = addresses.first?.id {
            setDefaultAddress(firstID)
        }
    }

    func deleteAddress(_ id: String) {
        addresses.removeAll { $0.id == id }
        if !addresses.contains(where: { $0.isDefault }), let firstID = addresses.first?.id {
            setDefaultAddress(firstID)
        }
    }

    func setDefaultAddress(_ id: String) {
        addresses = addresses.map { address in
            var copy = address
            copy.isDefault = address.id == id
            return copy
        }
    }

    func addUserReview(placeID: String, placeName: String, rating: Int, comment: String) {
        userReviews.insert(SpotlyUserReview(id: UUID().uuidString, placeID: placeID, placeName: placeName, rating: rating, comment: comment, createdAt: Date()), at: 0)
        SpotlyHaptics.success()
    }

    func addBusinessEnquiry(_ enquiry: SpotlyBusinessEnquiry) {
        businessEnquiries.insert(enquiry, at: 0)
        SpotlyHaptics.success()
    }

    var upcomingBookings: [SpotlyBooking] { bookings.filter { $0.isUpcoming } }
    var pastBookings: [SpotlyBooking]     { bookings.filter { !$0.isUpcoming } }

    var favouriteBusinesses: [SpotlyBusiness] {
        MockBusinesses.all.filter { favouriteIDs.contains($0.id) }
    }

    // MARK: - Session management

    func signOut() {
        currentUser = nil
        authState = .unauthenticated
        isGuestMode = false
        hasCompletedEntryFlow = false
        selectedTab = .home
        homeNavPath = NavigationPath()
        searchNavPath = NavigationPath()
    }

    func completeProfile(name: String, phone: String, city: String) {
        let cleanedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        selectedCity = city

        if isGuestMode {
            guestProfileName = cleanedName.isEmpty ? "Guest" : cleanedName
            currentUser = SpotlyUser(
                id: "guest",
                name: guestProfileName,
                firstName: guestProfileName.components(separatedBy: " ").first ?? guestProfileName,
                email: "Guest mode",
                phone: phone,
                avatarURL: nil,
                location: city,
                isVerified: false,
                createdAt: Date(),
                favouriteIDs: []
            )
        } else if currentUser != nil {
            currentUser?.name = cleanedName.isEmpty ? currentUser?.name ?? "" : cleanedName
            currentUser?.firstName = currentUser?.name.components(separatedBy: " ").first ?? currentUser?.firstName ?? ""
            currentUser?.phone = phone
            currentUser?.location = city
        }
    }

    func resetOnboarding() {
        hasSeenOnboarding = false
        selectedTab = .home
    }

    func resetEntryFlow() {
        hasCompletedEntryFlow = false
        currentUser = nil
        authState = .unauthenticated
        isGuestMode = false
        selectedTab = .home
    }

    func clearLocalBookingsAndFavourites() {
        favouriteIDs = []
        bookings = []
    }

    func resetDemoData() {
        selectedCity = "Harare"
        favouriteIDs = []
        bookings = MockBookings.all
        orders = [
            SpotlyOrder(id: "ord-001", businessID: "b002", businessName: "The Braai House", itemsSummary: "Chicken combo, sadza & stew", total: 24.49, status: "Preparing", createdAt: Date().addingTimeInterval(-3600)),
            SpotlyOrder(id: "ord-002", businessID: "b009", businessName: "Spar Avondale", itemsSummary: "Bread, milk, eggs, tomatoes", total: 17.50, status: "Out for delivery", createdAt: Date().addingTimeInterval(-86400))
        ]
        addresses = [
            SpotlyAddress(id: "addr-home", label: "Home", line: "Hillside, Bulawayo", city: "Bulawayo", isDefault: true),
            SpotlyAddress(id: "addr-work", label: "Work", line: "Nelson Mandela Avenue, Harare CBD", city: "Harare", isDefault: false)
        ]
        userReviews = []
        businessEnquiries = []
        selectedTab = .home
        SpotlyHaptics.success()
    }

    /// Resets all local onboarding and entry state — does NOT delete any Firebase account.
    func resetForTeamTesting() {
        hasSeenOnboarding = false
        hasCompletedEntryFlow = false
        selectedInterests = []
        selectedCity = "Harare"
        selectedAppearance = "system"
        guestProfileName = "Guest"
        notificationPreference = []
        currentUser = nil
        authState = .unauthenticated
        isGuestMode = false
        favouriteIDs = []
        bookings = MockBookings.all
        orders = [
            SpotlyOrder(id: "ord-001", businessID: "b002", businessName: "The Braai House", itemsSummary: "Chicken combo, sadza & stew", total: 24.49, status: "Preparing", createdAt: Date().addingTimeInterval(-3600)),
            SpotlyOrder(id: "ord-002", businessID: "b009", businessName: "Spar Avondale", itemsSummary: "Bread, milk, eggs, tomatoes", total: 17.50, status: "Out for delivery", createdAt: Date().addingTimeInterval(-86400))
        ]
        addresses = [
            SpotlyAddress(id: "addr-home", label: "Home", line: "Hillside, Bulawayo", city: "Bulawayo", isDefault: true),
            SpotlyAddress(id: "addr-work", label: "Work", line: "Nelson Mandela Avenue, Harare CBD", city: "Harare", isDefault: false)
        ]
        userReviews = []
        businessEnquiries = []
        selectedTab = .home
    }
}
