import Foundation

struct SpotlyCommandResult {
    let title: String
    let summary: String
    let businesses: [SpotlyBusiness]
    let events: [SpotlyEvent]
    let suggestedCategory: SpotlyCategory?
}

protocol SpotlyCommandServiceProtocol {
    func plan(for query: String, context: [String], city: String) async -> SpotlyCommandResult
}

final class MockSpotlyCommandService: SpotlyCommandServiceProtocol {
    func plan(for query: String, context: [String], city: String) async -> SpotlyCommandResult {
        try? await Task.sleep(nanoseconds: 380_000_000)

        let text = ([query] + context).joined(separator: " ").lowercased()
        var businesses = MockBusinesses.all
        var events: [SpotlyEvent] = []
        var categoryID: String?

        if contains(text, ["dinner", "restaurant", "table", "date", "food", "lunch"]) {
            categoryID = "restaurants"
        } else if contains(text, ["padel", "court", "sport", "activity", "after work"]) {
            categoryID = "padel"
        } else if contains(text, ["spa", "massage", "beauty", "salon", "hair", "nails", "wellness"]) {
            categoryID = contains(text, ["salon", "hair", "nails", "beauty"]) ? "beauty" : "wellnessSpa"
        } else if contains(text, ["event", "concert", "friday", "weekend", "what's on", "happening"]) {
            categoryID = "events"
            events = MockEvents.all
        } else if contains(text, ["coffee", "cafe", "brunch", "meeting"]) {
            categoryID = "cafes"
        } else if contains(text, ["grocery", "groceries", "essentials"]) {
            categoryID = "groceries"
        } else if contains(text, ["night", "tonight", "drinks", "lounge"]) {
            categoryID = "nightlife"
            events = MockEvents.all.filter { $0.categoryID == "events" }
        }

        if let categoryID {
            businesses = MockBusinesses.all.filter { $0.categoryID == categoryID }
            if businesses.isEmpty, categoryID == "events" {
                businesses = MockBusinesses.all.filter { $0.categoryID == "restaurants" || $0.categoryID == "cafes" }
            }
        }

        if contains(text, ["tonight", "available now", "open now"]) {
            businesses = businesses.filter { $0.status == .open } + businesses.filter { $0.status != .open }
        }

        if contains(text, ["near me", "nearby", "close"]) {
            businesses = businesses.sorted { ($0.distance ?? "9 km") < ($1.distance ?? "9 km") }
        } else {
            businesses = businesses.sorted { $0.rating > $1.rating }
        }

        if businesses.isEmpty {
            businesses = MockBusinesses.popular()
        }

        let suggestedCategory = categoryID.flatMap { id in SpotlyCategory.all.first { $0.id == id } }
        let title = title(for: text, category: suggestedCategory)
        let summary = summary(for: text, city: city, category: suggestedCategory, businesses: businesses, events: events)

        return SpotlyCommandResult(
            title: title,
            summary: summary,
            businesses: Array(businesses.prefix(4)),
            events: Array(events.prefix(3)),
            suggestedCategory: suggestedCategory
        )
    }

    private func contains(_ text: String, _ terms: [String]) -> Bool {
        terms.contains { text.contains($0) }
    }

    private func title(for text: String, category: SpotlyCategory?) -> String {
        if text.contains("weekend") { return "Here’s a strong weekend plan" }
        if text.contains("tonight") { return "Here’s a strong plan for tonight" }
        if let category { return "Best \(category.name.lowercased()) to start with" }
        return "Best matches around you"
    }

    private func summary(for text: String, city: String, category: SpotlyCategory?, businesses: [SpotlyBusiness], events: [SpotlyEvent]) -> String {
        if !events.isEmpty {
            return "I found events and nearby places in \(city) that fit the moment. Start with the top picks, then book or save what feels right."
        }
        if let first = businesses.first {
            return "Start with \(first.name), then compare a few high-signal options in \(city)."
        }
        if let category {
            return "I found a curated \(category.name.lowercased()) route for \(city)."
        }
        return "I found a few curated Spotly picks for \(city)."
    }
}
