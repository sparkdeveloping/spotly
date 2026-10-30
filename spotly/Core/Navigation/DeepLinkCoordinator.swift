import Foundation

struct DeepLinkRoute: Identifiable, Hashable {
    enum Destination: Hashable {
        case business(String)
        case item(String, title: String?)
        case order(String)
        case ride(String)
        case send(String)
        case service(SpotlyServiceKind)
        case support
        case notifications
        case paymentReturn(String)
    }

    let id = UUID()
    let destination: Destination
}

@MainActor
final class DeepLinkCoordinator {
    static let shared = DeepLinkCoordinator()
    private init() {}

    @discardableResult
    func handle(_ url: URL, appState: AppState) -> Bool {
        guard isSpotlyURL(url) else { return false }
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        // A real universal link can repeat a query key. Dictionary(uniqueKeysWithValues:)
        // traps on duplicates, which previously crashed Spotly from a notification.
        // Conflicting identifiers are ignored instead of arbitrarily targeting a record.
        let query = Self.safeQuery(urlComponents?.queryItems ?? [])
        let customScheme = ["spotly", "spotlyafrica"].contains(url.scheme?.lowercased() ?? "")
        // For spotly://ride/id the URL host is "ride" (not part of pathComponents).
        let components = (customScheme ? (url.host.map { [$0] } ?? []) : [])
            + url.pathComponents.filter { $0 != "/" }
        let first = components.first?.lowercased() ?? ""
        let second = components.dropFirst().first

        // Current Spotly web frequently encodes customer destinations in query parameters.
        // Resolve these before path routing so web links, notifications and payment returns
        // land on the same native object instead of a generic Home screen.
        if first == "payment", second?.lowercased() == "return", let orderID = query["orderid"], !orderID.isEmpty {
            appState.selectedTab = .activity
            appState.pendingDeepLink = DeepLinkRoute(destination: .paymentReturn(orderID))
            return true
        }
        if let orderID = query["order"], !orderID.isEmpty {
            appState.selectedTab = .activity
            appState.pendingDeepLink = DeepLinkRoute(destination: .order(orderID))
            return true
        }
        if let rideID = query["ride"], !rideID.isEmpty {
            appState.selectedTab = .activity
            appState.pendingDeepLink = DeepLinkRoute(destination: .ride(rideID))
            return true
        }
        if let parcelID = query["parcel"], !parcelID.isEmpty {
            appState.selectedTab = .activity
            appState.pendingDeepLink = DeepLinkRoute(destination: .send(parcelID))
            return true
        }
        if let businessID = query["business"], !businessID.isEmpty {
            if let offerID = query["offer"], !offerID.isEmpty {
                appState.pendingDeepLink = DeepLinkRoute(destination: .item(offerID, title: nil))
            } else {
                appState.pendingDeepLink = DeepLinkRoute(destination: .business(businessID))
            }
            return true
        }
        if let serviceName = query["service"], let service = Self.service(named: serviceName) {
            appState.pendingDeepLink = DeepLinkRoute(destination: .service(service))
            return true
        }
        if query["view"]?.lowercased() == "activity" {
            appState.selectedTab = .activity
            appState.pendingDeepLink = nil
            return true
        }

        switch first {
        case "", "home", "marketplace":
            appState.selectedTab = .home
            appState.pendingDeepLink = nil
        case "search":
            appState.selectedTab = .search
            appState.pendingDeepLink = nil
        case "activity":
            appState.selectedTab = .activity
            appState.pendingDeepLink = nil
        case "saved":
            appState.selectedTab = .favourites
            appState.pendingDeepLink = nil
        case "account", "profile":
            appState.selectedTab = .profile
            appState.pendingDeepLink = nil
        case "notifications":
            appState.selectedTab = .profile
            appState.pendingDeepLink = DeepLinkRoute(destination: .notifications)
        case "support", "help":
            appState.selectedTab = .profile
            appState.pendingDeepLink = DeepLinkRoute(destination: .support)
        case "place", "business":
            guard let second else { return false }
            appState.pendingDeepLink = DeepLinkRoute(destination: .business(second))
        case "item":
            guard let second else { return false }
            let title = urlComponents?.queryItems?.first(where: { $0.name == "title" })?.value
            appState.pendingDeepLink = DeepLinkRoute(destination: .item(second, title: title))
        case "order":
            guard let second else { return false }
            appState.selectedTab = .activity
            appState.pendingDeepLink = DeepLinkRoute(destination: .order(second))
        case "ride":
            if let second, !second.isEmpty {
                appState.selectedTab = .activity
                appState.pendingDeepLink = DeepLinkRoute(destination: .ride(second))
            } else {
                appState.pendingDeepLink = DeepLinkRoute(destination: .service(.ride))
            }
        case "send":
            if let second, !second.isEmpty {
                appState.selectedTab = .activity
                appState.pendingDeepLink = DeepLinkRoute(destination: .send(second))
            } else {
                appState.pendingDeepLink = DeepLinkRoute(destination: .service(.send))
            }
        case "eat", "bite", "shop", "shopper", "book", "events", "live":
            guard let service = Self.service(named: first) else { return false }
            appState.pendingDeepLink = DeepLinkRoute(destination: .service(service))
        default:
            return false
        }
        return true
    }

    private static func service(named name: String) -> SpotlyServiceKind? {
        switch name.lowercased() {
        case "bite": return .eat
        case "shopper": return .shop
        case "live": return .events
        default: return SpotlyServiceKind(rawValue: name.lowercased())
        }
    }

    private static func safeQuery(_ items: [URLQueryItem]) -> [String: String] {
        var result: [String: String] = [:]
        var conflicting = Set<String>()
        for item in items {
            let key = item.name.lowercased()
            guard let value = item.value?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !value.isEmpty, value.count <= 180, !conflicting.contains(key) else { continue }
            if let existing = result[key], existing != value {
                result.removeValue(forKey: key)
                conflicting.insert(key)
            } else {
                result[key] = value
            }
        }
        return result
    }

    private func isSpotlyURL(_ url: URL) -> Bool {
        let scheme = url.scheme?.lowercased() ?? ""
        if ["spotly", "spotlyafrica"].contains(scheme) { return true }
        guard scheme == "https", let host = url.host?.lowercased() else { return false }
        return host == "spotlyafrica.com" || host.hasSuffix(".spotlyafrica.com")
    }
}
