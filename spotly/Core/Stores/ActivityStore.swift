import Foundation
import Observation

@MainActor
@Observable
final class ActivityStore {
    var records: [ActivityRecord] = []
    var activeRide: RideTrip?
    var activeParcel: ParcelJob?
    var isLoading = false
    var errorMessage: String?
    var lastUpdated: Date?

    var attentionCount: Int { records.filter { $0.section == .attention }.count }
    var hasActiveWork: Bool { records.contains { $0.section == .active } }

    private let api = APIClient.shared
    private let firestore = FirestoreREST.shared
    private var generation = UUID()
    private var ownerID: String?
    private(set) var nextOffset: Int?

    func reset() {
        generation = UUID(); ownerID = nil; records = []; activeRide = nil; activeParcel = nil
        isLoading = false; errorMessage = nil; lastUpdated = nil; nextOffset = nil
    }

    func load(user: SpotlyUser?, force: Bool = false) async {
        guard let user else { reset(); return }
        if ownerID != user.id { reset(); ownerID = user.id }
        if isLoading && !force { return }
        if !force, let lastUpdated, Date().timeIntervalSince(lastUpdated) < 15 { return }
        generation = UUID()
        await fetch(offset: 0, generation: generation, user: user)
    }

    func loadMore() async {
        guard !isLoading, let nextOffset, let ownerID else { return }
        let user = SpotlyUser(id: ownerID, name: "", firstName: "", email: "", phone: "", avatarURL: nil, location: "", isVerified: false, createdAt: .distantPast, favouriteIDs: [])
        await fetch(offset: nextOffset, generation: generation, user: user)
    }

    private func fetch(offset: Int, generation: UUID, user: SpotlyUser) async {
        isLoading = true
        if offset == 0 { errorMessage = nil }
        defer { if generation == self.generation { isLoading = false } }

        do {
            let response: CustomerActivityResponse = try await api.get(
                "/api/customer/activity",
                query: [URLQueryItem(name: "offset", value: String(offset)), URLQueryItem(name: "limit", value: "30")],
                authenticated: true
            )
            guard generation == self.generation, !Task.isCancelled else { return }
            apply(response.records, offset: offset, nextOffset: response.nextOffset)
            if offset == 0 { await refreshActiveOperationalRecords(generation: generation) }
        } catch let apiError as SpotlyAPIError {
            guard generation == self.generation, !Task.isCancelled else { return }
            // Compatibility bridge for the currently deployed production host. The shared
            // /api/customer/activity contract remains the preferred path and should be deployed,
            // but a missing route must not make the customer Activity tab unusable.
            if offset == 0, apiError != .unauthenticated {
                do {
                    let legacy = try await legacyActivity(user: user)
                    guard generation == self.generation, !Task.isCancelled else { return }
                    apply(legacy.records, offset: 0, nextOffset: nil)
                    activeRide = legacy.activeRide
                    activeParcel = legacy.activeParcel
                    errorMessage = legacy.partialWarning
                } catch {
                    errorMessage = "Activity is temporarily unavailable. Try again shortly."
                }
            } else {
                errorMessage = apiError.errorDescription ?? "Activity is temporarily unavailable. Try again shortly."
            }
        } catch is CancellationError {
            return
        } catch {
            guard generation == self.generation, !Task.isCancelled else { return }
            errorMessage = "Activity is temporarily unavailable. Try again shortly."
        }
    }

    private func apply(_ incoming: [ActivityRecord], offset: Int, nextOffset: Int?) {
        var seen = Set<String>()
        let combined = (offset == 0 ? incoming : records + incoming)
            .sorted { ($0.createdAt ?? .distantPast) > ($1.createdAt ?? .distantPast) }
            .filter { seen.insert($0.id).inserted }
        records = combined
        self.nextOffset = nextOffset
        lastUpdated = Date()
        errorMessage = nil
    }

    private func refreshActiveOperationalRecords(generation: UUID) async {
        let rideID = records.first { $0.kind == .ride && !PollingPolicy.isTerminal($0.state) }?.rideId
        let parcelID = records.first { $0.kind == .send && !PollingPolicy.isTerminal($0.state) }?.parcelId
        // Failure of Ride must not suppress a successfully refreshed Send (or vice versa).
        async let refreshedRide: RideTrip? = try? await fetchRideDetail(rideID)
        async let refreshedParcel: ParcelJob? = try? await fetchParcelDetail(parcelID)
        let (ride, parcel) = await (refreshedRide, refreshedParcel)
        guard generation == self.generation, !Task.isCancelled else { return }
        if rideID == nil { activeRide = nil }
        else if let ride { activeRide = ride }
        else if activeRide?.id != rideID { activeRide = nil }
        if parcelID == nil { activeParcel = nil }
        else if let parcel { activeParcel = parcel }
        else if activeParcel?.id != parcelID { activeParcel = nil }
    }

