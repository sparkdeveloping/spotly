import SwiftUI

// ContentView is no longer the app root.
// Entry point: spotlyApp → RootView → OnboardingView / MainTabView
// This file is retained to avoid orphaned project references.

struct ContentView: View {
    var body: some View {
        RootView()
    }
}
