# Spotly iOS — Full Production Parity Audit

**Audit date:** 15 October 2026  
**Scope:** Current customer iOS codebase vs. current `spotlyafrica.com` / Spotly Web 7.0 customer platform  
**Inputs audited:** `spotly(4).zip`, `spotlyweb(20261015-131213).zip`, current iPhone screenshots, current web screenshots  
**Constraint:** Audit only. No iOS or web implementation code was changed.

---

## 1. Executive verdict

The current iOS app has a **good visual prototype foundation**, but it is **not yet the native client for the current Spotly product** and it is **not production ready**.

The largest issue is not one bad screen. The iOS app and the current web platform have diverged into two different product generations:

- **Current web:** a six-service Spotly platform — **Ride, Eat, Shop, Book, Events, Send** — with server-authoritative customer transactions, global search, unified Activity, generalized Saved, payments, delivery/ride lifecycle, support, production states, feature gates and current platform semantics.
- **Current iOS:** an older discovery/bookings prototype — category browsing, local mock businesses, local bookings/orders, simulated checkout/tracking, a Bookings tab, business-only Saved, and no active production network layer.

This means that a visual reskin would be the wrong project. iOS needs a **parity rebuild on top of the existing SwiftUI foundation**: retain the strongest native shell and design-system work, replace prototype product semantics, connect to the same production backend contracts as web, and then do the final iOS 27 polish.

### Overall release status

| Area | Status | Audit conclusion |
|---|---|---|
| Native iOS shell | **Amber / promising** | Native `TabView`, SwiftUI, semantic color work and componentization are useful foundations. |
| Visual quality | **Amber** | Clean in isolation, but visibly older and less intentional than web; media, hierarchy, service identity and information architecture need a major pass. |
| Product parity | **Red** | Current iOS does not represent Spotly's current six-service architecture. |
| Backend/data | **Red** | No active HTTP client; primary repositories are mocks; transactions are local simulations. |
| Authentication/session | **Red** | Mock auth is active and app-entry state can diverge from authentication state. |
| Commerce/payments | **Red** | Checkout/bookings/tickets are demos; web already has real server-authoritative transaction paths. |
| Ride/Send | **Red** | Missing as customer iOS experiences despite being first-class web services. |
| Location/nearby | **Red/Amber** | Permission UX exists, but current coordinates are not actually used to power nearby ranking. |
| Push/deep links | **Red** | Notification permission exists; production APNs/FCM registration and lifecycle routing do not. |
| Privacy/legal/App Store | **Red** | Demo legal copy, no privacy manifest found, no account-deletion flow found. |
| Testing/observability | **Red** | No iOS unit/UI test target found; no production crash/performance/analytics wiring found. |
| iOS 27 design adoption | **Amber** | Native tab bar is already the right direction; pushed navigation/search still bypass several strong system patterns. |

**Bottom line:** do not ship this build as “production Spotly.” Use it as the visual/native starting point for a deliberate parity implementation.

---

# 2. What was audited

## 2.1 Current web baseline

The supplied web source is materially newer and broader than the iOS app:

- Approximately **797 JS/TS/CSS source files**.
- **47 app pages** and **108 API route handlers**.
- Spotly Web package version **7.0.0**.
- Current stack includes Next 16.2.10, React 19.2.7, Firebase 12.16.0, Firebase Admin 14.2.0, Framer Motion and Zod.
- Current customer routes include `/`, `/search`, `/activity`, `/saved`, `/account`, `/eat`, `/shop`, `/book`, `/events`, `/ride`, `/send`, `/order/[id]`, `/place/[id]`, `/item/[id]`, `/support`, `/notifications`, payment return handling and more.
- Current server customer APIs include transaction creation, ride quotes/requests/ratings, parcel quotes/requests, promotions, reviews, payment flows, order state and substitution handling.

The supplied web release documentation consistently defines the customer platform around:

1. **Home** — six-service canvas and current city context.
2. **Search** — cross-type search, not only businesses.
3. **Activity** — unified lifecycle for orders, bookings, tickets, rides and sends.
4. **Saved** — businesses, products, services, events and places.
5. **Profile/account** — account and preferences.

The six service families are **Ride, Eat, Shop, Book, Events, Send**.

### Current web audit checks executed during this audit

- `npm run audit:v7-ui` — **passed 76 implementation checks across 39 audit themes**.
- `npm run audit:launch` — static audit reported **108 API routes audited** for release 7.0.0.
- `npm test` — **325 / 328 tests passed**. The three failures all come from the supplied `.env.example` missing environment-contract placeholders (`OPENAI_API_KEY`, related image/finance contract expectation, and `CRON_SECRET`). This means the web source should be treated as the product/reference baseline, but not as magically perfect.

That distinction matters: **iOS should copy the current product contracts and design language, not copy every implementation detail or every web bug.**

## 2.2 Current iOS baseline

The supplied iOS source contains:

- **81 Swift files**, approximately **12,372 lines**.
- SwiftUI + Observation (`@Observable`).
- One application target; **no unit-test or UI-test target found**.
- Firebase iOS SDK package requirement starts at **12.15.0**, but only **FirebaseCore** is linked as a product.
- No active `URLSession`/HTTP networking layer found.
- No `GoogleService-Info.plist` found.
- No `PrivacyInfo.xcprivacy` found.
- No entitlement file found.
- No `.xcconfig` environment files found.
- Project has `MARKETING_VERSION = 1.0`, `CURRENT_PROJECT_VERSION = 5`; the app UI hardcodes **“Version 1.0 · Build 2”**.
- `SWIFT_VERSION = 5.0` despite compiling against the current toolchain/platform generation.
- Project-level iOS deployment target is 27.0; target-level setting uses `$(RECOMMENDED_IPHONEOS_DEPLOYMENT_TARGET)`. This should be made intentional and explicit before release.
- `TARGETED_DEVICE_FAMILY = "1,2"`, so the target claims iPhone and iPad support.

The iOS zip also contains a **stale bundled `/web` project** using Next 14.2.16 / React 18.3.1, plus `.next`, `.git` and `xcuserdata`. The current standalone web project is Next 16 / React 19. This stale duplicate should not remain an ambiguous second source of truth in the iOS repository.

---

