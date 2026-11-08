import Foundation
import Observation

@MainActor
@Observable
final class MarketplaceStore {
    var feeds: [SpotlyServiceKind: ServiceFeedResponse] = [:]
    var feedErrors: [SpotlyServiceKind: String] = [:]
    var loadingFeeds: Set<SpotlyServiceKind> = []
    var isLoadingHome: Bool { !loadingFeeds.isEmpty }
    var homeError: String? { feeds.isEmpty ? feedErrors.values.first : nil }
    var searchResults: [RemoteSearchResult] { searchRequest.value?.results ?? [] }
    var isSearching: Bool { searchRequest.isLoading }
    var searchError: String? { searchRequest.error }
    let searchRequest: PagedRequest<SearchIntent, SearchResponse>
    private let api: APIClient
    private let defaults: UserDefaults
    private var homeCity: String?
    private var homeGeneration = UUID()
    private var homeTask: Task<Void, Never>?
    private var homeLoadedAt: Date?

    init(api: APIClient = .shared, defaults: UserDefaults = .standard) {
        self.api = api
        self.defaults = defaults
        searchRequest = PagedRequest(fetch: { intent, offset in
            var query = [URLQueryItem(name: "q", value: intent.query), URLQueryItem(name: "city", value: intent.city), URLQueryItem(name: "limit", value: "24"), URLQueryItem(name: "offset", value: String(offset))]
            if let service = intent.service { query.append(URLQueryItem(name: "service", value: service.rawValue)) }
            if let type = intent.type { query.append(URLQueryItem(name: "type", value: type)) }
            do {
                return try await api.get("/api/public/search", query: query)
            } catch {
                guard await NativeMarketplaceRepository.shared.isConfigured else { throw error }
                return try await NativeMarketplaceRepository.shared.fallbackSearch(
                    query: intent.query, city: intent.city, service: intent.service,
                    offset: offset, limit: 24)
            }
        }, next: { $0.nextOffset }, merge: { old, page in
            var seen = Set<String>()
            return SearchResponse(ok: page.ok, results: (old.results + page.results).filter { seen.insert("\($0.type ?? "business"):\($0.entityID)").inserted }, total: page.total, nextOffset: page.nextOffset)
        })
    }

    /// Clear all in-memory discovery state when the active account changes.
    /// Cancels outstanding work so an old response cannot rehydrate a new user.
    func resetForAccountChange() {
        homeTask?.cancel()
        homeTask = nil
        homeGeneration = UUID()
        homeCity = nil
        homeLoadedAt = nil
        loadingFeeds = []
        feeds = [:]
        feedErrors = [:]
        searchRequest.cancel(clear: true)
    }

    func loadHome(city: String, force: Bool = false) async {
        if homeCity == city, !force {
            if let homeTask, isLoadingHome { await homeTask.value; return }
            if let homeLoadedAt, Date().timeIntervalSince(homeLoadedAt) < 120, feedErrors.isEmpty { return }
        }
        homeTask?.cancel()
        homeGeneration = UUID()
        let generation = homeGeneration
        if homeCity != city { feeds = [:]; feedErrors = [:] }
        homeCity = city
        loadingFeeds = [.eat, .shop, .book, .events]
        homeTask = Task {
            await withTaskGroup(of: Void.self) { group in
                for service in [SpotlyServiceKind.eat, .shop, .book, .events] {
                    group.addTask { await self.loadHomeFeed(service, city: city, generation: generation) }
                }
            }
            if homeGeneration == generation { homeLoadedAt = Date() }
        }
        await homeTask?.value
    }

    private func loadHomeFeed(_ service: SpotlyServiceKind, city: String, generation: UUID) async {
        do {
            let value = try await fetchFeed(service, city: city, limit: 16)
            guard homeGeneration == generation, !Task.isCancelled else { return }
            feeds[service] = value
            feedErrors[service] = nil
        } catch {
            guard homeGeneration == generation, !Task.isCancelled else { return }
            feedErrors[service] = error.localizedDescription
        }
        if homeGeneration == generation { loadingFeeds.remove(service) }
    }

