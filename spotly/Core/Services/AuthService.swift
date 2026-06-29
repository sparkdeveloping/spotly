import Foundation

// MARK: - Protocol

protocol AuthServiceProtocol {
    var currentUser: SpotlyUser? { get }
    func signIn(email: String, password: String) async throws -> SpotlyUser
    func createUser(name: String, email: String, password: String) async throws -> SpotlyUser
    func resetPassword(email: String) async throws
    func signOut() throws
    func isAuthenticated() -> Bool
}

// MARK: - Mock implementation (active for team testing)

final class MockAuthService: AuthServiceProtocol {
    var currentUser: SpotlyUser? = nil

    func signIn(email: String, password: String) async throws -> SpotlyUser {
        try await Task.sleep(nanoseconds: 900_000_000)
        // Simulate a valid sign-in
        let user = SpotlyUser(
            id: "mock_\(email.prefix(8))",
            name: "Tinashe Moyo",
            firstName: "Tinashe",
            email: email,
            phone: "+263 77 123 4567",
            avatarURL: nil,
            location: "Harare",
            isVerified: true,
            createdAt: Date(),
            favouriteIDs: []
        )
        currentUser = user
        return user
    }

    func createUser(name: String, email: String, password: String) async throws -> SpotlyUser {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        let firstName = name.components(separatedBy: " ").first ?? name
        let user = SpotlyUser(
            id: "new_\(UUID().uuidString.prefix(8))",
            name: name,
            firstName: firstName,
            email: email,
            phone: "",
            avatarURL: nil,
            location: "Harare",
            isVerified: false,
            createdAt: Date(),
            favouriteIDs: []
        )
        currentUser = user
        return user
    }

    func resetPassword(email: String) async throws {
        try await Task.sleep(nanoseconds: 800_000_000)
        // Simulated success — no actual email sent in mock
    }

    func signOut() throws {
        currentUser = nil
    }

    func isAuthenticated() -> Bool { currentUser != nil }
}

// MARK: - Firebase stub (ready to activate — requires FirebaseAuth + GoogleService-Info.plist)
// To enable: uncomment this class, add `import FirebaseAuth` at top,
// call FirebaseApp.configure() in spotlyApp.init(), and swap MockAuthService → FirebaseAuthService in AppState.

/*
import FirebaseAuth

final class FirebaseAuthService: AuthServiceProtocol {
    var currentUser: SpotlyUser? {
        guard let fbUser = Auth.auth().currentUser else { return nil }
        return SpotlyUser(id: fbUser.uid, name: fbUser.displayName ?? "", firstName: ..., ...)
    }

    func signIn(email: String, password: String) async throws -> SpotlyUser {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        // Map result.user → SpotlyUser
    }

    func createUser(name: String, email: String, password: String) async throws -> SpotlyUser {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        let changeReq = result.user.createProfileChangeRequest()
        changeReq.displayName = name
        try await changeReq.commitChanges()
        // Map → SpotlyUser
    }

    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }

    func signOut() throws { try Auth.auth().signOut() }
    func isAuthenticated() -> Bool { Auth.auth().currentUser != nil }
}
*/
