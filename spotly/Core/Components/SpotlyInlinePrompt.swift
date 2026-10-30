import SwiftUI

/// Compact inline banner for "sign in to continue" prompts in guest mode.
struct SpotlyInlinePrompt: View {
    var icon: String = "lock.fill"
    var title: String = "Sign in to continue"
    var subtitle: String = "Create an account to keep your bookings, favourites, and tickets synced."
    var actionTitle: String = "Sign in"
    var action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: SpotlySpacing.sm) {
            HStack(spacing: SpotlySpacing.sm) {
                Image(systemName: icon)
                    .font(SpotlyFont.callout(.semibold))
                    .foregroundStyle(SpotlyColors.accent)

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(SpotlyFont.callout(.semibold))
                        .foregroundStyle(SpotlyColors.textPrimary)
                    Text(subtitle)
                        .font(SpotlyFont.caption())
                        .foregroundStyle(SpotlyColors.textSecondary)
                        .lineSpacing(2)
                }
                Spacer()
            }

            SpotlyButton(title: actionTitle, isFullWidth: false, action: action)
        }
        .padding(SpotlySpacing.cardPadding)
        .background {
            RoundedRectangle(cornerRadius: SpotlyRadius.md, style: .continuous)
                .fill(SpotlyColors.surfaceElevated)
                .overlay {
                    RoundedRectangle(cornerRadius: SpotlyRadius.md, style: .continuous)
                        .stroke(SpotlyColors.borderAccent, lineWidth: 1)
                }
        }
    }
}

/// Small toast / alert for inline success/error feedback.
struct SpotlyToast: View {
    let message: String
    var isError: Bool = false

    var body: some View {
        HStack(spacing: SpotlySpacing.xs) {
            Image(systemName: isError ? "exclamationmark.circle.fill" : "checkmark.circle.fill")
                .font(SpotlyFont.callout(.semibold))
                .foregroundStyle(isError ? SpotlyColors.error : SpotlyColors.success)

            Text(message)
                .font(SpotlyFont.callout(.medium))
                .foregroundStyle(SpotlyColors.textPrimary)
                .lineLimit(2)

            Spacer()
        }
        .padding(SpotlySpacing.cardPadding)
        .glassBackground(radius: SpotlyRadius.md)
        .spotlyShadow(SpotlyShadow.float)
        .padding(.horizontal, SpotlySpacing.screenPadding)
        .transition(.move(edge: .top).combined(with: .opacity))
    }
}

struct SpotlyFeedbackSheet: View {
    let icon: String
    let title: String
    let message: String
    var actionTitle: String = "Got it"
    var action: () -> Void = {}
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: SpotlySpacing.xl) {
            Capsule()
                .fill(SpotlyColors.divider)
                .frame(width: 40, height: 4)
                .padding(.top, SpotlySpacing.sm)

            ZStack {
                Circle()
                    .fill(SpotlyColors.accent.opacity(0.12))
                    .frame(width: 84, height: 84)
                Image(systemName: icon)
                    .font(.system(size: 30, weight: .light))
                    .foregroundStyle(SpotlyColors.accent)
            }

            VStack(spacing: SpotlySpacing.xs) {
                Text(title)
                    .font(SpotlyFont.title3(.bold))
                    .foregroundStyle(SpotlyColors.textPrimary)
                    .multilineTextAlignment(.center)
                Text(message)
                    .font(SpotlyFont.callout())
                    .foregroundStyle(SpotlyColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
            }

            SpotlyButton(title: actionTitle) {
                action()
                dismiss()
            }
        }
        .padding(SpotlySpacing.screenPadding)
        .presentationDetents([.height(340)])
        .presentationDragIndicator(.hidden)
        .background(SpotlyColors.background)
    }
}
