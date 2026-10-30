import XCTest
@testable import spotly

final class ActivityStateTests: XCTestCase {
    func testUnpaidActivityNeedsAttention() {
        let record = ActivityRecord(id: "1", kind: .order, title: "Order", subtitle: "", state: "submitted", paymentStatus: "unpaid", number: "S1", total: 10, currency: "USD", createdAt: nil, orderId: "1", rideId: nil, parcelId: nil)
        XCTAssertEqual(record.section, .attention)
    }

    func testCompletedActivityIsPast() {
        let record = ActivityRecord(id: "1", kind: .ride, title: "Ride", subtitle: "", state: "completed", paymentStatus: "paid", number: "R1", total: 5, currency: "USD", createdAt: nil, orderId: nil, rideId: "1", parcelId: nil)
        XCTAssertEqual(record.section, .past)
    }

    func testConfirmedBookingIsUpcoming() {
        let record = ActivityRecord(id: "1", kind: .booking, title: "Booking", subtitle: "", state: "confirmed", paymentStatus: "paid", number: "B1", total: 20, currency: "USD", createdAt: nil, orderId: "1", rideId: nil, parcelId: nil)
        XCTAssertEqual(record.section, .upcoming)
    }
}
