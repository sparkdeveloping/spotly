import SwiftUI

struct EventDetailView: View {
    let event: SpotlyEvent
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @State private var showTicketCheckout = false

    private var isFav: Bool { appState.isFavourited(event.id) }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                heroSection
                contentSection
                detailsSection
                tagsSection
                SpotlyBottomSafeSpacer(extra: 100)
            }
        }
        .background(SpotlyColors.background)
        .ignoresSafeArea(edges: .top)
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .overlay(alignment: .topLeading) { navOverlay }
        .safeAreaInset(edge: .bottom, spacing: 0) { bottomBar }
        .sheet(isPresented: $showTicketCheckout) {
            TicketCheckoutView(event: event)
        }
    }

    // MARK: - Hero

    private var heroSection: some View {
        ZStack(alignment: .bottom) {
            SpotlyImageView(imageName: event.cardImageName, categoryID: event.categoryID, style: .hero)
                .frame(maxWidth: .infinity)
                .frame(height: 280)
            LinearGradient(colors: [.clear, .black.opacity(0.65)], startPoint: .center, endPoint: .bottom)
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: SpotlySpacing.xxs) {
                    Text(event.formattedDate)
                        .font(SpotlyFont.caption(.semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, SpotlySpacing.xs)
                        .padding(.vertical, 3)
                        .background(.black.opacity(0.35))
                        .clipShape(Capsule())
                    Text(event.name)
                        .font(SpotlyFont.title3(.bold))
                        .foregroundStyle(.white)
                        .lineLimit(2)
                }
                Spacer()
                if let price = event.price {
                    Text(price == 0 ? "Free" : "ZiG \(Int(price))")
                        .font(SpotlyFont.callout(.bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, SpotlySpacing.sm)
                        .padding(.vertical, SpotlySpacing.xxs)
                        .background(SpotlyColors.accent)
                        .clipShape(Capsule())
                }
            }
            .padding(.horizontal, SpotlySpacing.screenPadding)
            .padding(.bottom, SpotlySpacing.md)
        }
    }

    // MARK: - Content

    private var contentSection: some View {
        VStack(alignment: .leading, spacing: SpotlySpacing.md) {
            HStack(alignment: .top) {
                Text(event.name)
                    .font(SpotlyFont.title2(.bold))
                    .foregroundStyle(SpotlyColors.textPrimary)
                Spacer()
                Button {
                    SpotlyHaptics.success()
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        appState.toggleFavourite(event.id)
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

            Text(event.description)
                .font(SpotlyFont.body())
                .foregroundStyle(SpotlyColors.textSecondary)
                .lineSpacing(4)

            if event.attendeeCount > 0 {
                HStack(spacing: SpotlySpacing.xxs) {
                    Image(systemName: "person.2.fill")
                        .font(SpotlyFont.caption(.semibold))
                        .foregroundStyle(SpotlyColors.accent)
                    Text("\(event.attendeeCount) attending")
                        .font(SpotlyFont.caption(.medium))
                        .foregroundStyle(SpotlyColors.textSecondary)
                }
            }
        }
        .padding(SpotlySpacing.screenPadding)
    }

    // MARK: - Details

    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Divider()
            Text("Event details")
                .font(SpotlyFont.title3(.bold))
                .foregroundStyle(SpotlyColors.textPrimary)
                .padding(.horizontal, SpotlySpacing.screenPadding)
                .padding(.top, SpotlySpacing.md)
                .padding(.bottom, SpotlySpacing.sm)

            VStack(spacing: 0) {
                detailRow(icon: "mappin.circle.fill", label: "Venue", value: event.venue)
                Divider().padding(.leading, 52)
                detailRow(icon: "calendar", label: "Date", value: event.formattedDate)
                Divider().padding(.leading, 52)
                detailRow(icon: "clock", label: "Time", value: formattedTime(event.startDate))
                Divider().padding(.leading, 52)
                detailRow(
                    icon: "ticket.fill",
                    label: "Price",
                    value: event.price == nil ? "Free" : event.price == 0 ? "Free" : "ZiG \(Int(event.price!))"
                )
            }
            .background(SpotlyColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.md))
            .overlay {
                RoundedRectangle(cornerRadius: SpotlyRadius.md)
                    .stroke(SpotlyColors.border, lineWidth: 0.5)
            }
            .padding(.horizontal, SpotlySpacing.screenPadding)
            .padding(.bottom, SpotlySpacing.md)
        }
    }

    private func detailRow(icon: String, label: String, value: String) -> some View {
        HStack(spacing: SpotlySpacing.md) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(SpotlyColors.accent)
                .frame(width: 20)
            Text(label)
                .font(SpotlyFont.callout())
                .foregroundStyle(SpotlyColors.textSecondary)
            Spacer()
            Text(value)
                .font(SpotlyFont.callout(.semibold))
                .foregroundStyle(SpotlyColors.textPrimary)
                .multilineTextAlignment(.trailing)
        }
        .padding(.horizontal, SpotlySpacing.screenPadding)
        .padding(.vertical, SpotlySpacing.sm)
    }

    private func formattedTime(_ date: Date) -> String {
        let f = DateFormatter()
        f.timeStyle = .short
        return f.string(from: date)
    }

    // MARK: - Tags

    private var tagsSection: some View {
        Group {
            if !event.tags.isEmpty {
                VStack(alignment: .leading, spacing: SpotlySpacing.sm) {
                    Divider()
                    Text("Tags")
                        .font(SpotlyFont.headline())
                        .foregroundStyle(SpotlyColors.textPrimary)
                        .padding(.horizontal, SpotlySpacing.screenPadding)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: SpotlySpacing.xs) {
                            ForEach(event.tags, id: \.self) { tag in
                                Text(tag)
                                    .font(SpotlyFont.caption(.medium))
                                    .foregroundStyle(SpotlyColors.accent)
                                    .padding(.horizontal, SpotlySpacing.sm)
                                    .padding(.vertical, SpotlySpacing.xxs)
                                    .background(SpotlyColors.accentBg)
                                    .clipShape(Capsule())
                            }
                        }
                        .padding(.horizontal, SpotlySpacing.screenPadding)
                    }
                    .padding(.bottom, SpotlySpacing.sm)
                }
            }
        }
    }

    // MARK: - Nav overlay

    private var navOverlay: some View {
        Button { dismiss() } label: {
            Image(systemName: "chevron.left")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 36, height: 36)
                .background(.black.opacity(0.35))
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
        .padding(.horizontal, SpotlySpacing.screenPadding)
        .padding(.top, 56)
    }

    // MARK: - Bottom bar

    private var bottomBar: some View {
        HStack(spacing: SpotlySpacing.sm) {
            Button {
                SpotlyHaptics.medium()
                showTicketCheckout = true
            } label: {
                Text(event.isAvailable ? "Get tickets" : "Sold out")
                    .font(SpotlyFont.headline(.semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(event.isAvailable ? SpotlyColors.accent : SpotlyColors.textTertiary)
                    .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.sm + 2))
            }
            .buttonStyle(.plain)
            .pressableScale()
            .disabled(!event.isAvailable)
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 10)
        .background(.regularMaterial)
        .overlay(alignment: .top) { Divider() }
    }
}

