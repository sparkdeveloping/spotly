import Foundation

struct SpotlyService: Identifiable, Codable {
    let id: String
    var name: String
    var description: String
    var duration: Int
    var price: Double
    var currency: String
    var category: String?

    var durationText: String {
        if duration >= 60 {
            let hours = duration / 60
            let mins  = duration % 60
            return mins > 0 ? "\(hours)h \(mins)min" : "\(hours)h"
        }
        return "\(duration)min"
    }

    var priceText: String { "\(currency)\(String(format: "%.0f", price))" }
}
