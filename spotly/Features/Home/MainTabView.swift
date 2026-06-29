import SwiftUI

struct MainTabView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        @Bindable var state = appState

        TabView(selection: $state.selectedTab) {
            HomeView()
                .tag(AppTab.home)
                .tabItem {
                    Label(AppTab.home.title, systemImage: AppTab.home.icon)
                }

            SearchView()
                .tag(AppTab.search)
                .tabItem {
                    Label(AppTab.search.title, systemImage: AppTab.search.icon)
                }

            BookingsView()
                .tag(AppTab.bookings)
                .tabItem {
                    Label(AppTab.bookings.title, systemImage: AppTab.bookings.icon)
                }

            FavouritesView()
                .tag(AppTab.favourites)
                .tabItem {
                    Label(AppTab.favourites.title, systemImage: AppTab.favourites.icon)
                }

            ProfileView()
                .tag(AppTab.profile)
                .tabItem {
                    Label(AppTab.profile.title, systemImage: AppTab.profile.icon)
                }
        }
        .tint(SpotlyColors.accent)
        .onChange(of: appState.selectedTab) { _, _ in
            SpotlyHaptics.selection()
        }
    }
}
