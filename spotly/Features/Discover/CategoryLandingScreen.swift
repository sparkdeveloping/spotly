import SwiftUI

struct CategoryLandingScreen: View {
    let categoryID: String
    @Environment(AppState.self) private var appState
    @State private var searchText = ""
    @State private var selectedFilter = "All"

    private var category: SpotlyCategory? {
        SpotlyCategory.all.first { $0.id == categoryID }
    }

    private var allPlaces: [SpotlyBusiness] {
        MockBusinesses.byCategory(categoryID)
    }

    private var events: [SpotlyEvent] {
        categoryID == "events" ? MockEvents.all : []
    }

    private var filters: [String] {
        let tags = allPlaces.flatMap(\.tags)
        let serviceCategories = allPlaces.flatMap { $0.services.compactMap(\.category) }
        let values = Array(Set(tags + serviceCategories)).sorted()
        return ["All", "Open now", "Top rated"] + Array(values.prefix(6))
    }

    private var filteredPlaces: [SpotlyBusiness] {
        var places = allPlaces
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if !trimmed.isEmpty {
            places = places.filter { place in
                place.name.lowercased().contains(trimmed) ||
                place.tagline.lowercased().contains(trimmed) ||
                place.description.lowercased().contains(trimmed) ||
                place.tags.contains { $0.lowercased().contains(trimmed) } ||
                place.services.contains { service in
                    service.name.lowercased().contains(trimmed) ||
                    service.description.lowercased().contains(trimmed)
                }
            }
        }
        switch selectedFilter {
        case "Open now": places = places.filter { $0.status == .open }
        case "Top rated": places = places.sorted { $0.rating > $1.rating }
        case "All": break
        default:
            places = places.filter { place in
                place.tags.contains(selectedFilter) || place.services.contains { $0.category == selectedFilter }
            }
        }
        return places
    }

    private var featuredPlaces: [SpotlyBusiness] {
        Array(filteredPlaces.filter(\.isFeatured).prefix(4))
    }

    private var popularPlaces: [SpotlyBusiness] {
        Array(filteredPlaces.sorted { $0.rating > $1.rating }.prefix(6))
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 28) {
                header
                scopedSearch
                filterRow
                if categoryID == "events" {
                    eventsSection
                } else if filteredPlaces.isEmpty {
                    emptyState
                } else {
                    if !featuredPlaces.isEmpty { featuredSection }
                    popularSection
                    allVendorsSection
                }
                partnerCTA
                SpotlyBottomSafeSpacer(extra: 80)
            }
            .padding(.top, SpotlySpacing.md)
        }
        .background(SpotlyColors.background)
        .navigationTitle(category?.name ?? "Category")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: SpotlySpacing.xs) {
            HStack(spacing: SpotlySpacing.sm) {
                Image(systemName: category?.icon ?? "square.grid.2x2.fill")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(SpotlyColors.accent)
                    .frame(width: 48, height: 48)
                    .background(SpotlyColors.accentBg)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                VStack(alignment: .leading, spacing: 2) {
                    Text(category?.name ?? "Category")
                        .font(SpotlyFont.title2(.bold))
                        .foregroundStyle(SpotlyColors.textPrimary)
                    Text("\(appState.selectedCity), Zimbabwe")
                        .font(SpotlyFont.callout())
                        .foregroundStyle(SpotlyColors.textSecondary)
                }
                Spacer()
            }
            Text(category?.shortDescription ?? "Curated places around Zimbabwe")
                .font(SpotlyFont.callout())
                .foregroundStyle(SpotlyColors.textSecondary)
                .lineSpacing(3)
        }
        .padding(.horizontal, SpotlySpacing.screenPadding)
    }

    private var scopedSearch: some View {
        HStack(spacing: SpotlySpacing.sm) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(SpotlyColors.textTertiary)
            TextField("Search \((category?.name ?? "places").lowercased())", text: $searchText)
                .font(SpotlyFont.callout())
                .textInputAutocapitalization(.never)
            if !searchText.isEmpty {
                Button { searchText = "" } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(SpotlyColors.textTertiary)
                }
                .buttonStyle(.plain)
            }
        }
        .frame(height: 48)
        .padding(.horizontal, SpotlySpacing.md)
        .background(SpotlyColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.sm, style: .continuous))
        .overlay { RoundedRectangle(cornerRadius: SpotlyRadius.sm).stroke(SpotlyColors.border, lineWidth: 1) }
        .padding(.horizontal, SpotlySpacing.screenPadding)
    }

    private var filterRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: SpotlySpacing.xs) {
                ForEach(filters, id: \.self) { filter in
                    SpotlyFilterChip(label: filter, isSelected: selectedFilter == filter) {
                        withAnimation(.easeInOut(duration: 0.16)) { selectedFilter = filter }
                    }
                }
            }
            .padding(.horizontal, SpotlySpacing.screenPadding)
        }
    }

    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: SpotlySpacing.md) {
            sectionHeader("Featured vendors", count: featuredPlaces.count)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: SpotlySpacing.itemGap) {
                    ForEach(featuredPlaces) { place in
                        NavigationLink(value: AppRoute.placeDetail(place.id)) {
                            CategoryPlaceTile(place: place)
                                .frame(width: 250)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, SpotlySpacing.screenPadding)
            }
        }
    }

    private var popularSection: some View {
        VStack(alignment: .leading, spacing: SpotlySpacing.md) {
            sectionHeader("Popular vendors", count: popularPlaces.count)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: SpotlySpacing.itemGap) {
                    ForEach(popularPlaces) { place in
                        NavigationLink(value: AppRoute.placeDetail(place.id)) {
                            CategoryPlaceTile(place: place)
                                .frame(width: 220)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, SpotlySpacing.screenPadding)
            }
        }
    }

    private var allVendorsSection: some View {
        VStack(alignment: .leading, spacing: SpotlySpacing.sm) {
            sectionHeader("All vendors", count: filteredPlaces.count)
            ForEach(filteredPlaces) { place in
                NavigationLink(value: AppRoute.placeDetail(place.id)) {
                    CategoryCompactPlaceRow(place: place)
                }
                .buttonStyle(.plain)
                .padding(.horizontal, SpotlySpacing.screenPadding)
            }
        }
    }

    private var eventsSection: some View {
        VStack(alignment: .leading, spacing: SpotlySpacing.md) {
            sectionHeader("This week", count: events.count)
            ForEach(events) { event in
                NavigationLink(value: AppRoute.eventDetail(event)) {
                    SpotlyEventCard(event: event, onTap: {})
                }
                .buttonStyle(.plain)
                .padding(.horizontal, SpotlySpacing.screenPadding)
            }
        }
    }

    private var emptyState: some View {
        SpotlyEmptyState(
            icon: category?.icon ?? "magnifyingglass",
            title: "No matches found",
            subtitle: "Try clearing the search or choosing a different filter.",
            actionTitle: "Clear filters",
            action: {
                searchText = ""
                selectedFilter = "All"
            }
        )
    }

    private var partnerCTA: some View {
        NavigationLink(value: AppRoute.businessInterest) {
            HStack(spacing: SpotlySpacing.sm) {
                Image(systemName: "storefront.fill")
                    .foregroundStyle(SpotlyColors.accent)
                    .frame(width: 40, height: 40)
                    .background(SpotlyColors.accentBg)
                    .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.xs))
                VStack(alignment: .leading, spacing: 2) {
                    Text("List your business in \(category?.name ?? "this category")")
                        .font(SpotlyFont.callout(.semibold))
                        .foregroundStyle(SpotlyColors.textPrimary)
                    Text("Join Spotly's 2026 launch partner pipeline.")
                        .font(SpotlyFont.caption())
                        .foregroundStyle(SpotlyColors.textSecondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(SpotlyFont.caption(.semibold))
                    .foregroundStyle(SpotlyColors.textTertiary)
            }
            .padding(SpotlySpacing.md)
            .background(SpotlyColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.md))
            .overlay { RoundedRectangle(cornerRadius: SpotlyRadius.md).stroke(SpotlyColors.border, lineWidth: 0.5) }
            .padding(.horizontal, SpotlySpacing.screenPadding)
        }
        .buttonStyle(.plain)
    }

    private func sectionHeader(_ title: String, count: Int) -> some View {
        HStack {
            Text(title)
                .font(SpotlyFont.title3(.bold))
                .foregroundStyle(SpotlyColors.textPrimary)
            Spacer()
            Text("\(count)")
                .font(SpotlyFont.caption(.semibold))
                .foregroundStyle(SpotlyColors.accent)
        }
        .padding(.horizontal, SpotlySpacing.screenPadding)
    }
}

