import SwiftUI

@main
struct spotlyApp: App {
    @UIApplicationDelegateAdaptor(SpotlyAppDelegate.self) private var appDelegate
    @State private var appState = AppState()

    init() {
        FirebaseBootstrap.configureIfPossible()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(appState)
                .preferredColorScheme(appState.preferredColorScheme)
                .task {
                    for await _ in NotificationCenter.default.notifications(named: UIApplication.didReceiveMemoryWarningNotification) {
                        await RemoteImageLoader.shared.clearMemoryCache()
                    }
                }
                .onOpenURL { url in
                    _ = DeepLinkCoordinator.shared.handle(url, appState: appState)
                }
                .task {
                    PushCoordinator.shared.configure(appState: appState)
                    await PushCoordinator.shared.registerForRemoteNotificationsIfAuthorized()
                }
        }
    }
}