# 3. The central parity problem

The iOS app currently answers a different product question from web.

### Current web question

> “What do you want Spotly to do for you — ride, eat, shop, book, find an event, or send something — and what is happening with everything you already started?”

### Current iOS question

> “What categories and nearby places would you like to browse, and what bookings have you made?”

That divergence is visible immediately in the screenshots.

The web home establishes Spotly through a large **six-service composition** with distinct visual identities. The iOS home establishes Spotly through a horizontal row of **Groceries / Food / Events / Restaurants / Pharmacy / …**, followed by a generic Featured listing and generic place cards.

The categories are not wrong as secondary discovery tools. They are wrong as the **primary architecture of the current Spotly product**.

The iOS rebuild should therefore distinguish:

- **Services:** Ride / Eat / Shop / Book / Events / Send — the primary product architecture.
- **Categories and intents:** groceries, restaurants, cafes, pharmacy, spa, takeaways, activities, etc. — secondary discovery/filtering inside the right service or global search.

---

# 4. UI / UX audit

## 4.1 What should stay

Several choices in the current app should be retained instead of rebuilt for novelty:

- **Native SwiftUI `TabView`** at the root. The current iOS 27 tab bar already looks better than a custom imitation and correctly benefits from system Liquid Glass.
- **SwiftUI-first navigation architecture** rather than UIKit wrappers for routine screens.
- **Semantic light/dark color tokens** already present in the theme layer.
- **Haptic and motion helpers** where they communicate state rather than becoming decoration.
- **Reduced-motion / reduced-transparency awareness** already present in some components.
- **Feature folders and route types** as an organizational baseline.
- **Contextual location and notification permission screens** that allow “not now”/manual fallback rather than coercive permission walls.

The goal is not “make the iOS app look like the website in a phone-sized browser.” The goal is **same Spotly product, native iOS expression**.

---

## 4.2 Root information architecture — P0 product gap

### Current iOS

Root tabs:

- Home
- Search
- **Bookings**
- Saved
- Profile

### Current web contract

- Home
- Search
- **Activity**
- Saved
- Profile

This is not a label change. `Bookings` is a narrower data model and narrower mental model.

### Required target

The third root tab should become **Activity**, with a unified lifecycle model containing:

- Orders
- Delivery state
- Bookings/appointments/stays/activities
- Event tickets
- Rides
- Sends/parcels
- Payment/retry states
- Cancellations/refunds where supported
- “Needs attention” items
- Active items
- Upcoming items
- Past items
- Deep links into the exact lifecycle screen

A calendar icon and upcoming-booking badge do not describe that product. The icon, copy and badge semantics should shift to current activity/attention.

---

## 4.3 Home — P0/P1

### Current iOS strengths

- Greeting and current city are understandable.
- The top search entry is obvious.
- Overall spacing is calmer than many marketplace home screens.
- Native tab bar is visually strong.

### Current iOS problems

1. **Primary taxonomy is stale.** The horizontal square icons promote categories rather than Spotly services.
2. **The Featured module is not trustworthy enough to be “Featured.”** In the supplied screenshot, “Kingdom Hall Mkoba 18” is elevated as the main featured object with copy indicating it is derived from open-map data. A generic place should not receive the app’s strongest merchandising position simply because it is first/marked featured in sample data.
3. **“Popular near you” is currently semantically false.** The location service requests permission but the app does not actually obtain and apply the user’s coordinates to ranking. Distances are mock strings.
4. **Generic directory data dominates over verified/live marketplace inventory.** A hospital and a place of worship appearing as hero/popular content makes Spotly feel like an unfinished maps directory instead of a useful commerce/local-services platform.
5. **Image hierarchy is weak.** Large gradients are used where actual marketable imagery or service art should carry emotion and trust.
6. **The app lacks the current service identity system.** Web now gives Ride, Eat, Shop, Book, Events and Send distinct color/art directions.

### Target home structure

A strong iPhone interpretation of the current web product should be:

1. **Compact native top chrome** — city/location, notifications, account state as appropriate.
2. **Primary service composition** — all six services, visually unmistakable, not a generic category rail.
3. **Current/active lifecycle accessory** when there is something happening now.
4. **Personalization only when honest:**
   - Again/reorder only after real completed history.
   - Near you only after usable coordinates exist.
   - Otherwise “Popular in Harare,” “Live in Harare,” etc.
5. **Secondary discovery:** categories, trending intents, verified merchant collections, offers, events, etc.
6. **Real content media** or intentionally designed service artwork — not random open-map listings elevated into hero status.
7. **Designed empty/new-city states** when inventory is thin instead of filling space with low-confidence directory content.

The current category rail can survive lower on the page or inside Search; it should stop defining the product.

---

## 4.4 Search — P0/P1

### Current iOS

- Results are only `[SpotlyBusiness]`.
- Recent searches are initialized from hardcoded strings on launch.
- “Popular right now” is hardcoded.
- Category selection maps to local mock repository calls.
- There is no product/service/event/place mixed result model.
- No backend relevance/ranking/pagination.
- No native semantic search-tab role.

### Current web target

Global search spans more than businesses and understands service/city context.

### Required iOS target

Search should support a result model such as:

- Places/businesses
- Products/items
- Services
- Events
- Useful service intents
- Potentially addresses/locations for Ride and Send when entered from those flows

The visual search experience can remain highly branded after activation, but the **system search affordance should be evaluated using the native search tab role and `searchable` integration** rather than a fully custom imitation of platform chrome.

The iOS search screenshot is visually clean, but it currently looks like a static catalogue page:

- Repeated cooking imagery for Food, Restaurants and Takeaways weakens category identity.
- “Recent searches” are not actually recent user history.
- The lower content becomes visually noisy behind the translucent tab bar.
- There is no distinction between live inventory, directory-only content and unsupported commerce capability.

### Search target states

Every search mode should have intentional states for:

- New user / no history
- Typing suggestions
- Loading
- Mixed results
- No exact results but useful alternatives
- No inventory in city
- Network offline
- Partial server failure
- Location unavailable
- Recent-history management
- Logged-out vs account-backed history

---

## 4.5 Activity replacing Bookings — P0

Current `BookingsView` is extensive but solves only a subset of the current customer lifecycle.

