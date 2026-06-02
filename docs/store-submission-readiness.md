# Store Submission Readiness — TrueRise (codename `rectify`)

**Run 6 · 2026-06-02 · model `claude-opus-4-8` · documentation-only planning run.**

> **How to read the evidence labels.** Every load-bearing claim is tagged:
> **[VERIFIED]** = confirmed this run by reading source/config in this repo;
> **[ASSUMED]** = inherited from a prior run's doc or a reasonable default, not
> re-verified against a live system; **[PROPOSED]** = a recommendation/draft for
> an owner to decide. No live store rankings, install counts, ratings, review
> quotes, trademark clearance, or store approvals are asserted anywhere in this
> document; all such items are routed to Section 12 as owner decisions.
>
> **Brand convention.** *TrueRise* is the public brand; *Rectify* /
> `com.rectify.rectify` is the current internal codename + bundle baseline
> (`README.md` title "TrueRise (codename rectify)"). **[VERIFIED]**

---

## 1. Executive summary

TrueRise is a feature-complete MVP — 177 unit/widget/golden tests plus one
integration test reported green (`docs/qa-phase8-report.md`, 2026-05-20), a
live rectification path against a third-party astrology API, an offline demo
mode, and a privacy-safe text-share feature. **The build is not submittable
today.** The blockers are not feature gaps; they are publication-hygiene and
compliance gaps that were intentionally deferred during the build and are now
the critical path.

**The P0 blocker set (all [VERIFIED] this run):**

1. **Public-name mismatch.** The binary still shows *Rectify* (iOS
   `CFBundleDisplayName=Rectify`, Android `android:label="rectify"`), and
   "Rectify" is baked into the in-app title, the Settings version row, and the
   privacy copy — while the brand, README, and share copy say *TrueRise*.
2. **Release is debug-signed.** `android/app/build.gradle.kts` ships the
   release build type with `signingConfig = signingConfigs.getByName("debug")`.
   A debug-signed AAB cannot go to Play production.
3. **No hosted privacy-policy URL.** The app has only an in-app privacy screen;
   there is no `url_launcher` dependency and no canonical hosted URL. Both
   stores require a reachable URL in the listing.
4. **Privacy/data-safety disclosures are not authored — and the in-app copy
   under-discloses.** In live mode the app transmits birth date, a birth-time
   estimate, precise birthplace latitude/longitude, and free-text life-event
   descriptions to a third-party API; the in-app screen emphasizes "on-device
   only" and does not surface that transmission. Apple privacy labels and the
   Play Data Safety form must both be filled in to match real behavior.
5. **No age gate.** The birth-date picker accepts any date from 1920 to today
   with no minimum-age floor, despite the PRD's COPPA age-gate requirement.
6. **Default app icon.** The build still uses the stock Flutter glyph.
7. **Store metadata + screenshots do not exist.** `pubspec.yaml` description is
   the placeholder "A new Flutter project."; no listing copy or screenshots are
   captured. ASO drafts exist (Run 3) but are unbuilt.
8. **Localized listings are blocked on an unbuilt l10n pipeline** (Run 4 G20 /
   Run 5). English Tier 0 can ship now; DE/FR/ES/PT-BR listings cannot.

**Recommendation:** sequence a single config-and-compliance gate run (Impl Run A
— name, bundle-ID decision, release signing, icon, age gate), stand up the
hosted privacy policy, finalize the English-only listing from the Run 3 ASO
package, capture screenshots, then submit **English Tier 0 first** under
**iOS Utilities / Play Tools** positioning (Apple 4.3(b) survival). Localized
listings follow only after Impl Run C/D. This document specifies each step,
labels every claim, and ends with the owner decisions that gate submission.

---

## 2. Current verified app and store readiness state

### 2.1 What is real today

| Area | State | Evidence |
| --- | --- | --- |
| App completeness | MVP feature-complete; 177 tests + 1 integration green | `docs/qa-phase8-report.md` (2026-05-20) **[ASSUMED — not re-run this run]** |
| Live calculation | Real path to third-party API; demo path fully offline | `lib/data/api/dto/rectification_request_dto.dart`, `lib/features/settings/settings_screen.dart` demo toggle **[VERIFIED]** |
| Result UX | Hero time + rising + confidence, ≤2 alt candidates, evidence screen, demo pill, demo upgrade nudge | `lib/features/calculation_flow/screens/result_screen.dart` **[VERIFIED]** |
| Sharing | **Text** share, PII-free by construction, OS share sheet w/ clipboard fallback | `lib/core/sharing/share_copy_builder.dart`, `share_service.dart` **[VERIFIED]** |
| Privacy posture | On-device storage, no accounts, "Delete all data", optional user key in keychain/Keystore | `lib/features/settings/privacy_policy_screen.dart`, `settings_screen.dart` **[VERIFIED]** |
| Analytics / crash reporting | **None wired** (no analytics SDK, no crash reporting) | `pubspec.yaml` (no firebase/sentry/posthog/amplitude); privacy screen text **[VERIFIED]** |
| iOS platform config | `CFBundleDisplayName=Rectify`, `CFBundleName=rectify`; no `NS*UsageDescription`; no ATS block; portrait+landscape | `ios/Runner/Info.plist` **[VERIFIED]** |
| Android platform config | `android:label="rectify"`; only `INTERNET` permission; release = **debug-signed** | `android/app/src/main/AndroidManifest.xml`, `android/app/build.gradle.kts` **[VERIFIED]** |
| Bundle identity | `namespace` + `applicationId` = `com.rectify.rectify`; version `1.0.0+1` | `android/app/build.gradle.kts`, `pubspec.yaml` **[VERIFIED]** |
| App icon | Stock Flutter glyph | `docs/qa-phase8-report.md` §6 **[ASSUMED — no icon asset added since]** |
| Localization | English-only; no `.arb`, no `l10n.yaml`, no `flutter_localizations` | Run 5 `docs/l10n-strategy.md`, `pubspec.yaml` **[VERIFIED]** |
| Demo/review key | `.env` bundled as an asset; key recoverable from the binary | `pubspec.yaml` assets, `README.md` **[VERIFIED]** |
| Build pin | `dependency_overrides: objective_c: 9.3.0` (build-hook regression workaround) | `pubspec.yaml` **[VERIFIED]** |

