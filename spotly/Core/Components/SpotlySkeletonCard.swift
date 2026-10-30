import SwiftUI

// MARK: - Shimmer modifier

struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .overlay {
                SpotlyGradients.shimmer(phase: phase)
                    .ignoresSafeArea()
            }
            .onAppear {
                withAnimation(.linear(duration: 1.4).repeatForever(autoreverses: false)) {
                    phase = 1.3
                }
            }
    }
}

extension View {
    func shimmer() -> some View { modifier(ShimmerModifier()) }
}

// MARK: - Skeleton listing card

struct SpotlySkeletonListingCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SpotlyColors.surfaceElevated
                .frame(height: 160)
                .shimmer()

            VStack(alignment: .leading, spacing: SpotlySpacing.xs) {
                Capsule().fill(SpotlyColors.surfaceElevated).frame(width: 160, height: 14).shimmer()
                Capsule().fill(SpotlyColors.surfaceElevated).frame(width: 120, height: 11).shimmer()
                Capsule().fill(SpotlyColors.surfaceElevated).frame(width: 80, height: 11).shimmer()
            }
            .padding(SpotlySpacing.cardPadding)
        }
        .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.md, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: SpotlyRadius.md, style: .continuous)
                .stroke(SpotlyColors.border, lineWidth: 0.5)
        }
    }
}

// MARK: - Skeleton compact card

struct SpotlySkeletonCompactCard: View {
    var body: some View {
        HStack(spacing: SpotlySpacing.md) {
            SpotlyColors.surfaceElevated
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.sm, style: .continuous))
                .shimmer()

            VStack(alignment: .leading, spacing: SpotlySpacing.xs) {
                Capsule().fill(SpotlyColors.surfaceElevated).frame(width: 140, height: 14).shimmer()
                Capsule().fill(SpotlyColors.surfaceElevated).frame(width: 100, height: 11).shimmer()
                Capsule().fill(SpotlyColors.surfaceElevated).frame(width: 80, height: 11).shimmer()
            }
            Spacer()
        }
        .padding(SpotlySpacing.cardPadding)
        .cardBackground()
    }
}
