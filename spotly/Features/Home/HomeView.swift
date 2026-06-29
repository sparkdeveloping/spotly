import SwiftUI

struct HomeView: View {
    @Environment(AppState.self) private var appState
    @State private var businesses: [SpotlyBusiness] = []
    @State private var events: [SpotlyEvent] = []
    @State private var isLoading = true
    @State private var showCitySelector = false
    @State private var showNotifications = false
    @State private var bookingFeedback: BookingFeedback?

    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 12 { return "Good morning" }
        if hour < 17 { return "Good afternoon" }
        return "Good evening"
    }

    var firstName: String { appState.displayName }

    // Top categories for squircle quick-action row (matches brief priority order)
    private let topCategoryIDs = ["groceries", "food", "events", "restaurants", "pharmacy", "wellnessSpa", "beauty", "activities"]

    var body: some View {
        @Bindable var state = appState
        NavigationStack(path: $state.homeNavPath) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    topBar
                    searchAffordance
                    squircleCategoryRow
                    Divider().padding(.top, SpotlySpacing.sm)
                    if isLoading { skeletonContent } else { mainContent }
                    SpotlyBottomSafeSpacer(extra: 56)
                }
            }
            .background(SpotlyColors.background)
            .navigationBarHidden(true)
            .navigationDestination(for: AppRoute.self) { route in
                destinationView(for: route)
            }
            .sheet(isPresented: $showCitySelector) {
                CityPickerSheet(selectedCity: appState.selectedCity) { city in
                    appState.selectedCity = city
                    showCitySelector = false
                }
            }
            .sheet(isPresented: $showNotifications) {
                NavigationStack { NotificationsView() }
            }
            .sheet(item: $bookingFeedback) { item in
                SpotlyFeedbackSheet(icon: item.icon, title: item.title, message: item.message)
            }
            .task { await loadData() }
        }
    }

    // MARK: - Top bar

    private var topBar: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 2) {
                Text("\(greeting), \(firstName)")
                    .font(SpotlyFont.headline())
                    .foregroundStyle(SpotlyColors.textPrimary)
                Button {
                    SpotlyHaptics.lightTap()
                    showCitySelector = true
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(SpotlyColors.accent)
                        Text("\(appState.selectedCity), Zimbabwe")
                            .font(SpotlyFont.callout())
                            .foregroundStyle(SpotlyColors.textSecondary)
                        Image(systemName: "chevron.down")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundStyle(SpotlyColors.textTertiary)
                    }
                }
                .buttonStyle(.plain)
            }
            Spacer()
            Button {
                SpotlyHaptics.lightTap()
                showNotifications = true
            } label: {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: "bell")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(SpotlyColors.textPrimary)
                        .frame(width: 40, height: 40)
                    Circle()
                        .fill(SpotlyColors.accent)
                        .frame(width: 8, height: 8)
                        .offset(x: 2, y: 2)
                }
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, SpotlySpacing.screenPadding)
        .padding(.top, SpotlySpacing.lg)
        .padding(.bottom, SpotlySpacing.sm)
    }

    // MARK: - Search affordance

    private var searchAffordance: some View {
        Button {
            SpotlyHaptics.lightTap()
            appState.selectedTab = .search
        } label: {
            HStack(spacing: SpotlySpacing.sm) {
                Image(systemName: "magnifyingglass")
                    .font(SpotlyFont.callout(.semibold))
                    .foregroundStyle(SpotlyColors.textTertiary)
                Text("Search restaurants, groceries, events, experiences...")
                    .font(SpotlyFont.callout())
                    .foregroundStyle(SpotlyColors.textTertiary)
                Spacer()
            }
            .padding(.horizontal, SpotlySpacing.md)
            .frame(height: 48)
            .background(SpotlyColors.backgroundElevated)
            .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.sm, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: SpotlyRadius.sm, style: .continuous)
                    .stroke(SpotlyColors.border, lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .padding(.horizontal, SpotlySpacing.screenPadding)
        .padding(.bottom, SpotlySpacing.md)
    }

    // MARK: - Squircle category row

    private var squircleCategoryRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: SpotlySpacing.md) {
                // Top priority categories
                ForEach(topCategoryIDs, id: \.self) { catID in
                    if let cat = SpotlyCategory.all.first(where: { $0.id == catID }) {
                        SquircleCategoryButton(category: cat) {
                            SpotlyHaptics.selection()
                            appState.homeNavPath.append(AppRoute.category(cat.id))
                        }
                    }
                }
                // More button
                SquircleCategoryButton(
                    icon: "square.grid.2x2.fill",
                    label: "More",
                    color: SpotlyColors.textSecondary
                ) {
                    SpotlyHaptics.selection()
                    appState.homeNavPath.append(AppRoute.exploreCategories)
                }
            }
            .padding(.horizontal, SpotlySpacing.screenPadding)
            .padding(.vertical, SpotlySpacing.sm)
        }
    }

    // MARK: - Loading skeleton

    private var skeletonContent: some View {
        VStack(spacing: SpotlySpacing.sectionGap) {
            ForEach(0..<3, id: \.self) { _ in
                VStack(alignment: .leading, spacing: SpotlySpacing.md) {
                    HStack {
                        Capsule().fill(SpotlyColors.surfaceElevated).frame(width: 140, height: 16).shimmer()
                        Spacer()
                        Capsule().fill(SpotlyColors.surfaceElevated).frame(width: 50, height: 12).shimmer()
                    }
                    .padding(.horizontal, SpotlySpacing.screenPadding)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: SpotlySpacing.itemGap) {
                            ForEach(0..<3, id: \.self) { _ in
                                SpotlySkeletonListingCard().frame(width: 220)
                            }
                        }
                        .padding(.horizontal, SpotlySpacing.screenPadding)
                    }
                }
            }
        }
        .padding(.top, SpotlySpacing.sectionGap)
    }

    // MARK: - Main content

    private var mainContent: some View {
        VStack(spacing: SpotlySpacing.sectionGap) {
            featuredBanner
            continueSection
            businessSection(
                title: "Popular near you",
                subtitle: "Top-rated places in \(appState.selectedCity)",
                businesses: Array(businesses.sorted { $0.rating > $1.rating }.prefix(6)),
                seeAllCategoryID: nil
            )
            foodSection
            groceriesSection
            eventsSection
            businessSection(
                title: "Beauty & wellness",
                businesses: businesses.filter { ["wellnessSpa", "beauty"].contains($0.categoryID) },
                seeAllCategoryID: "wellnessSpa"
            )
            businessSection(
                title: "Padel, gyms & activities",
                businesses: businesses.filter { ["padel", "gyms", "activities", "staycations"].contains($0.categoryID) },
                seeAllCategoryID: "activities"
            )
            weekendBanner
            businessSection(
                title: "Offers",
                subtitle: "Launch partner deals",
                businesses: businesses.filter { $0.categoryID == "offers" },
                seeAllCategoryID: "offers"
            )
            businessSection(
                title: "New on Spotly",
                subtitle: "Recently added",
                businesses: Array(businesses.shuffled().prefix(4)),
                seeAllCategoryID: nil
            )
        }
        .padding(.top, SpotlySpacing.sectionGap)
    }

    private var continueSection: some View {
        Group {
            if !appState.upcomingBookings.isEmpty {
                VStack(alignment: .leading, spacing: SpotlySpacing.md) {
                    SpotlySectionHeader(title: "Continue planning", subtitle: "Your upcoming reservations") {
                        withAnimation { appState.selectedTab = .bookings }
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: SpotlySpacing.itemGap) {
                            ForEach(appState.upcomingBookings.prefix(3)) { booking in
                                Button {
                                    appState.homeNavPath.append(AppRoute.bookingDetail(booking.id))
                                } label: {
                                    HStack(spacing: SpotlySpacing.sm) {
                                        ZStack {
                                            SpotlyGradients.forCategoryID(booking.gradientKey)
                                            Image(systemName: "calendar.badge.checkmark")
                                                .font(.system(size: 18, weight: .medium))
                                                .foregroundStyle(.white.opacity(0.85))
                                        }
                                        .frame(width: 52, height: 52)
                                        .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.sm, style: .continuous))
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(booking.businessName)
                                                .font(SpotlyFont.callout(.semibold))
                                                .foregroundStyle(SpotlyColors.textPrimary)
                                                .lineLimit(1)
                                            Text(booking.serviceName)
                                                .font(SpotlyFont.caption())
                                                .foregroundStyle(SpotlyColors.textSecondary)
                                                .lineLimit(1)
                                            Text(booking.formattedDate + " · " + booking.time)
                                                .font(SpotlyFont.micro(.semibold))
                                                .foregroundStyle(SpotlyColors.accent)
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 11, weight: .semibold))
                                            .foregroundStyle(SpotlyColors.textTertiary)
                                    }
                                    .padding(SpotlySpacing.cardPadding)
                                    .background(SpotlyColors.surface)
                                    .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.md, style: .continuous))
                                    .overlay { RoundedRectangle(cornerRadius: SpotlyRadius.md).stroke(SpotlyColors.border, lineWidth: 0.5) }
                                }
                                .buttonStyle(.plain)
                                .pressableScale(scale: 0.985)
                                .frame(width: 280)
                            }
                        }
                        .padding(.horizontal, SpotlySpacing.screenPadding)
                    }
                }
            }
        }
    }

    private var featuredBanner: some View {
        Group {
            if let featured = businesses.first(where: { $0.isFeatured }) ?? businesses.first {
                Button {
                    appState.homeNavPath.append(AppRoute.placeDetail(featured.id))
                } label: {
                    ZStack(alignment: .bottomLeading) {
                        SpotlyImageView(imageName: featured.heroImageName ?? featured.cardImageName, categoryID: featured.categoryID, style: .hero)
                            .frame(height: 188)
                        Rectangle()
                            .fill(SpotlyGradients.heroOverlay)
                        VStack(alignment: .leading, spacing: SpotlySpacing.xxs) {
                            Text("FEATURED")
                                .font(SpotlyFont.nano(.semibold))
                                .foregroundStyle(SpotlyColors.accentLight)
                                .tracking(1.5)
                            Text(featured.name)
                                .font(SpotlyFont.title3(.bold))
                                .foregroundStyle(.white)
                                .lineLimit(1)
                            Text(featured.tagline)
                                .font(SpotlyFont.caption())
                                .foregroundStyle(.white.opacity(0.80))
                                .lineLimit(1)
                        }
                        .padding(SpotlySpacing.md)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.md, style: .continuous))
                }
                .buttonStyle(.plain)
                .pressableScale(scale: 0.98)
                .padding(.horizontal, SpotlySpacing.screenPadding)
            }
        }
    }

    private var foodSection: some View {
        let foodBiz = businesses.filter { ["restaurants", "cafes", "takeaways"].contains($0.categoryID) }
        return businessSection(
            title: "Food & dining",
            subtitle: "Restaurants and cafes near you",
            businesses: foodBiz,
            seeAllCategoryID: "restaurants",
            isHighlighted: true
        )
    }

    private var groceriesSection: some View {
        let groceryBiz = businesses.filter { $0.categoryID == "groceries" }
        return Group {
            if !groceryBiz.isEmpty {
                VStack(alignment: .leading, spacing: SpotlySpacing.md) {
                    SpotlySectionHeader(title: "Groceries", subtitle: "Premium stores near you") {
                        if let cat = category(for: "groceries") {
                            appState.homeNavPath.append(AppRoute.category(cat.id))
                        }
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: SpotlySpacing.itemGap) {
                            ForEach(groceryBiz) { biz in
                                SpotlyListingCard(
                                    business: biz,
                                    isFavourited: appState.isFavourited(biz.id),
                                    onFavourite: { appState.toggleFavourite(biz.id) }
                                ) {
                                    appState.homeNavPath.append(AppRoute.placeDetail(biz.id))
                                }
                                .frame(width: 240)
                            }
                        }
                        .padding(.horizontal, SpotlySpacing.screenPadding)
                        .padding(.vertical, 2)
                    }
                }
            } else {
                EmptyView()
            }
        }
    }

    private var eventsSection: some View {
        VStack(alignment: .leading, spacing: SpotlySpacing.md) {
            SpotlySectionHeader(title: "Events this week", subtitle: "Concerts, markets & more") {
                if let cat = category(for: "events") {
                    appState.homeNavPath.append(AppRoute.category(cat.id))
                }
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: SpotlySpacing.itemGap) {
                    ForEach(events) { event in
                        SpotlyEventCard(event: event) {
                            appState.homeNavPath.append(AppRoute.eventDetail(event))
                        }
                    }
                }
                .padding(.horizontal, SpotlySpacing.screenPadding)
            }
        }
    }

    private func businessSection(title: String, subtitle: String? = nil, businesses: [SpotlyBusiness], seeAllCategoryID: String?, isHighlighted: Bool = false) -> some View {
        Group {
            if !businesses.isEmpty {
                VStack(alignment: .leading, spacing: SpotlySpacing.md) {
                    SpotlySectionHeader(title: title, subtitle: subtitle) {
                        if let id = seeAllCategoryID, let cat = category(for: id) {
                            appState.homeNavPath.append(AppRoute.category(cat.id))
                        } else {
                            appState.selectedTab = .search
                        }
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: SpotlySpacing.itemGap) {
                            ForEach(businesses) { biz in
                                SpotlyListingCard(
                                    business: biz,
                                    isFavourited: appState.isFavourited(biz.id),
                                    onFavourite: { appState.toggleFavourite(biz.id) }
                                ) {
                                    appState.homeNavPath.append(AppRoute.placeDetail(biz.id))
                                }
                                .frame(width: 240)
                            }
                        }
                        .padding(.horizontal, SpotlySpacing.screenPadding)
                        .padding(.vertical, 2)
                    }
                }
            }
        }
    }

    private var weekendBanner: some View {
        Button {
            if let cat = category(for: "events") {
                appState.homeNavPath.append(AppRoute.category(cat.id))
            }
        } label: {
            ZStack(alignment: .bottomLeading) {
                SpotlyImageView(imageName: SpotlySampleImages.imageName(for: "nightlife"), categoryID: "nightlife", style: .card)
                    .frame(height: 130)
                Rectangle().fill(SpotlyGradients.heroOverlay)
                VStack(alignment: .leading, spacing: 2) {
                    Text("WEEKEND PICKS")
                        .font(SpotlyFont.nano(.semibold))
                        .foregroundStyle(SpotlyColors.accentLight)
                        .tracking(1.5)
                    Text("The best plans for Saturday & Sunday.")
                        .font(SpotlyFont.headline(.bold))
                        .foregroundStyle(.white)
                }
                .padding(SpotlySpacing.md)
            }
            .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.md, style: .continuous))
        }
        .buttonStyle(.plain)
        .pressableScale(scale: 0.97)
        .padding(.horizontal, SpotlySpacing.screenPadding)
    }

    // MARK: - Navigation destinations

    @ViewBuilder
    private func destinationView(for route: AppRoute) -> some View {
        switch route {
        case .placeDetail(let id):
            if let biz = MockBusinesses.all.first(where: { $0.id == id }) {
                BusinessDetailView(business: biz)
            } else {
                SpotlyComingSoonView(title: "Place not found", message: "This listing could not be loaded. Try exploring nearby places.", icon: "mappin.slash")
            }
        case .category(let id):
            CategoryLandingScreen(categoryID: id)
        case .menu(let id):
            if let biz = MockBusinesses.all.first(where: { $0.id == id }) {
                RestaurantMenuView(business: biz)
            } else {
                SpotlyComingSoonView(title: "Menu not available", message: "Open a place detail to browse its menu.", icon: "list.bullet")
            }
        case .bookingFlowID(let id):
            if let biz = MockBusinesses.all.first(where: { $0.id == id }) {
                BookingFlowView(business: biz)
            } else {
                SpotlyComingSoonView(title: "Booking unavailable", message: "Open a place detail to start a booking.", icon: "calendar")
            }
        case .bookingDetail(let id):
            if let booking = appState.bookings.first(where: { $0.id == id }) {
                BookingDetailView(booking: booking, onFeedback: { bookingFeedback = $0 }, onCancel: { appState.cancelBooking($0) })
                    .toolbar(.hidden, for: .tabBar)
            } else {
                SpotlyComingSoonView(title: "Booking unavailable", message: "This booking could not be loaded. It may have been cancelled or reset.", icon: "calendar.badge.exclamationmark")
            }
        case .checkout:
            SpotlyComingSoonView(title: "Checkout", message: "Start checkout from a menu or shop cart so Spotly can carry your selected items.", icon: "cart")
        case .profileSection:
            SpotlyComingSoonView()
        case .businessDetail(let biz):
            BusinessDetailView(business: biz)
        case .categoryDiscover(let cat):
            CategoryLandingScreen(categoryID: cat.id)
        case .exploreCategories:
            ExploreCategoriesView { cat in
                appState.homeNavPath.append(AppRoute.category(cat.id))
            }
        case .bookingFlow(let biz):
            BookingFlowView(business: biz)
        case .bookingConfirmation(let booking):
            BookingConfirmationView(booking: booking)
        case .eventDetail(let event):
            EventDetailView(event: event)
        case .restaurantMenu(let biz):
            RestaurantMenuView(business: biz)
        case .myOrders:
            MyOrdersView()
        case .myReviews:
            MyReviewsView()
        case .addresses:
            AddressesView()
        case .paymentMethods:
            PaymentMethodsView()
        case .promotions:
            PromotionsView()
        case .notifications:
            NotificationsView()
        case .helpSupport:
            HelpSupportView()
        case .inviteFriends:
            InviteFriendsView()
        case .privacyPolicy:
            PrivacyPolicyView()
        case .aboutSpotly:
            AboutSpotlyView()
        case .settings:
            SettingsView()
        case .citySelector:
            CitySelectorView()
        case .businessInterest:
            BusinessInterestScreen()
        case .businessEnquiries:
            BusinessEnquiriesView()
        case .terms:
            TermsView()
        case .preferences:
            PreferencesView()
        }
    }

    private func category(for id: String) -> SpotlyCategory? {
        SpotlyCategory.all.first { $0.id == id }
    }

    private func loadData() async {
        isLoading = true
        async let b = (try? await appState.listingRepo.fetchBusinesses()) ?? []
        async let e = (try? await appState.listingRepo.fetchEvents()) ?? []
        businesses = await b
        events     = await e
        withAnimation(SpotlyMotion.cardEntrance) { isLoading = false }
    }
}

