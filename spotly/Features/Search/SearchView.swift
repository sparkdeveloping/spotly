import SwiftUI

struct SearchView: View {
    @Environment(AppState.self) private var appState
    @State private var query = ""
    @State private var selectedCategory: String? = nil
    @State private var results: [SpotlyBusiness] = []
    @State private var isSearching = false
    @State private var hasSearched = false
    @State private var navPath = NavigationPath()
    @FocusState private var isInputFocused: Bool

    @State private var recentSearches = ["The Braai House", "Spa this weekend", "Padel courts", "Groceries near me"]
    private let popularSearches = ["Dinner for two", "Groceries near me", "Spa this weekend", "Family activities", "Coffee", "Padel courts", "Concerts", "Chicken"]

    var body: some View {
        NavigationStack(path: $navPath) {
            VStack(spacing: 0) {
                searchHeader
                Divider()
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(alignment: .leading, spacing: 0) {
                        if isSearching {
                            searchingState
                        } else if hasSearched || selectedCategory != nil {
                            resultsContent
                        } else {
                            discoverContent
                        }
                        SpotlyBottomSafeSpacer(extra: 56)
                    }
                    .padding(.top, SpotlySpacing.md)
                }
            }
            .background(SpotlyColors.background)
            .navigationBarHidden(true)
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .placeDetail(let id):
                    if let biz = MockBusinesses.all.first(where: { $0.id == id }) {
                        BusinessDetailView(business: biz)
                    } else {
                        SpotlyComingSoonView(title: "Place not found", message: "This listing could not be loaded.", icon: "mappin.slash")
                    }
                case .category(let id):
                    CategoryLandingScreen(categoryID: id)
                case .menu(let id):
                    if let biz = MockBusinesses.all.first(where: { $0.id == id }) {
                        RestaurantMenuView(business: biz)
                    } else {
                        SpotlyComingSoonView(title: "Menu not available", message: "Open a place detail to browse its menu.", icon: "list.bullet")
                    }
                case .bookingFlowID(let id):
                    if let biz = MockBusinesses.all.first(where: { $0.id == id }) {
                        BookingFlowView(business: biz)
                    } else {
                        SpotlyComingSoonView(title: "Booking unavailable", message: "Open a place detail to start a booking.", icon: "calendar")
                    }
                case .businessDetail(let biz):
                    BusinessDetailView(business: biz)
                case .categoryDiscover(let c):
                    CategoryLandingScreen(categoryID: c.id)
                case .exploreCategories:
                    ExploreCategoriesView { cat in navPath.append(AppRoute.category(cat.id)) }
                case .restaurantMenu(let biz):
                    RestaurantMenuView(business: biz)
                case .bookingFlow(let biz):
                    BookingFlowView(business: biz)
                case .bookingConfirmation(let b):
                    BookingConfirmationView(booking: b)
                case .eventDetail(let e):
                    EventDetailView(event: e)
                case .businessInterest:
                    BusinessInterestScreen()
                case .businessEnquiries:
                    BusinessEnquiriesView()
                case .terms:
                    TermsView()
                case .preferences:
                    PreferencesView()
                default:
                    SpotlyComingSoonView()
                }
            }
        }
    }

    // MARK: - Search header

    private var searchHeader: some View {
        VStack(spacing: SpotlySpacing.sm) {
            HStack {
                Text("Search")
                    .font(SpotlyFont.title(.bold))
                    .foregroundStyle(SpotlyColors.textPrimary)
                Spacer()
            }
            SpotlySearchBar(text: $query, placeholder: "Search restaurants, events, activities...") {
                Task { await performSearch() }
            }
            .focused($isInputFocused)
            .onChange(of: query) { _, newVal in
                if newVal.isEmpty { hasSearched = false; results = []; selectedCategory = nil }
                else { Task { await performSearch() } }
            }
            // Category filter chips
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: SpotlySpacing.xs) {
                    ForEach(SpotlyCategory.all) { cat in
                        SpotlyFilterChip(
                            label: cat.name,
                            isSelected: selectedCategory == cat.id
                        ) {
                            withAnimation(.easeInOut(duration: 0.18)) {
                                selectedCategory = selectedCategory == cat.id ? nil : cat.id
                                if selectedCategory != nil { query = "" }
                            }
                            Task { await filterByCategory() }
                        }
                    }
                }
                .padding(.horizontal, 1)
            }
        }
        .padding(.horizontal, SpotlySpacing.screenPadding)
        .padding(.top, SpotlySpacing.lg)
        .padding(.bottom, SpotlySpacing.sm)
        .background(SpotlyColors.surface)
    }

    // MARK: - Discover content (no search active)

    private var discoverContent: some View {
        VStack(alignment: .leading, spacing: SpotlySpacing.xl) {
            chipSection(title: "Recent searches", chips: recentSearches, icon: "clock") { term in
                query = term
                Task { await performSearch() }
            }
            chipSection(title: "Popular right now", chips: popularSearches, icon: "arrow.up.right") { term in
                if let categoryID = categoryID(for: term) {
                    navPath.append(AppRoute.category(categoryID))
                } else {
                    query = term
                    Task { await performSearch() }
                }
            }
            categoryGridSection
        }
    }

    private func chipSection(title: String, chips: [String], icon: String, onTap: @escaping (String) -> Void) -> some View {
        VStack(alignment: .leading, spacing: SpotlySpacing.sm) {
            Text(title)
                .font(SpotlyFont.headline())
                .foregroundStyle(SpotlyColors.textPrimary)
                .padding(.horizontal, SpotlySpacing.screenPadding)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: SpotlySpacing.xs) {
                    ForEach(chips, id: \.self) { term in
                        Button { onTap(term) } label: {
                            HStack(spacing: 4) {
                                Image(systemName: icon).font(SpotlyFont.micro())
                                Text(term).font(SpotlyFont.caption(.medium))
                            }
                            .foregroundStyle(SpotlyColors.textSecondary)
                            .padding(.horizontal, SpotlySpacing.sm)
                            .padding(.vertical, SpotlySpacing.xs)
                            .background(SpotlyColors.backgroundElevated)
                            .clipShape(Capsule())
                            .overlay { Capsule().stroke(SpotlyColors.border, lineWidth: 1) }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, SpotlySpacing.screenPadding)
            }
        }
    }

    private var categoryGridSection: some View {
        VStack(alignment: .leading, spacing: SpotlySpacing.md) {
            HStack {
                Text("Browse by category")
                    .font(SpotlyFont.headline())
                    .foregroundStyle(SpotlyColors.textPrimary)
                Spacer()
                Button {
                    navPath.append(AppRoute.exploreCategories)
                } label: {
                    Text("See all")
                        .font(SpotlyFont.callout(.semibold))
                        .foregroundStyle(SpotlyColors.accent)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, SpotlySpacing.screenPadding)

            LazyVGrid(
                columns: [GridItem(.flexible()), GridItem(.flexible())],
                spacing: SpotlySpacing.xs
            ) {
                ForEach(SpotlyCategory.all) { cat in
                    Button {
                        SpotlyHaptics.lightTap()
                        navPath.append(AppRoute.category(cat.id))
                    } label: {
                        ZStack(alignment: .bottomLeading) {
                            SpotlyImageView(imageName: SpotlySampleImages.imageName(for: cat.id), categoryID: cat.id, style: .card)
                                .frame(height: 110)
                            LinearGradient(colors: [.clear, .black.opacity(0.55)], startPoint: .center, endPoint: .bottom)
                            HStack(spacing: SpotlySpacing.xxs) {
                                Image(systemName: cat.icon).font(SpotlyFont.caption())
                                Text(cat.name).font(SpotlyFont.callout(.semibold))
                            }
                            .foregroundStyle(.white)
                            .padding(SpotlySpacing.sm)
                        }
                    }
                    .buttonStyle(.plain)
                    .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.sm))
                    .pressableScale(scale: 0.97)
                }
            }
            .padding(.horizontal, SpotlySpacing.screenPadding)
        }
    }

    // MARK: - Results

    private var resultsContent: some View {
        VStack(alignment: .leading, spacing: SpotlySpacing.xs) {
            if !results.isEmpty {
                Text("\(results.count) result\(results.count == 1 ? "" : "s")")
                    .font(SpotlyFont.caption())
                    .foregroundStyle(SpotlyColors.textSecondary)
                    .padding(.horizontal, SpotlySpacing.screenPadding)
            }
            if results.isEmpty {
                SpotlyEmptyState(
                    icon: "magnifyingglass",
                    title: "Nothing found",
                    subtitle: "Try a different search term or explore by category.",
                    actionTitle: "Explore categories",
                    action: { navPath.append(AppRoute.exploreCategories) }
                )
            } else {
                ForEach(results) { biz in
                    SpotlyCompactListingCard(
                        business: biz,
                        isFavourited: appState.isFavourited(biz.id),
                        onFavourite: { appState.toggleFavourite(biz.id) }
                    ) {
                        navPath.append(AppRoute.placeDetail(biz.id))
                    }
                    .padding(.horizontal, SpotlySpacing.screenPadding)
                    Divider().padding(.leading, SpotlySpacing.screenPadding + 80 + SpotlySpacing.md)
                }
            }
        }
    }

    // MARK: - Searching skeleton

    private var searchingState: some View {
        VStack(spacing: SpotlySpacing.xs) {
            ForEach(0..<5, id: \.self) { _ in
                SpotlySkeletonCompactCard().padding(.horizontal, SpotlySpacing.screenPadding)
            }
        }
    }

    // MARK: - Data

    private func performSearch() async {
        let cleaned = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleaned.isEmpty else { return }
        addRecent(cleaned)
        if let categoryID = categoryID(for: cleaned) {
            await MainActor.run { navPath.append(AppRoute.category(categoryID)) }
            query = ""
            return
        }
        isSearching = true; hasSearched = true
        results = (try? await appState.listingRepo.searchBusinesses(query: query)) ?? []
        isSearching = false
    }

    private func addRecent(_ term: String) {
        let normalized = term.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !normalized.isEmpty else { return }
        recentSearches.removeAll { $0.caseInsensitiveCompare(normalized) == .orderedSame }
        recentSearches.insert(normalized, at: 0)
        recentSearches = Array(recentSearches.prefix(6))
    }

    private func categoryID(for term: String) -> String? {
        let q = term.lowercased()
        if ["grocer", "spar", "food lovers", "fresh co"].contains(where: { q.contains($0) }) { return "groceries" }
        if ["spa", "massage", "wellness", "treatment"].contains(where: { q.contains($0) }) { return "wellnessSpa" }
        if ["event", "concert", "gospel", "tickets"].contains(where: { q.contains($0) }) { return "events" }
        if ["dinner", "restaurant", "dining", "table for", "reserve"].contains(where: { q.contains($0) }) { return "restaurants" }
        if ["pizza", "burger", "chicken", "takeaway"].contains(where: { q.contains($0) }) { return "takeaways" }
        if ["coffee", "cafe", "brunch"].contains(where: { q.contains($0) }) { return "cafes" }
        if ["doctor", "clinic", "medical"].contains(where: { q.contains($0) }) { return "doctors" }
        if ["pharmacy", "medicine", "booties", "diamond"].contains(where: { q.contains($0) }) { return "pharmacy" }
        if ["beauty", "salon", "nails", "hair"].contains(where: { q.contains($0) }) { return "beauty" }
        if ["padel"].contains(where: { q.contains($0) }) { return "padel" }
        if ["activit", "escape", "trails", "family fun", "adventure park"].contains(where: { q.contains($0) }) { return "activities" }
        if ["staycation", "weekend stay", "lake stay", "lodge"].contains(where: { q.contains($0) }) { return "staycations" }
        return nil
    }

    private func filterByCategory() async {
        guard let cat = selectedCategory else { results = []; hasSearched = false; return }
        if cat == "events", let category = SpotlyCategory.all.first(where: { $0.id == cat }) {
            await MainActor.run { navPath.append(AppRoute.category(category.id)) }
            selectedCategory = nil
            return
        }
        isSearching = true; hasSearched = true
        results = (try? await appState.listingRepo.fetchBusinessesByCategory(cat)) ?? []
        isSearching = false
    }
}
