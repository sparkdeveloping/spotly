import Foundation

struct SpotlyUser: Identifiable, Codable {
    let id: String
    var name: String
    var firstName: String
    var email: String
    var phone: String
    var avatarURL: String?
    var location: String
    var isVerified: Bool
    var createdAt: Date
    var favouriteIDs: [String]

    static let preview = SpotlyUser(
        id: "user_001",
        name: "Tinashe Moyo",
        firstName: "Tinashe",
        email: "tinashe@example.com",
        phone: "+263 77 123 4567",
        avatarURL: nil,
        location: "Harare",
        isVerified: true,
        createdAt: Date(),
        favouriteIDs: []
    )
}
