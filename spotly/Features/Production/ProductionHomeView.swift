import SwiftUI

struct ProductionHomeView: View {
    @Environment(AppState.self) private var appState

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    private var columns: [GridItem] { dynamicTypeSize.isAccessibilitySize ? [GridItem(.flexible())] : [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)] }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 28) {
                    hero
                    serviceGrid

                    if let current = appState.activity.records.first(where: { $0.section == .attention || $0.section == .active }) {
                        currentActivity(current)
                    }

                    marketplaceSections
                    ForEach([SpotlyServiceKind.eat, .shop, .book, .events]) { service in
                        if let error = appState.marketplace.feedErrors[service] {
                            VStack(alignment: .leading, spacing: 8) {
                                Label("\(service.title) couldn’t update", systemImage: service.icon).font(.headline)
                                Text(error).font(.callout).foregroundStyle(.secondary)
                                Button("Try again") { Task { await appState.marketplace.loadHome(city: appState.selectedCity, force: true) } }
                            }
                        }
                    }
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 36)
            }
            .background(SpotlyColors.background)
            .navigationTitle("Spotly")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { toolbar }
            .refreshable {
                async let home: Void = appState.marketplace.loadHome(city: appState.selectedCity, force: true)
                async let activity: Void = appState.activity.load(user: appState.currentUser, force: true)
                _ = await (home, activity)
            }
            .task(id: appState.selectedCity) {
                await appState.marketplace.loadHome(city: appState.selectedCity)
                if appState.isAuthenticated { await appState.activity.load(user: appState.currentUser) }
            }
        }
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 9) {
            Text(greeting)
                .font(SpotlyFont.caption(.semibold))
                .foregroundStyle(SpotlyColors.accent)
                .textCase(.uppercase)
                .tracking(0.6)
            Text("Your city. A little closer.")
                .font(SpotlyFont.display(.bold))
                .foregroundStyle(SpotlyColors.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
            Text("Everyday plans, good finds and what comes next in \(appState.selectedCity).")
                .font(SpotlyFont.body())
                .foregroundStyle(SpotlyColors.textSecondary)
                .fixedSize(horizontal: false, vertical: true)

            Button {
                appState.selectedTab = .search
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                    Text("Search all of Spotly")
                        .foregroundStyle(SpotlyColors.textSecondary)
                    Spacer()
                }
                .font(SpotlyFont.body())
                .padding(.horizontal, 16)
                .frame(height: 52)
                .spotlyInteractiveGlass(cornerRadius: 18)
            }
            .buttonStyle(.plain)
            .padding(.top, 6)
        }
        .padding(.top, 8)
    }

    private var serviceGrid: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("One Spotly. Your kind of day.")
                .font(SpotlyFont.subheadline(.bold))
                .foregroundStyle(SpotlyColors.textPrimary)
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach([SpotlyServiceKind.eat, .shop, .ride, .book, .events, .send]) { service in
                    Group {
                        switch service {
                        case .ride:
                            NavigationLink { RideRequestView() } label: { ServiceTile(service: service) }
                        case .send:
                            NavigationLink { SendRequestView() } label: { ServiceTile(service: service) }
                        default:
                            NavigationLink { ServiceDiscoveryView(service: service) } label: { ServiceTile(service: service) }
                        }
                    }
                    .buttonStyle(SpotlyPressableButtonStyle(scale: 0.975))
                }
            }
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Spotly services")
        }
    }

    @ViewBuilder
    private var marketplaceSections: some View {
        if appState.marketplace.isLoadingHome && appState.marketplace.feeds.isEmpty {
            VStack(spacing: 12) {
                ProgressView().tint(SpotlyColors.accent)
                Text("Finding what’s live in \(appState.selectedCity)…")
                    .font(SpotlyFont.callout())
                    .foregroundStyle(SpotlyColors.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 36)
        } else if let error = appState.marketplace.homeError, appState.marketplace.feeds.isEmpty {
            SpotlyNetworkStateView(title: "Couldn’t load Spotly", message: error, actionTitle: "Try again") {
                Task { await appState.marketplace.loadHome(city: appState.selectedCity, force: true) }
            }
        } else {
            if !verifiedHomeBusinesses.isEmpty {
                businessCarousel(
                    verifiedHomeBusinesses,
                    title: "Popular in \(appState.selectedCity)",
                    subtitle: "Verified places ready on Spotly"
                )
            }

            if !directoryHomeBusinesses.isEmpty {
                businessCarousel(
                    directoryHomeBusinesses,
                    title: "Discover around \(appState.selectedCity)",
                    subtitle: "Local directory listings for discovery"
                )
            }

            if let events = appState.marketplace.feeds[.events]?.items, !events.isEmpty {
                VStack(alignment: .leading, spacing: 14) {
                    SpotlySectionTitle(title: "What’s happening", subtitle: "Events in \(appState.selectedCity)", actionTitle: "See all") {
                        // A direct button cannot push from here without route state; Search remains a useful fallback.
                        appState.selectedTab = .search
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 14) {
                            ForEach(events.prefix(8)) { item in
                                NavigationLink { MarketplaceItemDetailView(item: item, service: .events) } label: {
                                    SpotlyItemCard(item: item, tint: SpotlyServiceKind.events.tint).frame(width: 198)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
            }

            if feedsAreEmpty {
                ContentUnavailableView {
                    Label("Spotly is still filling out \(appState.selectedCity)", systemImage: "mappin.and.ellipse")
                } description: {
                    Text("Ride and Send may still be available. We’ll show verified local businesses here as they come online.")
                }
                .padding(.vertical, 12)
            }
        }
    }

    private func currentActivity(_ record: ActivityRecord) -> some View {
        Button {
            appState.selectedTab = .activity
        } label: {
            HStack(spacing: 14) {
                Image(systemName: record.kind.icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(SpotlyColors.accent, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                VStack(alignment: .leading, spacing: 3) {
                    Text(record.section == .attention ? "Needs your attention" : "Happening now")
                        .font(SpotlyFont.caption(.semibold)).foregroundStyle(SpotlyColors.accent)
                    Text(record.title).font(SpotlyFont.headline()).foregroundStyle(SpotlyColors.textPrimary).lineLimit(1)
                    Text(record.state.replacingOccurrences(of: "_", with: " ").capitalized)
                        .font(SpotlyFont.caption()).foregroundStyle(SpotlyColors.textSecondary)
                }
                Spacer()
                Image(systemName: "chevron.right").foregroundStyle(SpotlyColors.textTertiary)
            }
            .padding(14)
            .background(SpotlyColors.surface, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(SpotlyColors.border))
        }
        .buttonStyle(.plain)
    }

    @ToolbarContentBuilder
    private var toolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Menu {
                ForEach(["Harare", "Bulawayo", "Mutare", "Gweru", "Victoria Falls"], id: \.self) { city in
                    Button(city) { appState.selectedCity = city }
                }
            } label: {
                Label(appState.selectedCity, systemImage: "location.fill")
                    .font(SpotlyFont.subheadline(.semibold))
            }
            .accessibilityLabel("Current city, \(appState.selectedCity)")
        }

        ToolbarItem(placement: .topBarTrailing) {
            NavigationLink { NotificationCenterView() } label: {
                Image(systemName: "bell")
            }
            .accessibilityLabel("Notifications")
        }
    }

    private var allHomeBusinesses: [RemoteBusiness] {
        var seen = Set<String>()
        return [SpotlyServiceKind.eat, .shop, .book]
            .flatMap { appState.marketplace.feeds[$0]?.businesses ?? [] }
            .filter { seen.insert($0.id).inserted }
    }

    private var verifiedHomeBusinesses: [RemoteBusiness] {
        allHomeBusinesses.filter(\.isCommerceVerified)
    }

    private var directoryHomeBusinesses: [RemoteBusiness] {
        Array(allHomeBusinesses.filter { !$0.isCommerceVerified }.prefix(8))
    }

    private func businessCarousel(_ businesses: [RemoteBusiness], title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            SpotlySectionTitle(title: title, subtitle: subtitle, actionTitle: "Search") {
                appState.selectedTab = .search
            }
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 14) {
                    ForEach(businesses.prefix(8)) { business in
                        NavigationLink { MarketplaceBusinessDetailView(businessID: business.id, service: nil) } label: {
                            SpotlyBusinessCard(
                                business: business,
                                saved: appState.saved.isBusinessSaved(business.id),
                                onSave: { Task { await appState.saved.toggleBusiness(business, user: appState.currentUser) } }
                            )
                            .frame(width: 250)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .scrollTargetLayout()
                .padding(.vertical, 2)
            }
            .contentMargins(.horizontal, 2, for: .scrollContent)
            .scrollTargetBehavior(.viewAligned)
        }
    }

    private var feedsAreEmpty: Bool {
        [SpotlyServiceKind.eat, .shop, .book, .events].allSatisfy {
            let feed = appState.marketplace.feeds[$0]
            return (feed?.businesses.isEmpty ?? true) && (feed?.items.isEmpty ?? true)
        }
    }

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        let word = hour < 12 ? "Good morning" : hour < 17 ? "Good afternoon" : "Good evening"
        return "\(word), \(appState.displayName)"
    }
}

private struct ServiceTile: View {
    let service: SpotlyServiceKind
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dynamicTypeSize) private var dynamicType

    private var tileBackground: Color {
        let light: String
        let dark: String
        switch service {
        case .eat: (light, dark) = ("FFF0DD", "422913")
        case .shop: (light, dark) = ("E4F6ED", "15372B")
        case .ride: (light, dark) = ("E8F0FF", "192F50")
        case .book: (light, dark) = ("F0EAFB", "2E2045")
        case .events: (light, dark) = ("FFEAF0", "491B30")
        case .send: (light, dark) = ("F2E9FF", "302045")
        }
        return .adaptive(light: light, dark: dark)
    }

    private var headingColor: Color {
        let hex: String
        switch service {
        case .eat: hex = "853A0D"
        case .shop: hex = "07633D"
        case .ride: hex = "1C4F9D"
        case .book: hex = "6633A9"
        case .events: hex = "A51450"
        case .send: hex = "6832A9"
        }
        return colorScheme == .dark ? .white : Color(hex: hex)
    }

    var body: some View {
        GeometryReader { proxy in
            let isNarrow = proxy.size.width < 205
            ZStack(alignment: .topLeading) {
                tileBackground

                Image(service.artworkName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: proxy.size.width * (isNarrow ? 0.76 : 0.62),
                           height: proxy.size.height * 0.75)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
                    .offset(x: isNarrow ? 8 : 4, y: -3)
                    .accessibilityHidden(true)

                LinearGradient(
                    colors: [tileBackground.opacity(0.58), tileBackground.opacity(0.03)],
                    startPoint: .leading, endPoint: .trailing
                )
                VStack(alignment: .leading, spacing: 5) {
                    Text(service.title)
                        .font(.system(size: isNarrow ? 25 : 28, weight: .bold, design: .rounded))
                        .foregroundStyle(headingColor)
                    Spacer(minLength: 8)
                    Text(service.subtitle)
                        .font(SpotlyFont.caption(.semibold))
                        .foregroundStyle(headingColor)
                        .lineLimit(3)
                        .frame(maxWidth: isNarrow ? 106 : 145, alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)
                    HStack {
                        Spacer()
                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(headingColor)
                            .frame(width: 32, height: 32)
                            .background(.white.opacity(colorScheme == .dark ? 0.12 : 0.55), in: Circle())
                    }
                }
                .padding(16)
            }
        }
        .frame(height: dynamicType.isAccessibilitySize ? 214 : 190)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .strokeBorder(service.tint.opacity(0.12), lineWidth: 1)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Spotly \(service.title). \(service.subtitle)")
        .accessibilityAddTraits(.isButton)
    }
}
