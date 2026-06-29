import SwiftUI

struct DiscoverView: View {
    let category: SpotlyCategory
    @Environment(AppState.self) private var appState
    @State private var businesses: [SpotlyBusiness] = []
    @State private var events: [SpotlyEvent] = []
    @State private var isLoading = true
    @State private var selectedFilter: String? = nil
    @State private var navPath = NavigationPath()

    private let filters = ["Open now", "Top rated", "Nearby", "Price: Low", "Verified"]

    private var displayedBusinesses: [SpotlyBusiness] {
        var list = businesses
        switch selectedFilter {
        case "Open now":   list = list.filter { $0.status == .open }
        case "Top rated":  list = list.sorted { $0.rating > $1.rating }
        case "Nearby":     list = list.sorted { ($0.distance ?? "9 km") < ($1.distance ?? "9 km") }
        case "Price: Low": list = list.sorted { $0.priceLevel < $1.priceLevel }
        case "Verified":   list = list.filter { $0.isVerified }
        default: break
        }
        return list
    }

    var body: some View {
        NavigationStack(path: $navPath) {
            VStack(spacing: 0) {
                // Hero header
                ZStack(alignment: .bottomLeading) {
                    SpotlyImageView(imageName: SpotlySampleImages.heroName(for: category.id), categoryID: category.id, style: .hero)
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                    LinearGradient(colors: [.clear, .black.opacity(0.65)], startPoint: .center, endPoint: .bottom)
                    HStack(spacing: SpotlySpacing.xs) {
                        ZStack {
                            Circle().fill(.ultraThinMaterial).frame(width: 40, height: 40)
                            Image(systemName: category.icon)
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                        VStack(alignment: .leading, spacing: 1) {
                            Text(category.name)
                                .font(SpotlyFont.title3(.bold))
                                .foregroundStyle(.white)
                            Text(category.id == "events" ? "\(events.count) events in \(appState.selectedCity)" : "\(displayedBusinesses.count) places in \(appState.selectedCity)")
                                .font(SpotlyFont.caption())
                                .foregroundStyle(.white.opacity(0.78))
                        }
                    }
                    .padding(.horizontal, SpotlySpacing.screenPadding)
                    .padding(.bottom, SpotlySpacing.md)
                }

                // Filter bar
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: SpotlySpacing.xs) {
                        ForEach(filters, id: \.self) { filter in
                            SpotlyFilterChip(label: filter, isSelected: selectedFilter == filter) {
                                withAnimation(.easeInOut(duration: 0.15)) {
                                    selectedFilter = selectedFilter == filter ? nil : filter
                                }
                            }
                        }
                    }
                    .padding(.horizontal, SpotlySpacing.screenPadding)
                    .padding(.vertical, SpotlySpacing.sm)
                }
                .background(SpotlyColors.surface)
                .overlay(alignment: .bottom) { Divider() }

                // Results
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: SpotlySpacing.xs) {
                        if isLoading {
                            skeletonResults
                        } else if category.id == "events" {
                            eventsList
                        } else if displayedBusinesses.isEmpty {
                            emptyState
                        } else {
                            resultsList
                        }
                        SpotlyBottomSafeSpacer(extra: 12)
                    }
                    .padding(.top, SpotlySpacing.md)
                }
            }
            .background(SpotlyColors.background)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(category.name)
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .placeDetail(let id):
                    if let biz = MockBusinesses.all.first(where: { $0.id == id }) { BusinessDetailView(business: biz) }
                case .category(let id):
                    if SpotlyCategory.all.contains(where: { $0.id == id }) { CategoryLandingScreen(categoryID: id) }
                case .menu(let id):
                    if let biz = MockBusinesses.all.first(where: { $0.id == id }) { RestaurantMenuView(business: biz) }
                case .bookingFlowID(let id):
                    if let biz = MockBusinesses.all.first(where: { $0.id == id }) { BookingFlowView(business: biz) }
                case .businessDetail(let biz): BusinessDetailView(business: biz)
                case .categoryDiscover(let cat): CategoryLandingScreen(categoryID: cat.id)
                case .bookingFlow(let biz): BookingFlowView(business: biz)
                case .bookingConfirmation(let b): BookingConfirmationView(booking: b)
                case .eventDetail(let e): EventDetailView(event: e)
                case .businessInterest: BusinessInterestScreen()
                case .businessEnquiries: BusinessEnquiriesView()
                case .terms: TermsView()
                case .preferences: PreferencesView()
                default: SpotlyComingSoonView()
                }
            }
            .task { await load() }
        }
    }

    private var skeletonResults: some View {
        VStack(spacing: SpotlySpacing.xs) {
            ForEach(0..<4, id: \.self) { _ in
                SpotlySkeletonCompactCard().padding(.horizontal, SpotlySpacing.screenPadding)
            }
        }
    }

    private var emptyState: some View {
        SpotlyEmptyState(
            icon: category.icon,
            title: "No \(category.name.lowercased()) yet",
            subtitle: "We're adding more spots to this category. Check back soon."
        )
        .padding(.top, SpotlySpacing.xxxl)
        .frame(maxWidth: .infinity)
    }

    private var eventsList: some View {
        LazyVStack(spacing: SpotlySpacing.xs) {
            HStack {
                Text("Upcoming events")
                    .font(SpotlyFont.caption(.semibold))
                    .foregroundStyle(SpotlyColors.textSecondary)
                Spacer()
                Text("\(events.count)")
                    .font(SpotlyFont.caption(.semibold))
                    .foregroundStyle(SpotlyColors.accent)
            }
            .padding(.horizontal, SpotlySpacing.screenPadding)

            ForEach(events) { event in
                SpotlyEventCard(event: event) {
                    navPath.append(AppRoute.eventDetail(event))
                }
                .padding(.horizontal, SpotlySpacing.screenPadding)
            }
        }
    }

    private var resultsList: some View {
        LazyVStack(spacing: SpotlySpacing.xs) {
            HStack {
                Text(selectedFilter ?? "All results")
                    .font(SpotlyFont.caption(.semibold))
                    .foregroundStyle(SpotlyColors.textSecondary)
                Spacer()
                Text("\(displayedBusinesses.count)")
                    .font(SpotlyFont.caption(.semibold))
                    .foregroundStyle(SpotlyColors.accent)
            }
            .padding(.horizontal, SpotlySpacing.screenPadding)

            ForEach(displayedBusinesses) { biz in
                SpotlyCompactListingCard(
                    business: biz,
                    isFavourited: appState.isFavourited(biz.id),
                    onFavourite: { appState.toggleFavourite(biz.id) }
                ) {
                    navPath.append(AppRoute.placeDetail(biz.id))
                }
                .padding(.horizontal, SpotlySpacing.screenPadding)
            }
        }
    }

    private func load() async {
        isLoading = true
        if category.id == "events" {
            events = (try? await appState.listingRepo.fetchEvents()) ?? []
        } else {
            businesses = (try? await appState.listingRepo.fetchBusinessesByCategory(category.id)) ?? []
        }
        withAnimation(SpotlyMotion.cardEntrance) { isLoading = false }
    }
}
