import SwiftUI

struct CheckoutView: View {
    let business: SpotlyBusiness
    let cart: [CartItem]
    let total: Double
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @State private var deliveryAddress = ""
    @State private var selectedTime = "As soon as possible"
    @State private var selectedPayment = "Paynow"
    @State private var showTracking = false
    @State private var isPlacing = false

    let deliveryTimes = ["As soon as possible", "30 minutes", "45 minutes", "1 hour", "Schedule for later"]
    let paymentOptions = ["Paynow", "EcoCash", "Cash on delivery"]

    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: SpotlySpacing.sm) {
                    deliverySection
                    timeSection
                    paymentSection
                    orderSummarySection
                    SpotlyBottomSafeSpacer(extra: 80)
                }
                .padding(.top, SpotlySpacing.sm)
            }
            .background(SpotlyColors.backgroundElevated)
            .navigationTitle("Checkout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                placeOrderButton
            }
            .fullScreenCover(isPresented: $showTracking) {
                OrderTrackingView(business: business, total: total) {
                    showTracking = false
                    dismiss()
                }
            }
        }
    }

    // MARK: - Delivery section

    private var deliverySection: some View {
        checkoutCard(title: "Delivery address") {
            HStack(spacing: SpotlySpacing.sm) {
                Image(systemName: "location.fill")
                    .font(SpotlyFont.callout())
                    .foregroundStyle(SpotlyColors.accent)
                    .frame(width: 20)
                TextField("Enter delivery address", text: $deliveryAddress)
                    .font(SpotlyFont.callout())
                    .foregroundStyle(SpotlyColors.textPrimary)
            }
            .padding(SpotlySpacing.sm)
            .background(SpotlyColors.backgroundElevated)
            .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.sm))
            .overlay {
                RoundedRectangle(cornerRadius: SpotlyRadius.sm).stroke(SpotlyColors.border, lineWidth: 1)
            }
        }
    }

    // MARK: - Time section

    private var timeSection: some View {
        checkoutCard(title: "Delivery time") {
            VStack(spacing: SpotlySpacing.xs) {
                ForEach(deliveryTimes, id: \.self) { time in
                    Button {
                        SpotlyHaptics.selection()
                        selectedTime = time
                    } label: {
                        HStack {
                            Text(time)
                                .font(SpotlyFont.callout())
                                .foregroundStyle(SpotlyColors.textPrimary)
                            Spacer()
                            Image(systemName: selectedTime == time ? "checkmark.circle.fill" : "circle")
                                .font(SpotlyFont.callout())
                                .foregroundStyle(selectedTime == time ? SpotlyColors.accent : SpotlyColors.textTertiary)
                        }
                    }
                    .buttonStyle(.plain)
                    if time != deliveryTimes.last {
                        Divider()
                    }
                }
            }
        }
    }

    // MARK: - Payment section

    private var paymentSection: some View {
        checkoutCard(title: "Payment method") {
            VStack(spacing: SpotlySpacing.xs) {
                ForEach(paymentOptions, id: \.self) { option in
                    Button {
                        SpotlyHaptics.selection()
                        selectedPayment = option
                    } label: {
                        HStack(spacing: SpotlySpacing.sm) {
                            ZStack {
                                RoundedRectangle(cornerRadius: SpotlyRadius.xs)
                                    .fill(SpotlyColors.accentBg)
                                    .frame(width: 32, height: 32)
                                Image(systemName: paymentIcon(option))
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(SpotlyColors.accent)
                            }
                            Text(option)
                                .font(SpotlyFont.callout())
                                .foregroundStyle(SpotlyColors.textPrimary)
                            if option != "Cash on delivery" {
                                Text("Coming soon")
                                    .font(SpotlyFont.micro(.semibold))
                                    .foregroundStyle(SpotlyColors.textTertiary)
                                    .padding(.horizontal, SpotlySpacing.xxs)
                                    .padding(.vertical, 2)
                                    .background(SpotlyColors.backgroundElevated)
                                    .clipShape(Capsule())
                            }
                            Spacer()
                            Image(systemName: selectedPayment == option ? "checkmark.circle.fill" : "circle")
                                .font(SpotlyFont.callout())
                                .foregroundStyle(selectedPayment == option ? SpotlyColors.accent : SpotlyColors.textTertiary)
                        }
                    }
                    .buttonStyle(.plain)
                    if option != paymentOptions.last {
                        Divider()
                    }
                }
            }
        }
    }

    // MARK: - Order summary

    private var orderSummarySection: some View {
        checkoutCard(title: "Order summary") {
            VStack(spacing: SpotlySpacing.xs) {
                ForEach(cart) { item in
                    HStack {
                        Text("\(item.quantity)× \(item.name)")
                            .font(SpotlyFont.callout())
                            .foregroundStyle(SpotlyColors.textSecondary)
                        Spacer()
                        Text("US$\(String(format: "%.2f", item.total))")
                            .font(SpotlyFont.callout(.semibold))
                            .foregroundStyle(SpotlyColors.textPrimary)
                    }
                }
                Divider().padding(.vertical, SpotlySpacing.xxs)
                HStack {
                    Text("Total")
                        .font(SpotlyFont.headline(.semibold))
                        .foregroundStyle(SpotlyColors.textPrimary)
                    Spacer()
                    Text("US$\(String(format: "%.2f", total))")
                        .font(SpotlyFont.headline(.bold))
                        .foregroundStyle(SpotlyColors.accent)
                }
            }
        }
    }

    // MARK: - Place order button

    private var placeOrderButton: some View {
        Button {
            placeOrder()
        } label: {
            HStack {
                if isPlacing {
                    ProgressView().tint(.white).scaleEffect(0.85)
                } else {
                    Text("Place order")
                        .font(SpotlyFont.headline())
                }
                Spacer()
                Text("US$\(String(format: "%.2f", total))")
                    .font(SpotlyFont.headline(.bold))
            }
            .foregroundStyle(.white)
            .padding(.horizontal, SpotlySpacing.xl)
            .frame(height: 56)
            .frame(maxWidth: .infinity)
            .background(isPlacing ? SpotlyColors.accent.opacity(0.7) : SpotlyColors.accent)
            .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.sm + 2))
        }
        .buttonStyle(.plain)
        .disabled(isPlacing)
        .pressableScale()
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 10)
        .background(.regularMaterial)
        .overlay(alignment: .top) { Divider() }
    }

    // MARK: - Helpers

    private func checkoutCard<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: SpotlySpacing.sm) {
            Text(title)
                .font(SpotlyFont.headline(.semibold))
                .foregroundStyle(SpotlyColors.textPrimary)
                .padding(.horizontal, SpotlySpacing.screenPadding)
                .padding(.top, SpotlySpacing.sm)
            VStack(spacing: 0) {
                content()
                    .padding(.horizontal, SpotlySpacing.screenPadding)
                    .padding(.vertical, SpotlySpacing.sm)
            }
            .background(SpotlyColors.surface)
        }
    }

    private func paymentIcon(_ option: String) -> String {
        switch option {
        case "Paynow":           return "creditcard.fill"
        case "EcoCash":          return "iphone"
        case "Cash on delivery": return "banknote"
        default:                 return "creditcard"
        }
    }

    private func placeOrder() {
        SpotlyHaptics.medium()
        isPlacing = true
        Task {
            try? await Task.sleep(nanoseconds: 1_500_000_000)
            await MainActor.run {
                isPlacing = false
                let summary = cart.prefix(3).map { "\($0.quantity)x \($0.name)" }.joined(separator: ", ")
                appState.addOrder(SpotlyOrder(
                    id: "ord-\(Int(Date().timeIntervalSince1970))",
                    businessID: business.id,
                    businessName: business.name,
                    itemsSummary: summary.isEmpty ? "Spotly order" : summary,
                    total: total,
                    status: business.categoryID == "groceries" ? "Packing groceries" : "Preparing",
                    createdAt: Date()
                ))
                showTracking = true
            }
        }
    }
}
