import SwiftUI

// MARK: - Spotly logo mark (SwiftUI-drawn)

struct SpotlyLogoMark: View {
    var size: CGFloat = 64
    var foreground: Color = .white
    var background: Color = SpotlyColors.accent
    var showBackground: Bool = true

    var body: some View {
        ZStack {
            if showBackground {
                RoundedRectangle(cornerRadius: size * 0.26, style: .continuous)
                    .fill(background)
                    .frame(width: size, height: size)
            }
            PinShape()
                .fill(foreground)
                .frame(width: size * 0.46, height: size * 0.58)
                .offset(y: -size * 0.03)
            Text("S")
                .font(.system(size: size * 0.22, weight: .bold, design: .default))
                .foregroundStyle(background)
                .offset(y: -size * 0.10)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Pin shape (map pin without a background square)

private struct PinShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        let cx = rect.midX

        // Teardrop: circle top + pointed bottom
        let circleRadius = w * 0.5
        let circleCenter = CGPoint(x: cx, y: circleRadius)

        // Arc for top circle
        path.addArc(
            center: circleCenter,
            radius: circleRadius,
            startAngle: .degrees(150),
            endAngle: .degrees(30),
            clockwise: false
        )
        // Lines converging to bottom point
        path.addLine(to: CGPoint(x: cx, y: h))
        path.addLine(to: CGPoint(x: cx - circleRadius * sin(.pi / 6), y: circleRadius + circleRadius * cos(.pi / 6)))
        path.closeSubpath()
        return path
    }
}

// MARK: - Animated version for splash

struct AnimatedSpotlyLogo: View {
    var size: CGFloat = 88
    @State private var pinScale: CGFloat = 0.75
    @State private var pinOpacity: Double = 0
    @State private var letterOpacity: Double = 0
    @State private var rippleScale: CGFloat = 0.7
    @State private var rippleOpacity: Double = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ZStack {
            // Ripple ring
            Circle()
                .stroke(Color.white.opacity(0.25), lineWidth: 2)
                .frame(width: size * 1.5, height: size * 1.5)
                .scaleEffect(rippleScale)
                .opacity(rippleOpacity)

            // Background tile
            RoundedRectangle(cornerRadius: size * 0.26, style: .continuous)
                .fill(Color.white.opacity(0.15))
                .frame(width: size, height: size)
                .scaleEffect(pinScale)
                .opacity(pinOpacity)

            // Pin
            PinShape()
                .fill(Color.white)
                .frame(width: size * 0.46, height: size * 0.58)
                .offset(y: -size * 0.03)
                .scaleEffect(pinScale)
                .opacity(pinOpacity)

            // Letter S
            Text("S")
                .font(.system(size: size * 0.22, weight: .bold, design: .default))
                .foregroundStyle(SpotlyColors.accent)
                .offset(y: -size * 0.10)
                .opacity(letterOpacity)
        }
        .frame(width: size * 1.6, height: size * 1.6)
        .onAppear { animate() }
    }

    private func animate() {
        if reduceMotion {
            pinScale = 1; pinOpacity = 1; letterOpacity = 1; rippleOpacity = 0
            return
        }
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.15)) {
            pinScale = 1
            pinOpacity = 1
        }
        withAnimation(.easeIn(duration: 0.25).delay(0.45)) {
            letterOpacity = 1
        }
        withAnimation(.easeOut(duration: 0.6).delay(0.55)) {
            rippleScale = 1.3
            rippleOpacity = 0.6
        }
        withAnimation(.easeIn(duration: 0.35).delay(0.9)) {
            rippleOpacity = 0
        }
    }
}

// MARK: - Wordmark (logo + "spotly" text)

struct SpotlyWordmark: View {
    var iconSize: CGFloat = 36
    var textColor: Color = SpotlyColors.textPrimary
    var accentColor: Color = SpotlyColors.accent

    var body: some View {
        HStack(spacing: 10) {
            SpotlyLogoMark(size: iconSize, foreground: .white, background: accentColor)
            Text("spotly")
                .font(.system(size: iconSize * 0.6, weight: .bold, design: .default))
                .foregroundStyle(textColor)
                .tracking(0.5)
        }
    }
}
