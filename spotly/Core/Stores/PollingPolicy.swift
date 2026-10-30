import Foundation

nonisolated enum PollingPolicy {
    static func isTerminal(_ state: String) -> Bool {
        ["completed", "delivered", "cancelled", "failed", "refunded", "returned", "checked_out", "expired", "rejected"].contains(state.lowercased())
    }
    static func delay(failures: Int) -> Duration {
        .seconds(min(60, 8 * (1 << min(max(0, failures), 3))))
    }
}
