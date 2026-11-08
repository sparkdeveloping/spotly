import XCTest
@testable import spotly

final class CountryEngineTests: XCTestCase {
    func testCountryCatalogIsVersionedAndContainsZimbabweAndMalawi() {
        XCTAssertEqual(SpotlyCountryContractMetadata.version, "1.0.0")
        XCTAssertEqual(SpotlyCountryContractMetadata.manifestSHA256.count, 64)
        XCTAssertEqual(SpotlyCountryCatalog.countries.map(\.code), [.ZW, .MW])
        XCTAssertEqual(SpotlyCountryCatalog.definition(for: .ZW).timeZone, "Africa/Harare")
        XCTAssertEqual(SpotlyCountryCatalog.definition(for: .MW).timeZone, "Africa/Blantyre")
        XCTAssertEqual(SpotlyCountryCatalog.definition(for: .ZW).currencyPriority, [.USD, .ZWG])
        XCTAssertEqual(SpotlyCountryCatalog.definition(for: .MW).currencyPriority, [.MWK])
    }

    func testCoordinatesOnlyInferSupportedCountries() {
        XCTAssertEqual(SpotlyCountryEngine.country(latitude: -17.8252, longitude: 31.0335), .ZW)
        XCTAssertEqual(SpotlyCountryEngine.country(latitude: -13.9626, longitude: 33.7741), .MW)
        XCTAssertNil(SpotlyCountryEngine.country(latitude: 0, longitude: 0))
    }

    func testCountryAwarePhoneNormalization() throws {
        XCTAssertEqual(try SpotlyCountryEngine.normalizePhone("0771234567", country: .ZW), "+263771234567")
        XCTAssertEqual(try SpotlyCountryEngine.normalizePhone("0991234567", country: .MW), "+265991234567")
        XCTAssertThrowsError(try SpotlyCountryEngine.normalizePhone("077", country: .ZW))
    }

    func testCitiesAreCountryScoped() {
        XCTAssertEqual(SpotlyCountryEngine.city(named: "Harare", in: .ZW)?.id, "harare")
        XCTAssertNil(SpotlyCountryEngine.city(named: "Harare", in: .MW))
        XCTAssertEqual(SpotlyCountryEngine.city(named: "Lilongwe", in: .MW)?.id, "lilongwe")
        XCTAssertNil(SpotlyCountryEngine.city(named: "Lilongwe", in: .ZW))
    }
}
