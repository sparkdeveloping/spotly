import SwiftUI
import UIKit

// MARK: - Hex helpers

extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:  (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:  (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:  (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: Double(r)/255, green: Double(g)/255, blue: Double(b)/255, alpha: Double(a)/255)
    }
}

extension Color {
    init(hex: String) { self.init(UIColor(hex: hex)) }
    static func adaptive(light: String, dark: String) -> Color {
        Color(UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: dark) : UIColor(hex: light) })
    }
}

// MARK: - Raw palette

extension Color {
    static let spotlyObsidian  = Color(hex: "0A0A0A")
    static let spotlyInk       = Color(hex: "111827")
    static let spotlyCharcoal  = Color(hex: "1F2937")
    static let spotlySlate     = Color(hex: "374151")
    static let spotlyWhite     = Color(hex: "FFFFFF")
    static let spotlyOffWhite  = Color(hex: "F9FAFB")
    static let spotlyLightGrey = Color(hex: "F3F4F6")
    static let spotlyMidGrey   = Color(hex: "E5E7EB")
    static let spotlyPearl     = Color(hex: "F8F5EF")
    // Brand green
    static let spotlyGreen     = Color(hex: "1A7A4A")
    static let spotlyGreenDark = Color(hex: "145C37")
    static let spotlyGreenMid  = Color(hex: "16A34A")
    static let spotlyGreenBg   = Color(hex: "DCFCE7")
    // Legacy / accents
    static let spotlyChampagne = Color(hex: "D7B56D")
    static let spotlyEmerald   = Color(hex: "13A36F")
    static let spotlyCoral     = Color(hex: "EF4444")
    static let spotlyAurora    = Color(hex: "10B981")
    static let spotlyMist      = Color(hex: "E5E7EB")
}

// MARK: - Semantic adaptive tokens

enum SpotlyColors {
    // MARK: Brand
    static let primaryGreen     = Color.spotlyGreen
    static let primaryGreenDark = Color.spotlyGreenDark
    static let ratingGold       = Color(hex: "F59E0B")

    // Legacy aliases kept for compatibility
    static let champagne        = Color.spotlyChampagne
    static let aurora           = Color.spotlyAurora
    static let emerald          = Color.spotlyEmerald
    static let coral            = Color.spotlyCoral
    static let pearl            = Color.spotlyPearl
    static let mist             = Color.spotlyMist
    static let obsidian         = Color.spotlyObsidian
    static let ink              = Color.spotlyInk
    static let premiumGold      = Color(hex: "D7B56D")

    // MARK: Backgrounds
    static let background         = Color.adaptive(light: "FFFFFF", dark: "0A0A0A")
    static let backgroundElevated = Color.adaptive(light: "F9FAFB", dark: "161616")
    static let backgroundAlt      = Color.adaptive(light: "F3F4F6", dark: "111111")

    // MARK: Surfaces
    static let surface         = Color.adaptive(light: "FFFFFF", dark: "1A1A1A")
    static let surfaceElevated = Color.adaptive(light: "F9FAFB", dark: "222222")
    static let surfaceCard     = Color.adaptive(light: "FFFFFF", dark: "1C1C1E")
    static let card            = Color.adaptive(light: "FFFFFF", dark: "1C1C1E")
    static let cardPressed     = Color.adaptive(light: "F3F4F6", dark: "252525")

    // MARK: Text
    static let textPrimary   = Color.adaptive(light: "111827", dark: "F9FAFB")
    static let textSecondary = Color.adaptive(light: "6B7280", dark: "9CA3AF")
    static let textTertiary  = Color.adaptive(light: "9CA3AF", dark: "6B7280")
    static let textInverse   = Color.adaptive(light: "FFFFFF", dark: "111827")
    static let textOnAccent  = Color(hex: "FFFFFF")

    // MARK: Accent (deep green)
    static let accent          = Color.spotlyGreen
    static let accentLight     = Color.spotlyGreenMid
    static let accentDim       = Color.adaptive(light: "15803D", dark: "4ADE80")
    static let accentSecondary = Color.adaptive(light: "15803D", dark: "4ADE80")
    static let accentBg        = Color.adaptive(light: "DCFCE7", dark: "0D3D2A")

    // MARK: Status
    static let success    = Color(hex: "16A34A")
    static let successBg  = Color.adaptive(light: "DCFCE7", dark: "0D3D2A")
    static let error      = Color.adaptive(light: "DC2626", dark: "F87171")
    static let errorBg    = Color.adaptive(light: "FEE2E2", dark: "3D1A18")
    static let warning    = Color(hex: "D97706")
    static let warningBg  = Color.adaptive(light: "FEF3C7", dark: "3D2E0D")
    static let info       = Color.adaptive(light: "2563EB", dark: "60A5FA")
    static let infoBg     = Color.adaptive(light: "EFF6FF", dark: "1E3A5F")

    // MARK: Borders & Dividers
    static let border       = Color.adaptive(light: "E5E7EB", dark: "2D2D2D")
    static let borderStrong = Color.adaptive(light: "D1D5DB", dark: "404040")
    static let borderAccent = Color.spotlyGreen.opacity(0.35)
    static let divider      = Color.adaptive(light: "E5E7EB", dark: "2A2A2A")

    // MARK: Inputs
    static let inputBackground = Color.adaptive(light: "FFFFFF", dark: "1C1C1E")
    static let inputBorder     = Color.adaptive(light: "D1D5DB", dark: "374151")

    // MARK: Chips
    static let chipBackground        = Color.adaptive(light: "F3F4F6", dark: "2A2A2A")
    static let chipSelectedBg        = Color.spotlyGreen
    static let chipSelectedBackground = Color.spotlyGreen
    static let chipSelectedText      = Color(hex: "FFFFFF")

    // MARK: Badges
    static let badgeBackground = Color.adaptive(light: "DCFCE7", dark: "0D3D2A")
    static let badgeText       = Color.adaptive(light: "166534", dark: "4ADE80")
    static let verified        = Color.adaptive(light: "16A34A", dark: "4ADE80")
    static let favourite       = Color.adaptive(light: "DC2626", dark: "F87171")

    // MARK: Tab bar / chrome
    static let tabBar = Color.adaptive(light: "FFFFFF", dark: "0A0A0A")

    // MARK: Glass
    static let glass       = Color.adaptive(light: "FFFFFF", dark: "FFFFFF").opacity(0.08)
    static let glassStroke = Color.adaptive(light: "111827", dark: "FFFFFF").opacity(0.10)

    // MARK: Overlays
    static let overlay      = Color.black.opacity(0.45)
    static let overlayLight = Color.black.opacity(0.20)
    static let overlayHeavy = Color.black.opacity(0.70)

    // MARK: Shadows
    static let shadow = Color.adaptive(light: "111827", dark: "000000").opacity(0.07)
}
