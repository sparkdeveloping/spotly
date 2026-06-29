import SwiftUI

struct BusinessDetailView: View {
    let business: SpotlyBusiness
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @State private var showBooking = false
    @State private var showMenu = false
    @State private var showFeedback: DetailFeedback?
    @State private var showReviewSheet = false
    @State private var showBusinessInterest = false
    @State private var scrollOffset: CGFloat = 0

    private let scrollSpace = "BusinessDetailScroll"

    var isFav: Bool { appState.isFavourited(business.id) }
    var showsCatalog: Bool { ["restaurants", "cafes", "takeaways", "groceries", "pharmacy", "flowersGifts"].contains(business.categoryID) }
    var showsBooking: Bool { !["groceries", "pharmacy", "flowersGifts", "offers"].contains(business.categoryID) }

    var catalogTitle: String {
        switch business.categoryID {
        case "groceries": return "Shop groceries"
        case "pharmacy": return "Shop pharmacy"
        case "flowersGifts": return "Shop gifts"
        case "takeaways": return "Order food"
        default: return "View menu"
        }
    }

    var primaryActionTitle: String {
        switch business.categoryID {
        case "restaurants": return "Reserve table"
        case "cafes", "takeaways": return "View menu"
        case "groceries": return "Shop groceries"
        case "pharmacy": return "Request item"
        case "doctors": return "Book appointment"
        case "flowersGifts": return "Shop gifts"
        case "beauty": return "Book appointment"
        case "wellnessSpa": return "Book treatment"
        case "padel", "activities": return "Book activity"
        case "staycations": return "Check availability"
        case "gyms": return "Book session"
        case "nightlife": return "Request table"
        case "offers": return "View offer"
        default: return "Book now"
        }
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            SpotlyScrollOffsetReader(coordinateSpace: scrollSpace)
            VStack(alignment: .leading, spacing: 0) {
                heroSection
                contentCard
                servicesSection
                reviewsSection
                locationSection
                relatedListingsSection
                policiesSection
                SpotlyBottomSafeSpacer(extra: 100)
            }
        }
        .coordinateSpace(name: scrollSpace)
        .onPreferenceChange(SpotlyScrollOffsetPreferenceKey.self) { scrollOffset = $0 }
        .background(SpotlyColors.background)
        .ignoresSafeArea(edges: .top)
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .overlay(alignment: .top) { compactHeader }
        .safeAreaInset(edge: .bottom, spacing: 0) { bottomBar }
        .sheet(isPresented: $showBooking) {
            BookingFlowView(business: business)
        }
        .navigationDestination(isPresented: $showMenu) {
            RestaurantMenuView(business: business)
        }
        .sheet(item: $showFeedback) { item in
            SpotlyFeedbackSheet(icon: item.icon, title: item.title, message: item.message)
        }
        .sheet(isPresented: $showReviewSheet) {
            WriteReviewSheet(business: business)
        }
        .sheet(isPresented: $showBusinessInterest) {
            NavigationStack {
                BusinessInterestScreen(
                    initialBusinessName: business.name,
                    initialCategory: business.categoryName,
                    initialCity: business.location.city
                )
            }
        }
    }

    // MARK: - Hero

    private var heroSection: some View {
        StretchyHeroHeader(
            imageName: business.heroImageName,
            categoryID: business.categoryID,
            title: business.name,
            subtitle: business.location.displayName,
            categoryLabel: SpotlyCategory.all.first(where: { $0.id == business.categoryID })?.name ?? business.categoryName,
            statusLabel: business.status.displayText,
            height: 360,
            coordinateSpace: scrollSpace,
            onBack: { dismiss() },
            onShare: { shareContent() }
        )
    }

    // MARK: - Content card

    private var contentCard: some View {
        VStack(alignment: .leading, spacing: SpotlySpacing.md) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: SpotlySpacing.xxs) {
                    HStack(spacing: SpotlySpacing.xxs) {
                        Text(business.name)
                            .font(SpotlyFont.title2(.bold))
                            .foregroundStyle(SpotlyColors.textPrimary)
                        if business.isVerified {
                            SpotlyVerifiedBadge()
                        }
                    }
                    Text(business.tagline)
                        .font(SpotlyFont.callout())
                        .foregroundStyle(SpotlyColors.textSecondary)
                }
                Spacer()
                Button {
                    SpotlyHaptics.success()
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        appState.toggleFavourite(business.id)
                    }
                } label: {
                    Image(systemName: isFav ? "heart.fill" : "heart")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(isFav ? SpotlyColors.favourite : SpotlyColors.textSecondary)
                        .frame(width: 44, height: 44)
                        .background(SpotlyColors.surfaceElevated)
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }

            HStack(spacing: SpotlySpacing.md) {
                SpotlyRatingView(rating: business.rating, reviewCount: business.reviewCount)
                SpotlyPriceTag(level: business.priceLevel)
                if let d = business.distance {
                    HStack(spacing: 3) {
                        Image(systemName: "location.fill")
                            .font(SpotlyFont.micro(.semibold))
                            .foregroundStyle(SpotlyColors.accent)
                        Text(d)
                            .font(SpotlyFont.caption())
                            .foregroundStyle(SpotlyColors.textSecondary)
                    }
                }
            }

            HStack(spacing: SpotlySpacing.xs) {
                Image(systemName: "clock")
                    .font(SpotlyFont.caption())
                    .foregroundStyle(SpotlyColors.textTertiary)
                Text(business.openingHours)
                    .font(SpotlyFont.callout())
                    .foregroundStyle(SpotlyColors.textSecondary)
            }

            Divider()

            Text(business.description)
                .font(SpotlyFont.body())
                .foregroundStyle(SpotlyColors.textSecondary)
                .lineSpacing(4)

            if !business.highlights.isEmpty {
                highlightsGrid
            }
        }
        .padding(SpotlySpacing.screenPadding)
    }

    private var highlightsGrid: some View {
        VStack(alignment: .leading, spacing: SpotlySpacing.xs) {
            Text("Highlights")
                .font(SpotlyFont.headline())
                .foregroundStyle(SpotlyColors.textPrimary)
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: SpotlySpacing.xs) {
                ForEach(business.highlights, id: \.self) { h in
                    HStack(spacing: SpotlySpacing.xxs) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(SpotlyFont.caption())
                            .foregroundStyle(SpotlyColors.success)
                        Text(h)
                            .font(SpotlyFont.caption())
                            .foregroundStyle(SpotlyColors.textPrimary)
                            .lineLimit(2)
                        Spacer()
                    }
                    .padding(SpotlySpacing.xs)
                    .background(SpotlyColors.backgroundElevated)
                    .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.xs))
                }
            }
        }
    }

    // MARK: - Services

    private var servicesSection: some View {
        VStack(alignment: .leading, spacing: SpotlySpacing.sm) {
            Divider()
            Text(showsCatalog ? catalogTitle : "Services")
                .font(SpotlyFont.title3(.bold))
                .foregroundStyle(SpotlyColors.textPrimary)
                .padding(.horizontal, SpotlySpacing.screenPadding)
            VStack(spacing: SpotlySpacing.xs) {
                ForEach(business.services) { service in
                    ServiceRow(service: service)
                        .padding(.horizontal, SpotlySpacing.screenPadding)
                }
            }
        }
        .padding(.vertical, SpotlySpacing.md)
    }

    // MARK: - Reviews

    private var localReviews: [SpotlyUserReview] {
        appState.userReviews.filter { $0.placeID == business.id }
    }

    private var reviewsSection: some View {
        VStack(alignment: .leading, spacing: SpotlySpacing.md) {
            Divider()
            HStack {
                Text("Reviews")
                    .font(SpotlyFont.title3(.bold))
                    .foregroundStyle(SpotlyColors.textPrimary)
                Spacer()
                Button("Write review") { showReviewSheet = true }
                    .font(SpotlyFont.caption(.semibold))
                    .foregroundStyle(SpotlyColors.accent)
                    .padding(.horizontal, SpotlySpacing.xs)
                    .padding(.vertical, 6)
                    .background(SpotlyColors.accentBg)
                    .clipShape(Capsule())
            }
            .padding(.horizontal, SpotlySpacing.screenPadding)

            HStack(spacing: 3) {
                Image(systemName: "star.fill")
                    .font(SpotlyFont.callout(.semibold))
                    .foregroundStyle(SpotlyColors.ratingGold)
                Text(business.ratingFormatted)
                    .font(SpotlyFont.headline(.bold))
                    .foregroundStyle(SpotlyColors.textPrimary)
                Text("(\(business.reviewCount + localReviews.count))")
                    .font(SpotlyFont.callout())
                    .foregroundStyle(SpotlyColors.textSecondary)
            }
            .padding(.horizontal, SpotlySpacing.screenPadding)
            VStack(spacing: SpotlySpacing.sm) {
                ForEach(localReviews) { review in
                    LocalReviewRow(review: review)
                        .padding(.horizontal, SpotlySpacing.screenPadding)
                }
                ForEach(business.reviews) { review in
                    ReviewRow(review: review)
                        .padding(.horizontal, SpotlySpacing.screenPadding)
                }
            }
        }
        .padding(.vertical, SpotlySpacing.md)
    }

    // MARK: - Location

    private var locationSection: some View {
        VStack(alignment: .leading, spacing: SpotlySpacing.md) {
            Divider()
            Text("Location")
                .font(SpotlyFont.title3(.bold))
                .foregroundStyle(SpotlyColors.textPrimary)
                .padding(.horizontal, SpotlySpacing.screenPadding)
            ZStack {
                SpotlyColors.backgroundElevated
                VStack(spacing: SpotlySpacing.xs) {
                    Image(systemName: "map")
                        .font(.system(size: 28, weight: .light))
                        .foregroundStyle(SpotlyColors.accent.opacity(0.7))
                    Text(business.location.displayName)
                        .font(SpotlyFont.callout(.semibold))
                        .foregroundStyle(SpotlyColors.textPrimary)
                    Text(business.location.address)
                        .font(SpotlyFont.caption())
                        .foregroundStyle(SpotlyColors.textSecondary)
                }
            }
            .frame(height: 140)
            .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.md))
            .overlay {
                RoundedRectangle(cornerRadius: SpotlyRadius.md).stroke(SpotlyColors.border, lineWidth: 1)
            }
            .overlay(alignment: .bottomTrailing) {
                Button {
                    openMaps()
                } label: {
                    Label("Directions", systemImage: "arrow.triangle.turn.up.right.circle.fill")
                        .font(SpotlyFont.caption(.semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, SpotlySpacing.sm)
                        .padding(.vertical, SpotlySpacing.xxs)
                        .background(SpotlyColors.accent)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
                .padding(SpotlySpacing.sm)
            }
            .padding(.horizontal, SpotlySpacing.screenPadding)
        }
        .padding(.vertical, SpotlySpacing.md)
    }

    // MARK: - Related listings

    private var relatedListingsSection: some View {
        let related = MockBusinesses.byCategory(business.categoryID).filter { $0.id != business.id }.prefix(3)
        return Group {
            if !related.isEmpty {
                VStack(alignment: .leading, spacing: SpotlySpacing.md) {
                    Divider()
                    Text("More like this")
                        .font(SpotlyFont.title3(.bold))
                        .foregroundStyle(SpotlyColors.textPrimary)
                        .padding(.horizontal, SpotlySpacing.screenPadding)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: SpotlySpacing.itemGap) {
                            ForEach(Array(related)) { item in
                                NavigationLink(value: AppRoute.placeDetail(item.id)) {
                                    RelatedListingTile(business: item)
                                        .frame(width: 230)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, SpotlySpacing.screenPadding)
                    }
                }
                .padding(.vertical, SpotlySpacing.md)
            }
        }
    }

    // MARK: - Policies

    private var policiesSection: some View {
        VStack(alignment: .leading, spacing: SpotlySpacing.md) {
            Divider()
            Text("Good to know")
                .font(SpotlyFont.title3(.bold))
                .foregroundStyle(SpotlyColors.textPrimary)
            policyRow(icon: "xmark.circle", title: "Cancellation", value: "Cancel up to 24 hours before for a full refund")
            policyRow(icon: "creditcard", title: "Payment", value: "Secure payment · Paynow coming soon")
            policyRow(icon: "person.badge.plus", title: "Booking", value: "Instant confirmation upon booking")
            Button {
                showBusinessInterest = true
            } label: {
                HStack {
                    Label("Own this business?", systemImage: "storefront.fill")
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .font(SpotlyFont.callout(.semibold))
                .foregroundStyle(SpotlyColors.accent)
                .padding(SpotlySpacing.sm)
                .background(SpotlyColors.accentBg)
                .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.sm))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, SpotlySpacing.screenPadding)
        .padding(.vertical, SpotlySpacing.md)
    }

    private func policyRow(icon: String, title: String, value: String) -> some View {
        HStack(alignment: .top, spacing: SpotlySpacing.sm) {
            Image(systemName: icon)
                .font(SpotlyFont.callout())
                .foregroundStyle(SpotlyColors.textTertiary)
                .frame(width: 20)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(SpotlyFont.callout(.semibold)).foregroundStyle(SpotlyColors.textPrimary)
                Text(value).font(SpotlyFont.caption()).foregroundStyle(SpotlyColors.textSecondary)
            }
            Spacer()
        }
    }

    // MARK: - Compact header

    private var compactHeader: some View {
        SpotlyStickyHeader(isVisible: scrollOffset < -250, topPadding: 10) {
            HStack(spacing: SpotlySpacing.sm) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(SpotlyColors.textPrimary)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                VStack(alignment: .leading, spacing: 1) {
                    Text(business.name)
                        .font(SpotlyFont.callout(.semibold))
                        .foregroundStyle(SpotlyColors.textPrimary)
                        .lineLimit(1)
                    Text(business.location.shortDisplay)
                        .font(SpotlyFont.micro())
                        .foregroundStyle(SpotlyColors.textSecondary)
                }
                Spacer()
                Button { shareContent() } label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(SpotlyColors.textPrimary)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - Bottom bar

    private var bottomBar: some View {
        HStack(spacing: SpotlySpacing.sm) {
            if showsCatalog && showsBooking {
                Button {
                    SpotlyHaptics.medium()
                    showMenu = true
                } label: {
                    Label(catalogTitle, systemImage: "list.bullet")
                        .font(SpotlyFont.headline())
                        .foregroundStyle(SpotlyColors.accent)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(SpotlyColors.accentBg)
                        .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.sm + 2))
                        .overlay {
                            RoundedRectangle(cornerRadius: SpotlyRadius.sm + 2).stroke(SpotlyColors.borderAccent, lineWidth: 1)
                        }
                }
                .buttonStyle(.plain)
                .pressableScale()
            }
            Button {
                SpotlyHaptics.medium()
                if showsCatalog && !showsBooking {
                    showMenu = true
                } else if ["cafes", "takeaways"].contains(business.categoryID) {
                    showMenu = true
                } else if business.categoryID == "offers" {
                    showFeedback = .offer
                } else {
                    showBooking = true
                }
            } label: {
                Text(primaryActionTitle)
                    .font(SpotlyFont.headline())
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(SpotlyColors.accent)
                    .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.sm + 2))
            }
            .buttonStyle(.plain)
            .pressableScale()
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 10)
        .background(.regularMaterial)
        .overlay(alignment: .top) {
            Divider()
        }
    }

    // MARK: - Helpers

    private func openMaps() {
        let lat = business.location.latitude
        let lon = business.location.longitude
        let encoded = business.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: "maps://?ll=\(lat),\(lon)&q=\(encoded)") {
            UIApplication.shared.open(url)
        }
    }

    private func shareContent() {
        let items: [Any] = ["\(business.name) — \(business.tagline)\n\(business.location.displayName)\n\nFind it on Spotly — Zimbabwe's lifestyle app"]
        let av = UIActivityViewController(activityItems: items, applicationActivities: nil)
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let vc = windowScene.windows.first?.rootViewController else { return }
        av.popoverPresentationController?.sourceView = vc.view
        vc.present(av, animated: true)
    }
}

