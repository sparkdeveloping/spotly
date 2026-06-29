import SwiftUI

enum SpotlyGradients {
    static let heroOverlay = LinearGradient(
        colors: [.black.opacity(0.04), .black.opacity(0.60)], startPoint: .top, endPoint: .bottom)
    static let cardOverlay = LinearGradient(
        colors: [.black.opacity(0.0), .black.opacity(0.55)], startPoint: .center, endPoint: .bottom)

    // Brand gradients
    static let brand = LinearGradient(
        colors: [Color(hex: "1A7A4A"), Color(hex: "145C37")],
        startPoint: .topLeading, endPoint: .bottomTrailing)
    static let champagne = LinearGradient(
        colors: [Color(hex: "E8C97D"), Color(hex: "D7B56D")],
        startPoint: .topLeading, endPoint: .bottomTrailing)
    static let emerald = LinearGradient(
        colors: [Color(hex: "1A7A4A"), Color(hex: "145C37")],
        startPoint: .topLeading, endPoint: .bottomTrailing)
    static let darkBase = LinearGradient(
        colors: [Color(hex: "0A0A0A"), Color(hex: "111827")], startPoint: .top, endPoint: .bottom)
    static let onboarding = LinearGradient(
        colors: [Color(hex: "1A7A4A"), Color(hex: "0D4A2B"), Color(hex: "111827")],
        startPoint: .topLeading, endPoint: .bottomTrailing)
    static let aurora = LinearGradient(
        colors: [Color(hex: "10B981"), Color(hex: "059669")],
        startPoint: .topLeading, endPoint: .bottomTrailing)

    // Category image overlays (subtle, not full-bleed gradients)
    static let restaurants = LinearGradient(colors: [Color(hex: "B65F3E"), Color(hex: "7C2F2C")], startPoint: .topLeading, endPoint: .bottomTrailing)
    static let cafes        = LinearGradient(colors: [Color(hex: "B68A4A"), Color(hex: "6F4A24")], startPoint: .topLeading, endPoint: .bottomTrailing)
    static let events       = LinearGradient(colors: [Color(hex: "7557C8"), Color(hex: "A0477D")], startPoint: .topLeading, endPoint: .bottomTrailing)
    static let activities   = LinearGradient(colors: [Color(hex: "397EA8"), Color(hex: "4D5DA8")], startPoint: .topLeading, endPoint: .bottomTrailing)
    static let wellness     = LinearGradient(colors: [Color(hex: "1A7A4A"), Color(hex: "22788A")], startPoint: .topLeading, endPoint: .bottomTrailing)
    static let nightlife    = LinearGradient(colors: [Color(hex: "1F2937"), Color(hex: "374151")], startPoint: .topLeading, endPoint: .bottomTrailing)
    static let groceries    = LinearGradient(colors: [Color(hex: "1A7A4A"), Color(hex: "145C37")], startPoint: .topLeading, endPoint: .bottomTrailing)
    static let gyms         = LinearGradient(colors: [Color(hex: "1D4ED8"), Color(hex: "1E40AF")], startPoint: .topLeading, endPoint: .bottomTrailing)
    static let salons       = LinearGradient(colors: [Color(hex: "9D174D"), Color(hex: "831843")], startPoint: .topLeading, endPoint: .bottomTrailing)
    static let padel        = LinearGradient(colors: [Color(hex: "0369A1"), Color(hex: "075985")], startPoint: .topLeading, endPoint: .bottomTrailing)

    static func forCategoryID(_ id: String) -> LinearGradient {
        switch id {
        case "restaurants": return restaurants
        case "cafes":       return cafes
        case "events":      return events
        case "activities":  return activities
        case "spa":         return wellness
        case "salons":      return salons
        case "gyms":        return gyms
        case "padel":       return padel
        case "groceries":   return groceries
        case "nightlife":   return nightlife
        default:            return brand
        }
    }

    static func shimmer(phase: CGFloat) -> LinearGradient {
        LinearGradient(
            stops: [
                .init(color: .white.opacity(0.0),  location: phase - 0.3),
                .init(color: .white.opacity(0.06), location: phase),
                .init(color: .white.opacity(0.0),  location: phase + 0.3),
            ],
            startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}
