import SwiftUI

struct InterestSelectionView: View {
    var onNext: () -> Void
    var onSkip: () -> Void

    @Environment(AppState.self) private var appState
    @State private var selectedInterests: Set<String> = []

    private let interests: [(icon: String, label: String)] = [
        ("fork.knife", "Restaurants"),
        ("cup.and.saucer.fill", "Cafes"),
        ("theatermasks.fill", "Events"),
        ("music.note", "Concerts"),
        ("moon.stars.fill", "Nightlife"),
        ("tennisball.fill", "Padel"),
        ("figure.cooldown", "Fitness"),
        ("sparkles", "Spas"),
        ("wand.and.stars", "Beauty"),
        ("scissors", "Salons"),
        ("figure.2.and.child.holdinghands", "Family activities"),
        ("heart.fill", "Date nights"),
        ("calendar", "Weekend experiences"),
        ("cart.fill", "Groceries"),
        ("brain.head.profile", "Wellness"),
        ("map.fill", "Hidden gems"),
    ]

    private var isReady: Bool { selectedInterests.count >= 3 }

    var body: some View {
        ZStack {
            SpotlyAmbientBackground(variant: .auth)

            VStack(spacing: SpotlySpacing.xxl) {
                // Header
                VStack(spacing: SpotlySpacing.xs) {
                    stepIndicator(current: 2, total: 4)
                        .padding(.top, SpotlySpacing.lg)

                    ZStack {
                        Circle().fill(SpotlyColors.accent.opacity(0.1)).frame(width: 64, height: 64)
                        Image(systemName: "heart.text.square.fill")
                            .font(.system(size: 26, weight: .light))
                            .foregroundStyle(SpotlyColors.accent)
                    }

                    Text("What are you into?")
                        .font(SpotlyFont.title2(.bold))
                        .foregroundStyle(SpotlyColors.textPrimary)

                    HStack(spacing: SpotlySpacing.xxs) {
                        Text("We'll shape Spotly around the places, plans, and experiences you care about.")
                            .font(SpotlyFont.callout())
                            .foregroundStyle(SpotlyColors.textSecondary)
                            .multilineTextAlignment(.center)
                    }

                    // Counter badge
                    if !selectedInterests.isEmpty {
                        Text("\(selectedInterests.count) selected")
                            .font(SpotlyFont.caption(.semibold))
                            .foregroundStyle(SpotlyColors.accent)
                            .padding(.horizontal, SpotlySpacing.sm)
                            .padding(.vertical, SpotlySpacing.xxs)
                            .background(SpotlyColors.accent.opacity(0.1))
                            .clipShape(Capsule())
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .animation(SpotlyMotion.softSpring, value: selectedInterests.isEmpty)
                .padding(.horizontal, SpotlySpacing.screenPadding)

                // Chip grid
                ScrollView(.vertical, showsIndicators: false) {
                    FlowLayout(spacing: SpotlySpacing.xs) {
                        ForEach(interests, id: \.label) { interest in
                            SpotlyChoiceChip(
                                title: interest.label,
                                icon: interest.icon,
                                isSelected: selectedInterests.contains(interest.label)
                            ) {
                                if selectedInterests.contains(interest.label) {
                                    selectedInterests.remove(interest.label)
                                } else {
                                    selectedInterests.insert(interest.label)
                                    SpotlyHaptics.lightTap()
                                }
                            }
                        }
                    }
                    .padding(.horizontal, SpotlySpacing.screenPadding)
                }

                // Footer CTAs
                VStack(spacing: SpotlySpacing.xs) {
                    SpotlyButton(
                        title: isReady ? "Continue" : "Select \(max(0, 3 - selectedInterests.count)) more",
                        icon: isReady ? "arrow.right" : nil
                    ) {
                        if isReady {
                            appState.selectedInterests = Array(selectedInterests)
                            SpotlyHaptics.medium()
                            onNext()
                        } else {
                            SpotlyHaptics.warning()
                        }
                    }

                    Button { onSkip() } label: {
                        Text("Skip for now")
                            .font(SpotlyFont.callout(.medium))
                            .foregroundStyle(SpotlyColors.textTertiary)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, SpotlySpacing.screenPadding)
                .padding(.bottom, SpotlySpacing.xl)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("")
        .onAppear {
            selectedInterests = Set(appState.selectedInterests)
        }
    }

    private func stepIndicator(current: Int, total: Int) -> some View {
        HStack(spacing: SpotlySpacing.xxs) {
            ForEach(1...total, id: \.self) { step in
                Capsule()
                    .fill(step <= current ? SpotlyColors.accent : SpotlyColors.divider)
                    .frame(width: step == current ? 24 : 8, height: 6)
                    .animation(SpotlyMotion.softSpring, value: current)
            }
        }
    }
}

// MARK: - FlowLayout
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) -> CGSize {
        let width = proposal.width ?? 0
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var maxWidth: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > width && x > 0 {
                y += rowHeight + spacing
                x = 0
                rowHeight = 0
            }
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
            maxWidth = max(maxWidth, x)
        }
        return CGSize(width: maxWidth, height: y + rowHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) {
        var x = bounds.minX
        var y = bounds.minY
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > bounds.maxX && x > bounds.minX {
                y += rowHeight + spacing
                x = bounds.minX
                rowHeight = 0
            }
            subview.place(at: CGPoint(x: x, y: y), proposal: .init(size))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}