// MARK: - Sub-views

private struct RelatedListingTile: View {
    let business: SpotlyBusiness

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SpotlyImageView(imageName: business.cardImageName, categoryID: business.categoryID, style: .card)
                .frame(height: 120)
            VStack(alignment: .leading, spacing: 3) {
                Text(business.name)
                    .font(SpotlyFont.callout(.semibold))
                    .foregroundStyle(SpotlyColors.textPrimary)
                    .lineLimit(1)
                Text(business.tagline)
                    .font(SpotlyFont.caption())
                    .foregroundStyle(SpotlyColors.textSecondary)
                    .lineLimit(2)
                SpotlyRatingView(rating: business.rating, reviewCount: business.reviewCount)
            }
            .padding(SpotlySpacing.xs)
        }
        .background(SpotlyColors.surfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.sm))
        .overlay { RoundedRectangle(cornerRadius: SpotlyRadius.sm).stroke(SpotlyColors.border, lineWidth: 0.5) }
    }
}

private struct ServiceRow: View {
    let service: SpotlyService
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(service.name)
                    .font(SpotlyFont.callout(.semibold))
                    .foregroundStyle(SpotlyColors.textPrimary)
                HStack(spacing: SpotlySpacing.xxs) {
                    Image(systemName: "clock")
                        .font(SpotlyFont.micro())
                    Text(service.durationText)
                    if let cat = service.category { Text("· \(cat)") }
                }
                .font(SpotlyFont.caption())
                .foregroundStyle(SpotlyColors.textSecondary)
            }
            Spacer()
            Text(service.price == 0 ? "Free" : service.priceText)
                .font(SpotlyFont.callout(.semibold))
                .foregroundStyle(service.price == 0 ? SpotlyColors.success : SpotlyColors.textPrimary)
        }
        .padding(SpotlySpacing.cardPadding)
        .background(SpotlyColors.surfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.sm))
        .overlay { RoundedRectangle(cornerRadius: SpotlyRadius.sm).stroke(SpotlyColors.border, lineWidth: 0.5) }
    }
}

