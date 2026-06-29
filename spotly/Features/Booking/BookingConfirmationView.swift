import SwiftUI

struct BookingConfirmationView: View {
    let booking: SpotlyBooking
    @Environment(\.dismiss) private var dismiss
    @State private var showSuccess = false
    @State private var feedback: ConfirmationFeedback?

    var body: some View {
        ZStack {
            SpotlyAmbientBackground(variant: .booking)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: SpotlySpacing.xxl) {
                    Spacer(minLength: SpotlySpacing.xxxl)

                    // Success mark
                    ZStack {
                        Circle()
                            .fill(SpotlyColors.successBg)
                            .frame(width: 120, height: 120)
                            .scaleEffect(showSuccess ? 1 : 0.5)
                            .opacity(showSuccess ? 1 : 0)

                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 60, weight: .light))
                            .foregroundStyle(SpotlyColors.success)
                            .scaleEffect(showSuccess ? 1 : 0.3)
                            .opacity(showSuccess ? 1 : 0)
                    }

                    VStack(spacing: SpotlySpacing.xs) {
                        Text("You're booked!")
                            .font(SpotlyFont.title(.bold))
                            .foregroundStyle(SpotlyColors.textPrimary)
                            .opacity(showSuccess ? 1 : 0)
                            .offset(y: showSuccess ? 0 : 16)

                        Text("Your spot has been secured at \(booking.businessName).")
                            .font(SpotlyFont.body())
                            .foregroundStyle(SpotlyColors.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, SpotlySpacing.xxl)
                            .opacity(showSuccess ? 1 : 0)
                            .offset(y: showSuccess ? 0 : 12)
                    }

                    // Booking card
                    bookingCard
                        .opacity(showSuccess ? 1 : 0)
                        .offset(y: showSuccess ? 0 : 20)

                    // Payment note
                    HStack(spacing: SpotlySpacing.xs) {
                        Image(systemName: "creditcard.fill")
                            .font(SpotlyFont.caption(.semibold))
                            .foregroundStyle(SpotlyColors.accent)
                        Text("Payment will be collected through Paynow when checkout is enabled.")
                            .font(SpotlyFont.caption())
                            .foregroundStyle(SpotlyColors.textSecondary)
                    }
                    .padding(SpotlySpacing.sm)
                    .background(SpotlyColors.surfaceElevated)
                    .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.sm, style: .continuous))
                    .padding(.horizontal, SpotlySpacing.screenPadding)
                    .opacity(showSuccess ? 1 : 0)

                    // Actions
                    VStack(spacing: SpotlySpacing.sm) {
                        SpotlyButton(title: "Done") { dismiss() }

                        HStack(spacing: SpotlySpacing.sm) {
                            actionButton(icon: "calendar.badge.plus", label: "Add to\nCalendar", feedback: .calendar)
                            actionButton(icon: "arrow.triangle.turn.up.right.circle", label: "Get\nDirections", feedback: .directions)
                            actionButton(icon: "square.and.arrow.up", label: "Share\nBooking", feedback: .share)
                        }
                    }
                    .padding(.horizontal, SpotlySpacing.screenPadding)
                    .opacity(showSuccess ? 1 : 0)

                    Spacer(minLength: SpotlySpacing.safeAreaPad)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            withAnimation(SpotlyMotion.successPop.delay(0.2)) { showSuccess = true }
            SpotlyHaptics.success()
        }
        .sheet(item: $feedback) { item in
            SpotlyFeedbackSheet(icon: item.icon, title: item.title, message: item.message)
        }
    }

    // MARK: - Booking card

    private var bookingCard: some View {
        VStack(spacing: 0) {
            // Header gradient
            ZStack {
                SpotlyGradients.forCategoryID(booking.businessCategory.lowercased())
                    .frame(height: 80)
                    .overlay(SpotlyGradients.heroOverlay)

                VStack {
                    Text(booking.confirmationCode)
                        .font(SpotlyFont.title3(.bold))
                        .foregroundStyle(SpotlyColors.accent)
                        .tracking(2)
                    Text("Confirmation code")
                        .font(SpotlyFont.micro())
                        .foregroundStyle(.white.opacity(0.7))
                }
            }

            // QR placeholder
            VStack(spacing: SpotlySpacing.xxs) {
                ZStack {
                    RoundedRectangle(cornerRadius: SpotlyRadius.xs, style: .continuous)
                        .fill(SpotlyColors.surfaceElevated)
                        .frame(width: 100, height: 100)
                    VStack(spacing: 4) {
                        Image(systemName: "qrcode")
                            .font(.system(size: 40, weight: .light))
                            .foregroundStyle(SpotlyColors.textTertiary)
                        Text("QR at launch")
                            .font(SpotlyFont.nano())
                            .foregroundStyle(SpotlyColors.textTertiary)
                    }
                }
                .padding(.top, SpotlySpacing.md)
            }

            // Booking details
            VStack(spacing: SpotlySpacing.sm) {
                Divider().opacity(0.3)
                cardDetailRow(label: "Business", value: booking.businessName)
                cardDetailRow(label: "Service", value: booking.serviceName)
                cardDetailRow(label: "Date", value: booking.formattedDate)
                cardDetailRow(label: "Time", value: booking.time)
                cardDetailRow(label: "Status", value: booking.status.displayText)
                cardDetailRow(label: "Total", value: booking.price == 0 ? "Free" : booking.formattedPrice)
            }
            .padding(SpotlySpacing.cardPadding)
        }
        .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.lg, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: SpotlyRadius.lg, style: .continuous)
                .stroke(SpotlyColors.borderAccent, lineWidth: 1)
        }
        .spotlyShadow(SpotlyShadow.cardHeavy)
        .padding(.horizontal, SpotlySpacing.screenPadding)
    }

    private func cardDetailRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(SpotlyFont.caption())
                .foregroundStyle(SpotlyColors.textSecondary)
            Spacer()
            Text(value)
                .font(SpotlyFont.callout(.semibold))
                .foregroundStyle(SpotlyColors.textPrimary)
        }
    }

    private func actionButton(icon: String, label: String, feedback: ConfirmationFeedback) -> some View {
        Button {
            SpotlyHaptics.lightTap()
            self.feedback = feedback
        } label: {
            VStack(spacing: SpotlySpacing.xxs) {
                ZStack {
                    Image(systemName: icon)
                        .font(SpotlyFont.callout())
                        .foregroundStyle(SpotlyColors.accent)
                        .frame(width: 48, height: 48)
                        .spotlyGlassSurface(shape: Circle(), tint: SpotlyColors.accent, intensity: .subtle)
                }
                Text(label)
                    .font(SpotlyFont.nano(.medium))
                    .foregroundStyle(SpotlyColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
        .pressableScale(scale: 0.95)
    }
}

private enum ConfirmationFeedback: Identifiable {
    case calendar, directions, share

    var id: String { title }
    var icon: String {
        switch self {
        case .calendar: return "calendar.badge.plus"
        case .directions: return "arrow.triangle.turn.up.right.circle"
        case .share: return "square.and.arrow.up"
        }
    }
    var title: String {
        switch self {
        case .calendar: return "Calendar coming soon"
        case .directions: return "Directions coming soon"
        case .share: return "Share coming soon"
        }
    }
    var message: String {
        switch self {
        case .calendar: return "Calendar export will be enabled for launch partners. Your booking is saved in Spotly."
        case .directions: return "Directions will open the venue in Maps in a later build."
        case .share: return "Shareable booking passes are planned for launch readiness."
        }
    }
}
