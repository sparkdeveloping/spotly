import Foundation
import Testing
@testable import spotly

@Suite @MainActor
struct ProductionRegressionTests {
    @Test func missingMediaHasNoRequestURL() {
        for value: String? in [nil, "", "  ", "file:///private/image", "not a URL"] {
            #expect(RemoteMedia.url(value) == nil)
        }
        #expect(RemoteMedia.url("https://example.com/image.jpg") != nil)
    }

    @Test func addressDropsEmptyAndRepeatedComponents() {
        #expect(AddressFormatter.joined(["20 Julius Nyerere Way", "", " Harare ", "harare"]) == "20 Julius Nyerere Way · Harare")
        #expect(AddressFormatter.joined(["Harare / Harare", nil]) == "Harare")
    }

    @Test func transportErrorsAreTruthful() {
        #expect(SpotlyAPIError.classify(URLError(.notConnectedToInternet)) == .offline)
        #expect(SpotlyAPIError.classify(URLError(.timedOut)) == .timeout)
        #expect(SpotlyAPIError.classify(URLError(.dnsLookupFailed)) == .hostLookup)
        #expect(SpotlyAPIError.classify(URLError(.cannotConnectToHost)) == .connection)
        #expect(SpotlyAPIError.classify(URLError(.secureConnectionFailed)) == .security)
        #expect(SpotlyAPIError.classify(URLError(.cancelled)) == .cancelled)
    }

    @Test func latestIntentWinsEvenWhenTransportIgnoresCancellation() async {
        let request = PagedRequest<String, [String]>(fetch: { intent, _ in
            if intent == "old" { try? await Task.sleep(for: .milliseconds(80)) }
            return [intent]
        }, next: { _ in nil }, merge: +)
        request.load("old")
        await Task.yield()
        request.load("new")
        await request.wait()
        #expect(request.value == ["new"])
        #expect(request.error == nil)
        #expect(!request.isLoading)
        request.cancel(clear: true)
        #expect(request.value == nil)
    }

    @Test func paginationAppendsAndStops() async {
        let request = PagedRequest<String, [Int]>(fetch: { _, offset in [offset] },
            next: { $0.last == 0 ? 1 : nil }, merge: +)
        request.load("query")
        await request.wait()
        request.loadMore()
        await request.wait()
        #expect(request.value == [0, 1])
        #expect(request.nextOffset == nil)
    }

    @Test func terminalStatesStopPolling() {
        for state in ["completed", "delivered", "cancelled", "failed", "refunded", "expired"] {
            #expect(PollingPolicy.isTerminal(state))
        }
        #expect(!PollingPolicy.isTerminal("assigned"))
        #expect(PollingPolicy.delay(failures: 100) == .seconds(60))
    }
}

extension ProductionRegressionTests {
    @Test func commerceReadyRequiresCommerceVerificationNotGenericProfileStatus() throws {
        let json = #"{"id":"biz","name":"Directory place","verificationStatus":"verified","commerceVerified":false}"#
        let business = try JSONDecoder().decode(RemoteBusiness.self, from: Data(json.utf8))
        #expect(!business.isCommerceVerified)
        #expect(business.isProfileVerified)
    }

    @Test func legacyHomeAndWorkAddressesDoNotEnterMarketplaceSaved() {
        let home = FirestoreDocument(id: "home", fields: [
            "type": .string("place"), "entityId": .string("address-home"), "title": .string("Home")
        ])
        let work = FirestoreDocument(id: "work", fields: [
            "type": .string("place"), "entityId": .string("address-work"), "title": .string("Work")
        ])
        #expect(SavedStore.savedEntity(home) == nil)
        #expect(SavedStore.savedEntity(work) == nil)
    }

