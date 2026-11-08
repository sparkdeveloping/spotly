import XCTest
@testable import spotly

final class FirebasePlatformFoundationTests: XCTestCase {
    func testFirebasePlatformRoutingMatchesSpotlyAfricaFoundation() {
        XCTAssertEqual(FirebasePlatform.functionsRegion, "europe-west1")
        XCTAssertEqual(FirebasePlatform.databaseURL, "https://spotly-africa-default-rtdb.europe-west1.firebasedatabase.app")
        XCTAssertEqual(SpotlyConfiguration.firebaseProjectID, "spotly-africa")
    }
}
