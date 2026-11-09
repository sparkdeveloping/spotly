import Foundation

// MARK: - Shared location

typealias RidePoint = SpotlyLocationPoint

nonisolated extension SpotlyLocationPoint {
    var displayLabel: String { [label, formattedAddress, area, city].compactMap { $0?.nilIfBlank }.first ?? "Location" }
}

// A quote is valid only for the exact locations and service selection used
// to request it. Small pure values make stale-response rejection testable.
nonisolated struct RideQuoteIntent: Hashable, Sendable {
    let pickup: RidePoint
    let dropoff: RidePoint
    let serviceType: String
}

nonisolated struct SendQuoteIntent: Hashable, Sendable {
    let pickup: RidePoint
    let dropoff: RidePoint
    let size: String
}

// MARK: - Ride

nonisolated struct RideQuoteRequest: Encodable, Sendable {
    let pickup: RidePoint
    let dropoff: RidePoint
    let serviceType: SpotlyRideServiceTypeID
}

nonisolated struct RideQuoteResponse: Decodable, Sendable {
    let ok: Bool
    let quote: RideQuote
    let serviceTypes: [String: RideServiceType]?
    let paymentMethods: [String]?
    let serviceAvailability: SpotlyServiceAvailabilityDecision?
    let bookingAvailable: Bool?
    let bookingReason: String?
}

nonisolated struct RideServiceType: Decodable, Hashable, Sendable {
    let label: String?
    let seats: Int?
    let multiplier: Double?
    let vehicleTypes: [String]?
}

nonisolated struct RideQuote: Codable, Hashable, Sendable {
    let serviceType: String
    let serviceLabel: String
    let seats: Int?
    let currency: String
    let distanceKm: Double
    let directDistanceKm: Double?
    let durationMinutes: Int
    let baseFare: Double?
    let bookingFee: Double?
    let total: Double
    let driverPay: Double?
    let platformFee: Double?
    let requiredVehicleTypes: [String]?
}

nonisolated struct RideRequestBody: Encodable, Sendable {
    let action = "request"
    let pickup: RidePoint
    let dropoff: RidePoint
    let serviceType: SpotlyRideServiceTypeID
    let paymentMethod: SpotlyPaymentMethod
    let quotedTotal: Double
    let quotedCurrency: SpotlyCurrencyCode
    let riderName: String?
    let riderPhone: String?
    let note: String?
}

nonisolated struct RideRequestResponse: Decodable, Sendable {
    let ok: Bool
    let rideId: String
    let orderId: String?
    let number: String
    let state: String
    let quote: RideQuote?
}

nonisolated struct RideCancelBody: Encodable, Sendable {
    let action = "cancel"
    let rideId: String
    let reason: String
}

nonisolated struct RideListResponse: Decodable, Sendable {
    let ok: Bool
    let activeRide: RideTrip?
    let rides: [RideTrip]
}

nonisolated struct RideDetailResponse: Decodable, Sendable {
    let ok: Bool
    let ride: RideTrip
}

nonisolated struct RideTrip: Decodable, Identifiable, Hashable, Sendable {
    let id: String
    let number: String?
    let state: String
    let serviceType: String?
    let currency: String?
    let pickup: RidePoint?
    let dropoff: RidePoint?
    let quote: RideQuote?
    let paymentMethod: String?
    let paymentStatus: String?
    let assignedDriverId: String?
    let requestedAt: String?
    let assignedAt: String?
    let arrivedPickupAt: String?
    let startedAt: String?
    let completedAt: String?
    let cancelledAt: String?
    let cancellationReason: String?
    let pickupPin: String?
    let driver: SpotlyDriverSummary?
    let driverLocation: DriverLocation?
}

nonisolated struct SpotlyDriverSummary: Decodable, Hashable, Sendable {
    let id: String?
    let displayName: String?
    let phone: String?
    let photoURL: String?
    let rating: Double?
    let vehicle: DriverVehicleSummary?
}

nonisolated struct DriverVehicleSummary: Decodable, Hashable, Sendable {
    let type: String?
    let make: String?
    let model: String?
    let registration: String?
    let color: String?
}

nonisolated struct DriverLocation: Decodable, Hashable, Sendable {
    let lat: Double?
    let lng: Double?
    let accuracy: Double?
    let updatedAt: String?
}

// MARK: - Send

nonisolated struct ParcelQuoteRequest: Encodable, Sendable {
    let pickup: RidePoint
    let dropoff: RidePoint
    let parcelSize: SpotlyParcelSize
}

