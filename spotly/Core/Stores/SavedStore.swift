import Foundation
import Observation

@MainActor
@Observable
final class SavedStore {
    var businessIDs: Set<String> = []
    var businesses: [RemoteBusiness] = []
    var items: [SavedEntity] = []
    var isLoading = false
    var errorMessage: String?

    var unavailableIDs: Set<String> = []
    private let api: APIClient
    private let defaults: UserDefaults
    private var ownerID: String?
    private var generation = UUID()
    private var cache: [String: (RemoteBusiness, Date)] = [:]
    private var pendingIDs: [String] = []
    var hasMore: Bool { !pendingIDs.isEmpty }
    private let firestore = FirestoreREST.shared
    private let guestKey = "spotly.guest.saved.businesses.v2"

    init(api: APIClient = .shared, defaults: UserDefaults = .standard) {
        self.api = api; self.defaults = defaults
        businessIDs = Set(defaults.stringArray(forKey: guestKey) ?? [])
    }

    func reset() {
        generation = UUID(); ownerID = nil; cache = [:]; pendingIDs = []; unavailableIDs = []
        businessIDs = Set(defaults.stringArray(forKey: guestKey) ?? [])
        businesses = []; items = []; isLoading = false; errorMessage = nil
    }

    func isBusinessSaved(_ id: String) -> Bool { businessIDs.contains(id) }
    func isSaved(type: SavedEntityType, id: String) -> Bool { items.contains { $0.type == type && $0.entityID == id } }

    func load(user: SpotlyUser?, force: Bool = false) async {
        if ownerID != user?.id { reset(); ownerID = user?.id }
        guard !isLoading else { return }
        isLoading = true; errorMessage = nil
        let request = generation
        defer { if generation == request { isLoading = false } }
        do {
            if let user {
                guard let token = try await SessionController.shared.validIDToken() else { throw SpotlyAPIError.unauthenticated }
                async let favoriteDocs = firestore.queryFavorites(uid: user.id, token: token)
                async let savedDocs = firestore.querySavedItems(uid: user.id, token: token)
                let (favorites, saved) = try await (favoriteDocs, savedDocs)
                guard generation == request, !Task.isCancelled else { return }
                let remoteIDs = Set(favorites.compactMap { $0.fields["businessId"]?.stringValue?.nilIfBlank })
                let guestIDs = Set(defaults.stringArray(forKey: guestKey) ?? [])
                var pendingGuest = guestIDs
                for id in pendingGuest.sorted() {
                    if !remoteIDs.contains(id) { try await firestore.setFavorite(uid: user.id, businessId: id, saved: true, token: token) }
                    pendingGuest.remove(id)
                    defaults.set(pendingGuest.sorted(), forKey: guestKey)
                }
                businessIDs = remoteIDs.union(guestIDs)
                var seen = Set<String>()
                items = saved.sorted { ($0.fields["createdAt"]?.dateValue ?? .distantPast) > ($1.fields["createdAt"]?.dateValue ?? .distantPast) || ($0.fields["createdAt"]?.dateValue == $1.fields["createdAt"]?.dateValue && $0.id < $1.id) }.compactMap(Self.savedEntity).filter { seen.insert($0.id).inserted }
            }
            guard generation == request else { return }
            if force { cache = [:] }
            pendingIDs = businessIDs.sorted()
            businesses = []; unavailableIDs = []
            try await hydrateNext(generation: request)
        } catch {
            guard generation == request, !Task.isCancelled else { return }
            errorMessage = error.localizedDescription
        }
    }

    func loadMore() async {
        guard !isLoading, !pendingIDs.isEmpty else { return }
        isLoading = true
        let request = generation
        defer { if generation == request { isLoading = false } }
        do { try await hydrateNext(generation: request) }
        catch { if generation == request, !Task.isCancelled { errorMessage = error.localizedDescription } }
    }

    func toggleBusiness(_ business: RemoteBusiness, user: SpotlyUser?) async {
        let request = generation
        let priorBusinesses = businesses
        let wasSaved = businessIDs.contains(business.id)
        if wasSaved { businessIDs.remove(business.id) } else { businessIDs.insert(business.id) }
        if wasSaved { businesses.removeAll { $0.id == business.id } }
        else if !businesses.contains(where: { $0.id == business.id }) { businesses.insert(business, at: 0) }

        guard let user else {
            defaults.set(businessIDs.sorted(), forKey: guestKey)
            return
        }
        do {
            guard let token = try await SessionController.shared.validIDToken() else { throw SpotlyAPIError.unauthenticated }
            guard generation == request else { return }
            try await firestore.setFavorite(uid: user.id, businessId: business.id, saved: !wasSaved, token: token)
        } catch {
            guard generation == request else { return }
            if wasSaved { businessIDs.insert(business.id) } else { businessIDs.remove(business.id) }
            businesses = priorBusinesses
            errorMessage = error.localizedDescription
        }
    }

