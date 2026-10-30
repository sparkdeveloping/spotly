import Foundation
import FirebaseCore
import FirebaseFirestore

/// Reads the authoritative public merchant catalogue directly from Firestore.
/// The editorial/open-directory layer on web is NOT stored in these documents;
/// MarketplaceStore retains a public-web compatibility path for those IDs.
@MainActor
final class NativeMarketplaceRepository {
    static let shared = NativeMarketplaceRepository()
    private init() {}

    private var database: Firestore { Firestore.firestore() }
    private var cachedPublicMerchants: [RemoteBusiness] = []
    private var publicMerchantCacheDate: Date?
    private var publicMerchantTask: Task<[RemoteBusiness], Error>?

    var isConfigured: Bool { FirebaseBootstrap.isReady }

    /// Resilient, bounded fallback when web's enriched directory service fails.
    /// The backend holds many more curated records and sophisticated rankings;
    /// this intentionally covers only verified/licensed Firestore businesses.
    private func publicMerchantSeed() async throws -> [RemoteBusiness] {
        guard isConfigured else { throw SpotlyAPIError.firebaseUnconfigured }
        if let cacheDate = publicMerchantCacheDate,
           Date().timeIntervalSince(cacheDate) < 180 { return cachedPublicMerchants }
        if let task = publicMerchantTask { return try await task.value }
        let task = Task { () throws -> [RemoteBusiness] in
            let docs = try await database.collection("businesses")
                .whereField("public", isEqualTo: true)
                .order(by: "name")
                .limit(to: 80)
                .getDocuments()
            return docs.documents.compactMap { doc -> RemoteBusiness? in
                guard NativeMarketMapper.isPubliclyDiscoverable(doc.data()) else { return nil }
                return try? NativeMarketMapper.business(id: doc.documentID, raw: doc.data())
            }
        }
        publicMerchantTask = task
        defer { publicMerchantTask = nil }
        let result = try await task.value
        cachedPublicMerchants = result
        publicMerchantCacheDate = Date()
        return result
    }

    func fallbackFeed(service: SpotlyServiceKind, city: String, area: String? = nil,
                      query: String = "", category: String? = nil, offset: Int = 0,
                      limit: Int = 24) async throws -> ServiceFeedResponse {
        let cleanCity = city.trimmingCharacters(in: .whitespacesAndNewlines)
        let filtered = try await publicMerchantSeed().filter { business in
            (cleanCity.isEmpty || business.city?.localizedCaseInsensitiveCompare(cleanCity) == .orderedSame) &&
            (area?.isEmpty != false || business.area?.localizedCaseInsensitiveCompare(area ?? "") == .orderedSame) &&
            NativeMarketMapper.service(for: business) == service &&
            (query.isEmpty || NativeMarketMapper.matches(business, query: query)) &&
            (category == nil || business.displayCategory.localizedCaseInsensitiveCompare(category ?? "") == .orderedSame)
        }
        let sorted = filtered.sorted {
            if $0.isCommerceVerified != $1.isCommerceVerified { return $0.isCommerceVerified }
            if $0.isFeatured != $1.isFeatured { return $0.isFeatured == true }
            return $0.displayName.localizedStandardCompare($1.displayName) == .orderedAscending
        }
        // Business-only fallback deliberately avoids unbounded product reads.
        let page = Array(sorted.dropFirst(offset).prefix(min(max(limit, 1), 48)))
        let categories = Array(Set(sorted.map(\.displayCategory))).sorted()
        return ServiceFeedResponse(ok: true, service: service.rawValue, city: city,
                                   area: area, query: query, businesses: page, items: [],
                                   categories: categories, facets: nil,
                                   totalBusinesses: sorted.count, totalItems: 0,
                                   nextOffset: offset + page.count < sorted.count ? offset + page.count : nil)
    }

    func fallbackSearch(query: String, city: String, service: SpotlyServiceKind?,
                        offset: Int = 0, limit: Int = 24) async throws -> SearchResponse {
        let matches = try await publicMerchantSeed().filter { business in
            (city.isEmpty || business.city?.localizedCaseInsensitiveCompare(city) == .orderedSame) &&
            (service == nil || NativeMarketMapper.service(for: business) == service) &&
            NativeMarketMapper.matches(business, query: query)
        }
        let page = Array(matches.dropFirst(offset).prefix(min(max(limit, 1), 48)))
        let results: [RemoteSearchResult] = page.compactMap { business in
            try? NativeMarketMapper.searchResult(from: business)
        }
        return SearchResponse(ok: true, results: results, total: matches.count,
                              nextOffset: offset + page.count < matches.count ? offset + page.count : nil)
    }

