import SwiftUI

struct SpotlyCategoryPill: View {
    let category: SpotlyCategory
    var isSelected: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: {
            SpotlyHaptics.selection()
            action()
        }) {
            HStack(spacing: SpotlySpacing.xxs) {
                Image(systemName: category.icon)
                    .font(SpotlyFont.caption(.semibold))
                    .foregroundStyle(isSelected ? SpotlyColors.textOnAccent : Color(hex: category.colorHex))

                Text(category.name)
                    .font(SpotlyFont.caption(.semibold))
                    .foregroundStyle(isSelected ? SpotlyColors.textOnAccent : SpotlyColors.textPrimary)
            }
            .padding(.horizontal, SpotlySpacing.sm)
            .padding(.vertical, SpotlySpacing.xs)
            .spotlyGlassSurface(
                shape: Capsule(style: .continuous),
                tint: isSelected ? SpotlyColors.accent : Color(hex: category.colorHex),
                intensity: isSelected ? .regular : .subtle
            )
        }
        .buttonStyle(.plain)
        .pressableScale(scale: 0.94)
        .animation(SpotlyMotion.softSpring, value: isSelected)
    }
}

struct SpotlyFilterChip: View {
    let label: String
    var icon: String? = nil
    var isSelected: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: {
            SpotlyHaptics.selection()
            action()
        }) {
            HStack(spacing: 4) {
                if let icon {
                    Image(systemName: icon)
                        .font(SpotlyFont.micro(.semibold))
                }
                Text(label)
                    .font(SpotlyFont.caption(.medium))
            }
            .foregroundStyle(isSelected ? .white : SpotlyColors.textSecondary)
            .padding(.horizontal, SpotlySpacing.sm)
            .padding(.vertical, 8)
            .background(isSelected ? SpotlyColors.accent : SpotlyColors.backgroundElevated)
            .clipShape(Capsule(style: .continuous))
            .overlay {
                Capsule(style: .continuous)
                    .stroke(isSelected ? SpotlyColors.accent : SpotlyColors.border, lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .pressableScale(scale: 0.95)
        .animation(SpotlyMotion.softSpring, value: isSelected)
    }
}
