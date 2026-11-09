// GENERATED from Spotly Web contracts/spotly-service-availability.v1.json. Do not edit by hand.
import Foundation

nonisolated enum SpotlyServiceAvailabilityContractMetadata {
    static let version = "1.0.0"
    static let manifestSHA256 = "6647bceeab45a6eca5ee64dcf6bb911c7e139d84caf8c735f30ad19479613d45"
}

nonisolated enum SpotlyServiceAvailabilityState: String, CaseIterable, Codable, Hashable, Sendable {
    case hidden = "hidden"
    case preview = "preview"
    case discover = "discover"
    case live = "live"
    case paused = "paused"
}

nonisolated struct SpotlyServiceAvailabilityCapabilities: Codable, Hashable, Sendable {
    let visible: Bool
    let discoverable: Bool
    let transactable: Bool
    let paused: Bool
}

nonisolated struct SpotlyServiceAvailabilityBootstrap: Codable, Hashable, Sendable {
    let defaultState: SpotlyServiceAvailabilityState
    let countries: [SpotlyCountryCode: SpotlyServiceAvailabilityState]
}

nonisolated struct SpotlyServiceAvailabilityDecision: Codable, Hashable, Sendable, Identifiable {
    var id: String { service.rawValue }
    let service: SpotlyServiceID
    let country: SpotlyCountryCode
    let city: String
    let state: SpotlyServiceAvailabilityState
    let source: String
    let reason: String
    let visible: Bool
    let discoverable: Bool
    let transactable: Bool
    let paused: Bool
}

nonisolated enum SpotlyServiceAvailabilityCatalog {
    static let capabilities: [SpotlyServiceAvailabilityState: SpotlyServiceAvailabilityCapabilities] = [
        .hidden: SpotlyServiceAvailabilityCapabilities(visible: false, discoverable: false, transactable: false, paused: false),
        .preview: SpotlyServiceAvailabilityCapabilities(visible: true, discoverable: false, transactable: false, paused: false),
        .discover: SpotlyServiceAvailabilityCapabilities(visible: true, discoverable: true, transactable: false, paused: false),
        .live: SpotlyServiceAvailabilityCapabilities(visible: true, discoverable: true, transactable: true, paused: false),
        .paused: SpotlyServiceAvailabilityCapabilities(visible: true, discoverable: true, transactable: false, paused: true)
    ]
    static let bootstrap: [SpotlyServiceID: SpotlyServiceAvailabilityBootstrap] = [
        .eat: SpotlyServiceAvailabilityBootstrap(defaultState: .hidden, countries: [.ZW: .live, .MW: .preview]),
        .shop: SpotlyServiceAvailabilityBootstrap(defaultState: .hidden, countries: [.ZW: .live, .MW: .preview]),
        .ride: SpotlyServiceAvailabilityBootstrap(defaultState: .hidden, countries: [.ZW: .discover, .MW: .preview]),
        .book: SpotlyServiceAvailabilityBootstrap(defaultState: .hidden, countries: [.ZW: .live, .MW: .preview]),
        .events: SpotlyServiceAvailabilityBootstrap(defaultState: .hidden, countries: [.ZW: .live, .MW: .preview]),
        .send: SpotlyServiceAvailabilityBootstrap(defaultState: .hidden, countries: [.ZW: .discover, .MW: .hidden])
    ]
    static func bootstrapState(service: SpotlyServiceID, country: SpotlyCountryCode) -> SpotlyServiceAvailabilityState {
        bootstrap[service]?.countries[country] ?? bootstrap[service]?.defaultState ?? .hidden
    }
    static func decision(service: SpotlyServiceID, country: SpotlyCountryCode, city: String = "") -> SpotlyServiceAvailabilityDecision {
        let state = bootstrapState(service: service, country: country)
        let flags = capabilities[state] ?? SpotlyServiceAvailabilityCapabilities(visible: false, discoverable: false, transactable: false, paused: false)
        return SpotlyServiceAvailabilityDecision(service: service, country: country, city: city, state: state, source: "bootstrap", reason: "", visible: flags.visible, discoverable: flags.discoverable, transactable: flags.transactable, paused: flags.paused)
    }
}
