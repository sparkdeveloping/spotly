import SwiftUI

// MARK: - Unified theme namespace
enum SpotlyTheme {
    typealias Colors   = SpotlyColors
    typealias Font     = SpotlyFont
    typealias Spacing  = SpotlySpacing
    typealias Radius   = SpotlyRadius
    typealias Shadow   = SpotlyShadow
    typealias Motion   = SpotlyMotion
    typealias Gradient = SpotlyGradients
}

// MARK: - Glass background modifier (used sparingly)

struct GlassBackground: ViewModifier {
    var radius: CGFloat = SpotlyRadius.lg
    func body(content: Content) -> some View {
        content.background {
            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .fill(SpotlyColors.surface)
                .overlay {
                    RoundedRectangle(cornerRadius: radius, style: .continuous)
                        .stroke(SpotlyColors.border, lineWidth: 1)
                }
        }
    }
}

// MARK: - Card background modifier

struct CardBackground: ViewModifier {
    var radius: CGFloat = SpotlyRadius.lg
    var shadowStyle: SpotlyShadowStyle = SpotlyShadow.card
    func body(content: Content) -> some View {
        content.background {
            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .fill(SpotlyColors.surfaceCard)
                .overlay {
                    RoundedRectangle(cornerRadius: radius, style: .continuous)
                        .stroke(SpotlyColors.border, lineWidth: 1)
                }
                .spotlyShadow(shadowStyle)
        }
    }
}

extension View {
    func glassBackground(radius: CGFloat = SpotlyRadius.lg) -> some View {
        modifier(GlassBackground(radius: radius))
    }
    func cardBackground(radius: CGFloat = SpotlyRadius.md) -> some View {
        modifier(CardBackground(radius: radius))
    }

    func spotlySectionSurface(radius: CGFloat = SpotlyRadius.lg) -> some View {
        background(SpotlyColors.surface, in: RoundedRectangle(cornerRadius: radius, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .stroke(SpotlyColors.border, lineWidth: 1)
            }
    }

    func spotlyStandardCard(radius: CGFloat = SpotlyRadius.lg) -> some View {
        modifier(CardBackground(radius: radius, shadowStyle: SpotlyShadow.card))
    }

    func spotlyElevatedCard(radius: CGFloat = SpotlyRadius.lg) -> some View {
        modifier(CardBackground(radius: radius, shadowStyle: SpotlyShadow.elevated))
    }
}
