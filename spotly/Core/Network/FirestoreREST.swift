import Foundation
import CoreFoundation
import FirebaseFirestore

// Keep the app's existing view-model contract while using the native Firestore SDK.
// This is a migration adapter, not a REST transport. Callers no longer construct
// raw Firestore HTTP requests or manage Firebase tokens for these operations.
nonisolated struct FirestoreDocument: Identifiable, Hashable, Sendable {
    let id: String
    let fields: [String: FirestoreScalar]
}

nonisolated enum FirestoreScalar: Hashable, Sendable {
    case string(String)
    case number(Double)
    case bool(Bool)
    case timestamp(Date)
    case map([String: FirestoreScalar])
    case array([FirestoreScalar])
    case null

    var stringValue: String? {
        switch self {
        case .string(let value): return value
        case .number(let value): return String(value)
        case .bool(let value): return String(value)
        default: return nil
        }
    }
    var doubleValue: Double? {
        switch self {
        case .number(let value): return value
        case .string(let value): return Double(value)
        default: return nil
        }
    }
    var boolValue: Bool? {
        switch self {
        case .bool(let value): return value
        case .string(let value): return Bool(value)
        default: return nil
        }
    }
    var dateValue: Date? {
        if case .timestamp(let value) = self { return value }
        return nil
    }
    var arrayValue: [FirestoreScalar]? {
        if case .array(let value) = self { return value }
        return nil
    }
    var mapValue: [String: FirestoreScalar]? {
        if case .map(let value) = self { return value }
        return nil
    }
}

@MainActor
final class FirestoreREST {
    static let shared = FirestoreREST()
    private init() {}

    private var database: Firestore { Firestore.firestore() }