    private func fetchRideDetail(_ id: String?) async throws -> RideTrip? {
        guard let id else { return nil }
        return try await ride(id: id)
    }

    private func fetchParcelDetail(_ id: String?) async throws -> ParcelJob? {
        guard let id else { return nil }
        return try await parcel(id: id)
    }

    private func legacyActivity(user: SpotlyUser) async throws -> (
        records: [ActivityRecord], activeRide: RideTrip?, activeParcel: ParcelJob?, partialWarning: String?
    ) {
        guard let token = try await SessionController.shared.validIDToken() else { throw SpotlyAPIError.unauthenticated }
        // Three independently authorized sources. One outage should not hide the
        // other two; never show a "nothing here" state if none could be read.
        async let orderDocs: [FirestoreDocument]? = try? await firestore.queryOrders(uid: user.id, token: token)
        async let rides: RideListResponse? = try? await api.get("/api/customer/rides", authenticated: true)
        async let parcels: ParcelListResponse? = try? await api.get("/api/customer/parcels", authenticated: true)
        let (orders, rideResponse, parcelResponse) = await (orderDocs, rides, parcels)
        guard orders != nil || rideResponse != nil || parcelResponse != nil else {
            throw SpotlyAPIError.transport("No Activity sources available")
        }
        var result = (orders ?? []).compactMap(Self.activityRecord(from:))
        result.append(contentsOf: (rideResponse?.rides ?? []).map(Self.activityRecord(from:)))
        result.append(contentsOf: (parcelResponse?.parcels ?? []).map(Self.activityRecord(from:)))
        var seen = Set<String>()
        result = result
            .sorted { ($0.createdAt ?? .distantPast) > ($1.createdAt ?? .distantPast) }
            .filter { seen.insert($0.id).inserted }
        let warning = orders == nil || rideResponse == nil || parcelResponse == nil
            ? "Some Activity categories could not refresh. Showing the information currently available." : nil
        return (result, rideResponse?.activeRide, parcelResponse?.activeParcel, warning)
    }

    private static func activityRecord(from doc: FirestoreDocument) -> ActivityRecord? {
        let fields = doc.fields
        let transactionType = clean(fields["transactionType"]?.stringValue).lowercased()
        if ["ride", "send"].contains(transactionType) { return nil }

        let kind: ActivityKind = switch transactionType {
        case "appointment": .appointment
        case "booking": .booking
        case "ticket", "event": .ticket
        default: .order
        }
        let business = clean(fields["businessName"]?.stringValue)
        let title = business.isEmpty ? (kind == .ticket ? "Event ticket" : kind == .booking ? "Booking" : kind == .appointment ? "Appointment" : "Spotly order") : business
        let number = clean(fields["number"]?.stringValue).nilIfEmpty ?? doc.id
        let state = clean(fields["status"]?.stringValue).nilIfEmpty ?? "submitted"
        let total = fields["totals"]?.mapValue?["total"]?.doubleValue ?? fields["total"]?.doubleValue
        let payment = clean(fields["paymentStatus"]?.stringValue).nilIfEmpty ?? ((total ?? 0) > 0 ? "unpaid" : "not_required")
        let currency = clean(fields["currency"]?.stringValue).nilIfEmpty ?? "USD"
        let createdAt = fields["createdAt"]?.dateValue ?? fields["updatedAt"]?.dateValue
        let scheduledAt = fields["scheduledAt"]?.dateValue ?? fields["appointmentAt"]?.dateValue

        let items = fields["items"]?.arrayValue ?? []
        let itemNames = items.compactMap { $0.mapValue?["name"]?.stringValue?.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
        let subtitle: String
        if [.appointment, .booking, .ticket].contains(kind), let first = itemNames.first {
            subtitle = first
        } else if !items.isEmpty {
            subtitle = "\(items.count) \(items.count == 1 ? "item" : "items")"
        } else {
            subtitle = "Reference \(number)"
        }

        let attention = ["unpaid", "failed", "action_required", "awaiting_payment"].contains(payment.lowercased()) && (total ?? 0) > 0 ? "Payment required" : nil
        var record = ActivityRecord(
            id: "order:\(doc.id)", kind: kind, title: title, subtitle: subtitle, state: state,
            paymentStatus: payment, number: number, total: total, currency: SpotlyCurrencyCode(rawValue: currency),
            createdAt: createdAt, orderId: doc.id, rideId: nil, parcelId: nil
        )
        record.service = kind == .ticket ? .events : ([.appointment, .booking].contains(kind) ? .book : nil)
        record.scheduledAt = scheduledAt
        record.attentionReason = attention
        record.primaryAction = attention == nil ? nil : .pay
        return record
    }

    private static func activityRecord(from ride: RideTrip) -> ActivityRecord {
        let route = [ride.pickup?.displayLabel, ride.dropoff?.displayLabel].compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }.joined(separator: " → ")
        let total = ride.quote?.total
        let payment = clean(ride.paymentStatus).nilIfEmpty ?? (ride.paymentMethod == "cash" ? "cash_due" : ((total ?? 0) > 0 ? "unpaid" : "not_required"))
        let created = parseDate(ride.requestedAt)
        var record = ActivityRecord(
            id: "ride:\(ride.id)", kind: .ride, title: "Spotly Ride", subtitle: route.isEmpty ? "Ride request" : route,
            state: ride.state, paymentStatus: payment, number: ride.number ?? ride.id, total: total,
            currency: SpotlyCurrencyCode(rawValue: ride.quote?.currency ?? ride.currency ?? "USD"), createdAt: created,
            orderId: nil, rideId: ride.id, parcelId: nil
        )
        record.service = .ride
        if ["unpaid", "failed", "action_required", "awaiting_payment"].contains(payment.lowercased()), (total ?? 0) > 0 {
            record.attentionReason = "Payment required"; record.primaryAction = .pay
        }
        return record
    }

