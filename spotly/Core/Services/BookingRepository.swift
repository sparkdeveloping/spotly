import Foundation

// MARK: - Protocol

protocol BookingRepositoryProtocol {
    func fetchBookings(userID: String) async throws -> [SpotlyBooking]
    func createBooking(_ booking: SpotlyBooking) async throws -> SpotlyBooking
    func cancelBooking(id: String) async throws
}

// MARK: - Mock implementation

final class MockBookingRepository: BookingRepositoryProtocol {
    private var localBookings: [SpotlyBooking] = MockBookings.all

    func fetchBookings(userID: String) async throws -> [SpotlyBooking] {
        try await Task.sleep(nanoseconds: 300_000_000)
        return localBookings
    }

    func createBooking(_ booking: SpotlyBooking) async throws -> SpotlyBooking {
        try await Task.sleep(nanoseconds: 500_000_000)
        localBookings.append(booking)
        return booking
    }

    func cancelBooking(id: String) async throws {
        try await Task.sleep(nanoseconds: 300_000_000)
        if let idx = localBookings.firstIndex(where: { $0.id == id }) {
            localBookings[idx].status = .cancelled
        }
    }
}

// MARK: - Firebase placeholder
// TODO: Replace MockBookingRepository with FirebaseBookingRepository once
// Firestore is wired.