// MARK: - Squircle category button

private struct SquircleCategoryButton: View {
    var category: SpotlyCategory? = nil
    var icon: String = ""
    var label: String = ""
    var color: Color = SpotlyColors.accent
    var onTap: () -> Void

    init(category: SpotlyCategory, onTap: @escaping () -> Void) {
        self.category = category
        self.icon = category.icon
        self.label = category.name
        self.color = SpotlyColors.accent
        self.onTap = onTap
    }

    init(icon: String, label: String, color: Color, onTap: @escaping () -> Void) {
        self.icon = icon
        self.label = label
        self.color = color
        self.onTap = onTap
    }

    var body: some View {
        Button(action: { SpotlyHaptics.selection(); onTap() }) {
            VStack(spacing: SpotlySpacing.xs) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(SpotlyColors.accentBg)
                        .frame(width: 72, height: 72)
                        .overlay {
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(SpotlyColors.borderAccent, lineWidth: 1)
                        }
                    Image(systemName: icon)
                        .font(.system(size: 22, weight: .medium))
                        .foregroundStyle(SpotlyColors.accent)
                }
                Text(label)
                    .font(SpotlyFont.micro(.medium))
                    .foregroundStyle(SpotlyColors.textSecondary)
                    .lineLimit(1)
            }
            .frame(width: 80)
        }
        .buttonStyle(.plain)
        .pressableScale(scale: 0.94)
    }
}

