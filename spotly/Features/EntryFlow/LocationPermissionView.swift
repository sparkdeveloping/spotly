import SwiftUI

struct LocationPermissionView: View {
    var onNext: () -> Void
    var onSkip: () -> Void

    @Environment(AppState.self) private var appState
    @State private var locationService = LocationService()
    @State private var isRequesting = false
    @State private var selectedCity = "Harare"
    @State private var showManualCity = false

    private let cities = ["Harare", "Bulawayo", "Victoria Falls", "Mutare", "Gweru", "Other"]

    var body: some View {
        ZStack {
            SpotlyAmbientBackground(variant: .auth)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: SpotlySpacing.xxl) {
                    VStack(spacing: SpotlySpacing.sm) {
                        stepIndicator(current: 3, total: 4)
                            .padding(.top, SpotlySpacing.lg)

                        ZStack {
                            Circle()
                                .fill(SpotlyColors.aurora.opacity(0.12))
                                .frame(width: 172, height: 172)
                            Circle()
                                .fill(SpotlyColors.aurora.opacity(0.18))
                                .frame(width: 110, height: 110)
                            ZStack {
                                Circle()
                                    .fill(SpotlyColors.aurora)
                                    .frame(width: 72, height: 72)
                                Image(systemName: "location.fill")
                                    .font(.system(size: 28, weight: .light))
                                    .foregroundStyle(SpotlyColors.obsidian)
                            }
                        }
                        .padding(.top, SpotlySpacing.xl)

                        Text("Find what's close to you")
                            .font(SpotlyFont.title2(.bold))
                            .foregroundStyle(SpotlyColors.textPrimary)

                        Text("Spotly uses your location to recommend nearby restaurants, events, activities, and experiences.")
                            .font(SpotlyFont.body())
                            .foregroundStyle(SpotlyColors.textSecondary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(3)
                    }

                    VStack(alignment: .leading, spacing: SpotlySpacing.md) {
                        HStack(spacing: SpotlySpacing.sm) {
                            Image(systemName: "map.fill")
                                .font(SpotlyFont.callout(.semibold))
                                .foregroundStyle(SpotlyColors.accent)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Current city")
                                    .font(SpotlyFont.callout(.semibold))
                                    .foregroundStyle(SpotlyColors.textPrimary)
                                Text(appState.selectedCity)
                                    .font(SpotlyFont.caption())
                                    .foregroundStyle(SpotlyColors.textSecondary)
                            }
                            Spacer()
                        }
                        .padding(SpotlySpacing.cardPadding)
                        .cardBackground()

                        if showManualCity {
                            FlowLayout(spacing: SpotlySpacing.xs) {
                                ForEach(cities, id: \.self) { city in
                                    SpotlyChoiceChip(
                                        title: city,
                                        isSelected: selectedCity == city
                                    ) {
                                        selectedCity = city
                                        appState.selectedCity = city
                                    }
                                }
                            }
                            .transition(.move(edge: .top).combined(with: .opacity))
                        }
                    }

                    VStack(spacing: SpotlySpacing.xs) {
                        SpotlyButton(title: "Allow location", icon: "location.fill", isLoading: isRequesting) {
                            Task { await requestLocation() }
                        }

                        SpotlyButton(title: "Choose city manually", variant: .secondary) {
                            withAnimation(SpotlyMotion.softSpring) { showManualCity.toggle() }
                        }

                        Button {
                            SpotlyHaptics.lightTap()
                            onSkip()
                        } label: {
                            Text("Not now")
                                .font(SpotlyFont.callout(.medium))
                                .foregroundStyle(SpotlyColors.textTertiary)
                        }
                        .buttonStyle(.plain)
                    }

                    Color.clear.frame(height: SpotlySpacing.xl)
                }
                .padding(.horizontal, SpotlySpacing.screenPadding)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("")
        .onAppear { selectedCity = appState.selectedCity }
    }

    @MainActor
    private func requestLocation() async {
        isRequesting = true
        let state = await locationService.requestPermission()
        isRequesting = false
        if state == .authorized {
            SpotlyHaptics.success()
        } else {
            SpotlyHaptics.lightTap()
        }
        onNext()
    }

    private func stepIndicator(current: Int, total: Int) -> some View {
        HStack(spacing: SpotlySpacing.xxs) {
            ForEach(1...total, id: \.self) { step in
                Capsule()
                    .fill(step <= current ? SpotlyColors.accent : SpotlyColors.divider)
                    .frame(width: step == current ? 24 : 8, height: 6)
                    .animation(SpotlyMotion.softSpring, value: current)
            }
        }
    }
}
