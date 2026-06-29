import SwiftUI

struct SpotlyCategoryHubView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @Namespace private var transitionNamespace

    var onSelectCategory: (SpotlyCategory) -> Void

    private let smartCollections: [SmartCollection] = [
        SmartCollection(title: "For tonight", subtitle: "Open spots and late plans", icon: "moon.stars.fill", categoryID: "nightlife"),
        SmartCollection(title: "Weekend plans", subtitle: "Events, food, and activities", icon: "sparkles", categoryID: "events"),
        SmartCollection(title: "Date night", subtitle: "Atmospheric tables and lounges", icon: "heart.fill", categoryID: "restaurants"),
        SmartCollection(title: "Family friendly", subtitle: "Easy plans for everyone", icon: "figure.2.and.child.holdinghands", categoryID: "activities"),
        SmartCollection(title: "Near you", subtitle: "Curated around your city", icon: "location.fill", categoryID: "cafes"),
        SmartCollection(title: "Offers", subtitle: "Early testing deals", icon: "tag.fill", categoryID: "offers")
    ]

    var body: some View {
        ZStack {
            SpotlyAmbientBackground(variant: .discover)

            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: SpotlySpacing.xxl) {
                    header
                    smartCollectionGrid
                    categoryGrid
                    SpotlyBottomSafeSpacer(extra: 24)
                }
                .padding(.horizontal, SpotlySpacing.screenPadding)
                .padding(.top, SpotlySpacing.xl)
            }
        }
        .navigationBarHidden(true)
        .safeAreaInset(edge: .top, spacing: 0) {
            topBar
        }
    }

    private var topBar: some View {
        HStack {
            SpotlyIconButton(icon: "chevron.left", usesGlass: true, accessibilityLabel: "Back") {
                dismiss()
            }
            Spacer()
            Text("Explore all")
                .font(SpotlyFont.callout(.semibold))
                .foregroundStyle(SpotlyColors.textPrimary)
                .padding(.horizontal, SpotlySpacing.sm)
                .frame(height: 38)
                .spotlyGlassSurface(shape: Capsule(style: .continuous), tint: SpotlyColors.pearl, intensity: .subtle)
        }
        .padding(.horizontal, SpotlySpacing.screenPadding)
        .padding(.bottom, SpotlySpacing.xs)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: SpotlySpacing.sm) {
            Text("Choose your Spotly mood")
                .font(SpotlyFont.title(.bold))
                .foregroundStyle(SpotlyColors.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
            Text("Browse curated categories and smart collections for \(appState.selectedCity).")
                .font(SpotlyFont.callout())
                .foregroundStyle(SpotlyColors.textSecondary)
                .lineSpacing(3)
        }
        .padding(.top, SpotlySpacing.lg)
    }

    private var smartCollectionGrid: some View {
        VStack(alignment: .leading, spacing: SpotlySpacing.md) {
            Text("Smart collections")
                .font(SpotlyFont.title3(.bold))
                .foregroundStyle(SpotlyColors.textPrimary)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: SpotlySpacing.sm) {
                ForEach(smartCollections) { collection in
                    Button {
                        SpotlyHaptics.selection()
                        if let category = SpotlyCategory.all.first(where: { $0.id == collection.categoryID }) {
                            onSelectCategory(category)
                        }
                    } label: {
                        SmartCollectionCard(collection: collection)
                    }
                    .buttonStyle(SpotlyPressableButtonStyle(scale: 0.975))
                }
            }
        }
    }

    private var categoryGrid: some View {
        VStack(alignment: .leading, spacing: SpotlySpacing.md) {
            Text("Browse by category")
                .font(SpotlyFont.title3(.bold))
                .foregroundStyle(SpotlyColors.textPrimary)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: SpotlySpacing.sm) {
                ForEach(SpotlyCategory.all) { category in
                    Button {
                        SpotlyHaptics.selection()
                        onSelectCategory(category)
                    } label: {
                        CategoryHubCard(category: category)
                    }
                    .buttonStyle(SpotlyPressableButtonStyle(scale: 0.975))
                    .spotlyMatchedTransitionSource(id: "category-\(category.id)", namespace: transitionNamespace)
                }
            }
        }
    }
}

