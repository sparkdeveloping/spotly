import SwiftUI

struct SpotlySectionHeader: View {
    let title: String
    var subtitle: String? = nil
    var showSeeAll: Bool = true
    var onSeeAll: (() -> Void)? = nil

    var body: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(SpotlyFont.title3())
                    .foregroundStyle(SpotlyColors.textPrimary)

                if let subtitle {
                    Text(subtitle)
                        .font(SpotlyFont.caption())
                        .foregroundStyle(SpotlyColors.textSecondary)
                }
            }

            Spacer()

            if showSeeAll {
                Button {
                    SpotlyHaptics.lightTap()
                    onSeeAll?()
                } label: {
                    Text("See all")
                        .font(SpotlyFont.callout(.medium))
                        .foregroundStyle(SpotlyColors.accent)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, SpotlySpacing.screenPadding)
    }
}
