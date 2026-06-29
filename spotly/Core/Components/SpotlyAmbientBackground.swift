import SwiftUI

// Retained for source compatibility — now renders a simple clean background
// instead of the heavy bokeh/glow effect.

enum SpotlyAmbientVariant {
    case home, discover, detail, profile, empty, auth, booking
}

struct SpotlyAmbientBackground: View {
    var variant: SpotlyAmbientVariant = .home

    var body: some View {
        SpotlyColors.background.ignoresSafeArea()
    }
}
