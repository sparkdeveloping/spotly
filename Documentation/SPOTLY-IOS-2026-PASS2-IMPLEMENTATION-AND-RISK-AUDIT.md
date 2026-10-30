# Spotly customer iOS — second implementation pass
**Date:** 30 October 2026  
**Source:** Second-pass changes applied to the first-pass iOS project, using the supplied official Apple Firebase plist and the uploaded 30 October web source.  
**Verification level:** Swift syntax and project/asset validation only. **Not built or device-tested.**

## Mandate and explicit architecture decision

The owner wants a functional launch-first application and has **not authorized new Firebase Cloud Functions** for the initial rollout. This batch creates **zero Cloud Functions** and makes **zero production Firestore rule changes**. Firebase Authentication, user-owned state and live public merchant data use the native Firebase SDK. The existing website's operational APIs remain the **temporary trusted server** for transactions, payment, dispatch, support, and other actions that Firestore rules intentionally forbid client code from performing. This is a deliberate compromise, not a claim that the website is no longer involved.

It would be inaccurate to state that a no-server, direct-client-only replacement can provide all features under the checked-in rules. Specifically, `firestore.rules` denies client create/update for `orders`, direct access to `rideTrips`/`parcelJobs`/`deliveryJobs`, and creation of support conversations. Paynow initiation and reconciliation require credentials and webhooks that must never be embedded in iOS. Disabling those protections for launch would not be a functional-equivalence fix. The current Next.js endpoints can continue handling these operations **if they are actually deployed, correctly authenticated, and operational**. Those properties remain unverified.

## What was actually implemented

1. **Real customer Firebase iOS registration included.** Installed the owner's actual `GoogleService-Info.plist` for `com.denzeltinashe.spotly`, project `spotly-africa`, sender `14197555543`, app ID `1:14197555543:ios:236ea2214ec0f9d1c3be12`. Replaced the provisional value in `Shared.xcconfig`; updated Firebase client API key to the issued Apple configuration and made startup read the bundled plist, checking app ID, project, sender and bundle before configuring. Firebase App ID is no longer an *information* blocker, but successful bundle-copy, device sign-in and entitlement configuration remain unverified.
2. **Native merchant detail repository.** Added `NativeMarketplaceRepository.swift` for direct public Firestore business documents, published public branches and published active products. Mapping explicitly whitelists known fields, normalizes numeric/string variations and preserves the web's crucial distinction between generic business verification and commerce authorization. Native detail retrieval does not load up to 1,000 products; it is bounded to 100 products and 60 branches per merchant. Missing Firestore IDs can still resolve via the curated public website directory, but explicitly private/unpublished records are not sent through that fallback.
3. **Saved businesses hydrate from native Firestore first.** Bounded concurrency (eight documents in flight) and local caching; web only resolves IDs missing from the public Firestore merchant set, which may be editorial directory entries. Corrected Saved's optimistic rollback if a product/service/event toggle is attempted without a valid account session.
4. **Native product resolution in Saved and deep links.** A saved offering or deep-linked product now first tries its real Firestore document, checks `published`, `active` and availability, resolves the associated public business, and maps to native detail. The web search compatibility path still exists for non-Firestore/curated results.
5. **Graceful Home, service feed and search fallback.** Rich public discovery retains the web endpoint because the web combines Firestore, licensed/open directory data, brand rankings, regional policies, promotions and editorial metadata. When this endpoint fails, native Firestore provides a bounded business-only fallback: a shared query of at most **80 public merchant docs**, cached for **180 seconds**, rather than one costly scan per service card. This fallback intentionally does **not** claim product completeness, full ranking parity, or curated-directory coverage. It uses existing `public + name` Firestore index *as represented in the uploaded web repository*; deployment of the index is unverified.
6. **Native address search.** Ride/Send address selection now tries Apple Maps (`MKLocalSearch`) for Zimbabwe before the existing licensed geocoding route. Coordinates returned by native search are filtered to Zimbabwe. Apple Maps availability, local POI coverage and accuracy require real-device verification.
7. **Activity resilience.** A missing/failing normalized customer Activity endpoint now triggers a Firestore order-history recovery path for an authenticated user. Ride and Send history retrieval is independent and best-effort, so a temporary failure in either does not erase otherwise available orders. Accurate full operational tracking still relies on the current web API.
8. **Authentication edge case.** A verification email send failure *after successful Firebase account creation* can no longer cause the creation flow to falsely report that the account was not created. Profile now has actions to resend the email and refresh verification status. Any failure is shown during those explicit actions.
9. **Account separation and UI.** Discovery tasks, feed data and search state reset on sign-out to avoid stale cross-account results. The Bite / Shopper / Book / Live service discovery hero now includes corresponding approved 3D artwork and distinct service identity with accessible content.
10. **Swift 6 concurrency review.** Added explicit `Sendable` conformance to the pure value models and paginated search/service intents passed across asynchronous tasks; native compile-time concurrency correctness still requires an Xcode build.
11. **Regression tests expanded** for official app ID, publication gates, unexpected legacy document types, service classifications, and commerce-verification boundaries.

