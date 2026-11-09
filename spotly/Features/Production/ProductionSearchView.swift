import SwiftUI

struct ProductionSearchView: View {
    @Environment(AppState.self) private var appState
    @State private var query = ""
    @State private var serviceFilter: SpotlyServiceKind?
    @State private var typeFilter: String?
    @State private var searchTask: Task<Void, Never>? = nil

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 24) {
                    filters

                    if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        discovery
                    } else {
                        results
                    }
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 36)
            }
            .background(SpotlyColors.background)
            .navigationTitle("Search")
            .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always), prompt: "Restaurants, products, services, events…")
            .onChange(of: intent) { _, _ in
                appState.marketplace.search(query, city: appState.selectedCity, service: serviceFilter, type: typeFilter)
            }
            .onSubmit(of: .search) {
                appState.marketplace.rememberSearch(query.trimmingCharacters(in: .whitespacesAndNewlines))
                Task { await appState.marketplace.performSearch(query, city: appState.selectedCity, service: serviceFilter, type: typeFilter) }
            }
            .task {
                await appState.refreshServiceAvailability()
                if let serviceFilter, !appState.serviceIsDiscoverable(serviceFilter) { self.serviceFilter = nil }
                if appState.marketplace.feeds.isEmpty {
                    await appState.marketplace.loadHome(city: appState.selectedCity, services: discoverableMarketplaceServices)
                }
            }
            .onDisappear {
                searchTask?.cancel()
            }
        }
    }

    private var intent: SearchIntent {
        SearchIntent(query: query, city: appState.selectedCity, service: serviceFilter, type: typeFilter)
    }

    private var discoverableMarketplaceServices: Set<SpotlyServiceKind> {
        Set([.eat, .shop, .book, .events].filter { appState.serviceIsDiscoverable($0) })
    }

    private var filters: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                filterChip("All", selected: serviceFilter == nil && typeFilter == nil) {
                    serviceFilter = nil; typeFilter = nil
                }
                ForEach([SpotlyServiceKind.eat, .shop, .book, .events].filter { appState.serviceIsDiscoverable($0) }) { service in
                    filterChip(service.title, icon: service.icon, selected: serviceFilter == service) {
                        serviceFilter = serviceFilter == service ? nil : service
                        typeFilter = nil
                    }
                }
                filterChip("Places", icon: "mappin.and.ellipse", selected: typeFilter == "business") {
                    typeFilter = typeFilter == "business" ? nil : "business"
                    serviceFilter = nil
                }
            }
        }
        .contentMargins(.horizontal, 0, for: .scrollContent)
    }

    @ViewBuilder
    private var discovery: some View {
        let recents = appState.marketplace.recentSearches
        if !recents.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                SpotlySectionTitle(title: "Recent searches", actionTitle: "Clear") {
                    appState.marketplace.clearRecentSearches()
                }
                FlowLayout(spacing: 8) {
                    ForEach(recents, id: \.self) { value in
                        Button { query = value } label: {
                            Label(value, systemImage: "clock")
                                .font(SpotlyFont.callout(.medium))
                                .foregroundStyle(SpotlyColors.textSecondary)
                                .padding(.horizontal, 12).padding(.vertical, 9)
                                .background(SpotlyColors.secondaryBackground, in: Capsule())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }

        VStack(alignment: .leading, spacing: 14) {
            SpotlySectionTitle(title: "Browse Spotly", subtitle: "Find the right service first")
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(SpotlyServiceKind.allCases) { service in
                    NavigationLink {
                        service == .ride ? AnyView(RideRequestView()) : service == .send ? AnyView(SendRequestView()) : AnyView(ServiceDiscoveryView(service: service))
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: service.icon)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(service.tint)
                                .frame(width: 38, height: 38)
                                .background(service.tint.opacity(0.11), in: RoundedRectangle(cornerRadius: 12))
                            VStack(alignment: .leading, spacing: 2) {
                                Text(service.title).font(SpotlyFont.headline())
                                Text(service.subtitle).font(SpotlyFont.micro()).foregroundStyle(SpotlyColors.textSecondary).lineLimit(1)
                            }
                            Spacer(minLength: 0)
                        }
                        .foregroundStyle(SpotlyColors.textPrimary)
                        .padding(12)
                        .background(SpotlyColors.surface, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: 18).stroke(SpotlyColors.border))
                    }
                    .buttonStyle(.plain)
                }
            }
        }

        let categoryValues = Array(Set([SpotlyServiceKind.eat, .shop, .book, .events].flatMap { appState.marketplace.feeds[$0]?.categories ?? [] }).sorted().prefix(14))
        if !categoryValues.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                SpotlySectionTitle(title: "Categories in \(appState.selectedCity)")
                FlowLayout(spacing: 8) {
                    ForEach(categoryValues, id: \.self) { category in
                        Button(category) { query = category }
                            .font(SpotlyFont.callout(.medium))
                            .foregroundStyle(SpotlyColors.textPrimary)
                            .padding(.horizontal, 12).padding(.vertical, 9)
                            .background(SpotlyColors.surface, in: Capsule())
                            .overlay(Capsule().stroke(SpotlyColors.border))
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var results: some View {
        if appState.marketplace.isSearching && appState.marketplace.searchResults.isEmpty {
            VStack(spacing: 16) {
                ForEach(0..<5, id: \.self) { _ in
                    HStack { RoundedRectangle(cornerRadius: 12).frame(width: 64, height: 64); VStack(alignment: .leading) { Text("Searching Spotly").font(.headline); Text("Places, products and experiences").font(.subheadline) }; Spacer() }
                }
            }
            .foregroundStyle(SpotlyColors.secondaryBackground).redacted(reason: .placeholder)
            .accessibilityElement(children: .ignore).accessibilityLabel("Searching Spotly")
        } else if let error = appState.marketplace.searchError, appState.marketplace.searchResults.isEmpty {
            SpotlyNetworkStateView(title: "Search is unavailable", message: error, actionTitle: "Try again") {
                Task { await appState.marketplace.performSearch(query, city: appState.selectedCity, service: serviceFilter, type: typeFilter) }
            }
        } else if appState.marketplace.searchResults.isEmpty {
            ContentUnavailableView.search(text: query)
        } else {
            VStack(alignment: .leading, spacing: 12) {
                Text("\(appState.marketplace.searchResults.count) result\(appState.marketplace.searchResults.count == 1 ? "" : "s") in \(appState.selectedCity)")
                    .font(SpotlyFont.caption(.semibold)).foregroundStyle(SpotlyColors.textSecondary)
                if appState.marketplace.isSearching { ProgressView("Updating results…") }
                if let error = appState.marketplace.searchError {
                    Text(error).font(.callout).foregroundStyle(.secondary)
                    Button("Try again") { Task { await appState.marketplace.performSearch(query, city: appState.selectedCity, service: serviceFilter, type: typeFilter) } }
                }
                ForEach(appState.marketplace.searchResults, id: \.resultIdentity) { result in
                    NavigationLink { SearchResultDetailView(result: result).onAppear { appState.marketplace.rememberSearch(query) } } label: {
                        SearchResultRow(result: result)
                    }
                    .buttonStyle(.plain)
                    Divider().padding(.leading, 76)
                }
                if appState.marketplace.searchRequest.nextOffset != nil {
                    Button("Load more results") { appState.marketplace.searchRequest.loadMore() }
                        .disabled(appState.marketplace.isSearching).frame(maxWidth: .infinity, minHeight: 44)
                }
            }
        }
    }

    private func filterChip(_ title: String, icon: String? = nil, selected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let icon { Image(systemName: icon) }
                Text(title)
            }
            .font(SpotlyFont.callout(.semibold))
            .foregroundStyle(selected ? SpotlyColors.textOnAccent : SpotlyColors.textSecondary)
            .padding(.horizontal, 13).padding(.vertical, 8)
            .background(selected ? SpotlyColors.accent : SpotlyColors.surface, in: Capsule())
            .overlay(Capsule().stroke(selected ? Color.clear : SpotlyColors.border))
        }
        .buttonStyle(.plain)
    }
}

