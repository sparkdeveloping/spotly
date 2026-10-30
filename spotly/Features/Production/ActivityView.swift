import SwiftUI
import MapKit

struct ActivityView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        NavigationStack {
            Group {
                if !appState.isAuthenticated {
                    SignInRequiredView(title: "Sign in to see Activity", message: "Orders, bookings, tickets, rides and Sends stay together here.")
                } else if appState.activity.isLoading && appState.activity.records.isEmpty {
                    ProgressView("Loading Activity…")
                } else if let error = appState.activity.errorMessage, appState.activity.records.isEmpty {
                    SpotlyNetworkStateView(title: "Couldn’t load Activity", message: error, actionTitle: "Try again") {
                        Task { await appState.activity.load(user: appState.currentUser, force: true) }
                    }
                } else if appState.activity.records.isEmpty {
                    ContentUnavailableView {
                        Label("No activity yet", systemImage: "clock.arrow.circlepath")
                    } description: {
                        Text("Orders, bookings, tickets, rides and Sends will appear here as soon as you start something on Spotly.")
                    }
                } else {
                    List {
                        if appState.activity.errorMessage != nil {
                            SpotlyRefreshBanner(message: "Activity couldn’t refresh. Showing your most recent activity.") {
                                Task { await appState.activity.load(user: appState.currentUser, force: true) }
                            }
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets(top: 6, leading: 0, bottom: 8, trailing: 0))
                        }
                        ForEach(ActivitySectionKind.allCases, id: \.self) { section in
                            let records = appState.activity.records.filter { $0.section == section }
                            if !records.isEmpty {
                                Section(section.rawValue) {
                                    ForEach(records) { record in
                                        NavigationLink { ActivityDetailView(record: record) } label: {
                                            ActivityRow(record: record)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .safeAreaInset(edge: .bottom) {
                        if appState.activity.nextOffset != nil { Button("Load older activity") { Task { await appState.activity.loadMore() } }.disabled(appState.activity.isLoading).padding(8) }
                    }
                    .listStyle(.insetGrouped)
                    .refreshable { await appState.activity.load(user: appState.currentUser, force: true) }
                }
            }
            .navigationTitle("Activity")
            .task { if appState.isAuthenticated { await appState.activity.load(user: appState.currentUser) } }
        }
    }
}

private struct ActivityRow: View {
    let record: ActivityRecord

    var body: some View {
        HStack(spacing: 13) {
            Image(systemName: record.kind.icon)
                .font(.system(size: 19, weight: .semibold))
                .foregroundStyle(tint)
                .frame(width: 42, height: 42)
                .background(tint.opacity(0.10), in: RoundedRectangle(cornerRadius: 13))
            VStack(alignment: .leading, spacing: 7) {
                Text(record.title).font(SpotlyFont.headline()).fixedSize(horizontal: false, vertical: true)
                Text("\(record.kind.title) \(record.number)").font(.caption).foregroundStyle(.secondary)
                if let date = record.scheduledAt ?? record.createdAt { Text(date, style: .date).font(.caption).foregroundStyle(.secondary) }
                if !record.subtitle.isEmpty { Text(record.subtitle).font(.caption).foregroundStyle(.secondary) }
                SpotlyStatusPill(text: record.attentionReason ?? record.state, color: record.section == .attention ? SpotlyColors.warning : tint)
                if let total = record.total { Text(money(total, currency: record.currency)).font(.subheadline.bold()).foregroundStyle(.primary) }
                if record.section == .attention { Label(record.actionTitle, systemImage: "chevron.right").font(.subheadline.bold()).foregroundStyle(tint) }
            }
        }
        .padding(.vertical, 3)
    }

    private var tint: Color {
        if let service = record.service { return service.tint }
        switch record.kind {
        case .ride: return SpotlyServiceKind.ride.tint
        case .send: return SpotlyServiceKind.send.tint
        case .ticket: return SpotlyServiceKind.events.tint
        case .appointment, .booking: return SpotlyServiceKind.book.tint
        case .order: return SpotlyColors.accent
        }
    }
}

struct ActivityDetailView: View {
    let record: ActivityRecord
    @Environment(AppState.self) private var appState
    @State private var ride: RideTrip?
    @State private var parcel: ParcelJob?
    @State private var didFail = false

    var body: some View {
        Group {
            switch record.kind {
            case .ride:
                if let ride { RideTrackingView(initialRide: ride) }
                else if didFail { loadError }
                else { ProgressView("Opening ride…").task { await loadRide() } }
            case .send:
                if let parcel { SendTrackingView(initialParcel: parcel) }
                else if didFail { loadError }
                else { ProgressView("Opening Send…").task { await loadParcel() } }
            default:
                OrderActivityDetailView(record: record)
            }
        }
    }

    private var loadError: some View {
        SpotlyNetworkStateView(title: "Tracking unavailable",
                               message: "This request is recorded, but its tracking details could not be loaded.",
                               actionTitle: "Retry tracking") {
            didFail = false
        }
        .padding(18)
    }
    private func loadRide() async { guard let id = record.rideId else { didFail = true; return }; do { ride = try await appState.activity.ride(id: id) } catch { didFail = true } }
    private func loadParcel() async { guard let id = record.parcelId else { didFail = true; return }; do { parcel = try await appState.activity.parcel(id: id) } catch { didFail = true } }
}

struct OrderActivityDetailView: View {
    let record: ActivityRecord
    @Environment(AppState.self) private var appState
    @Environment(\.scenePhase) private var scenePhase
    @State private var refreshing = false
    @Environment(\.openURL) private var openURL
    @State private var status: CustomerOrderStatusResponse?
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var isWorking = false
    @State private var showCancel = false
    @State private var showReview = false
    @State private var rating = 5
    @State private var reviewComment = ""

    var body: some View {
        ScrollView {
            if let status {
                VStack(alignment: .leading, spacing: 20) {
                    statusHeader(status)
                    lineItems(status.order.items, currency: status.order.currency)
                    if let delivery = status.delivery { deliverySection(delivery) }
                    totals(status.order)
                    actions(status)
                    if let errorMessage { Label(errorMessage, systemImage: "exclamationmark.triangle.fill").font(SpotlyFont.callout()).foregroundStyle(SpotlyColors.error) }
                }
                .padding(18).padding(.bottom, 30)
            } else if isLoading {
                ProgressView("Refreshing Activity…").frame(maxWidth: .infinity).padding(.vertical, 90)
            } else {
                SpotlyNetworkStateView(title: "Couldn’t load this activity", message: errorMessage ?? "Try again.", actionTitle: "Try again") { Task { await load() } }.padding(18)
            }
        }
        .background(SpotlyColors.background)
        .navigationTitle(record.number)
        .navigationBarTitleDisplayMode(.inline)
        .refreshable { await load() }
        .task(id: scenePhase) { if scenePhase == .active { await load(); await pollingLoop() } }
        .confirmationDialog("Cancel this activity?", isPresented: $showCancel, titleVisibility: .visible) {
            Button("Cancel", role: .destructive) { Task { await cancel() } }
            Button("Keep it", role: .cancel) { }
        } message: { Text("Spotly will verify cancellation eligibility on the server before changing anything.") }
        .sheet(isPresented: $showReview) {
            NavigationStack {
                Form {
                    Section("Rating") { Picker("Rating", selection: $rating) { ForEach(1...5, id: \.self) { Text("\($0) star\($0 == 1 ? "" : "s")").tag($0) } }.pickerStyle(.segmented) }
                    Section("Comment") { TextField("Optional feedback", text: $reviewComment, axis: .vertical).lineLimit(4...8) }
                }
                .navigationTitle("Rate this activity")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) { Button("Cancel") { showReview = false } }
                    ToolbarItem(placement: .confirmationAction) { Button("Submit") { Task { await submitReview() } } }
                }
            }
        }
    }

    private func statusHeader(_ response: CustomerOrderStatusResponse) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack { Text(response.order.businessName).font(SpotlyFont.title(.bold)); Spacer(); SpotlyStatusPill(text: response.delivery?.state ?? response.order.status, color: record.section == .attention ? SpotlyColors.error : SpotlyColors.accent) }
            Text(response.delivery?.stateLabel ?? response.order.status.replacingOccurrences(of: "_", with: " ").capitalized)
                .font(SpotlyFont.callout()).foregroundStyle(SpotlyColors.textSecondary)
            Text("Reference \(response.order.number)").font(SpotlyFont.caption()).foregroundStyle(SpotlyColors.textTertiary)
        }
        .padding(17).background(SpotlyColors.accent.opacity(0.07), in: RoundedRectangle(cornerRadius: 20))
    }

    private func lineItems(_ items: [CustomerOrderLine], currency: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Items").font(SpotlyFont.title3())
            ForEach(items) { line in
                HStack(spacing: 12) {
                    SpotlyRemoteImage(url: URL(string: line.image ?? ""), cornerRadius: 10, aspectRatio: 1, fallbackIcon: "bag", tint: SpotlyColors.accent).frame(width: 50, height: 50)
                    VStack(alignment: .leading, spacing: 3) { Text(line.name ?? "Item").font(SpotlyFont.headline()); if let variant = line.variant, !variant.isEmpty { Text(variant).font(SpotlyFont.caption()).foregroundStyle(SpotlyColors.textSecondary) } }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 3) { Text("×\(line.quantity ?? 1)").font(SpotlyFont.caption()); Text(money(line.lineTotal ?? 0, currency: currency)).font(SpotlyFont.callout(.bold)) }
                }
            }
        }
    }

    @ViewBuilder private func deliverySection(_ delivery: CustomerDeliveryStatus) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Delivery").font(SpotlyFont.title3())
            if let driver = delivery.driver {
                HStack(spacing: 12) {
                    Image(systemName: "person.fill").frame(width: 46, height: 46).background(SpotlyColors.accentSoft, in: Circle()).foregroundStyle(SpotlyColors.accent)
                    VStack(alignment: .leading, spacing: 3) { Text(driver.firstName ?? "Spotly Driver").font(SpotlyFont.headline()); let vehicle = driver.vehicle; Text([vehicle?.color, vehicle?.make, vehicle?.model, vehicle?.registration].compactMap { $0?.nilIfBlank }.joined(separator: " · ")).font(SpotlyFont.caption()).foregroundStyle(SpotlyColors.textSecondary) }
                }
            }
            if let lat = delivery.driverLocation?.lat, let lng = delivery.driverLocation?.lng {
                Map { Marker("Driver", systemImage: "car.fill", coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lng)).tint(SpotlyColors.accent) }
                    .frame(height: 210).clipShape(RoundedRectangle(cornerRadius: 18)).allowsHitTesting(false)
            }
            if let pin = delivery.customerPin, !pin.isEmpty {
                VStack(alignment: .leading, spacing: 5) { Text("Delivery PIN").font(SpotlyFont.caption(.semibold)); Text(pin).font(.system(size: 30, weight: .bold, design: .rounded)).tracking(6); Text("Share only when you have your order.").font(SpotlyFont.caption()).foregroundStyle(SpotlyColors.textSecondary) }
                    .padding(14).frame(maxWidth: .infinity, alignment: .leading).background(SpotlyColors.warningBg, in: RoundedRectangle(cornerRadius: 16))
            }
        }
    }

    private func totals(_ order: CustomerOrderStatus) -> some View {
        HStack { VStack(alignment: .leading, spacing: 3) { Text("Total").font(SpotlyFont.caption()).foregroundStyle(SpotlyColors.textSecondary); Text(money(order.totals?.total ?? record.total ?? 0, currency: order.currency)).font(SpotlyFont.title2(.bold)) }; Spacer(); SpotlyStatusPill(text: order.paymentStatus, color: ["paid", "not_required"].contains(order.paymentStatus) ? SpotlyColors.success : SpotlyColors.warning) }
        .padding(15).background(SpotlyColors.surface, in: RoundedRectangle(cornerRadius: 18)).overlay(RoundedRectangle(cornerRadius: 18).stroke(SpotlyColors.border))
    }

    private func actions(_ response: CustomerOrderStatusResponse) -> some View {
        VStack(spacing: 10) {
            if ["unpaid", "initiated", "awaiting_payment"].contains(response.order.paymentStatus), (response.order.totals?.total ?? 0) > 0 {
                actionButton("Complete payment", icon: "creditcard.fill", tint: SpotlyColors.accent) { Task { await pay() } }
            }
            if ["awaiting_payment", "submitted", "new", "requested", "confirmed", "accepted"].contains(response.order.status), !["paid", "refund_pending", "refunded"].contains(response.order.paymentStatus) {
                Button("Cancel", role: .destructive) { showCancel = true }.buttonStyle(.bordered).frame(maxWidth: .infinity)
            }
            if ["completed", "delivered", "checked_out"].contains(response.order.status) || response.order.deliveryStatus == "delivered" {
                actionButton("Rate this experience", icon: "star", tint: SpotlyColors.ratingGold) { showReview = true }
            }
            NavigationLink { SupportView(contextType: "order", contextID: response.order.id, defaultSubject: "Help with \(response.order.number)") } label: {
                Label("Get help", systemImage: "questionmark.circle").font(SpotlyFont.headline()).frame(maxWidth: .infinity).frame(height: 48)
            }
            .buttonStyle(.bordered)
        }
        .disabled(isWorking)
    }

    private func actionButton(_ title: String, icon: String, tint: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) { Label(title, systemImage: icon).font(SpotlyFont.headline(.bold)).frame(maxWidth: .infinity).frame(height: 48).background(tint, in: RoundedRectangle(cornerRadius: 15)).foregroundStyle(.white) }.buttonStyle(.plain)
    }

    private func load() async {
        guard !refreshing, !Task.isCancelled else { return }
        refreshing = true; defer { refreshing = false }
        guard let orderID = record.orderId else { isLoading = false; errorMessage = "Missing order reference."; return }
        isLoading = true; errorMessage = nil; defer { isLoading = false }
        do { status = try await SpotlyCommerceService.shared.orderStatus(orderID: orderID) } catch { if !Task.isCancelled { errorMessage = error.localizedDescription } }
    }

    private func pollingLoop() async {
        var failures = 0
        while !Task.isCancelled && scenePhase == .active {
            if let state = status?.order.status, PollingPolicy.isTerminal(state) { return }
            failures = errorMessage == nil ? 0 : failures + 1
            do { try await Task.sleep(for: PollingPolicy.delay(failures: failures)) } catch { return }
            guard !Task.isCancelled, scenePhase == .active else { return }
            await load()
        }
    }

    private func pay() async {
        guard let orderID = record.orderId else { return }; isWorking = true; defer { isWorking = false }
        do { let result = try await SpotlyCommerceService.shared.initiatePaynow(orderId: orderID); if let value = result.redirectUrl, let url = URL(string: value) { openURL(url) }; await load() } catch { if !Task.isCancelled { errorMessage = error.localizedDescription } }
    }
    private func cancel() async {
        guard let orderID = record.orderId else { return }; isWorking = true; defer { isWorking = false }
        do { _ = try await SpotlyCommerceService.shared.cancelOrder(orderID: orderID, reason: "Cancelled by customer in Spotly iOS"); await load(); await appState.activity.load(user: appState.currentUser, force: true) } catch { if !Task.isCancelled { errorMessage = error.localizedDescription } }
    }
    private func submitReview() async {
        guard let orderID = record.orderId else { return }; isWorking = true; defer { isWorking = false }
        do { _ = try await SpotlyCommerceService.shared.review(orderID: orderID, rating: rating, comment: reviewComment); showReview = false } catch { if !Task.isCancelled { errorMessage = error.localizedDescription } }
    }
}
