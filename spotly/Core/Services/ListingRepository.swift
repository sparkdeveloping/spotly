import Foundation

// MARK: - Protocol

protocol ListingRepositoryProtocol {
    func fetchBusinesses() async throws -> [SpotlyBusiness]
    func fetchBusiness(id: String) async throws -> SpotlyBusiness?
    func fetchBusinessesByCategory(_ categoryID: String) async throws -> [SpotlyBusiness]
    func fetchEvents() async throws -> [SpotlyEvent]
    func searchBusinesses(query: String) async throws -> [SpotlyBusiness]
}

// MARK: - Mock implementation

final class MockListingRepository: ListingRepositoryProtocol {
    func fetchBusinesses() async throws -> [SpotlyBusiness] {
        try await Task.sleep(nanoseconds: 300_000_000)
        return MockBusinesses.all
    }

    func fetchBusiness(id: String) async throws -> SpotlyBusiness? {
        MockBusinesses.all.first { $0.id == id }
    }

    func fetchBusinessesByCategory(_ categoryID: String) async throws -> [SpotlyBusiness] {
        try await Task.sleep(nanoseconds: 200_000_000)
        return MockBusinesses.byCategory(categoryID)
    }

    func fetchEvents() async throws -> [SpotlyEvent] {
        try await Task.sleep(nanoseconds: 300_000_000)
        return MockEvents.all
    }

    func searchBusinesses(query: String) async throws -> [SpotlyBusiness] {
        try await Task.sleep(nanoseconds: 400_000_000)
        let q = query.lowercased()
        return MockBusinesses.all.filter { business in
            business.name.lowercased().contains(q) ||
            business.tagline.lowercased().contains(q) ||
            business.description.lowercased().contains(q) ||
            business.categoryName.lowercased().contains(q) ||
            business.tags.contains { $0.lowercased().contains(q) } ||
            business.services.contains { service in
                service.name.lowercased().contains(q) ||
                service.description.lowercased().contains(q) ||
                (service.category?.lowercased().contains(q) ?? false)
            }
        }
    }
}

// MARK: - Firebase placeholder
// TODO: Replace MockListingRepository with FirebaseListingRepository once
// Firestore is wired. Protocol is ready — just swap the implementation in AppState.

/*
final class FirebaseListingRepository: ListingRepositoryProtocol {
    func fetchBusinesses() async throws -> [SpotlyBusiness] {
        // Firestore implementation here
        fatalError("Not yet implemented")
    }
    ...
}
*/
