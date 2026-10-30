import Foundation

struct SpotlyReview: Identifiable, Codable {
    let id: String
    var authorName: String
    var authorInitials: String
    var rating: Double
    var comment: String
    var date: Date
    var verified: Bool
    var helpfulCount: Int

    var formattedDate: String {
        let f = RelativeDateTimeFormatter()
        f.unitsStyle = .abbreviated
        return f.localizedString(for: date, relativeTo: Date())
    }
}
