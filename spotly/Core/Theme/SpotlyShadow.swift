import SwiftUI

struct SpotlyShadowStyle {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

enum SpotlyShadow {
    static let section   = SpotlyShadowStyle(color: .clear, radius: 0, x: 0, y: 0)
    static let card      = SpotlyShadowStyle(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    static let elevated  = SpotlyShadowStyle(color: .black.opacity(0.06), radius: 12, x: 0, y: 4)
    static let hero      = SpotlyShadowStyle(color: .black.opacity(0.10), radius: 14, x: 0, y: 6)
    static let cardHeavy = elevated
    static let tab       = section
    static let button    = section
    static let float     = elevated
    static let accent    = section
    static let glow      = section
}

extension View {
    func spotlyShadow(_ style: SpotlyShadowStyle) -> some View {
        shadow(color: style.color, radius: style.radius, x: style.x, y: style.y)
    }
}
