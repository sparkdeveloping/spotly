import XCTest
@testable import spotly

@MainActor
final class DeepLinkTests: XCTestCase {
    func testActivityUniversalLinkSelectsActivityTab() {
        let state = AppState()
        let accepted = DeepLinkCoordinator.shared.handle(URL(string: "https://spotlyafrica.com/activity")!, appState: state)
        XCTAssertTrue(accepted)
        XCTAssertEqual(state.selectedTab, .activity)
    }

    func testRideLinkCreatesOperationalDestination() {
        let state = AppState()
        let accepted = DeepLinkCoordinator.shared.handle(URL(string: "https://spotlyafrica.com/ride/ride_123")!, appState: state)
        XCTAssertTrue(accepted)
        XCTAssertEqual(state.selectedTab, .activity)
        XCTAssertNotNil(state.pendingDeepLink)
    }
}

extension DeepLinkTests {
    func testMarketplaceQueryBusinessLinkOpensBusiness() {
        let state = AppState()
        let accepted = DeepLinkCoordinator.shared.handle(URL(string: "https://spotlyafrica.com/marketplace?business=biz_123")!, appState: state)
        XCTAssertTrue(accepted)
        guard case .business(let id) = state.pendingDeepLink?.destination else {
            return XCTFail("Expected business deep link")
        }
        XCTAssertEqual(id, "biz_123")
    }

    func testPaymentReturnUniversalLinkOpensPaymentStatus() {
        let state = AppState()
        let accepted = DeepLinkCoordinator.shared.handle(URL(string: "https://spotlyafrica.com/payment/return?orderId=order_123&client=ios")!, appState: state)
        XCTAssertTrue(accepted)
        XCTAssertEqual(state.selectedTab, .activity)
        guard case .paymentReturn(let id) = state.pendingDeepLink?.destination else {
            return XCTFail("Expected payment return deep link")
        }
        XCTAssertEqual(id, "order_123")
    }

    func testSupportQueryRideLinkOpensRideActivity() {
        let state = AppState()
        let accepted = DeepLinkCoordinator.shared.handle(URL(string: "https://spotlyafrica.com/support?topic=ride&ride=ride_987")!, appState: state)
        XCTAssertTrue(accepted)
        XCTAssertEqual(state.selectedTab, .activity)
        guard case .ride(let id) = state.pendingDeepLink?.destination else {
            return XCTFail("Expected ride deep link")
        }
        XCTAssertEqual(id, "ride_987")
    }
}

extension DeepLinkTests {
    func testRepeatedNotificationParametersDoNotCrashOrChooseConflictingOrder() {
        let state = AppState()
        let link = URL(string: "https://spotlyafrica.com/activity?order=one&ORDER=two")!
        XCTAssertTrue(DeepLinkCoordinator.shared.handle(link, appState: state))
        XCTAssertEqual(state.selectedTab, .activity)
        XCTAssertNil(state.pendingDeepLink)
    }

    func testRepeatedIdenticalIdentifierIsAccepted() {
        let state = AppState()
        let link = URL(string: "https://spotlyafrica.com/marketplace?business=b1&business=b1")!
        XCTAssertTrue(DeepLinkCoordinator.shared.handle(link, appState: state))
        guard case .business(let id) = state.pendingDeepLink?.destination else {
            return XCTFail("Expected business link")
        }
        XCTAssertEqual(id, "b1")
    }

    func testCustomSchemeUsesHostAsFirstRouteComponent() {
        let state = AppState()
        XCTAssertTrue(DeepLinkCoordinator.shared.handle(URL(string: "spotly://ride/ride-123")!, appState: state))
        guard case .ride(let id) = state.pendingDeepLink?.destination else {
            return XCTFail("Expected native ride deep link")
        }
        XCTAssertEqual(id, "ride-123")
    }

    func testConsumerFriendlyServiceAliasesWork() {
        let state = AppState()
        XCTAssertTrue(DeepLinkCoordinator.shared.handle(URL(string: "spotly://bite")!, appState: state))
        guard case .service(.eat) = state.pendingDeepLink?.destination else {
            return XCTFail("Expected Bite service")
        }
        XCTAssertTrue(DeepLinkCoordinator.shared.handle(URL(string: "https://spotlyafrica.com/live")!, appState: state))
        guard case .service(.events) = state.pendingDeepLink?.destination else {
            return XCTFail("Expected Live service")
        }
    }

    func testUntrustedHostsAndInsecureWebLinksAreNotOpenedAsSpotly() {
        let state = AppState()
        XCTAssertFalse(DeepLinkCoordinator.shared.handle(URL(string: "https://spotlyafrica.com.evil.example/ride/id")!, appState: state))
        XCTAssertFalse(DeepLinkCoordinator.shared.handle(URL(string: "http://spotlyafrica.com/ride/id")!, appState: state))
        XCTAssertNil(state.pendingDeepLink)
    }
}