    /// A `nil` result means the ID is not present in Firestore (e.g. a curated
    /// directory place); do not confuse it with a private/unpublished record.
    func publicBusiness(id: String) async throws -> RemoteBusiness? {
        guard isConfigured else { throw SpotlyAPIError.firebaseUnconfigured }
        guard !id.isEmpty, !id.contains("/") else { return nil }
        let snapshot = try await database.collection("businesses").document(id).getDocument()
        guard let raw = snapshot.data() else { return nil }
        guard NativeMarketMapper.isPubliclyDiscoverable(raw) else { return nil }
        return try NativeMarketMapper.business(id: snapshot.documentID, raw: raw)
    }

    func businessDetail(id: String) async throws -> BusinessDetailResponse? {
        guard isConfigured else { throw SpotlyAPIError.firebaseUnconfigured }
        guard !id.isEmpty, !id.contains("/") else { return nil }
        let snapshot = try await database.collection("businesses").document(id).getDocument()
        guard let raw = snapshot.data() else { return nil }
        // A private document must not be laundered through a fallback API.
        guard NativeMarketMapper.isPubliclyDiscoverable(raw) else {
            throw SpotlyAPIError.server(status: 404, message: "This place is not currently public.")
        }
        let business = try NativeMarketMapper.business(id: snapshot.documentID, raw: raw)
        let trusted = NativeMarketMapper.commerceVerified(raw)
        let eligibleForPublicChildren = NativeMarketMapper.childrenArePubliclyReadable(raw)
        var branches: [RemoteBranch] = []
        var products: [RemoteItem] = []
        if eligibleForPublicChildren {
            // Queries include the public/published constraints required by the
            // checked-in Firestore rules and the existing composite indexes.
            let branchDocs = try await database.collection("branches")
                .whereField("businessId", isEqualTo: id)
                .whereField("public", isEqualTo: true)
                .limit(to: 60).getDocuments()
            branches = branchDocs.documents.compactMap { doc in
                try? NativeMarketMapper.branch(id: doc.documentID, raw: doc.data())
            }.filter { $0.status?.lowercased() != "archived" && $0.status?.lowercased() != "removed" }
            if trusted {
                let productDocs = try await database.collection("products")
                    .whereField("businessId", isEqualTo: id)
                    .whereField("published", isEqualTo: true)
                    .whereField("active", isEqualTo: true)
                    .limit(to: 100).getDocuments()
                products = productDocs.documents.compactMap { doc in
                    try? NativeMarketMapper.product(id: doc.documentID, raw: doc.data(), business: business)
                }.filter { $0.available != false }
            }
        }
        return BusinessDetailResponse(ok: true, business: business, branches: branches,
                                      products: products, transactional: trusted, claimAvailable: nil)
    }

    func publicItem(id: String) async throws -> RemoteItem? {
        guard isConfigured else { throw SpotlyAPIError.firebaseUnconfigured }
        guard !id.isEmpty, !id.contains("/") else { return nil }
        let snapshot = try await database.collection("products").document(id).getDocument()
        guard let raw = snapshot.data(), raw["published"] as? Bool == true,
              raw["active"] as? Bool == true, raw["available"] as? Bool != false,
              let businessID = raw["businessId"] as? String,
              let business = try await publicBusiness(id: businessID) else { return nil }
        return try NativeMarketMapper.product(id: snapshot.documentID, raw: raw, business: business)
    }

    /// One document request per ID rather than an `in` query: a single removed
    /// or private saved record must not fail the entire user collection.
    /// Limit concurrency to avoid a burst of dozens of reads at once.
    func publicBusinesses(ids: [String]) async -> [RemoteBusiness] {
        guard isConfigured else { return [] }
        let uniqueIDs = Array(Set(ids.filter { !$0.isEmpty && !$0.contains("/") })).sorted()
        var found: [RemoteBusiness] = []
        for chunkStart in stride(from: 0, to: uniqueIDs.count, by: 8) {
            let chunk = Array(uniqueIDs.dropFirst(chunkStart).prefix(8))
            await withTaskGroup(of: RemoteBusiness?.self) { group in
                for id in chunk {
                    group.addTask { try? await self.publicBusiness(id: id) }
                }
                for await value in group {
                    if let value { found.append(value) }
                }
            }
            if Task.isCancelled { break }
        }
        return found.sorted { $0.id < $1.id }
    }
}

