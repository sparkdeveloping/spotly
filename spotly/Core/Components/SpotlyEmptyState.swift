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