It should not simply be renamed. It should be re-based on the web Activity contract.

### Current weaknesses

- Separate local arrays for orders and bookings in `AppState`.
- Many actions return “coming soon.”
- Transaction details are not server-authoritative.
- No Ride/Send lifecycle.
- No unified payment/action-needed model.

### Target Activity experience

Recommended hierarchy:

- **Needs attention** — failed payment, substitute choice, action-required booking, delivery exception, rider issue, etc.
- **Active** — preparing order, driver en route, ride active, parcel active.
- **Upcoming** — future booking/event/scheduled send.
- **Past** — completed/cancelled with receipt/rebook/rate/support actions.

Activity should be the customer’s operational home, not merely history.

---

## 4.6 Saved — P1

### Current iOS

Saved is effectively **favorite businesses**:

- IDs are stored in `UserDefaults`.
- Saved objects are resolved only from `MockBusinesses.all`.
- UI copy repeatedly says saved “places.”

### Current web product

Saved supports broader customer intent:

- Businesses
- Products
- Services
- Events
- Places

### Target

- Account-backed saved records when signed in.
- Guest persistence locally with merge behavior after account creation/sign-in.
- Type filters or grouped sections.
- City-independent saved records — something saved in Bulawayo should not disappear because the selected city is Harare.
- Deleted/unavailable object handling.
- Offline cached presentation.

---

## 4.7 Profile/account — P0/P1

The profile code is one of the largest parts of the app, but much of its content exposes prototype state.

### Launch-blocking copy/actions found

- “Spotly demo terms.”
- “customer marketplace demo.”
- “demo records only.”
- Privacy copy says a full policy **“will be published before public launch in 2026.”** It is now October 2026.
- “Reset demo data” is visible in the normal customer settings experience.
- Version UI hardcodes `Build 2` while the project build setting is `5`.
- Notifications show static example content.
- Payment-method screens describe demo/coming-soon state inconsistent with current web capability.

### Required target

Profile/account should become a thin, trustworthy control center for real state:

- Identity/account
- Addresses
- Payment preferences/method UX appropriate to the actual payment architecture
- Notification preferences synced to backend
- Saved/preferences where appropriate
- Privacy
- Security/session controls
- Help/support
- Legal documents
- Account deletion
- About/version derived from bundle metadata

Internal/demo reset utilities must be compiled only into explicitly internal builds, not hidden by copy or convention.

---

# 5. Six service parity audit

## 5.1 Ride — P0 missing

The current web has a production-oriented Ride 6.1 customer flow with server-priced quotes and operational lifecycle. The iOS app has no equivalent top-level Ride feature.

### Required native capability

- Pickup entry
- Destination entry
- Current-location use
- Map/pin confirmation where useful
- Vehicle class selection (matching enabled backend classes)
- Authoritative quote
- Payment method / payment state
- Request creation
- Matching/dispatch state
- Driver + vehicle identity
- Live location where backend supports it
- Pickup PIN
- Cancellation policy and server-authoritative eligibility
- Active trip state
- Completion
- Rating/support/receipt
- Feature-disabled state controlled by platform configuration

The iOS app must not invent its own ride pricing/dispatch logic. It should consume the existing server-authoritative contracts.

---

## 5.2 Send — P0 missing

The current web Send product supports immediate/scheduled parcel requests and an operational handoff lifecycle. iOS has no top-level Send feature.

### Required native capability

- Pickup/dropoff
- Current location and address confirmation
- Immediate vs scheduled
- Parcel size/weight
- Description/value
- Sender/recipient information
- Instructions
- Restricted-item acknowledgement
- Authoritative quote
- Payment
- Driver assignment/live status
- Pickup and handoff PIN/proof lifecycle
- Completion/history/support
- Feature-disabled states driven by platform settings

---

## 5.3 Eat — P0 parity gap

Current iOS has restaurant menus and a cart/checkout UI, which is useful work, but it is not connected to the current Eat product contract.

### Current prototype behavior

- Menu data is local.
- Checkout sleeps for a fixed delay, then creates a local `SpotlyOrder`.
- Order tracking advances through simulated stages using `Task.sleep`.
- A fake rider is shown.
- “Contact rider” explains that the connection is a demo.

This is unacceptable in a release build because it visually asserts operational truth that does not exist.

### Target Eat flow

- Eat landing/search aligned with current burnt-orange service identity.
- Restaurants filtered from live/eligible inventory.
- Delivery / Pickup / Open now / Deals and category filters from actual data.
- Branch selection where required.
- Published menu/catalogue.
- Product modifiers/options if backend model supports them.
- Real basket persistence.
- Availability and server-side price revalidation.
- Delivery address or pickup slot.
- Payment flow.
- Real order creation.
- Real Activity entry.
- Real delivery/collection lifecycle.
- Substitutions/cancellations/support where supported.

---

## 5.4 Shop — P0 missing as a product

Groceries and pharmacy exist as iOS categories, but there is no top-level **Shop** service architecture equivalent to web.

### Target

- Shop landing with the current green identity.
- Product and store discovery.
- Retail category/facet filters.
- Fulfilment and stock-aware presentation.
- Store/branch catalogue.
- Product detail.
- Basket and checkout via the same transaction system.
- Saved products.
- Order lifecycle through Activity.

Groceries and pharmacy become Shop discovery categories, not substitutes for the Shop service itself.

---

## 5.5 Book — P0/P1

Current iOS “Bookings” is primarily customer history plus local booking flows. The current Spotly **Book service** is a discovery/transaction destination for services and places; **Activity** should own history.

### Target Book destination

- Current blue service identity.
- Service/stay/activity discovery based on live platform inventory.
- Availability/intent-specific fields.
- Duration/pricing where applicable.
- Request or confirmation semantics that exactly match backend behavior.
- Server-created booking records.
- Payment only where the merchant/product flow actually requires it.
- Activity entry after creation.

Do not label something “confirmed” if the backend created a request that still awaits merchant acceptance.

---

## 5.6 Events — P0/P1

Current iOS Event detail is visually built out but ticket/payment flow remains a placeholder and local confirmation.

### Target