### 2.2 What does NOT exist yet (store-facing)

- Hosted privacy-policy URL. **[VERIFIED absent]**
- Apple App Privacy ("nutrition label") answers and Play Data Safety form.
  **[VERIFIED — not authored]**
- App Store / Play listing metadata (title, subtitle, descriptions, keywords).
  **[VERIFIED — placeholder only]**
- Screenshot set for any device class. **[VERIFIED absent]**
- Release signing keystore/profile (Android) and a distribution provisioning
  setup (iOS). **[VERIFIED — Android debug-signed; iOS signing not in repo]**
- Real app icon + adaptive icon. **[ASSUMED absent]**
- Localized listings (DE/FR/ES/PT-BR). **[VERIFIED blocked on G20/G22]**

### 2.3 What is explicitly out of scope for first submission

Per `docs/mvp-scope.md` and `CLAUDE.md`: payments/IAP/paywalls, accounts/sync,
dark mode, chart rendering, PDF/image export, Vedic/KP toggles, the privacy-safe
share **card image** (Run 4 G9, a V1.5 growth lever), and any analytics SDK.
None of these are submission blockers; do **not** pull them forward to unblock
the store. **[VERIFIED scope]**

---

## 3. Blocking pre-submission checklist (P0)

Each item below blocks first submission. ID maps to Run 4
(`docs/feature-gap-analysis.md`) where applicable.

| # | Blocker | Gap | Evidence | Fix owner-track |
| --- | --- | --- | --- | --- |
| P0-1 | **Public display name = TrueRise** across iOS `CFBundleDisplayName`, Android `android:label`, in-app title, Settings version row, privacy copy | G1 | `Info.plist`, `AndroidManifest.xml`, `lib/features/settings/settings_screen.dart:157` ("Rectify  v1.0.0"), `privacy_policy_screen.dart` ("What Rectify stores") **[VERIFIED]** | Impl Run A (config + 4 string sites) |
| P0-2 | **Release signing** — generate upload keystore (Android) + distribution signing (iOS); replace debug signing | G5 | `build.gradle.kts` release `signingConfig = ...debug`; `README.md` "intentionally signed with the debug keys for now" **[VERIFIED]** | Impl Run A + owner secrets |
| P0-3 | **Bundle-ID decision** — keep `com.rectify.rectify` or rebrand to a `com.truerise.*` ID **before first publish** (irreversible after) | G5 | `build.gradle.kts` `applicationId` **[VERIFIED]** | Owner decision (Sec. 12) → Impl Run A |
| P0-4 | **Hosted privacy-policy URL** reachable + linked in both listings | G2 | No `url_launcher` dep; `privacy_policy_screen.dart` header comment "Phase 8 swaps this for the canonical hosted URL" **[VERIFIED]** | Owner hosting + Legal |
| P0-5 | **Apple App Privacy labels + Play Data Safety** authored to match real data flow (incl. third-party transmission of birth data + life-event text + precise location in live mode) | G3 | `rectification_request_dto.dart` fields; `pubspec.yaml` (no analytics) **[VERIFIED]** | Owner + Legal (Sec. 4/5/9) |
| P0-6 | **Age gate / age rating** — add a minimum-age floor on the birth-date picker per PRD COPPA note, and set the store age rating consistently | G6 | `lib/features/calculation_flow/screens/birth_data_screen.dart` `firstDate: DateTime(1920), lastDate: now`, **no** born-before floor; `docs/prd.md` §13 "age gate (born before 2008)" **[VERIFIED absent]** | Owner decision (cutoff) → Impl Run A |
| P0-7 | **Real app icon** (iOS + Android adaptive) | G4 | `docs/qa-phase8-report.md` §6 default glyph **[ASSUMED]** | Design asset → Impl Run A |
| P0-8 | **Store metadata finalized** (title/subtitle/keywords/descriptions); replace `pubspec` placeholder description | G7 | `pubspec.yaml` "A new Flutter project." **[VERIFIED]** | Sec. 6 package → owner |
| P0-9 | **Screenshot set** captured for required device classes | G8 | none in repo **[VERIFIED absent]** | Sec. 8 storyboard → capture |
| P0-10 | **Category positioning** confirmed: iOS **Utilities**, Play **Tools** (4.3(b) survival) | — | Run 2/3; Vedic Samay precedent **[ASSUMED]** | Owner confirm (Sec. 9) |
| P0-11 | **Demo/review key hygiene** — rotate to a low-budget capped key before public build; confirm `.env` exposure is acceptable for review | — | `README.md`, `pubspec.yaml` `.env` asset **[VERIFIED]** | Owner key rotation |

