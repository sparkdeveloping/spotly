import SwiftUI

struct SpotlyRemoteImage: View {
    let url: URL?
    var cornerRadius: CGFloat = 18
    var aspectRatio: CGFloat = 1.35
    var fallbackIcon = "photo"
    var tint: Color = SpotlyColors.accent

    @State private var fetcher = SpotlyImageFetcher()
    @Environment(\.displayScale) private var displayScale

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                tint.opacity(0.08)
                if RemoteMedia.url(url?.absoluteString) == nil {
                    fallback
                } else {
                    switch fetcher.phase {
                    case .fallback, .failure: fallback
                    case .loading:
                        RoundedRectangle(cornerRadius: cornerRadius).fill(tint.opacity(0.08))
                            .overlay { Image(systemName: fallbackIcon).font(.largeTitle).foregroundStyle(tint.opacity(0.2)) }
                    case .success(let image): Image(uiImage: image).resizable().scaledToFill()
                    }
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .clipped()
            .task(id: "\(url?.absoluteString ?? "")#\(Int(proxy.size.width * displayScale))") {
                await fetcher.load(url: url, targetPixels: Int(max(proxy.size.width, proxy.size.height) * displayScale))
            }
        }
        .aspectRatio(aspectRatio, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .accessibilityHidden(true)
    }

    private var fallback: some View {
        Image(systemName: fallbackIcon)
            .font(.system(size: 32, weight: .medium))
            .foregroundStyle(tint)
    }
}


struct SpotlyRefreshBanner: View {
    let message: String
    var actionTitle = "Retry"
    let action: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "arrow.clockwise.circle.fill")
                .foregroundStyle(SpotlyColors.warning)
            Text(message)
                .font(SpotlyFont.caption())
                .foregroundStyle(SpotlyColors.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 8)
            Button(actionTitle, action: action)
                .font(SpotlyFont.caption(.semibold))
                .foregroundStyle(SpotlyColors.accent)
        }
        .padding(.horizontal, 13)
        .padding(.vertical, 10)
        .background(SpotlyColors.surface, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).stroke(SpotlyColors.border))
    }
}

struct SpotlyNetworkStateView: View {
    let title: String
    let message: String
    var systemImage = "wifi.exclamationmark"
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        ContentUnavailableView {
            Label(title, systemImage: systemImage)
        } description: {
            Text(message)
        } actions: {
            if let actionTitle, let action {
                Button(actionTitle, action: action).buttonStyle(.borderedProminent).tint(SpotlyColors.accent)
            }
        }
    }
}

struct SpotlySectionTitle: View {
    let title: String
    var subtitle: String? = nil
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        HStack(alignment: .lastTextBaseline, spacing: 12) {
            VStack(alignment: .leading, spacing: 3) {
                Text(title).font(SpotlyFont.title2()).foregroundStyle(SpotlyColors.textPrimary)
                if let subtitle { Text(subtitle).font(SpotlyFont.callout()).foregroundStyle(SpotlyColors.textSecondary) }
            }
            Spacer(minLength: 8)
            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .font(SpotlyFont.subheadline(.semibold))
                    .foregroundStyle(SpotlyColors.accent)
            }
        }
    }
}