- Current purple Event identity.
- Today / Tonight / Weekend / Free / availability-capacity intent filters where data supports them.
- Event detail with actual venue/time/capacity/ticket configuration.
- Real transactional capacity checks.
- Free and paid ticket paths.
- Payment status.
- Ticket code/record.
- Activity and Saved integration.
- Shareable/deep-linkable event route.

---

# 6. Native iOS 27 / Liquid Glass audit

The user's instinct here is correct: **do not replace the parts Apple now does exceptionally well with custom replicas.**

## 6.1 Root tab bar — keep native

Current code already uses SwiftUI `TabView`; this is one of the best architectural choices in the app.

Do **not** replace it with a handmade floating capsule. The current screenshot demonstrates why: the system already gives the correct material, selection geometry, safe-area behavior and platform evolution.

### Improvement

Modernize the tab declaration enough to support the semantic **search role**, and evaluate tab-bar minimization behavior for long feeds. Search can then gain the platform’s intended iPhone behavior rather than being a custom text field that happens to sit above a tab called Search.

## 6.2 Native back/navigation — use much more often

Custom back buttons and `.navigationBarHidden(true)` are used in pushed experiences including:

- Business detail
- Event detail
- Category hub
- Booking confirmation
- Other custom hero flows

A branded hero does not require owning the entire navigation mechanism.

### Default rule

Use native `NavigationStack`/toolbar/back behavior for pushed screens unless there is a concrete experience that genuinely cannot be expressed with the system APIs.

Benefits:

- Correct back behavior
- Interactive swipe-back consistency
- Accessibility semantics
- Better iPad behavior
- Liquid Glass updates for free
- Less custom hit-testing and safe-area code

A custom hero can still extend beneath or visually integrate with native chrome.

## 6.3 “SpotlyGlass” is not Liquid Glass

The project contains a custom `SpotlyGlass` surface abstraction built from normal surface color + tint + border. It should not become the team’s conceptual substitute for Apple Liquid Glass.

Recommended naming/design rule:

- **Content cards/surfaces:** Spotly materials/colors; generally opaque or intentionally translucent according to content needs.
- **Functional floating chrome:** system Liquid Glass when appropriate.
- **Brand service art:** completely custom Spotly expression.

Do not glassify every card. Liquid Glass is strongest when it establishes control hierarchy and lets content remain content.

## 6.4 Native vs custom decision rule

### Prefer native

- Root tabs
- Back navigation
- Toolbars
- Search chrome
- Sheets
- Menus
- Context menus
- Alerts/confirmation dialogs
- Pickers/forms where stock UX is strong
- Share sheet
- Date/time selection
- Permission system prompts

### Prefer custom Spotly design

- Six-service home composition
- Service hero art
- Merchant/product/event cards
- Order/ride/send status visualization
- Commerce rows where native Form styling is not suitable
- Branded empty states
- Map/service overlays when they communicate Spotly-specific state
- Intent/filter presentation when stock segmented controls cannot handle the content density

This avoids both extremes: an app made entirely of default `List` rows, and an app that fights iOS on every navigation control.

---

# 7. Media, merchandising and trust audit

The current screenshots expose one of the biggest perceived-quality gaps.

## Problems

- Multiple search categories reuse the same chef/chopping photo.
- Several category/business assets are semantically weak (for example unrelated spa/salon assets reused for other categories in mock data).
- Generic purple gradients fill large business cards.
- Open-map directory listings can become hero content.
- The app does not visually distinguish **verified commerce inventory** from **directory-only discovery**.

## Required media rules

1. **Never use a generic directory record as premium hero merchandising without explicit curation.**
2. Prefer real merchant photography when licensed/available.
3. Use service-specific Spotly art when real photography is unavailable.
4. Repeated placeholder photos should never appear adjacent in final UI.
5. Distinguish loading skeleton from “no image supplied.”
6. Establish a fallback hierarchy by entity type and service.
7. Preserve aspect ratio/crop standards per surface.
8. Cache remote media properly and degrade gracefully offline.
9. Moderate/validate uploaded merchant media through the same production pipeline used by web.

---

# 8. Architecture audit

## 8.1 `AppState` is carrying prototype responsibilities — P0

The current `@Observable AppState` contains, among other things:

- Onboarding persistence
- Entry-flow persistence
- Appearance
- City
- Interests
- Authentication state
- Current user
- Notification preferences
- Navigation paths
- Favorites
- Bookings
- Orders
- Addresses
- Reviews
- Business enquiries
- Repository instances
- Demo reset behavior

This creates a single mutable object that is simultaneously session store, local database, navigation coordinator, dependency container and mock backend.

It is manageable for a prototype and risky for a production marketplace.

### Target separation

A practical production structure should separate at least:

- **App/session state** — signed in/guest, boot state, user identity.
- **Navigation state** — tabs and route coordination/deep-link resolution.
- **Preferences** — appearance, selected city, lightweight local choices.
- **API/auth clients** — isolated dependencies.
- **Feature/domain state** — Search, Activity, Cart, Ride, Send, etc.
- **Persistent cache** — local cache/offline support, never mistaken for transaction authority.

This does not require a giant architecture framework. It requires clear ownership and dependency boundaries.

---

## 8.2 Current repositories are mocks — P0

Active dependencies in `AppState` are:

- `MockListingRepository`
- `MockBookingRepository`
- `MockAuthService`

The source contains comments/TODOs proposing future Firebase/Firestore implementations. The important architectural correction is:

> **Do not convert the current iOS app into a direct-Firestore clone of the old prototype if the web has already moved transaction authority into server APIs.**

The iOS client should use the same backend authority model as web.

### Recommended contract

- Firebase Auth (or whatever current web identity contract resolves to) for identity/token.
- Authenticated HTTP API client for authoritative operations.
- Public/read APIs for feeds/search as appropriate.
- Server-side transaction creation for orders/bookings/tickets/Ride/Send.
- Server-side quote, availability, price, capacity and eligibility checks.
- Server-side idempotency.
- Server-authoritative payment state.
- Direct realtime database/Firestore listeners only where the existing backend intentionally exposes safe, user-scoped realtime data and rules support it.

Do not put admin/merchant authority or pricing logic in the app binary.

---

## 8.3 No active network client — P0

No active `URLSession`, `URLRequest`, HTTP response handling or equivalent production API layer was found in the Swift source.

