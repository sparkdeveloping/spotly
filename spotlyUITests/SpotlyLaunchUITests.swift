import XCTest

final class SpotlyLaunchUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testAppLaunchesIntoCustomerExperience() throws {
        let app = XCUIApplication()
        app.launchArguments += ["-hasSeenOnboarding", "NO"]
        app.launch()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 8))

        let continueButton = app.buttons["Continue"]
        XCTAssertTrue(continueButton.waitForExistence(timeout: 8))
        continueButton.tap()
        XCTAssertTrue(app.staticTexts["Zimbabwe, made more useful."].waitForExistence(timeout: 8))

        continueButton.tap()
        XCTAssertTrue(app.staticTexts["One place for what’s happening."].waitForExistence(timeout: 8))

        continueButton.tap()
        XCTAssertTrue(app.staticTexts["Built for real transactions."].waitForExistence(timeout: 8))
        XCTAssertTrue(app.buttons["Get started"].exists)
        XCTAssertEqual(app.state, .runningForeground)
    }
}
