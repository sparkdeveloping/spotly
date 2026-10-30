import Foundation

struct SpotlyCategory: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let icon: String
    let colorHex: String

    var shortDescription: String {
        switch id {
        case "food": return "Restaurants, cafes, and takeaway"
        case "restaurants": return "Book tables and discover polished dining"
        case "cafes": return "Coffee, brunch, and work-friendly spots"
        case "takeaways": return "Quick meals and delivery-ready plates"
        case "groceries": return "Fresh essentials and household baskets"
        case "pharmacy": return "Pharmacy items with in-store verification"
        case "doctors": return "Doctor and clinic appointments"
        case "flowersGifts": return "Bouquets, hampers, and custom gifts"
        case "beauty": return "Hair, nails, and beauty appointments"
        case "wellnessSpa": return "Massages, facials, and spa packages"
        case "padel": return "Courts, coaching, and social matches"
        case "gyms": return "Gyms, classes, and personal training"
        case "activities": return "Day trips, experiences, and family plans"
        case "staycations": return "Local escapes and weekend stays"
        case "events": return "Tickets, markets, sport, and nightlife"
        case "nightlife": return "Lounges, music, and late plans"
        case "offers": return "Launch partner deals and bundles"
        default: return "Curated Spotly places"
        }
    }

    static let all: [SpotlyCategory] = [
        SpotlyCategory(id: "food", name: "Food", icon: "fork.knife", colorHex: "13A36F"),
        SpotlyCategory(id: "restaurants", name: "Restaurants", icon: "fork.knife.circle.fill", colorHex: "13A36F"),
        SpotlyCategory(id: "cafes", name: "Cafes", icon: "cup.and.saucer.fill", colorHex: "0EA5A4"),
        SpotlyCategory(id: "takeaways", name: "Takeaways", icon: "takeoutbag.and.cup.and.straw.fill", colorHex: "F97316"),
        SpotlyCategory(id: "groceries", name: "Groceries", icon: "basket.fill", colorHex: "13A36F"),
        SpotlyCategory(id: "pharmacy", name: "Pharmacy", icon: "cross.case.fill", colorHex: "0EA5E9"),
        SpotlyCategory(id: "doctors", name: "Doctors", icon: "stethoscope", colorHex: "2563EB"),
        SpotlyCategory(id: "flowersGifts", name: "Flowers & Gifts", icon: "gift.fill", colorHex: "EC4899"),
        SpotlyCategory(id: "beauty", name: "Beauty", icon: "scissors", colorHex: "DB2777"),
        SpotlyCategory(id: "wellnessSpa", name: "Wellness & Spa", icon: "sparkles", colorHex: "10B981"),
        SpotlyCategory(id: "activities", name: "Activities", icon: "figure.outdoor.cycle", colorHex: "F59E0B"),
        SpotlyCategory(id: "staycations", name: "Staycations", icon: "bed.double.fill", colorHex: "6366F1"),
        SpotlyCategory(id: "events", name: "Events", icon: "calendar.badge.clock", colorHex: "7C3AED"),
        SpotlyCategory(id: "padel", name: "Padel", icon: "sportscourt.fill", colorHex: "0EA5E9"),
        SpotlyCategory(id: "gyms", name: "Gyms", icon: "dumbbell.fill", colorHex: "64748B"),
        SpotlyCategory(id: "nightlife", name: "Nightlife", icon: "moon.stars.fill", colorHex: "1E40AF"),
        SpotlyCategory(id: "offers", name: "Offers", icon: "tag.fill", colorHex: "DC2626")
    ]
}
