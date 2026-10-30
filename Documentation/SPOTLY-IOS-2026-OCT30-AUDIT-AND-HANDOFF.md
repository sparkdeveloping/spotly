> **Superseded on 30 October 2026 by `SPOTLY-IOS-2026-PASS2-IMPLEMENTATION-AND-RISK-AUDIT.md`.** The prior missing-iOS-Firebase-App-ID blocker has been addressed with the owner-supplied `GoogleService-Info.plist`; the prior Cloud Functions recommendation has been replaced by a launch architecture using existing trusted Next.js endpoints for operations Firestore rules deny, with no new Cloud Functions. This document remains historical evidence of the first batch.

# Spotly customer iOS — 30 October 2026 engineering audit and implementation handoff

**State: first native modernization batch implemented in source; NOT compiled or production-ready.**

## Evidence inspected

- Uploaded customer iOS project: `spotly(6).zip`, containing `spotly.xcodeproj`, native source, tests, configuration, and dated 16 October implementation notes.
- Uploaded current web project: `spotlyweb(20261030-170140).zip` including Firestore rules, marketplace APIs, Firebase identity configuration and web UI.
- Uploaded approved `SpotlyBrandingKit(6).zip` and current site screenshot of the six service cards.
- Public website `spotlyafrica.com` (live page dynamically rendered, screenshot provides actual visual reference).
- Firebase Swift reference for auth `getIDToken(forcingRefresh:)` and Firestore async `getDocument()` and `getDocuments()`.
- No Firebase Console access, Firestore dataset export, crash logs, Xcode compile, simulator, device, or live write tests were available.

## Priority 0 — production Firebase identity mismatch

Web's `lib/firebase-project-config.js` canonically defines `spotly-africa`, sender `14197555543` and its matching public client key. The original iOS `Configuration/Shared.xcconfig` and `SpotlyConfiguration.swift` target **a different project**: `denzeltinashe-spotly`, sender `815870787939`. The iOS Firebase Apple App ID setting is empty.

This is not a minor routing preference. It risks independent customer accounts and business data between platforms. The patch changes the *source configuration* to match web's public project identity, but **native SDK startup remains intentionally disabled until the real iOS app ID for `com.denzeltinashe.spotly` is registered and inserted**. Do not substitute the Firebase Web app ID. Do not merge/release this code before registering the iOS app and testing existing web customer accounts.

The previous custom `FirebaseSession` contained ID/refresh tokens and stored them in app Keychain. The patch removes direct session-token persistence and uses FirebaseAuth's built-in session management instead. On launch it removes the retired Keychain record; users from the older project are **not** silently imported or granted access to `spotly-africa`.

## Second priority — backend approach is not yet fully Firebase-native

The original iOS project uses **20 distinct `/api/...` route literals**. All 20 have matching route files in the provided web archive, but existence does not prove they are deployed or working. Routes appear across `MarketplaceStore`, `SavedStore`, `ActivityStore`, `ServiceDiscoveryView`, `DeepLinkDestinationView`, `SavedView`, and `ProductionServices`.

The first patch eliminates the home-grown Identity Toolkit REST client and the home-grown Firestore REST client. **Those 20 website API calls remain, and must be migrated in later staged batches.** Never describe the result as a complete Firebase-native product.

The web feed implementation (`app/api/public/service-feed/route.js`) does more than a simple collection query: server-side it combines merchants, branches, product offerings, promotions, external directory data, editorial trust rules, ranking and regional availability. Its seed fetch can pull up to 500 businesses, 1,200 branches, 2,000 products and 1,000 promotions, with server cache. Copying it as full-client Firestore reads would be expensive, insecure/incomplete under current rules, and inconsistent with web ranking. The correct long-term approach is a Firestore-backed, read-optimized, **bounded/indexed public discovery projection**, or a trusted Firebase Cloud Function backed by the same authoritative ranking library. This needs backend design and deployment approval.

### Operation owner proposal (requires implementation and live-rule verification)

