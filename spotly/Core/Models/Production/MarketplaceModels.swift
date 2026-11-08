import Foundation
import SwiftUI

nonisolated extension SpotlyServiceID: Identifiable {
    var id: String { rawValue }
    // Presentation names follow the web and brand kit. Wire IDs come from SpotlyContracts.swift.
    var title: String {
        switch self {
        case .eat: return "Bite"
        case .shop: return "Shopper"
        case .events: return "Live"
        case .ride: return "Ride"
        case .book: return "Book"
        case .send: return "Send"
        }
    }
    var artworkName: String { "Service_\(title.lowercased())" }
    var subtitle: String {
        switch self {
        case .ride: return "Your next move, made easier."
        case .eat: return "A little more delicious."
        case .shop: return "Good finds. Close by."
        case .book: return "Make room for yourself."
        case .events: return "Be part of the moment."
        case .send: return "From here to their hands."
        }
    }
    var icon: String {
        switch self {
        case .ride: return "car.fill"
        case .eat: return "fork.knife"
        case .shop: return "bag.fill"
        case .book: return "sparkles"
        case .events: return "calendar"
        case .send: return "shippingbox.fill"
        }
    }
    @MainActor var tint: Color {
        switch self {
        case .ride: return Color(hex: "2F80FF")
        case .eat: return Color(hex: "FF8A00")
        case .shop: return Color(hex: "10C981")
        case .book: return Color(hex: "7C3AED")
        case .events: return Color(hex: "FF2D6F")
        case .send: return Color(hex: "A855F7")
        }
    }
}

nonisolated struct RemoteBusiness: Decodable, Identifiable, Hashable, Sendable {
    let id: String
    let name: String?
    let brandName: String?
    let category: String?
    let categories: [String]?
    let city: String?
    let area: String?
    let suburb: String?
    let address: String?
    let tagline: String?
    let description: String?
    let coverImage: String?
    let image: String?
    let logoUrl: String?
    let rating: Double?
    let reviewCount: Int?
    let isFeatured: Bool?
    let commerceVerified: Bool?
    let verificationStatus: String?
    let businessType: String?
    let capabilities: [String]?
    let latitude: Double?
    let longitude: Double?
    let operational: BusinessOperational?
    let promotion: RemotePromotion?

    var displayName: String { name?.nonEmpty ?? brandName?.nonEmpty ?? "Spotly place" }
    var displayCategory: String { category?.nonEmpty ?? categories?.first?.nonEmpty ?? "Local place" }
    var displayLocation: String { AddressFormatter.joined([area, city]) }
    var imageURL: URL? { RemoteMedia.url(coverImage?.nonEmpty ?? image?.nonEmpty ?? logoUrl?.nonEmpty) }
    var isCommerceVerified: Bool { commerceVerified == true }
    var isProfileVerified: Bool { verificationStatus?.lowercased() == "verified" || commerceVerified == true }
}

nonisolated struct BusinessOperational: Decodable, Hashable, Sendable {
    let openNow: Bool?
    let pickupAvailable: Bool?
    let deliveryAvailable: Bool?
    let earliestPickup: String?
    let deliveryFeeFrom: Double?
    let locationCount: Int?
}

nonisolated struct RemotePromotion: Decodable, Hashable, Sendable {
    let id: String?
    let name: String?
    let label: String?
    let type: String?
    let value: Double?
}

nonisolated struct RemoteBranch: Decodable, Identifiable, Hashable, Sendable {
    let id: String
    let businessId: String?
    let branchName: String?
    let name: String?
    let city: String?
    let suburb: String?
    let area: String?
    let address: String?
    let phone: String?
    let status: String?
    let fulfilment: [String]?
    let paymentMethods: [String]?
    let acceptedCurrencies: [String]?
    let delivery: BranchDelivery?
    let location: RemoteCoordinate?

    var displayName: String { branchName?.nonEmpty ?? name?.nonEmpty ?? "Location" }
}

nonisolated struct BranchDelivery: Decodable, Hashable, Sendable {
    let enabled: Bool?
    let paused: Bool?
    let fee: Double?
    let radiusKm: Double?
}

nonisolated struct RemoteCoordinate: Codable, Hashable, Sendable {
    let lat: Double
    let lng: Double
}

nonisolated struct RemoteItem: Decodable, Identifiable, Hashable, Sendable {
    let id: String
    let entityId: String?
    let type: String?
    let businessId: String?
    let businessName: String?
    let name: String?
    let title: String?
    let description: String?
    let category: String?
    let image: String?
    let brand: String?
    let variant: String?
    let packSize: String?
    let unit: String?
    let currency: String?
    let price: Double?
    let prices: [String: Double]?
    let compareAtPrice: Double?
    let stockStatus: String?
    let stockQuantity: Double?
    let available: Bool?
    let itemType: String?
    let durationMinutes: Int?
    let capacity: Int?
    let remainingCapacity: Int?
    let startsAt: String?
    let endsAt: String?
    let venue: String?
    let city: String?
    let area: String?
    let tags: [String]?
    let isFeatured: Bool?
    let maxQuantity: Int?
    let pickupEligible: Bool?
    let published: Bool?
    let promotion: RemotePromotion?
    let business: RemoteBusiness?

    var displayName: String { title?.nonEmpty ?? name?.nonEmpty ?? "Offering" }
    var displaySubtitle: String { [brand?.nonEmpty, variant?.nonEmpty, packSize?.nonEmpty].compactMap { $0 }.joined(separator: " · ") }
    var imageURL: URL? { RemoteMedia.url(image) }
    func price(in preferred: String = "USD") -> Double { prices?[preferred] ?? price ?? 0 }
    func currencyFor(_ preferred: String = "USD") -> String { prices?[preferred] != nil ? preferred : (currency ?? preferred) }
}

