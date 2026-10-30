import Foundation

enum SpotlyTaxonomy {
    static func classify(text: String) -> SpotlyServiceKind? {
        let lower = text.lowercased()
        // Tokenize by non-letters
        let tokens = lower.split(whereSeparator: { !$0.isLetter }) .map(String.init)
        let set = Set(tokens)

        // Book-specific terms first (to avoid bar vs barber leakage)
        let bookTokens: Set<String> = ["barber","barbers","hair","salon","hair_salon","spa","massage","clinic","doctor","hospital","hospitals","accommodation","hotel","hotels","lodge","lodges"]
        if !set.isDisjoint(with: bookTokens) { return .book }

        // Events
        let eventTokens: Set<String> = ["cinema","cinemas","event","events","concert","concerts","festival","festivals"]
        if !set.isDisjoint(with: eventTokens) { return .events }

        // Shop
        let shopTokens: Set<String> = ["grocery","groceries","supermarket","supermarkets","pharmacy","pharmacies","electronics","fashion","clothing"]
        if !set.isDisjoint(with: shopTokens) { return .shop }

        // Eat
        let eatTokens: Set<String> = ["restaurant","restaurants","cafe","cafes","café","cafés","coffee","coffees","pub","pubs","bar","bars"]
        if !set.isDisjoint(with: eatTokens) { return .eat }

        return nil
    }

    static func filterCategories(for service: SpotlyServiceKind, from categories: [String]) -> [String] {
        categories.filter { category in
            guard let cls = classify(text: category) else { return true }
            return cls == service
        }
    }
}
