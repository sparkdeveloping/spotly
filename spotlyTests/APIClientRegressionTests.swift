import Foundation
import Testing
@testable import spotly

private final class ContractURLProtocol: URLProtocol, @unchecked Sendable {
    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    override func startLoading() {
        guard let url = request.url else { return }
        if let code = Int(url.lastPathComponent), code < 0 {
            client?.urlProtocol(self, didFailWithError: URLError(URLError.Code(rawValue: code)))
            return
        }
        let status = Int(url.lastPathComponent) ?? 200
        guard let response = HTTPURLResponse(url: url, statusCode: status, httpVersion: nil, headerFields: nil) else { return }
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: Data((url.lastPathComponent == "decode" ? "not-json" : "{\"ok\":true}").utf8))
        client?.urlProtocolDidFinishLoading(self)
    }
    override func stopLoading() {}
}

@Suite struct APIClientRegressionTests {
    private func client() -> APIClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [ContractURLProtocol.self]
        return APIClient(session: URLSession(configuration: configuration), baseURL: URL(string: "https://test.invalid")!)
    }

    @Test(arguments: [-1009, -1001, -1003, -1004, -1200])
    func sessionTransportClassification(code: Int) async {
        do {
            let _: EmptyResponse = try await client().get("/\(code)")
            Issue.record("Expected transport error")
        } catch let error as SpotlyAPIError {
            #expect(error == SpotlyAPIError.classify(URLError(URLError.Code(rawValue: code))))
        } catch { Issue.record("Unexpected error type: \(type(of: error))") }
    }

    @Test(arguments: [400, 429, 500])
    func httpStatusIsPreserved(status: Int) async {
        do {
            let _: EmptyResponse = try await client().get("/\(status)")
            Issue.record("Expected HTTP failure")
        } catch let error as SpotlyAPIError {
            guard case .server(let actual, _) = error else { Issue.record("Wrong error family"); return }
            #expect(actual == status)
        } catch { Issue.record("Unexpected error type") }
    }

    @Test func invalidContractHasDecodingError() async {
        do {
            let _: EmptyResponse = try await client().get("/decode")
            Issue.record("Expected decode failure")
        } catch let error as SpotlyAPIError {
            guard case .decoding = error else { Issue.record("Wrong error family"); return }
        } catch { Issue.record("Unexpected error type") }
    }

    @Test func successDecodes() async throws {
        let response: EmptyResponse = try await client().get("/200")
        #expect(response.ok == true)
    }
}
