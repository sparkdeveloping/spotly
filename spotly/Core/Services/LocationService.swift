import Foundation
import CoreLocation

// MARK: - Types

enum LocationPermissionState {
    case notDetermined, authorized, denied, restricted
}

protocol LocationServiceProtocol: AnyObject {
    var permissionState: LocationPermissionState { get }
    func requestPermission() async -> LocationPermissionState
}

// MARK: - Real implementation

final class LocationService: NSObject, LocationServiceProtocol, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private(set) var permissionState: LocationPermissionState = .notDetermined
    private var continuation: CheckedContinuation<LocationPermissionState, Never>?

    override init() {
        super.init()
        manager.delegate = self
        syncState()
    }

    func requestPermission() async -> LocationPermissionState {
        syncState()
        guard permissionState == .notDetermined else { return permissionState }
        return await withCheckedContinuation { cont in
            continuation = cont
            manager.requestWhenInUseAuthorization()
        }
    }

    private func syncState() {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways: permissionState = .authorized
        case .denied:                                 permissionState = .denied
        case .restricted:                             permissionState = .restricted
        case .notDetermined:                          permissionState = .notDetermined
        @unknown default:                             permissionState = .notDetermined
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        syncState()
        continuation?.resume(returning: permissionState)
        continuation = nil
    }
}
