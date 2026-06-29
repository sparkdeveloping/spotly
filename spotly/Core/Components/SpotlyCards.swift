import SwiftUI

// MARK: - Listing card

struct SpotlyListingCard: View {
    let business: SpotlyBusiness
    var isFavourited: Bool = false
    var onFavourite: (() -> Void)? = nil
    let onTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .top) {
                SpotlyImageView(imageName: business.cardImageName, categoryID: business.categoryID, style: .card)
                    .frame(height: 148)

                HStack(alignment: .top) {
                    ZStack {
                        Circle().fill(.ultraThinMaterial)
                        if let cat = SpotlyCategory.all.first(where: { $0.id == business.categoryID }) {
                            Image(systemName: cat.icon)
                                .font(SpotlyFont.caption(.semibold))
                                .foregroundStyle(Color(hex: cat.colorHex))
                        }
                    }
                    .frame(width: 36, height: 36)

                    Spacer()

                    if onFavourite != nil {
                        Button {
                            SpotlyHaptics.success()
                            withAnimation(SpotlyMotion.successPop) { onFavourite?() }
                        } label: {
                            Image(systemName: isFavourited ? "heart.fill" : "heart")
                                .font(SpotlyFont.callout())
                                .foregroundStyle(isFavourited ? SpotlyColors.favourite : .white)
                                .frame(width: 40, height: 40)
                                .background(.regularMaterial)
                                .clipShape(Circle())
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(SpotlySpacing.xs)

                VStack(alignment: .leading, spacing: 2) {
                    Spacer()
                    SpotlyStatusBadge(status: business.status)
                    if business.isVerified {
                        SpotlyVerifiedBadge()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(SpotlySpacing.xs)
            }

            VStack(alignment: .leading, spacing: SpotlySpacing.xxs) {
                Text(business.name)
                    .font(SpotlyFont.headline())
                    .foregroundStyle(SpotlyColors.textPrimary)
                    .lineLimit(2)

                Text(business.tagline)
                    .font(SpotlyFont.caption())
                    .foregroundStyle(SpotlyColors.textSecondary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: SpotlySpacing.sm) {
                    SpotlyRatingView(rating: business.rating, reviewCount: business.reviewCount)

                    if let distance = business.distance {
                        HStack(spacing: 3) {
                            Image(systemName: "location.fill")
                                .font(SpotlyFont.micro())
                            Text(distance)
                                .font(SpotlyFont.caption())
                        }
                        .foregroundStyle(SpotlyColors.textSecondary)
                    }

                    Spacer()
                    SpotlyPriceTag(level: business.priceLevel)
                }
            }
            .padding(SpotlySpacing.cardPadding)
        }
        .contentShape(RoundedRectangle(cornerRadius: SpotlyRadius.md, style: .continuous))
        .onTapGesture {
            SpotlyHaptics.lightTap()
            onTap()
        }
        .background(SpotlyColors.surfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.md, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: SpotlyRadius.md, style: .continuous)
                .stroke(SpotlyColors.border, lineWidth: 0.5)
        }
        .spotlyShadow(SpotlyShadow.card)
        .pressableScale(scale: 0.97)
    }
}

// MARK: - Event card

struct SpotlyEventCard: View {
    let event: SpotlyEvent
    let onTap: () -> Void

    var body: some View {
        Button(action: {
            SpotlyHaptics.lightTap()
            onTap()
        }) {
            ZStack(alignment: .bottomLeading) {
                SpotlyImageView(imageName: event.cardImageName, categoryID: event.categoryID, style: .card)
                    .frame(width: 240, height: 160)

                VStack(alignment: .leading, spacing: SpotlySpacing.xxs) {
                    HStack {
                        Text(event.formattedDate)
                            .font(SpotlyFont.micro(.semibold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, SpotlySpacing.xs)
                            .padding(.vertical, 3)
                            .background(.ultraThinMaterial)
                            .clipShape(Capsule(style: .continuous))

                        Spacer()

                        Text(event.priceText)
                            .font(SpotlyFont.micro(.semibold))
                            .foregroundStyle(SpotlyColors.textOnAccent)
                            .padding(.horizontal, SpotlySpacing.xs)
                            .padding(.vertical, 3)
                            .background(SpotlyColors.accent)
                            .clipShape(Capsule(style: .continuous))
                    }

                    Text(event.name)
                        .font(SpotlyFont.headline())
                        .foregroundStyle(.white)
                        .lineLimit(2)

                    HStack(spacing: 3) {
                        Image(systemName: "mappin.circle.fill")
                            .font(SpotlyFont.micro())
                        Text(event.venue)
                            .font(SpotlyFont.caption())
                            .lineLimit(1)
                    }
                    .foregroundStyle(.white.opacity(0.8))
                }
                .padding(SpotlySpacing.cardPadding)
            }
        }
        .buttonStyle(.plain)
        .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.md, style: .continuous))
        .spotlyShadow(SpotlyShadow.card)
        .pressableScale(scale: 0.97)
    }
}

// MARK: - Compact listing card (for search results / list view)

struct SpotlyCompactListingCard: View {
    let business: SpotlyBusiness
    var isFavourited: Bool = false
    var onFavourite: (() -> Void)? = nil
    let onTap: () -> Void

    var body: some View {
        HStack(spacing: SpotlySpacing.md) {
            SpotlyImageView(imageName: business.cardImageName, categoryID: business.categoryID, style: .thumbnail)
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.sm, style: .continuous))

            VStack(alignment: .leading, spacing: SpotlySpacing.xxs) {
                HStack(alignment: .top, spacing: 4) {
                    Text(business.name)
                        .font(SpotlyFont.headline())
                        .foregroundStyle(SpotlyColors.textPrimary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                    if business.isVerified {
                        Image(systemName: "checkmark.seal.fill")
                            .font(SpotlyFont.caption())
                            .foregroundStyle(SpotlyColors.success)
                    }
                }

                Text(business.tagline)
                    .font(SpotlyFont.caption())
                    .foregroundStyle(SpotlyColors.textSecondary)
                    .lineLimit(2)

                HStack(spacing: SpotlySpacing.sm) {
                    SpotlyRatingView(rating: business.rating)
                    if let distance = business.distance {
                        Text(distance)
                            .font(SpotlyFont.caption())
                            .foregroundStyle(SpotlyColors.textSecondary)
                    }
                }
            }

            Spacer(minLength: SpotlySpacing.xs)

            VStack(alignment: .trailing, spacing: SpotlySpacing.xs) {
                SpotlyStatusBadge(status: business.status)
                if onFavourite != nil {
                    Button {
                        SpotlyHaptics.lightTap()
                        withAnimation(SpotlyMotion.successPop) { onFavourite?() }
                    } label: {
                        Image(systemName: isFavourited ? "heart.fill" : "heart")
                            .font(SpotlyFont.callout(.semibold))
                            .foregroundStyle(isFavourited ? SpotlyColors.favourite : SpotlyColors.textTertiary)
                            .frame(width: 44, height: 44)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(SpotlySpacing.cardPadding)
        .contentShape(Rectangle())
        .onTapGesture {
            SpotlyHaptics.lightTap()
            onTap()
        }
        .cardBackground()
        .pressableScale(scale: 0.98)
    }
}
