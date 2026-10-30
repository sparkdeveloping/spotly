import XCTest
@testable import spotly

final class SavedEntityTests: XCTestCase {
    func testEventSearchResultMapsToEventSavedType() {
        let result = RemoteSearchResult(
            id: "event-1", type: "event", entityId: "event-1", businessId: "biz-1", businessName: "Venue",
            title: "Night Market", name: nil, subtitle: "Friday", description: nil, displayCategory: "Events", category: "Events",
            vertical: "events", image: nil, city: "Harare", area: "Avondale", address: nil, currency: "USD", price: 0,
            prices: nil, itemType: "event", startsAt: nil, venue: "Venue", commerceVerified: true, business: nil
        )
        XCTAssertEqual(SavedEntity.from(result).type, .event)
        XCTAssertEqual(SavedEntity.from(result).entityID, "event-1")
    }
}