    @Test func customerNotificationsExcludeBusinessAndDriverWorkspaces() {
        let customer = FirestoreDocument(id: "c", fields: [
            "title": .string("Order ready"), "workspace": .string("customer"), "category": .string("order")
        ])
        let business = FirestoreDocument(id: "b", fields: [
            "title": .string("Settlement account verified"), "workspace": .string("business"), "category": .string("business_money_review")
        ])
        let driver = FirestoreDocument(id: "d", fields: [
            "title": .string("Active Driver vehicle needs review"), "workspace": .string("driver"), "category": .string("driver_review")
        ])
        #expect(SpotlyNotificationRecord(customer)?.isCustomerVisible == true)
        #expect(SpotlyNotificationRecord(business)?.isCustomerVisible == false)
        #expect(SpotlyNotificationRecord(driver)?.isCustomerVisible == false)
    }
}


extension ProductionRegressionTests {
    @Test func nativeServicePresentationMatchesWebIdentityWithoutChangingBackendIDs() {
        #expect(SpotlyServiceKind.eat.rawValue == "eat")
        #expect(SpotlyServiceKind.eat.title == "Bite")
        #expect(SpotlyServiceKind.shop.rawValue == "shop")
        #expect(SpotlyServiceKind.shop.title == "Shopper")
        #expect(SpotlyServiceKind.events.rawValue == "events")
        #expect(SpotlyServiceKind.events.title == "Live")
        for service in SpotlyServiceKind.allCases {
            #expect(!service.subtitle.isEmpty)
            #expect(service.artworkName.hasPrefix("Service_"))
        }
    }

    @Test func iosNeverTargetsRetiredFirebaseProject() {
        #expect(SpotlyConfiguration.firebaseProjectID == "spotly-africa")
        #expect(SpotlyConfiguration.firebaseMessagingSenderID == "14197555543")
        // The production iOS App ID must still be issued by Firebase Console.
        #expect(!SpotlyConfiguration.canConfigureFirebaseNativeSDK ||
                SpotlyConfiguration.firebaseIOSAppID.hasPrefix("1:14197555543:ios:"))
    }
}

extension ProductionRegressionTests {
    @Test func actualIosFirebaseRegistrationIsUsed() {
        #expect(SpotlyConfiguration.firebaseIOSAppID == "1:14197555543:ios:236ea2214ec0f9d1c3be12")
        #expect(SpotlyConfiguration.canConfigureFirebaseNativeSDK)
    }

    @Test func privateOrUnlaunchedMarketplaceRecordsAreNotDiscoverable() {
        #expect(!NativeMarketMapper.isPubliclyDiscoverable([
            "public": false, "name": "Private store", "verificationStatus": "verified"
        ]))
        #expect(!NativeMarketMapper.isPubliclyDiscoverable([
            "public": true, "name": "Research preview", "source": ["type": "spotly_assist_research"]
        ]))
        #expect(NativeMarketMapper.isPubliclyDiscoverable([
            "public": true, "name": "Licensed listing", "source": ["rightsStatus": "open_odbl"]
        ]))
    }

    @Test func noGenericVerifiedBadgeCanCreateCommerceAuthorization() throws {
        let raw: [String: Any] = [
            "public": true, "name": "Business", "verificationStatus": "verified",
            "businessType": "restaurant_food", "commerceEnabled": false,
            "status": "provisional"
        ]
        let business = try NativeMarketMapper.business(id: "example", raw: raw)
        #expect(business.isProfileVerified)
        #expect(!business.isCommerceVerified)
        #expect(NativeMarketMapper.service(for: business) == .eat)
    }

    @Test func oldFirestoreFieldsWithUnexpectedTypesAreSanitized() throws {
        let raw: [String: Any] = [
            "public": true, "name": "Legacy merchant", "category": 123,
            "coverImage": ["bad": "type"], "reviewCount": "42",
            "capabilities": ["pickup", "booking"], "latitude": "-17.83",
            "longitude": "31.03"
        ]
        let result = try NativeMarketMapper.business(id: "legacy", raw: raw)
        #expect(result.id == "legacy")
        #expect(result.displayName == "Legacy merchant")
        #expect(result.reviewCount == 42)
        #expect(result.category == nil)
        #expect(result.latitude == -17.83)
    }

    @Test func publishedItemDoesNotInheritCommerceFromUnverifiedDirectory() throws {
        let business = try NativeMarketMapper.business(id: "biz", raw: [
            "name": "Directory", "public": true, "commerceVerified": false
        ])
        let item = try NativeMarketMapper.product(id: "item-1", raw: [
            "name": "Service", "itemType": "appointment", "price": 25,
            "active": true, "published": true
        ], business: business)
        #expect(item.type == "service")
        #expect(item.price == 25)
        #expect(!business.isCommerceVerified)
    }
}