struct SpotlyBusinessCard: View {
    let business: RemoteBusiness
    var tint: Color = SpotlyColors.accent
    var compact = false
    var fallbackIcon = "storefront"
    var saved = false
    var onSave: (() -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack(alignment: .topTrailing) {
                SpotlyRemoteImage(url: business.imageURL, cornerRadius: 18, aspectRatio: business.imageURL == nil ? 3.2 : compact ? 1.4 : 1.25, fallbackIcon: fallbackIcon, tint: tint)
                if let onSave {
                    Button(action: onSave) {
                        Image(systemName: saved ? "heart.fill" : "heart")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(saved ? SpotlyColors.favourite : SpotlyColors.textPrimary)
                            .frame(width: 38, height: 38)
                            .background(.ultraThinMaterial, in: Circle())
                    }
                    .buttonStyle(.plain)
                    .padding(10)
                    .accessibilityLabel(saved ? "Remove from Saved" : "Save")
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 5) {
                    Text(business.displayName)
                        .font(compact ? SpotlyFont.headline() : SpotlyFont.title3())
                        .foregroundStyle(SpotlyColors.textPrimary)
                        .lineLimit(2)
                    if business.isCommerceVerified {
                        Image(systemName: "checkmark.seal.fill").foregroundStyle(SpotlyColors.accent).font(.caption)
                            .accessibilityLabel("Verified")
                    }
                }
                Text(business.displayCategory)
                    .font(SpotlyFont.callout())
                    .foregroundStyle(SpotlyColors.textSecondary)
                    .lineLimit(1)
                HStack(spacing: 10) {
                    if business.operational?.openNow == true {
                        Label("Open now", systemImage: "circle.fill")
                            .font(SpotlyFont.caption(.semibold))
                            .foregroundStyle(SpotlyColors.success)
                    }
                    if let rating = business.rating, rating > 0 {
                        Label(String(format: "%.1f", rating), systemImage: "star.fill")
                            .font(SpotlyFont.caption(.semibold))
                            .foregroundStyle(SpotlyColors.textSecondary)
                    }
                    if !business.displayLocation.isEmpty {
                        Text(business.displayLocation).lineLimit(1)
                    }
                }
                .font(SpotlyFont.caption())
                .foregroundStyle(SpotlyColors.textSecondary)
            }
        }
        .contentShape(Rectangle())
    }
}

struct SpotlyItemCard: View {
    let item: RemoteItem
    var tint: Color = SpotlyColors.accent

    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            SpotlyRemoteImage(url: item.imageURL, cornerRadius: 16, aspectRatio: 1.18, fallbackIcon: item.type == "event" ? "ticket" : "bag", tint: tint)
            Text(item.displayName)
                .font(SpotlyFont.headline())
                .foregroundStyle(SpotlyColors.textPrimary)
                .lineLimit(2)
            if !item.displaySubtitle.isEmpty {
                Text(item.displaySubtitle).font(SpotlyFont.caption()).foregroundStyle(SpotlyColors.textSecondary).lineLimit(1)
            } else if let business = item.businessName {
                Text(business).font(SpotlyFont.caption()).foregroundStyle(SpotlyColors.textSecondary).lineLimit(1)
            }
            if item.price(in: "USD") > 0 {
                Text(money(item.price(in: "USD"), currency: item.currencyFor("USD")))
                    .font(SpotlyFont.subheadline(.bold)).foregroundStyle(SpotlyColors.textPrimary)
            } else if item.type == "event" {
                Text("Free").font(SpotlyFont.subheadline(.bold)).foregroundStyle(SpotlyColors.success)
            }
        }
    }
}

struct SpotlyStatusPill: View {
    let text: String
    var color: Color = SpotlyColors.accent

    var body: some View {
        Text(text.replacingOccurrences(of: "_", with: " ").capitalized)
            .font(SpotlyFont.caption(.semibold))
            .foregroundStyle(color)
            .padding(.horizontal, 10).padding(.vertical, 6)
            .background(color.opacity(0.11), in: Capsule())
    }
}

struct SignInRequiredView: View {
    @Environment(AppState.self) private var appState
    var title = "Sign in to continue"
    var message = "Your Spotly account keeps payments, bookings and activity secure across devices."

    var body: some View {
        ContentUnavailableView {
            Label(title, systemImage: "person.crop.circle.badge.exclamationmark")
        } description: {
            Text(message)
        } actions: {
            Button("Sign in or create account") {
                appState.hasCompletedEntryFlow = false
                appState.isGuestMode = false
                appState.authState = .unauthenticated
            }
            .buttonStyle(.borderedProminent)
            .tint(SpotlyColors.accent)
        }
    }
}

func money(_ value: Double, currency: String) -> String {
    let code = currency == "ZWG" ? "ZWG" : "US$"
    return "\(code)\(String(format: "%.2f", value))"
}

extension View {
    @ViewBuilder
    func spotlyInteractiveGlass(cornerRadius: CGFloat = 20) -> some View {
        if #available(iOS 26.0, *) {
            self.glassEffect(.regular.interactive(), in: .rect(cornerRadius: cornerRadius))
        } else {
            self.background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        }
    }
}
