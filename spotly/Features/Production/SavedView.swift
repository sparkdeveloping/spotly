import SwiftUI

struct SavedView: View {
    @Environment(AppState.self) private var appState
    @State private var filter: SavedFilter = .all

    enum SavedFilter: String, CaseIterable, Identifiable {
        case all = "All"
        case places = "Places"
        case products = "Products"
        case services = "Services"
        case events = "Events"
        var id: String { rawValue }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) {
                    filterBar
                    if let error = appState.saved.errorMessage {
                        if hasVisibleContent {
                            SpotlyRefreshBanner(message: "Saved couldn’t refresh. Your existing saves are still available.") {
                                Task { await appState.saved.load(user: appState.currentUser, force: true) }
                            }
                        } else {
                            SpotlyNetworkStateView(title: "Saved is temporarily unavailable", message: friendlySavedError(error), actionTitle: "Try again") {
                                Task { await appState.saved.load(user: appState.currentUser, force: true) }
                            }
                        }
                    }
                    if appState.saved.isLoading {
                        ProgressView(hasVisibleContent ? "Updating Saved…" : "Loading Saved…").frame(maxWidth: .infinity)
                    }
                    if visibleBusinesses.isEmpty && visibleItems.isEmpty && !appState.saved.isLoading && appState.saved.errorMessage == nil {
                        ContentUnavailableView("Nothing saved here yet", systemImage: "heart", description: Text("Save places, products, services and events to find them here."))
                    }
                    ForEach(visibleBusinesses) { business in
                        NavigationLink { MarketplaceBusinessDetailView(businessID: business.id, service: nil) } label: {
                            HStack(spacing: 14) {
                                SpotlyRemoteImage(url: business.imageURL, cornerRadius: 14, aspectRatio: 1, fallbackIcon: "storefront").frame(width: 76, height: 76)
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(business.displayName).font(.headline).foregroundStyle(.primary)
                                    Text(business.displayCategory).font(.subheadline).foregroundStyle(.secondary)
                                    if !business.displayLocation.isEmpty { Text(business.displayLocation).font(.caption).foregroundStyle(.secondary) }
                                }
                                Spacer(minLength: 0)
                                if business.isCommerceVerified { Image(systemName: "checkmark.seal.fill").foregroundStyle(SpotlyColors.accent).accessibilityLabel("Verified") }
                            }
                            .padding(12).background(SpotlyColors.surface, in: RoundedRectangle(cornerRadius: 18))
                        }
                        .buttonStyle(.plain)
                        .contextMenu { Button("Remove from Saved", systemImage: "heart.slash", role: .destructive) { Task { await appState.saved.toggleBusiness(business, user: appState.currentUser) } } }
                    }
                    ForEach(visibleItems) { item in
                        NavigationLink { SavedEntityDestination(entity: item) } label: { SavedEntityRow(entity: item) }
                            .buttonStyle(.plain)
                            .contextMenu { Button("Remove from Saved", systemImage: "heart.slash", role: .destructive) { Task { await appState.saved.toggleItem(item, user: appState.currentUser) } } }
                    }
                    if !appState.saved.unavailableIDs.isEmpty { Text("\(appState.saved.unavailableIDs.count) saved places are currently unavailable. Your saves are retained.").font(.footnote).foregroundStyle(.secondary) }
                    if appState.saved.hasMore { Button("Load more saved places") { Task { await appState.saved.loadMore() } }.disabled(appState.saved.isLoading).frame(maxWidth: .infinity, minHeight: 44) }
                }
                .padding(18).padding(.bottom, 24)
            }
            .background(SpotlyColors.background)
            .navigationTitle("Saved")
            .refreshable { await appState.saved.load(user: appState.currentUser, force: true) }
            .task(id: appState.currentUser?.id) { await appState.saved.load(user: appState.currentUser) }
        }
    }


    private var hasVisibleContent: Bool {
        !visibleBusinesses.isEmpty || !visibleItems.isEmpty
    }

    private func friendlySavedError(_ value: String) -> String {
        let lower = value.lowercased()
        if lower.contains("not found") || lower.contains("404") { return "Spotly Saved is being updated. Try again shortly." }
        return value
    }

    private var filterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(SavedFilter.allCases) { option in
                    Button(option.rawValue) { withAnimation(.snappy) { filter = option } }
                        .font(SpotlyFont.subheadline(.semibold))
                        .foregroundStyle(filter == option ? Color.white : SpotlyColors.textPrimary)
                        .padding(.horizontal, 14).padding(.vertical, 9)
                        .background(filter == option ? SpotlyColors.accent : SpotlyColors.surface, in: Capsule())
                }
            }
        }
    }

    private var visibleBusinesses: [RemoteBusiness] {
        guard filter == .all || filter == .places else { return [] }
        return appState.saved.businesses
    }

    private var visibleItems: [SavedEntity] {
        appState.saved.items.filter { item in
            switch filter {
            case .all: return true
            case .places: return item.type == .place || item.type == .business
            case .products: return item.type == .product
            case .services: return item.type == .service
            case .events: return item.type == .event
            }
        }
    }

    private var itemSectionTitle: String {
        switch filter {
        case .all: return "More saved"
        default: return filter.rawValue
        }
    }
}