extension ProductionRegressionTests {
    @Test func rideQuotesAreBoundToExactRouteAndService() {
        let origin = RidePoint(lat: -17.825, lng: 31.035, label: "Harare")
        let destination = RidePoint(lat: -17.814, lng: 31.081, label: "Eastlea")
        let changedDestination = RidePoint(lat: -17.781, lng: 31.056, label: "Borrowdale")
        let current = RideQuoteIntent(pickup: origin, dropoff: destination, serviceType: "economy")
        #expect(current == RideQuoteIntent(pickup: origin, dropoff: destination, serviceType: "economy"))
        #expect(current != RideQuoteIntent(pickup: origin, dropoff: changedDestination, serviceType: "economy"))
        #expect(current != RideQuoteIntent(pickup: origin, dropoff: destination, serviceType: "comfort"))
        #expect(current != RideQuoteIntent(pickup: destination, dropoff: origin, serviceType: "economy"))
    }

    @Test func sendQuotesAreBoundToExactRouteAndParcelSize() {
        let origin = RidePoint(lat: -17.825, lng: 31.035)
        let destination = RidePoint(lat: -17.814, lng: 31.081)
        let medium = SendQuoteIntent(pickup: origin, dropoff: destination, size: "medium")
        #expect(medium != SendQuoteIntent(pickup: origin, dropoff: destination, size: "large"))
        #expect(medium != SendQuoteIntent(pickup: destination, dropoff: origin, size: "medium"))
    }

    @Test func notificationCategoriesReflectExactSelectedSwitches() {
        let none = NotificationSelection(orders: false, bookings: false, operations: false, offers: false)
        #expect(none.categories.isEmpty)
        let essential = NotificationSelection(orders: true, bookings: true, operations: true, offers: false)
        #expect(essential.categories == Set(["orders", "bookings", "operations"]))
        let marketingOnly = NotificationSelection(orders: false, bookings: false, operations: false, offers: true)
        #expect(marketingOnly.categories == Set(["offers"]))
    }

    @Test func changingSearchIntentClearsOldResultsWhileLoading() async {
        let request = PagedRequest<String, [String]>(fetch: { text, _ in
            try await Task.sleep(for: .milliseconds(20))
            return [text]
        }, next: { _ in nil }, merge: +)
        request.load("pizza")
        await request.wait()
        #expect(request.value == ["pizza"])
        request.load("pharmacy", preserve: false, debounce: .milliseconds(50))
        #expect(request.value == nil)
        await request.wait()
        #expect(request.value == ["pharmacy"])
    }

    @Test func createdOrderDoesNotImplyPaymentSucceeded() throws {
        let json = #"{"ok":true,"orderId":"order-001","number":"SP-20261030-ABCDE","total":13.50,"currency":"USD","paymentRequired":true,"fulfilment":"pickup"}"#
        let created = try JSONDecoder().decode(CommerceOrderCreateResponse.self, from: Data(json.utf8))
        #expect(created.orderId == "order-001")
        #expect(created.paymentRequired)
        let paynow = #"{"ok":true,"orderId":"order-001","redirectUrl":"https://checkout.example.invalid/start"}"#
        let initiated = try JSONDecoder().decode(PaynowInitiateResponse.self, from: Data(paynow.utf8))
        #expect(initiated.orderId == created.orderId)
        #expect(initiated.redirectUrl != nil)
        // Initiation alone does not provide payment confirmation; Activity tracks it.
    }
}

extension ProductionRegressionTests {
    @Test func uncertainWriteFailuresRequireActivityCheck() {
        #expect(SpotlyAPIError.timeout.mayHaveCommittedWrite)
        #expect(SpotlyAPIError.connection.mayHaveCommittedWrite)
        #expect(SpotlyAPIError.decoding("invalid response").mayHaveCommittedWrite)
        #expect(SpotlyAPIError.server(status: 503, message: "down").mayHaveCommittedWrite)
        #expect(!SpotlyAPIError.server(status: 422, message: "validation").mayHaveCommittedWrite)
        #expect(!SpotlyAPIError.offline.mayHaveCommittedWrite)
        #expect(!SpotlyAPIError.hostLookup.mayHaveCommittedWrite)
    }
}

