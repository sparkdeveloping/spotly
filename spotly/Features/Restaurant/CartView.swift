import SwiftUI

struct CartView: View {
    let business: SpotlyBusiness
    @Binding var cart: [CartItem]
    @Environment(\.dismiss) private var dismiss
    @State private var showCheckout = false

    var subtotal: Double { cart.reduce(0) { $0 + $1.total } }
    var deliveryFee: Double { 2.50 }
    var serviceFee: Double { subtotal * 0.05 }
    var total: Double { subtotal + deliveryFee + serviceFee }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if cart.isEmpty {
                    emptyCart
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 0) {
                            cartItemsList
                            orderSummarySection
                            SpotlyBottomSafeSpacer(extra: 80)
                        }
                    }
                }
            }
            .background(SpotlyColors.background)
            .navigationTitle("Your order")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                if !cart.isEmpty {
                    checkoutButton
                }
            }
            .sheet(isPresented: $showCheckout) {
                CheckoutView(business: business, cart: cart, total: total)
            }
        }
    }

    // MARK: - Cart items list

    private var cartItemsList: some View {
        VStack(spacing: 0) {
            HStack {
                Text(business.name)
                    .font(SpotlyFont.headline(.semibold))
                    .foregroundStyle(SpotlyColors.textPrimary)
                Spacer()
            }
            .padding(.horizontal, SpotlySpacing.screenPadding)
            .padding(.vertical, SpotlySpacing.md)

            ForEach(cart) { item in
                CartItemRow(item: item) { newQty in
                    updateQuantity(item, qty: newQty)
                }
                Divider().padding(.leading, SpotlySpacing.screenPadding)
            }
        }
        .background(SpotlyColors.surface)
    }

    // MARK: - Order summary

    private var orderSummarySection: some View {
        VStack(spacing: 0) {
            summaryRow(label: "Subtotal", value: "US$\(String(format: "%.2f", subtotal))")
            Divider().padding(.horizontal, SpotlySpacing.screenPadding)
            summaryRow(label: "Delivery fee", value: "US$\(String(format: "%.2f", deliveryFee))")
            Divider().padding(.horizontal, SpotlySpacing.screenPadding)
            summaryRow(label: "Service fee (5%)", value: "US$\(String(format: "%.2f", serviceFee))")
            Divider()
            summaryRow(label: "Total", value: "US$\(String(format: "%.2f", total))", isTotal: true)
        }
        .background(SpotlyColors.surface)
        .padding(.top, SpotlySpacing.sm)
    }

    private func summaryRow(label: String, value: String, isTotal: Bool = false) -> some View {
        HStack {
            Text(label)
                .font(isTotal ? SpotlyFont.headline(.semibold) : SpotlyFont.callout())
                .foregroundStyle(isTotal ? SpotlyColors.textPrimary : SpotlyColors.textSecondary)
            Spacer()
            Text(value)
                .font(isTotal ? SpotlyFont.headline(.bold) : SpotlyFont.callout(.semibold))
                .foregroundStyle(isTotal ? SpotlyColors.accent : SpotlyColors.textPrimary)
        }
        .padding(.horizontal, SpotlySpacing.screenPadding)
        .padding(.vertical, SpotlySpacing.sm)
    }

    // MARK: - Checkout button

    private var checkoutButton: some View {
        Button {
            SpotlyHaptics.medium()
            showCheckout = true
        } label: {
            HStack {
                Text("Proceed to checkout")
                    .font(SpotlyFont.headline())
                Spacer()
                Text("US$\(String(format: "%.2f", total))")
                    .font(SpotlyFont.headline(.bold))
            }
            .foregroundStyle(.white)
            .padding(.horizontal, SpotlySpacing.xl)
            .frame(height: 56)
            .frame(maxWidth: .infinity)
            .background(SpotlyColors.accent)
            .clipShape(RoundedRectangle(cornerRadius: SpotlyRadius.sm + 2))
        }
        .buttonStyle(.plain)
        .pressableScale()
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 10)
        .background(.regularMaterial)
        .overlay(alignment: .top) { Divider() }
    }

    // MARK: - Empty cart

    private var emptyCart: some View {
        VStack(spacing: SpotlySpacing.lg) {
            Spacer()
            Image(systemName: "cart")
                .font(.system(size: 48, weight: .light))
                .foregroundStyle(SpotlyColors.textTertiary)
            Text("Your cart is empty")
                .font(SpotlyFont.title3(.semibold))
                .foregroundStyle(SpotlyColors.textPrimary)
            Text("Add items from the menu to get started")
                .font(SpotlyFont.callout())
                .foregroundStyle(SpotlyColors.textSecondary)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    private func updateQuantity(_ item: CartItem, qty: Int) {
        if let idx = cart.firstIndex(where: { $0.id == item.id }) {
            if qty <= 0 {
                cart.remove(at: idx)
            } else {
                cart[idx].quantity = qty
            }
        }
    }
}

// MARK: - Cart item row

private struct CartItemRow: View {
    let item: CartItem
    let onQuantityChange: (Int) -> Void

    var body: some View {
        HStack(alignment: .center, spacing: SpotlySpacing.md) {
            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .font(SpotlyFont.callout(.semibold))
                    .foregroundStyle(SpotlyColors.textPrimary)
                Text("US$\(String(format: "%.2f", item.price)) each")
                    .font(SpotlyFont.caption())
                    .foregroundStyle(SpotlyColors.textSecondary)
            }
            Spacer()
            HStack(spacing: SpotlySpacing.sm) {
                Button { onQuantityChange(item.quantity - 1) } label: {
                    Image(systemName: "minus.circle")
                        .font(.system(size: 22))
                        .foregroundStyle(SpotlyColors.textTertiary)
                }
                .buttonStyle(.plain)
                Text("\(item.quantity)")
                    .font(SpotlyFont.headline(.bold))
                    .foregroundStyle(SpotlyColors.textPrimary)
                    .frame(minWidth: 20)
                Button { onQuantityChange(item.quantity + 1) } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 22))
                        .foregroundStyle(SpotlyColors.accent)
                }
                .buttonStyle(.plain)
            }
            Text("US$\(String(format: "%.2f", item.total))")
                .font(SpotlyFont.callout(.semibold))
                .foregroundStyle(SpotlyColors.textPrimary)
                .frame(minWidth: 56, alignment: .trailing)
        }
        .padding(.horizontal, SpotlySpacing.screenPadding)
        .padding(.vertical, SpotlySpacing.sm)
    }
}
