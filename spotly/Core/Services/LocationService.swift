import Foundation
import CoreLocation

enum LocationPermissionState: Equatable {
    case notDetermined, authorized, denied, restricted
}

struct SpotlyLocationSnapshot: Equatable {
    let coordinate: CLLocationCoordinate2D
    let horizontalAccuracy: CLLocationAccuracy
    let capturedAt: Date

    static func == (lhs: SpotlyLocationSnapshot, rhs: SpotlyLocationSnapshot) -> Bool {
        lhs.coordinate.latitude == rhs.coordinate.latitude &&
        lhs.coordinate.longitude == rhs.coordinate.longitude &&
        lhs.horizontalAccuracy == rhs.horizontalAccuracy &&
        lhs.capturedAt == rhs.capturedAt
    }

    func ridePoint(country: SpotlyCountryCode) -> RidePoint {
        RidePoint(lat: coordinate.latitude, lng: coordinate.longitude, accuracy: horizontalAccuracy, country: country)
    }
}

@MainActor
protocol LocationServiceProtocol: AnyObject {
    var permissionState: LocationPermissionState { get }
    var isPreciseLocationEnabled: Bool { get }
    func requestPermission() async -> LocationPermissionState
    func currentLocation() async throws -> SpotlyLocationSnapshot
}

enum SpotlyLocationError: LocalizedError {
    case permissionDenied
    case unavailable
    case timedOut

    var errorDescription: String? {
        switch self {
        case .permissionDenied: return "Location access is off. Choose a city or enable location in Settings."
        case .unavailable: return "Spotly could not determine your location."
        case .timedOut: return "Location took too long. Try again or choose a city manually."
        }
    }
}

@MainActor
final class LocationService: NSObject, LocationServiceProtocol, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private(set) var permissionState: LocationPermissionState = .notDetermined
    private var permissionContinuation: CheckedContinuation<LocationPermissionState, Never>?
    private var locationContinuation: CheckedContinuation<SpotlyLocationSnapshot, Error>?
    private var timeoutTask: Task<Void, Never>?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        syncState()
    }

    var isPreciseLocationEnabled: Bool {
        if #available(iOS 14.0, *) { return manager.accuracyAuthorization == .fullAccuracy }
        return true
    }

    func requestPermission() async -> LocationPermissionState {
        syncState()
        guard permissionState == .notDetermined else { return permissionState }
        return await withCheckedContinuation { continuation in
            permissionContinuation = continuation
            manager.requestWhenInUseAuthorization()
        }
    }

    func currentLocation() async throws -> SpotlyLocationSnapshot {
        syncState()
        if permissionState == .notDetermined {
            let state = await requestPermission()
            guard state == .authorized else { throw SpotlyLocationError.permissionDenied }
        }
        guard permissionState == .authorized else { throw SpotlyLocationError.permissionDenied }

        if let cached = manager.location, cached.horizontalAccuracy >= 0, abs(cached.timestamp.timeIntervalSinceNow) < 90 {
            return SpotlyLocationSnapshot(coordinate: cached.coordinate, horizontalAccuracy: cached.horizontalAccuracy, capturedAt: cached.timestamp)
        }

        return try await withCheckedThrowingContinuation { continuation in
            locationContinuation?.resume(throwing: CancellationError())
            locationContinuation = continuation
            manager.requestLocation()
            timeoutTask?.cancel()
            timeoutTask = Task { [weak self] in
                try? await Task.sleep(for: .seconds(12))
                guard !Task.isCancelled else { return }
                await MainActor.run {
                    guard let self, let pending = self.locationContinuation else { return }
                    self.locationContinuation = nil
                    pending.resume(throwing: SpotlyLocationError.timedOut)
                }
            }
        }
    }

    private func syncState() {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways: permissionState = .authorized
        case .denied: permissionState = .denied
        case .restricted: permissionState = .restricted
        case .notDetermined: permissionState = .notDetermined
        @unknown default: permissionState = .notDetermined
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        syncState()
        permissionContinuation?.resume(returning: permissionState)
        permissionContinuation = nil
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last(where: { $0.horizontalAccuracy >= 0 }) else {
            finishLocation(.failure(SpotlyLocationError.unavailable))
            return
        }
        finishLocation(.success(SpotlyLocationSnapshot(coordinate: location.coordinate, horizontalAccuracy: location.horizontalAccuracy, capturedAt: location.timestamp)))
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let clError = error as? CLError, clError.code == .denied {
            finishLocation(.failure(SpotlyLocationError.permissionDenied))
        } else {
            finishLocation(.failure(SpotlyLocationError.unavailable))
        }
    }

    private func finishLocation(_ result: Result<SpotlyLocationSnapshot, Error>) {
        timeoutTask?.cancel()
        timeoutTask = nil
        guard let continuation = locationContinuation else { return }
        locationContinuation = nil
        switch result {
        case .success(let value): continuation.resume(returning: value)
        case .failure(let error): continuation.resume(throwing: error)
        }
    }
}
