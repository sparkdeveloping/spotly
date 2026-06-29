import SwiftUI

struct SpotlyImageView: View {
    enum Style {
        case card
        case hero
        case thumbnail
    }

    let imageName: String?
    let categoryID: String
    var style: Style = .card

    var body: some View {
        Group {
            if let resolvedImage {
                Image(uiImage: resolvedImage)
                    .resizable()
                    .scaledToFill()
                    .overlay(overlay)
            } else {
                SpotlyGradients.forCategoryID(categoryID)
                    .overlay(overlay)
                    .overlay(alignment: .center) {
                        if let category = SpotlyCategory.all.first(where: { $0.id == categoryID }) {
                            Image(systemName: category.icon)
                                .font(style == .thumbnail ? SpotlyFont.title3(.medium) : .system(size: 34, weight: .medium))
                                .foregroundStyle(.white.opacity(0.78))
                        }
                    }
            }
        }
        .clipped()
    }

    private var resolvedImage: UIImage? {
        if let imageName, !SpotlySampleImages.shouldSuppressImage(imageName, for: categoryID), let image = UIImage(named: imageName) { return image }
        guard SpotlySampleImages.shouldUsePhotoFallback(for: categoryID) else { return nil }
        if let fallbackName = SpotlySampleImages.imageName(for: categoryID), let fallback = UIImage(named: fallbackName) { return fallback }
        return nil
    }

    private var overlay: some View {
        LinearGradient(
            colors: overlayColors,
            startPoint: .top,
            endPoint: .bottom
        )
    }

    private var overlayColors: [Color] {
        switch style {
        case .hero:
            return [.black.opacity(0.05), .black.opacity(0.18), .black.opacity(0.70)]
        case .card:
            return [.black.opacity(0.02), .black.opacity(0.10), .black.opacity(0.58)]
        case .thumbnail:
            return [.black.opacity(0.02), .black.opacity(0.12)]
        }
    }
}

enum SpotlySampleImages {
    static func shouldUsePhotoFallback(for categoryID: String) -> Bool {
        !["pharmacy", "doctors"].contains(categoryID)
    }

    static func shouldSuppressImage(_ imageName: String, for categoryID: String) -> Bool {
        ["pharmacy", "doctors"].contains(categoryID) && (imageName.contains("spa") || imageName.contains("salon"))
    }

    static func imageName(for categoryID: String) -> String? {
        switch categoryID {
        case "food", "restaurants", "takeaways", "offers": return "spotly_sample_restaurant_card_1"
        case "cafes": return "spotly_sample_cafe_card_1"
        case "spa", "salons", "wellnessSpa": return "spotly_sample_spa_card_1"
        case "beauty", "flowersGifts": return "spotly_sample_salon_card_1"
        case "padel", "activities", "staycations": return "spotly_sample_padel_card_1"
        case "gyms": return "spotly_sample_gym_card_1"
        case "events": return "spotly_sample_concert_card_1"
        case "groceries": return "spotly_sample_grocery_card_1"
        case "pharmacy", "doctors": return nil
        case "nightlife": return "spotly_sample_nightlife_card_1"
        default: return nil
        }
    }

    static func heroName(for categoryID: String) -> String? {
        switch categoryID {
        case "food", "restaurants", "takeaways", "offers": return "spotly_sample_restaurant_hero"
        case "cafes": return "spotly_sample_cafe_hero"
        case "spa", "salons", "wellnessSpa", "beauty", "flowersGifts": return "spotly_sample_spa_hero"
        case "pharmacy", "doctors": return nil
        case "padel", "activities", "staycations", "gyms": return "spotly_sample_padel_hero"
        case "events", "nightlife": return "spotly_sample_event_hero"
        default: return imageName(for: categoryID)
        }
    }
}

extension SpotlyBusiness {
    var heroImageName: String? { imageURLs.first }
    var cardImageName: String? { imageURLs.dropFirst().first ?? imageURLs.first }
}

extension SpotlyEvent {
    var heroImageName: String? { imageURLs.first }
    var cardImageName: String? { imageURLs.dropFirst().first ?? imageURLs.first }
}