nonisolated struct ParcelQuoteResponse: Decodable, Sendable {
    let ok: Bool
    let quote: ParcelQuote
    let parcelSizes: [String: ParcelSizeConfiguration]?
    let paymentMethods: [String]?
    let scheduledEnabled: Bool?
    let serviceAvailability: SpotlyServiceAvailabilityDecision?
    let bookingAvailable: Bool?
    let bookingReason: String?
}

nonisolated struct ParcelSizeConfiguration: Decodable, Hashable, Sendable {
    let label: String?
    let maxKg: Double?
    let multiplier: Double?
    let vehicleTypes: [String]?
}

nonisolated struct ParcelQuote: Codable, Hashable, Sendable {
    let parcelSize: String
    let parcelSizeLabel: String
    let maxKg: Double
    let currency: String
    let distanceKm: Double
    let durationMinutes: Int
    let baseFare: Double?
    let bookingFee: Double?
    let total: Double
    let driverPay: Double?
    let platformFee: Double?
    let requiredVehicleTypes: [String]?
    let proofPhotoRequired: Bool?
}

nonisolated struct ParcelRequestBody: Encodable, Sendable {
    let action = "request"
    let pickup: RidePoint
    let dropoff: RidePoint
    let parcelSize: SpotlyParcelSize
    let paymentMethod: SpotlyPaymentMethod
    let senderName: String
    let senderPhone: String
    let recipientName: String
    let recipientPhone: String
    let parcelDescription: String
    let estimatedWeightKg: Double?
    let declaredValue: Double?
    let instructions: String?
    let pickupMode: SpotlyPickupMode
    let scheduledPickupAt: String?
    let prohibitedAcknowledged = true
    let quotedTotal: Double
    let quotedCurrency: SpotlyCurrencyCode
}

nonisolated struct ParcelRequestResponse: Decodable, Sendable {
    let ok: Bool
    let parcelJobId: String
    let orderId: String?
    let number: String
    let state: String
    let paymentRequired: Bool?
    let pickupPin: String?
    let dropoffPin: String?
}

nonisolated struct ParcelCancelBody: Encodable, Sendable {
    let action = "cancel"
    let parcelJobId: String
    let reason: String
}

nonisolated struct ParcelListResponse: Decodable, Sendable {
    let ok: Bool
    let activeParcel: ParcelJob?
    let parcels: [ParcelJob]
}

nonisolated struct ParcelDetailResponse: Decodable, Sendable {
    let ok: Bool
    let parcel: ParcelJob
}

nonisolated struct ParcelJob: Decodable, Identifiable, Hashable, Sendable {
    let id: String
    let number: String?
    let orderId: String?
    let state: String
    let pickup: RidePoint?
    let dropoff: RidePoint?
    let parcelSize: String?
    let parcelDescription: String?
    let estimatedWeightKg: Double?
    let recipientName: String?
    let recipientPhone: String?
    let senderName: String?
    let senderPhone: String?
    let quote: ParcelQuote?
    let currency: String?
    let paymentMethod: String?
    let paymentStatus: String?
    let pickupMode: String?
    let scheduledPickupAt: String?
    let proofPhotoUrl: String?
    let proofPhotoRequired: Bool?
    let cancellationReason: String?
    let exceptionCode: String?
    let createdAt: String?
    let updatedAt: String?
    let driver: SpotlyDriverSummary?
    let driverLocation: DriverLocation?
    let pickupPin: String?
    let dropoffPin: String?
}

// MARK: - Orders / bookings / tickets

nonisolated struct CommerceOrderCreateBody: Encodable, Sendable {
    struct Line: Encodable, Sendable { let productId: String; let quantity: Int }
    struct Delivery: Encodable, Sendable {
        let contactName: String
        let contactPhone: String
        let address: String
        let suburb: String?
        let landmark: String?
        let instructions: String?
        let lat: Double
        let lng: Double
        let substitutionPreference: String
    }
    struct Pickup: Encodable, Sendable {
        let date: String
        let slot: String
        let slotId: String
        let contactName: String
        let contactPhone: String
        let alternativePhone: String?
        let notes: String?
        let substitutionPreference: String
    }

    let checkoutId: String
    let businessId: String
    let branchId: String
    let items: [Line]
    let currency: SpotlyCurrencyCode
    let promoCode: String?
    let paymentMethod: SpotlyPaymentMethod
    let fulfilment: String
    let delivery: Delivery?
    let pickup: Pickup?
}