    func toggleItem(_ entity: SavedEntity, user: SpotlyUser?) async {
        let request = generation
        let wasSaved = isSaved(type: entity.type, id: entity.entityID)
        if wasSaved { items.removeAll { $0.type == entity.type && $0.entityID == entity.entityID } }
        else { items.insert(entity, at: 0) }
        guard let user else {
            errorMessage = "Sign in to keep products, services and events synced across devices."
            if wasSaved { items.insert(entity, at: 0) }
            else { items.removeAll { $0.id == entity.id } }
            return
        }
        do {
            guard let token = try await SessionController.shared.validIDToken() else { throw SpotlyAPIError.unauthenticated }
            // A previous user's outstanding toggle must not write or roll back
            // the new account's Saved screen after sign-out or switching users.
            guard generation == request, ownerID == nil || ownerID == user.id else { return }
            try await firestore.setSavedItem(uid: user.id, item: entity, saved: !wasSaved, token: token)
        } catch {
            guard generation == request, ownerID == nil || ownerID == user.id else { return }
            if wasSaved { items.insert(entity, at: 0) }
            else { items.removeAll { $0.id == entity.id } }
            errorMessage = error.localizedDescription
        }
    }

    private func hydrateNext(generation: UUID) async throws {
        let ids = Array(pendingIDs.prefix(40))
        guard !ids.isEmpty else { return }
        let values = try await hydrateBusinesses(ids)
        guard self.generation == generation, !Task.isCancelled else { return }
        pendingIDs.removeFirst(ids.count)
        var seen = Set(businesses.map(\.id))
        businesses.append(contentsOf: values.filter { seen.insert($0.id).inserted })
    }

    func hydrateBusinesses(_ ids: [String]) async throws -> [RemoteBusiness] {
        let ordered = Array(Set(ids)).sorted()
        var result: [RemoteBusiness] = []
        let missing = ordered.filter { id in
            if let entry = cache[id], Date().timeIntervalSince(entry.1) < 300 { result.append(entry.0); return false }
            return true
        }
        // Hydrate public Firestore merchant records without routing them through
        // Next.js. Editorial/open-directory IDs still require the web's curated
        // dataset; the website is a compatibility fallback only for those IDs.
        var websiteOnly = missing
        if NativeMarketplaceRepository.shared.isConfigured, !missing.isEmpty {
            let native = await NativeMarketplaceRepository.shared.publicBusinesses(ids: missing)
            for business in native { cache[business.id] = (business, Date()) }
            result.append(contentsOf: native)
            let nativeIDs = Set(native.map(\.id))
            websiteOnly = missing.filter { !nativeIDs.contains($0) }
        }
        for offset in stride(from: 0, to: websiteOnly.count, by: 40) {
            try Task.checkCancellation()
            let batch = Array(websiteOnly.dropFirst(offset).prefix(40))
            do {
                let response: BusinessBatchResponse = try await api.get("/api/public/marketplace/businesses", query: batch.map { URLQueryItem(name: "id", value: $0) })
                for business in response.businesses { cache[business.id] = (business, Date()) }
                unavailableIDs.formUnion(response.unavailableIDs)
                result.append(contentsOf: response.businesses)
            } catch let error as SpotlyAPIError {
                // Production compatibility while the new batch contract rolls out. Keep this
                // only as a 404 bridge; once deployed, Saved uses one batched request.
                if case .server(let status, _) = error, status == 404 {
                    let legacy = await hydrateBusinessesIndividually(batch)
                    for business in legacy.businesses { cache[business.id] = (business, Date()) }
                    unavailableIDs.formUnion(legacy.unavailableIDs)
                    result.append(contentsOf: legacy.businesses)
                } else {
                    throw error
                }
            }
        }
        return result.sorted { $0.id < $1.id }
    }


    private func hydrateBusinessesIndividually(_ ids: [String]) async -> (businesses: [RemoteBusiness], unavailableIDs: Set<String>) {
        var businesses: [RemoteBusiness] = []
        var unavailable = Set<String>()
        // This path is deliberately conservative because it exists only for older deployments
        // that do not yet expose the batch endpoint. Caching keeps repeat visits cheap.
        for id in ids.prefix(16) {
            if Task.isCancelled { break }
            do {
                let response: BusinessDetailResponse = try await api.get("/api/public/marketplace/business", query: [URLQueryItem(name: "businessId", value: id)])
                businesses.append(response.business)
            } catch let error as SpotlyAPIError {
                if case .server(let status, _) = error, status == 404 { unavailable.insert(id) }
                else { unavailable.insert(id) }
            } catch {
                unavailable.insert(id)
            }
        }
        if ids.count > 16 { unavailable.formUnion(ids.dropFirst(16)) }
        return (businesses, unavailable)
    }

    static func savedEntity(_ doc: FirestoreDocument) -> SavedEntity? {
        guard let rawType = doc.fields["type"]?.stringValue, let type = SavedEntityType(rawValue: rawType), let entityID = doc.fields["entityId"]?.stringValue else { return nil }
        let businessID = doc.fields["businessId"]?.stringValue?.trimmingCharacters(in: .whitespacesAndNewlines)
        let title = doc.fields["title"]?.stringValue?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "Saved item"
        let normalizedTitle = title.lowercased()
        let legacyAddressShortcut = type == .place && (businessID?.isEmpty ?? true) && ["home", "work"].contains(normalizedTitle)
        if legacyAddressShortcut { return nil }
        return SavedEntity(
            type: type,
            entityID: entityID,
            businessID: businessID?.isEmpty == false ? businessID : nil,
            title: title,
            subtitle: doc.fields["subtitle"]?.stringValue ?? "",
            imageURL: RemoteMedia.url(doc.fields["image"]?.stringValue),
            city: doc.fields["city"]?.stringValue,
            area: doc.fields["area"]?.stringValue,
            address: doc.fields["address"]?.stringValue
        )
    }
}

nonisolated struct BusinessBatchResponse: Decodable {
    let ok: Bool
    let businesses: [RemoteBusiness]
    let unavailableIDs: [String]
}