This is the clearest architectural proof that the current build is a demo client.

### Required API layer capabilities

- Base URL/environment selection
- Auth-token injection/refresh
- Typed request/response models
- Codable date/currency conventions
- Error-envelope handling
- Idempotency keys where required
- Retry policy only for safe/idempotent operations
- Cancellation via structured concurrency
- Connectivity-aware UX
- Request tracing/correlation IDs if backend supports them
- Upload handling
- Pagination
- Cache semantics
- Mock/stub transport for tests

---

## 8.4 Data models need backend-contract alignment — P0/P1

Current local structs such as `SpotlyOrder` are intentionally tiny and cannot represent the current lifecycle.

Create a clear distinction between:

- **API DTOs** — exact backend schema.
- **Domain models** — app semantics.
- **UI presentation state** — formatting and view-specific decisions.

Avoid one huge “business” object with every optional field for every service.

Service-specific detail should have explicit types/contracts so Eat, Shop, Book, Events, Ride and Send cannot accidentally interpret the same field differently.

---

# 9. Authentication/session audit — P0

## Current state

- `MockAuthService` is active.
- Sign-in/create-account wait and generate mock state.
- Password reset does not send a real reset email.
- FirebaseAuth implementation is present only as a commented/conditional future path.
- No Firebase configure call was found in app bootstrap.
- No real auth-state listener/session restoration.
- `authState` starts as unauthenticated each process launch.
- `hasCompletedEntryFlow` is persisted independently.

This creates a specific consistency bug: the app can remember that onboarding/entry is complete while the auth session object starts unauthenticated. That is exactly the type of split-brain state production session architecture must eliminate.

## Required target

- Real startup session restoration.
- Auth state driven from actual provider state, not a second Boolean universe.
- Guest mode explicitly modeled.
- Guest data merge strategy after sign-in.
- Real email verification/reset behavior if required by policy.
- Sign-out that clears user-scoped caches without destroying unrelated device preferences.
- Revoked/expired session handling.
- Reauthentication for destructive/security-sensitive actions.
- Account deletion.

### Social login

Current Apple/Google affordances are marked “Soon”/no-op. Do not ship tappable dead controls.

If Spotly enables Google or another third-party social login for the primary account, App Store login-service requirements must be handled, normally including an equivalent privacy-preserving login option. If Spotly remains first-party email/phone only, do not add social buttons just because they are common.

---

# 10. Onboarding / first-run audit — P1

Current onboarding has two layers:

1. Intro onboarding pages.
2. A subsequent multi-step entry flow for auth/profile/interests/location/notifications.

This is heavier than the current web philosophy and contains outdated product claims, including **“Pay securely, coming soon.”**

## Target principles

- Explain Spotly as the six-service platform, not an older directory/booking concept.
- Let the person experience value before collecting optional preferences.
- Authentication should remain optional until it is genuinely needed for a user action, except where transaction/security requires it.
- City can be selected without precise location.
- Precise location should be requested in context and only when it materially improves the experience.
- Notification permission should be requested after the person understands the benefit.
- Interests should not block entry.
- Home/Work addresses can be progressive setup.
- Never claim payments or other functionality is “coming soon” when production web already provides it; instead reflect actual iOS availability/feature gate.

---

# 11. Location audit — P0/P1

## Positive

The app has a real `CLLocationManager` permission path and manual city fallback.

## Critical gap

Authorization is not the same as location. Current service code does not complete the chain of:

- request a current location,
- receive coordinates,
- update user/session context,
- use coordinates in queries/ranking,
- distinguish precise vs approximate/unavailable location.

As a result, current “near you” and distance presentation is not production truth.

## Target behavior

- Manual city always works.
- Ask for location only when useful.
- On grant, actually obtain a coordinate.
- Handle approximate location.
- Handle denied/restricted permissions without nag loops.
- Fall back to city-level discovery.
- Only use “near you” when a meaningful coordinate exists and the result query used it.
- Avoid background location for a normal marketplace session unless a specific active feature absolutely requires it and the platform/backend design justifies it.

---

# 12. Notifications audit — P0/P1

Current code requests local notification authorization, but that is only the first 10% of production push.

No complete production chain was found for:

- APNs registration
- Push token handling
- Firebase Messaging integration
- Device-token registration to Spotly backend
- User/topic preference synchronization
- Notification categories/actions
- Deep-link handling from a notification into the correct Activity/order/ride/send/support route
- Token refresh/removal on sign-out

The current `notificationPreference` set is held in memory and is not an authoritative account preference.

### Target

Push needs to be treated as an operational channel, especially for:

- Order updates
- Driver/ride/send updates
- Booking changes
- Event/ticket state
- Payment action required
- Support replies

Notification permission should remain optional; in-app Activity must still be authoritative.

---

# 13. Payments and transaction integrity — P0

The iOS app currently shows payment choices and Paynow copy, but it does not use the production payment contract.

Never implement merchant pricing/payment authority in the iOS app.

### Required transaction pattern

1. Client builds intent/basket/request.
2. Server validates current business/branch/service state.
3. Server revalidates price/capacity/stock/currency/availability.
4. Server creates idempotent transaction record.
5. Payment provider initiation occurs through trusted server logic.
6. Provider callback/status is reconciled server-side.
7. Client observes/refreshes authoritative state.
8. Activity reflects the resulting lifecycle.

If a payment handoff requires browser/provider UI, design the native handoff deliberately and safely; do not pretend a local “success” view is a payment confirmation.

---

# 14. Deep links, universal links and continuity — P1

No full universal-link/deep-link architecture or Associated Domains entitlement was found.

This matters because the web already has shareable object routes.

### iOS should resolve at minimum

- Place/business
- Item/product
- Event
- Order/Activity object
- Ride
- Send/parcel
- Support conversation
- Payment return/status where native flow requires it
- Referral links if retained

Every deep link needs behavior for:

- cold launch,
- warm launch,
- logged out,
- guest,
- signed in to wrong account where relevant,
- deleted/unavailable object,
- feature unavailable in current city.

---

# 15. Offline, loading, error and recovery — P1

The web release documentation has explicit offline/error/partial-state thinking. iOS presently has little production network behavior because there is no network layer.

Every networked iOS surface needs intentional states:

