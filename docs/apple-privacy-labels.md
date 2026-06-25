# App Store Connect — App Privacy ("Privacy Nutrition Labels") Guidance — TrueRise

**Prepared:** 2026-06-02 · **Model:** claude-opus-4-8 · **Scope:** preparation
guidance only.

> This document maps TrueRise's **verified current behavior** to the App Store
> Connect *App Privacy* questionnaire so the owner can answer it accurately. It
> is **not legal advice** and is **not** a submission. Items needing an
> owner/legal decision are marked `[OWNER/LEGAL]`. Do not invent provider
> contract terms, retention periods, or a data-processing agreement.

---

## 1. How Apple frames the questionnaire

App Store Connect asks, for each Apple **data type**:

1. **Do you collect this data?** Apple's "collect" means transmitting it off the
   device in a way that you or your third-party partners can access — including
   data sent to a provider acting on your behalf. Data that never leaves the
   device is **not** "collected."
2. If collected: **Is it linked to the user's identity?**
3. **Is it used for tracking?** (cross-app/cross-site, or shared with data
   brokers/ad networks).
4. **Purpose(s)** (e.g., App Functionality, Analytics, Product Personalization,
   Advertising).

A key consequence for TrueRise: **demo mode collects nothing**, but **live mode
transmits data off-device**, so the app as a whole must be declared based on
live-mode behavior. You answer for the whole app, not per-mode.

## 2. Verified behavior this guidance is based on

| Fact | Evidence (read-only) | Confidence |
|---|---|---|
| Demo mode makes **zero** network calls (short-circuits before any HTTP; a Dio client is asserted *never* constructed in demo) | `lib/data/repos/rectification_repository.dart` (demo branch), `lib/data/api/api_client.dart` (demo assert) | High |
| Live mode transmits birth + event data to a third-party provider over **HTTPS** | `lib/data/api/dto/rectification_request_dto.dart`, `lib/data/api/mappers.dart`, `lib/data/api/rectification_api.dart`; base URLs are `https://…` | High |
| Transmitted fields: birth date (Y/M/D); birth hour/minute + time-search window; city text; latitude/longitude; per-event category, date, optional free-text description | `rectification_request_dto.dart` (`BirthDataV3Dto`, `TimeSearchDto`, `EventV3Dto`), `mappers.dart` | High |
| Birthplace **coordinates** are real lat/lon (e.g., 50.4501, 30.5234 — 4 decimal places) | `docs/api-integration.md` payload sample; `geo_place.dart` | High |
| City search/geocoding can transmit the typed city search text to the configured geocoding provider/proxy, or to the device's native geocoding service when no explicit HTTP geocoder is configured. The on-device stub is only a last fallback. | `lib/features/calculation_flow/geocoding/geocoding_service.dart` (`HttpGeocodingService`, `NativePlatformGeocodingService`, `StubGeocodingService`) | High |
| Secure storage holds **only** a user-supplied provider API key (`pro_api_key`) | `lib/data/secure/secure_key_store.dart` | High |
| Local persistence: birth/event/result rows + raw response JSON (Drift) and a few settings (SharedPreferences) — stays on device | `lib/data/db/tables.dart`, `lib/data/prefs/settings_store.dart` | High |
| **No** analytics, crash-reporting, advertising, or tracking SDKs | full `pubspec.yaml` dependency set; no `firebase_*`, `sentry`, `*_ads`, `app_tracking_transparency`, IDFA/AdSupport references | High |
| **No** user accounts / login / OAuth | no auth routes in `lib/app/router.dart`; no identity model | High |
| **Delete all data** wipes DB + prefs + secure storage | `lib/data/repos/settings_repository.dart` (`deleteAllData`) | High |
| The optional calculation **label** is stored locally and **not** sent to the provider (request DTO has no label field) | `rectification_request_dto.dart`, `mappers.dart` | High |

## 3. The distinction Apple cares about: collected-by-developer vs transmitted-to-provider

