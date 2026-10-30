import Foundation
import UIKit
import ImageIO
import Observation

nonisolated enum RemoteMedia {
    static func url(_ value: String?) -> URL? {
        guard let value = value?.trimmingCharacters(in: .whitespacesAndNewlines),
              !value.isEmpty, let url = URL(string: value),
              ["https", "http"].contains(url.scheme?.lowercased() ?? ""), url.host != nil else { return nil }
        return url
    }
}

actor RemoteImageLoader {
    static let shared = RemoteImageLoader()
    private let cache = NSCache<NSString, UIImage>()
    private let session: URLSession
    private struct Flight {
        let task: Task<UIImage, Error>
        var consumers: Set<UUID>
    }
    private var flights: [String: Flight] = [:]

    init(session: URLSession? = nil) {
        let config = URLSessionConfiguration.default
        config.urlCache = URLCache(memoryCapacity: 16 * 1024 * 1024, diskCapacity: 150 * 1024 * 1024, diskPath: "spotly-media")
        config.timeoutIntervalForRequest = 20
        config.timeoutIntervalForResource = 40
        self.session = session ?? URLSession(configuration: config)
        cache.totalCostLimit = 48 * 1024 * 1024
        cache.countLimit = 160
    }

    func image(for url: URL, targetPixels: Int = 640) async throws -> UIImage {
        let pixels = min(2048, max(128, ((targetPixels + 127) / 128) * 128))
        let key = "\(url.absoluteString)#\(pixels)"
        if let image = cache.object(forKey: key as NSString) { return image }
        let consumer = UUID()
        if flights[key] != nil {
            flights[key]?.consumers.insert(consumer)
        } else {
            let session = session
            let task = Task<UIImage, Error> {
                let (data, response) = try await session.data(for: URLRequest(url: url, cachePolicy: .useProtocolCachePolicy))
                try Task.checkCancellation()
                guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode),
                      data.count <= 25 * 1024 * 1024 else { throw URLError(.badServerResponse) }
                return try await Task.detached(priority: .utility) {
                    guard let source = CGImageSourceCreateWithData(data as CFData, [kCGImageSourceShouldCache: false] as CFDictionary),
                          let image = CGImageSourceCreateThumbnailAtIndex(source, 0, [
                            kCGImageSourceCreateThumbnailFromImageAlways: true,
                            kCGImageSourceCreateThumbnailWithTransform: true,
                            kCGImageSourceShouldCacheImmediately: true,
                            kCGImageSourceThumbnailMaxPixelSize: pixels
                          ] as CFDictionary) else { throw URLError(.cannotDecodeContentData) }
                    return UIImage(cgImage: image)
                }.value
            }
            flights[key] = Flight(task: task, consumers: [consumer])
        }
        guard let task = flights[key]?.task else { throw CancellationError() }
        return try await withTaskCancellationHandler {
            defer { release(key, consumer: consumer) }
            let image = try await task.value
            try Task.checkCancellation()
            cache.setObject(image, forKey: key as NSString, cost: (image.cgImage?.bytesPerRow ?? 0) * (image.cgImage?.height ?? 0))
            return image
        } onCancel: {
            Task { await self.release(key, consumer: consumer) }
        }
    }

    private func release(_ key: String, consumer: UUID) {
        guard flights[key]?.consumers.remove(consumer) != nil else { return }
        if flights[key]?.consumers.isEmpty == true {
            flights.removeValue(forKey: key)?.task.cancel()
        }
    }

    func clearMemoryCache() { cache.removeAllObjects() }
}

@MainActor
@Observable
final class SpotlyImageFetcher {
    enum Phase { case fallback, loading, success(UIImage), failure }
    private(set) var phase: Phase = .fallback
    private var generation = UUID()

    func load(url: URL?, targetPixels: Int, loader: RemoteImageLoader = .shared) async {
        let request = UUID()
        generation = request
        guard let url = RemoteMedia.url(url?.absoluteString) else { phase = .fallback; return }
        phase = .loading
        do {
            let image = try await loader.image(for: url, targetPixels: targetPixels)
            guard generation == request, !Task.isCancelled else { return }
            phase = .success(image)
        } catch {
            guard generation == request, !Task.isCancelled else { return }
            phase = .failure
        }
    }
}