// MARK: - Notifications placeholder sheet

private struct NotificationsPlaceholderSheet: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: SpotlySpacing.xl) {
                Spacer()
                Image(systemName: "bell.badge")
                    .font(.system(size: 52, weight: .light))
                    .foregroundStyle(SpotlyColors.accent.opacity(0.7))
                VStack(spacing: SpotlySpacing.xs) {
                    Text("Notifications")
                        .font(SpotlyFont.title3(.bold))
                        .foregroundStyle(SpotlyColors.textPrimary)
                    Text("Your booking confirmations and updates will appear here. Push notifications are coming soon.")
                        .font(SpotlyFont.callout())
                        .foregroundStyle(SpotlyColors.textSecondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(3)
                }
                Spacer()
            }
            .padding(SpotlySpacing.xl)
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}

// MARK: - City picker sheet

private struct CityPickerSheet: View {
    let selectedCity: String
    var onSelect: (String) -> Void
    private let cities = ["Harare", "Bulawayo", "Victoria Falls", "Mutare", "Gweru", "Other"]

    var body: some View {
        NavigationStack {
            List {
                ForEach(cities, id: \.self) { city in
                    Button {
                        SpotlyHaptics.selection()
                        onSelect(city)
                    } label: {
                        HStack {
                            Text(city)
                                .foregroundStyle(SpotlyColors.textPrimary)
                            Spacer()
                            if city == selectedCity {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(SpotlyColors.accent)
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .navigationTitle("Choose city")
            .navigationBarTitleDisplayMode(.inline)
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}
