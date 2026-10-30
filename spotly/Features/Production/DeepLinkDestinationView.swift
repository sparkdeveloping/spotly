import SwiftUI

struct DeepLinkDestinationView: View {
    @Environment(AppState.self) private var appState
    let route: DeepLinkRoute

    var body: some View {
        NavigationStack {
            Group {
                switch route.destination {
                case .business(let id):
                    MarketplaceBusinessDetailView(businessID: id, service: nil)
                case .item(let id, let title):
                    RemoteItemResolverView(itemID: id, titleHint: title)
                case .order(let id):
                    OrderActivityDetailView(record: ActivityRecord(
                        id: id, kind: .order, title: "Spotly activity", subtitle: "", state: "submitted",
                        paymentStatus: "", number: id, total: nil, currency: "USD", createdAt: nil,
                        orderId: id, rideId: nil, parcelId: nil
                    ))
                case .ride(let id):
                    OperationalResolverView(kind: .ride, id: id)
                case .send(let id):
                    OperationalResolverView(kind: .send, id: id)
                case .service(let service):
                    switch service {
                    case .ride: RideRequestView()
                    case .send: SendRequestView()
                    case .eat, .shop, .book, .events: ServiceDiscoveryView(service: service)
                    }
                case .support:
                    SupportView()
                case .notifications:
                    NotificationCenterView()
                case .paymentReturn(let orderID):
                    PaymentReturnView(orderID: orderID)
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { appState.pendingDeepLink = nil }
                }
            }
        }
    }
}

private struct RemoteItemResolverView: View {
    let itemID: String
    let titleHint: String?
    @State private var item: RemoteItem?
    @State private var errorMessage: String?

    var body: some View {
        Group {
            if let item {
                MarketplaceItemDetailView(item: item, service: inferredService)
            } else if let errorMessage {
                ContentUnavailableView("Item unavailable", systemImage: "bag.badge.questionmark", description: Text(errorMessage))
            } else {
                ProgressView("Loading item…")
            }
        }
        .task { await resolve() }
    }

    private var inferredService: SpotlyServiceKind {
        guard let item else { return .shop }
        if item.type == "event" || item.itemType == "event" { return .events }
        if item.type == "service" || item.durationMinutes != nil { return .book }
        return .shop
    }

    private func resolve() async {
        do {
            if NativeMarketplaceRepository.shared.isConfigured,
               let native = try await NativeMarketplaceRepository.shared.publicItem(id: itemID) {
                item = native
                return
            }
            let query = titleHint?.nilIfBlank ?? itemID
            let response: SearchResponse
            do {
                response = try await APIClient.shared.get("/api/public/search", query: [
                    URLQueryItem(name: "q", value: query),
                    URLQueryItem(name: "limit", value: "40")
                ])
            } catch {
                guard NativeMarketplaceRepository.shared.isConfigured else { throw error }
                response = try await NativeMarketplaceRepository.shared.fallbackSearch(
                    query: query, city: "", service: nil, limit: 40)
            }
            guard let match = response.results.first(where: { $0.entityID == itemID || $0.id == itemID }) else {
                errorMessage = "This item may have been removed or is not currently available."
                return
            }
            item = RemoteItem(searchResult: match)
        } catch { errorMessage = error.localizedDescription }
    }
}

extension RemoteItem {
    init(searchResult match: RemoteSearchResult) {
        self.init(
            id: match.entityID, entityId: match.entityId, type: match.type, businessId: match.businessId,
            businessName: match.businessName, name: match.name, title: match.title, description: match.description,
            category: match.category, image: match.image, brand: nil, variant: nil, packSize: nil, unit: nil,
            currency: match.currency, price: match.price, prices: match.prices, compareAtPrice: nil, stockStatus: nil,
            stockQuantity: nil, available: nil, itemType: match.itemType, durationMinutes: nil, capacity: nil,
            remainingCapacity: nil, startsAt: match.startsAt, endsAt: nil, venue: match.venue, city: match.city,
            area: match.area, tags: nil, isFeatured: nil, maxQuantity: nil, pickupEligible: nil, published: nil,
            promotion: nil, business: match.business
        )
    }
}


private struct OperationalResolverView: View {
    enum Kind { case ride, send }
    @Environment(AppState.self) private var appState
    let kind: Kind
    let id: String
    @State private var ride: RideTrip?
    @State private var parcel: ParcelJob?
    @State private var error: String?