// MARK: - Ticket checkout placeholder

struct TicketCheckoutView: View {
    let event: SpotlyEvent
    @Environment(\.dismiss) private var dismiss
    @State private var quantity = 1
    @State private var confirmed = false

    var total: Double { Double(quantity) * (event.price ?? 0) }

    var body: some View {
        NavigationStack {
            if confirmed {
                ticketConfirmation
            } else {
                ScrollView {
                VStack(alignment: .leading, spacing: SpotlySpacing.lg) {
                    // Event summary
                    VStack(alignment: .leading, spacing: SpotlySpacing.xs) {
                        Text(event.name)
                            .font(SpotlyFont.title3(.bold))
                            .foregroundStyle(SpotlyColors.textPrimary)
                        Text(event.formattedDate + " · " + event.venue)
                            .font(SpotlyFont.callout())
                            .foregroundStyle(SpotlyColors.textSecondary)
                    }
                    .padding(SpotlySpacing.md)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(SpotlyColors.accentBg)
                    .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.md))

                    // Quantity
                    VStack(alignment: .leading, spacing: SpotlySpacing.sm) {
                        Text("Number of tickets")
                            .font(SpotlyFont.headline())
                            .foregroundStyle(SpotlyColors.textPrimary)
                        HStack(spacing: SpotlySpacing.md) {
                            Button { if quantity > 1 { quantity -= 1 } } label: {
                                Image(systemName: "minus.circle.fill")
                                    .font(.system(size: 28))
                                    .foregroundStyle(quantity > 1 ? SpotlyColors.accent : SpotlyColors.textTertiary)
                            }
                            .buttonStyle(.plain)
                            Text("\(quantity)")
                                .font(SpotlyFont.title2(.bold))
                                .foregroundStyle(SpotlyColors.textPrimary)
                                .frame(width: 44)
                            Button { if quantity < 10 { quantity += 1 } } label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 28))
                                    .foregroundStyle(SpotlyColors.accent)
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    Divider()

                    // Summary
                    VStack(spacing: SpotlySpacing.xs) {
                        summaryRow("Tickets (\(quantity)×)", value: event.price == nil || event.price == 0 ? "Free" : "ZiG \(Int((event.price ?? 0) * Double(quantity)))")
                        summaryRow("Booking fee", value: "ZiG 150")
                        Divider()
                        summaryRow("Total", value: event.price == nil || event.price == 0 ? "Free" : "ZiG \(Int(total) + 150)", bold: true)
                    }

                    // Payment note
                    HStack(spacing: SpotlySpacing.xs) {
                        Image(systemName: "lock.fill")
                            .font(SpotlyFont.caption())
                            .foregroundStyle(SpotlyColors.accent)
                        Text("Payment via Paynow and EcoCash coming soon. Reservation confirmed immediately.")
                            .font(SpotlyFont.caption())
                            .foregroundStyle(SpotlyColors.textSecondary)
                            .lineSpacing(3)
                    }
                    .padding(SpotlySpacing.sm)
                    .background(SpotlyColors.accentBg)
                    .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.sm))

                    Button {
                        SpotlyHaptics.success()
                        withAnimation(.easeInOut(duration: 0.2)) { confirmed = true }
                    } label: {
                        Text("Confirm reservation")
                            .font(SpotlyFont.headline(.semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(SpotlyColors.accent)
                            .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.sm + 2))
                    }
                    .buttonStyle(.plain)
                    .pressableScale()
                }
                .padding(SpotlySpacing.screenPadding)
            }
            .background(SpotlyColors.background)
            .navigationTitle("Get tickets")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            }
        }
    }

    private var ticketConfirmation: some View {
        VStack(spacing: SpotlySpacing.xl) {
            Spacer(minLength: SpotlySpacing.md)
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 56, weight: .light))
                .foregroundStyle(SpotlyColors.accent)
            VStack(spacing: SpotlySpacing.xs) {
                Text("Tickets reserved")
                    .font(SpotlyFont.title2(.bold))
                    .foregroundStyle(SpotlyColors.textPrimary)
                Text(event.name)
                    .font(SpotlyFont.callout(.semibold))
                    .foregroundStyle(SpotlyColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            VStack(spacing: SpotlySpacing.sm) {
                Text("SPT-EVT-\(event.id.suffix(3).uppercased())")
                    .font(.system(size: 24, weight: .bold, design: .monospaced))
                    .foregroundStyle(SpotlyColors.accent)
                Image(systemName: "qrcode")
                    .font(.system(size: 72, weight: .light))
                    .foregroundStyle(SpotlyColors.textTertiary)
                Text("QR check-in activates when event partners go live.")
                    .font(SpotlyFont.caption())
                    .foregroundStyle(SpotlyColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(SpotlySpacing.xl)
            .frame(maxWidth: .infinity)
            .background(SpotlyColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.md))
            Button("Done") { dismiss() }
                .font(SpotlyFont.headline(.semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(SpotlyColors.accent)
                .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.sm + 2))
            Spacer()
        }
        .padding(SpotlySpacing.screenPadding)
        .background(SpotlyColors.background)
        .navigationTitle("Ticket confirmation")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func summaryRow(_ label: String, value: String, bold: Bool = false) -> some View {
        HStack {
            Text(label)
                .font(bold ? SpotlyFont.callout(.bold) : SpotlyFont.callout())
                .foregroundStyle(SpotlyColors.textSecondary)
            Spacer()
            Text(value)
                .font(bold ? SpotlyFont.callout(.bold) : SpotlyFont.callout(.semibold))
                .foregroundStyle(bold ? SpotlyColors.accent : SpotlyColors.textPrimary)
        }
    }
}
