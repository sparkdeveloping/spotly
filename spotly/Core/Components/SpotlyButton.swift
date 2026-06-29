import SwiftUI

// MARK: - Button style enum

enum SpotlyButtonVariant {
    case primary, secondary, ghost, destructive
}

// MARK: - Primary button

struct SpotlyButton: View {
    let title: String
    var icon: String? = nil
    var variant: SpotlyButtonVariant = .primary
    var isLoading: Bool = false
    var isFullWidth: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: {
            SpotlyHaptics.medium()
            action()
        }) {
            HStack(spacing: SpotlySpacing.xs) {
                if isLoading {
                    ProgressView()
                        .tint(foregroundColor)
                        .scaleEffect(0.8)
                } else {
                    if let icon {
                        Image(systemName: icon)
                            .font(SpotlyFont.callout(.semibold))
                    }
                    Text(title)
                        .font(SpotlyFont.headline())
                }
            }
            .foregroundStyle(foregroundColor)
            .padding(.vertical, SpotlySpacing.sm + 2)
            .padding(.horizontal, SpotlySpacing.xl)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.sm + 2, style: .continuous))
            .overlay {
                if variant == .secondary {
                    RoundedRectangle(cornerRadius: SpotlyRadius.sm + 2, style: .continuous)
                        .stroke(SpotlyColors.border, lineWidth: 1.5)
                }
            }
        }
        .buttonStyle(.plain)
        .pressableScale()
        .disabled(isLoading)
        .animation(SpotlyMotion.quickTap, value: isLoading)
        .accessibilityLabel(title)
    }

    private var backgroundColor: Color {
        switch variant {
        case .primary:     return SpotlyColors.accent
        case .secondary:   return SpotlyColors.surfaceElevated
        case .ghost:       return .clear
        case .destructive: return SpotlyColors.errorBg
        }
    }

    private var foregroundColor: Color {
        switch variant {
        case .primary:     return .white
        case .secondary:   return SpotlyColors.textPrimary
        case .ghost:       return SpotlyColors.accent
        case .destructive: return SpotlyColors.error
        }
    }
}

// MARK: - Icon button

struct SpotlyIconButton: View {
    let icon: String
    var size: CGFloat = 44
    var foreground: Color = SpotlyColors.textPrimary
    var background: Color = SpotlyColors.surfaceElevated
    var usesGlass: Bool = false
    var accessibilityLabel: String = ""
    let action: () -> Void

    var body: some View {
        Button(action: {
            SpotlyHaptics.lightTap()
            action()
        }) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(foreground)
                .frame(width: size, height: size)
                .modifier(SpotlyIconButtonBackground(size: size, background: background, usesGlass: usesGlass))
        }
        .buttonStyle(.plain)
        .pressableScale()
        .accessibilityLabel(accessibilityLabel.isEmpty ? icon : accessibilityLabel)
    }
}

private struct SpotlyIconButtonBackground: ViewModifier {
    let size: CGFloat
    let background: Color
    let usesGlass: Bool

    func body(content: Content) -> some View {
        if usesGlass {
            content
                .background(.ultraThinMaterial)
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(SpotlyColors.border, lineWidth: 0.5)
                }
        } else {
            content
                .background(background)
                .clipShape(Circle())
        }
    }
}
