# MVP Scope: Rectify (Birth Time Rectification App)

**Version:** 0.1
**Date:** 2026-05-19
**Linked to:** docs/prd.md

---

## Overview

MVP = one complete user loop, end-to-end, without extra features. The loop:

> User enters birth data + time window + life events → App calls API → User sees a ranked result with confidence score and per-event evidence → Result saved to history.

Demo mode runs this full loop with no API key and no payment, using mock data. A real calculation runs the same loop against the live endpoint via configured API access — there is **no in-app purchase or payment step in MVP** (monetization is deferred to V1.5; MVP carries only a pricing assumption).

---

## Must-Have Features

These ship with MVP or MVP does not ship.

### M1 — Onboarding (first-launch only)
- 3-screen onboarding explaining BTR in plain language, skippable
- "Try demo" and "Start real calculation" CTAs on final screen
- Shown only on first launch; never repeated

### M2 — Birth Data Input
- Date of birth (date picker, 1920–today)
- City of birth (text search with geocoding to lat/lon)
- Optional label/name for the calculation
- Field validation before proceeding (city must resolve; date not in future)

### M3 — Time Window Setup
- Toggle: "I have no idea" (full 24h window) vs. "I have an approximate time"
- If approximate: time picker + window width (±30 min, ±1 hr, ±2 hr, ±3 hr, ±6 hr)
- Brief copy on screen explaining why window size affects accuracy

### M4 — Life Events Input
- Categorized picker (12 categories: marriage, divorce, career change, job loss, relocation, child birth, family death, illness, accident, education, financial, other)
- Date entry: month + year minimum (year required, month optional)
- Optional free-text description per event (max 200 chars)
- Add / delete / reorder events
- Up to 20 events per calculation
- Soft warning when fewer than 5 events entered (not a hard block)
- Minimum 3 events to proceed to demo; minimum recommended 5 for real calculation

### M5 — Demo Mode
- Full calculation flow runs with hardcoded mock API response
- Simulated 3-second loading delay
- Results clearly labeled "Demo — not a real calculation"
- Demo mode toggle in Settings (for users who want to re-run demo later)
- Demo does not require payment or API key

### M6 — Real Calculation (no payment in MVP)
- Triggered directly from the flow — **no IAP, no price gate, no payment confirmation**
- Gated only by configured API access:
  - Production: request goes through our backend proxy / serverless function (provider key held server-side, never in the app)
  - Dev / Pro mode: uses the user-supplied API key from Settings (keychain)
- API call to rectification endpoint with full payload
- 30-second timeout with actionable error
- On API failure: show retryable error; preserve inputs as a draft (no credit/refund concept exists in MVP)

### M7 — Calculation Loading Screen
- Progress animation (non-determinate)
- Rotating copy lines about the calculation process
- "DEMO" badge if in demo mode
- Cancel option (navigates back, no charge)

### M8 — Result Screen
- Top candidate birth time displayed prominently (HH:MM, local time)
- Confidence score as percentage + visual bar or ring
- Up to 3 ranked candidate times
- Rising sign name for top candidate only (no full chart)
- Demo badge if demo result
- "See how we got this" → Evidence Breakdown
- "Save" button → saves to history

### M9 — Evidence Breakdown
- All submitted life events listed
- Per-event: category, date, match strength (Strong / Moderate / Weak / No match), brief explanation
- Match strength shown with color + text label (not color-only)
- Summary line: "X of Y events strongly supported this time"
- Expandable event cards for detail

### M10 — History
- Home screen = list of past calculations, newest first
- Each item: label, calculation date, top candidate time, confidence score
- Tap to view cached result (no re-calculation)
- Swipe-to-delete with confirmation dialog
- Empty state with CTA to start first calculation

### M11 — Settings
- Optional API key override — **Pro / Developer setting only**, for professional users with their own provider key; stored in keychain/keystore, blank by default, never used by demo mode (no bundled key exists to "fall back" to)
- Demo mode toggle
- Time format: 12h / 24h
- App version
- Privacy policy link
- "Delete all data" with confirmation

### M12 — Error States
- All error states from PRD section 14 implemented (city not found, timeout, API errors, no internet — no payment errors exist in MVP)
- Every error has an actionable recovery path — no dead ends

### M13 — Data Persistence
- All calculations stored in local SQLite database
- No server-side storage, no user account required
- "Delete all data" fully wipes local database

---

## Should-Have Features

These are desirable for MVP quality but will not block ship if time-constrained. Include if build timeline allows; otherwise defer to V1.5.

