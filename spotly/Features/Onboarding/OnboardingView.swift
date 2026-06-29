import SwiftUI

private struct OnboardingPage {
    let icon: String
    let accent: Color
    let headline: String
    let body: String
    let gradient: LinearGradient
}

private let pages: [OnboardingPage] = [
    OnboardingPage(
        icon: "sparkles",
        accent: Color(hex: "D7B56D"),
        headline: "Everything you love, all in one spot.",
        body: "Spotly brings the best of Harare's restaurants, experiences, events, wellness, and activities into one beautifully curated place.",
        gradient: SpotlyGradients.champagne
    ),
    OnboardingPage(
        icon: "location.circle.fill",
        accent: Color(hex: "5EEAD4"),
        headline: "Discover what's around you.",
        body: "Find restaurants, cafes, events, beauty salons, padel courts, spas, gyms, and activities — all near you, right now.",
        gradient: SpotlyGradients.aurora
    ),
    OnboardingPage(
        icon: "calendar.badge.checkmark",
        accent: Color(hex: "13A36F"),
        headline: "Book in seconds.",
        body: "Reserve tables, book appointments, lock in court times, and secure event tickets with just a few taps — no calling required.",
        gradient: SpotlyGradients.emerald
    ),
    OnboardingPage(
        icon: "lock.shield.fill",
        accent: Color(hex: "D7B56D"),
        headline: "Pay securely, coming soon.",
        body: "Payment through trusted local options including Paynow is being enabled. Book now, pay seamlessly when checkout launches.",
        gradient: SpotlyGradients.champagne
    ),
]

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var dragOffset: CGFloat = 0
    var onComplete: () -> Void

    var body: some View {
        ZStack {
            SpotlyGradients.onboarding.ignoresSafeArea()

            VStack(spacing: 0) {
                // Skip
                HStack {
                    Spacer()
                    if currentPage < pages.count - 1 {
                        Button {
                            withAnimation(SpotlyMotion.pageTransition) { currentPage = pages.count - 1 }
                        } label: {
                            Text("Skip")
                                .font(SpotlyFont.callout(.medium))
                                .foregroundStyle(SpotlyColors.textSecondary)
                        }
                        .buttonStyle(.plain)
                        .transition(.opacity)
                    }
                }
                .padding(.horizontal, SpotlySpacing.screenPadding)
                .padding(.top, SpotlySpacing.lg)
                .animation(SpotlyMotion.standard, value: currentPage)

                // Pages
                TabView(selection: $currentPage) {
                    ForEach(Array(pages.enumerated()), id: \.offset) { idx, page in
                        OnboardingPageView(page: page, index: idx)
                            .tag(idx)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(SpotlyMotion.pageTransition, value: currentPage)

                // Dots + CTA
                VStack(spacing: SpotlySpacing.xl) {
                    // Page dots
                    HStack(spacing: SpotlySpacing.xs) {
                        ForEach(0..<pages.count, id: \.self) { idx in
                            Capsule(style: .continuous)
                                .fill(idx == currentPage ? SpotlyColors.accent : SpotlyColors.textTertiary)
                                .frame(width: idx == currentPage ? 24 : 6, height: 6)
                                .animation(SpotlyMotion.softSpring, value: currentPage)
                        }
                    }

                    // CTA
                    if currentPage < pages.count - 1 {
                        SpotlyButton(title: "Continue", icon: "arrow.right") {
                            withAnimation(SpotlyMotion.pageTransition) { currentPage += 1 }
                            SpotlyHaptics.lightTap()
                        }
                    } else {
                        SpotlyButton(title: "Get started", icon: "arrow.right") {
                            SpotlyHaptics.success()
                            onComplete()
                        }
                    }
                }
                .padding(.horizontal, SpotlySpacing.screenPadding)
                .padding(.bottom, SpotlySpacing.xxxl)
                .animation(SpotlyMotion.softSpring, value: currentPage)
            }
        }
    }
}

private struct OnboardingPageView: View {
    let page: OnboardingPage
    let index: Int
    @State private var appeared = false

    var body: some View {
        VStack(spacing: SpotlySpacing.xxl) {
            Spacer()

            // Icon ring
            ZStack {
                Circle()
                    .fill(page.accent.opacity(0.08))
                    .frame(width: 160, height: 160)

                Circle()
                    .fill(page.accent.opacity(0.12))
                    .frame(width: 120, height: 120)

                ZStack {
                    page.gradient
                        .mask(
                            Image(systemName: page.icon)
                                .font(.system(size: 52, weight: .light))
                        )
                }
                .frame(width: 52, height: 52)
            }
            .scaleEffect(appeared ? 1 : 0.7)
            .opacity(appeared ? 1 : 0)

            // Text
            VStack(spacing: SpotlySpacing.md) {
                Text(page.headline)
                    .font(SpotlyFont.title(.bold))
                    .foregroundStyle(SpotlyColors.textPrimary)
                    .multilineTextAlignment(.center)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 20)

                Text(page.body)
                    .font(SpotlyFont.body())
                    .foregroundStyle(SpotlyColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(5)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 20)
            }
            .padding(.horizontal, SpotlySpacing.xxl)

            Spacer()
            Spacer()
        }
        .onAppear {
            withAnimation(SpotlyMotion.cardEntrance.delay(0.1)) { appeared = true }
        }
        .onDisappear { appeared = false }
    }
}
