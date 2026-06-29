import SwiftUI

struct NotificationPreferenceView: View {
    var onFinish: (Set<String>) -> Void

    @State private var notifService = NotificationPermissionService()
    @State private var isRequesting = false
    @State private var hasEnabled = false
    @State private var preferences: [NotifPreference] = NotifPreference.all

    var body: some View {
        ZStack {
            SpotlyAmbientBackground(variant: .auth)

            VStack(spacing: 0) {
                Spacer()

                // Illustration
                ZStack {
                    Circle()
                        .fill(SpotlyColors.champagne.opacity(0.08))
                        .frame(width: 180, height: 180)
                    Circle()
                        .fill(SpotlyColors.champagne.opacity(0.12))
                        .frame(width: 110, height: 110)
                    ZStack {
                        Circle().fill(SpotlyColors.champagne).frame(width: 72, height: 72)
                        Image(systemName: "bell.badge.fill")
                            .font(.system(size: 28, weight: .light))
                            .foregroundStyle(SpotlyColors.ink)
                    }
                }

                Spacer().frame(height: SpotlySpacing.xl)

                // Header
                VStack(spacing: SpotlySpacing.sm) {
                    stepIndicator(current: 4, total: 4)

                    Text("Stay in the loop")
                        .font(SpotlyFont.title2(.bold))
                        .foregroundStyle(SpotlyColors.textPrimary)

                    Text("Get booking confirmations, event reminders, offers, and updates that actually matter.")
                        .font(SpotlyFont.body())
                        .foregroundStyle(SpotlyColors.textSecondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(3)
                }

                Spacer()

                // Preference list
                VStack(spacing: SpotlySpacing.sm) {
                    ForEach($preferences) { $pref in
                        HStack(spacing: SpotlySpacing.md) {
                            ZStack {
                                RoundedRectangle(cornerRadius: SpotlyRadius.sm, style: .continuous)
                                    .fill(SpotlyColors.accent.opacity(0.1))
                                    .frame(width: 44, height: 44)
                                Image(systemName: pref.icon)
                                    .font(.system(size: 18, weight: .light))
                                    .foregroundStyle(SpotlyColors.accent)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text(pref.title)
                                    .font(SpotlyFont.callout(.semibold))
                                    .foregroundStyle(SpotlyColors.textPrimary)
                                Text(pref.subtitle)
                                    .font(SpotlyFont.caption())
                                    .foregroundStyle(SpotlyColors.textSecondary)
                            }
                            Spacer()
                            Toggle("", isOn: $pref.isEnabled)
                                .labelsHidden()
                                .tint(SpotlyColors.accent)
                        }
                        .padding(SpotlySpacing.sm)
                        .background(SpotlyColors.surface)
                        .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.md, style: .continuous))
                    }
                }
                .padding(.horizontal, SpotlySpacing.screenPadding)

                Spacer()

                // Actions
                VStack(spacing: SpotlySpacing.xs) {
                    if hasEnabled {
                        SpotlyButton(title: "All set — Take me in!", icon: "arrow.right") {
                            SpotlyHaptics.success()
                            onFinish(enabledPreferenceIDs)
                        }
                    } else {
                        SpotlyButton(title: "Enable notifications", isLoading: isRequesting) {
                            Task { await requestNotifications() }
                        }

                        Button { onFinish([]) } label: {
                            Text("Not now")
                                .font(SpotlyFont.callout(.medium))
                                .foregroundStyle(SpotlyColors.textTertiary)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, SpotlySpacing.screenPadding)
                .padding(.bottom, SpotlySpacing.xxxl)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("")
    }

    @MainActor
    private func requestNotifications() async {
        isRequesting = true
        let granted = (try? await notifService.requestPermission()) ?? false
        isRequesting = false
        hasEnabled = granted
        if granted {
            SpotlyHaptics.success()
        }
    }

    private var enabledPreferenceIDs: Set<String> {
        Set(preferences.filter(\.isEnabled).map(\.title))
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

// MARK: - Preference model
struct NotifPreference: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let subtitle: String
    var isEnabled: Bool

    static let all: [NotifPreference] = [
        .init(icon: "calendar.badge.checkmark", title: "Booking confirmations", subtitle: "Receipts, updates, and changes", isEnabled: true),
        .init(icon: "bell.badge.fill", title: "Event reminders", subtitle: "Helpful nudges before plans start", isEnabled: true),
        .init(icon: "location.fill", title: "Offers near me", subtitle: "Relevant deals around your city", isEnabled: false),
        .init(icon: "sparkles", title: "Weekend picks", subtitle: "Curated plans worth knowing about", isEnabled: true),
    ]
}
