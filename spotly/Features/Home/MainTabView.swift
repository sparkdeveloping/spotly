import SwiftUI

struct MainTabView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        @Bindable var state = appState

        TabView(selection: $state.selectedTab) {
            Tab("Home", systemImage: "house.fill", value: AppTab.home) {
                ProductionHomeView()
            }

            Tab("Search", systemImage: "magnifyingglass", value: AppTab.search, role: .search) {
                ProductionSearchView()
            }

            Tab("Activity", systemImage: "clock.fill", value: AppTab.activity) {
                ActivityView()
            }
            .badge(appState.activity.attentionCount)

            Tab("Saved", systemImage: "heart.fill", value: AppTab.favourites) {
                SavedView()
            }

            Tab("Profile", systemImage: "person.crop.circle.fill", value: AppTab.profile) {
                ProductionProfileView()
            }
        }
        .tint(SpotlyColors.accent)
        .spotlyTabBarBehavior()
        .onChange(of: appState.selectedTab) { _, _ in SpotlyHaptics.selection() }
        .sheet(item: $state.pendingDeepLink) { route in
            DeepLinkDestinationView(route: route)
                .presentationDetents([.large])
        }
    }
}

private extension View {
    @ViewBuilder
    func spotlyTabBarBehavior() -> some View {
        if #available(iOS 26.0, *) {
            self.tabBarMinimizeBehavior(.onScrollDown)
        } else {
            self
        }
    }
}
