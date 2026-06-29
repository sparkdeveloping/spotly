import SwiftUI

enum SpotlyGlassIntensity {
    case subtle, regular, prominent

    var tintOpacity: Double {
        switch self {
        case .subtle: return 0.05
        case .regular: return 0.09
        case .prominent: return 0.14
        }
    }

    var shadow: SpotlyShadowStyle {
        switch self {
        case .subtle: return SpotlyShadow.card
        case .regular: return SpotlyShadow.float
        case .prominent: return SpotlyShadow.cardHeavy
        }
    }
}

struct SpotlyGlassSurface<S: Shape>: ViewModifier {
    let shape: S
    var tint: Color = SpotlyColors.accent
    var intensity: SpotlyGlassIntensity = .regular
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    func body(content: Content) -> some View {
        if reduceTransparency {
            content
                .background(SpotlyColors.surfaceElevated, in: shape)
                .overlay(shape.stroke(SpotlyColors.borderStrong, lineWidth: 0.7))
                .spotlyShadow(intensity.shadow)
        } else if #available(iOS 26.0, *) {
            content
                .glassEffect(.regular.tint(tint.opacity(intensity.tintOpacity)).interactive(), in: shape)
        } else {
            content
                .background(.ultraThinMaterial, in: shape)
                .background(tint.opacity(intensity.tintOpacity), in: shape)
                .overlay(shape.stroke(SpotlyColors.glassStroke, lineWidth: 0.7))
                .spotlyShadow(intensity.shadow)
        }
    }
}

extension View {
    func spotlyGlassSurface<S: Shape>(shape: S, tint: Color = SpotlyColors.accent, intensity: SpotlyGlassIntensity = .regular) -> some View {
        modifier(SpotlyGlassSurface(shape: shape, tint: tint, intensity: intensity))
    }

    func spotlyFloatingGlass(tint: Color = SpotlyColors.accent) -> some View {
        spotlyGlassSurface(shape: Capsule(style: .continuous), tint: tint, intensity: .regular)
    }

    func spotlyToolbarGlass() -> some View {
        spotlyGlassSurface(shape: Capsule(style: .continuous), tint: SpotlyColors.pearl, intensity: .subtle)
    }

    func spotlyCardGlass(radius: CGFloat = SpotlyRadius.md) -> some View {
        spotlyGlassSurface(shape: RoundedRectangle(cornerRadius: radius, style: .continuous), tint: SpotlyColors.accent, intensity: .subtle)
    }

    @ViewBuilder
    func spotlyMatchedTransitionSource<ID: Hashable>(id: ID, namespace: Namespace.ID) -> some View {
        if #available(iOS 18.0, *) {
            self.matchedTransitionSource(id: id, in: namespace)
        } else {
            self
        }
    }

    @ViewBuilder
    func spotlyZoomNavigation<ID: Hashable>(sourceID: ID, namespace: Namespace.ID) -> some View {
        if #available(iOS 18.0, *) {
            self.navigationTransition(.zoom(sourceID: sourceID, in: namespace))
        } else {
            self
        }
    }
}