- **TrueRise (developer) runs no server that stores your content.** We do not
  operate a backend that retains the data you enter. [OWNER/LEGAL: if a backend
  **proxy** is used in production, confirm whether it logs/retains request
  content — that would change this statement.]
- **However**, Apple counts data that **leaves the device**, including data sent
  to a provider performing the calculation. In **live mode**, TrueRise transmits
  the fields in §2 to the third-party calculation provider. The conservative,
  reviewer-safe stance is therefore to declare those transmitted types as
  **collected**, with **purpose = App Functionality**, **not linked to identity**
  (no account/identifier), and **not used for tracking**.
- The data is the app's **primary functionality**, so Apple's "optional
  disclosure / infrequent collection" exception does **not** apply — disclose it.

## 4. Recommended answers by Apple data category

Legend — **Collect?** = recommended answer · **Linked?** = linked to identity ·
**Track?** = used for tracking.

| Apple category / type | Collect? | Linked? | Track? | Purpose | Rationale + evidence | Confidence |
|---|---|---|---|---|---|---|
| **Contact Info** (name, email, phone, address) | **No** | — | — | — | No name/email/phone/address fields anywhere. (See free-text caveat below.) | High |
| **Health & Fitness** | **`[OWNER/LEGAL]`** | No | No | App Functionality | Not from HealthKit. But a life-event **category** "illness" maps to `health_diagnosis`, "accident" exists, and free-text descriptions can describe health events. Owner/legal: decide whether voluntary, user-typed health-adjacent events require a **Health** disclosure. Conservative = disclose. | Low / decision |
| **Financial Info** | **No** (payments) | — | — | — | No IAP/payments. The `financial` life-event category is biographical text, not financial-account data — treat as User Content/Other Data, not Apple "Financial Info." [OWNER/LEGAL confirm] | Medium |
| **Location — Precise** | **`[OWNER/LEGAL]`** — see §5 | No | No | App Functionality | Birthplace lat/lon at ≥3 decimals **meets Apple's resolution test** for Precise Location, **but** it is a *birthplace you pick*, not device/current location, and the app uses **no** location services/permission. Defensible either way; **do not hide it.** | Decision (key) |
| **Location — Coarse** | **No** | — | — | — | App does not derive coarse device location. | High |
| **Sensitive Info** | **`[OWNER/LEGAL]`** | No | No | App Functionality | Free-text event descriptions are unconstrained and could contain Apple-"sensitive" content (e.g., sexual orientation, religious belief, health/disability). Owner/legal: decide whether to disclose given free-text risk. | Low / decision |
| **Contacts** | **No** | — | — | — | No address-book access. | High |
| **User Content — Other User Content** | **Yes** | No | No | App Functionality | The optional **free-text life-event descriptions** are user-generated content and **are transmitted** in live mode. Best-fit bucket. (The calc *label* is User Content too but stays on-device → not collected.) | High |
| **User Content — Emails/Texts, Photos, Audio, Gameplay, Customer Support** | **No** | — | — | — | None of these surfaces exist. | High |
| **Browsing History** | **No** | — | — | — | No web browsing. | High |
| **Search History** | **No** | — | — | — | City search is on-device and not stored/transmitted. | High |
| **Identifiers — User ID / Device ID** | **No** | — | — | — | No per-user/-device identifier collected. The constant `X-Rectify-App-Id` proxy header is an app-level public ID shared by all installs, not a user/device identifier; no IDFA. | High (note app-id) |
| **Purchases** | **No** | — | — | — | No IAP/purchase history. | High |
| **Usage Data** | **No** | — | — | — | No analytics SDK; no product-interaction telemetry. | High |
| **Diagnostics** | **No** | — | — | — | No crash-reporting/performance SDK. (README lists Crashlytics as a *future* follow-up — re-answer if added.) | High |
| **Other Data Types** | **Yes** | No | No | App Functionality | The structured **birth date**, **birth time + window**, and **birthplace** fields, plus per-event **category/date**, that are transmitted in live mode and don't fit a narrower bucket. | High |

### Cross-cutting answers

