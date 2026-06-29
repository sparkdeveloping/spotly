import SwiftUI

// MARK: - Empty state

struct SpotlyEmptyState: View {
    let icon: String
    let title: String
    let subtitle: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: SpotlySpacing.xl) {
            ZStack {
                Circle()
                    .fill(SpotlyColors.surfaceElevated)
                    .frame(width: 88, height: 88)

                Image(systemName: icon)
                    .font(.system(size: 36, weight: .light))
                    .foregroundStyle(SpotlyColors.accent)
            }

            VStack(spacing: SpotlySpacing.xs) {
                Text(title)
                    .font(SpotlyFont.title3())
                    .foregroundStyle(SpotlyColors.textPrimary)
                    .multilineTextAlignment(.center)

                Text(subtitle)
                    .font(SpotlyFont.body())
                    .foregroundStyle(SpotlyColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }

            if let actionTitle, let action {
                SpotlyButton(title: actionTitle, isFullWidth: false, action: action)
            }
        }
        .padding(SpotlySpacing.xxxl)
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Coming soon view

struct SpotlyComingSoonView: View {
    var title: String = "Coming soon"
    var message: String = "We're curating something special here. Stay tuned."
    var icon: String = "sparkles"

    var body: some View {
        VStack(spacing: SpotlySpacing.xl) {
            ZStack {
                Circle()
                    .fill(SpotlyColors.surfaceElevated)
                    .frame(width: 100, height: 100)

                ZStack {
                    SpotlyGradients.champagne
                        .mask(
                            Image(systemName: icon)
                                .font(.system(size: 40, weight: .light))
                        )
                }
                .frame(width: 40, height: 40)
            }

            VStack(spacing: SpotlySpacing.xs) {
                Text(title)
                    .font(SpotlyFont.title2())
                    .foregroundStyle(SpotlyColors.textPrimary)

                Text(message)
                    .font(SpotlyFont.body())
                    .foregroundStyle(SpotlyColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, SpotlySpacing.xl)
            }

            Text("This feature is being prepared for launch.")
                .font(SpotlyFont.caption())
                .foregroundStyle(SpotlyColors.textTertiary)
                .padding(.horizontal, SpotlySpacing.xxl)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(SpotlyColors.background)
    }
}
