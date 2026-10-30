import SwiftUI

struct RootView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        Group {
            if appState.isBootstrapping {
                LaunchBootView()
            } else if !appState.hasSeenOnboarding {
                OnboardingView {
                    withAnimation(SpotlyMotion.pageTransition) { appState.hasSeenOnboarding = true }
                }
            } else if !appState.hasCompletedEntryFlow {
                EntryFlowView()
            } else {
                MainTabView()
            }
        }
        .animation(SpotlyMotion.pageTransition, value: appState.isBootstrapping)
        .animation(SpotlyMotion.pageTransition, value: appState.hasSeenOnboarding)
        .animation(SpotlyMotion.pageTransition, value: appState.hasCompletedEntryFlow)
        .task { await appState.bootstrap() }
    }
}

private struct LaunchBootView: View {
    var body: some View {
        ZStack {
            SpotlyColors.background.ignoresSafeArea()
            VStack(spacing: 14) {
                SpotlyLogoMark(size: 58)
                ProgressView()
                    .controlSize(.small)
                    .tint(SpotlyColors.accent)
                    .accessibilityLabel("Opening Spotly")
            }
        }
    }
}

// MARK: - Splash screen

struct SplashView: View {
    @State private var appeared = false
    @State private var wordmarkOpacity: Double = 0
    @State private var wordmarkOffset: CGFloat = 10
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ZStack {
            SpotlyColors.accent.ignoresSafeArea()

            VStack(spacing: SpotlySpacing.lg) {
                AnimatedSpotlyLogo(size: 88)

                VStack(spacing: 4) {
                    Text("spotly")
                        .font(.system(size: 32, weight: .bold, design: .default))
                        .foregroundStyle(.white)
                        .tracking(1.2)
                    Text("Everything you love, all in one spot.")
                        .font(SpotlyFont.callout())
                        .foregroundStyle(.white.opacity(0.78))
                        .multilineTextAlignment(.center)
                }
                .opacity(wordmarkOpacity)
                .offset(y: wordmarkOffset)
            }
            .padding(.horizontal, SpotlySpacing.xxl)
        }
        .onAppear {
            if reduceMotion {
                wordmarkOpacity = 1; wordmarkOffset = 0
            } else {
                withAnimation(.easeOut(duration: 0.4).delay(0.7)) {
                    wordmarkOpacity = 1
                    wordmarkOffset = 0
                }
            }
        }
    }
}