## Truthful data ownership as of this batch

| Capability | Source now | Notes / remaining limitations |
|---|---|---|
| Account creation/sign-in/reset/verification | **Native FirebaseAuth** | Plist now supplied; sign-in untested; old-project accounts not migrated automatically |
| User profile, preferences, notifications, saved records | **Native Firestore** (pass 1) | No real permission/index/device tests yet |
| Merchant detail from `businesses` | **Native Firestore primary** | Website only for editorial IDs that have no native document |
| Public branches and published active products | **Native Firestore for supported merchant detail** | Limited per merchant; not the complete web product directory |
| Saved merchant hydration | **Native Firestore primary**, public website for curated IDs | User records remain native |
| Product deep links / saved products | **Native Firestore primary** with public web compatibility | Incomplete editorial products still need web data |
| Home/Bite/Shopper/Book/Live feeds | **Existing curated website feed primary**, bounded native Firestore fallback | Full native curated/indexed read model NOT implemented |
| Global search | **Existing public website search primary**, bounded native fallback | Direct Firebase fallback returns businesses only; no global ranking parity |
| Ride/Send address search | **Apple Maps primary**, existing web geocode fallback | Map/search in Zimbabwe untested |
| Customer Activity | **Existing authenticated web API primary**, native Firestore orders on failure | Ride/parcel source is still server-owned |
| Order/appointment/ticket creation, cancellations, payment initiation/status | **Existing Next.js API** | No Cloud Functions added; must verify live endpoints before release |
| Ride/Send quotes, requests, cancellation, tracking | **Existing Next.js API** | No client-only replacement under current rules |
| Support creation, reviews, account deletion request | **Existing Next.js API** | Their writes are server-governed; live delivery unverified |
| FCM and push delivery | Native Messaging + Firestore token document | APNs capability/configuration and token cleanup remain device-test items |

## Remaining API routes (20 distinct paths; route *presence* verified in uploaded web source, live operation NOT verified)

- Rich data and compatibility: `/api/public/service-feed`, `/api/public/search`, `/api/public/marketplace/business`, `/api/public/marketplace/businesses`, `/api/public/geocode`, `/api/public/marketplace/pickup-availability`.
- Orders, reservations and payments: `/api/orders/create`, `/api/customer/transactions/create`, `/api/customer/orders/status`, `/api/orders/cancel`, `/api/payments/paynow/initiate`, `/api/payments/paynow/status`, `/api/customer/reviews`.
- Customer operations: `/api/customer/activity`, `/api/customer/rides`, `/api/customer/rides/quote`, `/api/customer/parcels`, `/api/customer/parcels/quote`, `/api/support/conversations`, `/api/customer/account/deletion`.

They are **not** all equivalent. Ordinary user-scope reads can migrate to the SDK. Protected operations require a trusted executor; in the owner's no-Cloud-Functions launch architecture, that executor is the **existing** deployed Next.js backend, not a new one. When the web host is down, operations requiring it are not available; UI must display a recoverable failure, not fabricate an order or payment. An offline local cash/quote estimate must never be presented as a booked or assigned job.

## Checked-in Firestore rules evidence

Verified against uploaded `spotlyweb/firestore.rules`: `businesses` readable when `public == true`; `branches` public if its parent business is public and in allowed status; `products` public only if published, active and parent business is public. `users`, `favorites`, `savedItems`, `notifications` and `notificationPreferences` have user-scope rules. `orders` are customer-readable but client create/update is denied. `rideTrips`, `parcelJobs`, `deliveryJobs` are denied to clients. Support conversation creation is denied. Product and branch composite indexes are present in uploaded `firestore.indexes.json`, **not independently confirmed deployed**. No rule relaxation was made.