private struct SmartCollection: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
    let categoryID: String
}

private struct SmartCollectionCard: View {
    let collection: SmartCollection

    var body: some View {
        VStack(alignment: .leading, spacing: SpotlySpacing.sm) {
            Image(systemName: collection.icon)
                .font(SpotlyFont.title3(.bold))
                .foregroundStyle(SpotlyColors.accent)
                .frame(width: 44, height: 44)
                .spotlyGlassSurface(shape: Circle(), tint: SpotlyColors.accent, intensity: .subtle)

            VStack(alignment: .leading, spacing: 3) {
                Text(collection.title)
                    .font(SpotlyFont.callout(.bold))
                    .foregroundStyle(SpotlyColors.textPrimary)
                    .lineLimit(1)
                Text(collection.subtitle)
                    .font(SpotlyFont.caption())
                    .foregroundStyle(SpotlyColors.textSecondary)
                    .lineLimit(2)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 132, alignment: .topLeading)
        .padding(SpotlySpacing.md)
        .background(SpotlyColors.surfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.lg, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: SpotlyRadius.lg, style: .continuous)
                .stroke(SpotlyColors.border, lineWidth: 0.5)
        }
    }
}

private struct CategoryHubCard: View {
    let category: SpotlyCategory

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            SpotlyImageView(imageName: SpotlySampleImages.imageName(for: category.id), categoryID: category.id, style: .card)
                .frame(height: 156)

            VStack(alignment: .leading, spacing: SpotlySpacing.xxs) {
                HStack {
                    Image(systemName: category.icon)
                        .font(SpotlyFont.callout(.bold))
                        .foregroundStyle(.white)
                        .frame(width: 34, height: 34)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                    Spacer()
                    Text("\(MockBusinesses.byCategory(category.id).count)")
                        .font(SpotlyFont.micro(.bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, SpotlySpacing.xs)
                        .padding(.vertical, 4)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule(style: .continuous))
                }
                Text(category.name)
                    .font(SpotlyFont.headline(.bold))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                Text(promise(for: category.id))
                    .font(SpotlyFont.caption())
                    .foregroundStyle(.white.opacity(0.78))
                    .lineLimit(2)
            }
            .padding(SpotlySpacing.sm)
        }
        .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.lg, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: SpotlyRadius.lg, style: .continuous)
                .stroke(.white.opacity(0.12), lineWidth: 0.5)
        }
        .spotlyShadow(SpotlyShadow.card)
    }

    private func promise(for id: String) -> String {
        switch id {
        case "food": return "Restaurants, cafes, and reliable takeaway"
        case "restaurants": return "Tables, tasting menus, and date-night dining"
        case "cafes": return "Coffee, brunch, and slow mornings"
        case "takeaways": return "Quick plates, combos, and delivery-friendly meals"
        case "groceries": return "Premium stores and fresh essentials"
        case "pharmacy": return "Wellness items with prescription verification"
        case "doctors": return "Clinic and doctor appointments"
        case "flowersGifts": return "Bouquets, hampers, and thoughtful gifts"
        case "beauty": return "Hair, nails, makeup, and beauty plans"
        case "wellnessSpa": return "Massages, facials, and reset rituals"
        case "activities": return "Things to do around your city"
        case "staycations": return "Weekend stays and local escapes"
        case "padel": return "Courts, coaching, and social matches"
        case "gyms": return "Training spaces and wellness routines"
        case "events": return "Concerts, markets, and weekend culture"
        case "nightlife": return "Late plans, lounges, and music"
        case "offers": return "Launch deals and partner bundles"
        default: return "Curated places around Zimbabwe"
        }
    }
}