    var body: some View {
        Group {
            if let ride { RideTrackingView(initialRide: ride) }
            else if let parcel { SendTrackingView(initialParcel: parcel) }
            else if let error { ContentUnavailableView("Activity unavailable", systemImage: "exclamationmark.triangle", description: Text(error)) }
            else { ProgressView("Opening Activity…") }
        }
        .task {
            do {
                switch kind {
                case .ride: ride = try await appState.activity.ride(id: id)
                case .send: parcel = try await appState.activity.parcel(id: id)
                }
            } catch { self.error = error.localizedDescription }
        }
    }
}


private struct PaymentReturnView: View {
    let orderID: String
    @Environment(AppState.self) private var appState
    @State private var result: PaynowStatusResponse?
    @State private var isChecking = true
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 22) {
            Spacer(minLength: 24)
            Image(systemName: statusIcon)
                .font(.system(size: 46, weight: .semibold))
                .foregroundStyle(statusColor)
                .frame(width: 84, height: 84)
                .background(statusColor.opacity(0.11), in: RoundedRectangle(cornerRadius: 26, style: .continuous))
                .accessibilityHidden(true)

            VStack(spacing: 8) {
                Text(title)
                    .font(SpotlyFont.title(.bold))
                    .multilineTextAlignment(.center)
                Text(message)
                    .font(SpotlyFont.body())
                    .foregroundStyle(SpotlyColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }

            VStack(spacing: 6) {
                Text("Reference")
                    .font(SpotlyFont.caption(.semibold))
                    .foregroundStyle(SpotlyColors.textSecondary)
                Text(result?.number?.nilIfBlank ?? orderID)
                    .font(.system(.footnote, design: .monospaced, weight: .semibold))
                    .foregroundStyle(SpotlyColors.textPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
            }
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity)
            .background(SpotlyColors.surface, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 18).stroke(SpotlyColors.border))

            if let errorMessage {
                Label(errorMessage, systemImage: "exclamationmark.triangle.fill")
                    .font(SpotlyFont.callout())
                    .foregroundStyle(SpotlyColors.error)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            VStack(spacing: 10) {
                Button {
                    Task { await check() }
                } label: {
                    HStack {
                        Spacer()
                        if isChecking { ProgressView().tint(.white) }
                        else { Label("Check again", systemImage: "arrow.clockwise") }
                        Spacer()
                    }
                    .font(SpotlyFont.headline(.semibold))
                    .frame(height: 50)
                    .background(SpotlyColors.accent, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .foregroundStyle(.white)
                }
                .buttonStyle(.plain)
                .disabled(isChecking || !appState.isAuthenticated)

                Button("Open Activity") {
                    appState.selectedTab = .activity
                    appState.pendingDeepLink = nil
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
            }

            Spacer()
        }
        .padding(20)
        .background(SpotlyColors.background)
        .navigationTitle("Payment")
        .navigationBarTitleDisplayMode(.inline)
        .task { await check() }
    }

    private var title: String {
        if !appState.isAuthenticated { return "Sign in to check payment" }
        if isChecking && result == nil { return "Checking your payment" }
        if result?.isPaid == true { return "Payment confirmed" }
        return "Payment is still settling"
    }

    private var message: String {
        if !appState.isAuthenticated { return "Your payment is safe. Sign in with the Spotly account that created this transaction, then open Activity to check the authoritative status." }
        if isChecking && result == nil { return "Spotly is checking the payment provider and your order before showing a final state." }
        if result?.isPaid == true {
            let object = transactionLabel
            let business = result?.businessName?.nilIfBlank.map { " from \($0)" } ?? ""
            return "Your \(object) payment is confirmed\(business). Activity now has the latest status."
        }
        return "Some Paynow payments take a moment to settle. Check again before attempting another payment so you do not pay twice."
    }

    private var transactionLabel: String {
        switch result?.transactionType?.lowercased() {
        case "ticket": return "ticket"
        case "appointment": return "appointment"
        case "booking": return "booking"
        default: return result?.fulfilment?.lowercased() == "delivery" ? "delivery order" : "order"
        }
    }

    private var statusIcon: String {
        if isChecking && result == nil { return "arrow.triangle.2.circlepath" }
        return result?.isPaid == true ? "checkmark.circle.fill" : "clock.badge.questionmark"
    }

    private var statusColor: Color {
        if result?.isPaid == true { return SpotlyColors.success }
        if let errorMessage, !errorMessage.isEmpty { return SpotlyColors.error }
        return SpotlyColors.accent
    }

    private func check() async {
        guard appState.isAuthenticated else { isChecking = false; return }
        isChecking = true
        errorMessage = nil
        defer { isChecking = false }
        do {
            result = try await SpotlyCommerceService.shared.paymentStatus(orderId: orderID)
            await appState.activity.load(user: appState.currentUser, force: true)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
