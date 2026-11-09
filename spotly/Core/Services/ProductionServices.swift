import Foundation

actor SpotlyCommerceService {
    static let shared = SpotlyCommerceService()
    private let api = APIClient.shared

    func createOrder(_ body: CommerceOrderCreateBody) async throws -> CommerceOrderCreateResponse {
        try await api.post("/api/orders/create", body: body, authenticated: true)
    }

    func createTransaction(_ body: CustomerTransactionCreateBody) async throws -> CustomerTransactionCreateResponse {
        try await api.post("/api/customer/transactions/create", body: body, authenticated: true)
    }

    func initiatePaynow(orderId: String, channel: String = "web", phone: String? = nil) async throws -> PaynowInitiateResponse {
        try await api.post("/api/payments/paynow/initiate", body: PaynowInitiateBody(orderId: orderId, channel: channel, client: "ios", phone: phone), authenticated: true)
    }

    func paymentStatus(orderId: String) async throws -> PaynowStatusResponse {
        try await api.post("/api/payments/paynow/status", body: PaynowStatusBody(orderId: orderId), authenticated: true)
    }

    func pickupAvailability(branchID: String) async throws -> PickupAvailabilityResponse {
        try await api.get("/api/public/marketplace/pickup-availability", query: [URLQueryItem(name: "branchId", value: branchID), URLQueryItem(name: "days", value: "14")])
    }

    func orderStatus(orderID: String) async throws -> CustomerOrderStatusResponse {
        try await api.post("/api/customer/orders/status", body: OrderStatusBody(orderId: orderID), authenticated: true)
    }

    func cancelOrder(orderID: String, reason: String) async throws -> OrderCancelResponse {
        try await api.post("/api/orders/cancel", body: OrderCancelBody(orderId: orderID, reason: reason), authenticated: true)
    }

    func review(orderID: String, rating: Int, comment: String) async throws -> ReviewCreateResponse {
        try await api.post("/api/customer/reviews", body: ReviewCreateBody(orderId: orderID, rating: rating, comment: comment), authenticated: true)
    }

    func createSupport(subject: String, category: String, message: String, user: SpotlyUser?, contextType: String? = nil, contextID: String? = nil) async throws -> SupportCreateResponse {
        let body = SupportCreateBody(name: user?.name, email: user?.email, subject: subject, category: category, priority: "normal", message: message, businessId: nil, contextType: contextType, contextId: contextID)
        return try await api.post("/api/support/conversations", body: body, authenticated: true)
    }

    func requestAccountDeletion() async throws -> AccountDeletionResponse {
        try await api.post(
            "/api/customer/account/deletion",
            body: AccountDeletionRequestBody(reason: "customer_request"),
            authenticated: true
        )
    }
}

actor SpotlyRideService {
    static let shared = SpotlyRideService()
    private let api = APIClient.shared

    func quote(pickup: RidePoint, dropoff: RidePoint, serviceType: String) async throws -> RideQuoteResponse {
        guard let service = SpotlyRideServiceTypeID(rawValue: serviceType) else {
            throw SpotlyAPIError.server(status: 422, message: "That Ride service type is not supported by this app version.")
        }
        return try await api.post("/api/customer/rides/quote", body: RideQuoteRequest(pickup: pickup, dropoff: dropoff, serviceType: service), authenticated: false)
    }

    func request(pickup: RidePoint, dropoff: RidePoint, serviceType: String, paymentMethod: String, quote: RideQuote, riderName: String?, riderPhone: String?, note: String?) async throws -> RideRequestResponse {
        guard let service = SpotlyRideServiceTypeID(rawValue: serviceType),
              let payment = SpotlyPaymentMethod(rawValue: paymentMethod),
              let currency = SpotlyCurrencyCode(rawValue: quote.currency) else {
            throw SpotlyAPIError.server(status: 422, message: "The Ride quote is not compatible with this app version.")
        }
        let body = RideRequestBody(
            pickup: pickup, dropoff: dropoff, serviceType: service, paymentMethod: payment,
            quotedTotal: quote.total, quotedCurrency: currency,
            riderName: riderName, riderPhone: riderPhone, note: note
        )
        return try await api.post("/api/customer/rides", body: body, authenticated: true)
    }
}

actor SpotlySendService {
    static let shared = SpotlySendService()
    private let api = APIClient.shared

    func quote(pickup: RidePoint, dropoff: RidePoint, parcelSize: String) async throws -> ParcelQuoteResponse {
        guard let size = SpotlyParcelSize(rawValue: parcelSize) else {
            throw SpotlyAPIError.server(status: 422, message: "That parcel size is not supported by this app version.")
        }
        return try await api.post("/api/customer/parcels/quote", body: ParcelQuoteRequest(pickup: pickup, dropoff: dropoff, parcelSize: size), authenticated: false)
    }

    func request(_ body: ParcelRequestBody) async throws -> ParcelRequestResponse {
        try await api.post("/api/customer/parcels", body: body, authenticated: true)
    }
}


actor SpotlyOperationsService {
    static let shared = SpotlyOperationsService()
    private let api = APIClient.shared

    func rides() async throws -> SpotlyOperationsRideListResponse {
        try await api.get("/api/operations/rides", authenticated: true)
    }

    func createRide(pickup: RidePoint, dropoff: RidePoint, serviceType: String) async throws -> SpotlyOperationsRideMutationResponse {
        try await api.post(
            "/api/operations/rides",
            body: SpotlyOperationsRideRequestBody(pickup: pickup, dropoff: dropoff, serviceType: serviceType),
            authenticated: true
        )
    }

    func createSend(pickup: RidePoint, dropoff: RidePoint, parcelSize: String) async throws -> SpotlyOperationsSendResponse {
        try await api.post(
            "/api/operations/send",
            body: SpotlyOperationsSendRequestBody(pickup: pickup, dropoff: dropoff, parcelSize: parcelSize),
            authenticated: true
        )
    }

    func validateCheckout(_ body: SpotlyOperationsCheckoutRequest) async throws -> SpotlyOperationsCheckoutResponse {
        try await api.post("/api/operations/checkout", body: body, authenticated: true)
    }
}


nonisolated struct AccountDeletionRequestBody: Encodable {
    let reason: String
}

nonisolated struct AccountDeletionResponse: Decodable {
    let ok: Bool
    let status: String
    let blockers: AccountDeletionBlockers?
}

nonisolated struct AccountDeletionBlockers: Decodable {
    let activeRideCount: Int
    let activeParcelCount: Int
    let activeOrderCount: Int
    var total: Int { activeRideCount + activeParcelCount + activeOrderCount }
}