**Not P0 (do not block on these):** privacy-safe share **card image** (G9,
V1.5), analytics SDK (G13, greenfield), localized listings (G20/G22 — English
Tier 0 ships without them).

---

## 4. iOS App Store readiness

### 4.1 Binary / Xcode configuration

- **Display name.** `CFBundleDisplayName` must become **TrueRise**
  (currently `Rectify`). `CFBundleName` (`rectify`) is the short internal name
  and is less user-visible, but align it for consistency. **[VERIFIED gap]**
- **Bundle identifier.** Decide `com.rectify.rectify` vs a `com.truerise.*`
  rebrand **before** the first App Store Connect record exists — the bundle ID
  is immutable post-creation. **[VERIFIED / owner decision]**
- **Version / build.** `1.0.0 (1)` is fine for a first submission; bump the
  build number on each upload. **[VERIFIED]**
- **Privacy usage strings.** `Info.plist` has **no** `NS*UsageDescription`
  keys. The app declares no camera/location/contacts/mic usage and uses only
  network + the share sheet, so usage strings are likely **not required** —
  but confirm no transitive plugin demands one. **[VERIFIED absent / confirm]**
- **ATS.** No `NSAppTransportSecurity` block; the live endpoint is HTTPS
  (`https://api.astrology-api.io/...`, `README.md`), so default ATS is
  satisfied. Do **not** add ATS exceptions. **[VERIFIED]**
- **Orientation.** Info.plist allows portrait + landscape. Confirm the UI is
  acceptable in landscape on iPad if iPad is a target, or restrict to portrait.
  **[VERIFIED / confirm]**
- **Signing.** Set up the distribution certificate + provisioning profile in
  Xcode/App Store Connect (not present in-repo). **[ASSUMED needed]**

### 4.2 App Store Connect listing

- **Category.** Primary **Utilities**; optional secondary **Reference**
  (Run 3). This is the 4.3(b) mitigation, not a cosmetic choice — see Sec. 9.
  **[PROPOSED]**
- **Age rating.** Complete the questionnaire consistently with the in-app age
  gate (P0-6). Astrology/"infrequent mature themes" answers must be honest;
  expect a 12+ outcome unless the questionnaire indicates otherwise. **[PROPOSED]**
- **App Privacy ("nutrition labels").** Author to match verified behavior:
  - **Data collected & linked/Not linked:** In **live** mode the app sends
    **Precise Location** (birthplace latitude/longitude), **Sensitive Info**
    (free-text life-event descriptions can contain personal life detail), and
    **Other Data** (birth date/time estimate) to the third-party provider for
    the calculation. It is **not** linked to a TrueRise account (there is none).
    **[VERIFIED data flow]**
  - **Data used for tracking:** **None** (no analytics/ads SDK). **[VERIFIED]**
  - **Data NOT collected by TrueRise servers:** TrueRise runs no backend/account
    store; on-device data stays on device. The third-party provider's handling
    of submitted data is governed by **its** policy and must be named in the
    hosted privacy policy. **[VERIFIED / Legal]**
- **Privacy policy URL.** Required field — blocked on P0-4. **[VERIFIED]**
- **Demo account / review notes.** Provide reviewer instructions: how to run
  **Demo mode** (offline, no key) so review does not consume live API credits,
  and disclose that demo results are labeled with a DEMO pill. **[PROPOSED]**
- **Export compliance.** Standard HTTPS only; answer the encryption question
  accordingly (no custom crypto). **[ASSUMED]**

### 4.3 Likely review friction (see Sec. 9)

Guideline **4.3(b)** (saturation: fortune-telling/astrology) is the primary
risk. Utilities positioning + honest, utility-framed, probabilistic copy is the
mitigation. **5.1.1/5.1.2** (data collection & storage) requires the privacy
labels and hosted policy to be accurate about the third-party transmission.
**[ASSUMED risk / VERIFIED data basis]**

---

## 5. Google Play readiness

### 5.1 Binary / Gradle configuration

- **Application label.** `android:label="rectify"` must become **TrueRise**.
  **[VERIFIED gap]**
- **Application ID.** `com.rectify.rectify`; same immutability caveat as iOS —
  decide before first upload. **[VERIFIED / owner decision]**
- **Release signing.** Replace the debug `signingConfig` with a real upload key
  and enroll in Play App Signing. **A debug-signed AAB will be rejected from
  production.** **[VERIFIED P0]**
- **Permissions.** Only `INTERNET` is app-declared — minimal and clean. Note
  the merged release AAB adds a `DUMP` permission via
  `androidx.profileinstaller` (not app-declared) per `docs/qa-phase8-report.md`
  §4; this is a known library behavior, but be ready to explain it if Play
  flags it. **[VERIFIED / ASSUMED-benign]**
