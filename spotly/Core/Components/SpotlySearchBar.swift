import SwiftUI

struct SpotlySearchBar: View {
    @Binding var text: String
    var placeholder: String = "Search for places, events..."
    var onSubmit: (() -> Void)? = nil
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: SpotlySpacing.sm) {
            Image(systemName: "magnifyingglass")
                .font(SpotlyFont.body(.medium))
                .foregroundStyle(isFocused ? SpotlyColors.accent : SpotlyColors.textSecondary)
                .animation(SpotlyMotion.quickTap, value: isFocused)

            TextField(placeholder, text: $text)
                .font(SpotlyFont.body())
                .foregroundStyle(SpotlyColors.textPrimary)
                .tint(SpotlyColors.accent)
                .focused($isFocused)
                .submitLabel(.search)
                .onSubmit { onSubmit?() }

            if !text.isEmpty {
                Button {
                    withAnimation(SpotlyMotion.quickTap) { text = "" }
                    SpotlyHaptics.lightTap()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(SpotlyFont.body())
                        .foregroundStyle(SpotlyColors.textTertiary)
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(.horizontal, SpotlySpacing.md)
        .padding(.vertical, SpotlySpacing.sm)
        .spotlyGlassSurface(
            shape: RoundedRectangle(cornerRadius: SpotlyRadius.md, style: .continuous),
            tint: isFocused ? SpotlyColors.accent : SpotlyColors.pearl,
            intensity: isFocused ? .regular : .subtle
        )
        .animation(SpotlyMotion.softSpring, value: isFocused)
    }
}
