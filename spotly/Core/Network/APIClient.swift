import Foundation
import OSLog

nonisolated enum SpotlyAPIError: LocalizedError, Equatable {
    case offline, timeout, hostLookup, connection, security, cancelled
    case invalidURL
    case unauthenticated
    case firebaseUnconfigured
    case server(status: Int, message: String)
    case decoding(String)
    case transport(String)

    static func classify(_ error: URLError) -> SpotlyAPIError {
        switch error.code {
        case .cancelled: return .cancelled
        case .notConnectedToInternet: return .offline
        case .timedOut: return .timeout
        case .cannotFindHost, .dnsLookupFailed: return .hostLookup
        case .cannotConnectToHost, .networkConnectionLost: return .connection
        case .secureConnectionFailed, .serverCertificateHasBadDate, .serverCertificateUntrusted,
             .serverCertificateHasUnknownRoot, .serverCertificateNotYetValid, .clientCertificateRejected,
             .clientCertificateRequired, .appTransportSecurityRequiresSecureConnection: return .security
        default: return .transport(String(error.code.rawValue))
        }
    }

    /// After a mutating request fails this way, the server may already have
    /// committed the operation. Do not offer a blind second booking/ride request.
    var mayHaveCommittedWrite: Bool {
        switch self {
        case .timeout, .connection, .decoding, .transport: return true
        case .server(let status, _): return status >= 500
        default: return false
        }
    }

    var errorDescription: String? {
        switch self {
        case .offline: return "You're offline. Reconnect to continue."
        case .timeout: return "Spotly is taking longer than expected. Try again."
        case .hostLookup: return "Spotly’s server address could not be resolved. Try again shortly."
        case .connection: return "Spotly’s server could not be reached. Try again shortly."
        case .security: return "A secure connection to Spotly could not be established. Try again later."
        case .cancelled: return nil
        case .invalidURL: return "Spotly could not create that request."
        case .unauthenticated: return "Sign in to continue."
        case .firebaseUnconfigured: return "Spotly could not initialize Firebase. Rebuild the app with the registered Spotly iOS Firebase configuration."
        case .server(let status, let message):
            if status == 429 { return "Too many requests. Please wait a moment and try again." }
            if status >= 500 { return "Spotly is temporarily unavailable. Try again shortly." }
            return message
        case .decoding: return "Spotly received an unexpected response. Try again."
        case .transport: return "Spotly could not complete the request. Try again."

        }
    }
}

nonisolated struct SpotlyErrorEnvelope: Decodable {
    let ok: Bool?
    let error: String?
    let message: String?
}

struct EmptyResponse: Decodable { let ok: Bool? }

