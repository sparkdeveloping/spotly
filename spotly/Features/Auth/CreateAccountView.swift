import SwiftUI

struct CreateAccountView: View {
    @Bindable var viewModel: AuthViewModel
    var onSuccess: (SpotlyUser) -> Void
    var onGuest: () -> Void

    var body: some View {
        ZStack {
            SpotlyAmbientBackground(variant: .auth)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: SpotlySpacing.xxl) {
                    // Header
                    VStack(spacing: SpotlySpacing.xs) {
                        ZStack {
                            Circle().fill(SpotlyColors.accent.opacity(0.1)).frame(width: 64, height: 64)
                            Image(systemName: "person.badge.plus")
                                .font(.system(size: 24, weight: .light))
                                .foregroundStyle(SpotlyColors.accent)
                        }
                        Text("Create your account")
                            .font(SpotlyFont.title2(.bold))
                            .foregroundStyle(SpotlyColors.textPrimary)
                        Text("Join Spotly and start discovering\neverything Zimbabwe has to offer.")
                            .font(SpotlyFont.callout())
                            .foregroundStyle(SpotlyColors.textSecondary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(3)
                    }
                    .padding(.top, SpotlySpacing.xxxl)

                    // Form
                    VStack(spacing: SpotlySpacing.md) {
                        SpotlyTextField(
                            label: "Full name",
                            text: $viewModel.name,
                            placeholder: "Your name",
                            textContentType: .name,
                            hasError: viewModel.errorMessage?.contains("name") == true
                        )

                        SpotlyTextField(
                            label: "Email",
                            text: $viewModel.email,
                            placeholder: "you@example.com",
                            keyboardType: .emailAddress,
                            textContentType: .emailAddress,
                            autocapitalization: .never,
                            hasError: viewModel.errorMessage?.contains("email") == true
                        )

                        SpotlyTextField(
                            label: "Password",
                            text: $viewModel.password,
                            placeholder: "At least 6 characters",
                            isSecure: true,
                            textContentType: .newPassword,
                            hasError: viewModel.errorMessage?.contains("password") == true || viewModel.errorMessage?.contains("short") == true
                        )

                        SpotlyTextField(
                            label: "Confirm password",
                            text: $viewModel.confirmPassword,
                            placeholder: "Repeat your password",
                            isSecure: true,
                            textContentType: .newPassword,
                            hasError: viewModel.errorMessage?.contains("match") == true
                        )

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

                    // CTA
                    VStack(spacing: SpotlySpacing.sm) {
                        SpotlyButton(title: "Create account", icon: "arrow.right", isLoading: viewModel.isLoading) {
                            Task {
                                if let user = await viewModel.createAccount() {
                                    onSuccess(user)
                                }
                            }
                        }

                        HStack {
                            Rectangle().fill(SpotlyColors.divider).frame(height: 0.5)
                            Text("or")
                                .font(SpotlyFont.caption())
                                .foregroundStyle(SpotlyColors.textTertiary)
                                .padding(.horizontal, SpotlySpacing.xs)
                            Rectangle().fill(SpotlyColors.divider).frame(height: 0.5)
                        }

                        Button {
                            SpotlyHaptics.lightTap()
                            onGuest()
                        } label: {
                            Text("Continue as guest")
                                .font(SpotlyFont.callout(.medium))
                                .foregroundStyle(SpotlyColors.textSecondary)
                        }
                        .buttonStyle(.plain)
                    }

                    Text("By creating an account you agree to Spotly's Terms of Service and Privacy Policy.")
                        .font(SpotlyFont.micro())
                        .foregroundStyle(SpotlyColors.textTertiary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(2)

                    Color.clear.frame(height: SpotlySpacing.xl)
                }
                .padding(.horizontal, SpotlySpacing.screenPadding)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("")
    }
}
