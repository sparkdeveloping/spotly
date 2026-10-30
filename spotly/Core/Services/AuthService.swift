import Foundation

@MainActor
protocol AuthServiceProtocol: AnyObject {
    var currentUser: SpotlyUser? { get }
    func signIn(email: String, password: String) async throws -> SpotlyUser
    func createUser(name: String, email: String, password: String) async throws -> SpotlyUser
    func resetPassword(email: String) async throws
    func signOut() throws
    func isAuthenticated() -> Bool
}

@MainActor
final class ProductionAuthService: AuthServiceProtocol {
    private(set) var currentUser: SpotlyUser?

    func signIn(email: String, password: String) async throws -> SpotlyUser {
        let user = try await SessionController.shared.signIn(email: email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(), password: password)
        currentUser = user
        return user
    }

    func createUser(name: String, email: String, password: String) async throws -> SpotlyUser {
        let user = try await SessionController.shared.createAccount(name: name.trimmingCharacters(in: .whitespacesAndNewlines), email: email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(), password: password)
        currentUser = user
        return user
    }

    func resetPassword(email: String) async throws {
        try await SessionController.shared.resetPassword(email: email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased())
    }

    func signOut() throws {
        SessionController.shared.signOut()
        currentUser = nil
    }

    func isAuthenticated() -> Bool { SessionController.shared.isAuthenticated }

    func restore() async -> SpotlyUser? {
        let user = await SessionController.shared.restoreUser()
        currentUser = user
        return user
    }
}