    func ensureUserProfile(uid: String, email: String, displayName: String, idToken _: String) async throws -> SpotlyUser {
        let ref = database.collection("users").document(uid)
        let snapshot = try await ref.getDocument()
        if snapshot.exists {
            let fields = snapshot.data() ?? [:]
            let existingName = (fields["displayName"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
            let resolved = (existingName?.isEmpty == false ? existingName ?? displayName : displayName.isEmpty ? fallbackName(email) : displayName)
            let preferences = fields["preferences"] as? [String: Any] ?? [:]
            return SpotlyUser(
                id: uid,
                name: resolved,
                firstName: resolved.split(separator: " ").first.map(String.init) ?? resolved,
                email: fields["email"] as? String ?? email,
                phone: fields["phoneNumber"] as? String ?? fields["phone"] as? String ?? "",
                avatarURL: fields["photoURL"] as? String,
                location: preferences["city"] as? String ?? "",
                isVerified: false,
                createdAt: (fields["createdAt"] as? Timestamp)?.dateValue() ?? Date(),
                favouriteIDs: []
            )
        }
        // Only create if missing. Do not overwrite existing roles or permissions.
        // This shape is permitted by the supplied web project's /users create rule.
        let now = Timestamp(date: Date())
        try await ref.setData([
            "uid": uid, "email": email, "displayName": displayName,
            "phoneNumber": "", "photoURL": "", "providers": ["password"],
            "locale": "en", "roles": ["customer"], "status": "active",
            "createdAt": now, "updatedAt": now, "lastSeenAt": now
        ])
        let name = displayName.isEmpty ? fallbackName(email) : displayName
        return SpotlyUser(id: uid, name: name, firstName: name.split(separator: " ").first.map(String.init) ?? name,
                          email: email, phone: "", avatarURL: nil, location: "", isVerified: false,
                          createdAt: Date(), favouriteIDs: [])
    }

    func updateUserProfile(uid: String, displayName: String, phone: String, city: String, token _: String) async throws {
        // Dot-path update preserves all other preference fields; overwriting the
        // preferences map could erase a customer's settings from another device.
        try await database.collection("users").document(uid).updateData([
            "displayName": displayName,
            "phoneNumber": phone,
            "preferences.city": city,
            "updatedAt": Timestamp(date: Date())
        ])
    }

    func queryOrders(uid: String, token _: String) async throws -> [FirestoreDocument] {
        try await query(collection: "orders", field: "customerId", equals: uid, limit: 120)
    }
    func queryFavorites(uid: String, token _: String) async throws -> [FirestoreDocument] {
        try await query(collection: "favorites", field: "userId", equals: uid, limit: 200)
    }
    func querySavedItems(uid: String, token _: String) async throws -> [FirestoreDocument] {
        try await query(collection: "savedItems", field: "userId", equals: uid, limit: 200)
    }
    func queryNotifications(uid: String, token _: String) async throws -> [FirestoreDocument] {
        try await query(collection: "notifications", field: "userId", equals: uid, limit: 100)
    }

    func setFavorite(uid: String, businessId: String, saved: Bool, token _: String) async throws {
        let ref = database.collection("favorites").document("\(uid)_\(businessId)")
        if saved {
            try await ref.setData(["userId": uid, "businessId": businessId,
                                   "createdAt": Timestamp(date: Date())], merge: true)
        } else {
            try await ref.delete()
        }
    }

    func setSavedItem(uid: String, item: SavedEntity, saved: Bool, token _: String) async throws {
        let safeEntity = item.entityID.replacingOccurrences(of: "[^a-zA-Z0-9_-]", with: "_", options: .regularExpression).prefix(140)
        let ref = database.collection("savedItems").document("\(uid)_\(item.type.rawValue)_\(safeEntity)")
        if saved {
            let data: [String: Any] = [
                "userId": uid, "type": item.type.rawValue, "entityId": item.entityID,
                "businessId": item.businessID.map { $0 as Any } ?? NSNull(),
                "title": item.title, "subtitle": item.subtitle,
                "image": item.imageURL?.absoluteString ?? "", "city": item.city ?? "",
                "area": item.area ?? "", "createdAt": Timestamp(date: Date()),
                "updatedAt": Timestamp(date: Date())
            ]
            try await ref.setData(data, merge: true)
        } else {
            try await ref.delete()
        }
    }

    func markNotificationRead(id: String, token _: String) async throws {
        try await database.collection("notifications").document(id).updateData([
            "read": true, "readAt": Timestamp(date: Date())
        ])
    }

    func setPushToken(uid: String, token: String, active: Bool, idToken _: String) async throws {
        let ref = database.collection("pushTokens").document(token.replacingOccurrences(of: "/", with: "_"))
        try await ref.setData([
            "token": token, "userId": uid, "workspace": "customer", "origin": "ios",
            "userAgent": "Spotly iOS/\(SpotlyConfiguration.appVersion)",
            "active": active, "updatedAt": Timestamp(date: Date())
        ], merge: true)
    }

    func readNotificationPreferences(uid: String, token _: String) async throws -> FirestoreDocument? {
        let snapshot = try await database.collection("notificationPreferences").document(uid).getDocument()
        return snapshot.exists ? convert(snapshot) : nil
    }

    func saveNotificationPreferences(uid: String, orderUpdates: Bool, bookingUpdates: Bool, rideSendUpdates: Bool, marketing: Bool, token _: String) async throws {
        try await database.collection("notificationPreferences").document(uid).setData([
            "userId": uid, "orderUpdates": orderUpdates, "bookingUpdates": bookingUpdates,
            "rideSendUpdates": rideSendUpdates, "marketing": marketing,
            "emailUpdates": true, "updatedAt": Timestamp(date: Date())
        ], merge: true)
    }

    private func query(collection: String, field: String, equals value: String, limit: Int) async throws -> [FirestoreDocument] {
        let result = try await database.collection(collection)
            .whereField(field, isEqualTo: value)
            .limit(to: limit)
            .getDocuments()
        return result.documents.map(convert)
    }

    private func convert(_ snapshot: DocumentSnapshot) -> FirestoreDocument {
        FirestoreDocument(id: snapshot.documentID,
                          fields: (snapshot.data() ?? [:]).compactMapValues(Self.scalar))
    }

    private static func scalar(_ raw: Any) -> FirestoreScalar? {
        if raw is NSNull { return .null }
        if let value = raw as? Timestamp { return .timestamp(value.dateValue()) }
        if let point = raw as? GeoPoint {
            return .map(["lat": .number(point.latitude), "lng": .number(point.longitude)])
        }
        if let map = raw as? [String: Any] { return .map(map.compactMapValues(scalar)) }
        if let array = raw as? [Any] { return .array(array.compactMap(scalar)) }
        if let number = raw as? NSNumber {
            if CFGetTypeID(number) == CFBooleanGetTypeID() { return .bool(number.boolValue) }
            return .number(number.doubleValue)
        }
        if let value = raw as? String { return .string(value) }
        if let value = raw as? Date { return .timestamp(value) }
        return nil
    }

    private func fallbackName(_ email: String) -> String {
        email.split(separator: "@").first.map(String.init) ?? "Spotly user"
    }
}