nonisolated struct CommerceOrderCreateResponse: Decodable, Sendable {
    let ok: Bool
    let orderId: String
    let number: String
    let total: Double
    let currency: String
    let paymentRequired: Bool
    let fulfilment: String?
    let fulfilmentMode: String?
    let shoppingReserve: Double?
    let discount: Double?
}

nonisolated struct CustomerTransactionCreateBody: Encodable, Sendable {
    struct Appointment: Encodable, Sendable { let date: String; let time: String; let staffPreference: String? }
    struct Booking: Encodable, Sendable { let startDate: String; let endDate: String?; let guests: Int }

    let checkoutId: String
    let businessId: String
    let branchId: String
    let itemId: String
    let quantity: Int
    let currency: SpotlyCurrencyCode
    let promoCode: String?
    let paymentMethod: SpotlyPaymentMethod
    let contactName: String
    let contactPhone: String
    let notes: String?
    let appointment: Appointment?
    let booking: Booking?
}

nonisolated struct CustomerTransactionCreateResponse: Decodable, Sendable {
    let ok: Bool
    let orderId: String
    let number: String
    let total: Double
    let currency: String
    let paymentRequired: Bool
    let transactionType: String?
    let status: String?
    let discount: Double?
}

nonisolated struct PaynowInitiateBody: Encodable, Sendable {
    let orderId: String
    let channel: String
    let client: String
    let phone: String?
}

nonisolated struct PaynowInitiateResponse: Decodable, Sendable {
    let ok: Bool
    let reused: Bool?
    let orderId: String
    let reference: String?
    let channel: String?
    let redirectUrl: String?
    let instructions: String?
    let status: String?
}

nonisolated struct PaynowStatusBody: Encodable, Sendable { let orderId: String }

nonisolated struct PaynowStatusResponse: Decodable, Sendable {
    let ok: Bool
    let orderId: String
    let state: String
    let paid: Bool?
    let providerStatus: String?
    let transitionApplied: Bool?
    let amountMismatch: Bool?
    let deduplicated: Bool?
    let transactionType: String?
    let fulfilment: String?
    let businessName: String?
    let number: String?

    var isPaid: Bool { paid == true || state.lowercased() == "paid" }
}

nonisolated struct OrderStatusBody: Encodable, Sendable { let orderId: String }

// MARK: - Unified activity

typealias ActivityKind = SpotlyActivityKind

nonisolated extension SpotlyActivityKind {
    var title: String {
        switch self {
        case .order: return "Order"
        case .appointment: return "Appointment"
        case .booking: return "Booking"
        case .ticket: return "Ticket"
        case .ride: return "Ride"
        case .send: return "Send"
        case .assistShopping: return "Assist shopping"
        case .assistBooking: return "Assist booking"
        }
    }

    var icon: String {
        switch self {
        case .order: return "bag.fill"
        case .appointment: return "calendar.badge.clock"
        case .booking: return "calendar"
        case .ticket: return "ticket.fill"
        case .ride: return "car.fill"
        case .send: return "shippingbox.fill"
        case .assistShopping: return "person.crop.circle.badge.checkmark"
        case .assistBooking: return "calendar.badge.checkmark"
        }
    }
}

enum ActivitySectionKind: String, CaseIterable, Hashable, Sendable {
    case attention = "Needs attention"
    case active = "Active"
    case upcoming = "Upcoming"
    case past = "Past"
}

nonisolated struct ActivityRecord: Decodable, Identifiable, Hashable, Sendable {
    let id: String
    let kind: ActivityKind
    let title: String
    let subtitle: String
    let state: String
    let paymentStatus: String
    let number: String
    let total: Double?
    let currency: SpotlyCurrencyCode?
    let createdAt: Date?
    let orderId: String?
    let rideId: String?
    let parcelId: String?

    var service: SpotlyServiceKind? = nil
    var scheduledAt: Date? = nil
    var attentionReason: String? = nil
    var primaryAction: SpotlyPrimaryAction? = nil

    var actionTitle: String {
        switch primaryAction {
        case .pay: return "Pay now"
        case .track: return "Track"
        case .support: return "Get help"
        case .reviewQuote: return "Review quote"
        case .reviewAlternative: return "Review time"
        case .reviewSubstitution: return "Review replacement"
        case .open, .none: return "View details"
        }
    }

    var section: ActivitySectionKind {
        let stateValue = state.lowercased()
        let payment = paymentStatus.lowercased()
        if PollingPolicy.isTerminal(stateValue) { return .past }
        if attentionReason != nil || ["unpaid", "failed", "action_required", "awaiting_payment"].contains(payment) && (total ?? 0) > 0 && orderId != nil || stateValue.contains("action") || stateValue.contains("substitution") { return .attention }
        if ["completed", "cancelled", "failed", "refunded", "delivered"].contains(stateValue) { return .past }
        if ["appointment", "booking", "ticket"].contains(kind.rawValue) && ["accepted", "confirmed", "scheduled", "submitted"].contains(stateValue) { return .upcoming }
        return .active
    }
}