private struct SearchResultRow: View {
    let result: RemoteSearchResult

    var body: some View {
        HStack(spacing: 13) {
            SpotlyRemoteImage(url: result.imageURL, cornerRadius: 14, aspectRatio: 1, fallbackIcon: icon, tint: SpotlyColors.accent)
                .frame(width: 64, height: 64)
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 5) {
                    Text(result.displayTitle).font(SpotlyFont.headline()).foregroundStyle(SpotlyColors.textPrimary).lineLimit(2)
                    if result.commerceVerified == true { Image(systemName: "checkmark.seal.fill").foregroundStyle(SpotlyColors.accent).font(.caption) }
                }
                Text(result.subtitle ?? result.displayCategory ?? result.businessName ?? result.type?.capitalized ?? "Spotly")
                    .font(SpotlyFont.callout()).foregroundStyle(SpotlyColors.textSecondary).lineLimit(1)
                HStack(spacing: 10) {
                    if let price = result.prices?["USD"] ?? result.price, price > 0 {
                        Text(money(price, currency: result.prices?["USD"] != nil ? "USD" : (result.currency ?? "USD"))).font(SpotlyFont.caption(.bold))
                    }
                    if let area = result.area ?? result.city { Text(area).font(SpotlyFont.caption()) }
                }
                .foregroundStyle(SpotlyColors.textSecondary)
            }
            Spacer()
            Image(systemName: "chevron.right").font(.caption.bold()).foregroundStyle(SpotlyColors.textTertiary)
        }
        .contentShape(Rectangle())
    }

    private var icon: String {
        switch result.savedType {
        case .business, .place: return "storefront"
        case .product: return "bag"
        case .service: return "sparkles"
        case .event: return "ticket"
        }
    }
}

