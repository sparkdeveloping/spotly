import SwiftUI

struct SpotlyBottomActionBar<Content: View>: View {
    var horizontalPadding: CGFloat = SpotlySpacing.screenPadding
    @ViewBuilder var content: Content

    var body: some View {
        content
            .padding(SpotlySpacing.xs)
            .frame(maxWidth: .infinity)
            .background(SpotlyColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.lg, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: SpotlyRadius.lg, style: .continuous)
                    .stroke(SpotlyColors.border, lineWidth: 1)
            }
            .spotlyShadow(SpotlyShadow.elevated)
            .padding(.horizontal, horizontalPadding)
            .padding(.top, SpotlySpacing.xs)
            .padding(.bottom, SpotlySpacing.xs)
    }
}
