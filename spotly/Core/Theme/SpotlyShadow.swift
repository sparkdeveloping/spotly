import SwiftUI

struct SpotlyShadowStyle {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

enum SpotlyShadow {
    static let card      = SpotlyShadowStyle(color: SpotlyColors.shadow, radius: 18, x: 0, y: 8)
    static let cardHeavy = SpotlyShadowStyle(color: .black.opacity(0.18), radius: 28, x: 0, y: 14)
    static let tab       = SpotlyShadowStyle(color: .black.opacity(0.18), radius: 18, x: 0, y: 8)
    static let button    = SpotlyShadowStyle(color: Color(hex: "D7B56D").opacity(0.32), radius: 12, x: 0, y: 4)
    static let float     = SpotlyShadowStyle(color: .black.opacity(0.32), radius: 32, x: 0, y: 12)
    static let accent    = SpotlyShadowStyle(color: Color(hex: "D7B56D").opacity(0.42), radius: 16, x: 0, y: 6)
    static let glow      = SpotlyShadowStyle(color: Color(hex: "D7B56D").opacity(0.2), radius: 24, x: 0, y: 0)
}

extension View {
    func spotlyShadow(_ style: SpotlyShadowStyle) -> some View {
        shadow(color: style.color, radius: style.radius, x: style.x, y: style.y)
    }
}