### S1 — Post-result feedback prompt — IMPLEMENTED (local-only)
- Single-question prompt after result: "Does this time feel plausible?" (Yes / Not sure / No) — shipped in `lib/features/calculation_flow/screens/result_screen.dart` / `result_screen_sections.dart`
- Answers stored locally (result id -> answer) via `lib/data/prefs/result_feedback_store.dart`; "Delete all data" wipes them via `SettingsRepository`
- No backend, no network, no analytics — on-device only

### S2 — Event entry suggestions
- Prompt "Add another event?" with category chips after the user adds their first event
- Not a full suggestion engine — just a UI nudge to add more

### S3 — Retry flow with preserved inputs — IMPLEMENTED (in-session retry)
- If calculation fails, user can retry with same inputs without re-entering everything (verified 2026-06-12: error-screen retry re-enters loading and succeeds; Cancel on `CalculationLoadingScreen` calls `CalculationFlowController.cancelSubmit()`, which aborts the in-flight Dio `CancelToken`, keeps the draft editable, and guards a late completion from clearing the draft, writing history, or stealing navigation; tests: `test/widget/features/calculation_flow/loading_screen_test.dart`, `test/widget/features/error_flow/error_routing_test.dart`)
- Inputs persisted as a draft calculation; a true persistent "save and retry later" entry point remains deferred/hidden

### S4 — Pull-to-refresh on history
- Cosmetic UX improvement on the History screen

---

## Explicitly Deferred Features

These are not permitted in MVP under any circumstances. Log any implementation attempts as scope creep.

| Feature | Why Deferred |
|---------|-------------|
| PDF / full report export | V1.5; the privacy-safe image share card has since shipped in-repo (`share_plus`, `StoryCardRenderer`, `ShareService.shareImagePng`, `resultShareImageButtonKey`), so image export is no longer deferred. PDF / full report export remains deferred; direct Instagram Stories posting stays optional until a Meta/Facebook App ID exists |
| Vedic / KP method toggle | V1.5; API method support unconfirmed; India market is secondary |
| Hindi language localization | V1.5; requires translation pipeline |
| Multiple candidate comparison view | V1.5; results UI can show 3 candidates as a list for now |
| Birth chart rendering | V2; separate API capability, significant design scope |
| In-app purchase / payment ("1 Calculation Credit") | V1.5; MVP has no real monetization, only a pricing assumption |
| Restore purchase, purchase history, refund / credit restoration | V1.5; depends on IAP shipping first |
| Subscription billing | V2; validate per-calculation IAP first |
| Bundling the provider API key in the app | Never; production uses a backend proxy, dev/pro uses the user's own key |
| Push notifications or reminders | V1.5; no recurring use case proven yet |
| Live astrologer consultation | V2; separate product feature |
| Social sharing / community | V2; requires user accounts |
| Multi-device sync | V2; requires server-side storage and accounts |
| User accounts / authentication | V2; local-only storage is sufficient for MVP |
| In-app review prompt | Originally post-MVP; since implemented in-repo as a neutral, OS-owned prompt (`in_app_review`) with eligibility/throttle logic and unit + widget tests. Rating metrics remain App Store Connect / Play Console scope; no rating impact is claimed |
| Apple Watch / widget | V2+ |
| Astrological interpretation beyond rising sign | V1.5 at earliest |

---

## Acceptance Criteria for MVP

The following conditions must all be true before MVP is considered complete.

