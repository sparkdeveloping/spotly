import XCTest
@testable import spotly

final class PaymentContractTests: XCTestCase {
    func testPaynowStatusPaidResponseDecodes() throws {
        let data = Data(#"{"ok":true,"orderId":"order_1","state":"paid","paid":true,"providerStatus":"Paid","transactionType":"ticket","fulfilment":null,"businessName":"Spotly Events","number":"SP-1"}"#.utf8)
        let value = try JSONDecoder().decode(PaynowStatusResponse.self, from: data)
        XCTAssertTrue(value.isPaid)
        XCTAssertEqual(value.orderId, "order_1")
        XCTAssertEqual(value.transactionType, "ticket")
    }

    func testPaynowStatusUnpaidResponseWithoutProviderFieldsDecodes() throws {
        let data = Data(#"{"ok":true,"orderId":"order_2","state":"unpaid","transactionType":"order","fulfilment":"delivery","businessName":"Merchant","number":"SP-2"}"#.utf8)
        let value = try JSONDecoder().decode(PaynowStatusResponse.self, from: data)
        XCTAssertFalse(value.isPaid)
        XCTAssertNil(value.providerStatus)
    }
}
