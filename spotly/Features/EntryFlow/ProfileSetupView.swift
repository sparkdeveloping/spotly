import SwiftUI

struct ProfileSetupView: View {
    @Binding var name: String
    @Binding var phone: String
    @Binding var selectedCity: String
    var onNext: () -> Void

    @Environment(AppState.self) private var appState

    private let cities = ["Harare", "Bulawayo", "Victoria Falls", "Mutare", "Gweru", "Other"]

    var body: some View {
        ZStack {
            SpotlyAmbientBackground(variant: .auth)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: SpotlySpacing.xxl) {
                    // Header
                    VStack(spacing: SpotlySpacing.xs) {
                        stepIndicator(current: 1, total: 4)
                            .padding(.top, SpotlySpacing.lg)

                        ZStack {
                            Circle().fill(SpotlyColors.accent.opacity(0.1)).frame(width: 64, height: 64)
                            Image(systemName: "person.fill")
                                .font(.system(size: 26, weight: .light))
                                .foregroundStyle(SpotlyColors.accent)
                        }

                        Text("Set up your profile")
                            .font(SpotlyFont.title2(.bold))
                            .foregroundStyle(SpotlyColors.textPrimary)

                        Text("Tell us a little about yourself so we can\npersonalise your experience.")
                            .font(SpotlyFont.callout())
                            .foregroundStyle(SpotlyColors.textSecondary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(3)
                    }

                    // Form
                    VStack(spacing: SpotlySpacing.md) {
                        SpotlyTextField(
                            label: "Your name",
                            text: $name,
                            placeholder: "How should we call you?",
                            textContentType: .name
                        )

                        SpotlyTextField(
                            label: "Phone (optional)",
                            text: $phone,
                            placeholder: "+263 77 000 0000",
                            keyboardType: .phonePad,
                            textContentType: .telephoneNumber
                        )

                        // City picker
                        VStack(alignment: .leading, spacing: SpotlySpacing.xxs) {
                            Text("Your city")
                                .font(SpotlyFont.caption(.semibold))
                                .foregroundStyle(SpotlyColors.textSecondary)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: SpotlySpacing.xs) {
                                    ForEach(cities, id: \.self) { city in
                                        SpotlyChoiceChip(
                                            title: city,
                                            isSelected: selectedCity == city
                                        ) {
                                            selectedCity = city
                                        }
                                    }
                                }
                                .padding(.horizontal, 1)
                            }
                        }
                    }

                    // CTA
                    VStack(spacing: SpotlySpacing.xs) {
                        SpotlyButton(title: "Continue", icon: "arrow.right") {
                            SpotlyHaptics.medium()
                            appState.completeProfile(name: name, phone: phone, city: selectedCity)
                            onNext()
                        }

                        Text("You can update these details anytime from your profile.")
                            .font(SpotlyFont.micro())
                            .foregroundStyle(SpotlyColors.textTertiary)
                            .multilineTextAlignment(.center)
                    }

                    Color.clear.frame(height: SpotlySpacing.xl)
                }
                .padding(.horizontal, SpotlySpacing.screenPadding)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("")
    }

    private func stepIndicator(current: Int, total: Int) -> some View {
        HStack(spacing: SpotlySpacing.xxs) {
            ForEach(1...total, id: \.self) { step in
                Capsule()
                    .fill(step == current ? SpotlyColors.accent : SpotlyColors.divider)
                    .frame(width: step == current ? 24 : 8, height: 6)
                    .animation(SpotlyMotion.softSpring, value: current)
            }
        }
    }
}
