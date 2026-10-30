import Foundation

nonisolated enum SpotlyConfiguration {
    static let apiBaseURL = URL(string: value("SPOTLY_API_BASE_URL") ?? "https://spotlyafrica.com")!
    // Registered customer iOS Firebase identity, verified against the supplied
    // Firebase Console GoogleService-Info.plist. Public client identifiers,
    // NOT privileged service credentials. Never depend on generated Info.plist
    // keys to decide whether users are allowed to sign in.
    static let expectedBundleID = "com.denzeltinashe.spotly"
    static let firebaseAPIKey = "AIzaSyDnKUXM48uEoH59me47E1ekQQ05v9JUoFE"
    static let firebaseProjectID = "spotly-africa"
    static let firestoreDatabaseID = "(default)"
    static let firebaseIOSAppID = "1:14197555543:ios:236ea2214ec0f9d1c3be12"
    static let firebaseMessagingSenderID = "14197555543"
    static let firebaseStorageBucket = "spotly-africa.firebasestorage.app"
    static let supportEmail = "spotlyafrica@gmail.com"
    static let websiteURL = URL(string: "https://spotlyafrica.com")!
    static let privacyURL = URL(string: "https://spotlyafrica.com/privacy")!
    static let termsURL = URL(string: "https://spotlyafrica.com/terms")!

    static var appVersion: String { Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0" }
    static var buildNumber: String { Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1" }

    static var canConfigureFirebaseNativeSDK: Bool {
        firebaseProjectID == "spotly-africa" && !firebaseAPIKey.isEmpty &&
        firebaseIOSAppID.hasPrefix("1:\(firebaseMessagingSenderID):ios:")
    }

    private static func value(_ key: String) -> String? {
        guard let raw = Bundle.main.object(forInfoDictionaryKey: key) as? String else { return nil }
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty || (trimmed.hasPrefix("$(") && trimmed.hasSuffix(")")) { return nil }
        return trimmed
    }
}