| Customer operation | Appropriate owner | Current iOS status |
| --- | --- | --- |
| Email login, signup, email verification, password reset, token refresh | Native FirebaseAuth | **Replaced with SDK in source**, pending Firebase iOS app registration/build |
| User profile read/create/update | Native Firestore, under `users/{uid}` rules | **Replaced with SDK**, field-level preference update avoids wiping other settings |
| Saved items and favorites | Native Firestore under user-scoped rules | **Replaced transport with SDK**; display hydration still calls public website APIs |
| Customer notifications and preferences | Native Firestore (query, update read state, settings write) | **Replaced with SDK**; no realtime listeners yet |
| FCM token persistence | Native Firestore + Messaging | **SDK document writes added**; requires valid APNs/FCM setup |
| Public business search, feed, enrichment, taxonomy, editorial ranking | Bounded Firestore materialized public index or Firebase callable/HTTPS Function | **Still website APIs**; do not copy multi-thousand-document server scan into the phone |
| Public geocoding / map provider | Approved geolocation provider with key restrictions, or Firebase Function proxy if secrets required | **Still website API** |
| Ride and Send quotes and requests | Authenticated Cloud Functions with validated tariff, territory, dispatch, idempotency | **Still website APIs** |
| Orders, Book, Live reservations, inventory and capacity | Cloud Functions with transactions and server-side authorization | **Still website APIs** |
| Paynow initiation/status and payment reconciliation | Cloud Functions / payment webhooks, never iOS client secrets | **Still website APIs** |
| Support conversation creation, account deletion requests, reviews | Authenticated Cloud Functions for staff routing, audit, content safeguards | **Still website APIs** |
| Orders/booking/activity reads where permitted | Firestore scoped query or generated customer activity projection | Current normalized Activity comes from website API; Firestore order read adapter exists |
| Analytics, App Check, Crashlytics, Remote Config | Native Firebase SDK | **Not integrated yet**; App Check must be planned before enforcement |

## Product parity (source-derived, not runtime-verified)

| Journey | Web reference | Original iOS source | 30 Oct batch |
| --- | --- | --- | --- |
| Home and six services | Branded violet Home, Bite / Shopper / Ride / Book / Live / Send with distinct 3D illustrations | Real Home and all six entry views; older Eat / Shop / Events labels; large Ride card plus basic colored tiles | Source UI now uses correct six names, 3D web art, paired two-column grid and revised hero |
| Bite | `/bite`, marketplace discovery and food | `eat` service feed, item and merchant details, ordering flow | UI branding updated; remote feed/transaction API still pending |
| Shopper | `/shopper`, store/product discovery | `shop` feed, products and checkout | UI branding updated; feeds and checkout still website API |
| Ride | `/ride`, ride quote/request, service coverage | Ride request/picker and activity tracking | Service visual updated; quote, request, tracking still website API |
| Book | `/book`, reservations and appointments | `book` feed, item details and transaction | Distinct Book art/name; backend still website API |
| Live | `/live`, events and tickets | `events` feed, event-first content and booking | Distinct Live art/name; backend still website API |
| Send | `/send`, quotes/parcel handoff | `send` request screen and activity | Visual updated; protected request handling still website API |
| Accounts / onboarding | Firebase web client | Native onboarding and custom REST Firebase email flow | Native Auth SDK wired to correct project identity; real Apple app registration outstanding |
| Search / taxonomy / editorial | Web taxonomy, matching, ranking, brands, trust tiers | Native search and server-backed discovery with debounce | No search logic replacement; avoid expensive blind reads |
| Saved | `/saved` and typed user records | Native `SavedStore` and hydration | Saved record Firestore operations now native SDK; hydration still website API |
| Activity | `/activity`, normalized cross-service updates | Native `ActivityStore` with 404 compatibility | Legacy web API remains; direct order records adapter exists |
| Notifications | `/notifications`, workspace-scoped filters | Native filtering/FCM + profile settings | Native Firestore adapter; push setup still untested |
| Profile/settings | `/account`, locale/city, privacy/support | Native profile, support and notification settings | Native profile updates via SDK; support remains website API |
| Appearance/accessibility | Modern responsive web; brand system | Light/dark SwiftUI tokens and some Reduce Motion safeguards | Six-card UI updated; full contrast, VoiceOver and Dynamic Type audit pending |
| Deep links | Web canonical paths | Native coordinator and modal destination view | In-place; still uses website search for lookup |
| Privacy, legal and App Store | Web policies | Privacy manifest and entitlement files | Source was inspected only; consent, data deletion and real App Store review pending |

