import Foundation

enum SpotlyBookingStatus: String, Codable {
    case draft, pending, confirmed, cancelled, completed, failed

    var displayText: String {
        switch self {
        case .draft:     return "Draft"
        case .pending:   return "Pending"
        case .confirmed: return "Confirmed"
        case .cancelled: return "Cancelled"
        case .completed: return "Completed"
        case .failed:    return "Failed"
        }
    }

    var isActive: Bool { self == .confirmed || self == .pending }
}

enum SpotlyPaymentStatus: String, Codable {
    case unpaid, pending, paid, refunded
}

struct SpotlyBooking: Identifiable, Codable {
    let id: String
    var businessID: String
    var businessName: String
    var businessCategory: String
    var gradientKey: String
    var serviceName: String
    var date: Date
    var time: String
    var duration: Int
    var price: Double
    var currency: String
    var status: SpotlyBookingStatus
    var paymentStatus: SpotlyPaymentStatus
    var notes: String?
    var createdAt: Date
    var location: SpotlyLocation
    var confirmationCode: String

    var formattedDate: String {
        let f = DateFormatter()
        f.dateFormat = "EEEE, MMMM d"
        return f.string(from: date)
    }
    var formattedPrice: String { "\(currency)\(String(format: "%.0f", price))" }
    var isUpcoming: Bool { date > Date() && status.isActive }
}