- **Target API level.** Confirm `targetSdk` meets Play's current minimum for
  new apps at submission time (Flutter default may lag Play's annual bump).
  Re-check in-console. **[ASSUMED / verify]**
- **AAB size.** ~60 MB release AAB reported (`qa-phase8-report.md`); acceptable.
  **[ASSUMED]**

### 5.2 Play Console listing

- **Category.** **Tools** (Run 2/3). **[PROPOSED]**
- **Data Safety form.** Author to match the verified flow:
  - **Data collected:** Approximate/Precise **Location** (birthplace
    coordinates), **Personal info** (birth date/time), and **free-text**
    life-event descriptions — **transmitted** to a third-party API in live mode;
    declare **"Data shared"** with a third party for app functionality.
    **[VERIFIED data flow]**
  - **Encryption in transit:** Yes (HTTPS). **[VERIFIED]**
  - **Data deletion:** In-app "Delete all data" wipes local DB, prefs, and the
    secure-storage key; surface this and the deletion path. **[VERIFIED]**
  - **No analytics/ads/tracking SDKs.** Declare none. **[VERIFIED]**
  - The form must not claim "no data shared" — live mode shares birth data with
    the provider. Under-declaring is a Data Safety violation. **[VERIFIED risk]**
- **Privacy policy URL.** Required — blocked on P0-4. **[VERIFIED]**
- **Content rating (IARC) questionnaire.** Complete consistently with the age
  gate; astrology content + user-entered free text should be answered honestly.
  **[PROPOSED]**
- **Target audience & content / Families policy.** Declare an **adult** target
  audience (not children) consistent with the age gate (P0-6); this keeps the
  app out of the Families program and aligns with the PRD "not targeted at
  children" stance. **[PROPOSED / VERIFIED PRD basis]**
- **Ads declaration:** No ads. **[VERIFIED]**

### 5.3 Pre-launch report

Use Play's pre-launch report (automated device testing) on the internal-testing
track before promoting. Run **Demo mode** there to avoid spending live API
credits. **[PROPOSED]**

---

## 6. ASO publication package for English Tier 0

Source: `docs/aso-naming-strategy.md` (Run 3). All character counts below are
**approximate and must be re-counted in the store console**, which counts some
characters differently. These are **[PROPOSED]** drafts, not guarantees.

> **No ranking promise.** Nothing here guarantees a top-10 position for any
> term. The high-intent long-tail set is where a new, single-purpose app can
> *realistically* compete; the head terms are explicitly flagged as
> too-competitive and are **not** to be chased.

### 6.1 App name / title

- **iOS title (≤30):** `TrueRise: Birth Time Finder` (~27). **[PROPOSED]**
- **Play title (≤30):** `TrueRise: Birth Time Finder` (~27). **[PROPOSED]**
- Brand **TrueRise** stays English in every locale (Sec. 7).

### 6.2 iOS subtitle (≤30)

- **Primary:** `Find your real birth time` (~25). **[PROPOSED]**
- **Alt:** `Rectify your birth time` (~23) — uses "rectify" as the **domain
  verb**, not the brand; acceptable but watch for brand/codename confusion.
  **[PROPOSED / caution]**

### 6.3 iOS keyword field (≤100, comma-separated, no spaces, no title repeats)

Do **not** repeat words already in the title/subtitle ("birth", "time",
"find"). Two directional drafts (re-count + de-dupe in console):

- **Draft A (high-intent long-tail lead):**
  `rectification,unknown birth time,rising sign,ascendant,natal chart,houses,astrology,chart`
  (~90). **[PROPOSED]**
- **Draft B (adds supporting reach):**
  `rectification,birth chart,rising sign,ascendant,natal,houses,zodiac,astrology,horoscope`
  (~88). **[PROPOSED]**

### 6.4 Keyword strategy — high-intent vs too-competitive

- **Group A — high-intent long-tail (compete here):** "birth time
  rectification", "unknown birth time", "rectify birth time", "find rising
  sign", "what's my ascendant", "birth time from events". Low volume, high
  intent, low competition — TrueRise's realistic lane. **[PROPOSED]**
- **Group B — supporting astrology reach (hidden keyword field only):** "natal
  chart", "ascendant", "houses", "zodiac". Adds discoverability without making
  the *listing* read as a horoscope app (4.3(b)). **[PROPOSED]**
- **Group C — too-competitive head terms (DO NOT chase):** "astrology",
  "horoscope", "birth chart", "natal chart" as primary targets. Dominated by
  incumbents; ranking is not realistic for a new single-purpose app. Use only
  as secondary keyword-field tokens, never as the listing's spine. **[PROPOSED]**
- **Group D — blocked / policy-risky (avoid):** "fortune", "psychic",
  "prediction", "future", anything implying guaranteed outcomes. Raises 4.3(b)
  and misleading-claim risk. **[PROPOSED]**

### 6.5 Play short description (≤80)

- `Estimate your unknown birth time from real life events. Private, on-device.`
  (~74). **[PROPOSED]**

### 6.6 Play long description (≤4000) — outline

First ~250 chars carry the hook (Play weights early text):

1. **Hook (first ~250):** the problem (you don't know your exact birth time →
   your rising sign/houses are uncertain) + the promise (TrueRise estimates it
   from life events, with an honest confidence number).
2. **How it works (utility framing):** enter approximate birth data + a few
   dated life events → get candidate times ranked by confidence → "See how we
   got this" evidence view. Emphasize *method/estimate*, never *certainty*.
3. **Privacy block:** on-device storage, no account required, demo mode runs
   fully offline, "Delete all data" in one tap. (Match the hosted policy and
   Data Safety form exactly.)
4. **Who it's for:** people with an unknown/uncertain birth time who want a
   rising sign / accurate houses — framed as a tool, not a horoscope.
5. **Honest-confidence disclaimer:** results are probabilistic estimates, not
   guarantees; no medical, legal, or fortune-telling claims.

### 6.7 Promotional text (iOS, ≤170, updatable without review)

- `An honest, private way to estimate your unknown birth time from the events
  you actually remember.` (~95). **[PROPOSED]**

### 6.8 What still gates the package

Title/keyword finalization depends on the **bundle-ID/name decision** (P0-1/3),
**console character re-count**, and **trademark clearance for "TrueRise"**
(Sec. 12). Do not lock metadata before those resolve. **[VERIFIED dependency]**

---

## 7. Localized publication package plan (DE, FR, PT-BR, ES) — direction only

> **Status: blocked, direction-only.** Localized **listings** depend on the
> product l10n pipeline (Run 4 **G20**) and the Tier 1 translation pass (Run 5
> **G22**), neither of which is built. Sequencing is **Impl Run C** (extract
> base `app_en.arb` + formatting debt G21) → **Impl Run D** (translate
> DE/FR/ES/PT-BR). Do **not** publish a localized listing whose in-app UI is
> still English — that mismatch invites rejection and 1-star "not localized"
> reviews. **[VERIFIED dependency — `docs/l10n-strategy.md`, Run 5]**

### 7.1 Locale priority and brand rule

- **Priority:** DE > FR > ES > PT-BR (Run 5 rationale: market value + BTR
  credibility bar). Portuguese = **PT-BR**. **[ASSUMED — Run 5]**
- **Brand stays English everywhere**; only the **descriptor tail** localizes.
  Pattern: `TrueRise - <localized descriptor>`. **[PROPOSED]**

### 7.2 Per-locale direction (NOT final copy)

| Locale | Descriptor direction | Tone gate | Caution |
| --- | --- | --- | --- |
| **DE** | "Geburtszeit finden/korrigieren" register | **Highest** sobriety bar (W2); avoid proof-words (`Beweis`) | German market is the credibility ceiling — most conservative claims |
| **FR** | "trouver l'heure de naissance" register | Probabilistic; avoid `preuve` | Keep utility framing |
| **ES** | "encontrar tu hora de nacimiento" | Neutral Spanish; decide es-419 split later | Decide neutral vs LatAm |
| **PT-BR** | "descobrir seu horário de nascimento" | Probabilistic | PT-BR only; PT-PT fallback is an owner decision |

Full terminology table (recommended vs avoid forms) lives in
`docs/l10n-strategy.md` §6. **[ASSUMED — Run 5]**

### 7.3 What must be true before any localized listing goes live

1. In-app UI localized for that locale (Impl Run D done). **[VERIFIED gate]**
2. Localized **hosted privacy policy** (or a clearly localized section).
   **[PROPOSED / Legal]**
3. Native-reviewer sign-off on store copy + sensitive-language terms.
   **[PROPOSED]**
4. Per-locale console character re-count (German overflows limits fastest).
   **[PROPOSED]**

---

## 8. Required assets, screenshots, and QA storyboard

### 8.1 Asset checklist

| Asset | Requirement | Status |
| --- | --- | --- |
| App icon (iOS) | 1024² + all sizes, no alpha | **[ASSUMED missing]** |
| App icon (Android) | Adaptive (fore/background) + legacy | **[ASSUMED missing]** |
| iOS screenshots | 6.7" (required) + 6.5"; 5.5" optional; iPad if iPad-enabled | **[VERIFIED missing]** |
| Play screenshots | ≥2 phone (min 320px); 7"/10" tablet if tablet-enabled | **[VERIFIED missing]** |
| Play feature graphic | 1024×500 | **[ASSUMED missing]** |
| Promo/preview video | Optional; skip for v1 | n/a |

### 8.2 Screenshot storyboard (4 frames) — how the app works AND how it spreads

Ordering follows Run 3 §8. Each frame must depict **real, shipped UI**.

1. **Frame 1 — The answer (hero).** `HeroResultCard`: rectified time + "X
   Rising" + the confidence bar. Caption: "Find your real birth time — with an
   honest confidence score." This is the single most persuasive screen and
   leads. **[VERIFIED UI — `result_screen.dart` / `hero_result_card.dart`]**
2. **Frame 2 — The evidence (trust).** The "See how we got this" evidence view
   + alternate candidates. Caption: "See *why*, from your real life events."
   Counters the "is this just astrology?" objection with method. **[VERIFIED UI]**
3. **Frame 3 — Private & offline (utility + 4.3(b)).** Demo pill + Settings
   privacy posture (on-device, Delete all data, demo = no network). Caption:
   "Private by default. Try it offline in Demo mode." Reinforces Utilities
   positioning. **[VERIFIED UI — `settings_screen.dart`, `privacy_policy_screen.dart`]**
4. **Frame 4 — Share the result (spread).** The **"Share result"** button +
   the **OS share sheet** carrying the privacy-safe **text** ("My TrueRise
   rectification result: … · X Rising · NN% confidence … Calculated with
   TrueRise"). Caption: "Share your result — no birth data, ever." This is how
   the product spreads today. **[VERIFIED — `share_copy_builder.dart`,
   `result_screen.dart` `resultShareButtonKey`]**

> **Do not over-claim sharing.** The shipped share is **text only** via the OS
> share sheet (with a clipboard fallback). The privacy-safe **share-card image**
> (Run 4 **G9**) is **not built** (no `share_plus`/screenshot package in
> `pubspec.yaml`). Screenshots and copy must show the **text** share — never
> mock up an Instagram-style image card as if it ships. **[VERIFIED]**

### 8.3 QA storyboard (end-to-end walkthrough to capture)

Capture both paths so reviewers and screenshots reflect reality:

1. Onboarding → New calculation → **birth-date picker** (note: age gate must be
   in place per P0-6 before capture). **[VERIFIED flow]**
2. Approximate time window → life-events entry → confirmation → loading →
   **result** (live path) **or** **Demo mode** result with the DEMO pill.
   **[VERIFIED flow]**
3. Result → "See how we got this" evidence → "Share result" (text share) →
   "Save to history". **[VERIFIED flow]**
4. Settings → API key sheet (never displays the value) → Time format 12/24h →
   **Delete all data** (confirm wipe + return to onboarding) → Privacy screen.
   **[VERIFIED flow]**
5. Capture in **both** 12h and 24h time formats; verify no "Rectify" string is
   visible once P0-1 lands (title, Settings version, privacy copy). **[VERIFIED]**

---

## 9. Policy risk analysis and mitigation language

### 9.1 Apple Guideline 4.3(b) — astrology/fortune-telling saturation

- **Risk [ASSUMED — Run 2]:** Apple names fortune-telling/astrology as a
  saturated, rejection-prone category; disclaimers do **not** cure a 4.3
  rejection. The only known mobile-native BTR app (Vedic Samay) ships under
  **Utilities** — the working precedent.
- **Mitigation:**
  1. **Category = Utilities (iOS) / Tools (Play).** **[PROPOSED]**
  2. **Frame as a calculation tool, not a horoscope.** Listing copy leads with
     *estimate / method / confidence*, not *prediction / destiny / fortune*.
  3. **No Group D terms** ("fortune", "psychic", "prediction", "future").
  4. **Single, honest job:** "estimate your unknown birth time from life
     events" — narrow utility reads as a tool, not entertainment astrology.

### 9.2 Honest-confidence / no-guarantee copy (misleading-claims risk)

- Always present results as **probabilistic estimates with a confidence
  number**, never as certainty. The app already does this (confidence bar,
  "candidates"). Listing + policy copy must match. **[VERIFIED in-app basis]**
- **Avoid** proof/guarantee words in every locale (EN "proof/guaranteed", DE
  "Beweis", FR "preuve"). **[ASSUMED — Run 5 §6]**
- No medical, legal, or financial advice framing.

### 9.3 Privacy & data collection (Apple 5.1.1/5.1.2; Play Data Safety)

- **The real, [VERIFIED] data flow** (live mode): birth date (year/month/day),
  birth-time estimate (hour/minute), **precise birthplace coordinates**
  (latitude/longitude), and **free-text life-event descriptions** are POSTed to
  the third-party provider (`rectification_request_dto.dart`). Demo mode sends
  nothing.
- **Mitigation / required actions:**
  1. **Disclose third-party transmission** in the hosted policy, the Apple
     privacy labels, and the Play Data Safety form. Name the provider and its
     data handling. **[VERIFIED requirement]**
  2. **Update the in-app privacy copy** so it does not read as "everything
     stays on device" without also stating that a **live** calculation sends
     birth data + events to the provider (demo does not). Today's copy
     under-discloses this. **[VERIFIED gap — `privacy_policy_screen.dart`]**
  3. **Treat life-event free text + precise location as sensitive** in both
     stores' forms. **[VERIFIED]**
  4. **No tracking** declaration is honest today (no analytics SDK) — keep it
     honest if analytics is added later (Run 4 G13). **[VERIFIED]**

### 9.4 Children / age (COPPA + store age policies)

- **Gap [VERIFIED]:** no minimum-age floor on the birth-date picker
  (`birth_data_screen.dart`), despite PRD's COPPA age-gate requirement.
- **Mitigation:** add the age gate (P0-6), declare an **adult** target audience
  on Play, and answer Apple's age rating consistently. **[PROPOSED]**

### 9.5 Release-integrity / key-handling risk

- **Debug-signed release [VERIFIED]:** must be replaced (P0-2) — also a trust
  signal in review.
- **Bundled `.env` demo key [VERIFIED]:** recoverable from the binary
  (`README.md`). Rotate to a **low-budget, capped** key before the public build;
  confirm the exposure is acceptable for review and that the demo path
  (offline) is what reviewers are guided to use. **[PROPOSED]**

### 9.6 Suggested reviewer-facing language (paste into review notes)

> "TrueRise is a **utility** that estimates an unknown birth time from
> user-entered life events and returns time candidates with an **honest
> confidence score** — it is not a horoscope or fortune-telling app. To review
> without using live API credits, enable **Demo mode** (Settings → Demo mode),
> which runs entirely **offline**; demo results are labeled with a DEMO pill.
> In live mode, birth data and event dates are sent over HTTPS to our astrology
> calculation provider solely to compute the result; see our privacy policy at
> [URL]. The app stores data on-device only, has no user accounts, and offers a
> one-tap 'Delete all data'." **[PROPOSED]**

---

## 10. Release sequencing and ownership

> Ownership labels are **tracks**, not named individuals (this run does not
> assert who the owner is). Owner decisions that gate these tracks are in
> Sec. 12.

### 10.1 Critical path

```
Impl Run A  ──►  Privacy URL  ──►  Metadata + Screenshots  ──►  Internal test  ──►  Submit EN Tier 0
(config gate)    (hosting)        (Sec. 6 + Sec. 8)            (both stores)       (Utilities/Tools)
     │
     └─ depends on owner decisions: bundle-ID, age cutoff, demo-key rotation
```

### 10.2 Stage detail

1. **Impl Run A — Config & compliance gate (engineering).** Display name →
   TrueRise (Info.plist, AndroidManifest, in-app title, Settings version,
   privacy copy); **bundle-ID decision** applied; **release signing**
   (keystore + iOS distribution); **age gate**; **app icon**; update in-app
   privacy copy to disclose live transmission (Sec. 9.3). *Gates everything.*
   **[PROPOSED]**
2. **Hosted privacy policy (owner + Legal).** Stand up a reachable URL that
   accurately describes the third-party transmission, on-device storage, demo
   mode, deletion, and the optional user key. Can proceed in parallel with
   Run A. **[PROPOSED]**
3. **Metadata + screenshots (owner + design).** Finalize Sec. 6 package
   (post-trademark/console re-count); capture Sec. 8 storyboard from the
   **post-Run-A** build (so no "Rectify" leaks). **[PROPOSED]**
4. **Privacy/Data-Safety forms (owner + Legal).** Author Apple labels + Play
   Data Safety to match Sec. 9.3. **[PROPOSED]**
5. **Internal testing (engineering).** TestFlight internal + Play
   internal-testing track; run Play pre-launch report in **Demo mode**;
   on-device smoke on a real iOS + Android device (deferred in Phase 8).
   **[PROPOSED]**
6. **Submit English Tier 0** under Utilities/Tools with the reviewer notes from
   Sec. 9.6. **[PROPOSED]**
7. **Localized listings (later).** Only after **Impl Run C → Run D**
   (`docs/l10n-strategy.md`). Not on the first-submission critical path.
   **[VERIFIED gate]**

### 10.3 Parallelizable vs blocking

- **Blocking (must precede submit):** Impl Run A, hosted privacy URL,
  privacy/Data-Safety forms, metadata, screenshots, real-device smoke.
- **Parallel with Run A:** privacy-URL hosting, icon design, copy drafting.
- **Off critical path:** share-card image (G9, V1.5), analytics (G13),
  localized listings (G20/G22).

---

## 11. Verification checklist and commands

### 11.1 Pre-submission engineering verification (run locally)

```bash
# Static analysis + full test suite (touches shared models/routing/persistence)
flutter analyze
flutter test
flutter test integration_test/demo_flow_test.dart

# Confirm the public name is applied (expect TrueRise; expect NO stray 'Rectify' in user-facing UI)
#   iOS:     CFBundleDisplayName -> TrueRise
#   Android: android:label       -> TrueRise
#   in-app:  app title, Settings version row, privacy copy

# Confirm release is NOT debug-signed (Android)
#   android/app/build.gradle.kts release buildType must use a real upload key

# Build the shippable artifacts
flutter build ipa            # iOS (with distribution signing configured)
flutter build appbundle      # Android AAB (with upload keystore configured)
```

### 11.2 Listing/compliance verification (manual, in-console)

- [ ] Hosted privacy-policy URL returns 200 and matches in-app + Data-Safety
      claims (incl. third-party transmission). **[P0-4/P0-5]**
- [ ] Apple App Privacy labels authored; Play Data Safety form authored; both
      declare location + sensitive free-text + birth data **shared** with the
      provider in live mode; both declare **no tracking**. **[P0-5]**
- [ ] Age gate present in build; store age ratings consistent. **[P0-6]**
- [ ] App icon present (no default glyph). **[P0-7]**
- [ ] Title/subtitle/keyword/description char counts re-counted in console.
      **[P0-8]**
- [ ] Screenshots captured for required device classes from a **post-Run-A**
      build. **[P0-9]**
- [ ] Category = Utilities (iOS) / Tools (Play). **[P0-10]**
- [ ] Demo/review key rotated to a low-budget capped key; reviewer notes point
      to offline Demo mode. **[P0-11]**
- [ ] Trademark clearance + App Store name availability for "TrueRise"
      confirmed before locking the listing. **[Sec. 12]**

### 11.3 This document's own verification (Run 6, doc-only)

```bash
git status --short
git diff --stat
git status --short -- lib ios android test integration_test pubspec.yaml assets l10n.yaml
grep -nE '^## ' docs/store-submission-readiness.md   # confirm all 12 sections
```

Expected: only `docs/store-submission-readiness.md` (new) and
`docs/claude-build-history.md` (Run 6 entry appended) changed; the scoped
`git status` for app code paths returns **empty**. Results are reported in the
closing summary.

---

## 12. Open owner decisions and source evidence appendix

### 12.1 Owner decisions (gate submission — not decidable from code)

1. **Bundle ID:** keep `com.rectify.rectify` or rebrand to `com.truerise.*`?
   *Irreversible after first publish.* **[decision]**
2. **Age-gate cutoff & store age rating:** PRD says "born before 2008"; confirm
   the exact floor and the resulting iOS/Play age rating. **[decision]**
3. **Hosted privacy-policy ownership + content:** who hosts, and confirm it
   names the **third-party provider** and its data retention. **[decision/Legal]**
4. **Demo/review key:** rotate to a low-budget capped key; confirm `.env`
   in-binary exposure is acceptable for review. **[decision]**
5. **Trademark clearance + App Store name availability for "TrueRise."**
   Not asserted here — must be cleared before locking metadata. **[decision]**
6. **Category confirmation:** Utilities (iOS) / Tools (Play). **[decision]**
7. **Device matrix:** is iPad / Android tablet a target (affects screenshot
   sets + landscape QA)? **[decision]**
8. **Localized-listing go/no-go + sequencing** after Impl Run C/D, and PT-BR-only
   vs PT-PT fallback, German du/Sie, ES neutral vs es-419. **[decision — Run 5]**
9. **In-app privacy-copy update scope:** confirm Impl Run A also revises the
   privacy screen to disclose live transmission (Sec. 9.3). **[decision]**

### 12.2 Source evidence appendix (read this run, read-only)

| Claim | Source | Label |
| --- | --- | --- |
| iOS display name = Rectify; no usage strings; no ATS | `ios/Runner/Info.plist` | VERIFIED |
| Android label = rectify; only INTERNET permission | `android/app/src/main/AndroidManifest.xml` | VERIFIED |
| Release debug-signed; appId `com.rectify.rectify` | `android/app/build.gradle.kts` | VERIFIED |
| `name: rectify`; placeholder description; no url_launcher/share_plus/analytics/flutter_localizations; `objective_c` pin; `.env` asset | `pubspec.yaml` | VERIFIED |
| TrueRise = brand, rectify = codename; debug signing; live HTTPS endpoint; demo `.env` key recoverable | `README.md` | VERIFIED |
| Share is text-only, PII-free (time/ascendant/confidence only) | `lib/core/sharing/share_copy_builder.dart` | VERIFIED |
| Share via OS sheet + clipboard fallback | `lib/core/sharing/share_service.dart` | VERIFIED |
| In-app privacy screen (not hosted); "Rectify" brand leak; "on-device" framing; no analytics | `lib/features/settings/privacy_policy_screen.dart` | VERIFIED |
| Settings: API key never shown, demo toggle, 12/24h, delete-all, privacy row, "Rectify v1.0.0" | `lib/features/settings/settings_screen.dart` (`:157`) | VERIFIED |
| Result UI: hero/confidence/candidates/evidence/share/save/demo-nudge; `resultShareButtonKey` | `lib/features/calculation_flow/screens/result_screen.dart` | VERIFIED |
| Live request sends birth date/time, **lat/long**, and **free-text** life events to provider | `lib/data/api/dto/rectification_request_dto.dart` | VERIFIED |
| No age-gate floor (firstDate 1920, lastDate now) | `lib/features/calculation_flow/screens/birth_data_screen.dart` | VERIFIED |
| Default icon; deferred blockers; 177(+1) tests; merged-AAB DUMP perm | `docs/qa-phase8-report.md` | ASSUMED (2026-05-20) |
| Gap IDs G1–G24; share-card image = V1.5; analytics greenfield | `docs/feature-gap-analysis.md` | ASSUMED (Run 4) |
| Naming, category, keyword groups, screenshot order, metadata options | `docs/aso-naming-strategy.md` | ASSUMED (Run 3) |
| Vedic Samay = Utilities precedent; 4.3(b) saturation; locale vocab | `docs/competitor-aso-research.md` | ASSUMED (Run 2) |
| No l10n pipeline; locale priority; tone gates; G20/G22 sequencing | `docs/l10n-strategy.md`, `docs/l10n-string-audit.md` | VERIFIED/ASSUMED (Run 5) |
| PRD privacy/COPPA/age-gate stance; 4.3(b) risk noted | `docs/prd.md` | ASSUMED |
| MVP deferrals (IAP, export, Vedic/KP, share card) | `docs/mvp-scope.md` | ASSUMED |

**Constraints respected this run:** documentation only; no app code, config,
assets, screenshots, generated files, tests, `pubspec.yaml`, `ios/`, `android/`,
`lib/`, `integration_test/`, or l10n files were modified. Listed source/config
files were **read only** for evidence. No live store rankings, install counts,
ratings, review quotes, trademark clearance, or store approvals were invented;
absent evidence is stated as absent. Every load-bearing claim is labeled
VERIFIED / ASSUMED / PROPOSED.
