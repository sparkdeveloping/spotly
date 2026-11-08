import Foundation

nonisolated struct SpotlyUser: Identifiable, Codable, Sendable {
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
    var countryCode: SpotlyCountryCode? = nil
    var countryOverrideCode: SpotlyCountryCode? = nil
    var countrySource: String? = nil
    var preferredCity: String = ""

    var effectiveCountryCode: SpotlyCountryCode? { countryOverrideCode ?? countryCode }

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