- **Linked to identity?** Recommend **Not Linked** for every collected type:
  there is no account and no identifier with which TrueRise links the data.
  [OWNER/LEGAL confirm — the data is *inherently* identifying about a real
  person if combined, but Apple's "linked" question is about whether *you* link
  it to an identity, which TrueRise does not.]
- **Used for tracking?** **No** for everything — no ad networks, no data
  brokers, no cross-app/site linking. High confidence.

## 5. The Precise-Location judgment call (do not hide it)

The single most important decision. In live mode the app sends a **birthplace**
latitude/longitude (e.g., `50.4501, 30.5234`) **when available**.

- **Reading A — declare under Location → Precise Location (conservative).** The
  coordinate resolution (≥3 decimal places) literally matches Apple's definition
  of Precise Location, so a reviewer may expect it declared. Purpose = App
  Functionality; Not Linked; Not for Tracking.
- **Reading B — treat as "Other Data," not Location.** Apple frames Location as
  the location *of the user or device*. This is a **biographical birthplace** the
  user selects; the app requests **no** location permission and reads **no**
  device GPS. Under this reading it is not "Location" but birthplace context.

**Recommendation:** if uncertain, choose **Reading A** (disclose as Precise
Location) — it is the safer answer with App Review — and record the rationale.
Either way, **do not omit the coordinates from disclosure.** [OWNER/LEGAL to
make and document the final call.]

## 6. App Tracking Transparency (ATT)

The app does **not** track: no ad SDKs, no `app_tracking_transparency`, no
IDFA/AdSupport usage (verified absent in `pubspec.yaml`/imports). Therefore no
ATT prompt and no `NSUserTrackingUsageDescription` are required. Confidence:
High. [OWNER/LEGAL: re-evaluate if any attribution/ads SDK is ever added.]

## 7. Privacy "notes" wording for App Review

Suggested reviewer-facing note (App Privacy details / Review Notes):

> "TrueRise has no accounts and no analytics, crash-reporting, advertising, or
> tracking SDKs. **Demo mode is fully offline.** In **live** mode the app sends
> the user's birth date, approximate birth time/window, birthplace text and
> coordinates (when available), and life-event categories/dates/descriptions to
> a third-party calculation provider over HTTPS, solely to compute the result;
> it is not linked to an identity and not used for tracking. Users can erase all
> local data via Settings → Delete all data."

## 8. Owner/legal checklist (Apple)

- [ ] **Location decision (§5):** declare birthplace coordinates under Precise
      Location (conservative) or as Other Data; document the rationale.
- [ ] **Health / Sensitive Info:** decide whether the `illness`/`accident`
      categories and free-text descriptions require Health and/or Sensitive Info
      disclosure.
- [ ] **Linked vs Not Linked:** confirm "Not Linked to You" given no accounts.
- [ ] **Provider relationship:** confirm direct-to-provider vs backend-proxy,
      whether the proxy retains content, the provider's retention, and provide
      the provider's privacy-policy URL.
- [ ] **Demo/review build key:** the review build may embed a low-budget
      provider key for App Review (not a label item, but note it in Review Notes
      and confirm the rotation plan — see store-submission docs).
- [ ] **Future SDKs:** if analytics or crash reporting (README's Crashlytics
      follow-up) is added, re-answer Usage Data / Diagnostics.
- [ ] **Hosted policy URL:** enter the live `docs/privacy-policy.md` URL in App
      Store Connect (App Privacy *and* the app metadata privacy field).
- [ ] **Age:** confirm the App Store age rating matches the in-app 18+ gate.

## 9. Unresolved questions

1. Is the calculation provider an independent third party or a contracted
   processor acting on TrueRise's behalf? (Affects how the provider is described
   in App Privacy.) — `[OWNER/LEGAL]`
2. Does the provider (or proxy) retain request content, and for how long?
   — `[OWNER/LEGAL]`
3. Final Precise-Location classification for the birthplace coordinates.
   — `[OWNER/LEGAL]`
4. Whether free-text descriptions warrant Health/Sensitive disclosure given they
   are unconstrained. — `[OWNER/LEGAL]`