private struct LocalReviewRow: View {
    let review: SpotlyUserReview

    var body: some View {
        VStack(alignment: .leading, spacing: SpotlySpacing.xs) {
            HStack(alignment: .top) {
                ZStack {
                    Circle().fill(SpotlyColors.accentBg)
                    Text("ME")
                        .font(SpotlyFont.caption(.bold))
                        .foregroundStyle(SpotlyColors.accent)
                }
                .frame(width: 36, height: 36)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Your review")
                        .font(SpotlyFont.callout(.semibold))
                        .foregroundStyle(SpotlyColors.textPrimary)
                    Text(review.createdAt.formatted(date: .abbreviated, time: .omitted))
                        .font(SpotlyFont.micro())
                        .foregroundStyle(SpotlyColors.textTertiary)
                }
                Spacer()
                HStack(spacing: 2) {
                    ForEach(0..<review.rating, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .font(SpotlyFont.micro(.semibold))
                            .foregroundStyle(SpotlyColors.ratingGold)
                    }
                }
            }
            Text(review.comment)
                .font(SpotlyFont.callout())
                .foregroundStyle(SpotlyColors.textSecondary)
                .lineSpacing(3)
        }
        .padding(SpotlySpacing.cardPadding)
        .background(SpotlyColors.surfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.sm))
        .overlay { RoundedRectangle(cornerRadius: SpotlyRadius.sm).stroke(SpotlyColors.border, lineWidth: 0.5) }
    }
}

