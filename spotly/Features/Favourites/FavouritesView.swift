import SwiftUI

struct FavouritesView: View {
    @Environment(AppState.self) private var appState
    @State private var navPath = NavigationPath()
    @State private var selectedFilter: String? = nil

    var body: some View {
        NavigationStack(path: $navPath) {
            Group {
                if appState.favouriteBusinesses.isEmpty {
                    emptyState
                } else {
                    savedList
                }
            }
            .background(SpotlyColors.background)
            .navigationTitle("Saved")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .placeDetail(let id):
                    if let biz = MockBusinesses.all.first(where: { $0.id == id }) {
                        BusinessDetailView(business: biz)
                    } else {
                        SpotlyComingSoonView(title: "Place not found", message: "This listing could not be loaded.", icon: "mappin.slash")
                    }
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
                case .businessDetail(let biz): BusinessDetailView(business: biz)
                case .bookingFlow(let biz): BookingFlowView(business: biz)
                case .bookingConfirmation(let b): BookingConfirmationView(booking: b)
                case .category(let id): CategoryLandingScreen(categoryID: id)
                case .businessInterest: BusinessInterestScreen()
                case .businessEnquiries: BusinessEnquiriesView()
                default: SpotlyComingSoonView()
                }
            }
        }
    }

    // MARK: - Saved list

    private var filterChipRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: SpotlySpacing.xs) {
                ForEach(["All", "Food", "Groceries", "Wellness", "Events", "Health", "Activities"], id: \.self) { label in
                    let isSelected = (label == "All" && selectedFilter == nil) || selectedFilter == label
                    Button {
                        withAnimation(.easeInOut(duration: 0.16)) {
                            selectedFilter = label == "All" ? nil : label
                        }
                    } label: {
                        Text(label)
                            .font(SpotlyFont.caption(.semibold))
                            .foregroundStyle(isSelected ? .white : SpotlyColors.textSecondary)
                            .padding(.horizontal, SpotlySpacing.sm)
                            .padding(.vertical, SpotlySpacing.xs)
                            .background(isSelected ? SpotlyColors.accent : SpotlyColors.backgroundElevated)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, SpotlySpacing.screenPadding)
        }
    }

    private var filteredFavourites: [SpotlyBusiness] {
        let all = appState.favouriteBusinesses
        switch selectedFilter {
        case "Food":      return all.filter { ["restaurants","cafes","takeaways"].contains($0.categoryID) }
        case "Wellness":  return all.filter { $0.categoryID == "wellnessSpa" }
        case "Beauty":    return all.filter { $0.categoryID == "beauty" }
        case "Groceries": return all.filter { $0.categoryID == "groceries" }
        case "Events":    return all.filter { $0.categoryID == "events" }
        case "Health":    return all.filter { ["pharmacy", "doctors"].contains($0.categoryID) }
        case "Activities": return all.filter { ["activities", "staycations", "padel"].contains($0.categoryID) }
        default:          return all
        }
    }

    private var savedList: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Saved places")
                    .font(SpotlyFont.title3(.bold))
                    .foregroundStyle(SpotlyColors.textPrimary)
                Text("\(appState.savedCount) saved place\(appState.savedCount == 1 ? "" : "s")")
                    .font(SpotlyFont.callout())
                    .foregroundStyle(SpotlyColors.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, SpotlySpacing.screenPadding)
            .padding(.top, SpotlySpacing.md)
            filterChipRow.padding(.top, SpotlySpacing.sm)
            if filteredFavourites.isEmpty {
                VStack(spacing: SpotlySpacing.sm) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .font(.system(size: 34, weight: .light))
                        .foregroundStyle(SpotlyColors.accent)
                    Text("No saved places in this filter")
                        .font(SpotlyFont.headline(.semibold))
                    Text("Try All or save more places from Home, Search, or category pages.")
                        .font(SpotlyFont.caption())
                        .foregroundStyle(SpotlyColors.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(SpotlySpacing.xl)
            } else {
                LazyVStack(spacing: SpotlySpacing.sm) {
                    ForEach(filteredFavourites) { biz in
                        FavouriteCard(
                            business: biz,
                            onRemove: { appState.toggleSaved(spotID: biz.id) }
                        ) {
                            navPath.append(AppRoute.placeDetail(biz.id))
                        }
                    }
                }
                .padding(.horizontal, SpotlySpacing.screenPadding)
                .padding(.top, SpotlySpacing.md)
            }
            SpotlyBottomSafeSpacer(extra: 56)
        }
    }

    // MARK: - Empty state

    private var emptyState: some View {
        VStack(spacing: SpotlySpacing.xl) {
            Spacer()
            Image(systemName: "heart")
                .font(.system(size: 52, weight: .light))
                .foregroundStyle(SpotlyColors.accent.opacity(0.5))
            VStack(spacing: SpotlySpacing.xs) {
                Text("No saved places yet")
                    .font(SpotlyFont.title3(.bold))
                    .foregroundStyle(SpotlyColors.textPrimary)
                Text("Save restaurants, spas, events, and hidden gems for your next plan.")
                    .font(SpotlyFont.callout())
                    .foregroundStyle(SpotlyColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
            }
            Button {
                withAnimation(SpotlyMotion.softSpring) { appState.selectedTab = .search }
            } label: {
                Label("Discover places", systemImage: "magnifyingglass")
                    .font(SpotlyFont.callout(.semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, SpotlySpacing.xl)
                    .padding(.vertical, SpotlySpacing.sm)
                    .background(SpotlyColors.accent)
                    .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.sm))
            }
            .buttonStyle(.plain)
            .pressableScale()
            Spacer()
        }
        .padding(SpotlySpacing.xl)
        .frame(maxWidth: .infinity)
    }
}

