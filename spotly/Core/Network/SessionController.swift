import Foundation
import FirebaseAuth
import FirebaseCore

/// Customer identity belongs to the Firebase iOS SDK. The SDK persists and
/// refreshes tokens; Spotly no longer keeps refresh tokens in its own Keychain.
@MainActor
final class SessionController {
    static let shared = SessionController()
    private let retiredSessionKey = "spotly.firebase.session.v2"
    private init() { KeychainStore.delete(retiredSessionKey) }

    var isAuthenticated: Bool { FirebaseBootstrap.isReady && Auth.auth().currentUser != nil }

    /// A returning customer must not sit on a splash screen waiting for a
    /// network call. Firebase Auth keeps the signed-in identity on the device;
    /// account-scoped data and an authoritative profile refresh follow separately.
    func restoreUser() async -> SpotlyUser? {
        guard FirebaseApp.app() != nil, let user = Auth.auth().currentUser else { return nil }
        return mapUser(user)
    }

    /// Optional background refresh. Never return a previous account's data
    /// if the user signs out or changes identity while Firebase is responding.
    func refreshRestoredProfile(for uid: String) async -> SpotlyUser? {
        guard FirebaseApp.app() != nil, let user = Auth.auth().currentUser,
              user.uid == uid else { return nil }
        try? await user.reload()
        guard !Task.isCancelled, Auth.auth().currentUser?.uid == uid else { return nil }
        let fallback = mapUser(user)
        guard let token = try? await idToken(for: user), !Task.isCancelled,
              Auth.auth().currentUser?.uid == uid else { return fallback }
        guard var profile = try? await FirestoreREST.shared.ensureUserProfile(
            uid: uid, email: user.email ?? "", displayName: user.displayName ?? "", idToken: token
        ), !Task.isCancelled, Auth.auth().currentUser?.uid == uid else { return fallback }
        profile.isVerified = user.isEmailVerified
        return profile
    }

    func signIn(email: String, password: String) async throws -> SpotlyUser {
        try requireConfigured()
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        KeychainStore.delete(retiredSessionKey)
        return await loadProfile(for: result.user)
    }

    func createAccount(name: String, email: String, password: String) async throws -> SpotlyUser {
        try requireConfigured()
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        KeychainStore.delete(retiredSessionKey)
        let change = result.user.createProfileChangeRequest()
        change.displayName = name
        try await change.commitChanges()
        let profile = await loadProfile(for: result.user, name: name)
        // The account already exists at this point. A temporary email delivery
        // failure must not be misreported as failed account creation, causing
        // the customer to retry and hit an 'email already in use' error.
        do { try await sendVerificationEmail(for: result.user) }
        catch {
            #if DEBUG
            print("Verification email could not be sent; customer can retry in Profile.")
            #endif
        }
        return profile
    }

    func resetPassword(email: String) async throws {
        try requireConfigured()
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }

    func sendVerificationEmail(token _: String? = nil) async throws {
        try requireConfigured()
        guard let user = Auth.auth().currentUser else { throw SpotlyAPIError.unauthenticated }
        try await sendVerificationEmail(for: user)
    }

    func reloadEmailVerificationStatus() async throws -> Bool {
        try requireConfigured()
        guard let user = Auth.auth().currentUser else { throw SpotlyAPIError.unauthenticated }
        try await user.reload()
        return user.isEmailVerified
    }

    func validIDToken() async throws -> String? {
        guard FirebaseApp.app() != nil, let user = Auth.auth().currentUser else { return nil }
        return try await idToken(for: user)
    }

    func signOut() {
        if FirebaseApp.app() != nil { try? Auth.auth().signOut() }
        KeychainStore.delete(retiredSessionKey)
    }

    private func loadProfile(for user: User, name: String? = nil) async -> SpotlyUser {
        let fallback = mapUser(user, name: name)
        guard let token = try? await idToken(for: user),
              var profile = try? await FirestoreREST.shared.ensureUserProfile(
                uid: user.uid, email: user.email ?? "", displayName: name ?? user.displayName ?? "", idToken: token
              ) else { return fallback }
        profile.isVerified = user.isEmailVerified
        return profile
    }

    private func mapUser(_ user: User, name: String? = nil) -> SpotlyUser {
        let display = (name ?? user.displayName ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let resolved = display.isEmpty ? (user.email?.split(separator: "@").first.map(String.init) ?? "Spotly user") : display
        return SpotlyUser(id: user.uid, name: resolved,
                          firstName: resolved.split(separator: " ").first.map(String.init) ?? resolved,
                          email: user.email ?? "", phone: user.phoneNumber ?? "",
                          avatarURL: user.photoURL?.absoluteString, location: "",
                          isVerified: user.isEmailVerified, createdAt: user.metadata.creationDate ?? Date(),
                          favouriteIDs: [])
    }

    // Bridge the SDK callbacks on MainActor so its non-Sendable User stays
    // actor-isolated while only token values and errors cross the suspension.
    private func idToken(for user: User) async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            user.getIDToken { token, error in
                if let error {
                    continuation.resume(throwing: error)
                } else if let token {
                    continuation.resume(returning: token)
                } else {
                    continuation.resume(throwing: SpotlyAPIError.unauthenticated)
                }
            }
        }
    }

    private func sendVerificationEmail(for user: User) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            user.sendEmailVerification(completion: { error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            })
        }
    }

    private func requireConfigured() throws {
        guard FirebaseBootstrap.isReady else {
            throw SpotlyAPIError.firebaseUnconfigured
        }
    }
}