private struct SavedEntityRow: View {
    let entity: SavedEntity

    var body: some View {
        HStack(spacing: 13) {
            SpotlyRemoteImage(url: entity.imageURL, cornerRadius: 14, aspectRatio: 1, fallbackIcon: icon, tint: tint)
                .frame(width: 74, height: 74)
            VStack(alignment: .leading, spacing: 4) {
                Text(entity.title).font(SpotlyFont.headline()).foregroundStyle(SpotlyColors.textPrimary).lineLimit(2)
                if !entity.subtitle.isEmpty {
                    Text(entity.subtitle).font(SpotlyFont.callout()).foregroundStyle(SpotlyColors.textSecondary).lineLimit(1)
                }
                if let location = AddressFormatter.joined([entity.area, entity.city]).nilIfBlank {
                    Label(location, systemImage: "mappin.and.ellipse")
                        .font(SpotlyFont.caption()).foregroundStyle(SpotlyColors.textSecondary).lineLimit(1)
                }
            }
            Spacer()
            Image(systemName: "chevron.right").font(.caption.bold()).foregroundStyle(SpotlyColors.textTertiary)
        }
        .padding(12)
        .background(SpotlyColors.surface, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private var icon: String {
        switch entity.type {
        case .business, .place: return "storefront"
        case .product: return "bag"
        case .service: return "sparkles"
        case .event: return "ticket"
        }
    }

    private var tint: Color {
        switch entity.type {
        case .product: return SpotlyServiceKind.shop.tint
        case .service: return SpotlyServiceKind.book.tint
        case .event: return SpotlyServiceKind.events.tint
        default: return SpotlyColors.accent
        }
    }
}

private struct SavedEntityDestination: View {
    @Environment(AppState.self) private var appState
    let entity: SavedEntity
    @State private var item: RemoteItem?
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        Group {
            if entity.type == .business || entity.type == .place, let businessID = entity.businessID ?? (entity.type == .business ? entity.entityID : nil) {
                MarketplaceBusinessDetailView(businessID: businessID, service: nil)
            } else if entity.type == .place, entity.businessID == nil {
                Form {
                    Section(entity.title) { Label(AddressFormatter.joined([entity.address, entity.area, entity.city]), systemImage: "mappin.and.ellipse") }
                    Section { Text("Your saved address").foregroundStyle(.secondary) }
                }.navigationTitle(entity.title)
            } else if let item {
                MarketplaceItemDetailView(item: item, service: service(for: item))
            } else if isLoading {
                ProgressView("Loading…")
            } else {
                ContentUnavailableView("Unavailable", systemImage: "questionmark.folder", description: Text(errorMessage ?? "This saved item is no longer available."))
            }
        }
        .task { await resolve() }
    }

    private func service(for item: RemoteItem) -> SpotlyServiceKind {
        if entity.type == .event || item.type == "event" || item.itemType == "event" { return .events }
        if entity.type == .service || item.type == "service" || item.durationMinutes != nil { return .book }
        return .shop
    }

    private func resolve() async {
        guard !(entity.type == .business || entity.type == .place) else { isLoading = false; return }
        do {
            if NativeMarketplaceRepository.shared.isConfigured,
               let native = try await NativeMarketplaceRepository.shared.publicItem(id: entity.entityID) {
                item = native
                isLoading = false
                return
            }
            let result: SearchResponse
            do {
                result = try await APIClient.shared.get(
                    "/api/public/search",
                    query: [URLQueryItem(name: "q", value: entity.title), URLQueryItem(name: "limit", value: "24")]
                )
            } catch {
                guard NativeMarketplaceRepository.shared.isConfigured else { throw error }
                result = try await NativeMarketplaceRepository.shared.fallbackSearch(
                    query: entity.title, city: entity.city ?? "", service: nil, limit: 24)
            }
            item = result.results.first(where: { $0.entityID == entity.entityID }).map { match in
                RemoteItem(
                    id: match.entityID, entityId: match.entityId, type: match.type, businessId: match.businessId,
                    businessName: match.businessName, name: match.name, title: match.title, description: match.description,
                    category: match.category, image: match.image, brand: nil, variant: nil, packSize: nil, unit: nil,
                    currency: match.currency, price: match.price, prices: match.prices, compareAtPrice: nil, stockStatus: nil,
                    stockQuantity: nil, available: nil, itemType: match.itemType, durationMinutes: nil, capacity: nil,
                    remainingCapacity: nil, startsAt: match.startsAt, endsAt: nil, venue: match.venue, city: match.city,
                    area: match.area, tags: nil, isFeatured: nil, maxQuantity: nil, pickupEligible: nil, published: nil,
                    promotion: nil, business: match.business
                )
            }
            if item == nil { errorMessage = "The item may have been removed or unpublished." }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
