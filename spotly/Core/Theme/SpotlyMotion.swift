import SwiftUI

enum SpotlyMotion {
    static let quickTap       = Animation.spring(response: 0.2, dampingFraction: 0.8)
    static let softSpring     = Animation.spring(response: 0.35, dampingFraction: 0.75)
    static let pageTransition = Animation.spring(response: 0.4, dampingFraction: 0.85)
    static let cardEntrance   = Animation.spring(response: 0.5, dampingFraction: 0.8)
    static let sheetSpring    = Animation.spring(response: 0.45, dampingFraction: 0.8)
    static let successPop     = Animation.spring(response: 0.3, dampingFraction: 0.6)
    static let quick          = Animation.easeOut(duration: 0.15)
    static let standard       = Animation.easeInOut(duration: 0.25)
    static let slow           = Animation.easeInOut(duration: 0.4)
}

// MARK: - Scroll-safe press styles

struct SpotlyPressableButtonStyle: ButtonStyle {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    var scale: CGFloat = 0.96

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed && !reduceMotion ? scale : 1)
            .opacity(configuration.isPressed ? 0.92 : 1)
            .animation(SpotlyMotion.quickTap, value: configuration.isPressed)
    }
}

extension View {
    func pressableScale(scale: CGFloat = 0.96) -> some View {
        buttonStyle(SpotlyPressableButtonStyle(scale: scale))
    }
}

// MARK: - Appear animation

struct AppearModifier: ViewModifier {
    @State private var appeared = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    var delay: Double = 0

    func body(content: Content) -> some View {
        content
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : (reduceMotion ? 0 : 16))
            .onAppear {
                withAnimation(SpotlyMotion.cardEntrance.delay(delay)) { appeared = true }
            }
    }
}

extension View {
    func spotlyAppear(delay: Double = 0) -> some View {
        modifier(AppearModifier(delay: delay))
    }
}
