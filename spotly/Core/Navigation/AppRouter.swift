import SwiftUI

enum AppTab: Int, CaseIterable {
    case home, search, bookings, favourites, profile

    var title: String {
        switch self {
        case .home:       return "Home"
        case .search:     return "Search"
        case .bookings:   return "Bookings"
        case .favourites: return "Saved"
        case .profile:    return "Profile"
        }
    }

    var icon: String {
        switch self {
        case .home:       return "house.fill"
        case .search:     return "magnifyingglass"
        case .bookings:   return "calendar"
        case .favourites: return "heart.fill"
        case .profile:    return "person.fill"
        }
    }
}

// MARK: - Navigation routes

enum ProfileSection: String, Hashable {
    case orders, bookings, reviews, favourites, addresses, paymentMethods, promotions, notifications, helpSupport, inviteFriends, privacy, about, settings, city
    case businessInterest, businessEnquiries, terms, preferences
}

enum AppRoute: Hashable {
    case placeDetail(String)
    case category(String)
    case menu(String)
    case checkout(String)
    case bookingFlowID(String)
    case bookingDetail(String)
    case profileSection(ProfileSection)
    case businessDetail(SpotlyBusiness)
    case categoryDiscover(SpotlyCategory)
    case exploreCategories
    case bookingFlow(SpotlyBusiness)
    case bookingConfirmation(SpotlyBooking)
    case eventDetail(SpotlyEvent)
    case restaurantMenu(SpotlyBusiness)
    case myOrders
    case myReviews
    case addresses
    case paymentMethods
    case promotions
    case notifications
    case helpSupport
    case inviteFriends
    case privacyPolicy
    case aboutSpotly
    case settings
    case citySelector
    case businessInterest
    case businessEnquiries
    case terms
    case preferences

    func hash(into hasher: inout Hasher) {
        switch self {
        case .placeDetail(let id):        hasher.combine("place"); hasher.combine(id)
        case .category(let id):           hasher.combine("category"); hasher.combine(id)
        case .menu(let id):               hasher.combine("menuID"); hasher.combine(id)
        case .checkout(let id):           hasher.combine("checkout"); hasher.combine(id)
        case .bookingFlowID(let id):      hasher.combine("bookingFlowID"); hasher.combine(id)
        case .bookingDetail(let id):      hasher.combine("bookingDetail"); hasher.combine(id)
        case .profileSection(let section): hasher.combine("profileSection"); hasher.combine(section.rawValue)
        case .businessDetail(let b):      hasher.combine("biz"); hasher.combine(b.id)
        case .categoryDiscover(let c):    hasher.combine("cat"); hasher.combine(c.id)
        case .exploreCategories:          hasher.combine("exploreCategories")
        case .bookingFlow(let b):         hasher.combine("bkf"); hasher.combine(b.id)
        case .bookingConfirmation(let b): hasher.combine("bkc"); hasher.combine(b.id)
        case .eventDetail(let e):         hasher.combine("evt"); hasher.combine(e.id)
        case .restaurantMenu(let b):      hasher.combine("menu"); hasher.combine(b.id)
        case .myOrders:                   hasher.combine("myOrders")
        case .myReviews:                  hasher.combine("myReviews")
        case .addresses:                  hasher.combine("addresses")
        case .paymentMethods:             hasher.combine("paymentMethods")
        case .promotions:                 hasher.combine("promotions")
        case .notifications:              hasher.combine("notifications")
        case .helpSupport:                hasher.combine("helpSupport")
        case .inviteFriends:              hasher.combine("inviteFriends")
        case .privacyPolicy:              hasher.combine("privacyPolicy")
        case .aboutSpotly:                hasher.combine("aboutSpotly")
        case .settings:                   hasher.combine("settings")
        case .citySelector:               hasher.combine("citySelector")
        case .businessInterest:           hasher.combine("businessInterest")
        case .businessEnquiries:          hasher.combine("businessEnquiries")
        case .terms:                      hasher.combine("terms")
        case .preferences:                hasher.combine("preferences")
        }
    }

    static func == (lhs: AppRoute, rhs: AppRoute) -> Bool {
        switch (lhs, rhs) {
        case (.placeDetail(let a), .placeDetail(let b)),
             (.category(let a), .category(let b)),
             (.menu(let a), .menu(let b)),
             (.checkout(let a), .checkout(let b)),
             (.bookingFlowID(let a), .bookingFlowID(let b)),
             (.bookingDetail(let a), .bookingDetail(let b)):
            return a == b
        case (.profileSection(let a), .profileSection(let b)):
            return a == b
        case (.businessDetail(let a), .businessDetail(let b)):
            return a.id == b.id
        case (.categoryDiscover(let a), .categoryDiscover(let b)):
            return a.id == b.id
        case (.bookingFlow(let a), .bookingFlow(let b)),
             (.restaurantMenu(let a), .restaurantMenu(let b)):
            return a.id == b.id
        case (.bookingConfirmation(let a), .bookingConfirmation(let b)):
            return a.id == b.id
        case (.eventDetail(let a), .eventDetail(let b)):
            return a.id == b.id
        case (.exploreCategories, .exploreCategories),
             (.myOrders, .myOrders),
             (.myReviews, .myReviews),
             (.addresses, .addresses),
             (.paymentMethods, .paymentMethods),
             (.promotions, .promotions),
             (.notifications, .notifications),
             (.helpSupport, .helpSupport),
             (.inviteFriends, .inviteFriends),
             (.privacyPolicy, .privacyPolicy),
             (.aboutSpotly, .aboutSpotly),
             (.settings, .settings),
             (.citySelector, .citySelector),
             (.businessInterest, .businessInterest),
             (.businessEnquiries, .businessEnquiries),
             (.terms, .terms),
             (.preferences, .preferences):
            return true
        default:
            return false
        }
    }
}
