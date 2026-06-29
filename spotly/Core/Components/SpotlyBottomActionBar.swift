import SwiftUI

struct SpotlyBottomActionBar<Content: View>: View {
    var horizontalPadding: CGFloat = SpotlySpacing.screenPadding
    @ViewBuilder var content: Content

    var body: some View {
        content
            .padding(SpotlySpacing.xs)
            .frame(maxWidth: .infinity)
            .spotlyGlassSurface(
                shape: RoundedRectangle(cornerRadius: SpotlyRadius.lg, style: .continuous),
                tint: SpotlyColors.accent,
                intensity: .regular
            )
            .overlay {
                RoundedRectangle(cornerRadius: SpotlyRadius.lg, style: .continuous)
                    .stroke(SpotlyColors.glassStroke, lineWidth: 0.8)
            }
            .spotlyShadow(SpotlyShadow.float)
            .padding(.horizontal, horizontalPadding)
            .padding(.top, SpotlySpacing.xs)
            .padding(.bottom, SpotlySpacing.xs)
    }
}
