import SwiftUI
import MapKit

struct RideTrackingView: View {
    let initialRide: RideTrip
    @Environment(AppState.self) private var appState
    @Environment(\.scenePhase) private var scenePhase
    @State private var refreshing = false
    @Environment(\.openURL) private var openURL
    @State private var ride: RideTrip
    @State private var errorMessage: String?
    @State private var showCancel = false
    @State private var cancelReason = ""
    @State private var isWorking = false

    init(initialRide: RideTrip) {
        self.initialRide = initialRide
        _ride = State(initialValue: initialRide)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                statusHero
                routeMap
                routeDetails
                if let driver = ride.driver { driverCard(driver) } else if !isFinal { matchingCard }
                if let pin = ride.pickupPin, !pin.isEmpty { pinCard(pin) }
                fareCard
                if ride.paymentMethod == "paynow", ride.paymentStatus != "paid", isFinal { payButton }
                if canCancel { cancelButton }
                if let errorMessage { Label(errorMessage, systemImage: "exclamationmark.triangle.fill").font(SpotlyFont.callout()).foregroundStyle(SpotlyColors.error) }
            }
            .padding(18).padding(.bottom, 30)
        }
        .background(SpotlyColors.background)
        .navigationTitle(ride.number ?? "Ride")
        .navigationBarTitleDisplayMode(.inline)
        .refreshable { await refresh() }
        .task(id: scenePhase) { if scenePhase == .active { await pollingLoop() } }
        .confirmationDialog("Cancel this ride?", isPresented: $showCancel, titleVisibility: .visible) {
            Button("Cancel ride", role: .destructive) { Task { await cancel() } }
            Button("Keep ride", role: .cancel) { }
        } message: { Text("Spotly checks the server before cancelling. Paid or progressed rides may require Support.") }
    }

    private var statusHero: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: stateIcon).font(.system(size: 22, weight: .semibold))
                Spacer()
                SpotlyStatusPill(text: ride.state, color: SpotlyServiceKind.ride.tint)
            }
            Text(stateCopy.0).font(SpotlyFont.title(.bold))
            Text(stateCopy.1).font(SpotlyFont.callout()).foregroundStyle(SpotlyColors.textSecondary)
        }
        .padding(18)
        .background(SpotlyServiceKind.ride.tint.opacity(0.08), in: RoundedRectangle(cornerRadius: 22))
    }

    @ViewBuilder private var routeMap: some View {
        if let pickup = ride.pickup, let dropoff = ride.dropoff {
            Map {
                Marker("Pickup", coordinate: CLLocationCoordinate2D(latitude: pickup.lat, longitude: pickup.lng)).tint(SpotlyColors.success)
                Marker("Destination", coordinate: CLLocationCoordinate2D(latitude: dropoff.lat, longitude: dropoff.lng)).tint(SpotlyServiceKind.ride.tint)
                if let lat = ride.driverLocation?.lat, let lng = ride.driverLocation?.lng {
                    Marker("Driver", systemImage: "car.fill", coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lng)).tint(SpotlyColors.accent)
                }
            }
            .frame(height: 245).clipShape(RoundedRectangle(cornerRadius: 22)).allowsHitTesting(false)
        }
    }

    private var routeDetails: some View {
        VStack(spacing: 0) {
            routeLine(icon: "circle.fill", label: "Pickup", value: ride.pickup?.displayLabel ?? "Pickup", color: SpotlyColors.success)
            Divider().padding(.leading, 46)
            routeLine(icon: "mappin.circle.fill", label: "Destination", value: ride.dropoff?.displayLabel ?? "Destination", color: SpotlyServiceKind.ride.tint)
        }
        .background(SpotlyColors.surface, in: RoundedRectangle(cornerRadius: 18)).overlay(RoundedRectangle(cornerRadius: 18).stroke(SpotlyColors.border))
    }

    private func routeLine(icon: String, label: String, value: String, color: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon).foregroundStyle(color).frame(width: 22)
            VStack(alignment: .leading, spacing: 2) { Text(label).font(SpotlyFont.caption()).foregroundStyle(SpotlyColors.textSecondary); Text(value).font(SpotlyFont.callout(.semibold)).lineLimit(2) }
            Spacer()
        }.padding(13)
    }

    private func driverCard(_ driver: SpotlyDriverSummary) -> some View {
        HStack(spacing: 14) {
            SpotlyRemoteImage(url: RemoteMedia.url(driver.photoURL), cornerRadius: 27, aspectRatio: 1, fallbackIcon: "person.fill")
                .frame(width: 54, height: 54)
            VStack(alignment: .leading, spacing: 3) {
                Text(driver.displayName ?? "Spotly Driver").font(SpotlyFont.headline())
                let vehicle = driver.vehicle
                Text([vehicle?.color, vehicle?.make, vehicle?.model, vehicle?.registration].compactMap { $0?.nilIfBlank }.joined(separator: " · "))
                    .font(SpotlyFont.caption()).foregroundStyle(SpotlyColors.textSecondary)
                if let rating = driver.rating { Label(String(format: "%.1f", rating), systemImage: "star.fill").font(SpotlyFont.caption(.semibold)).foregroundStyle(SpotlyColors.ratingGold) }
            }
            Spacer()
            if let phone = driver.phone, !phone.isEmpty, let url = URL(string: "tel:\(phone.filter { $0.isNumber || $0 == "+" })") {
                Link(destination: url) { Image(systemName: "phone.fill").frame(width: 42, height: 42).spotlyInteractiveGlass(cornerRadius: 21) }
            }
        }
        .padding(14).background(SpotlyColors.surface, in: RoundedRectangle(cornerRadius: 18)).overlay(RoundedRectangle(cornerRadius: 18).stroke(SpotlyColors.border))
    }

    private var matchingCard: some View {
        HStack(spacing: 12) { ProgressView().tint(SpotlyServiceKind.ride.tint); VStack(alignment: .leading, spacing: 3) { Text("Matching with a Driver").font(SpotlyFont.headline()); Text("Spotly only offers your ride to eligible Drivers nearby.").font(SpotlyFont.caption()).foregroundStyle(SpotlyColors.textSecondary) } }
        .padding(15).background(SpotlyColors.secondaryBackground, in: RoundedRectangle(cornerRadius: 18))
    }

    private func pinCard(_ pin: String) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            Text("Pickup PIN").font(SpotlyFont.caption(.semibold)).foregroundStyle(SpotlyColors.textSecondary)
            Text(pin).font(.system(size: 34, weight: .bold, design: .rounded)).tracking(6)
            Text("Give this PIN only after you have matched the Driver and vehicle shown in Spotly.").font(SpotlyFont.caption()).foregroundStyle(SpotlyColors.textSecondary)
        }
        .padding(16).frame(maxWidth: .infinity, alignment: .leading).background(SpotlyColors.warningBg, in: RoundedRectangle(cornerRadius: 18))
    }

    private var fareCard: some View {
        HStack { VStack(alignment: .leading, spacing: 4) { Text("Estimated fare").font(SpotlyFont.caption()).foregroundStyle(SpotlyColors.textSecondary); Text(money(ride.quote?.total ?? 0, currency: ride.currency ?? ride.quote?.currency ?? "USD")).font(SpotlyFont.title2(.bold)); Text("\(ride.quote?.distanceKm ?? 0, specifier: "%.1f") km · \(ride.paymentMethod == "cash" ? "Cash" : "Paynow")").font(SpotlyFont.caption()).foregroundStyle(SpotlyColors.textSecondary) }; Spacer(); Image(systemName: "car.fill").font(.title2).foregroundStyle(SpotlyServiceKind.ride.tint) }
        .padding(16).background(SpotlyColors.surface, in: RoundedRectangle(cornerRadius: 18)).overlay(RoundedRectangle(cornerRadius: 18).stroke(SpotlyColors.border))
    }

    private var payButton: some View {
        Button { Task { await pay() } } label: { Label(isWorking ? "Starting payment…" : "Pay with Paynow", systemImage: "creditcard.fill").font(SpotlyFont.headline(.bold)).frame(maxWidth: .infinity).frame(height: 50).background(SpotlyColors.accent, in: RoundedRectangle(cornerRadius: 16)).foregroundStyle(.white) }
        .buttonStyle(.plain).disabled(isWorking)
    }

    private var cancelButton: some View {
        Button("Cancel ride", role: .destructive) { showCancel = true }.frame(maxWidth: .infinity).buttonStyle(.bordered)
    }

    private func refresh() async {
        guard !refreshing, !Task.isCancelled else { return }
        refreshing = true; defer { refreshing = false }
        do { ride = try await appState.activity.ride(id: ride.id); errorMessage = nil }
        catch { if !Task.isCancelled { errorMessage = error.localizedDescription } }
    }

    private func pollingLoop() async {
        var failures = 0
        while !Task.isCancelled && scenePhase == .active && !isFinal {
            await refresh()
            guard !Task.isCancelled, !isFinal else { break }
            failures = errorMessage == nil ? 0 : failures + 1
            do { try await Task.sleep(for: PollingPolicy.delay(failures: failures)) } catch { return }
        }
        if !Task.isCancelled && scenePhase == .active { await appState.activity.load(user: appState.currentUser, force: true) }
    }

    private func cancel() async {
        isWorking = true; defer { isWorking = false }
        do { try await appState.activity.cancelRide(id: ride.id, reason: "Cancelled by customer in Spotly iOS"); await refresh(); await appState.activity.load(user: appState.currentUser, force: true) }
        catch { if !Task.isCancelled { errorMessage = error.localizedDescription } }
    }

    private func pay() async {
        guard let orderID = appState.activity.records.first(where: { $0.rideId == ride.id })?.orderId else { errorMessage = "Payment is not available for this ride yet."; return }
        isWorking = true; defer { isWorking = false }
        do { let result = try await SpotlyCommerceService.shared.initiatePaynow(orderId: orderID); if let value = result.redirectUrl, let url = URL(string: value) { openURL(url) } }
        catch { if !Task.isCancelled { errorMessage = error.localizedDescription } }
    }

    private var isFinal: Bool { PollingPolicy.isTerminal(ride.state) }
    private var canCancel: Bool { ["requested", "searching_driver", "driver_assigned", "driver_to_pickup", "driver_arrived_pickup", "pickup_verification"].contains(ride.state) }
    private var stateIcon: String { ride.state == "completed" ? "checkmark.circle.fill" : ride.state == "cancelled" ? "xmark.circle.fill" : ride.driver == nil ? "magnifyingglass" : "car.fill" }
    private var stateCopy: (String, String) {
        switch ride.state {
        case "requested", "searching_driver": return ("Finding your Driver", "Nearby eligible Drivers are being offered your ride.")
        case "driver_assigned": return ("Driver found", "Check the Driver and vehicle details before pickup.")
        case "driver_to_pickup": return ("Driver is on the way", "Your Driver is heading to the pickup point.")
        case "driver_arrived_pickup", "pickup_verification": return ("Your Driver has arrived", "Meet the Driver and use the pickup PIN only after verifying the vehicle.")
        case "in_trip", "driver_arrived_dropoff": return ("You’re on your way", "Spotly is tracking the active trip state from the server.")
        case "completed": return ("Ride complete", "Thanks for riding with Spotly.")
        case "cancelled": return ("Ride cancelled", ride.cancellationReason?.nilIfBlank ?? "This ride is no longer active.")
        default: return (ride.state.replacingOccurrences(of: "_", with: " ").capitalized, "Your ride is updating.")
        }
    }
}