private struct ReviewRow: View {
    let review: SpotlyReview
    var body: some View {
        VStack(alignment: .leading, spacing: SpotlySpacing.xs) {
            HStack(alignment: .top) {
                ZStack {
                    Circle().fill(SpotlyColors.accentBg)
                    Text(review.authorInitials)
                        .font(SpotlyFont.caption(.bold))
                        .foregroundStyle(SpotlyColors.accent)
                }
                .frame(width: 36, height: 36)
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: SpotlySpacing.xxs) {
                        Text(review.authorName)
                            .font(SpotlyFont.callout(.semibold))
                            .foregroundStyle(SpotlyColors.textPrimary)
                        if review.verified {
                            Image(systemName: "checkmark.seal.fill")
                                .font(SpotlyFont.micro())
                                .foregroundStyle(SpotlyColors.success)
                        }
                    }
                    Text(review.formattedDate)
                        .font(SpotlyFont.micro())
                        .foregroundStyle(SpotlyColors.textTertiary)
                }
                Spacer()
                SpotlyRatingView(rating: review.rating)
            }
            Text(review.comment)
                .font(SpotlyFont.callout())
                .foregroundStyle(SpotlyColors.textSecondary)
                .lineSpacing(3)
        }
        .padding(SpotlySpacing.cardPadding)
        .background(SpotlyColors.surfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.sm))
        .overlay { RoundedRectangle(cornerRadius: SpotlyRadius.sm).stroke(SpotlyColors.border, lineWidth: 0.5) }
    }
}

