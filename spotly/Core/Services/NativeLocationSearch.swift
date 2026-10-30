import Foundation
import MapKit

/// Native Apple Maps search for Ride/Send address selection. A search provider
/// still needs network connectivity, but it does not call Spotly's Next.js API.
@MainActor
enum NativeLocationSearch {
    static func search(_ text: String, city: String) async throws -> [GeocodeResult] {
        let clean = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard clean.count >= 3 else { return [] }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = [clean, city, "Zimbabwe"].filter { !$0.isEmpty }.joined(separator: ", ")
        request.resultTypes = [.address, .pointOfInterest]
        let normalized = city.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        switch normalized {
        case "harare":
            request.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -17.8252, longitude: 31.0335), span: MKCoordinateSpan(latitudeDelta: 0.45, longitudeDelta: 0.45))
        case "bulawayo":
            request.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -20.1563, longitude: 28.5886), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        case "mutare":
            request.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -18.9707, longitude: 32.6709), span: MKCoordinateSpan(latitudeDelta: 0.4, longitudeDelta: 0.4))
        default: break
        }
        let results = try await MKLocalSearch(request: request).start()
        var seen = Set<String>()
        return results.mapItems.compactMap { item in
            let place = item.placemark
            guard place.isoCountryCode?.uppercased() == "ZW" else { return nil }
            let lat = place.coordinate.latitude
            let lng = place.coordinate.longitude
            guard lat.isFinite, lng.isFinite, (-22.5 ... -15.5).contains(lat), (25 ... 34).contains(lng) else { return nil }
            let label = place.title ?? item.name ?? clean
            let key = "\(Int((lat * 100000).rounded()))_\(Int((lng * 100000).rounded()))"
            guard seen.insert(key).inserted else { return nil }
            return GeocodeResult(id: key, label: label, lat: lat, lng: lng,
                                 area: place.subLocality, city: place.locality ?? city)
        }.prefix(8).map { $0 }
    }
}
