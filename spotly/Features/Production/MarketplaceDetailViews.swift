import SwiftUI

private struct BusinessHeroBottomPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .greatestFiniteMagnitude

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct MarketplaceBusinessDetailView: View {
    let businessID: String
    let service: SpotlyServiceKind?

    @Environment(AppState.self) private var appState

    @State private var detail: BusinessDetailResponse?
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var isHeaderCollapsed = false

    var body: some View {
        Group {
            if let detail {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 22) {
                        hero(detail.business)

                        capabilityRow(detail)

                        if !detail.products.isEmpty {
                            offerings(detail.products)
                        }

                        locations(detail.branches)

                        if !detail.transactional && detail.products.isEmpty {
                            directoryNotice(detail.business)
                        }
                    }
                    .padding(.bottom, 44)
                }
                .coordinateSpace(name: "businessDetailScroll")
                .ignoresSafeArea(edges: .top)
                .onPreferenceChange(BusinessHeroBottomPreferenceKey.self) { bottom in
                    let shouldCollapse = bottom < 118

                    if shouldCollapse != isHeaderCollapsed {
                        isHeaderCollapsed = shouldCollapse
                    }
                }
            } else if isLoading {
                ProgressView("Opening…")
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity
                    )
            } else {
                SpotlyNetworkStateView(
                    title: "Couldn’t open this place",
                    message: errorMessage ?? "This place is temporarily unavailable.",
                    actionTitle: "Try again"
                ) {
                    Task {
                        await load()
                    }
                }
                .padding(18)
            }
        }
        .background(SpotlyColors.background)
        .navigationTitle(
            isHeaderCollapsed
                ? (detail?.business.displayName ?? "")
                : ""
        )
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(
            isHeaderCollapsed ? .visible : .hidden,
            for: .navigationBar
        )
        .toolbar {
            if let business = detail?.business {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task {
                            await appState.saved.toggleBusiness(
                                business,
                                user: appState.currentUser
                            )
                        }
                    } label: {
                        Image(
                            systemName:
                                appState.saved.isBusinessSaved(business.id)
                                ? "heart.fill"
                                : "heart"
                        )
                    }
                    .accessibilityLabel(
                        appState.saved.isBusinessSaved(business.id)
                            ? "Remove from Saved"
                            : "Save"
                    )
                }
            }
        }
        .task(id: businessID) {
            await load()
        }
        .refreshable {
            await load()
        }
    }

    private func hero(_ business: RemoteBusiness) -> some View {
        let tint = service?.tint ?? SpotlyColors.accent

        return ZStack(alignment: .bottomLeading) {
            Rectangle()
                .fill(tint.gradient)

            SpotlyRemoteImage(
                url: business.imageURL,
                cornerRadius: 0,
                aspectRatio: 1,
                fallbackIcon: service?.icon ?? "storefront",
                tint: tint
            )
            .opacity(
                business.imageURL == nil
                    ? 0.42
                    : 1
            )

            LinearGradient(
                colors: [
                    .clear,
                    .black.opacity(
                        business.imageURL == nil
                            ? 0.34
                            : 0.74
                    )
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            VStack(alignment: .leading, spacing: 8) {
                HStack(
                    alignment: .firstTextBaseline,
                    spacing: 7
                ) {
                    Text(business.displayName)
                        .font(SpotlyFont.title(.bold))
                        .foregroundStyle(.white)
                        .fixedSize(
                            horizontal: false,
                            vertical: true
                        )

                    if business.isCommerceVerified {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundStyle(.white)
                            .accessibilityLabel(
                                "Verified for Spotly commerce"
                            )
                    }
                }

                Text(
                    business.tagline
                        ?? business.description
                        ?? business.displayCategory
                )
                .font(SpotlyFont.callout())
                .foregroundStyle(.white.opacity(0.86))
                .lineLimit(3)

                let location = AddressFormatter.joined([
                    business.area ?? business.suburb,
                    business.city
                ])

                if !location.isEmpty {
                    Label(
                        location,
                        systemImage: "mappin.and.ellipse"
                    )
                    .font(SpotlyFont.caption(.semibold))
                    .foregroundStyle(.white.opacity(0.86))
                }

                Text(
                    business.isCommerceVerified
                        ? "Verified on Spotly"
                        : "Directory listing"
                )
                .font(SpotlyFont.caption(.semibold))
                .foregroundStyle(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    .black.opacity(0.22),
                    in: Capsule()
                )
            }
            .padding(.horizontal, 18)
            .padding(.bottom, 24)
            .padding(.top, 112)
        }
        .frame(maxWidth: .infinity)
        .frame(
            height:
                business.imageURL == nil
                ? 310
                : 360
        )
        .clipped()
        .background {
            GeometryReader { proxy in
                Color.clear.preference(
                    key: BusinessHeroBottomPreferenceKey.self,
                    value: proxy
                        .frame(
                            in: .named(
                                "businessDetailScroll"
                            )
                        )
                        .maxY
                )
            }
        }
        .accessibilityElement(children: .contain)
    }

    private func capabilityRow(
        _ detail: BusinessDetailResponse
    ) -> some View {
        ScrollView(
            .horizontal,
            showsIndicators: false
        ) {
            HStack(spacing: 8) {
                if detail.transactional {
                    SpotlyStatusPill(
                        text: "Book or buy on Spotly",
                        color: SpotlyColors.success
                    )
                }

                if detail.business.operational?.pickupAvailable == true {
                    SpotlyStatusPill(
                        text: "Pickup",
                        color: SpotlyColors.info
                    )
                }

                if detail.business.operational?.deliveryAvailable == true {
                    SpotlyStatusPill(
                        text: "Delivery",
                        color: SpotlyColors.accent
                    )
                }

                if detail.business.isCommerceVerified {
                    SpotlyStatusPill(
                        text: "Verified commerce",
                        color: SpotlyColors.accent
                    )
                } else {
                    SpotlyStatusPill(
                        text: "Directory listing",
                        color: SpotlyColors.textSecondary
                    )
                }
            }
            .padding(.horizontal, 18)
        }
    }

    private func offerings(
        _ items: [RemoteItem]
    ) -> some View {
        VStack(
            alignment: .leading,
            spacing: 14
        ) {
            SpotlySectionTitle(
                title:
                    service == .events
                    ? "Events"
                    : service == .book
                    ? "Book here"
                    : "Available here"
            )
            .padding(.horizontal, 18)

            ScrollView(
                .horizontal,
                showsIndicators: false
            ) {
                LazyHStack(spacing: 14) {
                    ForEach(items) { item in
                        NavigationLink {
                            MarketplaceItemDetailView(
                                item: item,
                                service: resolvedService(item)
                            )
                        } label: {
                            SpotlyItemCard(
                                item: item,
                                tint: resolvedService(item).tint
                            )
                            .frame(width: 205)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 18)
            }
        }
    }

    private func locations(
        _ branches: [RemoteBranch]
    ) -> some View {
        VStack(
            alignment: .leading,
            spacing: 12
        ) {
            SpotlySectionTitle(
                title:
                    branches.count > 1
                    ? "Locations"
                    : "Location"
            )
            .padding(.horizontal, 18)

            if branches.isEmpty {
                Text("Location details are not available yet.")
                    .font(SpotlyFont.callout())
                    .foregroundStyle(
                        SpotlyColors.textSecondary
                    )
                    .padding(.horizontal, 18)
            } else {
                ForEach(branches) { branch in
                    let address = AddressFormatter.joined([
                        branch.address,
                        branch.area ?? branch.suburb,
                        branch.city
                    ])

                    let name = branch.displayName
                        .trimmingCharacters(
                            in: .whitespacesAndNewlines
                        )

                    let shouldShowName =
                        !name.isEmpty
                        && !address.localizedCaseInsensitiveContains(name)
                        && name.caseInsensitiveCompare(
                            branch.city ?? ""
                        ) != .orderedSame

                    VStack(
                        alignment: .leading,
                        spacing: 5
                    ) {
                        if shouldShowName {
                            Text(name)
                                .font(
                                    SpotlyFont.headline()
                                )
                        }

                        if !address.isEmpty {
                            Text(address)
                                .font(
                                    SpotlyFont.callout()
                                )
                                .foregroundStyle(
                                    SpotlyColors.textSecondary
                                )
                        }

                        if let phone = branch.phone,
                           !phone.isEmpty,
                           let phoneURL = URL(
                            string:
                                "tel:\(phone.filter { $0.isNumber || $0 == "+" })"
                           ) {
                            Link(
                                destination: phoneURL
                            ) {
                                Label(
                                    phone,
                                    systemImage: "phone"
                                )
                            }
                            .font(
                                SpotlyFont.callout(
                                    .semibold
                                )
                            )
                            .foregroundStyle(
                                SpotlyColors.accent
                            )
                        }
                    }
                    .padding(14)
                    .background(
                        SpotlyColors.surface,
                        in: RoundedRectangle(
                            cornerRadius: 18
                        )
                    )
                    .overlay {
                        RoundedRectangle(
                            cornerRadius: 18
                        )
                        .stroke(
                            SpotlyColors.border
                        )
                    }
                    .padding(.horizontal, 18)
                }
            }
        }
    }

    private func directoryNotice(
        _ business: RemoteBusiness
    ) -> some View {
        HStack(
            alignment: .top,
            spacing: 12
        ) {
            Image(systemName: "info.circle.fill")
                .foregroundStyle(
                    SpotlyColors.info
                )

            Text(
                "This is a discovery listing. Ordering or booking only appears when the business enables verified Spotly commerce."
            )
            .font(SpotlyFont.callout())
            .foregroundStyle(
                SpotlyColors.textSecondary
            )
        }
        .padding(14)
        .background(
            SpotlyColors.infoBg,
            in: RoundedRectangle(
                cornerRadius: 18
            )
        )
        .padding(.horizontal, 18)
    }

    private func resolvedService(
        _ item: RemoteItem
    ) -> SpotlyServiceKind {
        if let service {
            return service
        }

        if item.type == "event"
            || item.itemType == "event" {
            return .events
        }

        if item.type == "service"
            || item.durationMinutes != nil {
            return .book
        }

        return .shop
    }

    private func load() async {
        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            detail = try await appState.marketplace.business(
                id: businessID
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

struct MarketplaceItemDetailView: View {
    let item: RemoteItem
    let service: SpotlyServiceKind

    @Environment(AppState.self) private var appState

    var body: some View {
        ScrollView {
            VStack(
                alignment: .leading,
                spacing: 20
            ) {
                SpotlyRemoteImage(
                    url: item.imageURL,
                    cornerRadius: 0,
                    aspectRatio: 1.35,
                    fallbackIcon: service.icon,
                    tint: service.tint
                )

                VStack(
                    alignment: .leading,
                    spacing: 10
                ) {
                    Text(item.displayName)
                        .font(
                            SpotlyFont.title(.bold)
                        )
                        .foregroundStyle(
                            SpotlyColors.textPrimary
                        )

                    if let business = item.businessName {
                        Text(business)
                            .font(
                                SpotlyFont.headline()
                            )
                            .foregroundStyle(
                                service.tint
                            )
                    }

                    if !item.displaySubtitle.isEmpty {
                        Text(item.displaySubtitle)
                            .font(
                                SpotlyFont.callout()
                            )
                            .foregroundStyle(
                                SpotlyColors.textSecondary
                            )
                    }

                    if let description = item.description,
                       !description.isEmpty {
                        Text(description)
                            .font(
                                SpotlyFont.body()
                            )
                            .foregroundStyle(
                                SpotlyColors.textSecondary
                            )
                            .fixedSize(
                                horizontal: false,
                                vertical: true
                            )
                    }

                    metadata
                }
                .padding(.horizontal, 18)
            }
            .padding(.bottom, 110)
        }
        .background(
            SpotlyColors.background
        )
        .navigationTitle(service.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(
                placement: .topBarTrailing
            ) {
                Button {
                    Task {
                        await appState.saved.toggleItem(
                            .from(item),
                            user: appState.currentUser
                        )
                    }
                } label: {
                    Image(
                        systemName:
                            appState.saved.isSaved(
                                type: SavedEntity.from(item).type,
                                id: item.id
                            )
                            ? "heart.fill"
                            : "heart"
                    )
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            bottomAction
        }
    }

    private var metadata: some View {
        VStack(
            alignment: .leading,
            spacing: 10
        ) {
            if item.price(in: "USD") > 0 {
                Text(
                    money(
                        item.price(in: "USD"),
                        currency:
                            item.currencyFor(
                                "USD"
                            )
                    )
                )
                .font(
                    SpotlyFont.title2(.bold)
                )
                .foregroundStyle(
                    SpotlyColors.textPrimary
                )
            } else if service == .events {
                Text("Free")
                    .font(
                        SpotlyFont.title2(.bold)
                    )
                    .foregroundStyle(
                        SpotlyColors.success
                    )
            }

            if let duration = item.durationMinutes {
                Label(
                    "\(duration) minutes",
                    systemImage: "clock"
                )
            }

            if let startsAt = item.startsAt {
                Label(
                    startsAt,
                    systemImage: "calendar"
                )
            }

            if let venue = item.venue {
                Label(
                    venue,
                    systemImage: "mappin.and.ellipse"
                )
            }

            if let remaining = item.remainingCapacity {
                Label(
                    "\(remaining) remaining",
                    systemImage: "person.2"
                )
            }
        }
        .font(
            SpotlyFont.callout()
        )
        .foregroundStyle(
            SpotlyColors.textSecondary
        )
    }

    private var bottomAction: some View {
        VStack(spacing: 0) {
            Divider()

            NavigationLink {
                MarketplaceCheckoutView(
                    item: item,
                    service: service
                )
            } label: {
                Text(actionTitle)
                    .font(
                        SpotlyFont.headline(.bold)
                    )
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(
                        service.tint,
                        in: RoundedRectangle(
                            cornerRadius: 16,
                            style: .continuous
                        )
                    )
            }
            .buttonStyle(.plain)
            .disabled(item.checkoutUnavailableReason(for: service) != nil)
            .opacity(item.checkoutUnavailableReason(for: service) != nil ? 0.55 : 1)
            .padding(18)
            .background(.bar)
        }
    }

    private var actionTitle: String {
        if let reason = item.checkoutUnavailableReason(for: service) {
            return reason
        }

        switch service {
        case .eat, .shop:
            return "Continue to checkout"

        case .book:
            return "Choose a time"

        case .events:
            return item.price(in: "USD") > 0
                ? "Get tickets"
                : "Reserve free ticket"

        default:
            return "Continue"
        }
    }
}