/// Pure, bounded transformation of real Firestore documents to the public view
/// contract. Explicit allowlists avoid type crashes from untrusted/old records.
@MainActor
enum NativeMarketMapper {
    static func isPubliclyDiscoverable(_ raw: [String: Any]) -> Bool {
        guard raw["public"] as? Bool == true else { return false }
        let status = string(raw, "status").lowercased()
        guard status != "archived", status != "removed", status != "deleted" else { return false }
        guard string(raw, "canonicalBusinessId").isEmpty else { return false }
        let source = raw["source"] as? [String: Any] ?? [:]
        if string(source, "type") == "spotly_assist_research", raw["launchApproved"] as? Bool != true { return false }
        // The server also checks claimed/verified/licensed provenance. Native
        // business detail links must not show unpublished/unknown imports.
        let claim = string(raw, "ownershipStatus").isEmpty ? string(raw, "claimStatus") : string(raw, "ownershipStatus")
        let verified = ["verified", "approved", "spotly_verified"].contains(string(raw, "verificationStatus").lowercased())
        let claimPending = ["claim_pending", "claimed_pending_verification", "pending"].contains(claim.lowercased())
        let owned = !claimPending && (["claimed", "owner_verified"].contains(claim.lowercased()) || !(raw["ownerIds"] as? [String] ?? []).isEmpty)
        let rights = string(source, "rightsStatus").isEmpty ? string(raw, "sourceRightsStatus") : string(source, "rightsStatus")
        return owned || verified || commerceVerified(raw) || ["open_odbl", "spotly_created", "licensed", "merchant_owned"].contains(rights.lowercased())
    }

    static func childrenArePubliclyReadable(_ raw: [String: Any]) -> Bool {
        let status = string(raw, "status").lowercased()
        let lifecycle = string(raw, "lifecycleStatus").lowercased()
        return ["active", "paused"].contains(status) || ["live", "paused"].contains(lifecycle)
    }

    static func commerceVerified(_ raw: [String: Any]) -> Bool {
        let source = raw["source"] as? [String: Any] ?? [:]
        if string(source, "type") == "spotly_assist_research" { return false }
        let c = string(raw, "commerceVerificationStatus").lowercased()
        if raw["commerceEnabled"] as? Bool == true || raw["commerceVerified"] as? Bool == true ||
            ["verified", "approved", "commerce_verified"].contains(c) { return true }
        let claim = string(raw, "ownershipStatus").isEmpty ? string(raw, "claimStatus") : string(raw, "ownershipStatus")
        let pending = ["claim_pending", "claimed_pending_verification", "pending"].contains(claim.lowercased())
        let claimed = !pending && (["claimed", "owner_verified"].contains(claim.lowercased()) || !(raw["ownerIds"] as? [String] ?? []).isEmpty)
        let verified = ["approved", "verified", "spotly_verified"].contains(string(raw, "verificationStatus").lowercased())
        return claimed && verified && childrenArePubliclyReadable(raw)
    }