private struct CategoryCompactPlaceRow: View {
    let place: SpotlyBusiness

    var body: some View {
        HStack(spacing: SpotlySpacing.md) {
            SpotlyImageView(imageName: place.cardImageName, categoryID: place.categoryID, style: .thumbnail)
                .frame(width: 82, height: 82)
                .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.sm, style: .continuous))
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    Text(place.name)
                        .font(SpotlyFont.callout(.semibold))
                        .foregroundStyle(SpotlyColors.textPrimary)
                        .lineLimit(1)
                    if place.isVerified {
                        Image(systemName: "checkmark.seal.fill")
                            .font(SpotlyFont.micro(.semibold))
                            .foregroundStyle(SpotlyColors.success)
                    }
                }
                Text(place.tagline)
                    .font(SpotlyFont.caption())
                    .foregroundStyle(SpotlyColors.textSecondary)
                    .lineLimit(2)
                HStack(spacing: SpotlySpacing.sm) {
                    SpotlyRatingView(rating: place.rating, reviewCount: place.reviewCount)
                    if let distance = place.distance {
                        Text(distance)
                            .font(SpotlyFont.caption())
                            .foregroundStyle(SpotlyColors.textSecondary)
                    }
                }
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(SpotlyColors.textTertiary)
        }
        .padding(SpotlySpacing.cardPadding)
        .background(SpotlyColors.surfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.md, style: .continuous))
        .overlay { RoundedRectangle(cornerRadius: SpotlyRadius.md).stroke(SpotlyColors.border, lineWidth: 0.5) }
    }
}

private struct CategoryPlaceTile: View {
    let place: SpotlyBusiness

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SpotlyImageView(imageName: place.cardImageName, categoryID: place.categoryID, style: .card)
                .frame(height: 128)
            VStack(alignment: .leading, spacing: 4) {
                Text(place.name)
                    .font(SpotlyFont.callout(.semibold))
                    .foregroundStyle(SpotlyColors.textPrimary)
                    .lineLimit(1)
                Text(place.tagline)
                    .font(SpotlyFont.caption())
                    .foregroundStyle(SpotlyColors.textSecondary)
                    .lineLimit(2)
                HStack {
                    SpotlyRatingView(rating: place.rating, reviewCount: place.reviewCount)
                    Spacer()
                    if let distance = place.distance {
                        Text(distance)
                            .font(SpotlyFont.micro(.semibold))
                            .foregroundStyle(SpotlyColors.textTertiary)
                    }
                }
            }
            .padding(SpotlySpacing.sm)
        }
        .background(SpotlyColors.surfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.md, style: .continuous))
        .overlay { RoundedRectangle(cornerRadius: SpotlyRadius.md).stroke(SpotlyColors.border, lineWidth: 0.5) }
    }
}
