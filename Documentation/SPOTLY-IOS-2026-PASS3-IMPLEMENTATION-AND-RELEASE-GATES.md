# Spotly iOS — Pass 3 implementation and release gates

**Date:** October 30, 2026  
**Starting point:** `Spotly_iOS_Native_Transformation_Batch_2_2026-10-30.zip`  
**Target:** Spotly customer iOS, `com.denzeltinashe.spotly`, Firebase project `spotly-africa`  
**Type of deliverable:** Complete updated source project + unified source diff, *not an Xcode-verified binary*

## Executive status

**Implemented:** Request lifecycle integrity for marketplace checkout, Ride and Send; latest-intent quote handling; Activity partial-failure recovery; notification preference write ordering; Saved account-isolation guard; stale search result clearing; small address and Activity recovery UI improvements. **No Cloud Functions, no server code, no Firebase security rule changes, no production data writes, no deployment.**

**Still unverified:** Full Xcode compilation, native Firebase runtime, Firestore permissions/indexes in the live project, Paynow integration, Ride and Send production endpoints, Apple Maps availability, APNs, device-specific layout and performance, animations and App Store readiness.

## Specific defects identified and fixed

### 1. Successfully created order incorrectly looked like a failed checkout

**Before:** The checkout implementation `try await`ed `/api/payments/paynow/initiate` immediately after the web endpoint had already created an order/booking. If Paynow initiation threw, `success` was never set; the form remained visible, suggesting the request itself had failed. This was particularly dangerous for users with slow or intermittent Zimbabwean mobile connectivity.

**After:** Successful create responses first establish an immutable confirmation (order ID, reference, total, currency, whether payment is required). Payment initiation is a separate recoverable phase. The confirmation screen clearly distinguishes **request created** from **payment pending**, offers a retry of *payment initiation only* on errors, and links to authoritative Activity. HTTPS is required for redirect links. An ambiguous create failure tells the user to retry/check the *same* checkout, not to invent a new checkout ID.

**Evidence:** The uploaded web routes `app/api/orders/create/route.js` and `app/api/customer/transactions/create/route.js` both implement a `checkoutId`-based idempotency record (`orderRequests`/`customerTransactionRequests`). The native view retains its per-checkout ID across retries. **This does not verify the routes are deployed or work live.**

### 2. Stale or mismatched Ride/Send quotes

**Before:** Every pickup, drop-off, service type or parcel-size edit could launch a separate quote request. Any response, including an old slow response, could overwrite the displayed fare/payment options. Requests could be submitted against a displayed quote not associated with the current route.

**After:** Shared, strongly typed `RideQuoteIntent`/`SendQuoteIntent` capture exact quote inputs. Only the latest generation for the still-current intent can publish fare/payment methods. A change immediately invalidates the prior quote. Ride/Send submission is blocked while the current quote is loading or stale. Added regression tests for route reversal, destination change, tier and parcel-size change.

### 3. Created Ride/Send could fall back to an unsafe blank request form

**Before:** After successful POST, the app fetched the operational detail. If that follow-up GET failed, the initial request was already created, but the screen returned to the request form with an error, allowing another request. The Send flow also treated Paynow initiation failure as part of the request failure.

**After:** Once the POST returns an identifier, iOS records it first and shows a dedicated tracking-recovery state if the GET fails. A **Retry tracking** action never creates another Ride/Send request. For Send, external payment errors no longer erase a confirmed parcel, and a warning remains visible above tracking. Unknown POST outcomes (timeout, connection interruption, server 5xx, invalid response) require an explicit Activity check before re-enabling submission. This is a practical mitigation, **not a guarantee against duplicates**: unlike checkout, the uploaded Ride/Send request bodies do not carry a stable client idempotency key. That is a follow-up server contract improvement.

### 4. Notification preference initialization silently wrote to Firestore

**Before:** Four `.onChange` handlers called `persist()` even when the screen was loading local and server preferences. Multiple rapid toggle actions could produce out-of-order writes, and errors were swallowed.

**After:** Only user-invoked toggle bindings persist. Toggles remain disabled during initial hydration. Local selection is saved immediately and remote writes are debounced and serially ordered (new writes await prior writes). A visible retry action appears when account sync fails. In-flight account switches are checked before remote writes. Push authorization is still independent from category preferences.

