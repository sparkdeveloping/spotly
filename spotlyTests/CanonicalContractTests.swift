import XCTest
@testable import spotly

final class CanonicalContractTests: XCTestCase {
    func testCanonicalWireIdentifiersRemainStable() {
        XCTAssertEqual(SpotlyContractMetadata.version, "1.0.0")
        XCTAssertEqual(SpotlyContractMetadata.manifestSHA256.count, 64)
        XCTAssertEqual(SpotlyServiceID.allCases.map(\.rawValue), ["eat", "shop", "ride", "book", "events", "send"])
        XCTAssertEqual(SpotlyCountryCode.allCases.map(\.rawValue), ["ZW", "MW"])
        XCTAssertTrue(SpotlyPaymentMethod.allCases.contains(.payLater))
        XCTAssertTrue(SpotlyActivityKind.allCases.contains(.assistShopping))
        XCTAssertTrue(SpotlyActivityKind.allCases.contains(.assistBooking))
    }

    func testRideRequestEncodesCountryAndQuoteLock() throws {
        let pickup = RidePoint(lat: -17.8252, lng: 31.0335, country: .ZW, label: "Harare", formattedAddress: "Harare", area: "CBD", city: "Harare")
        let dropoff = RidePoint(lat: -17.79, lng: 31.04, country: .ZW, label: "Avondale", formattedAddress: "Avondale", area: "Avondale", city: "Harare")
        let body = RideRequestBody(pickup: pickup, dropoff: dropoff, serviceType: .economy, paymentMethod: .cash, quotedTotal: 7.5, quotedCurrency: .USD, riderName: nil, riderPhone: nil, note: nil)
        let object = try XCTUnwrap(JSONSerialization.jsonObject(with: JSONEncoder().encode(body)) as? [String: Any])
        XCTAssertEqual((object["pickup"] as? [String: Any])?["country"] as? String, "ZW")
        XCTAssertEqual(object["quotedTotal"] as? Double, 7.5)
        XCTAssertEqual(object["quotedCurrency"] as? String, "USD")
    }

    func testSendRequestEncodesCountryAndQuoteLock() throws {
        let point = RidePoint(lat: -17.8252, lng: 31.0335, country: .ZW, label: "Harare", formattedAddress: "Harare", area: "CBD", city: "Harare")
        let body = ParcelRequestBody(pickup: point, dropoff: point, parcelSize: .medium, paymentMethod: .cash, senderName: "Sender", senderPhone: "+263771234567", recipientName: "Recipient", recipientPhone: "+263772345678", parcelDescription: "Documents", estimatedWeightKg: nil, declaredValue: nil, instructions: nil, pickupMode: .now, scheduledPickupAt: nil, quotedTotal: 5, quotedCurrency: .USD)
        let object = try XCTUnwrap(JSONSerialization.jsonObject(with: JSONEncoder().encode(body)) as? [String: Any])
        XCTAssertEqual((object["pickup"] as? [String: Any])?["country"] as? String, "ZW")
        XCTAssertEqual(object["quotedTotal"] as? Double, 5)
        XCTAssertEqual(object["quotedCurrency"] as? String, "USD")
    }

    func testBookTransactionSupportsCanonicalPayLater() throws {
        let body = CustomerTransactionCreateBody(checkoutId: "checkout_book_001", businessId: "business_1", branchId: "branch_1", itemId: "service_1", quantity: 1, currency: .USD, promoCode: nil, paymentMethod: .payLater, contactName: "Tariro Moyo", contactPhone: "+263771234567", notes: nil, appointment: .init(date: "2026-11-20", time: "14:30", staffPreference: nil), booking: nil)
        let object = try XCTUnwrap(JSONSerialization.jsonObject(with: JSONEncoder().encode(body)) as? [String: Any])
        XCTAssertEqual(object["paymentMethod"] as? String, "pay_later")
        XCTAssertEqual(object["currency"] as? String, "USD")
    }

    func testActivityDecodesAssistKindsAndNullableCurrency() throws {
        let json = #"{"id":"assist-booking:1","kind":"assist_booking","service":"book","title":"Booking help","subtitle":"Availability check","state":"alternative_offered","paymentStatus":"not_initiated","number":"1","total":null,"currency":null,"createdAt":null,"scheduledAt":null,"attentionReason":"Review a suggested time","primaryAction":"review_alternative","orderId":null,"rideId":null,"parcelId":null}"#.data(using: .utf8)!
        let record = try JSONDecoder().decode(ActivityRecord.self, from: json)
        XCTAssertEqual(record.kind, .assistBooking)
        XCTAssertNil(record.currency)
        XCTAssertEqual(record.primaryAction, .reviewAlternative)
        XCTAssertEqual(record.section, .attention)
    }

    func testMalawiGeocodeResultCarriesCountry() throws {
        let data = #"{"id":"mw","label":"Lilongwe","area":"City Centre","city":"Lilongwe","country":"MW","lat":-13.9626,"lng":33.7741}"#.data(using: .utf8)!
        let result = try JSONDecoder().decode(GeocodeResult.self, from: data)
        XCTAssertEqual(result.country, .MW)
        XCTAssertEqual(result.point.country, .MW)
    }
}
