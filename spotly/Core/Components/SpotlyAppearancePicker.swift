import SwiftUI

struct SpotlyAppearancePicker: View {
    @Binding var selection: String   // "system" | "light" | "dark"

    private let options: [(id: String, label: String, icon: String)] = [
        ("system", "System", "circle.lefthalf.filled"),
        ("light",  "Light",  "sun.max.fill"),
        ("dark",   "Dark",   "moon.fill"),
    ]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(options, id: \.id) { opt in
                Button {
                    SpotlyHaptics.selection()
                    withAnimation(SpotlyMotion.softSpring) { selection = opt.id }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: opt.icon)
                            .font(.system(size: 15, weight: selection == opt.id ? .semibold : .regular))
                        Text(opt.label)
                            .font(SpotlyFont.nano(selection == opt.id ? .semibold : .regular))
                    }
                    .foregroundStyle(selection == opt.id ? SpotlyColors.textOnAccent : SpotlyColors.textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, SpotlySpacing.xs)
                    .background {
                        if selection == opt.id {
                            Capsule(style: .continuous)
                                .fill(SpotlyColors.accent)
                                .padding(3)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(SpotlyColors.surfaceElevated)
        .clipShape(Capsule(style: .continuous))
    }
}