extension ProductionRegressionTests {
    @Test func pickupEarliestAndDayAreAlwaysFromTheSameDate() {
        let a = PickupAvailabilitySlot(id: "slot-a", start: "09:00", end: "10:00", label: "9 AM", remaining: 3)
        let b = PickupAvailabilitySlot(id: "slot-b", start: "14:00", end: "15:00", label: "2 PM", remaining: 2)
        let response = PickupAvailabilityResponse(ok: true, branchId: "b", available: true, reason: nil,
            days: [
                PickupAvailabilityDay(date: "2026-11-01", label: "Sunday", slots: [a]),
                PickupAvailabilityDay(date: "2026-11-02", label: "Monday", slots: [b])
            ], earliest: PickupEarliest(date: "2026-11-02", slot: b))
        let selection = response.defaultSelection()
        #expect(selection?.day.date == "2026-11-02")
        #expect(selection?.slot.id == "slot-b")
        #expect(selection?.day.slots.contains(where: { $0.id == selection?.slot.id }) == true)
    }

    @Test func pickupSkipsExpiredOrDepletedSlots() {
        let empty = PickupAvailabilitySlot(id: "expired", start: "09:00", end: "10:00", label: "9 AM", remaining: 0)
        let available = PickupAvailabilitySlot(id: "valid", start: "10:00", end: "11:00", label: "10 AM", remaining: 1)
        let response = PickupAvailabilityResponse(ok: true, branchId: "b", available: true, reason: nil,
            days: [PickupAvailabilityDay(date: "2026-11-01", label: "Sunday", slots: [empty, available])],
            earliest: PickupEarliest(date: "2026-11-01", slot: empty))
        #expect(response.defaultSelection()?.slot.id == "valid")
        let exhausted = PickupAvailabilityResponse(ok: true, branchId: "b", available: true, reason: nil,
            days: [PickupAvailabilityDay(date: "2026-11-01", label: "Sunday", slots: [empty])],
            earliest: nil)
        #expect(exhausted.defaultSelection() == nil)
    }

    @Test func missingPriceAndSoldOutOfferingsDoNotInviteCheckout() throws {
        let decoder = JSONDecoder()
        let missingPrice = try decoder.decode(RemoteItem.self, from: Data(#"{"id":"missing-price","available":true}"#.utf8))
        #expect(missingPrice.checkoutUnavailableReason(for: .shop) == "Price unavailable")
        let event = try decoder.decode(RemoteItem.self, from: Data(#"{"id":"sold-out","price":0,"remainingCapacity":0}"#.utf8))
        #expect(event.checkoutUnavailableReason(for: .events) == "Fully booked")
        let freeEvent = try decoder.decode(RemoteItem.self, from: Data(#"{"id":"free","price":0,"remainingCapacity":5}"#.utf8))
        #expect(freeEvent.checkoutUnavailableReason(for: .events) == nil)
        let unpublished = try decoder.decode(RemoteItem.self, from: Data(#"{"id":"draft","price":5,"published":false}"#.utf8))
        #expect(unpublished.checkoutUnavailableReason(for: .eat) != nil)
    }
}


extension ProductionRegressionTests {
    @Test func customerFirebaseIdentityIsCompleteWithoutGeneratedInfoPlistKeys() {
        #expect(SpotlyConfiguration.canConfigureFirebaseNativeSDK)
        #expect(SpotlyConfiguration.expectedBundleID == "com.denzeltinashe.spotly")
        #expect(SpotlyConfiguration.firebaseProjectID == "spotly-africa")
        #expect(SpotlyConfiguration.firebaseIOSAppID.hasPrefix("1:\(SpotlyConfiguration.firebaseMessagingSenderID):ios:"))
        #expect(!SpotlyConfiguration.firebaseAPIKey.isEmpty)
    }
}