    static func matches(_ business: RemoteBusiness, query: String) -> Bool {
        let query = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return true }
        return [business.displayName, business.displayCategory,
                business.description ?? "", business.area ?? "", business.city ?? ""]
            .contains { $0.localizedStandardContains(query) }
    }

    static func service(for business: RemoteBusiness) -> SpotlyServiceKind? {
        let archetype = business.businessType?.lowercased() ?? ""
        switch archetype {
        case "restaurant_food": return .eat
        case "grocery_retail": return .shop
        case "appointments_services", "accommodation_activities": return .book
        case "ticketing_events": return .events
        default: break
        }
        let terms = ([business.displayName, business.displayCategory] +
                     (business.categories ?? []) + [archetype]).joined(separator: " ").lowercased()
        if ["restaurant", "cafe", "bakery", "takeaway", "food court", "pizza", "chicken", "coffee"].contains(where: terms.contains) { return .eat }
        if ["barber", "salon", "spa", "gym", "fitness", "hotel", "lodge", "clinic", "dentist", "nail"].contains(where: terms.contains) { return .book }
        if ["cinema", "theatre", "event", "concert", "festival", "museum", "conference"].contains(where: terms.contains) { return .events }
        if ["supermarket", "retail", "grocer", "shop", "store", "pharmacy", "market", "hardware", "fashion", "electronics"].contains(where: terms.contains) { return .shop }
        return nil
    }

    static func searchResult(from business: RemoteBusiness) throws -> RemoteSearchResult {
        var values: [String: Any] = ["id": business.id, "entityId": business.id,
                                     "type": "business", "businessId": business.id,
                                     "name": business.displayName, "title": business.displayName,
                                     "displayCategory": business.displayCategory,
                                     "commerceVerified": business.isCommerceVerified]
        for (key, value) in ["description": business.description,
                             "image": business.coverImage ?? business.image ?? business.logoUrl,
                             "city": business.city, "area": business.area, "address": business.address] {
            if let value { values[key] = value }
        }
        return try decode(RemoteSearchResult.self, values)
    }

    static func business(id: String, raw: [String: Any]) throws -> RemoteBusiness {
        var fields: [String: Any] = ["id": id]
        for key in ["name", "brandName", "category", "city", "area", "suburb", "address", "tagline", "description", "coverImage", "image", "logoUrl", "verificationStatus", "businessType"] {
            if let str = raw[key] as? String { fields[key] = str }
        }
        if fields["name"] == nil { fields["name"] = string(raw, "brandName") }
        if fields["logoUrl"] == nil { fields["logoUrl"] = string(raw, "logo") }
        if fields["area"] == nil { fields["area"] = string(raw, "suburb") }
        fields["commerceVerified"] = commerceVerified(raw)
        for key in ["isFeatured"] { if let value = raw[key] as? Bool { fields[key] = value } }
        for key in ["rating", "reviewCount", "latitude", "longitude"] {
            if let value = numeric(raw[key]) { fields[key] = value }
        }
        if fields["latitude"] == nil || fields["longitude"] == nil {
            let coordinates = raw["coordinates"] as? [String: Any] ?? raw["location"] as? [String: Any] ?? [:]
            fields["latitude"] = fields["latitude"] ?? numeric(coordinates["lat"])
            fields["longitude"] = fields["longitude"] ?? numeric(coordinates["lng"])
        }
        for key in ["categories", "capabilities"] {
            if let values = raw[key] as? [String] { fields[key] = values }
        }
        return try decode(RemoteBusiness.self, fields)
    }

    static func branch(id: String, raw: [String: Any]) throws -> RemoteBranch {
        var fields: [String: Any] = ["id": id]
        for key in ["businessId", "branchName", "name", "city", "suburb", "area", "address", "phone", "status"] {
            if let value = raw[key] as? String { fields[key] = value }
        }
        for key in ["fulfilment", "paymentMethods", "acceptedCurrencies"] {
            if let values = raw[key] as? [String] { fields[key] = values }
        }
        if let value = raw["delivery"] as? [String: Any] {
            var delivery: [String: Any] = [:]
            for key in ["enabled", "paused"] { delivery[key] = value[key] as? Bool }
            for key in ["fee", "radiusKm"] { delivery[key] = numeric(value[key]) }
            fields["delivery"] = delivery
        }
        let location = raw["location"] as? [String: Any] ?? [:]
        if let lat = numeric(location["lat"]), let lng = numeric(location["lng"]) {
            fields["location"] = ["lat": lat, "lng": lng]
        }
        return try decode(RemoteBranch.self, fields)
    }

    static func product(id: String, raw: [String: Any], business: RemoteBusiness) throws -> RemoteItem {
        let itemType = (raw["itemType"] as? String ?? "product").lowercased()
        let type = ["event", "ticket"].contains(itemType) ? "event" :
            ["service", "appointment", "booking", "activity", "stay", "listing"].contains(itemType) ? "service" : "product"
        var fields: [String: Any] = ["id": id, "entityId": id, "businessName": business.displayName,
                                     "businessId": business.id, "type": type]
        for key in ["name", "description", "category", "image", "brand", "variant", "packSize", "unit", "currency", "stockStatus", "itemType", "venue", "city", "area"] {
            if let value = raw[key] as? String { fields[key] = value }
        }
        fields["title"] = fields["name"] ?? "Offering"
        if fields["image"] == nil { fields["image"] = string(raw, "imageUrl") }
        for key in ["price", "compareAtPrice", "stockQuantity", "durationMinutes", "capacity", "remainingCapacity", "maxQuantity"] {
            if let value = numeric(raw[key]) { fields[key] = value }
        }
        for key in ["available", "pickupEligible", "published", "isFeatured"] {
            if let value = raw[key] as? Bool { fields[key] = value }
        }
        if let values = raw["prices"] as? [String: Any] {
            fields["prices"] = values.compactMapValues(numeric)
        }
        if let tags = raw["tags"] as? [String] { fields["tags"] = Array(tags.prefix(20)) }
        if let timestamp = raw["startsAt"] as? Timestamp { fields["startsAt"] = ISO8601DateFormatter().string(from: timestamp.dateValue()) }
        if let timestamp = raw["endsAt"] as? Timestamp { fields["endsAt"] = ISO8601DateFormatter().string(from: timestamp.dateValue()) }
        return try decode(RemoteItem.self, fields)
    }

    private static func string(_ raw: [String: Any], _ key: String) -> String { raw[key] as? String ?? "" }
    private static func numeric(_ raw: Any?) -> Double? {
        if let value = raw as? NSNumber { return value.doubleValue.isFinite ? value.doubleValue : nil }
        if let value = raw as? String, let number = Double(value), number.isFinite { return number }
        return nil
    }
    private static func decode<T: Decodable>(_ type: T.Type, _ values: [String: Any]) throws -> T {
        let data = try JSONSerialization.data(withJSONObject: values)
        return try JSONDecoder().decode(type, from: data)
    }
}
