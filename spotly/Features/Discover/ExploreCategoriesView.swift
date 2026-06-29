import SwiftUI

struct ExploreCategoriesView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""

    var onSelectCategory: (SpotlyCategory) -> Void

    private let smartCollections: [(title: String, subtitle: String, icon: String, categoryID: String)] = [
        ("Food & dining", "Restaurants, cafes and takeaways", "fork.knife", "food"),
        ("Groceries", "Premium stores and fresh essentials", "basket.fill", "groceries"),
        ("Events", "Concerts, markets and weekend culture", "calendar.badge.clock", "events"),
        ("Activities", "Things to do around your city", "figure.outdoor.cycle", "activities"),
        ("Date night", "Atmospheric tables and experiences", "heart.fill", "restaurants"),
        ("Weekend plans", "Events, food and leisure", "sparkles", "events"),
        ("Family friendly", "Easy plans for everyone", "figure.2.and.child.holdinghands", "activities"),
        ("Near you", "Curated around your city", "location.fill", "cafes"),
    ]

    private var filteredCategories: [SpotlyCategory] {
        if searchText.isEmpty { return SpotlyCategory.all }
        return SpotlyCategory.all.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                // Search
                HStack(spacing: SpotlySpacing.sm) {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(SpotlyColors.textTertiary)
                    TextField("Search categories", text: $searchText)
                        .font(SpotlyFont.callout())
                }
                .padding(.horizontal, SpotlySpacing.md)
                .frame(height: 44)
                .background(SpotlyColors.backgroundElevated)
                .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.sm, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: SpotlyRadius.sm, style: .continuous)
                        .stroke(SpotlyColors.border, lineWidth: 1)
                }
                .padding(.horizontal, SpotlySpacing.screenPadding)
                .padding(.top, SpotlySpacing.md)
                .padding(.bottom, SpotlySpacing.xl)

                if searchText.isEmpty {
                    // Smart collections
                    sectionHeader("Smart collections")
                        .padding(.bottom, SpotlySpacing.md)
                    LazyVGrid(
                        columns: [GridItem(.flexible()), GridItem(.flexible())],
                        spacing: SpotlySpacing.sm
                    ) {
                        ForEach(smartCollections, id: \.title) { col in
                            SmartCollectionTile(
                                icon: col.icon,
                                title: col.title,
                                subtitle: col.subtitle
                            ) {
                                SpotlyHaptics.selection()
                                if let cat = SpotlyCategory.all.first(where: { $0.id == col.categoryID }) {
                                    onSelectCategory(cat)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, SpotlySpacing.screenPadding)
                    .padding(.bottom, SpotlySpacing.xl)
                }

                // All categories grid
                sectionHeader(searchText.isEmpty ? "Browse by category" : "Results")
                    .padding(.bottom, SpotlySpacing.md)

                LazyVGrid(
                    columns: [GridItem(.flexible()), GridItem(.flexible())],
                    spacing: SpotlySpacing.sm
                ) {
                    ForEach(filteredCategories) { cat in
                        CategoryTile(category: cat) {
                            SpotlyHaptics.selection()
                            onSelectCategory(cat)
                        }
                    }
                }
                .padding(.horizontal, SpotlySpacing.screenPadding)

                SpotlyBottomSafeSpacer(extra: 24)
            }
        }
        .background(SpotlyColors.background)
        .navigationTitle("Explore categories")
        .navigationBarTitleDisplayMode(.large)
    }

    private func sectionHeader(_ text: String) -> some View {
        Text(text)
            .font(SpotlyFont.title3(.bold))
            .foregroundStyle(SpotlyColors.textPrimary)
            .padding(.horizontal, SpotlySpacing.screenPadding)
    }
}

// MARK: - Smart collection tile

private struct SmartCollectionTile: View {
    let icon: String
    let title: String
    let subtitle: String
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: SpotlySpacing.sm) {
                ZStack {
                    RoundedRectangle(cornerRadius: SpotlyRadius.xs, style: .continuous)
                        .fill(SpotlyColors.accentBg)
                        .frame(width: 40, height: 40)
                    Image(systemName: icon)
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(SpotlyColors.accent)
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(SpotlyFont.callout(.semibold))
                        .foregroundStyle(SpotlyColors.textPrimary)
                        .lineLimit(1)
                    Text(subtitle)
                        .font(SpotlyFont.caption())
                        .foregroundStyle(SpotlyColors.textSecondary)
                        .lineLimit(2)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 120, alignment: .topLeading)
            .padding(SpotlySpacing.md)
            .background(SpotlyColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.md, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: SpotlyRadius.md, style: .continuous)
                    .stroke(SpotlyColors.border, lineWidth: 0.5)
            }
        }
        .buttonStyle(.plain)
        .pressableScale(scale: 0.97)
    }
}

// MARK: - Category tile

private struct CategoryTile: View {
    let category: SpotlyCategory
    let onTap: () -> Void

    private var businessCount: Int { MockBusinesses.byCategory(category.id).count }

    var body: some View {
        Button(action: onTap) {
            ZStack(alignment: .bottomLeading) {
                SpotlyImageView(imageName: SpotlySampleImages.imageName(for: category.id), categoryID: category.id, style: .card)
                    .frame(height: 140)

                Rectangle()
                    .fill(SpotlyGradients.heroOverlay)

                VStack(alignment: .leading, spacing: SpotlySpacing.xxs) {
                    Image(systemName: category.icon)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(width: 30, height: 30)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                    Text(category.name)
                        .font(SpotlyFont.headline(.bold))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                    if businessCount > 0 {
                        Text("\(businessCount) places")
                            .font(SpotlyFont.micro())
                            .foregroundStyle(.white.opacity(0.75))
                    }
                }
                .padding(SpotlySpacing.sm)
            }
            .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.md, style: .continuous))
        }
        .buttonStyle(.plain)
        .pressableScale(scale: 0.97)
    }
}
