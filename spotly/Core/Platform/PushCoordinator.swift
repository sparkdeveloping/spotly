import Foundation
import UIKit
import UserNotifications
#if canImport(FirebaseCore)
import FirebaseCore
#endif
#if canImport(FirebaseMessaging)
import FirebaseMessaging
#endif

@MainActor
final class PushCoordinator: NSObject, UNUserNotificationCenterDelegate {
    static let shared = PushCoordinator()
    private override init() { super.init() }

    weak var appState: AppState?

    func configure(appState: AppState) {
        self.appState = appState
        UNUserNotificationCenter.current().delegate = self
        configureFirebaseIfPossible()
    }

    func registerForRemoteNotificationsIfAuthorized() async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        guard [.authorized, .provisional, .ephemeral].contains(settings.authorizationStatus) else { return }
        UIApplication.shared.registerForRemoteNotifications()
        await registerCurrentTokenForSignedInUser()
    }

    /// Re-associates the current FCM token after session restoration or sign-in.
    /// FCM may not emit a fresh token merely because a customer authenticated,
    /// so relying only on the messaging delegate can leave operational push detached.
    func registerCurrentTokenForSignedInUser() async {
        #if canImport(FirebaseMessaging)
        guard FirebaseBootstrap.isReady, appState?.currentUser != nil else { return }
        do {
            Messaging.messaging().isAutoInitEnabled = true
            let token = try await Messaging.messaging().token()
            await persistFCMToken(token)
        } catch {
            #if DEBUG
            print("Spotly could not obtain the current FCM token: \(error.localizedDescription)")
            #endif
        }
        #endif
    }

    func didRegisterForRemoteNotifications(deviceToken: Data) {
        #if canImport(FirebaseMessaging)
        guard FirebaseBootstrap.isReady else { return }
        Messaging.messaging().apnsToken = deviceToken
        Messaging.messaging().token { token, _ in
            guard let token else { return }
            Task { @MainActor in await self.persistFCMToken(token) }
        }
        #endif
    }

    func didFailToRegisterForRemoteNotifications(_ error: Error) {
        #if DEBUG
        print("Spotly push registration failed: \(error.localizedDescription)")
        #endif
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        [.banner, .sound, .badge, .list]
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let info = response.notification.request.content.userInfo
        if let href = (info["href"] as? String).flatMap(URL.init(string:)), let appState {
            _ = DeepLinkCoordinator.shared.handle(href, appState: appState)
        }
    }

    private func configureFirebaseIfPossible() {
        #if canImport(FirebaseCore) && canImport(FirebaseMessaging)
        guard FirebaseBootstrap.isReady else {
            #if DEBUG
            print("Spotly push is disabled: Firebase has not initialized with the registered customer iOS configuration.")
            #endif
            return
        }
        guard FirebaseApp.app() != nil else { return }
        Messaging.messaging().delegate = FirebaseMessagingBridge.shared
        FirebaseMessagingBridge.shared.onToken = { [weak self] token in
            guard let self else { return }
            Task { @MainActor in await self.persistFCMToken(token) }
        }
        #endif
    }

    private func persistFCMToken(_ token: String) async {
        guard let appState, let user = appState.currentUser else { return }
        do {
            guard let authToken = try await SessionController.shared.validIDToken() else { return }
            try await FirestoreREST.shared.setPushToken(uid: user.id, token: token, active: true, idToken: authToken)
        } catch {
            #if DEBUG
            print("Spotly could not store push token: \(error.localizedDescription)")
            #endif
        }
    }

    /// Immediately revoke this device's FCM token after a local sign-out.
    /// A server-side cleanup of stale pushTokens documents is still required.
    func invalidateLocalFCMTokenAfterSignOut() async {
        #if canImport(FirebaseMessaging)
        guard FirebaseApp.app() != nil else { return }
        Messaging.messaging().isAutoInitEnabled = false
        do {
            try await Messaging.messaging().deleteToken()
        } catch {
            #if DEBUG
            print("Spotly could not revoke the local FCM token: \(error.localizedDescription)")
            #endif
        }
        #endif
    }

    func deactivateCurrentToken() async {
        #if canImport(FirebaseMessaging)
        guard FirebaseBootstrap.isReady, let token = try? await Messaging.messaging().token(), let appState, let user = appState.currentUser,
              let authToken = try? await SessionController.shared.validIDToken() else { return }
        try? await FirestoreREST.shared.setPushToken(uid: user.id, token: token, active: false, idToken: authToken)
        #endif
    }
}

#if canImport(FirebaseMessaging)
private final class FirebaseMessagingBridge: NSObject, MessagingDelegate {
    static let shared = FirebaseMessagingBridge()
    var onToken: ((String) -> Void)?
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let fcmToken { onToken?(fcmToken) }
    }
}
#endif

final class SpotlyAppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Task { @MainActor in PushCoordinator.shared.didRegisterForRemoteNotifications(deviceToken: deviceToken) }
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        Task { @MainActor in PushCoordinator.shared.didFailToRegisterForRemoteNotifications(error) }
    }
}
