import SwiftUI
import UIKit

// MARK: - Hex helpers

extension UIColor {
    nonisolated convenience init(hex: String) {
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
    // SwiftUI can resolve dynamic colors on its background rendering queue.
    nonisolated static func adaptive(light: String, dark: String) -> Color {
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
    static let spotlyPearl     = Color(hex: "F7F8FA")
    // Customer brand
    static let spotlyViolet     = Color(hex: "6657D9")
    static let spotlyVioletDark = Color(hex: "4E3FBF")
    static let spotlyVioletSoft = Color(hex: "F0EEFF")
    static let spotlyVioletMuted = Color(hex: "F8F7FF")
    // Legacy names resolve to semantic/customer tokens for compatibility.
    static let spotlyGreen     = Color(hex: "16A34A")
    static let spotlyGreenDark = Color(hex: "15803D")
    static let spotlyGreenMid  = Color(hex: "16A34A")
    static let spotlyGreenBg   = Color(hex: "DCFCE7")
    static let spotlyChampagne = Color(hex: "F59E0B")
    static let spotlyEmerald   = Color(hex: "16A34A")
    static let spotlyCoral     = Color(hex: "EF4444")
    static let spotlyAurora    = Color(hex: "6657D9")
    static let spotlyMist      = Color(hex: "E5E7EB")
}

// MARK: - Semantic adaptive tokens

enum SpotlyColors {
    // MARK: Brand
    static let primaryGreen     = success
    static let primaryGreenDark = Color.adaptive(light: "15803D", dark: "4ADE80")
    static let ratingGold       = Color(hex: "F59E0B")

    // Legacy aliases kept for compatibility
    static let champagne        = ratingGold
    static let aurora           = accent
    static let emerald          = success
    static let coral            = Color.spotlyCoral
    static let pearl            = groupedBackground
    static let mist             = Color.spotlyMist
    static let obsidian         = Color.spotlyObsidian
    static let ink              = Color.spotlyInk
    static let premiumGold      = ratingGold

    // MARK: Backgrounds
    static let background         = Color.adaptive(light: "FFFFFF", dark: "0B0B10")
    static let groupedBackground  = Color.adaptive(light: "F7F8FA", dark: "111118")
    static let secondaryBackground = Color.adaptive(light: "F3F4F6", dark: "1A1B23")
    static let backgroundElevated = groupedBackground
    static let backgroundAlt      = secondaryBackground

    // MARK: Surfaces
    static let surface         = Color.adaptive(light: "FFFFFF", dark: "1A1B23")
    static let surfaceElevated = Color.adaptive(light: "FFFFFF", dark: "222431")
    static let surfaceCard     = surface
    static let card            = surface
    static let cardPressed     = secondaryBackground

    // MARK: Text
    static let textPrimary   = Color.adaptive(light: "111827", dark: "F9FAFB")
    static let textSecondary = Color.adaptive(light: "6B7280", dark: "A1A7B3")
    static let textTertiary  = Color.adaptive(light: "9CA3AF", dark: "777E8C")
    static let textInverse   = Color.adaptive(light: "FFFFFF", dark: "111827")
    static let textOnAccent  = Color(hex: "FFFFFF")

    // MARK: Customer accent (violet)
    static let accent          = Color.adaptive(light: "6657D9", dark: "9B8CFF")
    static let accentStrong    = Color.adaptive(light: "4E3FBF", dark: "B4A9FF")
    static let accentSoft      = Color.adaptive(light: "F0EEFF", dark: "282343")
    static let accentMuted     = Color.adaptive(light: "F8F7FF", dark: "1D1A31")
    static let accentLight     = accentStrong
    static let accentDim       = accentSoft
    static let accentSecondary = accentStrong
    static let accentBg        = accentSoft

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
    static let border       = Color.adaptive(light: "E5E7EB", dark: "303240")
    static let borderStrong = Color.adaptive(light: "D1D5DB", dark: "45485A")
    static let borderAccent = accent.opacity(0.45)
    static let divider      = Color.adaptive(light: "E7E9E8", dark: "2A2C38")
    static let disabled     = Color.adaptive(light: "C7CBD1", dark: "555B68")

    // MARK: Inputs
    static let inputBackground = surface
    static let inputBorder     = border

    // MARK: Chips
    static let chipBackground        = surface
    static let chipSelectedBg        = accentSoft
    static let chipSelectedBackground = accentSoft
    static let chipSelectedText      = accent

    // MARK: Badges
    static let badgeBackground = Color.adaptive(light: "DCFCE7", dark: "0D3D2A")
    static let badgeText       = Color.adaptive(light: "166534", dark: "4ADE80")
    static let verified        = Color.adaptive(light: "16A34A", dark: "4ADE80")
    static let favourite       = Color.adaptive(light: "DC2626", dark: "F87171")

    // MARK: Tab bar / chrome
    static let tabBar = Color.adaptive(light: "FFFFFF", dark: "0A0A0A")

    // MARK: Glass
    static let glass       = surface
    static let glassStroke = border

    // MARK: Overlays
    static let overlay      = Color.black.opacity(0.45)
    static let overlayLight = Color.black.opacity(0.20)
    static let overlayHeavy = Color.black.opacity(0.70)

    // MARK: Shadows
    static let shadow = Color.adaptive(light: "111827", dark: "000000").opacity(0.05)
}