- first load
- refresh
- cached data + refresh
- empty
- offline with cached data
- offline without cache
- timeout
- authentication expired
- permission missing
- object no longer exists
- partial content failure
- transaction retry/reconciliation

Skeletons are useful only when there is a real asynchronous data source behind them. Never use fake delay to make a demo appear networked.

---

# 16. Security / privacy / legal audit — P0

## 16.1 Privacy manifest

The app uses `UserDefaults` throughout but no `PrivacyInfo.xcprivacy` file was found. Apple categorizes `UserDefaults` as a required-reason API category and requires the app’s relevant approved reason to be declared in a privacy manifest.

This should be treated as a release task, not a documentation nicety.

## 16.2 Legal copy

Current in-app privacy and terms are explicitly demo/pre-launch documents. They must be replaced with the actual current legal documents or current web legal routes before production.

## 16.3 Account deletion

The app supports account-creation UX but no production account-deletion path was found. App Store requirements require apps with account creation to allow the user to initiate account deletion in the app.

## 16.4 Secrets/configuration

There are currently no environment config files and no active backend client. Production design must ensure:

- no server secrets in the app bundle,
- separate development/staging/production endpoints,
- Firebase configuration per environment,
- provider secrets stay server-side,
- App Check/device integrity strategy is compatible with current backend controls,
- logs never include sensitive payment/auth/location data unnecessarily.

## 16.5 Health/pharmacy representation

Pharmacy appears in discovery. The app should avoid accidentally representing directory/product discovery as medical advice or implying unsupported prescription/health workflows. Current demo legal copy already hints this area was known but unresolved.

---

# 17. Build/release engineering audit — P0/P1

## Findings

- Swift language setting is `5.0`.
- iOS deployment-target settings are not cleanly intentional.
- App UI build number is hardcoded and wrong.
- No environment `.xcconfig` structure found.
- No entitlements found for push/associated domains/Sign in with Apple.
- Firebase package is present but only FirebaseCore is linked.
- No `GoogleService-Info.plist` found.
- App icon uses the older raster app-icon set; no modern Icon Composer source was found.
- iPad is declared supported without evidence of an iPad-specific/adaptive UX pass.
- No test target found.

## Required release cleanup

- Compile with the current Xcode 27 SDK.
- Decide the **minimum supported iOS version intentionally**; do not confuse “build with iOS 27 SDK” with “only people on iOS 27 may install.” If Spotly intentionally wants iOS 27-only, document that product decision. Otherwise set a lower supported minimum based on actual audience/testing.
- Move toward current Swift language/concurrency checking deliberately, not as an all-at-once warning avalanche at the end.
- Derive app version/build from `Bundle` metadata.
- Introduce Debug/Staging/Release configuration.
- Add required capabilities/entitlements.
- Keep server secrets out of all app config.
- Add current icon source strategy, including current clear/tinted appearance support if Spotly wants to take advantage of the modern icon system.
- Remove stale `/web`, `.next`, user-specific `xcuserdata`, and other ambiguous generated source from the iOS repository where appropriate.

---

# 18. Accessibility audit — P1

The current design system has some good groundwork, but accessibility needs a release-level pass rather than spot fixes.

### Required test matrix

- VoiceOver on every core flow
- Dynamic Type through accessibility sizes
- Bold Text
- Increase Contrast
- Reduce Transparency
- Reduce Motion
- Differentiate Without Color
- Button Shapes if relevant
- Switch Control / keyboard focus where applicable
- Large content viewer / context where system controls provide it

### Current risk patterns

- Many fixed frames and fixed system font sizes.
- Custom image/icon buttons.
- Custom navigation/back behavior.
- Dense card compositions.
- Text sometimes line-limited inside fixed visual regions.
- Large translucent tab bar overlays content.

The correct goal is not “everything grows infinitely.” It is that important content remains perceivable, operable and understandable at supported accessibility settings.

---

# 19. iPad and adaptive-layout audit — P1

The target claims iPad support but the current app is primarily phone-composed.

A production iPad app needs an explicit choice:

- Deliver a truly adaptive iPad experience, or
- stop claiming broad iPad support until it is ready, if product policy permits.

If iPad remains supported, audit:

- portrait/landscape
- multitasking widths
- resizable windows
- larger content grids
- navigation split/detail patterns where they improve the experience
- toolbar placement
- popover vs sheet adaptation
- map/commerce layouts
- keyboard/pointer interaction

Do not simply stretch the iPhone feed across a tablet.

---

# 20. Performance audit — P1

Because the current app is mock/local, it has not yet faced the performance behavior of production data.

### Production risks to design for now

- Large search/catalogue lists
- Image decode/cache pressure
- Repeated feature feed requests
- Location updates
- Realtime activity/ride/send updates
- State invalidation caused by one giant `AppState`
- Navigation destinations retaining oversized models
- MainActor work during decoding/transformation

### Required performance work

- Paginate feeds/search.
- Use proper remote image caching and cancellation.
- Keep observable state scoped.
- Measure launch time and first meaningful content.
- Eliminate the fixed **2-second splash delay** in `RootView`; startup should wait only on real boot requirements and should surface content as soon as it can.
- Profile scrolling and image-heavy screens on physical devices.
- Test poor network, not only localhost/Wi-Fi.

---

# 21. Testing / QA / observability audit — P0

No iOS XCTest/XCUITest target or test code was found.

That is incompatible with the production requirement for a multi-service transaction app.

## Minimum automated coverage

### Unit/domain

- Money/currency formatting
- Quote/transaction mapping
- Activity state grouping
- Feature-gate logic
- Search result mapping
- Deep-link parsing
- Auth/session transitions
- Guest-to-user merge behavior
- Location fallback semantics
- Cancellation eligibility presentation

### API contract

- Decode current backend fixtures for all production endpoints used by iOS.
- Validate error envelopes.
- Validate backward-compatible optional fields.
- Mock 401/403/404/409/422/429/5xx/offline behavior.

### UI / end-to-end

- First run as guest
- Sign up/sign in/reset
- Home service navigation
- Search mixed result
- Save/unsave
- Eat order path
- Shop order path
- Book path
- Event ticket path
- Activity actions
- Ride request/lifecycle
- Send request/lifecycle
- Payment return/reconciliation
- Push notification -> exact destination
- Deep link cold launch
- Account deletion

