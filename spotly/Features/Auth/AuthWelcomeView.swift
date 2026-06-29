import SwiftUI

struct AuthWelcomeView: View {
    var onCreateAccount: () -> Void
    var onSignIn: () -> Void
    var onGuest: () -> Void

    @State private var appeared = false

    var body: some View {
        ZStack {
            SpotlyColors.background.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Logo area
                VStack(spacing: SpotlySpacing.lg) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(SpotlyColors.accent)
                            .frame(width: 88, height: 88)
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 44, weight: .medium))
                            .foregroundStyle(.white)
                    }
                    .scaleEffect(appeared ? 1 : 0.8)
                    .opacity(appeared ? 1 : 0)

                    VStack(spacing: SpotlySpacing.xs) {
                        Text("Welcome to Spotly")
                            .font(SpotlyFont.title(.bold))
                            .foregroundStyle(SpotlyColors.textPrimary)
                            .multilineTextAlignment(.center)
                        Text("Discover restaurants, events and experiences\nin Zimbabwe's top booking app.")
                            .font(SpotlyFont.callout())
                            .foregroundStyle(SpotlyColors.textSecondary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                    }
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 10)
                }

                Spacer()

                // Feature bullets
                VStack(alignment: .leading, spacing: SpotlySpacing.sm) {
                    featureBullet(icon: "fork.knife", text: "Discover restaurants and cafés")
                    featureBullet(icon: "calendar.badge.plus", text: "Book tables, spas, and events")
                    featureBullet(icon: "star.fill", text: "Read real reviews from real people")
                }
                .padding(.horizontal, SpotlySpacing.xl)
                .padding(.bottom, SpotlySpacing.xxl)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 12)

                // CTAs
                VStack(spacing: SpotlySpacing.sm) {
                    SpotlyButton(title: "Create account") {
                        SpotlyHaptics.medium()
                        onCreateAccount()
                    }

                    SpotlyButton(title: "Sign in", variant: .secondary) {
                        SpotlyHaptics.lightTap()
                        onSignIn()
                    }

                    HStack {
                        Rectangle().fill(SpotlyColors.divider).frame(height: 1)
                        Text("or")
                            .font(SpotlyFont.caption())
                            .foregroundStyle(SpotlyColors.textTertiary)
                            .padding(.horizontal, SpotlySpacing.xs)
                        Rectangle().fill(SpotlyColors.divider).frame(height: 1)
                    }

                    Button {
                        SpotlyHaptics.lightTap()
                        onGuest()
                    } label: {
                        Text("Browse as guest")
                            .font(SpotlyFont.callout(.medium))
                            .foregroundStyle(SpotlyColors.textSecondary)
                    }
                    .buttonStyle(.plain)
                    .pressableScale()

                    Text("You can sign in later when you're ready to book.")
                        .font(SpotlyFont.micro())
                        .foregroundStyle(SpotlyColors.textTertiary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, SpotlySpacing.screenPadding)
                .padding(.bottom, SpotlySpacing.xxxl)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 16)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            withAnimation(SpotlyMotion.cardEntrance.delay(0.1)) { appeared = true }
        }
    }

    private func featureBullet(icon: String, text: String) -> some View {
        HStack(spacing: SpotlySpacing.sm) {
            ZStack {
                RoundedRectangle(cornerRadius: SpotlyRadius.xs)
                    .fill(SpotlyColors.accentBg)
                    .frame(width: 32, height: 32)
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(SpotlyColors.accent)
            }
            Text(text)
                .font(SpotlyFont.callout())
                .foregroundStyle(SpotlyColors.textSecondary)
            Spacer()
        }
    }
}
