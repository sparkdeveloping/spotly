import SwiftUI

// MARK: - Cart item model

struct CartItem: Identifiable {
    let id: String
    let name: String
    let price: Double
    var quantity: Int
    var total: Double { price * Double(quantity) }
}

// MARK: - Menu item model

struct MenuItem: Identifiable {
    let id: String
    let name: String
    let description: String
    let price: Double
    let category: String
    let imageName: String?
    var priceText: String { "US$\(String(format: "%.2f", price))" }
}

// MARK: - Restaurant Menu View

struct RestaurantMenuView: View {
    let business: SpotlyBusiness
    @State private var selectedCategory = "Popular"
    @State private var cart: [CartItem] = []
    @State private var showCart = false

    var menuCategories: [String] {
        let categories = business.services.compactMap(\.category)
        return ["Popular"] + Array(Set(categories)).sorted()
    }

    var menuItems: [MenuItem] {
        let items = business.services.enumerated().map { _, service in
            MenuItem(id: service.id, name: service.name, description: service.description, price: service.price, category: service.category ?? "Popular", imageName: nil)
        }
        if items.isEmpty { return sampleMenuItems.filter { $0.category == selectedCategory || selectedCategory == "Popular" } }
        return selectedCategory == "Popular" ? items : items.filter { $0.category == selectedCategory }
    }

    var cartTotal: Double { cart.reduce(0) { $0 + $1.total } }
    var cartCount: Int { cart.reduce(0) { $0 + $1.quantity } }

