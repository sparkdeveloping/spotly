import Foundation
import FirebaseDatabase
import FirebaseFunctions

struct SpotlyPlatformFoundationStatus: Equatable, Sendable {
    let projectID: String
    let functionsRegion: String
    let contractVersion: String
    let contractSHA256: String
    let countryContractVersion: String
    let countryContractSHA256: String
    let capabilities: [String: Bool]
    let serverTimeMs: Double
}

@MainActor
enum FirebasePlatform {
    private static var functionsEmulatorConnected = false
    private static var databaseEmulatorConnected = false

    static let functionsRegion = SpotlyConfiguration.firebaseFunctionsRegion
    static let databaseURL = SpotlyConfiguration.firebaseDatabaseURL

    static func functions() -> Functions {
        FirebaseBootstrap.configureIfPossible()
        let instance = Functions.functions(region: functionsRegion)
        connectEmulatorsIfRequested(functions: instance)
        return instance
    }

    static func realtimeDatabase() -> Database {
        FirebaseBootstrap.configureIfPossible()
        let instance = Database.database(url: databaseURL)
        connectEmulatorsIfRequested(database: instance)
        return instance
    }

    static func foundationStatus() async throws -> SpotlyPlatformFoundationStatus {
        let result = try await functions().httpsCallable("platformFoundation").call()
        guard let envelope = result.data as? [String: Any], envelope["ok"] as? Bool == true,
              let data = envelope["data"] as? [String: Any],
              let projectID = data["projectId"] as? String,
              let region = data["functionsRegion"] as? String,
              let contractVersion = data["contractVersion"] as? String,
              let contractSHA256 = data["contractSHA256"] as? String,
              let countryContractVersion = data["countryContractVersion"] as? String,
              let countryContractSHA256 = data["countryContractSHA256"] as? String else {
            throw NSError(domain: "SpotlyFirebasePlatform", code: 1, userInfo: [NSLocalizedDescriptionKey: "Spotly's Firebase platform returned an invalid foundation response."])
        }
        guard projectID == SpotlyConfiguration.firebaseProjectID,
              region == functionsRegion,
              contractVersion == SpotlyContractMetadata.version,
              contractSHA256 == SpotlyContractMetadata.manifestSHA256,
              countryContractVersion == SpotlyCountryContractMetadata.version,
              countryContractSHA256 == SpotlyCountryContractMetadata.manifestSHA256 else {
            throw NSError(domain: "SpotlyFirebasePlatform", code: 2, userInfo: [NSLocalizedDescriptionKey: "This Spotly build and Firebase platform are not compatible."])
        }
        let rawCapabilities = data["capabilities"] as? [String: Any] ?? [:]
        let capabilities = rawCapabilities.reduce(into: [String: Bool]()) { partial, pair in
            if let value = pair.value as? Bool { partial[pair.key] = value }
        }
        let serverTime = (data["serverTimeMs"] as? NSNumber)?.doubleValue ?? 0
        return SpotlyPlatformFoundationStatus(projectID: projectID, functionsRegion: region, contractVersion: contractVersion, contractSHA256: contractSHA256, countryContractVersion: countryContractVersion, countryContractSHA256: countryContractSHA256, capabilities: capabilities, serverTimeMs: serverTime)
    }

    private static var shouldUseEmulators: Bool {
        ProcessInfo.processInfo.environment["SPOTLY_FIREBASE_USE_EMULATORS"] == "1"
    }

    private static var emulatorHost: String {
        ProcessInfo.processInfo.environment["SPOTLY_FIREBASE_EMULATOR_HOST"] ?? "127.0.0.1"
    }

    private static func connectEmulatorsIfRequested(functions: Functions? = nil, database: Database? = nil) {
        guard shouldUseEmulators else { return }
        // Each SDK component may be obtained independently. Connecting the same
        // component twice is harmlessly avoided by keeping this routing local to
        // the process; production builds never enter this path.
        if let functions, !functionsEmulatorConnected {
            functions.useEmulator(withHost: emulatorHost, port: 5001)
            functionsEmulatorConnected = true
        }
        if let database, !databaseEmulatorConnected {
            database.useEmulator(withHost: emulatorHost, port: 9000)
            databaseEmulatorConnected = true
        }
    }
}
