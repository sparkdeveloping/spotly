import SwiftUI

struct SpotlyChoiceChip: View {
    let label: String
    var icon: String? = nil
    var isSelected: Bool = false
    var action: () -> Void

    init(label: String, icon: String? = nil, isSelected: Bool = false, action: @escaping () -> Void) {
        self.label = label
        self.icon = icon
        self.isSelected = isSelected
        self.action = action
    }

    init(title: String, icon: String? = nil, isSelected: Bool = false, action: @escaping () -> Void) {
        self.init(label: title, icon: icon, isSelected: isSelected, action: action)
    }

    var body: some View {
        Button(action: {
            SpotlyHaptics.selection()
            action()
        }) {
            HStack(spacing: 5) {
                if let icon {
                    Image(systemName: icon)
                        .font(SpotlyFont.micro(.semibold))
                        .foregroundStyle(isSelected ? SpotlyColors.chipSelectedText : SpotlyColors.textSecondary)
                }
                Text(label)
                    .font(SpotlyFont.caption(.medium))
                    .foregroundStyle(isSelected ? SpotlyColors.chipSelectedText : SpotlyColors.textPrimary)
            }
            .padding(.horizontal, SpotlySpacing.sm)
            .padding(.vertical, SpotlySpacing.xs)
            .background {
                Capsule(style: .continuous)
                    .fill(isSelected ? SpotlyColors.chipSelectedBg : SpotlyColors.chipBackground)
                    .overlay {
                        Capsule(style: .continuous)
                            .stroke(
                                isSelected ? Color.clear : SpotlyColors.border,
                                lineWidth: 0.5
                            )
                    }
            }
        }
        .buttonStyle(.plain)
        .pressableScale(scale: 0.93)
        .animation(SpotlyMotion.softSpring, value: isSelected)
    }
}