// MARK: - Support / customer actions

nonisolated struct SupportCreateBody: Encodable, Sendable {
    let action = "create"
    let name: String?
    let email: String?
    let audience = "customer"
    let subject: String
    let category: String
    let priority: String
    let message: String
    let businessId: String?
    let contextType: String?
    let contextId: String?
}

nonisolated struct SupportCreateResponse: Decodable, Sendable { let ok: Bool; let conversationId: String }
nonisolated struct OrderCancelBody: Encodable, Sendable { let orderId: String; let reason: String }
nonisolated struct OrderCancelResponse: Decodable, Sendable { let ok: Bool; let orderId: String; let status: String }
nonisolated struct ReviewCreateBody: Encodable, Sendable { let orderId: String; let rating: Int; let comment: String }
nonisolated struct ReviewCreateResponse: Decodable, Sendable { let ok: Bool }

// MARK: - Pickup availability

nonisolated struct PickupAvailabilityResponse: Decodable, Sendable {
    let ok: Bool
    let branchId: String
    let available: Bool
    let reason: String?
    let days: [PickupAvailabilityDay]
    let earliest: PickupEarliest?
}

// The server's earliest slot may belong to a different day than the first
// listed day. Always choose both fields from the same authoritative day.
nonisolated extension PickupAvailabilityResponse {
    func defaultSelection() -> (day: PickupAvailabilityDay, slot: PickupAvailabilitySlot)? {
        if let earliest,
           let day = days.first(where: { $0.date == earliest.date }),
           let slot = day.slots.first(where: { $0.id == earliest.slot.id && ($0.remaining ?? 1) > 0 }) {
            return (day, slot)
        }
        for day in days {
            if let slot = day.slots.first(where: { ($0.remaining ?? 1) > 0 }) {
                return (day, slot)
            }
        }
        return nil
    }
}

nonisolated struct PickupAvailabilityDay: Decodable, Identifiable, Hashable, Sendable {
    var id: String { date }
    let date: String
    let label: String
    let slots: [PickupAvailabilitySlot]
}

nonisolated struct PickupAvailabilitySlot: Decodable, Identifiable, Hashable, Sendable {
    let id: String
    let start: String
    let end: String
    let label: String
    let remaining: Int?
}

nonisolated struct PickupEarliest: Decodable, Hashable, Sendable {
    let date: String
    let slot: PickupAvailabilitySlot
}

// MARK: - Customer order status

nonisolated struct CustomerOrderStatusResponse: Decodable, Sendable {
    let ok: Bool
    let order: CustomerOrderStatus
    let delivery: CustomerDeliveryStatus?
}

nonisolated struct CustomerOrderStatus: Decodable, Identifiable, Sendable {
    let id: String
    let number: String
    let businessId: String?
    let businessName: String
    let branchId: String?
    let branchName: String?
    let status: String
    let paymentStatus: String
    let fulfilment: String?
    let deliveryStatus: String?
    let currency: String
    let totals: CustomerOrderTotals?
    let items: [CustomerOrderLine]
    let createdAt: String?
    let updatedAt: String?
}

nonisolated struct CustomerOrderTotals: Decodable, Sendable { let total: Double?; let subtotal: Double?; let deliveryFee: Double?; let serviceFee: Double?; let discount: Double? }
nonisolated struct CustomerOrderLine: Decodable, Identifiable, Sendable {
    var id: String { productId ?? name ?? UUID().uuidString }
    let productId: String?
    let name: String?
    let image: String?
    let quantity: Int?
    let unitPrice: Double?
    let lineTotal: Double?
    let variant: String?
}

nonisolated struct CustomerDeliveryStatus: Decodable, Identifiable, Sendable {
    let id: String
    let number: String?
    let state: String
    let stateLabel: String?
    let fulfilmentMode: String?
    let driver: CustomerDeliveryDriver?
    let driverLocation: DriverLocation?
    let customerPin: String?
    let updatedAt: String?
}

nonisolated struct CustomerDeliveryDriver: Decodable, Sendable {
    let id: String?
    let firstName: String?
    let photoURL: String?
    let rating: Double?
    let vehicle: DriverVehicleSummary?
}