### Visual/accessibility

- Small iPhone
- Current Pro Max
- iPad sizes if supported
- Light/dark
- Dynamic Type
- Reduce Motion/Transparency
- Empty/loading/error/offline states

## Observability needed

- Crash reporting
- Nonfatal error capture
- Network/service error metrics
- Transaction funnel metrics with privacy-safe event design
- Performance monitoring
- Push-delivery/token health where measurable
- Server correlation IDs when debugging customer incidents

A production app should make “what broke for this user?” answerable without reproducing everything manually.

---

# 22. Screen-by-screen current iOS disposition

| Current area | Keep | Rebuild / change |
|---|---|---|
| Root `TabView` | **Keep** | Change Bookings -> Activity; modernize Search role. |
| Home header | **Keep concept** | Tighten native chrome; connect actual location/account/notification state. |
| Home category rail | **Keep as secondary discovery** | Remove as primary product architecture; introduce six services first. |
| Featured banner | **Rebuild** | Curated/live service or merchant content only; no accidental OSM hero. |
| Popular near you | **Rebuild semantics** | Use coordinates or rename to city-level wording. |
| Search | **Rebuild data/product model** | Mixed server search, real recent history, native search semantics. |
| Browse category grid | **Keep concept** | Better unique media, service-aware taxonomy, actual inventory. |
| Bookings tab | **Replace** | Unified Activity. Reuse useful card/detail subcomponents where appropriate. |
| Saved | **Expand** | All supported saved types; account-backed sync. |
| Profile shell | **Keep concept** | Remove demo copy/tools; connect real account/legal/support/payment/notification state. |
| Business detail | **Reuse selectively** | Backend entity contract, native navigation, capability-based actions. |
| Restaurant menu | **Reuse visual components** | Live catalog, branch/availability/pricing, real cart. |
| Checkout | **Reuse layout selectively** | Server-authoritative transaction/payment flow. |
| Order tracking | **Rebuild behavior** | Remove simulated rider/status. Real Activity/delivery state. |
| Booking flow | **Reuse selectively** | Align server semantics; real availability/request/confirmation. |
| Event detail | **Reuse visual base** | Real ticket/capacity/payment contract. |
| Onboarding | **Rework** | Current six-service story, lighter progressive setup, remove stale payment copy. |
| Auth | **Rebuild backend** | Real auth/session/reset/account deletion; remove no-op social buttons. |
| Notifications | **Rebuild backend** | APNs/FCM/server prefs/deep links. |
| Location | **Complete** | Obtain/use real coordinate; precise/approximate/fallback semantics. |
| Custom glass surfaces | **Rename/rethink** | Do not present colored card styling as a replacement for system Liquid Glass. |
| Custom pushed back buttons | **Reduce heavily** | Prefer native back/toolbars while preserving branded content. |

---

# 23. Production target architecture

The clean target can remain straightforward:

```text
SpotlyApp
  └─ AppContainer / Dependencies
      ├─ SessionController
      │   └─ Auth provider + current user
      ├─ NavigationCoordinator
      │   └─ tabs + deep links
      ├─ APIClient
      │   ├─ public/read APIs
      │   ├─ customer transaction APIs
      │   └─ payment/status APIs
      ├─ LocationClient
      ├─ PushClient
      ├─ RealtimeActivityClient (only where needed)
      ├─ Cache/Persistence
      └─ Observability

Features
  ├─ Home
  ├─ Search
  ├─ Activity
  ├─ Saved
  ├─ Profile
  ├─ Ride
  ├─ Eat
  ├─ Shop
  ├─ Book
  ├─ Events
  └─ Send
```

Each feature owns its presentation state. The server owns commerce/ride/send truth.

This is intentionally less magical than a large “clean architecture” framework. Spotly needs strong seams, not ceremony.

---

# 24. Recommended implementation sequence

## Phase 0 — Contract lock and prototype cleanup

**Goal:** stop building more UI against obsolete assumptions.

- Freeze the current web customer contract as the parity baseline.
- Inventory exact endpoints/data shapes iOS needs.
- Decide minimum iOS support target while building with Xcode 27.
- Establish environment configuration.
- Establish real Firebase/app bootstrap.
- Create API/auth/session foundation.
- Introduce tests before feature migration.
- Remove fixed splash delay.
- Remove/demo-gate prototype-only utilities.
- Define release-vs-internal data behavior.

**Exit condition:** iOS can authenticate/guest, boot safely, call current backend, display a real user/session/platform configuration, and has a test harness.

## Phase 1 — Customer shell parity

**Goal:** make iOS structurally the same Spotly product before finishing all transactions.

- Home six-service architecture.
- Search global/mixed contract.
- Activity root tab.
- Saved generalized model.
- Profile/account real state.
- Location real semantics.
- Push registration/preferences.
- Universal/deep-link foundation.
- Native iOS 27 navigation/search cleanup.

**Exit condition:** a user moving between web and iOS recognizes one product and one account state.

## Phase 2 — Marketplace transaction parity

**Goal:** real Eat / Shop / Book / Events.

- Live listings/catalogues.
- Real detail and availability.
- Basket/booking/ticket transaction creation.
- Payment handoff/reconciliation.
- Activity integration.
- Support/cancellation/error paths.

**Exit condition:** no fake order/booking/ticket success exists in the release build.

## Phase 3 — Ride + Send

**Goal:** bring the two operational services to native parity.

- Quotes.
- Requests.
- Dispatch/assignment state.
- Maps/current location.
- PIN/proof lifecycle.
- Active state.
- Cancellation/support/rating where applicable.
- Platform feature gating.

**Exit condition:** enabled Ride/Send cities can complete the same core customer lifecycle on iOS as web.

## Phase 4 — Production polish and App Store hardening

**Goal:** remove every remaining “prototype” edge.

- Accessibility/device matrix.
- iPad/adaptive pass or support-scope decision.
- Performance profiling.
- Remote image/cache polish.
- Error/offline/recovery polish.
- Privacy manifest/App Privacy declarations.
- Final legal copy/account deletion.
- Observability.
- Full automated regression suite.
- TestFlight operational rehearsal.
- App icon/store assets/versioning/release metadata.

