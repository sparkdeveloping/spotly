import Foundation

nonisolated enum SpotlyOperationGrantType: String, CaseIterable, Codable, Hashable, Sendable {
    case servicePreview = "service_preview"
    case serviceOperations = "service_operations"
    case paymentSandbox = "payment_sandbox"
    case locationOverride = "location_override"
    case driverOperations = "driver_operations"
}

nonisolated struct SpotlyOperationsContext: Equatable, Hashable, Sendable {
    let servicePreview: Bool
    let serviceOperations: Bool
    let paymentSandbox: Bool
    let locationOverride: Bool
    let driverOperations: Bool

    static let empty = SpotlyOperationsContext(servicePreview: false, serviceOperations: false, paymentSandbox: false, locationOverride: false, driverOperations: false)
}

nonisolated struct SpotlyOperationGrant: Equatable, Hashable, Sendable {
    let id: String
    let type: SpotlyOperationGrantType
    let services: [String]
    let countries: [String]
    let cities: [String]
    let expiresAt: String?
    let reason: String
}

nonisolated struct SpotlyOperationsRideRun: Decodable, Identifiable, Hashable, Sendable {
    let id: String
    let kind: String?
    let operations: Bool?
    let state: String
    let customerId: String?
    let driverId: String?
    let pickup: RidePoint?
    let dropoff: RidePoint?
    let serviceType: String?
    let quote: RideQuote?
}

nonisolated struct SpotlyOperationsRideListResponse: Decodable, Sendable {
    let ok: Bool
    let allowed: Bool
    let canRequest: Bool?
    let canDrive: Bool?
    let myRuns: [SpotlyOperationsRideRun]
    let offers: [SpotlyOperationsRideRun]
}

nonisolated struct SpotlyOperationsRideRequestBody: Encodable, Sendable {
    let action = "request"
    let pickup: RidePoint
    let dropoff: RidePoint
    let serviceType: String
}

nonisolated struct SpotlyOperationsRideMutationResponse: Decodable, Sendable {
    let ok: Bool
    let runId: String
    let state: String
    let operations: Bool
    let quote: RideQuote?
}

nonisolated struct SpotlyOperationsSendRequestBody: Encodable, Sendable {
    let pickup: RidePoint
    let dropoff: RidePoint
    let parcelSize: String
}

nonisolated struct SpotlyOperationsSendResponse: Decodable, Sendable {
    let ok: Bool
    let runId: String
    let state: String
    let operations: Bool
    let quote: ParcelQuote?
}

nonisolated struct SpotlyOperationsCheckoutItem: Encodable, Hashable, Sendable {
    let productId: String
    let quantity: Int
}

nonisolated struct SpotlyOperationsCheckoutRequest: Encodable, Sendable {
    let businessId: String
    let branchId: String
    let currency: String
    let fulfilment: String
    let paymentMethod: String
    let simulatePayment: Bool
    let items: [SpotlyOperationsCheckoutItem]
}

nonisolated struct SpotlyOperationsCheckoutResponse: Decodable, Sendable {
    let ok: Bool
    let operations: Bool
    let runId: String
    let state: String
    let service: String
    let payment: SpotlyOperationsPaymentResult?
}

nonisolated struct SpotlyOperationsPaymentResult: Decodable, Sendable {
    let simulated: Bool
    let charged: Bool
    let providerCalled: Bool
}