    var body: some View {
        VStack(spacing: 0) {
            categoryTabs
            Divider()
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(menuItems) { item in
                        MenuItemRow(item: item, quantity: quantityFor(item)) {
                            addToCart(item)
                        } onRemove: {
                            removeFromCart(item)
                        }
                        Divider().padding(.leading, 96)
                    }
                    SpotlyBottomSafeSpacer(extra: cartCount > 0 ? 80 : 16)
                }
            }
        }
        .background(SpotlyColors.background)
        .navigationTitle(business.name)
        .navigationBarTitleDisplayMode(.large)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            if cartCount > 0 {
                viewCartButton
            }
        }
        .sheet(isPresented: $showCart) {
            CartView(business: business, cart: $cart)
        }
    }

    // MARK: - Category tabs

    private var categoryTabs: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: SpotlySpacing.xs) {
                ForEach(menuCategories, id: \.self) { cat in
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) { selectedCategory = cat }
                    } label: {
                        Text(cat)
                            .font(SpotlyFont.callout(selectedCategory == cat ? .semibold : .regular))
                            .foregroundStyle(selectedCategory == cat ? .white : SpotlyColors.textSecondary)
                            .padding(.horizontal, SpotlySpacing.md)
                            .padding(.vertical, SpotlySpacing.xs)
                            .background(selectedCategory == cat ? SpotlyColors.accent : Color.clear)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, SpotlySpacing.screenPadding)
            .padding(.vertical, SpotlySpacing.sm)
        }
        .background(SpotlyColors.surface)
    }

    // MARK: - View cart button

    private var viewCartButton: some View {
        Button {
            SpotlyHaptics.medium()
            showCart = true
        } label: {
            HStack {
                Text("View cart (\(cartCount))")
                    .font(SpotlyFont.headline())
                Spacer()
                Text("US$\(String(format: "%.2f", cartTotal))")
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
        .padding(.horizontal, SpotlySpacing.screenPadding)
        .padding(.vertical, SpotlySpacing.sm)
        .background(SpotlyColors.surface)
        .overlay(alignment: .top) { Divider() }
    }

    // MARK: - Cart helpers

    private func quantityFor(_ item: MenuItem) -> Int {
        cart.first(where: { $0.id == item.id })?.quantity ?? 0
    }

    private func addToCart(_ item: MenuItem) {
        SpotlyHaptics.lightTap()
        if let idx = cart.firstIndex(where: { $0.id == item.id }) {
            cart[idx].quantity += 1
        } else {
            cart.append(CartItem(id: item.id, name: item.name, price: item.price, quantity: 1))
        }
    }

    private func removeFromCart(_ item: MenuItem) {
        SpotlyHaptics.lightTap()
        guard let idx = cart.firstIndex(where: { $0.id == item.id }) else { return }
        if cart[idx].quantity > 1 {
            cart[idx].quantity -= 1
        } else {
            cart.remove(at: idx)
        }
    }

    // MARK: - Sample menu data

    private var sampleMenuItems: [MenuItem] {
        [
            MenuItem(id: "1", name: "Grilled Chicken Platter", description: "Juicy grilled chicken with seasoned fries and coleslaw", price: 12.99, category: "Popular", imageName: nil),
            MenuItem(id: "2", name: "Beef Burger", description: "Double beef patty, cheddar, lettuce, tomato, special sauce", price: 9.99, category: "Popular", imageName: nil),
            MenuItem(id: "3", name: "Veggie Pizza", description: "Wood-fired, mozzarella, bell peppers, mushrooms, olives", price: 11.50, category: "Popular", imageName: nil),
            MenuItem(id: "4", name: "Chicken Combo", description: "2-piece chicken, chips, coleslaw, and a drink", price: 15.99, category: "Combos", imageName: nil),
            MenuItem(id: "5", name: "Family Combo", description: "4-piece chicken, large chips, 4 drinks, large coleslaw", price: 34.99, category: "Combos", imageName: nil),
            MenuItem(id: "6", name: "Sadza & Stew", description: "Traditional sadza with your choice of stew: beef, chicken, or vegetable", price: 8.50, category: "Mains", imageName: nil),
            MenuItem(id: "7", name: "Nyama Choma", description: "Char-grilled beef ribs served with chimichurri and sides", price: 18.00, category: "Mains", imageName: nil),
            MenuItem(id: "8", name: "Seasoned Fries", description: "Crispy golden fries with seasoning salt", price: 3.50, category: "Sides", imageName: nil),
            MenuItem(id: "9", name: "Coleslaw", description: "Creamy homemade coleslaw", price: 2.50, category: "Sides", imageName: nil),
            MenuItem(id: "10", name: "Coca-Cola 500ml", description: "Chilled Coca-Cola", price: 1.50, category: "Drinks", imageName: nil),
            MenuItem(id: "11", name: "Fresh Mango Juice", description: "Freshly squeezed mango juice", price: 3.00, category: "Drinks", imageName: nil),
        ]
    }
}

// MARK: - Menu item row

private struct MenuItemRow: View {
    let item: MenuItem
    let quantity: Int
    let onAdd: () -> Void
    let onRemove: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: SpotlySpacing.md) {
            // Image placeholder
            ZStack {
                RoundedRectangle(cornerRadius: SpotlyRadius.sm)
                    .fill(SpotlyColors.backgroundElevated)
                Image(systemName: "fork.knife")
                    .font(.system(size: 20, weight: .light))
                    .foregroundStyle(SpotlyColors.textTertiary)
            }
            .frame(width: 80, height: 80)

            VStack(alignment: .leading, spacing: SpotlySpacing.xxs) {
                Text(item.name)
                    .font(SpotlyFont.callout(.semibold))
                    .foregroundStyle(SpotlyColors.textPrimary)
                    .lineLimit(2)
                Text(item.description)
                    .font(SpotlyFont.caption())
                    .foregroundStyle(SpotlyColors.textSecondary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer(minLength: 4)
                HStack {
                    Text(item.priceText)
                        .font(SpotlyFont.callout(.semibold))
                        .foregroundStyle(SpotlyColors.textPrimary)
                    Spacer()
                    if quantity == 0 {
                        Button(action: onAdd) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 28))
                                .foregroundStyle(SpotlyColors.accent)
                        }
                        .buttonStyle(.plain)
                    } else {
                        HStack(spacing: SpotlySpacing.sm) {
                            Button(action: onRemove) {
                                Image(systemName: "minus.circle.fill")
                                    .font(.system(size: 28))
                                    .foregroundStyle(SpotlyColors.textTertiary)
                            }
                            .buttonStyle(.plain)
                            Text("\(quantity)")
                                .font(SpotlyFont.headline(.bold))
                                .foregroundStyle(SpotlyColors.textPrimary)
                                .frame(minWidth: 20)
                            Button(action: onAdd) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 28))
                                    .foregroundStyle(SpotlyColors.accent)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, SpotlySpacing.screenPadding)
        .padding(.vertical, SpotlySpacing.sm)
    }
}
