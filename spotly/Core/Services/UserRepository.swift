import Foundation

// MARK: - Protocol

protocol UserRepositoryProtocol {
    func saveProfile(_ user: SpotlyUser) async throws
    func fetchProfile(uid: String) async throws -> SpotlyUser?
    func updateInterests(_ interests: [String], uid: String) async throws
    func updateCity(_ city: String, uid: String) async throws
}

// MARK: - Mock implementation

final class MockUserRepository: UserRepositoryProtocol {
    private var profiles: [String: SpotlyUser] = [:]

    func saveProfile(_ user: SpotlyUser) async throws {
        try await Task.sleep(nanoseconds: 400_000_000)
        profiles[user.id] = user
    }

    func fetchProfile(uid: String) async throws -> SpotlyUser? {
        profiles[uid]
    }

    func updateInterests(_ interests: [String], uid: String) async throws {
        try await Task.sleep(nanoseconds: 200_000_000)
    }

    func updateCity(_ city: String, uid: String) async throws {
        try await Task.sleep(nanoseconds: 200_000_000)
    }
}

// MARK: - Firebase stub
// TODO: FirebaseUserRepository — save to Firestore collection "users/{uid}"
// Fields: name, email, city, interests, createdAt, updatedAt
