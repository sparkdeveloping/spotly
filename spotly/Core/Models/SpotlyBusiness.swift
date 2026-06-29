import Foundation

enum BusinessStatus: String, Codable {
    case open, closed, openingSoon

    var displayText: String {
        switch self {
        case .open:        return "Open now"
        case .closed:      return "Closed"
        case .openingSoon: return "Opening soon"
        }
    }
}

struct SpotlyBusiness: Identifiable, Codable {
    let id: String
    var name: String
    var tagline: String
    var description: String
    var categoryID: String
    var categoryName: String
    var location: SpotlyLocation
    var rating: Double
    var reviewCount: Int
    var priceLevel: Int
    var distance: String?
    var imageURLs: [String]
    var gradientKey: String
    var status: BusinessStatus
    var openingHours: String
    var phone: String?
    var isVerified: Bool
    var isFeatured: Bool
    var tags: [String]
    var services: [SpotlyService]
    var reviews: [SpotlyReview]
    var highlights: [String]

    var priceLevelText: String { String(repeating: "$", count: priceLevel) }
    var ratingFormatted: String { String(format: "%.1f", rating) }
}
