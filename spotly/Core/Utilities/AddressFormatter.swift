import Foundation

nonisolated enum AddressFormatter {
    static func joined(_ components: [String?]) -> String {
        var seen = Set<String>()
        return components.compactMap { $0 }.flatMap { $0.components(separatedBy: CharacterSet(charactersIn: "·/")) }
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty && seen.insert($0.folding(options: [.caseInsensitive, .diacriticInsensitive], locale: .current)).inserted }
            .joined(separator: " · ")
    }
}