### 5. Notification fetch failure appeared as "all caught up"

**Before:** With no prior records, the notification screen showed the empty state after a failed read, plus an alert. There was no retry button on the empty state and no pull-to-refresh when empty.

**After:** Loading, error, empty and loaded states are separate; empty and failure states have refresh actions. If prior notifications are available but refresh fails, they remain visible with an explanatory banner. A request generation and account-ID check rejects stale results from another session.

### 6. One failed operational Activity source hid another

**Before:** Active Ride and Send refresh was one all-or-nothing `try await` tuple; fallback Activity required the Firestore order query even if Ride/Send endpoints succeeded.

**After:** Each Activity source is independent. The fallback shows successful categories and a partial-data warning, while truly having no usable source produces an error instead of a false empty history. A tracking detail that previously failed now has a retry UI.

### 7. Older results shown as a new search

**Before:** Search preserved results whenever the city and filters matched, even when query text was completely different. The displayed results could therefore be mislabeled as matches for a different query while refreshing or after failure.

**After:** Search results are only preserved for an *identical* full intent (text, city, service and type). A changed intent clears old records before beginning the next debounced request. A new test verifies this behavior.

### 8. Account change could mutate Saved state from an old request

**Before:** `SavedStore.toggleItem` did not guard its async success/rollback against account generation changes, unlike business save/unsave.

**After:** The operation is generation- and owner-aware. A former user's failed operation cannot reinsert/remove a saved item on the next account's screen. Existing Firebase rules remain authoritative.

### 9. Minor but user-visible details

- Branch pickup-availability requests now reject stale results when switching branches quickly.
- Address Picker now interpolates the actual city instead of rendering a literal `\(city)` token.
- Booking/appointment pickers explicitly present Zimbabwe (CAT, UTC+2) time, matching the web route's Harare-time validation.
- Server error classification distinguishes potentially committed writes from clear local/network failures.

## Changed source files

1. `spotly/Core/Models/Production/TransactionModels.swift` — quote intent value types.
2. `spotly/Core/Network/APIClient.swift` — ambiguous-write error classification.
3. `spotly/Core/Stores/ActivityStore.swift` — independent partial-failure recovery.
4. `spotly/Core/Stores/MarketplaceStore.swift` — full search-intent preservation rules.
5. `spotly/Core/Stores/SavedStore.swift` — account generation guards.
6. `spotly/Features/Production/ActivityView.swift` — retryable tracking detail state.
7. `spotly/Features/Production/MarketplaceCheckoutView.swift` — separate creation/payment phases, branch request generation, Harare time and address text.
8. `spotly/Features/Production/ProfileSupportNotifications.swift` — notification preference loading, ordered writes, errors and retrieval states.
9. `spotly/Features/Production/RideRequestView.swift` — stable quote intent, duplicate-request mitigation and tracking recovery.
10. `spotly/Features/Production/SendRequestView.swift` — same protections with independent payment warnings.
11. `spotlyTests/ProductionRegressionTests.swift` — added pure model/state/contract regression coverage.

## Firebase, web and backend architecture

- Native Firebase Auth and Firestore changes from Passes 1 and 2 remain intact.
- **No Cloud Functions were created.** No Firebase rules were weakened.
- User-owned profiles, saved items and notifications continue to use native SDK calls.
- The current Next.js endpoints remain responsible for order/booking creation, Paynow, Ride/Send request creation, tracking, cancellation and support. This is the working architectural assumption pending real endpoint verification.
- The richer curated marketplace and search still use web as the primary source with bounded native Firestore fallbacks.
- The web source proves checkout idempotency by `checkoutId`; it does not prove identical guarantees for Ride/Send POST. Launch should validate both APIs under network interruption and consider a stable request ID implemented on the existing backend (not Cloud Functions).
- **Do not relax the production Firestore order/payment rules to eliminate website endpoints.** That would expose other customers' orders or permit price/status manipulation without making Paynow operational.

## Static verification completed