private struct FavouriteCard: View {
    let business: SpotlyBusiness
    let onRemove: () -> Void
    let onTap: () -> Void

    var body: some View {
        HStack(spacing: SpotlySpacing.md) {
            Button {
                SpotlyHaptics.lightTap()
                onTap()
            } label: {
                HStack(spacing: SpotlySpacing.md) {
                    SpotlyImageView(imageName: business.cardImageName, categoryID: business.categoryID, style: .thumbnail)
                        .frame(width: 96, height: 96)
                        .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.sm, style: .continuous))

                    VStack(alignment: .leading, spacing: 5) {
                        Text(business.categoryName)
                            .font(SpotlyFont.micro(.semibold))
                            .foregroundStyle(SpotlyColors.accent)
                            .lineLimit(1)
                        Text(business.name)
                            .font(SpotlyFont.headline(.semibold))
                            .foregroundStyle(SpotlyColors.textPrimary)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                        Text(business.location.displayName)
                            .font(SpotlyFont.caption())
                            .foregroundStyle(SpotlyColors.textSecondary)
                            .lineLimit(1)
                        HStack(spacing: SpotlySpacing.sm) {
                            SpotlyRatingView(rating: business.rating)
                            if let distance = business.distance {
                                Text(distance)
                                    .font(SpotlyFont.caption())
                                    .foregroundStyle(SpotlyColors.textSecondary)
                            }
                            SpotlyStatusBadge(status: business.status)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .buttonStyle(.plain)

            Button {
                SpotlyHaptics.lightTap()
                withAnimation(SpotlyMotion.successPop) { onRemove() }
            } label: {
                Image(systemName: "heart.fill")
                    .font(SpotlyFont.callout(.semibold))
                    .foregroundStyle(SpotlyColors.favourite)
                    .frame(width: 44, height: 44)
                    .background(SpotlyColors.backgroundElevated)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
        .padding(SpotlySpacing.cardPadding)
        .background(SpotlyColors.surfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.md, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: SpotlyRadius.md, style: .continuous)
                .stroke(SpotlyColors.border, lineWidth: 0.75)
        }
        .spotlyShadow(SpotlyShadow.card)
    }
}
