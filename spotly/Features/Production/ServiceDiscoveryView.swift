import Foundation
import SwiftUI

struct ServiceDiscoveryView: View {
    let service: SpotlyServiceKind
    @Environment(AppState.self) private var appState
    @State private var request = makeServiceRequest()
    @State private var query = ""
    @State private var selectedCategory: String?
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    private var feed: ServiceFeedResponse? { request.value }
    private var isLoading: Bool { request.isLoading }
    private var currentIntent: ServiceIntent {
        ServiceIntent(service: service, city: appState.selectedCity, query: query.trimmingCharacters(in: .whitespacesAndNewlines), category: selectedCategory)
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 24) {
                serviceHero
                if let feed {
                    feedContent(feed)
                } else if isLoading {
                    ProgressView("Loading \(service.title)…").frame(maxWidth: .infinity).padding(.vertical, 70)
                } else if let errorMessage = request.error {
                    SpotlyNetworkStateView(title: "Couldn’t load \(service.title)", message: errorMessage, actionTitle: "Try again") {
                        Task { await reload() }
                    }
                }
                if let error = request.error, feed != nil {
                    SpotlyNetworkStateView(title: "Couldn’t update results", message: error, actionTitle: "Try again") { Task { await reload() } }
                }
                if request.nextOffset != nil {
                    Button("Load more") { request.loadMore() }.disabled(isLoading).frame(maxWidth: .infinity, minHeight: 44)
                }
                if isLoading && feed != nil { ProgressView("Updating…").frame(maxWidth: .infinity) }
            }
            .padding(.horizontal, 18)
            .padding(.bottom, 36)
        }
        .background(SpotlyColors.background)
        .contentMargins(.top, 12, for: .scrollContent)
        .navigationTitle(service.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .searchable(text: $query, prompt: searchPrompt)
        .onSubmit(of: .search) { Task { await reload() } }
        .onAppear { request.load(currentIntent) }
        .onChange(of: currentIntent) { _, intent in
            request.load(intent, debounce: intent.query.isEmpty ? .zero : .milliseconds(320))
        }
        .onDisappear { request.cancel() }
        .refreshable { await reload() }
    }

    private var serviceHero: some View {
        HStack(alignment: .center, spacing: 8) {
            VStack(alignment: .leading, spacing: 9) {
                Text("SPOTLY " + service.title.uppercased())
                    .font(SpotlyFont.caption(.bold))
                    .tracking(0.6)
                Text(heroTitle)
                    .font(SpotlyFont.title(.bold))
                    .fixedSize(horizontal: false, vertical: true)
                Text("Explore in " + appState.selectedCity)
                    .font(SpotlyFont.callout())
                    .opacity(0.9)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Image(service.artworkName)
                .resizable()
                .scaledToFit()
                .frame(width: dynamicTypeSize.isAccessibilitySize ? 74 : 116,
                       height: dynamicTypeSize.isAccessibilitySize ? 88 : 144)
                .accessibilityHidden(true)
        }
        .foregroundStyle(.white)
        .padding(18)
        .frame(maxWidth: .infinity, minHeight: 178, alignment: .leading)
        .background(service.tint.gradient, in: RoundedRectangle(cornerRadius: 26))
        .accessibilityElement(children: .combine)
    }

    private func categoryRail(_ categories: [String]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Browse by category").font(SpotlyFont.headline())
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    categoryButton("All", selected: selectedCategory == nil) { selectedCategory = nil }
                    ForEach(categories, id: \.self) { category in
                        categoryButton(category, selected: selectedCategory == category) {
                            selectedCategory = selectedCategory == category ? nil : category
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func feedContent(_ feed: ServiceFeedResponse) -> some View {
        if !feed.categories.isEmpty { categoryRail(feed.categories) }

        switch service {
        case .events:
            if !feed.items.isEmpty {
                itemSection(feed.items)
            } else {
                ContentUnavailableView {
                    Label("No live events yet", systemImage: "ticket")
                } description: {
                    Text("Spotly is still adding events in \(appState.selectedCity). Explore venues below or check again soon.")
                }
                .padding(.vertical, 8)
            }
            if !feed.businesses.isEmpty {
                businessSection(feed.businesses, title: "Popular venues", subtitle: "Places that host events and experiences", fallbackIcon: "building.columns")
            }
        case .book:
            let bookable = feed.businesses.filter(\.isCommerceVerified)
            let directory = feed.businesses.filter { !$0.isCommerceVerified }
            if !bookable.isEmpty {
                businessSection(bookable, title: "Book on Spotly", subtitle: "Verified businesses with Spotly booking")
            }
            if !feed.items.isEmpty { itemSection(feed.items) }
            if !directory.isEmpty {
                businessSection(directory, title: "Places to discover", subtitle: "Directory listings — booking appears only when enabled")
            }
            if bookable.isEmpty && directory.isEmpty && feed.items.isEmpty { emptyServiceState }
        case .eat:
            if !feed.businesses.isEmpty {
                businessSection(feed.businesses, title: "Restaurants to explore", subtitle: "Restaurants and food places in \(appState.selectedCity)")
            }
            if !feed.items.isEmpty { itemSection(feed.items) }
            if feed.businesses.isEmpty && feed.items.isEmpty { emptyServiceState }
        case .shop:
            if !feed.businesses.isEmpty {
                businessSection(feed.businesses, title: "Stores to explore", subtitle: "Shops and retail around \(appState.selectedCity)")
            }
            if !feed.items.isEmpty { itemSection(feed.items) }
            if feed.businesses.isEmpty && feed.items.isEmpty { emptyServiceState }
        default:
            if feed.businesses.isEmpty && feed.items.isEmpty { emptyServiceState }
        }
    }

    private var emptyServiceState: some View {
        ContentUnavailableView("Nothing live here yet", systemImage: service.icon, description: Text("Spotly is still filling out \(appState.selectedCity). Try another search or check back soon."))
    }

    private func businessSection(_ businesses: [RemoteBusiness], title: String, subtitle: String, fallbackIcon: String = "storefront") -> some View {
        VStack(alignment: .leading, spacing: 14) {
            SpotlySectionTitle(title: title, subtitle: subtitle)
            LazyVStack(spacing: 20) {
                ForEach(businesses) { business in
                    NavigationLink { MarketplaceBusinessDetailView(businessID: business.id, service: service) } label: {
                        SpotlyBusinessCard(
                            business: business,
                            tint: service.tint,
                            fallbackIcon: fallbackIcon,
                            saved: appState.saved.isBusinessSaved(business.id),
                            onSave: { Task { await appState.saved.toggleBusiness(business, user: appState.currentUser) } }
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func itemSection(_ items: [RemoteItem]) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            SpotlySectionTitle(title: itemSectionTitle, subtitle: "Available on Spotly")
            LazyVGrid(columns: dynamicTypeSize.isAccessibilitySize ? [GridItem(.flexible())] : [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 20) {
                ForEach(items) { item in
                    NavigationLink { MarketplaceItemDetailView(item: item, service: service) } label: {
                        SpotlyItemCard(item: item, tint: service.tint)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func categoryButton(_ title: String, selected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title).font(SpotlyFont.callout(.semibold))
                .foregroundStyle(selected ? .white : SpotlyColors.textSecondary)
                .padding(.horizontal, 14).padding(.vertical, 8)
                .background(selected ? service.tint : SpotlyColors.surface, in: Capsule())
                .overlay(Capsule().stroke(selected ? Color.clear : SpotlyColors.border))
        }
        .buttonStyle(.plain)
    }

    private func reload() async {
        request.load(currentIntent, force: true)
        await request.wait()
    }

    private var searchPrompt: String {
        switch service {
        case .eat: return "Dishes, restaurants or cuisines"
        case .shop: return "Products, stores or categories"
        case .book: return "Services, activities or places"
        case .events: return "Events, venues or experiences"
        default: return "Search \(service.title)"
        }
    }

    private var heroTitle: String {
        switch service {
        case .eat: return "What are you craving?"
        case .shop: return "Find what you need."
        case .book: return "Make time for something good."
        case .events: return "Find something worth going to."
        default: return service.title
        }
    }

    private var itemSectionTitle: String {
        switch service {
        case .eat: return "Menus & favourites"
        case .shop: return "Products"
        case .book: return "Services & experiences"
        case .events: return "Events & tickets"
        default: return "Available now"
        }
    }
}

@MainActor
private func makeServiceRequest() -> PagedRequest<ServiceIntent, ServiceFeedResponse> {
    PagedRequest<ServiceIntent, ServiceFeedResponse>(fetch: { intent, offset in
        var query = [URLQueryItem(name: "service", value: intent.service.rawValue), URLQueryItem(name: "city", value: intent.city), URLQueryItem(name: "q", value: intent.query), URLQueryItem(name: "offset", value: String(offset)), URLQueryItem(name: "limit", value: "24")]
        if let category = intent.category { query.append(URLQueryItem(name: "category", value: category)) }
        do {
            return try await APIClient.shared.get("/api/public/service-feed", query: query)
        } catch {
            guard await NativeMarketplaceRepository.shared.isConfigured else { throw error }
            return try await NativeMarketplaceRepository.shared.fallbackFeed(
                service: intent.service, city: intent.city, query: intent.query,
                category: intent.category, offset: offset, limit: 24)
        }
    }, next: { $0.nextOffset }, merge: { old, page in
        var businesses = Set<String>(), items = Set<String>()
        return ServiceFeedResponse(ok: page.ok, service: page.service, city: page.city, area: page.area, query: page.query,
            businesses: (old.businesses + page.businesses).filter { businesses.insert($0.id).inserted },
            items: (old.items + page.items).filter { items.insert($0.id).inserted }, categories: page.categories,
            facets: page.facets, totalBusinesses: page.totalBusinesses, totalItems: page.totalItems, nextOffset: page.nextOffset)
    })
}
