import SwiftUI

struct ForgotPasswordView: View {
    @Bindable var viewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            SpotlyAmbientBackground(variant: .auth)

            VStack(spacing: SpotlySpacing.xxl) {
                Spacer()

                // Header
                VStack(spacing: SpotlySpacing.sm) {
                    ZStack {
                        Circle().fill(SpotlyColors.accent.opacity(0.1)).frame(width: 72, height: 72)
                        Image(systemName: "envelope.badge.key.fill")
                            .font(.system(size: 28, weight: .light))
                            .foregroundStyle(SpotlyColors.accent)
                    }

                    Text("Reset your password")
                        .font(SpotlyFont.title2(.bold))
                        .foregroundStyle(SpotlyColors.textPrimary)

                    Text("Enter your email and we'll send a link\nto get you back in.")
                        .font(SpotlyFont.body())
                        .foregroundStyle(SpotlyColors.textSecondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(3)
                }

                Spacer()

                VStack(spacing: SpotlySpacing.md) {
                    if viewModel.successMessage != nil {
                        // Success state
                        VStack(spacing: SpotlySpacing.md) {
                            ZStack {
                                Circle().fill(SpotlyColors.successBg).frame(width: 60, height: 60)
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 30))
                                    .foregroundStyle(SpotlyColors.success)
                            }
                            Text(viewModel.successMessage ?? "")
                                .font(SpotlyFont.callout(.medium))
                                .foregroundStyle(SpotlyColors.success)
                                .multilineTextAlignment(.center)
                        }
                        .padding(SpotlySpacing.md)
                        .frame(maxWidth: .infinity)
                        .background(SpotlyColors.successBg)
                        .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.md, style: .continuous))
                        .transition(.scale.combined(with: .opacity))

                        SpotlyButton(title: "Back to sign in") { dismiss() }

                    } else {
                        SpotlyTextField(
                            label: "Email",
                            text: $viewModel.email,
                            placeholder: "you@example.com",
                            keyboardType: .emailAddress,
                            textContentType: .emailAddress,
                            autocapitalization: .never,
                            hasError: viewModel.errorMessage != nil
                        )

                        if let error = viewModel.errorMessage {
                            HStack(spacing: SpotlySpacing.xxs) {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .font(SpotlyFont.caption(.semibold))
                                Text(error).font(SpotlyFont.caption())
                            }
                            .foregroundStyle(SpotlyColors.error)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .transition(.move(edge: .top).combined(with: .opacity))
                        }

                        SpotlyButton(title: "Send reset link", isLoading: viewModel.isLoading) {
                            Task { await viewModel.resetPassword() }
                        }

                        Button { dismiss() } label: {
                            Text("Back to sign in")
                                .font(SpotlyFont.callout(.medium))
                                .foregroundStyle(SpotlyColors.textSecondary)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .animation(SpotlyMotion.softSpring, value: viewModel.successMessage != nil)
                .animation(SpotlyMotion.softSpring, value: viewModel.errorMessage != nil)

                Spacer()
                Spacer()
            }
            .padding(.horizontal, SpotlySpacing.screenPadding)
        }
        .scrollDismissesKeyboard(.interactively)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Forgot password")
    }
}