### AC1 — Core flow works end-to-end
- [x] A new user can complete onboarding in under 90 seconds (verified 2026-06-12: 3 short screens, skippable from slide 1, and the final CTAs both persist settings and exit in one tap — "Try demo first"/"Skip" persist `demoModeDefault=true`, "Start real calculation" persists `demoModeDefault=false`; tests: `test/widget/features/onboarding/onboarding_screen_test.dart`)
- [ ] A user can enter birth data, time window, and ≥5 life events without UI errors
- [x] Demo mode completes the full loop (input → load → result → evidence) with no API key and no payment (verified 2026-06-12: offline demo loop covered by `integration_test/demo_flow_test.dart`; demo submit never reaches the network — `test/data/repos/rectification_repository_test.dart` "demo submit never calls RectificationApi.rectify")
- [ ] Real calculation completes the full loop via configured API access (Oleg's public no-key host, optional backend proxy, or user-supplied key) with no payment step (local routing and error mapping are tested — `test/providers/api_endpoint_routing_test.dart`, `test/data/api/rectification_api_test.dart` — but the live end-to-end loop still needs a bounded owner-approved device check before release)

### AC2 — Results are intelligible
- [x] The result screen displays a birth time, confidence score, and rising sign name without astrology jargon (confidence + method explainer shipped 2026-06-12: `_ConfidenceExplainer` in `result_screen_sections.dart`; low-confidence results also show next-step guidance shipped 2026-06-12: `_LowConfidenceNote` suggests adding dated events, rechecking birth data, or widening the time window; widget tests in `test/widget/features/calculation_flow/result_screen_test.dart`; framing guarded by `test/security/probabilistic_framing_test.dart`)
- [x] Evidence breakdown lists each submitted event with a match strength and explanation (verified 2026-06-12: `EvidenceCard` shows match strength and expandable explanation, `evidence_screen.dart` renders one card per event; tests: `test/widget/cards/cards_test.dart`, `test/widget/features/calculation_flow/evidence_screen_test.dart`)
- [x] Demo results are clearly marked as demo (verified 2026-06-12: `DemoPill` on the result hero and on history rows; tests: `test/widget/features/calculation_flow/result_screen_test.dart` "DEMO pill rendered for a demo result", `test/widget/cards/cards_test.dart` history-card demo pill)

### AC3 — No monetization in MVP
- [x] No IAP SDK is integrated; no purchase, price gate, or paywall is reachable in any flow (verified 2026-06-12: no `in_app_purchase` in `pubspec.yaml`; guarded by `test/security/no_payment_or_secret_strings_test.dart`)
- [x] A real calculation can be run without any payment (verified 2026-06-12: submit is gated only by configured API access — proxy or user key — with no payment surface; guarded by `test/security/no_payment_or_secret_strings_test.dart`)
- [x] No "credit", "refund", or "purchase history" surface exists in the app (verified 2026-06-12: guarded by `test/security/no_payment_or_secret_strings_test.dart`)

### AC4 — Data privacy & key handling
- [ ] The provider's shared API key is **not** present in the app binary, `--dart-define`, or bundle (release-guarded but still owner/release-build gated: the bundled review `.env` key remains until owner rotation/removal — P0-11; `tool/release_env_guard.dart` blocks unacknowledged release builds, tested by `test/tool/release_env_guard_test.dart`; final confirmation requires inspecting a release binary)
- [x] Production path calls a backend proxy; dev/pro path uses a user-supplied key stored in the device keychain (not SQLite or preferences) (verified 2026-06-12: no-key submissions fall back to the proxy path and a Settings-entered key overrides it — `test/providers/api_endpoint_routing_test.dart`; keychain isolation — `test/data/secure/api_key_isolation_test.dart`)
- [x] Demo mode performs zero network calls and uses no key (verified 2026-06-12: `test/data/repos/rectification_repository_test.dart` "demo submit never calls RectificationApi.rectify"; offline loop in `integration_test/demo_flow_test.dart`)
- [x] "Delete all data" removes all local SQLite records and cached responses (verified 2026-06-12: `test/data/repos/settings_repository_test.dart` "deleteAllData clears prefs, secure storage, and DB tables")
- [x] Privacy policy is accessible before any data submission (verified 2026-06-12: Settings privacy link opens the hosted URL when configured and always falls back to the in-app `PrivacyPolicyScreen`; tests: `test/widget/features/settings/settings_screen_test.dart`)

### AC5 — Error handling
- [x] Every API error state has user-facing copy and an actionable path (verified 2026-06-12: timeout / no-internet / bad-request / unauthorized / missing-key / server / rate-limited / malformed each route to a dedicated error screen; tests: `test/widget/features/error_flow/error_routing_test.dart`)
- [x] Timeout at 30 seconds with retry option (verified 2026-06-12: 30s default in `lib/data/api/api_client.dart`; retry re-enters loading with preserved inputs and succeeds)
- [x] No error state leads to a dead end or blank screen (verified 2026-06-12: primary actions tested — retry re-enters loading, rate-limit switches to demo or opens Settings, bad request returns to confirm; secondary actions reset to home where appropriate)

### AC6 — History
- [ ] Past calculations persist across app restarts
- [ ] Swipe-to-delete works with confirmation
- [ ] Tapping a history item shows the cached result without re-calling the API

### AC7 — Platform
- [ ] Builds and runs on iOS 15+ and Android 10+
- [ ] No critical crashes in 50-session internal testing
- [ ] Passes App Store and Google Play technical review requirements

### AC8 — Settings
- [x] Optional API key override (Pro/Dev) works and, when set, is used instead of the backend-proxy path; blank by default (verified 2026-06-12: a Settings-entered key overrides and no-key submissions fall back to proxy mode — `test/providers/api_endpoint_routing_test.dart`; stored in keychain — `test/data/secure/api_key_isolation_test.dart`)
- [x] Time format preference (12h/24h) applies across all result screens (verified 2026-06-12: `AppDateFormat`, `ShareCopyBuilder`; result/history/settings tests)
- [x] Demo mode toggle persists across restarts (verified 2026-06-12: `test/widget/features/settings/settings_screen_test.dart` "demo toggle updates settings + persists to prefs"; onboarding CTAs persist the default — `test/widget/features/onboarding/onboarding_screen_test.dart`)

---

## Demo Mode Requirements

Demo mode is the primary conversion mechanism. It must feel identical to a real calculation except for the data being mock.

### DM1 — Trigger
- Offered on final onboarding screen ("Try demo first")
- Available via Settings toggle at any time
- Visible demo badge on loading screen, result screen, and evidence breakdown

### DM2 — Mock response spec
The hardcoded demo response must include:
- 3 candidate birth times with different confidence scores (e.g., 07:14 at 78%, 07:42 at 61%, 08:03 at 44%)
- A rising sign for the top candidate (e.g., "Gemini Rising")
- 6 mock life events with varied match strengths (2 strong, 2 moderate, 1 weak, 1 no match)
- Realistic-sounding explanation text per event

### DM3 — No API dependency
- Demo must work with no network connection
- Demo must work with no API key configured

### DM4 — Upgrade nudge
- After viewing demo result, show a non-blocking prompt: "This was a demo. Run a real calculation with your own data." (no price shown — monetization is deferred to V1.5)
- Prompt appears once after each demo result view; not a modal, not blocking

### DM5 — Demo ≠ idealized
- Demo result should look realistic, not perfect. Confidence scores should not all be high — the user should see that uncertainty is normal.

---

## What Must Be True Before Moving to Design

The design phase needs **documented assumptions and a clear open-questions list — not external confirmations.** Anything that depends on a third party (API provider, App Store, legal review) is explicitly an *assumption* at this stage and is gated later, before implementation/production. Do not block design on these.

### Required before design (assumptions are acceptable)

- [ ] **Working title:** "Rectify" adopted as the recommended working title (pending App Store / domain / trademark clearance — see PRD §2). Used in all mockups and copy. Does **not** block design.
- [ ] **MVP flow defined:** The end-to-end screen flow (onboarding → birth data → time window → life events → loading → result → evidence → history) is agreed. No payment step.
- [ ] **Assumed API fields documented:** The *assumed* request/response schema (PRD §11) and the assumed life event category list are written down as assumptions. Exact schema is not required yet.
- [ ] **Demo mock shape defined:** The shape of the hardcoded demo response (candidates, confidence, per-event match strengths, explanation text) is specified so design can build the result/evidence screens. Exact final wording can iterate.
- [ ] **Privacy copy assumptions:** A plain-language draft of what data is collected, where it goes (on-device + backend proxy / provider), and the "delete all data" promise — enough to write onboarding/Settings copy. Formal legal review is **not** required before design.
- [ ] **API method assumption:** Assume API default method for V1 (Western transit) unless decided otherwise; affects result-screen copy. Can be revisited.

### Required before implementation / before production (not before design)

- [ ] **API exact schema confirmed:** Provider confirms endpoint URL, exact request/response schema, supported life event category identifiers, partial date format, sandbox/test mode, SLA.
- [ ] **Backend proxy designed:** Hosting (serverless function), proxy auth scheme (app-scoped token), rate limiting, and PII-handling policy decided and implemented. Provider key lives only here.
- [ ] **Geocoding service selected:** City-to-lat/lon provider chosen (Google Places / Nominatim / Mapbox); free-tier limits understood.
- [ ] **Flutter package choices made:** Database (sqflite / Drift), keychain storage, HTTP client, geocoding package selected.
- [ ] **Legal-reviewed privacy policy:** Lawyer-reviewed privacy policy finalized before any data submission ships to production.
- [ ] **App name cleared:** App Store name availability, domain, and trademark checked; final name confirmed (may differ from working title).
- [ ] **(V1.5, not MVP) IAP configuration:** App Store Connect / Google Play IAP product IDs registered; pricing (~$4.99 or equivalent) and currency localization confirmed. Out of MVP scope entirely.
