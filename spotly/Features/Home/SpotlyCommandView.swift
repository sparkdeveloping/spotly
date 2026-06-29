import SwiftUI

struct SpotlyCommandView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppState.self) private var appState
    @State private var query = ""
    @State private var selectedContext: Set<String> = ["Tonight"]
    @State private var result: SpotlyCommandResult?
    @State private var isPlanning = false

    private let service: SpotlyCommandServiceProtocol = MockSpotlyCommandService()
    @Namespace private var transitionNamespace

    var onBusiness: (SpotlyBusiness) -> Void
    var onCategory: (SpotlyCategory) -> Void

    private let prompts = [
        "Dinner tonight", "Book padel", "Spa day", "Date night", "Family weekend",
        "Events this week", "Coffee meeting", "Gym near me", "Hidden gems", "Offers nearby"
    ]
    private let contexts = ["Today", "Tonight", "This weekend", "Near me", "Top rated", "Available now"]

    var body: some View {
        ZStack {
            SpotlyAmbientBackground(variant: .home)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: SpotlySpacing.xxl) {
                    header
                    commandInput
                    promptChips
                    contextChips
                    resultContent
                    SpotlyBottomSafeSpacer(extra: 16)
                }
                .padding(.horizontal, SpotlySpacing.screenPadding)
                .padding(.top, SpotlySpacing.xl)
            }
        }
        .safeAreaInset(edge: .top, spacing: 0) { topBar }
        .onAppear {
            if result == nil {
                query = "dinner for two tonight"
            }
        }
    }

    private var topBar: some View {
        HStack {
            Text("Spotly Command")
                .font(SpotlyFont.callout(.bold))
                .foregroundStyle(SpotlyColors.textPrimary)
                .padding(.horizontal, SpotlySpacing.sm)
                .frame(height: 38)
                .spotlyGlassSurface(shape: Capsule(style: .continuous), tint: SpotlyColors.pearl, intensity: .subtle)
            Spacer()
            SpotlyIconButton(icon: "xmark", usesGlass: true, accessibilityLabel: "Close") {
                dismiss()
            }
        }
        .padding(.horizontal, SpotlySpacing.screenPadding)
        .padding(.bottom, SpotlySpacing.xs)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: SpotlySpacing.sm) {
            Text("What are you planning?")
                .font(SpotlyFont.title(.bold))
                .foregroundStyle(SpotlyColors.textPrimary)
            Text("Tell Spotly what you want to do. Find a table, book padel, plan tonight, or discover what’s on.")
                .font(SpotlyFont.callout())
                .foregroundStyle(SpotlyColors.textSecondary)
                .lineSpacing(3)
        }
        .padding(.top, SpotlySpacing.md)
    }

    private var commandInput: some View {
        VStack(alignment: .leading, spacing: SpotlySpacing.md) {
            HStack(alignment: .top, spacing: SpotlySpacing.sm) {
                Image(systemName: "sparkle.magnifyingglass")
                    .font(SpotlyFont.title3(.semibold))
                    .foregroundStyle(SpotlyColors.accent)
                    .frame(width: 42, height: 42)
                    .spotlyGlassSurface(shape: Circle(), tint: SpotlyColors.accent, intensity: .subtle)

                TextField("Try: dinner for two tonight", text: $query, axis: .vertical)
                    .font(SpotlyFont.title3(.semibold))
                    .foregroundStyle(SpotlyColors.textPrimary)
                    .lineLimit(2...4)
                    .submitLabel(.search)
                    .onSubmit { Task { await plan() } }
            }

            SpotlyButton(title: isPlanning ? "Planning..." : "Search Spotly", icon: "arrow.right.circle.fill", isLoading: isPlanning) {
                Task { await plan() }
            }
        }
        .padding(SpotlySpacing.md)
        .spotlyGlassSurface(
            shape: RoundedRectangle(cornerRadius: SpotlyRadius.lg, style: .continuous),
            tint: SpotlyColors.pearl,
            intensity: .regular
        )
    }

    private var promptChips: some View {
        VStack(alignment: .leading, spacing: SpotlySpacing.sm) {
            Text("Try a prompt")
                .font(SpotlyFont.caption(.bold))
                .foregroundStyle(SpotlyColors.textSecondary)
            chipWrap(items: prompts) { prompt in
                query = prompt.lowercased()
                Task { await plan() }
            }
        }
    }

    private var contextChips: some View {
        VStack(alignment: .leading, spacing: SpotlySpacing.sm) {
            Text("Add context")
                .font(SpotlyFont.caption(.bold))
                .foregroundStyle(SpotlyColors.textSecondary)
            chipWrap(items: contexts) { item in
                if selectedContext.contains(item) {
                    selectedContext.remove(item)
                } else {
                    selectedContext.insert(item)
                }
            }
        }
    }

    private func chipWrap(items: [String], action: @escaping (String) -> Void) -> some View {
        FlexibleChipLayout(spacing: SpotlySpacing.xs) {
            ForEach(items, id: \.self) { item in
                let selected = selectedContext.contains(item)
                Button {
                    SpotlyHaptics.selection()
                    withAnimation(SpotlyMotion.softSpring) { action(item) }
                } label: {
                    Text(item)
                        .font(SpotlyFont.caption(.semibold))
                        .foregroundStyle(selected ? SpotlyColors.textOnAccent : SpotlyColors.textPrimary)
                        .padding(.horizontal, SpotlySpacing.sm)
                        .frame(height: 36)
                        .background(selected ? SpotlyColors.accent : SpotlyColors.surfaceElevated)
                        .clipShape(Capsule(style: .continuous))
                }
                .buttonStyle(SpotlyPressableButtonStyle(scale: 0.97))
            }
        }
    }

    @ViewBuilder
    private var resultContent: some View {
        if isPlanning {
            SpotlyCommandLoadingCard()
        } else if let result {
            VStack(alignment: .leading, spacing: SpotlySpacing.md) {
                VStack(alignment: .leading, spacing: SpotlySpacing.xs) {
                    Text(result.title)
                        .font(SpotlyFont.title3(.bold))
                        .foregroundStyle(SpotlyColors.textPrimary)
                    Text(result.summary)
                        .font(SpotlyFont.callout())
                        .foregroundStyle(SpotlyColors.textSecondary)
                        .lineSpacing(3)
                }
                .padding(SpotlySpacing.md)
                .background(SpotlyColors.surfaceCard)
                .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.lg, style: .continuous))

                if let category = result.suggestedCategory {
                    Button {
                        dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
                            onCategory(category)
                        }
                    } label: {
                        HStack {
                            Image(systemName: category.icon)
                            Text("Open \(category.name)")
                            Spacer()
                            Image(systemName: "arrow.right")
                        }
                        .font(SpotlyFont.callout(.bold))
                        .foregroundStyle(SpotlyColors.textPrimary)
                        .padding(SpotlySpacing.md)
                        .spotlyGlassSurface(shape: RoundedRectangle(cornerRadius: SpotlyRadius.md, style: .continuous), tint: SpotlyColors.accent, intensity: .subtle)
                    }
                    .buttonStyle(SpotlyPressableButtonStyle(scale: 0.985))
                }

                ForEach(result.businesses) { business in
                    SpotlyCompactListingCard(
                        business: business,
                        isFavourited: appState.isFavourited(business.id),
                        onFavourite: { appState.toggleFavourite(business.id) }
                    ) {
                        dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
                            onBusiness(business)
                        }
                    }
                    .spotlyMatchedTransitionSource(id: "command-business-\(business.id)", namespace: transitionNamespace)
                }

                if !result.events.isEmpty {
                    VStack(alignment: .leading, spacing: SpotlySpacing.sm) {
                        Text("Events to consider")
                            .font(SpotlyFont.headline(.bold))
                            .foregroundStyle(SpotlyColors.textPrimary)
                        ForEach(result.events) { event in
                            Button {
                                if let category = SpotlyCategory.all.first(where: { $0.id == "events" }) {
                                    dismiss()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) { onCategory(category) }
                                }
                            } label: {
                                HStack(spacing: SpotlySpacing.sm) {
                                    SpotlyImageView(imageName: event.cardImageName, categoryID: event.categoryID, style: .thumbnail)
                                        .frame(width: 64, height: 64)
                                        .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.sm, style: .continuous))
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text(event.name)
                                            .font(SpotlyFont.callout(.bold))
                                            .foregroundStyle(SpotlyColors.textPrimary)
                                            .lineLimit(1)
                                        Text("\(event.formattedDate) · \(event.venue)")
                                            .font(SpotlyFont.caption())
                                            .foregroundStyle(SpotlyColors.textSecondary)
                                            .lineLimit(1)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(SpotlyFont.caption(.bold))
                                        .foregroundStyle(SpotlyColors.textTertiary)
                                }
                                .padding(SpotlySpacing.sm)
                                .background(SpotlyColors.surfaceCard)
                                .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.md, style: .continuous))
                            }
                            .buttonStyle(SpotlyPressableButtonStyle(scale: 0.985))
                        }
                    }
                }
            }
        } else {
            SpotlyCommandEmptyCard()
        }
    }

    private func plan() async {
        let cleaned = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleaned.isEmpty else { return }
        isPlanning = true
        let output = await service.plan(for: cleaned, context: Array(selectedContext), city: appState.selectedCity)
        withAnimation(SpotlyMotion.softSpring) {
            result = output
            isPlanning = false
        }
    }
}

private struct SpotlyCommandEmptyCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: SpotlySpacing.sm) {
            Image(systemName: "wand.and.stars")
                .font(SpotlyFont.title2(.bold))
                .foregroundStyle(SpotlyColors.accent)
            Text("Start with a plan")
                .font(SpotlyFont.title3(.bold))
                .foregroundStyle(SpotlyColors.textPrimary)
            Text("Try “spa this weekend”, “padel after work”, or “what’s happening Friday?”")
                .font(SpotlyFont.callout())
                .foregroundStyle(SpotlyColors.textSecondary)
        }
        .padding(SpotlySpacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(SpotlyColors.surfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.lg, style: .continuous))
    }
}

private struct SpotlyCommandLoadingCard: View {
    var body: some View {
        HStack(spacing: SpotlySpacing.sm) {
            ProgressView().tint(SpotlyColors.accent)
            VStack(alignment: .leading, spacing: 2) {
                Text("Building a plan")
                    .font(SpotlyFont.callout(.bold))
                    .foregroundStyle(SpotlyColors.textPrimary)
                Text("Matching intent, timing, and availability.")
                    .font(SpotlyFont.caption())
                    .foregroundStyle(SpotlyColors.textSecondary)
            }
        }
        .padding(SpotlySpacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(SpotlyColors.surfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.lg, style: .continuous))
    }
}

private struct FlexibleChipLayout<Content: View>: View {
    let spacing: CGFloat
    @ViewBuilder var content: Content

    init(spacing: CGFloat, @ViewBuilder content: () -> Content) {
        self.spacing = spacing
        self.content = content()
    }

    var body: some View {
        FlowLayout(spacing: spacing) { content }
    }
}