    private static func activityRecord(from parcel: ParcelJob) -> ActivityRecord {
        let route = [parcel.pickup?.displayLabel, parcel.dropoff?.displayLabel].compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }.joined(separator: " → ")
        let total = parcel.quote?.total
        let payment = clean(parcel.paymentStatus).nilIfEmpty ?? (parcel.paymentMethod == "cash" ? "cash_due" : ((total ?? 0) > 0 ? "unpaid" : "not_required"))
        var record = ActivityRecord(
            id: "send:\(parcel.id)", kind: .send, title: "Spotly Send",
            subtitle: route.isEmpty ? (clean(parcel.parcelDescription).nilIfEmpty ?? "Parcel delivery") : route,
            state: parcel.state, paymentStatus: payment, number: parcel.number ?? parcel.id, total: total,
            currency: SpotlyCurrencyCode(rawValue: parcel.quote?.currency ?? parcel.currency ?? "USD"), createdAt: parseDate(parcel.createdAt),
            orderId: parcel.orderId, rideId: nil, parcelId: parcel.id
        )
        record.service = .send
        record.scheduledAt = parseDate(parcel.scheduledPickupAt)
        if ["unpaid", "failed", "action_required", "awaiting_payment"].contains(payment.lowercased()), (total ?? 0) > 0 {
            record.attentionReason = "Payment required"; record.primaryAction = .pay
        }
        return record
    }

    private static func parseDate(_ value: String?) -> Date? {
        guard let value else { return nil }
        return ISO8601DateFormatter.spotly.date(from: value) ?? ISO8601DateFormatter().date(from: value)
    }

    private static func clean(_ value: String?) -> String { value?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "" }

    func ride(id: String) async throws -> RideTrip {
        let response: RideDetailResponse = try await api.get("/api/customer/rides", query: [URLQueryItem(name: "rideId", value: id)], authenticated: true)
        return response.ride
    }

    func parcel(id: String) async throws -> ParcelJob {
        let response: ParcelDetailResponse = try await api.get("/api/customer/parcels", query: [URLQueryItem(name: "parcelJobId", value: id)], authenticated: true)
        return response.parcel
    }

    func cancelRide(id: String, reason: String) async throws {
        let _: EmptyResponse = try await api.post("/api/customer/rides", body: RideCancelBody(rideId: id, reason: reason), authenticated: true)
        activeRide = nil
        lastUpdated = nil
    }

    func cancelParcel(id: String, reason: String) async throws {
        let _: EmptyResponse = try await api.post("/api/customer/parcels", body: ParcelCancelBody(parcelJobId: id, reason: reason), authenticated: true)
        activeParcel = nil
        lastUpdated = nil
    }
}

private extension String {
    var nilIfEmpty: String? { isEmpty ? nil : self }
}

nonisolated struct CustomerActivityResponse: Decodable {
    let ok: Bool
    let records: [ActivityRecord]
    let nextOffset: Int?
}