---

# 25. P0 release blockers

The following should be treated as **non-negotiable before calling the iOS app production ready**:

1. Replace mock auth/session with production identity/session restoration.
2. Add the production API/data layer; no transactional operation may depend on local mock repositories.
3. Remove simulated checkout/order tracking/booking/ticket success from release behavior.
4. Introduce Activity as the lifecycle root instead of Bookings.
5. Implement/feature-gate all six Spotly services so iOS never presents a different product definition from web.
6. Implement server-authoritative Eat/Shop/Book/Events transaction paths.
7. Implement Ride and Send before exposing them as enabled services.
8. Complete real location behavior before using “near you”/distance claims.
9. Implement push token/backend/deep-link lifecycle for operational updates.
10. Replace demo legal documents and pre-launch claims.
11. Add in-app account-deletion initiation for accounts.
12. Add privacy manifest and complete privacy review.
13. Add tests, crash/error observability and release QA gates.
14. Establish environment configuration/capabilities/entitlements and real Firebase initialization.
15. Remove visible demo/reset tooling and hardcoded incorrect version information from release builds.

---

# 26. P1 parity requirements

Immediately after/following the P0 foundation:

- Global mixed Search.
- All-type Saved.
- Real support conversations/deep links as current backend permits.
- Honest empty/new-city/partial inventory states.
- Web-consistent service filters and service identity.
- Native search-role/tab behavior.
- Native pushed navigation/back behavior.
- Better verified/live vs directory-only presentation.
- Real recent search/history/personalization semantics.
- Deep links/universal links.
- Offline/cache/retry behavior.
- Full accessibility pass.
- Adaptive iPad/size-class strategy.

---

# 27. P2 polish that will materially improve perceived quality

- Modern app icon source / clear-tinted appearance treatment.
- Remove repeated category imagery and improve fallback asset system.
- Service-specific transitions/microinteractions with reduced-motion alternatives.
- Appropriate `tabBarMinimizeBehavior` on long feeds if it improves content browsing.
- More intentional scroll-edge treatment under Liquid Glass rather than custom opaque fixes.
- Native toolbar overflow/priority behavior where dense actions exist.
- Haptic hierarchy standardization.
- Content skeletons that match real final geometry.
- Merchant photo quality rules and image loading transitions.
- iPad pointer/keyboard refinement.

---

# 28. “Do not do this” list

To keep the rebuild from drifting again:

- **Do not** make iOS a visual clone of desktop web.
- **Do not** build a custom root tab bar to imitate Liquid Glass.
- **Do not** replace native back navigation everywhere for branding.
- **Do not** apply glass to every content card.
- **Do not** wire production transactions directly to Firestore merely because the old repository comments suggest it.
- **Do not** trust prices, capacity, ride quotes or payment success generated on-device.
- **Do not** keep fake riders, fake tracking stages or fake confirmations in a production build.
- **Do not** use “near you” without actual usable location context.
- **Do not** use static “popular”/“recent” labels for sample data in production.
- **Do not** expose “coming soon” buttons that look actionable.
- **Do not** allow web and iOS to maintain different service taxonomies or lifecycle terminology.
- **Do not** target iOS 27-only accidentally merely because the SDK/toolchain is 27.

---

# 29. Definition of done for Spotly iOS production parity

The release should not be considered complete until all of the following are true:

### Product

- Home establishes Ride/Eat/Shop/Book/Events/Send as Spotly’s service architecture.
- Root tabs are Home/Search/Activity/Saved/Profile.
- Search is current, mixed and server-backed.
- Saved supports the same meaningful object families as web.
- Activity contains the customer’s real cross-service lifecycle.

### Transactions

- Every enabled checkout/request/ticket/ride/send is created by the production backend.
- No release screen fabricates success or progress.
- Payment and capacity/price truth is server-authoritative.
- Failed/interrupted transactions recover correctly.

### Account

- Real auth/session restoration works.
- Guest mode is coherent.
- Data merges or remains correctly scoped on sign-in/sign-out.
- Account deletion exists.
- Legal/privacy content is current.

### Platform

- Native iOS 27 tab/navigation/search patterns are used where they are stronger than custom UI.
- Spotly custom design is concentrated in content and service identity.
- Dynamic Type/VoiceOver/reduced motion/transparency are validated.
- iPad support is genuinely adaptive or intentionally removed from supported scope.

### Operations

- Push updates deep-link correctly.
- Universal links work cold/warm.
- Offline/error states are honest.
- Crash/error/performance monitoring is active.
- Feature gates from platform configuration are respected.
- Test suite covers core flows and contract decoding.

### Release

- No “demo,” fake tracking, stale “coming soon,” test merchant, reset-demo or incorrect version copy leaks into Release.
- Privacy manifest and App Store privacy metadata match actual behavior.
- No secrets are bundled.
- Debug/staging/production are separated.
- TestFlight production rehearsal completes against real staging/prod-like services.

---

# 30. Final assessment

The iOS project is **worth evolving rather than throwing away**. Its native shell, visual token work, SwiftUI structure and some polished detail screens provide useful material. But the correct framing is important:

> **We are not “finishing the current iOS demo.” We are making iOS a first-class client of the current Spotly platform.**

The strongest move is to preserve the native pieces that are already right — especially the system tab bar and SwiftUI foundation — then deliberately replace every stale product/data assumption underneath them.

The first implementation pass should therefore begin with **platform contract + shell parity**, not with another round of isolated screen polishing. Once Home/Search/Activity/Saved/Profile and the backend/session foundations are aligned, the existing visual quality can be elevated into something that feels substantially more premium than the web while still remaining unmistakably the same Spotly product.

---

## Apple platform guidance consulted for this audit

- Apple Developer Documentation — **Adopting Liquid Glass**
- Apple Developer Documentation — **SwiftUI updates** (June 2025 and June 2026 / Xcode 27)
- Apple WWDC26 — **What’s new in SwiftUI**
- Apple Developer Documentation — **Describing use of required reason API** / `NSPrivacyAccessedAPICategoryUserDefaults`
- Apple App Review — **Offering account deletion in your app** / Guideline 5.1.1(v)
- Apple App Review Guidelines — **Login Services** (4.8)