struct SearchResultDetailView: View {
    let result: RemoteSearchResult
    @Environment(AppState.self) private var appState
    @State private var item: RemoteItem?
    @State private var failed = false

    var body: some View {
        Group {
            if result.savedType == .business || result.savedType == .place, let businessID = result.businessId ?? (result.savedType == .business ? result.entityID : nil) {
                MarketplaceBusinessDetailView(businessID: businessID, service: service)
            } else if let item {
                MarketplaceItemDetailView(item: item, service: service ?? serviceForItem(item))
            } else if failed {
                ContentUnavailableView("This result is no longer available", systemImage: "magnifyingglass", description: Text("Try searching Spotly again."))
            } else {
                ProgressView("Opening…")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .task { await resolveItem() }
            }
        }
    }

    private var service: SpotlyServiceKind? { result.vertical.flatMap(SpotlyServiceKind.init(rawValue:)) }

    private func serviceForItem(_ item: RemoteItem) -> SpotlyServiceKind {
        if item.type == "event" || item.itemType == "event" { return .events }
        if item.type == "service" || item.durationMinutes != nil { return .book }
        return .shop
    }

    private func resolveItem() async {
        guard let businessID = result.businessId else { failed = true; return }
        do {
            let detail = try await appState.marketplace.business(id: businessID)
            item = detail.products.first(where: { $0.id == result.entityID || $0.entityId == result.entityID })
            failed = item == nil
        } catch { failed = true }
    }
}

/// Lightweight wrapping layout for chips without third-party dependencies.
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? 0
        var x: CGFloat = 0, y: CGFloat = 0, rowHeight: CGFloat = 0
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x > 0 && x + size.width > width { x = 0; y += rowHeight + spacing; rowHeight = 0 }
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
        return CGSize(width: width, height: y + rowHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX, y = bounds.minY, rowHeight: CGFloat = 0
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x > bounds.minX && x + size.width > bounds.maxX { x = bounds.minX; y += rowHeight + spacing; rowHeight = 0 }
            subview.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}