    func fetchFeed(_ service: SpotlyServiceKind, city: String, area: String? = nil, query: String = "", category: String? = nil, offset: Int = 0, limit: Int = 24) async throws -> ServiceFeedResponse {
        guard [.eat, .shop, .book, .events].contains(service) else {
            throw SpotlyAPIError.server(status: 422, message: "That service uses a dedicated Spotly experience.")
        }
        var items = [
            URLQueryItem(name: "service", value: service.rawValue),
            URLQueryItem(name: "city", value: city),
            URLQueryItem(name: "offset", value: String(offset)),
            URLQueryItem(name: "limit", value: String(limit))
        ]
        if let area, !area.isEmpty { items.append(URLQueryItem(name: "area", value: area)) }
        if !query.isEmpty { items.append(URLQueryItem(name: "q", value: query)) }
        if let category { items.append(URLQueryItem(name: "category", value: category)) }
        do {
            return try await api.get("/api/public/service-feed", query: items)
        } catch {
            guard NativeMarketplaceRepository.shared.isConfigured else { throw error }
            return try await NativeMarketplaceRepository.shared.fallbackFeed(
                service: service, city: city, area: area, query: query,
                category: category, offset: offset, limit: limit)
        }
    }

    func business(id: String) async throws -> BusinessDetailResponse {
        if NativeMarketplaceRepository.shared.isConfigured {
            // Native path for actual Firestore merchants. Only use the website
            // for curated directory IDs that have no Firestore document.
            if let detail = try await NativeMarketplaceRepository.shared.businessDetail(id: id) {
                return detail
            }
        }
        return try await api.get("/api/public/marketplace/business", query: [URLQueryItem(name: "businessId", value: id)])
    }

    func geocode(_ text: String, city: String, country: SpotlyCountryCode) async throws -> [GeocodeResult] {
        guard text.trimmingCharacters(in: .whitespacesAndNewlines).count >= 3 else { return [] }
        // Native location search is primary; Spotly's existing licensed web
        // provider is retained for cities with limited Apple Maps coverage.
        if let results = try? await NativeLocationSearch.search(text, city: city, country: country), !results.isEmpty {
            return results
        }
        let response: GeocodeResponse = try await api.get("/api/public/geocode", query: [URLQueryItem(name: "q", value: text), URLQueryItem(name: "city", value: city), URLQueryItem(name: "country", value: country.rawValue)])
        return response.results
    }

    func search(_ text: String, city: String, service: SpotlyServiceKind? = nil, type: String? = nil) {
        let clean = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !clean.isEmpty else { searchRequest.cancel(clear: true); return }
        let intent = SearchIntent(query: clean, city: city, service: service, type: type)
        let old = searchRequest.intent
        // Never show results for an old query, filter or city as though they
        // match the new search. Preserve only an identical intent.
        searchRequest.load(intent, preserve: old == intent, debounce: .milliseconds(280))
    }

    func performSearch(_ text: String, city: String, service: SpotlyServiceKind? = nil, type: String? = nil) async {
        let clean = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !clean.isEmpty else { searchRequest.cancel(clear: true); return }
        let intent = SearchIntent(query: clean, city: city, service: service, type: type)
        searchRequest.load(intent, force: true, preserve: searchRequest.intent == intent)
        await searchRequest.wait()
    }

    var recentSearches: [String] {
        get { defaults.stringArray(forKey: "spotly.recentSearches") ?? [] }
        set { defaults.set(Array(newValue.prefix(8)), forKey: "spotly.recentSearches") }
    }

    func clearRecentSearches() { recentSearches = [] }

    func rememberSearch(_ value: String) {
        guard value.count >= 2 else { return }
        var values = recentSearches.filter { $0.caseInsensitiveCompare(value) != .orderedSame }
        values.insert(value, at: 0)
        recentSearches = values
    }
}
