import Foundation
import FirebaseCore

/// Initializes the customer iOS Firebase app from the registered Apple app.
/// A missing generated Info.plist build key must NEVER disable authentication.
/// Use the Firebase Console plist when bundled; if Xcode failed to copy it,
/// use the exact same verified, non-secret client identifiers as a fallback.
@MainActor
enum FirebaseBootstrap {
    static var isReady: Bool {
        guard let options = FirebaseApp.app()?.options else { return false }
        return matchesCustomerApp(options)
    }

    static func configureIfPossible() {
        guard FirebaseApp.app() == nil else { return }

        guard Bundle.main.bundleIdentifier == SpotlyConfiguration.expectedBundleID else {
            diagnose("The app's bundle identifier does not match its Firebase registration.")
            return
        }
        guard SpotlyConfiguration.canConfigureFirebaseNativeSDK else {
            diagnose("The bundled Firebase customer configuration is incomplete.")
            return
        }

        let options: FirebaseOptions
        if let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") {
            guard let bundledOptions = FirebaseOptions(contentsOfFile: path),
                  matchesCustomerApp(bundledOptions) else {
                // A bundled but *incorrect* configuration must fail closed;
                // never silently connect to another Firebase project.
                diagnose("Bundled GoogleService-Info.plist is invalid or targets another app.")
                return
            }
            options = bundledOptions
        } else {
            // Some Xcode project configurations omit the plist from Copy Bundle
            // Resources. Auth/Firestore can still use manual FirebaseOptions.
            // Analytics needs the actual plist and must be checked separately.
            let fallback = FirebaseOptions(
                googleAppID: SpotlyConfiguration.firebaseIOSAppID,
                gcmSenderID: SpotlyConfiguration.firebaseMessagingSenderID
            )
            fallback.apiKey = SpotlyConfiguration.firebaseAPIKey
            fallback.projectID = SpotlyConfiguration.firebaseProjectID
            fallback.bundleID = SpotlyConfiguration.expectedBundleID
            fallback.storageBucket = SpotlyConfiguration.firebaseStorageBucket
            options = fallback
            diagnose("GoogleService-Info.plist is missing from the app bundle; using registered customer Firebase options. Add the plist to the target's resources before shipping.")
        }

        FirebaseApp.configure(options: options)
        if !isReady {
            diagnose("Firebase initialized but its options do not match Spotly's customer app.")
        }
    }

    private static func matchesCustomerApp(_ options: FirebaseOptions) -> Bool {
        options.googleAppID == SpotlyConfiguration.firebaseIOSAppID &&
        options.gcmSenderID == SpotlyConfiguration.firebaseMessagingSenderID &&
        options.projectID == SpotlyConfiguration.firebaseProjectID &&
        options.apiKey == SpotlyConfiguration.firebaseAPIKey &&
        options.bundleID == SpotlyConfiguration.expectedBundleID
    }

    private static func diagnose(_ message: String) {
        #if DEBUG
        print("Spotly Firebase setup: \(message)")
        #endif
    }
}
