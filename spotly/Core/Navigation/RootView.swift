import SwiftUI

struct RootView: View {
    @Environment(AppState.self) private var appState
    @State private var showSplash = true
    @State private var splashOpacity: Double = 1

    var body: some View {
        ZStack {
            if showSplash {
                SplashView()
                    .opacity(splashOpacity)
                    .transition(.opacity)
            } else if !appState.hasSeenOnboarding {
                OnboardingView {
                    withAnimation(SpotlyMotion.pageTransition) {
                        appState.hasSeenOnboarding = true
                    }
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .opacity
                ))
            } else if !appState.hasCompletedEntryFlow {
                EntryFlowView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .opacity
                    ))
            } else {
                MainTabView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .opacity
                    ))
            }
        }
        .animation(SpotlyMotion.pageTransition, value: appState.hasSeenOnboarding)
        .animation(SpotlyMotion.pageTransition, value: appState.hasCompletedEntryFlow)
        .animation(SpotlyMotion.pageTransition, value: showSplash)
        .task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            withAnimation(.easeOut(duration: 0.4)) { splashOpacity = 0 }
            try? await Task.sleep(nanoseconds: 420_000_000)
            showSplash = false
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
