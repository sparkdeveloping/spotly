import SwiftUI

struct ProfileView: View {
    @Environment(AppState.self) private var appState
    @State private var navPath: [AppRoute] = []
    @State private var showEditProfile = false
    @State private var showSignOutConfirmation = false
    @State private var showResetConfirmation = false
    @State private var bookingFeedback: BookingFeedback?

    private let showInternalTools = false
    private var user: SpotlyUser { appState.currentUser ?? SpotlyUser.preview }

    var body: some View {
        @Bindable var state = appState
        NavigationStack(path: $navPath) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    profileHeader
                    statsRow
                    Divider()
                    menuSection(title: "Activity", items: [
                        ProfileMenuItem(icon: "bag.fill",             label: "My Orders",    color: SpotlyColors.accent,        route: .myOrders),
                        ProfileMenuItem(icon: "calendar.badge.checkmark", label: "My Bookings", color: SpotlyColors.info,       route: .profileSection(.bookings)),
                        ProfileMenuItem(icon: "star.fill",            label: "My Reviews",   color: SpotlyColors.ratingGold,    route: .myReviews),
                        ProfileMenuItem(icon: "heart.fill",           label: "Favourites",   color: SpotlyColors.favourite,     route: nil, tab: .favourites),
                    ])
                    Divider()
                    menuSection(title: "Account", items: [
                        ProfileMenuItem(icon: "location.fill",        label: "Addresses",    color: SpotlyColors.success,       route: .addresses),
                        ProfileMenuItem(icon: "creditcard.fill",      label: "Payment methods", color: SpotlyColors.info,      route: .paymentMethods, badge: "Coming soon"),
                        ProfileMenuItem(icon: "tag.fill",             label: "Promotions & offers", color: SpotlyColors.ratingGold, route: .promotions),
                        ProfileMenuItem(icon: "bell.fill",            label: "Notifications", color: SpotlyColors.coral,       route: .notifications),
                        ProfileMenuItem(icon: "location.circle.fill",  label: "City", color: SpotlyColors.accent, route: .citySelector),
                        ProfileMenuItem(icon: "slider.horizontal.3",   label: "Preferences", color: SpotlyColors.textSecondary, route: .preferences),
                    ])
                    Divider()
                    menuSection(title: "Business", items: [
                        ProfileMenuItem(icon: "storefront.fill", label: "List your business", color: SpotlyColors.accent, route: .businessInterest),
                        ProfileMenuItem(icon: "tray.full.fill", label: "Business enquiries", color: SpotlyColors.info, route: .businessEnquiries, badge: appState.businessEnquiries.isEmpty ? nil : "\(appState.businessEnquiries.count)"),
                    ])
                    Divider()
                    menuSection(title: "Support", items: [
                        ProfileMenuItem(icon: "questionmark.circle.fill", label: "Help & support", color: SpotlyColors.accent, route: .helpSupport),
                        ProfileMenuItem(icon: "person.2.fill",        label: "Invite friends", color: SpotlyColors.success,   route: .inviteFriends),
                        ProfileMenuItem(icon: "shield.fill",          label: "Privacy",      color: SpotlyColors.textSecondary, route: .privacyPolicy),
                        ProfileMenuItem(icon: "doc.text.fill",        label: "Terms",        color: SpotlyColors.textSecondary, route: .terms),
                        ProfileMenuItem(icon: "info.circle.fill",     label: "About Spotly", color: SpotlyColors.textSecondary, route: .aboutSpotly),
                    ])
                    Divider()
                    menuSection(title: "Settings", items: [
                        ProfileMenuItem(icon: "gearshape.fill", label: "Settings", color: SpotlyColors.textSecondary, route: .settings),
                    ])
                    Divider()
                    resetDemoRow
                    Divider()
                    appearanceRow(selection: $state.selectedAppearance)
                    if showInternalTools {
                        Divider()
                        teamTestingSection
                    }
                    Divider()
                    signOutButton
                    footerNote
                    SpotlyBottomSafeSpacer(extra: 40)
                }
            }
            .background(SpotlyColors.backgroundElevated)
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: AppRoute.self) { route in
                profileDestination(for: route)
            }
            .sheet(isPresented: $showEditProfile) {
                EditProfileSheet()
            }
            .sheet(item: $bookingFeedback) { item in
                SpotlyFeedbackSheet(icon: item.icon, title: item.title, message: item.message)
            }
            .confirmationDialog("Reset demo data?", isPresented: $showResetConfirmation, titleVisibility: .visible) {
                Button("Reset demo data", role: .destructive) { appState.resetDemoData() }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Clears local demo activity and restores default sample data.")
            }
            .confirmationDialog(appState.isGuestMode ? "Leave guest mode?" : "Sign out?", isPresented: $showSignOutConfirmation, titleVisibility: .visible) {
                Button(appState.isGuestMode ? "Leave guest mode" : "Sign out", role: .destructive) {
                    appState.signOut()
                }
                Button("Cancel", role: .cancel) {}
            }
        }
    }

    @ViewBuilder
    private func profileDestination(for route: AppRoute) -> some View {
        Group {
            switch route {
            case .profileSection(.bookings): MyBookingsView()
            case .bookingDetail(let id):
                if let booking = appState.bookings.first(where: { $0.id == id }) {
                    BookingDetailView(booking: booking, onFeedback: { bookingFeedback = $0 }, onCancel: { appState.cancelBooking($0) })
                } else {
                    SpotlyComingSoonView(title: "Booking unavailable", message: "This booking could not be loaded.", icon: "calendar.badge.exclamationmark")
                }
        case .myOrders:       MyOrdersView()
        case .myReviews:      MyReviewsView()
        case .addresses:      AddressesView()
        case .paymentMethods: PaymentMethodsView()
        case .promotions:     PromotionsView()
        case .notifications:  NotificationsView()
        case .helpSupport:    HelpSupportView()
        case .inviteFriends:  InviteFriendsView()
        case .privacyPolicy:  PrivacyPolicyView()
        case .aboutSpotly:    AboutSpotlyView()
        case .settings:       SettingsView()
        case .citySelector:   CitySelectorView()
        case .businessInterest: BusinessInterestScreen()
        case .businessEnquiries: BusinessEnquiriesView()
        case .terms:          TermsView()
            case .preferences:    PreferencesView()
            default:              SpotlyComingSoonView()
            }
        }
        .toolbar(.hidden, for: .tabBar)
    }

    // MARK: - Profile header

    private var profileHeader: some View {
        VStack(spacing: SpotlySpacing.sm) {
            ZStack {
                Circle()
                    .fill(SpotlyColors.accent)
                    .frame(width: 80, height: 80)
                Text(String(user.firstName.prefix(1)).uppercased())
                    .font(SpotlyFont.title(.bold))
                    .foregroundStyle(.white)
            }
            VStack(spacing: SpotlySpacing.xxs) {
                HStack(spacing: SpotlySpacing.xxs) {
                    Text(user.name)
                        .font(SpotlyFont.title3(.bold))
                        .foregroundStyle(SpotlyColors.textPrimary)
                    if user.isVerified {
                        Image(systemName: "checkmark.seal.fill")
                            .font(SpotlyFont.callout())
                            .foregroundStyle(SpotlyColors.success)
                    }
                }
                Text(user.email)
                    .font(SpotlyFont.callout())
                    .foregroundStyle(SpotlyColors.textSecondary)
                Text(appState.selectedCity + ", Zimbabwe")
                    .font(SpotlyFont.caption())
                    .foregroundStyle(SpotlyColors.textTertiary)
            }
            Button { showEditProfile = true } label: {
                Text("Edit profile")
                    .font(SpotlyFont.caption(.semibold))
                    .foregroundStyle(SpotlyColors.accent)
                    .padding(.horizontal, SpotlySpacing.md)
                    .padding(.vertical, SpotlySpacing.xxs)
                    .overlay { Capsule().stroke(SpotlyColors.borderAccent, lineWidth: 1) }
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity)
        .padding(SpotlySpacing.xl)
        .background(SpotlyColors.surface)
    }

    // MARK: - Stats row

    private var statsRow: some View {
        HStack(spacing: 0) {
            statCell(value: "\(appState.bookings.count)", label: "Bookings")
            Divider().frame(height: 36)
            statCell(value: "\(appState.favouriteIDs.count)", label: "Favourites")
            Divider().frame(height: 36)
            statCell(value: "\(appState.userReviews.count)", label: "Reviews")
        }
        .padding(.vertical, SpotlySpacing.md)
        .background(SpotlyColors.surface)
    }

    private func statCell(value: String, label: String) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(SpotlyFont.title3(.bold))
                .foregroundStyle(SpotlyColors.accent)
            Text(label)
                .font(SpotlyFont.micro())
                .foregroundStyle(SpotlyColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Menu sections

    private func menuSection(title: String, items: [ProfileMenuItem]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title.uppercased())
                .font(SpotlyFont.nano(.semibold))
                .foregroundStyle(SpotlyColors.textTertiary)
                .tracking(0.8)
                .padding(.horizontal, SpotlySpacing.screenPadding)
                .padding(.top, SpotlySpacing.md)
                .padding(.bottom, SpotlySpacing.xs)
            VStack(spacing: 0) {
                ForEach(Array(items.enumerated()), id: \.offset) { idx, item in
                    profileMenuRow(item)
                    if idx < items.count - 1 {
                        Divider().padding(.leading, 52)
                    }
                }
            }
            .background(SpotlyColors.surface)
        }
    }

    private func profileMenuRow(_ item: ProfileMenuItem) -> some View {
        Button {
            SpotlyHaptics.lightTap()
            if let route = item.route {
                navPath.append(route)
            } else if let tab = item.tab {
                appState.selectedTab = tab
            }
        } label: {
            HStack(spacing: SpotlySpacing.md) {
                ZStack {
                    RoundedRectangle(cornerRadius: SpotlyRadius.xs)
                        .fill(item.color.opacity(0.12))
                        .frame(width: 32, height: 32)
                    Image(systemName: item.icon)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(item.color)
                }
                Text(item.label)
                    .font(SpotlyFont.callout())
                    .foregroundStyle(SpotlyColors.textPrimary)
                Spacer()
                if let badge = item.badge {
                    Text(badge)
                        .font(SpotlyFont.nano(.semibold))
                        .foregroundStyle(SpotlyColors.textTertiary)
                        .padding(.horizontal, SpotlySpacing.xxs)
                        .padding(.vertical, 2)
                        .background(SpotlyColors.backgroundElevated)
                        .clipShape(Capsule())
                }
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(SpotlyColors.textTertiary)
            }
            .padding(.horizontal, SpotlySpacing.screenPadding)
            .padding(.vertical, SpotlySpacing.sm)
            .frame(minHeight: 56)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    // MARK: - Appearance row

    private func appearanceRow(selection: Binding<String>) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: SpotlySpacing.md) {
                ZStack {
                    RoundedRectangle(cornerRadius: SpotlyRadius.xs)
                        .fill(SpotlyColors.textSecondary.opacity(0.12))
                        .frame(width: 32, height: 32)
                    Image(systemName: "circle.lefthalf.filled")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(SpotlyColors.textSecondary)
                }
                Text("Appearance")
                    .font(SpotlyFont.callout())
                    .foregroundStyle(SpotlyColors.textPrimary)
                Spacer()
                SpotlyAppearancePicker(selection: selection)
            }
            .padding(.horizontal, SpotlySpacing.screenPadding)
            .padding(.vertical, SpotlySpacing.sm)
        }
        .background(SpotlyColors.surface)
    }

    // MARK: - Reset demo data

    private var resetDemoRow: some View {
        Button {
            SpotlyHaptics.medium()
            showResetConfirmation = true
        } label: {
            HStack(spacing: SpotlySpacing.md) {
                ZStack {
                    RoundedRectangle(cornerRadius: SpotlyRadius.xs)
                        .fill(SpotlyColors.warning.opacity(0.12))
                        .frame(width: 32, height: 32)
                    Image(systemName: "arrow.counterclockwise.circle.fill")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(SpotlyColors.warning)
                }
                Text("Reset demo data")
                    .font(SpotlyFont.callout())
                    .foregroundStyle(SpotlyColors.textPrimary)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(SpotlyColors.textTertiary)
            }
            .padding(.horizontal, SpotlySpacing.screenPadding)
            .padding(.vertical, SpotlySpacing.sm)
        }
        .buttonStyle(.plain)
        .background(SpotlyColors.surface)

    }

    // MARK: - Team testing

    private var teamTestingSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("TEAM TESTING")
                .font(SpotlyFont.nano(.semibold))
                .foregroundStyle(SpotlyColors.textTertiary)
                .tracking(0.8)
                .padding(.horizontal, SpotlySpacing.screenPadding)
                .padding(.top, SpotlySpacing.md)
                .padding(.bottom, SpotlySpacing.xs)
            VStack(spacing: 0) {
                testingRow(icon: "arrow.counterclockwise", label: "Reset onboarding", color: SpotlyColors.warning) {
                    appState.resetOnboarding()
                }
                Divider().padding(.leading, 52)
                testingRow(icon: "person.crop.circle.badge.xmark", label: "Reset entry flow", color: SpotlyColors.coral) {
                    appState.resetEntryFlow()
                }
                Divider().padding(.leading, 52)
                testingRow(icon: "trash.fill", label: "Clear bookings & favourites", color: SpotlyColors.error) {
                    appState.clearLocalBookingsAndFavourites()
                }
            }
            .background(SpotlyColors.surface)
        }
    }

    private func testingRow(icon: String, label: String, color: Color, action: @escaping () -> Void) -> some View {
        Button {
            SpotlyHaptics.lightTap()
            action()
        } label: {
            HStack(spacing: SpotlySpacing.md) {
                ZStack {
                    RoundedRectangle(cornerRadius: SpotlyRadius.xs)
                        .fill(color.opacity(0.12))
                        .frame(width: 32, height: 32)
                    Image(systemName: icon)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(color)
                }
                Text(label)
                    .font(SpotlyFont.callout())
                    .foregroundStyle(SpotlyColors.textPrimary)
                Spacer()
            }
            .padding(.horizontal, SpotlySpacing.screenPadding)
            .padding(.vertical, SpotlySpacing.sm)
            .frame(minHeight: 56)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    // MARK: - Sign out

    private var signOutButton: some View {
        Button {
            SpotlyHaptics.medium()
            showSignOutConfirmation = true
        } label: {
            Text(appState.isGuestMode ? "Leave guest mode" : "Sign out")
                .font(SpotlyFont.callout(.semibold))
                .foregroundStyle(SpotlyColors.error)
                .frame(maxWidth: .infinity)
                .padding(.vertical, SpotlySpacing.sm)
        }
        .buttonStyle(.plain)
        .background(SpotlyColors.surface)
        .padding(.top, SpotlySpacing.sm)
    }

    // MARK: - Footer

    private var footerNote: some View {
        VStack(spacing: SpotlySpacing.xxs) {
            Text("Spotly · Zimbabwe's premier lifestyle app")
                .font(SpotlyFont.micro())
                .foregroundStyle(SpotlyColors.textTertiary)
            Text("Version 1.0 · Build 2")
                .font(SpotlyFont.micro())
                .foregroundStyle(SpotlyColors.textTertiary)
        }
        .multilineTextAlignment(.center)
        .padding(.vertical, SpotlySpacing.xl)
    }
}

private struct ProfileMenuItem {
    let icon: String
    let label: String
    let color: Color
    var route: AppRoute? = nil
    var tab: AppTab? = nil
    var badge: String? = nil
}
