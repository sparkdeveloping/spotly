import Foundation

enum AppTab: Int, CaseIterable, Hashable {
    case home, search, activity, favourites, profile

    var title: String {
        switch self {
        case .home: return "Home"
        case .search: return "Search"
        case .activity: return "Activity"
        case .favourites: return "Saved"
        case .profile: return "Profile"
        }
    }

    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .search: return "magnifyingglass"
        case .activity: return "clock.arrow.circlepath"
        case .favourites: return "heart.fill"
        case .profile: return "person.fill"
        }
    }
}
