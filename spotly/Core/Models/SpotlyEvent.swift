import Foundation

struct SpotlyEvent: Identifiable, Codable {
    let id: String
    var name: String
    var description: String
    var venue: String
    var location: SpotlyLocation
    var startDate: Date
    var endDate: Date
    var price: Double?
    var currency: String
    var imageURLs: [String]
    var gradientKey: String
    var categoryID: String
    var attendeeCount: Int
    var isAvailable: Bool
    var tags: [String]
    var isFeatured: Bool

    var formattedDate: String {
        let f = DateFormatter()
        f.dateFormat = "EEE, MMM d"
        return f.string(from: startDate)
    }

    var formattedTime: String {
        let f = DateFormatter()
        f.dateFormat = "h:mm a"
        return f.string(from: startDate)
    }

    var priceText: String {
        guard let price else { return "Free" }
        return price == 0 ? "Free" : "\(currency)\(String(format: "%.0f", price))"
    }
}