struct SendTrackingView: View {
    let initialParcel: ParcelJob
    @Environment(AppState.self) private var appState
    @Environment(\.scenePhase) private var scenePhase
    @State private var refreshing = false
    @Environment(\.openURL) private var openURL
    @State private var parcel: ParcelJob
    @State private var errorMessage: String?
    @State private var isWorking = false
    @State private var showCancel = false

    init(initialParcel: ParcelJob) { self.initialParcel = initialParcel; _parcel = State(initialValue: initialParcel) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                statusHero
                routeMap
                if let driver = parcel.driver { driverCard(driver) } else if shouldMatch { matchingCard }
                pins
                priceCard
                if parcel.paymentMethod == "paynow" && ["unpaid", "initiated"].contains(parcel.paymentStatus ?? "") { payButton }
                if canCancel { Button("Cancel Send request", role: .destructive) { showCancel = true }.buttonStyle(.bordered).frame(maxWidth: .infinity) }
                if let errorMessage { Label(errorMessage, systemImage: "exclamationmark.triangle.fill").font(SpotlyFont.callout()).foregroundStyle(SpotlyColors.error) }
            }
            .padding(18).padding(.bottom, 30)
        }
        .background(SpotlyColors.background)
        .navigationTitle(parcel.number ?? "Send")
        .navigationBarTitleDisplayMode(.inline)
        .refreshable { await refresh() }
        .task(id: scenePhase) { if scenePhase == .active { await pollingLoop() } }
        .confirmationDialog("Cancel this Send request?", isPresented: $showCancel, titleVisibility: .visible) {
            Button("Cancel request", role: .destructive) { Task { await cancel() } }
            Button("Keep request", role: .cancel) { }
        }
    }

    private var statusHero: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack { Image(systemName: "shippingbox.fill").font(.title2); Spacer(); SpotlyStatusPill(text: parcel.state, color: SpotlyServiceKind.send.tint) }
            Text(stateCopy.0).font(SpotlyFont.title(.bold))
            Text(stateCopy.1).font(SpotlyFont.callout()).foregroundStyle(SpotlyColors.textSecondary)
        }
        .padding(18).background(SpotlyServiceKind.send.tint.opacity(0.08), in: RoundedRectangle(cornerRadius: 22))
    }

    @ViewBuilder private var routeMap: some View {
        if let pickup = parcel.pickup, let dropoff = parcel.dropoff {
            Map {
                Marker("Pickup", coordinate: CLLocationCoordinate2D(latitude: pickup.lat, longitude: pickup.lng)).tint(SpotlyColors.success)
                Marker("Drop-off", coordinate: CLLocationCoordinate2D(latitude: dropoff.lat, longitude: dropoff.lng)).tint(SpotlyServiceKind.send.tint)
                if let lat = parcel.driverLocation?.lat, let lng = parcel.driverLocation?.lng { Marker("Courier", systemImage: "car.fill", coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lng)).tint(SpotlyColors.accent) }
            }
            .frame(height: 245).clipShape(RoundedRectangle(cornerRadius: 22)).allowsHitTesting(false)
            VStack(spacing: 9) {
                Label(parcel.pickup?.displayLabel ?? "Pickup", systemImage: "circle.fill").frame(maxWidth: .infinity, alignment: .leading)
                Label(parcel.dropoff?.displayLabel ?? "Drop-off", systemImage: "mappin.circle.fill").frame(maxWidth: .infinity, alignment: .leading)
            }.font(SpotlyFont.callout()).foregroundStyle(SpotlyColors.textSecondary)
        }
    }

    private func driverCard(_ driver: SpotlyDriverSummary) -> some View {
        HStack(spacing: 14) {
            Image(systemName: "person.fill").foregroundStyle(SpotlyServiceKind.send.tint).frame(width: 50, height: 50).background(SpotlyServiceKind.send.tint.opacity(0.10), in: Circle())
            VStack(alignment: .leading, spacing: 3) {
                Text(driver.displayName ?? "Spotly Driver").font(SpotlyFont.headline())
                let vehicle = driver.vehicle
                Text([vehicle?.color, vehicle?.make, vehicle?.model, vehicle?.registration].compactMap { $0?.nilIfBlank }.joined(separator: " · ")).font(SpotlyFont.caption()).foregroundStyle(SpotlyColors.textSecondary)
            }
            Spacer()
            if let phone = driver.phone, !phone.isEmpty, let url = URL(string: "tel:\(phone.filter { $0.isNumber || $0 == "+" })") { Link(destination: url) { Image(systemName: "phone.fill").frame(width: 42, height: 42).spotlyInteractiveGlass(cornerRadius: 21) } }
        }.padding(14).background(SpotlyColors.surface, in: RoundedRectangle(cornerRadius: 18)).overlay(RoundedRectangle(cornerRadius: 18).stroke(SpotlyColors.border))
    }

    private var matchingCard: some View {
        HStack(spacing: 12) { ProgressView().tint(SpotlyServiceKind.send.tint); VStack(alignment: .leading, spacing: 3) { Text("Matching with a courier").font(SpotlyFont.headline()); Text("Spotly only offers the job to eligible Drivers nearby.").font(SpotlyFont.caption()).foregroundStyle(SpotlyColors.textSecondary) } }.padding(15).background(SpotlyColors.secondaryBackground, in: RoundedRectangle(cornerRadius: 18))
    }

    @ViewBuilder private var pins: some View {
        if let pickupPin = parcel.pickupPin, !pickupPin.isEmpty {
            verificationCard(title: "Pickup PIN", pin: pickupPin, detail: "Give this PIN only when the parcel is physically with the correct Driver.")
        }
        if let dropoffPin = parcel.dropoffPin, !dropoffPin.isEmpty {
            verificationCard(title: "Delivery PIN", pin: dropoffPin, detail: "The recipient gives this PIN only after receiving the parcel.")
        }
    }

    private func verificationCard(title: String, pin: String, detail: String) -> some View {
        VStack(alignment: .leading, spacing: 6) { Text(title).font(SpotlyFont.caption(.semibold)).foregroundStyle(SpotlyColors.textSecondary); Text(pin).font(.system(size: 31, weight: .bold, design: .rounded)).tracking(6); Text(detail).font(SpotlyFont.caption()).foregroundStyle(SpotlyColors.textSecondary) }.padding(16).frame(maxWidth: .infinity, alignment: .leading).background(SpotlyColors.warningBg, in: RoundedRectangle(cornerRadius: 18))
    }

    private var priceCard: some View {
        HStack { VStack(alignment: .leading, spacing: 4) { Text("Delivery price").font(SpotlyFont.caption()).foregroundStyle(SpotlyColors.textSecondary); Text(money(parcel.quote?.total ?? 0, currency: parcel.currency ?? parcel.quote?.currency ?? "USD")).font(SpotlyFont.title2(.bold)); Text("\(parcel.quote?.distanceKm ?? 0, specifier: "%.1f") km · \(parcel.parcelSize?.capitalized ?? "Parcel")").font(SpotlyFont.caption()).foregroundStyle(SpotlyColors.textSecondary) }; Spacer(); Image(systemName: "shippingbox.fill").font(.title2).foregroundStyle(SpotlyServiceKind.send.tint) }.padding(16).background(SpotlyColors.surface, in: RoundedRectangle(cornerRadius: 18)).overlay(RoundedRectangle(cornerRadius: 18).stroke(SpotlyColors.border))
    }

    private var payButton: some View {
        Button { Task { await pay() } } label: { Label(isWorking ? "Starting payment…" : "Complete payment", systemImage: "creditcard.fill").font(SpotlyFont.headline(.bold)).frame(maxWidth: .infinity).frame(height: 50).background(SpotlyColors.accent, in: RoundedRectangle(cornerRadius: 16)).foregroundStyle(.white) }.buttonStyle(.plain).disabled(isWorking)
    }

    private func refresh() async { guard !refreshing, !Task.isCancelled else { return }; refreshing = true; defer { refreshing = false }; do { parcel = try await appState.activity.parcel(id: parcel.id); errorMessage = nil } catch { if !Task.isCancelled { errorMessage = error.localizedDescription } } }
    private func pollingLoop() async {
        var failures = 0
        while !Task.isCancelled && scenePhase == .active && !isFinal {
            await refresh()
            guard !Task.isCancelled, !isFinal else { break }
            failures = errorMessage == nil ? 0 : failures + 1
            do { try await Task.sleep(for: PollingPolicy.delay(failures: failures)) } catch { return }
        }
        if !Task.isCancelled && scenePhase == .active { await appState.activity.load(user: appState.currentUser, force: true) }
    }

    private func cancel() async { isWorking = true; defer { isWorking = false }; do { try await appState.activity.cancelParcel(id: parcel.id, reason: "Cancelled by customer in Spotly iOS"); await refresh(); await appState.activity.load(user: appState.currentUser, force: true) } catch { if !Task.isCancelled { errorMessage = error.localizedDescription } } }
    private func pay() async { guard let orderID = parcel.orderId else { errorMessage = "Payment is not available yet."; return }; isWorking = true; defer { isWorking = false }; do { let result = try await SpotlyCommerceService.shared.initiatePaynow(orderId: orderID, phone: parcel.senderPhone); if let value = result.redirectUrl, let url = URL(string: value) { openURL(url) } } catch { if !Task.isCancelled { errorMessage = error.localizedDescription } } }

    private var isFinal: Bool { PollingPolicy.isTerminal(parcel.state) }
    private var shouldMatch: Bool { !["awaiting_payment", "requested", "scheduled", "delivered", "cancelled", "failed", "returned"].contains(parcel.state) }
    private var canCancel: Bool { ["requested", "scheduled", "awaiting_payment", "searching_driver", "driver_assigned", "driver_to_pickup", "driver_arrived_pickup", "pickup_verification"].contains(parcel.state) && !["paid", "refund_pending", "refunded"].contains(parcel.paymentStatus ?? "") }
    private var stateCopy: (String, String) {
        switch parcel.state {
        case "requested": return ("Request received", "Spotly is preparing your Send request.")
        case "scheduled": return ("Pickup scheduled", "Spotly will start matching a courier shortly before pickup.")
        case "awaiting_payment": return ("Complete payment", "Pay securely before Spotly dispatches a courier.")
        case "searching_driver": return ("Finding a courier", "Nearby eligible Drivers are being offered your delivery.")
        case "driver_assigned", "driver_to_pickup": return ("Courier found", "Your Driver is heading to the pickup.")
        case "driver_arrived_pickup", "pickup_verification": return ("Courier has arrived", "Verify the Driver before handing over the parcel.")
        case "collected", "en_route": return ("Parcel is on the way", "Track progress until the recipient receives it.")
        case "driver_arrived_dropoff", "handoff_verification": return ("Courier has arrived", "The recipient should meet the Driver and verify delivery.")
        case "delivered": return ("Delivered", "Your parcel has been handed over successfully.")
        case "cancelled": return ("Send cancelled", parcel.cancellationReason?.nilIfBlank ?? "This request is no longer active.")
        default: return (parcel.state.replacingOccurrences(of: "_", with: " ").capitalized, "Your delivery is updating.")
        }
    }
}
