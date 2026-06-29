import SwiftUI

struct SpotlyTabBar: View {
    @Binding var selectedTab: AppTab

    var body: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases, id: \.self) { tab in
                TabBarItem(tab: tab, isSelected: selectedTab == tab) {
                    if selectedTab != tab {
                        SpotlyHaptics.selection()
                        withAnimation(SpotlyMotion.softSpring) {
                            selectedTab = tab
                        }
                    }
                }
            }
        }
        .padding(.horizontal, SpotlySpacing.xs)
        .padding(.vertical, SpotlySpacing.xs)
        .background {
            Capsule(style: .continuous)
                .fill(SpotlyColors.glass)
                .background(.ultraThinMaterial, in: Capsule(style: .continuous))
                .overlay(alignment: .topLeading) {
                    Capsule(style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [SpotlyColors.accent.opacity(0.18), SpotlyColors.aurora.opacity(0.08), .clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .blur(radius: 10)
                }
                .overlay {
                    Capsule(style: .continuous)
                        .stroke(SpotlyColors.glassStroke, lineWidth: 0.8)
                }
                .spotlyShadow(SpotlyShadow.float)
        }
        .frame(maxWidth: 318)
        .padding(.horizontal, 34)
    }
}

private struct TabBarItem: View {
    let tab: AppTab
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                if isSelected {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [SpotlyColors.accent.opacity(0.36), SpotlyColors.accent.opacity(0.12), .clear],
                                center: .center,
                                startRadius: 4,
                                endRadius: 28
                            )
                        )
                        .frame(width: 52, height: 52)
                        .blur(radius: 2)
                        .transition(.scale.combined(with: .opacity))
                }
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(SpotlyColors.surface.opacity(0.72))
                            .frame(width: 44, height: 44)
                            .overlay {
                                Circle().stroke(SpotlyColors.accent.opacity(0.36), lineWidth: 0.8)
                            }
                    }
                    Image(systemName: tab.icon)
                        .font(.system(size: 19, weight: .semibold))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(isSelected ? SpotlyColors.accent : SpotlyColors.textPrimary.opacity(0.62))
                        .scaleEffect(isSelected ? 1.08 : 1.0)
                }
                .animation(SpotlyMotion.softSpring, value: isSelected)
                .frame(width: 52, height: 52)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
