import Foundation

struct SpotlyLocation: Codable, Equatable {
    let latitude: Double
    let longitude: Double
    let address: String
    let area: String
    let city: String

    var displayName: String { "\(area), \(city)" }
    var shortDisplay: String { area }

    static let harare = SpotlyLocation(latitude: -17.8252, longitude: 31.0335,
        address: "Harare, Zimbabwe", area: "Harare", city: "Harare")
    static let borrowdale = SpotlyLocation(latitude: -17.7668, longitude: 31.0906,
        address: "Borrowdale, Harare", area: "Borrowdale", city: "Harare")
    static let avondale = SpotlyLocation(latitude: -17.8050, longitude: 31.0232,
        address: "Avondale, Harare", area: "Avondale", city: "Harare")
    static let highlands = SpotlyLocation(latitude: -17.8105, longitude: 31.0583,
        address: "Highlands, Harare", area: "Highlands", city: "Harare")
    static let samLevys = SpotlyLocation(latitude: -17.7703, longitude: 31.0872,
        address: "Sam Levy's Village, Borrowdale", area: "Sam Levy's", city: "Harare")
    static let newlands = SpotlyLocation(latitude: -17.8015, longitude: 31.0441,
        address: "Newlands, Harare", area: "Newlands", city: "Harare")
    static let bulawayo = SpotlyLocation(latitude: -20.1325, longitude: 28.6265,
        address: "Bulawayo, Zimbabwe", area: "Bulawayo", city: "Bulawayo")
    static let victoriaFalls = SpotlyLocation(latitude: -17.9243, longitude: 25.8572,
        address: "Victoria Falls, Zimbabwe", area: "Victoria Falls", city: "Victoria Falls")
    static let mutare = SpotlyLocation(latitude: -18.9707, longitude: 32.6709,
        address: "Nyanga / Mutare region", area: "Nyanga", city: "Mutare")
}
