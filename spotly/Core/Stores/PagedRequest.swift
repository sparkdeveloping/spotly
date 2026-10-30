import Foundation
import Observation

/// Owns one intent and one page request. Generation guards also reject transports that ignore cancellation.
@MainActor
@Observable
final class PagedRequest<Intent: Hashable & Sendable, Page: Sendable> {
    private(set) var intent: Intent?
    private(set) var value: Page?
    private(set) var isLoading = false
    private(set) var error: String?
    private(set) var nextOffset: Int?
    private var generation = UUID()
    private var task: Task<Void, Never>?
    private let fetch: @Sendable (Intent, Int) async throws -> Page
    private let next: (Page) -> Int?
    private let merge: (Page, Page) -> Page

    init(fetch: @escaping @Sendable (Intent, Int) async throws -> Page,
         next: @escaping (Page) -> Int?, merge: @escaping (Page, Page) -> Page) {
        self.fetch = fetch
        self.next = next
        self.merge = merge
    }

    func load(_ intent: Intent, force: Bool = false, preserve: Bool = false, debounce: Duration = .zero) {
        if !force, self.intent == intent, isLoading || value != nil { return }
        task?.cancel()
        generation = UUID()
        self.intent = intent
        if !preserve { value = nil }
        nextOffset = nil
        start(intent, offset: 0, generation: generation, debounce: debounce)
    }

    func loadMore() {
        guard !isLoading, let intent, let nextOffset else { return }
        start(intent, offset: nextOffset, generation: generation, debounce: .zero)
    }

    func wait() async { await task?.value }

    func cancel(clear: Bool = false) {
        task?.cancel()
        generation = UUID()
        isLoading = false
        error = nil
        if clear { intent = nil; value = nil; nextOffset = nil }
    }

    private func start(_ intent: Intent, offset: Int, generation: UUID, debounce: Duration) {
        isLoading = true
        error = nil
        task = Task {
            do {
                if debounce != .zero { try await Task.sleep(for: debounce) }
                let page = try await fetch(intent, offset)
                guard self.generation == generation, !Task.isCancelled else { return }
                value = offset > 0 ? value.map { merge($0, page) } ?? page : page
                let candidate = next(page)
                nextOffset = candidate.flatMap { $0 > offset ? $0 : nil }
            } catch {
                guard self.generation == generation, !Task.isCancelled else { return }
                if !(error is CancellationError) { self.error = error.localizedDescription }
            }
            guard self.generation == generation else { return }
            isLoading = false
        }
    }
}

nonisolated struct SearchIntent: Hashable, Sendable {
    let query: String
    let city: String
    let service: SpotlyServiceKind?
    let type: String?
}

nonisolated struct ServiceIntent: Hashable, Sendable {
    let service: SpotlyServiceKind
    let city: String
    let query: String
    let category: String?
}