nonisolated extension RemoteItem {
    /// Client-side presentation guard only. The existing server remains
    /// authoritative about inventory, booking slots and payment amounts.
    func checkoutUnavailableReason(for service: SpotlyServiceKind) -> String? {
        if published == false || available == false { return "Currently unavailable" }
        if let maximum = maxQuantity, maximum <= 0 { return "Currently unavailable" }
        if (service == .events || service == .book), let remainingCapacity, remainingCapacity <= 0 {
            return "Fully booked"
        }
        if service == .eat || service == .shop {
            if let stockQuantity, stockQuantity < 1 { return "Out of stock" }
            if price(in: "USD") <= 0 { return "Price unavailable" }
        }
        return nil
    }
}

nonisolated struct ServiceFeedResponse: Decodable, Sendable {
    let ok: Bool
    let service: String?
    let city: String?
    let area: String?
    let query: String?
    let businesses: [RemoteBusiness]
    let items: [RemoteItem]
    let categories: [String]
    let facets: ServiceFacets?
    let totalBusinesses: Int?
    let totalItems: Int?
    let nextOffset: Int?
}

nonisolated struct ServiceFacets: Decodable, Hashable, Sendable {
    let openNow: Int?
    let pickup: Int?
    let delivery: Int?
    let featuredBusinesses: Int?
    let deals: Int?
    let freeEvents: Int?
}

nonisolated struct SearchResponse: Decodable, Sendable {
    let ok: Bool
    let results: [RemoteSearchResult]
    let total: Int?
    let nextOffset: Int?
}

nonisolated struct RemoteSearchResult: Decodable, Identifiable, Hashable, Sendable {
    let id: String
    let type: String?
    let entityId: String?
    let businessId: String?
    let businessName: String?
    let title: String?
    let name: String?
    let subtitle: String?
    let description: String?
    let displayCategory: String?
    let category: String?
    let vertical: String?
    let image: String?
    let city: String?
    let area: String?
    let address: String?
    let currency: String?
    let price: Double?
    let prices: [String: Double]?
    let itemType: String?
    let startsAt: String?
    let venue: String?
    let commerceVerified: Bool?
    let business: RemoteBusiness?

    var resultIdentity: String { "\(type ?? "business"):\(entityID)" }
    var entityID: String { entityId?.nonEmpty ?? id }
    var displayTitle: String { title?.nonEmpty ?? name?.nonEmpty ?? "Spotly result" }
    var imageURL: URL? { RemoteMedia.url(image?.nonEmpty ?? business?.coverImage?.nonEmpty ?? business?.image?.nonEmpty) }
    var savedType: SavedEntityType {
        switch type?.lowercased() {
        case "business": return .business
        case "product": return .product
        case "service": return .service
        case "event": return .event
        default: return .place
        }
    }
}

nonisolated struct BusinessDetailResponse: Decodable, Sendable {
    let ok: Bool
    let business: RemoteBusiness
    let branches: [RemoteBranch]
    let products: [RemoteItem]
    let transactional: Bool
    let claimAvailable: Bool?
}

nonisolated struct GeocodeResponse: Decodable, Sendable {
    let ok: Bool
    let results: [GeocodeResult]
}

nonisolated struct GeocodeResult: Decodable, Identifiable, Hashable, Sendable {
    let id: String
    let label: String
    let lat: Double
    let lng: Double
    let area: String?
    let city: String?
    let country: SpotlyCountryCode

    var point: RidePoint { RidePoint(lat: lat, lng: lng, accuracy: nil, country: country, label: label, formattedAddress: label, area: area, city: city) }
}

enum SavedEntityType: String, Codable, CaseIterable, Hashable {
    case business, product, service, event, place
}

nonisolated struct SavedEntity: Identifiable, Hashable, Sendable {
    var id: String { "\(type.rawValue):\(entityID)" }
    let type: SavedEntityType
    let entityID: String
    let businessID: String?
    let title: String
    let subtitle: String
    let imageURL: URL?
    let city: String?
    let area: String?
    var address: String? = nil
}

nonisolated extension SavedEntity {
    static func from(_ result: RemoteSearchResult) -> SavedEntity {
        SavedEntity(type: result.savedType, entityID: result.entityID, businessID: result.businessId, title: result.displayTitle, subtitle: result.subtitle ?? result.displayCategory ?? "", imageURL: result.imageURL, city: result.city, area: result.area)
    }

    static func from(_ item: RemoteItem, type: SavedEntityType? = nil) -> SavedEntity {
        let resolved: SavedEntityType = type ?? (item.type == "event" || item.itemType == "event" ? .event : item.type == "service" ? .service : .product)
        return SavedEntity(type: resolved, entityID: item.id, businessID: item.businessId, title: item.displayName, subtitle: item.businessName ?? item.category ?? "", imageURL: item.imageURL, city: item.city, area: item.area)
    }
}

extension String {
    nonisolated fileprivate var nonEmpty: String? {
        let value = trimmingCharacters(in: .whitespacesAndNewlines)
        return value.isEmpty ? nil : value
    }
}
