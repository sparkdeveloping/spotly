import SwiftUI

struct SignInView: View {
    @Bindable var viewModel: AuthViewModel
    var onSuccess: (SpotlyUser) -> Void
    var onForgotPassword: () -> Void
    var onGuest: () -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            SpotlyAmbientBackground(variant: .auth)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: SpotlySpacing.xxl) {
                    // Header
                    VStack(spacing: SpotlySpacing.xs) {
                        ZStack {
                            Circle().fill(SpotlyColors.accent.opacity(0.1)).frame(width: 64, height: 64)
                            Image(systemName: "lock.open.fill")
                                .font(.system(size: 26, weight: .light))
                                .foregroundStyle(SpotlyColors.accent)
                        }
                        Text("Welcome back")
                            .font(SpotlyFont.title2(.bold))
                            .foregroundStyle(SpotlyColors.textPrimary)
                        Text("Sign in to your Spotly account")
                            .font(SpotlyFont.callout())
                            .foregroundStyle(SpotlyColors.textSecondary)
                    }
                    .padding(.top, SpotlySpacing.xxxl)

                    // Form
                    VStack(spacing: SpotlySpacing.md) {
                        SpotlyTextField(
                            label: "Email",
                            text: $viewModel.email,
                            placeholder: "you@example.com",
                            keyboardType: .emailAddress,
                            textContentType: .emailAddress,
                            autocapitalization: .never,
                            hasError: viewModel.errorMessage != nil
                        )

                        SpotlyTextField(
                            label: "Password",
                            text: $viewModel.password,
                            placeholder: "Your password",
                            isSecure: true,
                            textContentType: .password,
                            hasError: viewModel.errorMessage != nil
                        )

                        // Error message
                        if let error = viewModel.errorMessage {
                            HStack(spacing: SpotlySpacing.xxs) {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .font(SpotlyFont.caption(.semibold))
                                Text(error)
                                    .font(SpotlyFont.caption())
                            }
                            .foregroundStyle(SpotlyColors.error)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .transition(.move(edge: .top).combined(with: .opacity))
                        }
                    }
                    .animation(SpotlyMotion.softSpring, value: viewModel.errorMessage != nil)

                    // Actions
                    VStack(spacing: SpotlySpacing.sm) {
                        SpotlyButton(title: "Sign in", isLoading: viewModel.isLoading) {
                            Task {
                                if let user = await viewModel.signIn() {
                                    onSuccess(user)
                                }
                            }
                        }

                        Button {
                            viewModel.clearError()
                            onForgotPassword()
                        } label: {
                            Text("Forgot password?")
                                .font(SpotlyFont.callout(.medium))
                                .foregroundStyle(SpotlyColors.accent)
                        }
                        .buttonStyle(.plain)
                    }

                    // Divider
                    HStack {
                        Rectangle().fill(SpotlyColors.divider).frame(height: 0.5)
                        Text("or sign in with")
                            .font(SpotlyFont.caption())
                            .foregroundStyle(SpotlyColors.textTertiary)
                            .padding(.horizontal, SpotlySpacing.xs)
                            .fixedSize()
                        Rectangle().fill(SpotlyColors.divider).frame(height: 0.5)
                    }

                    // Social buttons
                    VStack(spacing: SpotlySpacing.xs) {
                        SpotlyAuthSocialButton(provider: .apple) {
                            showComingSoon()
                        }
                        SpotlyAuthSocialButton(provider: .google) {
                            showComingSoon()
                        }
                    }

                    // Guest
                    Button {
                        SpotlyHaptics.lightTap()
                        onGuest()
                    } label: {
                        Text("Continue as guest")
                            .font(SpotlyFont.callout(.medium))
                            .foregroundStyle(SpotlyColors.textSecondary)
                    }
                    .buttonStyle(.plain)

                    Color.clear.frame(height: SpotlySpacing.xl)
                }
                .padding(.horizontal, SpotlySpacing.screenPadding)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("")
    }

    private func showComingSoon() {
        SpotlyHaptics.lightTap()
        // Social sign-in is being prepared for the next release.
    }
}
