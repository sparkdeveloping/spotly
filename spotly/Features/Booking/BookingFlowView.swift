import SwiftUI

struct BookingFlowView: View {
    let business: SpotlyBusiness
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    @State private var step = 0
    @State private var selectedService: SpotlyService? = nil
    @State private var selectedDate = Date()
    @State private var selectedTime = "10:00 AM"
    @State private var notes = ""
    @State private var confirmedBooking: SpotlyBooking? = nil
    @State private var isConfirming = false

    private let times = ["9:00 AM", "10:00 AM", "11:00 AM", "12:00 PM",
                         "1:00 PM", "2:00 PM", "3:00 PM", "4:00 PM", "5:00 PM", "6:00 PM"]

    var body: some View {
        NavigationStack {
            ZStack {
                SpotlyAmbientBackground(variant: .booking)

                VStack(spacing: 0) {
                    // Progress bar
                    progressBar

                    // Step content
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: SpotlySpacing.xl) {
                            switch step {
                            case 0: serviceStep
                            case 1: dateStep
                            case 2: timeStep
                            case 3: reviewStep
                            default: EmptyView()
                            }
                        }
                        .padding(SpotlySpacing.screenPadding)
                        .padding(.bottom, 100)
                    }
                    .scrollDismissesKeyboard(.interactively)

                    // Navigation
                    bottomNav
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                        .foregroundStyle(SpotlyColors.textSecondary)
                }
            }
            .navigationDestination(isPresented: Binding(
                get: { confirmedBooking != nil },
                set: { if !$0 { confirmedBooking = nil } }
            )) {
                if let booking = confirmedBooking {
                    BookingConfirmationView(booking: booking)
                }
            }
        }
    }

    // MARK: - Progress bar

    private var progressBar: some View {
        VStack(spacing: SpotlySpacing.xs) {
            HStack(spacing: SpotlySpacing.xs) {
                ForEach(0..<4, id: \.self) { i in
                    Capsule(style: .continuous)
                        .fill(i <= step ? SpotlyColors.accent : SpotlyColors.surfaceElevated)
                        .frame(height: 3)
                        .animation(SpotlyMotion.softSpring, value: step)
                }
            }
            .padding(.horizontal, SpotlySpacing.screenPadding)

            Text(stepTitle)
                .font(SpotlyFont.caption())
                .foregroundStyle(SpotlyColors.textSecondary)
        }
        .padding(.vertical, SpotlySpacing.md)
        .background(SpotlyColors.background)
    }

    private var stepTitle: String {
        switch step {
        case 0: return "Select a service"
        case 1: return "Choose a date"
        case 2: return "Pick a time"
        case 3: return "Review your booking"
        default: return "Booking"
        }
    }

    // MARK: - Step 0: Services

    private var serviceStep: some View {
        VStack(alignment: .leading, spacing: SpotlySpacing.md) {
            Text("What would you like to book?")
                .font(SpotlyFont.title3(.bold))
                .foregroundStyle(SpotlyColors.textPrimary)

            Text("at \(business.name)")
                .font(SpotlyFont.callout())
                .foregroundStyle(SpotlyColors.textSecondary)

            VStack(spacing: SpotlySpacing.xs) {
                ForEach(business.services) { service in
                    Button {
                        SpotlyHaptics.selection()
                        withAnimation(SpotlyMotion.softSpring) { selectedService = service }
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(service.name)
                                    .font(SpotlyFont.callout(.semibold))
                                    .foregroundStyle(SpotlyColors.textPrimary)
                                HStack(spacing: 4) {
                                    Image(systemName: "clock")
                                        .font(SpotlyFont.micro())
                                    Text(service.durationText)
                                }
                                .font(SpotlyFont.caption())
                                .foregroundStyle(SpotlyColors.textSecondary)
                            }
                            Spacer()
                            VStack(alignment: .trailing, spacing: 2) {
                                Text(service.price == 0 ? "Free" : service.priceText)
                                    .font(SpotlyFont.callout(.semibold))
                                    .foregroundStyle(service.price == 0 ? SpotlyColors.success : SpotlyColors.accent)
                                if selectedService?.id == service.id {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(SpotlyFont.callout())
                                        .foregroundStyle(SpotlyColors.success)
                                }
                            }
                        }
                        .padding(SpotlySpacing.cardPadding)
                        .background {
                            RoundedRectangle(cornerRadius: SpotlyRadius.md, style: .continuous)
                                .fill(selectedService?.id == service.id ? SpotlyColors.successBg : SpotlyColors.surfaceCard)
                                .overlay {
                                    RoundedRectangle(cornerRadius: SpotlyRadius.md, style: .continuous)
                                        .stroke(selectedService?.id == service.id ? SpotlyColors.success.opacity(0.4) : SpotlyColors.border, lineWidth: 1)
                                }
                        }
                    }
                    .buttonStyle(.plain)
                    .pressableScale(scale: 0.98)
                }
            }
        }
        .spotlyAppear()
    }

    // MARK: - Step 1: Date

    private var dateStep: some View {
        VStack(alignment: .leading, spacing: SpotlySpacing.md) {
            Text("When would you like to come?")
                .font(SpotlyFont.title3(.bold))
                .foregroundStyle(SpotlyColors.textPrimary)

            DatePicker("Select date", selection: $selectedDate, in: Date()..., displayedComponents: .date)
                .datePickerStyle(.graphical)
                .tint(SpotlyColors.accent)
                .padding(SpotlySpacing.md)
                .background(SpotlyColors.surfaceCard)
                .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.md, style: .continuous))
        }
        .spotlyAppear()
    }

    // MARK: - Step 2: Time

    private var timeStep: some View {
        VStack(alignment: .leading, spacing: SpotlySpacing.md) {
            Text("Choose a time")
                .font(SpotlyFont.title3(.bold))
                .foregroundStyle(SpotlyColors.textPrimary)

            Text("Available slots")
                .font(SpotlyFont.caption())
                .foregroundStyle(SpotlyColors.textSecondary)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: SpotlySpacing.xs) {
                ForEach(times, id: \.self) { time in
                    Button {
                        SpotlyHaptics.selection()
                        withAnimation(SpotlyMotion.softSpring) { selectedTime = time }
                    } label: {
                        Text(time)
                            .font(SpotlyFont.callout(.medium))
                            .foregroundStyle(selectedTime == time ? SpotlyColors.textOnAccent : SpotlyColors.textPrimary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, SpotlySpacing.sm)
                            .background(selectedTime == time ? SpotlyColors.accent : SpotlyColors.surfaceCard)
                            .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.sm, style: .continuous))
                            .overlay {
                                RoundedRectangle(cornerRadius: SpotlyRadius.sm, style: .continuous)
                                    .stroke(selectedTime == time ? Color.clear : SpotlyColors.border, lineWidth: 0.5)
                            }
                    }
                    .buttonStyle(.plain)
                    .pressableScale(scale: 0.95)
                }
            }

            // Notes
            VStack(alignment: .leading, spacing: SpotlySpacing.xs) {
                Text("Special requests (optional)")
                    .font(SpotlyFont.callout(.medium))
                    .foregroundStyle(SpotlyColors.textPrimary)

                TextField("Any notes for the team...", text: $notes, axis: .vertical)
                    .font(SpotlyFont.body())
                    .foregroundStyle(SpotlyColors.textPrimary)
                    .tint(SpotlyColors.accent)
                    .lineLimit(3...5)
                    .padding(SpotlySpacing.md)
                    .background(SpotlyColors.surfaceCard)
                    .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.md, style: .continuous))
                    .overlay {
                        RoundedRectangle(cornerRadius: SpotlyRadius.md, style: .continuous)
                            .stroke(SpotlyColors.border, lineWidth: 0.5)
                    }
            }
        }
        .spotlyAppear()
    }

    // MARK: - Step 3: Review

    private var reviewStep: some View {
        VStack(alignment: .leading, spacing: SpotlySpacing.md) {
            Text("Review your booking")
                .font(SpotlyFont.title3(.bold))
                .foregroundStyle(SpotlyColors.textPrimary)

            // Summary card
            VStack(spacing: SpotlySpacing.md) {
                summaryRow(icon: "building.2", title: business.name, subtitle: business.location.displayName)
                Divider().opacity(0.3)
                summaryRow(icon: "sparkles", title: selectedService?.name ?? "—", subtitle: selectedService?.durationText ?? "")
                Divider().opacity(0.3)
                summaryRow(icon: "calendar", title: formattedDate, subtitle: selectedTime)
                Divider().opacity(0.3)
                HStack {
                    Label("Total", systemImage: "creditcard")
                        .font(SpotlyFont.callout(.semibold))
                        .foregroundStyle(SpotlyColors.textPrimary)
                    Spacer()
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(selectedService?.priceText ?? "Free")
                            .font(SpotlyFont.headline(.bold))
                            .foregroundStyle(SpotlyColors.accent)
                        Text("Payment via Paynow — coming soon")
                            .font(SpotlyFont.micro())
                            .foregroundStyle(SpotlyColors.textTertiary)
                    }
                }
            }
            .padding(SpotlySpacing.cardPadding)
            .cardBackground()

            // Payment note
            HStack(spacing: SpotlySpacing.xs) {
                Image(systemName: "lock.shield.fill")
                    .font(SpotlyFont.caption(.semibold))
                    .foregroundStyle(SpotlyColors.success)
                Text("Secure payment through Paynow will be enabled at launch. Book now to secure your spot.")
                    .font(SpotlyFont.caption())
                    .foregroundStyle(SpotlyColors.textSecondary)
            }
            .padding(SpotlySpacing.sm)
            .background(SpotlyColors.successBg)
            .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.sm, style: .continuous))
        }
        .spotlyAppear()
    }

    private func summaryRow(icon: String, title: String, subtitle: String) -> some View {
        HStack(spacing: SpotlySpacing.sm) {
            Image(systemName: icon)
                .font(SpotlyFont.callout())
                .foregroundStyle(SpotlyColors.accent)
                .frame(width: 20)
            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(SpotlyFont.callout(.semibold))
                    .foregroundStyle(SpotlyColors.textPrimary)
                if !subtitle.isEmpty {
                    Text(subtitle)
                        .font(SpotlyFont.caption())
                        .foregroundStyle(SpotlyColors.textSecondary)
                }
            }
            Spacer()
        }
    }

    private var formattedDate: String {
        let f = DateFormatter()
        f.dateFormat = "EEE, MMM d"
        return f.string(from: selectedDate)
    }

    // MARK: - Bottom nav

    private var bottomNav: some View {
        VStack(spacing: 0) {
            Divider().opacity(0.2)
            HStack(spacing: SpotlySpacing.sm) {
                if step > 0 {
                    SpotlyButton(title: "Back", variant: .secondary, isFullWidth: false) {
                        withAnimation(SpotlyMotion.pageTransition) { step -= 1 }
                    }
                }

                SpotlyButton(
                    title: step == 3 ? "Confirm booking" : "Continue",
                    icon: step == 3 ? "checkmark" : "arrow.right",
                    isLoading: isConfirming
                ) {
                    if step < 3 {
                        guard canProceed else { return }
                        SpotlyHaptics.lightTap()
                        withAnimation(SpotlyMotion.pageTransition) { step += 1 }
                    } else {
                        Task { await confirmBooking() }
                    }
                }
                .disabled(step < 3 && !canProceed)
                .opacity(step < 3 && !canProceed ? 0.55 : 1)
            }
            .padding(.horizontal, SpotlySpacing.screenPadding)
            .padding(.vertical, SpotlySpacing.md)
            .background(.ultraThinMaterial)
        }
    }

    private var canProceed: Bool {
        switch step {
        case 0: return selectedService != nil
        default: return true
        }
    }

    private func confirmBooking() async {
        guard let selectedService else { return }
        isConfirming = true
        let booking = SpotlyBooking(
            id: UUID().uuidString,
            businessID: business.id,
            businessName: business.name,
            businessCategory: business.categoryName,
            gradientKey: business.gradientKey,
            serviceName: selectedService.name,
            date: selectedDate,
            time: selectedTime,
            duration: selectedService.duration,
            price: selectedService.price,
            currency: selectedService.currency,
            status: .confirmed,
            paymentStatus: .unpaid,
            notes: notes.isEmpty ? nil : notes,
            createdAt: Date(),
            location: business.location,
            confirmationCode: "SPT-\(Int.random(in: 1000...9999))"
        )
        try? await Task.sleep(nanoseconds: 800_000_000)
        appState.addBooking(booking)
        isConfirming = false
        confirmedBooking = booking
    }
}
