import Foundation
import MapKit

/// Country-aware native Apple Maps search for Ride/Send address selection.
@MainActor
enum NativeLocationSearch {
    static func search(_ text: String, city: String, country countryCode: SpotlyCountryCode) async throws -> [GeocodeResult] {
        let clean = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard clean.count >= 3 else { return [] }
        let country = SpotlyCountryCatalog.definition(for: countryCode)
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = [clean, city, country.name].filter { !$0.isEmpty }.joined(separator: ", ")
        request.resultTypes = [.address, .pointOfInterest]
        let center = SpotlyCountryEngine.city(named: city, in: countryCode).map { CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.lng) }
            ?? CLLocationCoordinate2D(latitude: country.mapCenter.lat, longitude: country.mapCenter.lng)
        request.region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.6, longitudeDelta: 0.6))
        let results = try await MKLocalSearch(request: request).start()
        var seen = Set<String>()
        return results.mapItems.compactMap { item in
            let place = item.placemark
            guard place.isoCountryCode?.uppercased() == countryCode.rawValue else { return nil }
            let lat = place.coordinate.latitude, lng = place.coordinate.longitude
            guard lat.isFinite, lng.isFinite, lat >= country.bounds.minLat, lat <= country.bounds.maxLat, lng >= country.bounds.minLng, lng <= country.bounds.maxLng else { return nil }
            let label = place.title ?? item.name ?? clean
            let key = "\(Int((lat * 100000).rounded()))_\(Int((lng * 100000).rounded()))"
            guard seen.insert(key).inserted else { return nil }
            return GeocodeResult(id: key, label: label, lat: lat, lng: lng, area: place.subLocality, city: place.locality ?? city, country: countryCode)
        }.prefix(8).map { $0 }
    }
}
