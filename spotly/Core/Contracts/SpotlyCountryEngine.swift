import Foundation

nonisolated enum SpotlyCountryEngine {
    static func definition(for code: SpotlyCountryCode?) -> SpotlyCountryDefinition? {
        guard let code else { return nil }
        return SpotlyCountryCatalog.countries.first(where: { $0.code == code })
    }

    static func country(latitude: Double, longitude: Double) -> SpotlyCountryCode? {
        SpotlyCountryCatalog.country(latitude: latitude, longitude: longitude)
    }

    static func normalizePhone(_ value: String, country code: SpotlyCountryCode) throws -> String {
        let country = SpotlyCountryCatalog.definition(for: code)
        let raw = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !raw.isEmpty else { return "" }
        var digits = raw.filter(\.isNumber)
        let dialDigits = country.dialCode.filter(\.isNumber)
        if digits.hasPrefix("00") { digits.removeFirst(2) }
        if digits.hasPrefix(dialDigits) { digits.removeFirst(dialDigits.count) }
        if digits.hasPrefix("0") { digits.removeFirst() }
        guard digits.count >= country.phone.nationalMinDigits,
              digits.count <= country.phone.nationalMaxDigits else {
            throw NSError(domain: "SpotlyCountry", code: 1, userInfo: [NSLocalizedDescriptionKey: "Enter a valid \(country.name) phone number."])
        }
        return country.dialCode + digits
    }

    static func city(named value: String, in code: SpotlyCountryCode) -> SpotlyCountryCity? {
        let clean = value.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !clean.isEmpty else { return nil }
        return SpotlyCountryCatalog.definition(for: code).cities.first { $0.id == clean || $0.name.lowercased() == clean }
    }
}
