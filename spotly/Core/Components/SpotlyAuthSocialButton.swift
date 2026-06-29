import SwiftUI

enum SocialProvider {
    case apple, google
}

struct SpotlyAuthSocialButton: View {
    let provider: SocialProvider
    var action: () -> Void

    var body: some View {
        Button(action: {
            SpotlyHaptics.lightTap()
            action()
        }) {
            HStack(spacing: SpotlySpacing.sm) {
                Image(systemName: provider == .apple ? "apple.logo" : "g.circle.fill")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(iconColor)

                Text(provider == .apple ? "Continue with Apple" : "Continue with Google")
                    .font(SpotlyFont.callout(.semibold))
                    .foregroundStyle(SpotlyColors.textPrimary)

                Spacer()

                Text("Soon")
                    .font(SpotlyFont.nano(.semibold))
                    .foregroundStyle(SpotlyColors.textTertiary)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(SpotlyColors.surfaceElevated)
                    .clipShape(Capsule(style: .continuous))
            }
            .padding(.horizontal, SpotlySpacing.md)
            .padding(.vertical, SpotlySpacing.sm + 2)
            .frame(maxWidth: .infinity)
            .background(SpotlyColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.sm, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: SpotlyRadius.sm, style: .continuous)
                    .stroke(SpotlyColors.border, lineWidth: 0.5)
            }
        }
        .buttonStyle(.plain)
        .pressableScale(scale: 0.98)
    }

    private var iconColor: Color {
        switch provider {
        case .apple:  return SpotlyColors.textPrimary
        case .google: return SpotlyColors.error
        }
    }
}
