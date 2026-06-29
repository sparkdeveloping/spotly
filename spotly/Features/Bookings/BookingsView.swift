import SwiftUI

struct BookingsView: View {
    @Environment(AppState.self) private var appState
    @State private var selectedSegment = 0
    @State private var bookingPath: [String] = []
    @State private var feedback: BookingFeedback?

    var body: some View {
        NavigationStack(path: $bookingPath) {
            VStack(spacing: 0) {
                bookingsHeader
                Divider()
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: SpotlySpacing.md) {
                        let items = selectedSegment == 0 ? appState.upcomingBookings : appState.pastBookings
                        if items.isEmpty {
                            emptyState
                                .padding(.top, SpotlySpacing.xxxl)
                        } else {
                            ForEach(items) { booking in
                                BookingCard(booking: booking) {
                                    bookingPath.append(booking.id)
                                } onDirections: {
                                    let lat = booking.location.latitude
                                    let lon = booking.location.longitude
                                    let encoded = booking.businessName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                                    if let url = URL(string: "maps://?ll=\(lat),\(lon)&q=\(encoded)") {
                                        UIApplication.shared.open(url)
                                    }
                                } onCalendar: {
                                    feedback = .calendar
                                } onBookAgain: {
                                    bookingPath.append(booking.id)
                                } onReview: {
                                    feedback = .review
                                }
                                .padding(.horizontal, SpotlySpacing.screenPadding)
                            }
                            if selectedSegment == 1 && items.count == 1 {
                                pastPlanCTA
                                    .padding(.horizontal, SpotlySpacing.screenPadding)
                            }
                        }
                        SpotlyBottomSafeSpacer(extra: 56)
                    }
                    .padding(.top, SpotlySpacing.xl)
                }
                .animation(.easeInOut(duration: 0.2), value: selectedSegment)
            }
            .background(SpotlyColors.background)
            .navigationBarHidden(true)
            .navigationDestination(for: String.self) { bookingID in
                if let booking = appState.bookings.first(where: { $0.id == bookingID }) {
                    BookingDetailView(booking: booking, onFeedback: { feedback = $0 }, onCancel: { id in appState.cancelBooking(id) })
                        .toolbar(.hidden, for: .tabBar)
                } else {
                    SpotlyComingSoonView(
                        title: "Booking unavailable",
                        message: "This booking is no longer available in your demo data.",
                        icon: "calendar.badge.exclamationmark"
                    )
                }
            }
        }
        .sheet(item: $feedback) { item in
            SpotlyFeedbackSheet(icon: item.icon, title: item.title, message: item.message)
        }
    }

    // MARK: - Header

    private func bookingCountText(_ count: Int, label: String) -> String {
        count == 1 ? "1 \(label)" : "\(count) \(label)s"
    }

    private var bookingsHeader: some View {
        VStack(spacing: SpotlySpacing.md) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Bookings")
                    .font(SpotlyFont.title(.bold))
                    .foregroundStyle(SpotlyColors.textPrimary)
                Text(selectedSegment == 0 ? bookingCountText(appState.upcomingBookings.count, label: "upcoming reservation") : bookingCountText(appState.pastBookings.count, label: "past booking"))
                    .font(SpotlyFont.callout())
                    .foregroundStyle(SpotlyColors.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            // Segmented control
            HStack(spacing: 0) {
                ForEach(["Upcoming", "Past"], id: \.self) { seg in
                    let idx = seg == "Upcoming" ? 0 : 1
                    Button {
                        SpotlyHaptics.selection()
                        withAnimation(.easeInOut(duration: 0.2)) { selectedSegment = idx }
                    } label: {
                        Text(seg)
                            .font(SpotlyFont.callout(.semibold))
                            .foregroundStyle(selectedSegment == idx ? .white : SpotlyColors.textSecondary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, SpotlySpacing.xs)
                            .background(selectedSegment == idx ? SpotlyColors.accent : Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.xs + 2))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(4)
            .background(SpotlyColors.backgroundElevated)
            .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.sm))
        }
        .padding(.horizontal, SpotlySpacing.screenPadding)
        .padding(.top, SpotlySpacing.lg)
        .padding(.bottom, SpotlySpacing.md)
        .background(SpotlyColors.surface)
    }

    // MARK: - Empty state

    private var pastPlanCTA: some View {
        VStack(alignment: .leading, spacing: SpotlySpacing.sm) {
            Text("Find your next plan")
                .font(SpotlyFont.headline(.semibold))
                .foregroundStyle(SpotlyColors.textPrimary)
            Text("Book another table, treatment, ticket, or activity from Spotly.")
                .font(SpotlyFont.callout())
                .foregroundStyle(SpotlyColors.textSecondary)
            Button {
                withAnimation { appState.selectedTab = .home }
            } label: {
                Label("Explore places", systemImage: "magnifyingglass")
                    .font(SpotlyFont.callout(.semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, minHeight: 48)
                    .background(SpotlyColors.accent)
                    .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.sm, style: .continuous))
            }
            .buttonStyle(.plain)
        }
        .padding(SpotlySpacing.cardPadding)
        .background(SpotlyColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.md, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: SpotlyRadius.md, style: .continuous)
                .stroke(SpotlyColors.border, lineWidth: 0.75)
        }
    }

    private var emptyState: some View {
        VStack(spacing: SpotlySpacing.lg) {
            Image(systemName: selectedSegment == 0 ? "calendar.badge.plus" : "calendar.badge.checkmark")
                .font(.system(size: 44, weight: .light))
                .foregroundStyle(SpotlyColors.accent.opacity(0.6))
            VStack(spacing: SpotlySpacing.xs) {
                Text(selectedSegment == 0 ? "No upcoming bookings" : "No past bookings")
                    .font(SpotlyFont.title3(.bold))
                    .foregroundStyle(SpotlyColors.textPrimary)
                Text(selectedSegment == 0
                    ? "Your confirmed plans will appear here. Start by exploring places."
                    : "Your completed visits and past bookings will collect here.")
                    .font(SpotlyFont.callout())
                    .foregroundStyle(SpotlyColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
            }
            if selectedSegment == 0 {
                Button {
                    withAnimation { appState.selectedTab = .home }
                } label: {
                    Text("Explore places")
                        .font(SpotlyFont.callout(.semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, SpotlySpacing.xl)
                        .padding(.vertical, SpotlySpacing.sm)
                        .background(SpotlyColors.accent)
                        .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.sm))
                }
                .buttonStyle(.plain)
                .pressableScale()
            }
        }
        .padding(SpotlySpacing.xl)
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Booking card

private struct BookingCard: View {
    let booking: SpotlyBooking
    let onTap: () -> Void
    let onDirections: () -> Void
    let onCalendar: () -> Void
    let onBookAgain: () -> Void
    let onReview: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                SpotlyHaptics.lightTap()
                onTap()
            } label: {
                VStack(alignment: .leading, spacing: 0) {
                    header
                    summaryBody
                }
            }
            .buttonStyle(.plain)

            actionRow
                .padding(.horizontal, SpotlySpacing.cardPadding)
                .padding(.bottom, SpotlySpacing.cardPadding)
        }
        .background(SpotlyColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.md, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: SpotlyRadius.md, style: .continuous)
                .stroke(SpotlyColors.border, lineWidth: 0.75)
        }
        .spotlyShadow(SpotlyShadow.card)
    }

    private var header: some View {
        ZStack(alignment: .bottomLeading) {
            SpotlyImageView(
                imageName: SpotlySampleImages.imageName(for: categoryID),
                categoryID: categoryID,
                style: .card
            )
            .frame(height: 132)

            LinearGradient(
                colors: [.black.opacity(0.08), .black.opacity(0.72)],
                startPoint: .top,
                endPoint: .bottom
            )

            HStack(alignment: .bottom, spacing: SpotlySpacing.sm) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(booking.businessName)
                        .font(SpotlyFont.headline(.bold))
                        .foregroundStyle(.white)
                        .lineLimit(2)
                    Text(booking.businessCategory)
                        .font(SpotlyFont.caption(.semibold))
                        .foregroundStyle(.white.opacity(0.86))
                        .lineLimit(1)
                }
                Spacer(minLength: SpotlySpacing.sm)
                SpotlyBookingStatusBadge(status: booking.status)
                    .background(.white.opacity(0.9), in: Capsule(style: .continuous))
            }
            .padding(SpotlySpacing.cardPadding)
        }
    }

    private var summaryBody: some View {
        HStack(alignment: .top, spacing: SpotlySpacing.md) {
            VStack(alignment: .leading, spacing: 7) {
                Text(booking.serviceName)
                    .font(SpotlyFont.callout(.semibold))
                    .foregroundStyle(SpotlyColors.textPrimary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                bookingMeta(icon: "calendar", text: booking.formattedDate)
                bookingMeta(icon: "clock", text: booking.time)
                bookingMeta(icon: "timer", text: "\(booking.duration) min")
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack(alignment: .trailing, spacing: 4) {
                Text(booking.price == 0 ? "Pay at venue" : booking.formattedPrice)
                    .font(SpotlyFont.callout(.bold))
                    .foregroundStyle(SpotlyColors.accent)
                    .multilineTextAlignment(.trailing)
                Text(booking.paymentStatus == .paid ? "Paid" : booking.paymentStatus == .pending ? "Pending" : "Demo payment")
                    .font(SpotlyFont.micro(.semibold))
                    .foregroundStyle(SpotlyColors.textSecondary)
                    .lineLimit(1)
            }
            .padding(.horizontal, SpotlySpacing.xs)
            .padding(.vertical, 6)
            .background(SpotlyColors.accentBg)
            .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.xs, style: .continuous))
        }
        .padding(SpotlySpacing.cardPadding)
        .background(SpotlyColors.surface)
    }

    @ViewBuilder
    private var actionRow: some View {
        if booking.isUpcoming {
            HStack(spacing: SpotlySpacing.xs) {
                actionChip(icon: "info.circle", title: "Details", action: onTap)
                actionChip(icon: "location", title: "Directions", action: onDirections)
                actionChip(icon: "calendar.badge.plus", title: "Calendar", action: onCalendar)
            }
        } else {
            HStack(spacing: SpotlySpacing.xs) {
                actionChip(icon: "info.circle", title: "Details", action: onTap)
                actionChip(icon: "arrow.clockwise", title: "Book again", action: onBookAgain)
                if booking.status != .cancelled {
                    actionChip(icon: "star", title: "Review", action: onReview)
                }
            }
        }
    }

    private var categoryID: String {
        if let business = MockBusinesses.all.first(where: { $0.id == booking.businessID }) {
            return business.categoryID
        }
        let value = booking.businessCategory.lowercased()
        if value.contains("spa") || value.contains("wellness") { return "wellnessSpa" }
        if value.contains("restaurant") { return "restaurants" }
        if value.contains("padel") { return "padel" }
        if value.contains("grocery") { return "groceries" }
        if value.contains("event") { return "events" }
        if value.contains("beauty") { return "beauty" }
        if value.contains("pharmacy") || value.contains("health") { return "pharmacy" }
        if value.contains("activity") { return "activities" }
        return value
    }

    private func bookingMeta(icon: String, text: String) -> some View {
        Label(text, systemImage: icon)
            .font(SpotlyFont.caption())
            .foregroundStyle(SpotlyColors.textSecondary)
            .lineLimit(1)
    }

    private func actionChip(icon: String, title: String, action: @escaping () -> Void) -> some View {
        Button {
            SpotlyHaptics.lightTap()
            action()
        } label: {
            HStack(spacing: 4) {
                Image(systemName: icon)
                Text(title)
                    .lineLimit(1)
            }
            .font(SpotlyFont.micro(.semibold))
            .foregroundStyle(SpotlyColors.textPrimary)
            .frame(maxWidth: .infinity, minHeight: 38)
            .background(SpotlyColors.backgroundElevated)
            .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.xs, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Booking detail view

struct BookingDetailView: View {
    let booking: SpotlyBooking
    var onFeedback: (BookingFeedback) -> Void
    var onCancel: (String) -> Void = { _ in }
    @State private var showCancelDialog = false
    @State private var selectedBusiness: SpotlyBusiness?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: SpotlySpacing.md) {
                    VStack(alignment: .leading, spacing: SpotlySpacing.sm) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(booking.businessName)
                                    .font(SpotlyFont.title3(.bold))
                                    .foregroundStyle(SpotlyColors.textPrimary)
                                Text(booking.businessCategory)
                                    .font(SpotlyFont.callout())
                                    .foregroundStyle(SpotlyColors.textSecondary)
                            }
                            Spacer()
                            SpotlyBookingStatusBadge(status: booking.status)
                        }
                        Text("Your Spotly reservation is saved.")
                            .font(SpotlyFont.caption())
                            .foregroundStyle(SpotlyColors.textSecondary)
                    }
                    .padding(SpotlySpacing.cardPadding)
                    .background(SpotlyColors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.md))
                    .overlay { RoundedRectangle(cornerRadius: SpotlyRadius.md).stroke(SpotlyColors.border, lineWidth: 1) }

                    // Confirmation code card
                    VStack(spacing: SpotlySpacing.xs) {
                        Text(booking.confirmationCode)
                            .font(.system(size: 32, weight: .bold, design: .monospaced))
                            .foregroundStyle(SpotlyColors.accent)
                            .tracking(4)
                        Text("Confirmation code")
                            .font(SpotlyFont.caption())
                            .foregroundStyle(SpotlyColors.textSecondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(SpotlySpacing.xl)
                    .background(SpotlyColors.accentBg)
                    .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.md))

                    // Details
                    VStack(spacing: 0) {
                        detailRow("Business", booking.businessName)
                        Divider().padding(.horizontal, SpotlySpacing.cardPadding)
                        detailRow("Service", booking.serviceName)
                        Divider().padding(.horizontal, SpotlySpacing.cardPadding)
                        detailRow("Date", booking.formattedDate)
                        Divider().padding(.horizontal, SpotlySpacing.cardPadding)
                        detailRow("Time", booking.time)
                        Divider().padding(.horizontal, SpotlySpacing.cardPadding)
                        detailRow("Duration", "\(booking.duration) min")
                        Divider().padding(.horizontal, SpotlySpacing.cardPadding)
                        detailRow("Location", booking.location.displayName)
                        Divider().padding(.horizontal, SpotlySpacing.cardPadding)
                        detailRow("Payment", booking.price == 0 ? "Pay at venue" : booking.formattedPrice)
                    }
                    .background(SpotlyColors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.md))
                    .overlay { RoundedRectangle(cornerRadius: SpotlyRadius.md).stroke(SpotlyColors.border, lineWidth: 1) }

                    // QR placeholder
                    VStack(spacing: SpotlySpacing.sm) {
                        Image(systemName: "qrcode")
                            .font(.system(size: 64, weight: .light))
                            .foregroundStyle(SpotlyColors.textTertiary)
                        Text("Check-in QR activates at launch")
                            .font(SpotlyFont.caption())
                            .foregroundStyle(SpotlyColors.textTertiary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(SpotlySpacing.xl)
                    .background(SpotlyColors.backgroundElevated)
                    .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.md))

                    VStack(alignment: .leading, spacing: SpotlySpacing.xs) {
                        Text("Good to know")
                            .font(SpotlyFont.headline(.semibold))
                            .foregroundStyle(SpotlyColors.textPrimary)
                        Text("Arrive 10 minutes early. Calendar export and self-service rescheduling will be enabled for launch partners.")
                            .font(SpotlyFont.callout())
                            .foregroundStyle(SpotlyColors.textSecondary)
                            .lineSpacing(3)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(SpotlySpacing.cardPadding)
                    .background(SpotlyColors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.md))
                    .overlay { RoundedRectangle(cornerRadius: SpotlyRadius.md).stroke(SpotlyColors.border, lineWidth: 1) }

                    if let relatedBusiness {
                        Button {
                            selectedBusiness = relatedBusiness
                        } label: {
                            HStack(spacing: SpotlySpacing.sm) {
                                SpotlyImageView(imageName: relatedBusiness.cardImageName, categoryID: relatedBusiness.categoryID, style: .thumbnail)
                                    .frame(width: 56, height: 56)
                                    .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.sm))
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("View spot")
                                        .font(SpotlyFont.caption(.semibold))
                                        .foregroundStyle(SpotlyColors.textSecondary)
                                    Text(relatedBusiness.name)
                                        .font(SpotlyFont.callout(.semibold))
                                        .foregroundStyle(SpotlyColors.textPrimary)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(SpotlyFont.caption(.semibold))
                                    .foregroundStyle(SpotlyColors.textTertiary)
                            }
                            .padding(SpotlySpacing.cardPadding)
                            .background(SpotlyColors.surface)
                            .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.md))
                            .overlay { RoundedRectangle(cornerRadius: SpotlyRadius.md).stroke(SpotlyColors.border, lineWidth: 1) }
                        }
                        .buttonStyle(.plain)
                    }

                    // Actions
                    HStack(spacing: SpotlySpacing.sm) {
                        detailAction(icon: "calendar.badge.plus", title: "Calendar") {
                            onFeedback(.calendar)
                        }
                        detailAction(icon: "location.fill", title: "Directions") {
                            openDirections()
                        }
                        ShareLink(item: shareText) {
                            VStack(spacing: SpotlySpacing.xxs) {
                                Image(systemName: "square.and.arrow.up")
                                    .font(SpotlyFont.callout())
                                    .foregroundStyle(SpotlyColors.accent)
                                Text("Share")
                                    .font(SpotlyFont.micro(.semibold))
                                    .foregroundStyle(SpotlyColors.textSecondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, SpotlySpacing.sm)
                            .background(SpotlyColors.backgroundElevated)
                            .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.sm))
                        }
                    }

                    detailAction(icon: "arrow.clockwise", title: booking.isUpcoming ? "Reschedule" : "Book again") {
                        onFeedback(.reschedule)
                    }

                    if booking.status.isActive {
                        Button(role: .destructive) {
                            showCancelDialog = true
                        } label: {
                            Label("Cancel booking", systemImage: "xmark.circle")
                                .font(SpotlyFont.callout(.semibold))
                                .foregroundStyle(SpotlyColors.error)
                                .frame(maxWidth: .infinity, minHeight: 48)
                                .background(SpotlyColors.error.opacity(0.08))
                                .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.sm, style: .continuous))
                        }
                        .buttonStyle(.plain)
                    }

                    SpotlyBottomSafeSpacer()
                }
                .padding(SpotlySpacing.screenPadding)
            }
            .background(SpotlyColors.backgroundElevated)
            .navigationTitle("Booking details")
            .navigationBarTitleDisplayMode(.inline)
            .confirmationDialog("Cancel booking?", isPresented: $showCancelDialog, titleVisibility: .visible) {
                Button("Cancel booking", role: .destructive) {
                    onCancel(booking.id)
                    dismiss()
                }
                Button("Keep booking", role: .cancel) {}
            } message: {
                Text("This will remove the booking from your upcoming plans.")
            }
            .sheet(item: $selectedBusiness) { business in
                NavigationStack {
                    BusinessDetailView(business: business)
                }
            }
        }

    private var relatedBusiness: SpotlyBusiness? {
        MockBusinesses.all.first { $0.id == booking.businessID }
    }

    private var shareText: String {
        "Spotly booking: \(booking.businessName) · \(booking.serviceName) · \(booking.formattedDate) at \(booking.time) · Code \(booking.confirmationCode)"
    }

    private func openDirections() {
        let lat = booking.location.latitude
        let lon = booking.location.longitude
        let encoded = booking.businessName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "Spotly"
        if let url = URL(string: "maps://?ll=\(lat),\(lon)&q=\(encoded)") {
            UIApplication.shared.open(url)
        } else {
            onFeedback(.directions)
        }
    }

    private func detailRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
                .font(SpotlyFont.callout())
                .foregroundStyle(SpotlyColors.textSecondary)
            Spacer()
            Text(value)
                .font(SpotlyFont.callout(.semibold))
                .foregroundStyle(SpotlyColors.textPrimary)
                .multilineTextAlignment(.trailing)
        }
        .padding(.horizontal, SpotlySpacing.cardPadding)
        .padding(.vertical, SpotlySpacing.sm)
    }

    private func detailAction(icon: String, title: String, action: @escaping () -> Void) -> some View {
        Button {
            SpotlyHaptics.lightTap()
            action()
        } label: {
            VStack(spacing: SpotlySpacing.xxs) {
                Image(systemName: icon)
                    .font(SpotlyFont.callout())
                    .foregroundStyle(SpotlyColors.accent)
                Text(title)
                    .font(SpotlyFont.micro(.semibold))
                    .foregroundStyle(SpotlyColors.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, SpotlySpacing.sm)
            .background(SpotlyColors.backgroundElevated)
            .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.sm))
        }
        .buttonStyle(.plain)
    }
}

enum BookingFeedback: Identifiable {
    case calendar, directions, reschedule, review
    var id: String { title }
    var icon: String {
        switch self {
        case .calendar:   return "calendar.badge.plus"
        case .directions: return "location.fill"
        case .reschedule: return "arrow.clockwise"
        case .review:     return "star"
        }
    }
    var title: String {
        switch self {
        case .calendar:   return "Calendar coming soon"
        case .directions: return "Directions coming soon"
        case .reschedule: return "Reschedule coming soon"
        case .review:     return "Review coming soon"
        }
    }
    var message: String {
        switch self {
        case .calendar:   return "Calendar export will be enabled for launch partners. Your booking is saved in Spotly."
        case .directions: return "Maps directions will open when partner addresses are verified for launch."
        case .reschedule: return "Self-service rescheduling will be enabled for launch partners."
        case .review:     return "Review writing from past bookings will be enabled before public launch."
        }
    }
}
