> **Second pass update (30 October 2026):** The official `spotly-africa` customer iOS `GoogleService-Info.plist` is included and checked against `Shared.xcconfig`. No Cloud Functions have been added; protected transactions still use the existing Next.js backend. Consult `Documentation/SPOTLY-IOS-2026-PASS2-IMPLEMENTATION-AND-RISK-AUDIT.md` for current verified state. An Xcode build and device tests are still required.

# Spotly Customer iOS — native modernization in progress

**Read [`Documentation/SPOTLY-IOS-2026-OCT30-AUDIT-AND-HANDOFF.md`](Documentation/SPOTLY-IOS-2026-OCT30-AUDIT-AND-HANDOFF.md) first.**

The 30 October source patch migrates Auth and user Firestore operations to native Firebase SDKs, aligns project identity with the current web project, and imports the current premium service artwork. This is **NOT a verified release build**. Firebase's registered iOS App ID for `com.denzeltinashe.spotly` is still required, and **20 website `/api` endpoint literals remain** for public discovery and privileged operations pending proper Firebase-native migration.

The section below was written for an older 16 October REST-backed version and is retained only as historical context. Its claims about parity and completed validation do not apply to this source patch.

---

# Spotly iOS — Production Parity Build

This project is the native customer client aligned to the current Spotly Web 7.0 product contract.

## Product architecture

- Native SwiftUI `TabView`: Home, Search, Activity, Saved, Profile.
- Six first-class services: Ride, Eat, Shop, Book, Events, Send.
- Native SwiftUI navigation/back/search behavior and Liquid Glass-compatible system chrome.
- Server-backed public feeds, mixed search, business details, geocoding and transactions.
- Server-authoritative Eat/Shop orders, Book transactions, Events tickets, Ride and Send requests.
- Paynow initiation and payment-return/status reconciliation.
- Unified Activity contract with compatibility fallback while the new production route is deployed.
- Generalized Saved model with batched marketplace hydration and a bounded 404 compatibility bridge.
- Customer/Business/Driver notification audience filtering in the customer app, paired with strictly workspace-scoped push delivery in the companion backend.
- Firebase email/password authentication with Keychain session persistence and refresh.
- Real current-location acquisition with manual search that remains available when GPS fails.
- APNs/FCM registration path, token persistence and notification deep-link routing.
- Universal/deep-link routing for current web and native object links.
- Profile/account, notification preferences, support, privacy/legal links and a dedicated account-deletion initiation contract.
- Privacy manifest, associated-domain/push entitlements and Debug/Release xcconfig separation.
- Swift 6 project settings with iOS 18 minimum deployment target while building with the current SDK.
- Unit-test and UI-test targets.

## Current parity fixes included

- Activity no longer exposes raw 404 copy and can keep operating against the current deployed backend until `/api/customer/activity` is deployed.
- Saved uses `/api/public/marketplace/businesses` as the canonical batch contract and does not mix legacy Home/Work address shortcuts into marketplace Saved.
- Customer Notifications exclude Business/Driver/Admin/Staff workspace records, including defensive handling for legacy unscoped notifications.
- Commerce-ready/verified sections now require explicit commerce verification; unclaimed directory listings are shown honestly in separate discovery sections.
- Events is event-first: actual event/ticket items are primary; venues are secondary and an honest no-events state is shown when inventory is empty.
- Marketplace detail pages use a native collapsing hero that extends through the top safe area and transitions into the native inline title while scrolling.
- Address presentation deduplicates repeated locality components.
- Ride location selection keeps manual address/landmark search independent from current-location permission or GPS failure and hides the root tab bar during the focused picker.
- Send progressively reveals route, parcel, recipient and quote steps and hides the root tab bar during the focused request flow.
- Service discovery uses latest-intent-wins request handling, pagination, canonical service categories and truthful fallback media.
- Home separates verified commerce from directory discovery and uses stable horizontal card geometry.

## Required web/backend companion deployment

This iOS build is paired with the included Spotly Web/backend update. Deploy the companion web zip before removing the temporary compatibility bridges. It adds/updates:

- `GET /api/customer/activity`
- `GET /api/public/marketplace/businesses`
- `POST /api/customer/account/deletion`
- canonical marketplace taxonomy boundaries (for example `bar` does not classify `barber` as Eat)
- canonical service-feed category derivation
- nearby duplicate OpenStreetMap place deduplication

The iOS project currently keeps narrow HTTP-404 compatibility fallbacks for Activity and Saved so the customer app remains usable during deployment sequencing. They should be removed in a later cleanup once production route smoke tests confirm the new contracts are live everywhere.

## Required external console setup before archive

The source contains no server secret. One value cannot be generated from source code: the Firebase **iOS app ID** for bundle identifier `com.denzeltinashe.spotly`.

Register/confirm that iOS app in the existing Firebase project, then set `FIREBASE_IOS_APP_ID` in `spotly/Configuration/Shared.xcconfig`. This enables native Firebase Messaging initialization. The Firebase Web app ID must not be substituted for the iOS app ID.

Also confirm Push Notifications and Associated Domains for the existing Apple Developer team/bundle identifier before TestFlight archive, and upload/configure the APNs credential in Firebase.

## Validation performed in this package

- Swift parser validation over application, unit-test and UI-test sources using Swift 6.2: **PASS**.
- Privacy manifest and entitlements plist parsing: **PASS**.
- All **20** hard-coded Spotly HTTP route literals in the iOS client were checked against the supplied updated web source: **20/20 present**.
- The companion web test suite: **335/335 passing**.
- V7 UI audit: **76 checks across 39 themes passing**.
- Launch-readiness audit: **111 API routes passing static audit**.
- New iOS/native backend contract integrity tests: **7/7 passing**.
- Changed web route/module syntax checks: **PASS**.

A full Xcode/iOS SDK compile, simulator run and physical-device/TestFlight validation still must be run on macOS/Xcode because this packaging environment does not provide Xcode or Apple platform SDKs.

The production host could not be re-smoke-tested from this packaging environment because outbound DNS was unavailable. The supplied device runtime log established that the currently deployed host returned 404 for the new Activity and batch-Saved routes; deploy the companion web package, then run `node scripts/audit-ios-contracts.mjs` from the web package to verify the live host.
