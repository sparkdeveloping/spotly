import SwiftUI

// MARK: - Status badge

struct SpotlyStatusBadge: View {
    let status: BusinessStatus

    private var color: Color {
        switch status {
        case .open:        return SpotlyColors.success
        case .closed:      return SpotlyColors.error
        case .openingSoon: return SpotlyColors.warning
        }
    }

    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 5, height: 5)
            Text(status.displayText)
                .font(SpotlyFont.micro(.semibold))
                .foregroundStyle(color)
        }
        .padding(.horizontal, SpotlySpacing.xs)
        .padding(.vertical, 4)
        .background(SpotlyColors.badgeBackground)
        .overlay {
            Capsule(style: .continuous)
                .stroke(color.opacity(0.22), lineWidth: 0.5)
        }
        .clipShape(Capsule(style: .continuous))
    }
}

// MARK: - Booking status badge

struct SpotlyBookingStatusBadge: View {
    let status: SpotlyBookingStatus

    private var textColor: Color {
        switch status {
        case .confirmed: return SpotlyColors.success
        case .pending:   return SpotlyColors.warning
        case .cancelled, .failed: return SpotlyColors.error
        case .completed: return SpotlyColors.textSecondary
        case .draft:     return SpotlyColors.textSecondary
        }
    }

    private var backgroundColor: Color {
        switch status {
        case .confirmed: return SpotlyColors.success.opacity(0.14)
        case .pending:   return SpotlyColors.warning.opacity(0.16)
        case .cancelled, .failed: return SpotlyColors.error.opacity(0.14)
        case .completed: return SpotlyColors.backgroundElevated
        case .draft:     return SpotlyColors.backgroundElevated
        }
    }

    var body: some View {
        Text(status.displayText)
            .font(SpotlyFont.micro(.semibold))
            .foregroundStyle(textColor)
            .padding(.horizontal, SpotlySpacing.xs)
            .padding(.vertical, 4)
            .background(backgroundColor)
            .overlay {
                Capsule(style: .continuous)
                    .stroke(textColor.opacity(0.18), lineWidth: 0.5)
            }
            .clipShape(Capsule(style: .continuous))
    }
}

// MARK: - Rating view

struct SpotlyRatingView: View {
    let rating: Double
    var reviewCount: Int? = nil
    var size: Font = SpotlyFont.caption(.semibold)

    var body: some View {
        HStack(spacing: 3) {
            Image(systemName: "star.fill")
                .font(size)
                .foregroundStyle(SpotlyColors.accent)
            Text(String(format: "%.1f", rating))
                .font(size)
                .foregroundStyle(SpotlyColors.textPrimary)
            if let reviewCount {
                Text("(\(reviewCount))")
                    .font(SpotlyFont.micro())
                    .foregroundStyle(SpotlyColors.textSecondary)
            }
        }
    }
}

// MARK: - Price tag

struct SpotlyPriceTag: View {
    let level: Int
    var currency: String = "$"

    var body: some View {
        let filled = String(repeating: currency, count: level)
        let empty  = String(repeating: currency, count: 4 - level)
        HStack(spacing: 0) {
            Text(filled).foregroundStyle(SpotlyColors.accent)
            Text(empty).foregroundStyle(SpotlyColors.textTertiary)
        }
        .font(SpotlyFont.micro(.semibold))
    }
}

// MARK: - Verified badge

struct SpotlyVerifiedBadge: View {
    var body: some View {
        HStack(spacing: 3) {
            Image(systemName: "checkmark.seal.fill")
                .font(SpotlyFont.micro(.semibold))
            Text("Verified")
                .font(SpotlyFont.micro(.semibold))
        }
        .foregroundStyle(SpotlyColors.verified)
        .padding(.horizontal, SpotlySpacing.xs)
        .padding(.vertical, 3)
        .background(SpotlyColors.badgeBackground)
        .overlay {
            Capsule(style: .continuous)
                .stroke(SpotlyColors.verified.opacity(0.22), lineWidth: 0.5)
        }
        .clipShape(Capsule(style: .continuous))
    }
}
