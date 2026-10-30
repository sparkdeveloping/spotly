import Foundation

enum PromotionType: String, Codable {
    case discount, freeItem, bundleDeal, newMember
}

struct SpotlyPromotion: Identifiable, Codable {
    let id: String
    var title: String
    var description: String
    var code: String
    var discountValue: Double
    var discountType: String
    var expiresAt: Date
    var type: PromotionType
    var businessID: String?
    var isActive: Bool

    var displayValue: String {
        discountType == "percentage"
            ? "\(Int(discountValue))% off"
            : "$\(String(format: "%.0f", discountValue)) off"
    }
}