## Testing and verification

Completed on extracted project:
- `swiftc -frontend -parse` over all app, unit and UI test Swift sources: PASS **syntax only**.
- `plutil -lint` on Xcode `.pbxproj`, privacy manifest and official Firebase plist: PASS.
- All 25 asset `Contents.json` files decode as JSON: PASS.
- Cross-checked Firebase plist identifiers against `.xcconfig` and App bundle ID in project source: PASS.
- Confirmed 20 distinct remaining API paths against corresponding uploaded web routes: 20/20 present as files, no live check.
- No Xcode, Apple SDK module type checking, simulator, on-device test, authenticated Firebase traffic, App Check, APNs, order, payment or live ride/parcel test. **Release readiness is NOT established.**

### First required Xcode checks (Mac)

```bash
xcodebuild -resolvePackageDependencies -project spotly.xcodeproj -scheme spotly
xcodebuild -project spotly.xcodeproj -scheme spotly -configuration Debug -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO build
xcodebuild -project spotly.xcodeproj -scheme spotly -configuration Debug -destination 'platform=iOS Simulator,name=iPhone 17' test
```

Check the **Spotly app target's Copy Bundle Resources** actually includes `GoogleService-Info.plist`; the Xcode project uses synchronized file groups, but resource copying cannot be certified from Linux. Build the **customer** target `com.denzeltinashe.spotly` using the confirmed Apple registration. Test with a **test account**: sign in with a web-account from `spotly-africa`, create account, sign out/sign back in, change city, visit all six services, save/unsave, search, load detail/product, verify email, load Activity, attempt a nonfinancial quote, and deny location permissions. Verify for empty city, offline, delayed network, dark mode, reduced motion, small-screen and large-text modes. Only use deliberately provisioned test payments/transactions under operator supervision.

## Risks explicitly left open

1. **Native SDK / Swift 6 compile risk** until Xcode builds; Linux Swift syntax parsing does not type check Apple Firebase/MapKit symbols.
2. **Actual Firebase rules/indexes may not match repository** until checked in live project.
3. **Web-curated marketplace still cannot be recreated from raw Firestore alone**; a precomputed indexed public Firestore projection is the appropriate later solution without functions, if its *publisher* runs from the existing trusted web/admin deployment.
4. **No zero-dependency order/ride/payment workflow** can be guaranteed while their required website server endpoints and driver integrations are outside this runtime's test access. Do not weaken order/payment authorization rules to mask the dependency.
5. **Sign-out FCM cleanup** still only revokes the local FCM token after local state clears. The previous Firestore `pushTokens` document may remain `active` until a future server cleanup; no production rule or token lifecycle migration was made.
6. **Fallback catalogue incomplete by design**: 80-document snapshot limits and simplified service taxonomy; the curated web catalogue remains canonical for discovery/ranking.
7. **No production dataset touched**, no GitHub branch or pull request created, no paid billing flow executed, no Cloud Functions deployed or authored.
8. **Performance, App Check, accessibility, UI placement and native animations remain unverified on real hardware**.

## Next recommended *implementation* pass, under the owner's no-Cloud-Functions condition

1. Open this exact project in Xcode, resolve SDK/type-check errors and validate runtime auth against the supplied plist; execute controlled smoke journeys. Without builds, further source changes increase integration uncertainty.
2. Inspect real deployed web endpoints and run test quotes/orders (without charging a real customer). Migrate any failed route to an existing working trusted server implementation, preserving Firebase identity, idempotency, and database transaction semantics.
3. Add a server-published bounded discovery index in Firestore using existing administrative/deployment facilities (not Cloud Functions), so iOS can query complete curated service/category/city pages directly and cheaply. Keep a real revision/version for stale index validation.
4. Port Activity, order status and trusted live booking read models where current Firestore rules permit. Keep financial operations and dispatch under a trusted server; add reliable network retry/reconciliation states.
5. Test Ride and Send mapping, push notification deep links, cancellations and location search in Harare/Bulawayo on devices, including blank data and slow mobile connections.
6. Complete accessibility, animation, keyboard, search focus, Dark Mode, empty states and 3D illustration refinements across *every* screen, measuring actual SwiftUI runtime behavior before asserting premium finish.

**Status: meaningful second source implementation delivered; NOT a production-verified release.**