actor APIClient {
    static let shared = APIClient()

    private let baseURL: URL
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    init(session: URLSession = .shared, baseURL: URL = SpotlyConfiguration.apiBaseURL) {
        self.baseURL = baseURL
        self.session = session
        self.decoder = JSONDecoder()
        self.encoder = JSONEncoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            if let seconds = try? container.decode(Double.self) { return Date(timeIntervalSince1970: seconds) }
            let value = try container.decode(String.self)
            if let date = ISO8601DateFormatter.spotly.date(from: value) ?? ISO8601DateFormatter().date(from: value) { return date }
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unsupported date format")
        }
        encoder.dateEncodingStrategy = .iso8601
    }

    func get<Response: Decodable>(
        _ path: String,
        query: [URLQueryItem] = [],
        authenticated: Bool = false
    ) async throws -> Response {
        try await request(path, method: "GET", query: query, body: Optional<Data>.none, authenticated: authenticated)
    }

    func post<Body: Encodable, Response: Decodable>(
        _ path: String,
        body: Body,
        authenticated: Bool = false
    ) async throws -> Response {
        let data = try encoder.encode(body)
        return try await request(path, method: "POST", query: [], body: data, authenticated: authenticated)
    }

    func delete<Response: Decodable>(_ path: String, authenticated: Bool = false) async throws -> Response {
        try await request(path, method: "DELETE", query: [], body: Optional<Data>.none, authenticated: authenticated)
    }

    func raw(
        url: URL,
        method: String,
        json: Data? = nil,
        bearerToken: String? = nil,
        headers: [String: String] = [:]
    ) async throws -> Data {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.timeoutInterval = 30
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if json != nil { request.setValue("application/json", forHTTPHeaderField: "Content-Type") }
        if let bearerToken { request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization") }
        headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        request.httpBody = json
        return try await perform(request)
    }

    private func request<Response: Decodable>(
        _ path: String,
        method: String,
        query: [URLQueryItem],
        body: Data?,
        authenticated: Bool
    ) async throws -> Response {
        let cleanPath = path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let endpoint = baseURL.appendingPathComponent(cleanPath)
        guard var components = URLComponents(url: endpoint, resolvingAgainstBaseURL: false) else {
            throw SpotlyAPIError.invalidURL
        }
        if !query.isEmpty { components.queryItems = query }
        guard let url = components.url else { throw SpotlyAPIError.invalidURL }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.timeoutInterval = 30
        request.cachePolicy = authenticated || method != "GET" ? .reloadIgnoringLocalCacheData : .useProtocolCachePolicy
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Spotly-iOS/\(SpotlyConfiguration.appVersion) (\(SpotlyConfiguration.buildNumber))", forHTTPHeaderField: "User-Agent")
        if let body {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        if authenticated {
            guard let token = try await SessionController.shared.validIDToken() else { throw SpotlyAPIError.unauthenticated }
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let data = try await perform(request)
        do { return try decoder.decode(Response.self, from: data) }
        catch {
            diagnose(request, started: Date(), detail: "decoding \(Self.decodingKind(error))")
            throw SpotlyAPIError.decoding(Self.decodingKind(error))
        }
    }

    private func perform(_ request: URLRequest) async throws -> Data {
        let started = Date()
        do {
            try Task.checkCancellation()
            let (data, response) = try await session.data(for: request)
            guard let http = response as? HTTPURLResponse else { throw SpotlyAPIError.transport("No HTTP response") }
            diagnose(request, started: started, detail: "HTTP \(http.statusCode)", correlation: http.value(forHTTPHeaderField: "X-Request-ID") ?? http.value(forHTTPHeaderField: "X-Correlation-ID"))
            try Task.checkCancellation()
            guard 200..<300 ~= http.statusCode else {
                let envelope = try? decoder.decode(SpotlyErrorEnvelope.self, from: data)
                let fallback = HTTPURLResponse.localizedString(forStatusCode: http.statusCode)
                throw SpotlyAPIError.server(status: http.statusCode, message: envelope?.error ?? envelope?.message ?? fallback.capitalized)
            }
            return data
        } catch let error as SpotlyAPIError {
            throw error
        } catch is CancellationError {
            throw CancellationError()
        } catch let error as URLError {
            diagnose(request, started: started, detail: "URLError \(error.code.rawValue)")
            if error.code == .cancelled { throw CancellationError() }
            throw SpotlyAPIError.classify(error)
        } catch {
            diagnose(request, started: started, detail: "transport failure")
            throw SpotlyAPIError.transport("unknown")
        }
    }
    private static func decodingKind(_ error: Error) -> String {
        switch error {
        case DecodingError.keyNotFound: return "missing key"
        case DecodingError.typeMismatch: return "type mismatch"
        case DecodingError.valueNotFound: return "missing value"
        default: return "invalid data"
        }
    }

    private func diagnose(_ request: URLRequest, started: Date, detail: String, correlation: String? = nil) {
        #if DEBUG
        // Only static API route segments are retained. No query, payload, headers or entity IDs.
        let known = Set(["api", "public", "customer", "search", "service-feed", "marketplace", "business", "businesses", "activity", "saved", "orders", "status", "create", "rides", "parcels", "quote", "payments", "paynow", "initiate", "support", "conversations"])
        let path = request.url?.path.split(separator: "/").map { known.contains(String($0)) ? String($0) : "_" }.joined(separator: "/") ?? ""
        let host = request.url?.host ?? "unknown"
        let identifier = correlation.map { String($0.filter { $0.isLetter || $0.isNumber || $0 == "-" }.prefix(80)) } ?? "none"
        Logger(subsystem: "com.spotly.customer", category: "network").debug("\(request.httpMethod ?? "GET", privacy: .public) \(host, privacy: .public)/\(path, privacy: .public) \(detail, privacy: .public) elapsed=\(Date().timeIntervalSince(started)) request=\(identifier, privacy: .public)")
        #endif
    }

}

extension ISO8601DateFormatter {
    nonisolated static var spotly: ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }
}