private struct WriteReviewSheet: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    let business: SpotlyBusiness
    @State private var rating = 5
    @State private var comment = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Rating") {
                    HStack(spacing: SpotlySpacing.xs) {
                        ForEach(1...5, id: \.self) { value in
                            Button {
                                rating = value
                            } label: {
                                Image(systemName: value <= rating ? "star.fill" : "star")
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundStyle(SpotlyColors.ratingGold)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, SpotlySpacing.xs)
                }
                Section("Review") {
                    TextField("Share your demo feedback", text: $comment, axis: .vertical)
                        .lineLimit(4...8)
                }
                Section {
                    Text("Reviews are saved for this demo and appear in Profile > My Reviews.")
                        .font(SpotlyFont.caption())
                        .foregroundStyle(SpotlyColors.textSecondary)
                }
            }
            .navigationTitle("Write review")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Submit") {
                        appState.addUserReview(placeID: business.id, placeName: business.name, rating: rating, comment: comment.isEmpty ? "Demo review submitted for \(business.name)." : comment)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

private enum DetailFeedback: Identifiable {
    case offer
    var id: String { title }
    var icon: String { "tag.fill" }
    var title: String { "Offer saved" }
    var message: String { "This launch offer is ready for partner demos. Real redemption connects at launch." }
}