## Implemented files

- `spotly/Core/Network/SpotlyConfiguration.swift` and `spotly/Configuration/Shared.xcconfig`: aligned public Firebase identity, validate iOS App ID prefix and reject arbitrary different project for native startup.
- `spotly/Core/Platform/FirebaseBootstrap.swift` **new**: configures native Firebase once, before SwiftUI root bootstrap, without treating Messaging as the app initializer.
- `spotly/spotlyApp.swift` and `spotly/Core/Platform/PushCoordinator.swift`: initialize Firebase at app creation, leave Messaging delegation in push coordinator; invalidate FCM device token on local signout.
- `spotly/Core/Network/SessionController.swift`: uses native FirebaseAuth, removes hand-written token refresh/Keychain session persistence, retains same public interface used by callers.
- `spotly/Core/Network/APIClient.swift`: adds a specific actionable configuration error if the Firebase iOS App ID is missing.
- `spotly/Core/Network/FirestoreREST.swift`: retains existing models/method names for minimal callsite churn while using native FirebaseFirestore queries and documents directly; bounded reads.
- `spotly.xcodeproj/project.pbxproj`: declares `FirebaseAuth` and `FirebaseFirestore` products from already-pinned Firebase SDK package.
- `spotly/Core/Models/Production/MarketplaceModels.swift`: presentation labels and tint tokens aligned with Web and brand kit while preserving authoritative internal IDs.
- `spotly/Features/Production/ProductionHomeView.swift`: all six services in web order, new branded illustration tiles, intentional text hierarchy, image accessibility.
- `spotly/Features/Home/MainTabView.swift`: filled symbol variants while retaining native iOS tab behaviors.
- `spotly/Core/Navigation/AppState.swift`: clear previous customer state immediately on signout instead of waiting for the push network operation.
- `spotly/Assets.xcassets/Service_*.imageset`: six PNG variants of approved web 3D service artwork; no network image dependencies.
- `spotly/Assets.xcassets/AppIcon.appiconset`: icon set from supplied primary identity in approved branding kit.
- `spotlyTests/ProductionRegressionTests.swift`: static identity/service presentation assertions.

## High-priority defects / risks remaining

1. **Release blocker — iOS Firebase App ID:** not registered/provided. Need console registration, bundle verification and native test before any real sign in. The patch prevents silent native initialization against a mismatched project.
2. **Release blocker — `/api` coupling:** 20 routes still called. They need migration to Firebase native queries or secure Functions with server counterpart; do not remove them without equivalents.
3. **Critical — old sessions:** old project identities do not equal new project identities; test proper login/migration communication for existing customers.
4. **High — stale remote FCM records:** local signout now clears UI state synchronously and deletes the device token asynchronously. The backend may still retain an `active` push-token document until an authenticated cleanup / failed-send sweep is implemented; confirm token revocation on a real device and implement backend cleanup.
5. **High — current feed cost:** server feed reads potentially thousands of documents per uncached computation. An indexed discovery projection could materially cut backend cost for web **and** iOS.
6. **High — App Check:** native App Check not added; do not enable enforcement for iOS until the client has been configured and tested.
7. **High — account-scoped listeners and caching:** most data use one-shot reads, not managed real-time listeners. Plan cancellation, listener cleanup and account change invalidation.
8. **High — UI reliability:** no actual Xcode compile or simulator screenshots; layout and design need accessibility, contrast, keyboard and small-screen test on real devices.
9. **High — app permissions:** confirm APNs, universal link domain entitlements, iOS permission description strings and privacy manifest against real iOS behavior.
10. **High — API/token compatibility:** Cloud Functions must validate Firebase Auth/App Check correctly; existing website routes may have additional rate-limit, payment and customer pilot gates.
11. **Medium — crash diagnostics:** no Crashlytics collection, Xcode logs, crash traces or observability available for the reported crashes. Do not claim them solved.
12. **Medium — production availability truth:** a decorative service card must never imply that Ride/Send/Book commerce is live in a city unless the backend confirms it; gate action flows on authoritative capability flags.

