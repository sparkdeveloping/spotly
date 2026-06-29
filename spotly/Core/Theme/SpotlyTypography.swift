import SwiftUI

enum SpotlyFont {
    static func displayLarge(_ weight: Font.Weight = .bold) -> Font  { .system(size: 48, weight: weight, design: .default) }
    static func display(_ weight: Font.Weight = .bold) -> Font       { .system(size: 34, weight: weight, design: .default) }
    static func title(_ weight: Font.Weight = .bold) -> Font         { .system(size: 28, weight: weight, design: .default) }
    static func title2(_ weight: Font.Weight = .semibold) -> Font    { .system(size: 22, weight: weight, design: .default) }
    static func title3(_ weight: Font.Weight = .semibold) -> Font    { .system(size: 20, weight: weight, design: .default) }
    static func headline(_ weight: Font.Weight = .semibold) -> Font  { .system(size: 17, weight: weight, design: .default) }
    static func body(_ weight: Font.Weight = .regular) -> Font       { .system(size: 15, weight: weight, design: .default) }
    static func callout(_ weight: Font.Weight = .regular) -> Font    { .system(size: 14, weight: weight, design: .default) }
    static func subheadline(_ weight: Font.Weight = .medium) -> Font { .system(size: 13, weight: weight, design: .default) }
    static func caption(_ weight: Font.Weight = .regular) -> Font    { .system(size: 12, weight: weight, design: .default) }
    static func micro(_ weight: Font.Weight = .medium) -> Font       { .system(size: 11, weight: weight, design: .default) }
    static func nano(_ weight: Font.Weight = .semibold) -> Font      { .system(size: 10, weight: weight, design: .default) }
}

extension View {
    func spotlyText(
        _ font: Font,
        color: Color = SpotlyColors.textPrimary,
        tracking: CGFloat = 0
    ) -> some View {
        self.font(font).foregroundStyle(color).tracking(tracking)
    }
}