- `swiftc -frontend -parse` over app, Swift test and UI test source: **PASS**; parser-only, no Apple SDK type-check.
- `plutil -lint` Xcode project, Firebase plist, privacy manifest: **PASS**.
- All 25 `.xcassets` JSON manifests: **PASS**.
- Bundled Firebase plist identifies `spotly-africa` / `com.denzeltinashe.spotly` / iOS app `1:14197555543:ios:236ea2214ec0f9d1c3be12`.
- Confirmed both existing web create routes contain checkout-based idempotency logic in the *supplied source*.
- Source comparison against exact Pass 2 ZIP shows 11 modified Swift files plus this handoff document; no other source files replaced.

**Not executed:** `xcodebuild`, dependency resolution on Apple platforms, simulator tests, Firebase authenticated SDK calls, push delivery, external payment initiation, ride/parcel requests, database writes or live endpoint requests. No source syntax check should be confused with a successful Xcode build.

## Required Xcode release gates (before launch)

Run from this delivered `spotly/` project directory on a Mac with Xcode:

```bash
xcodebuild -resolvePackageDependencies -project spotly.xcodeproj -scheme spotly
xcodebuild -project spotly.xcodeproj -scheme spotly -configuration Debug -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO build
xcodebuild -project spotly.xcodeproj -scheme spotly -configuration Debug -destination 'platform=iOS Simulator,name=iPhone 17' test
```

If your installed simulator differs, replace the destination with an available iPhone device from `xcrun simctl list devices available`.

**Test scenarios:**

1. Sign in with a `spotly-africa` account, verify profile, save/unsave, switch users and test guest mode. Confirm no cross-account Saved/Notification information.
2. Search `pizza` then immediately `pharmacy` on a throttled network. Change city/filter while loading; old results must not be shown under new criteria.
3. Open Bite/Shopper, switch merchant pickup branch A to B before A responds. Only B's slots must be selectable; test invalid/empty availability and delivery fallback.
4. Use a controlled test-order environment: create an order with non-Paynow payment and validate Activity. For Paynow, simulate payment initiation failure **after** create and ensure a reference and "payment pending" remain. Retry payment without creating a second order; verify web idempotency records.
5. Test a Book appointment and Live ticket with the device time zone both inside and outside Zimbabwe. Verify the backend receives the intended Harare-local date/time.
6. In Ride and Send, rapidly change route and tier/size while quotes are delayed. Confirm the final route owns the fare. Simulate tracking GET failure **after successful POST** and verify no new request is created by retrying tracking.
7. Simulate connection loss during POST without an acknowledgement; confirm the user can consult Activity before allowing another request. Verify whether the deployed backend has duplicate protection beyond the client mitigation.
8. Disable the Activity endpoint while leaving Firestore orders and one other operational endpoint reachable. Confirm existing categories display with a partial warning rather than an empty state.
9. Load notification preferences where server differs from local defaults. Confirm initial load generates **zero writes**. Toggle rapidly, verify last selection wins on re-read, check offline/error retry, and sign out during a delayed write.
10. Test no connectivity, weak mobile reception, 429/403/500 responses, background/foreground, dark mode, increased Dynamic Type, VoiceOver, Reduce Motion and notification permission denial.

Check exact Firebase rules and indexes **in the deployed Firebase project**, not merely repository files. Review App Check / APNs setup, logs with personal data redacted, foreground push/deep link behavior, and actual order/dispatch/Paynow reconciliation before TestFlight.

## Unresolved high-priority risks

1. No actual Xcode build; SwiftUI/Firebase type or actor-isolation errors may remain.
2. Checkout/payment/dispatch still require the existing deployed Next.js APIs; if offline or unconfigured, those operations cannot work end to end. Native fallback browsing is deliberately not a replacement for paid services.
3. Ride and Send request POSTs lack confirmed client-supplied idempotency keys. A non-acknowledged write remains ambiguous, even with the new UX guard.
4. No verified live Firebase rules/index deployment, no device notification testing, no real Zimbabwe Apple Maps quality assessment.
5. Some legacy marketplace-only listings remain accessible through public website compatibility; full native curated Firestore materialization has not been built.
6. This pass does not overhaul every screen or complete animation/accessibility audits. That work must be measured on device rather than pronounced finished from static source.

**Release status:** Improved customer source code, **not yet release-certified**. The next bottleneck is a real Xcode type check/build plus verified test operations against production-equivalent infrastructure.