## Verification performed on this source batch

- `swiftc -frontend -parse` on all app, unit-test, UI-test Swift files: **PASS** (syntax parser only).
- `plutil -lint` for `.pbxproj` and `PrivacyInfo.xcprivacy`: **PASS**.
- JSON parse for all 25 asset `Contents.json`: **PASS**.
- Inspected 20 literal website API paths against the supplied web route files: **20/20 present in source** (not live-tested).
- Attempts to run web's premium visual test suite: **BLOCKED**, missing local Node dependency `sharp`; this is not a test failure in product logic.
- Actual native `xcodebuild`, Swift type checking with Firebase module interfaces, emulator, live Firebase login, permissions, transactions, layout screenshots and TestFlight: **NOT PERFORMED** (no macOS/Xcode or production credentials).

## Next exact work, in order

1. In Firebase Console, select `spotly-africa`. Register iOS app bundle `com.denzeltinashe.spotly`, verify Apple Team ID and app configuration, add its `GOOGLE_APP_ID` as `FIREBASE_IOS_APP_ID` in `Shared.xcconfig` or use an approved local build-secret overlay. **Do not use Web `appId`.** Verify Firebase Auth authorized flows, user creation rules and App Check rollout requirements with test accounts.
2. Open `spotly.xcodeproj` in Xcode with iOS 18+ simulator/device. Resolve SPM Firebase products. Compile `spotly` then `spotlyTests`; address any SDK-specific Swift 6 strict-concurrency typing diagnostics. Verify launch on missing ID produces guest-capable UI without crash, and configured build signs in with an existing `spotly-africa` user.
3. Build a Firebase-native public discovery contract: city/service-specific lightweight indexed documents (bounded per page), shared taxonomy/merchant trust/brand signals, explicit unavailable states, Firestore rules/indexes and tests. Avoid pulling 4,700 documents per Home load.
4. Move commerce, Paynow, Ride/Send dispatch and protected customer operations to callable/HTTPS Cloud Functions, keeping existing validation/idempotency/authorization from the web routes. Do not change payment/rule production infrastructure without approval. Update native repositories to call them and remove `/api` dependencies only after they exist and are tested.
5. Rebuild Activity and Saved hydration over native collections or read models and implement account-scoped listener lifecycles and accurate offline states.
6. Complete professional UI pass for each customer screen beyond Home: search, market details, Book/Live distinction, orders, maps, ride/send workflow, profile, notifications, support. Verify both appearance modes and Reduce Motion.
7. Verify signout and push token revocation on device, add stale token cleanup, integrate App Check and Crashlytics, add regression tests for auth expiry and nil/incomplete Firestore data.
8. Test 6 service journeys, empty states, failed network, expired tokens, user switching, permission denial, tiny/large iPhones, Dynamic Type, VoiceOver and push/deep links. Only then prepare a release candidate.

## Suggested local Xcode checks

```bash
xcodebuild -resolvePackageDependencies -project spotly.xcodeproj -scheme spotly
xcodebuild -project spotly.xcodeproj -scheme spotly -configuration Debug -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO build
xcodebuild -project spotly.xcodeproj -scheme spotly -configuration Debug -destination 'platform=iOS Simulator,name=iPhone 17' test
```

Use an actually available simulator name; check `xcrun simctl list devices available`. Test Firebase in a restricted nonproduction account, with controlled permissions and clearly isolated transactions. Never use live customer financial data as a test fixture.

---

### Change control

All changes were made inside an extracted copy of the supplied archive. **No GitHub branch, PR, Firebase rules, production data, or deployed website were modified.** An implementation archive accompanies this report. The next session must start by reading this file and current source rather than assuming an Xcode build has occurred.
