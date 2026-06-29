import SwiftUI

struct SpotlyScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct SpotlyScrollOffsetReader: View {
    let coordinateSpace: String

    var body: some View {
        GeometryReader { proxy in
            Color.clear.preference(
                key: SpotlyScrollOffsetPreferenceKey.self,
                value: proxy.frame(in: .named(coordinateSpace)).minY
            )
        }
        .frame(height: 0)
    }
}

struct SpotlyStretchyHeader<Content: View>: View {
    let height: CGFloat
    let coordinateSpace: String
    @ViewBuilder var content: Content

    var body: some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .named(coordinateSpace)).minY
            let stretch = max(minY, 0)

            content
                .frame(height: height + stretch)
                .frame(maxWidth: .infinity)
                .offset(y: minY > 0 ? -stretch : 0)
        }
        .frame(height: height)
    }
}

struct StretchyHeroHeader: View {
    let imageName: String?
    let categoryID: String
    let title: String
    let subtitle: String?
    let categoryLabel: String
    let statusLabel: String?
    var height: CGFloat = 360
    let coordinateSpace: String
    let onBack: () -> Void
    let onShare: () -> Void

    var body: some View {
        SpotlyStretchyHeader(height: height, coordinateSpace: coordinateSpace) {
            ZStack(alignment: .bottomLeading) {
                SpotlyImageView(imageName: imageName, categoryID: categoryID, style: .hero)
                LinearGradient(
                    colors: [.black.opacity(0.24), .clear, .black.opacity(0.72)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                VStack(alignment: .leading, spacing: SpotlySpacing.xs) {
                    HStack(spacing: SpotlySpacing.xs) {
                        Text(categoryLabel)
                            .font(SpotlyFont.caption(.semibold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, SpotlySpacing.xs)
                            .padding(.vertical, 4)
                            .background(.black.opacity(0.35))
                            .clipShape(Capsule())
                        if let statusLabel {
                            Text(statusLabel)
                                .font(SpotlyFont.caption(.semibold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, SpotlySpacing.xs)
                                .padding(.vertical, 4)
                                .background(SpotlyColors.accent.opacity(0.92))
                                .clipShape(Capsule())
                        }
                    }
                    Text(title)
                        .font(SpotlyFont.title(.bold))
                        .foregroundStyle(.white)
                        .lineLimit(2)
                        .minimumScaleFactor(0.82)
                    if let subtitle {
                        Text(subtitle)
                            .font(SpotlyFont.callout(.semibold))
                            .foregroundStyle(.white.opacity(0.84))
                            .lineLimit(1)
                    }
                }
                .padding(.horizontal, SpotlySpacing.screenPadding)
                .padding(.bottom, SpotlySpacing.lg)
            }
            .overlay(alignment: .top) {
                HStack {
                    headerButton(icon: "chevron.left", action: onBack)
                    Spacer()
                    headerButton(icon: "square.and.arrow.up", action: onShare)
                }
                .padding(.horizontal, SpotlySpacing.screenPadding)
                .padding(.top, 58)
            }
        }
    }

    private func headerButton(icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
                .background(.black.opacity(0.34))
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }
}

struct SpotlyStickyHeader<Content: View>: View {
    let isVisible: Bool
    var topPadding: CGFloat = 8
    @ViewBuilder var content: Content

    var body: some View {
        Group {
            if isVisible {
                content
                    .padding(.horizontal, SpotlySpacing.md)
                    .padding(.top, topPadding)
                    .padding(.bottom, SpotlySpacing.xs)
                    .frame(maxWidth: .infinity)
                    .spotlyToolbarGlass()
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.snappy(duration: 0.22), value: isVisible)
    }
}

struct SpotlyBottomRoundedRectangle: Shape {
    var radius: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let radius = min(radius, rect.width / 2, rect.height / 2)
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - radius))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX - radius, y: rect.maxY),
            control: CGPoint(x: rect.maxX, y: rect.maxY)
        )
        path.addLine(to: CGPoint(x: rect.minX + radius, y: rect.maxY))
        path.addQuadCurve(
            to: CGPoint(x: rect.minX, y: rect.maxY - radius),
            control: CGPoint(x: rect.minX, y: rect.maxY)
        )
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}

struct SpotlyBottomSafeSpacer: View {
    var extra: CGFloat = 0

    var body: some View {
        Color.clear.frame(height: SpotlySpacing.safeAreaPad + extra)
    }
}
