# Store Submission Readiness — TrueRise (codename `rectify`)

**Run 6 · 2026-06-02 · model `claude-opus-4-8` · documentation-only planning run.**

> ## Current status as of 2026-06-03 — Impl Run E.1 (reconciliation)
>
> **The body of this document below is the 2026-06-02 (Run 6) baseline and is
> preserved as historical evidence.** Since then, Impl Runs A.1–A.5, C.1, and
> D.1–D.4 have landed. The authoritative current readiness view — including a
> per-blocker reconciliation and the next-action ordering — is
> **`docs/publication-readiness-current-status.md`**. Status deltas to §3 below:
>
> - **Resolved in-repo (supersedes the §3 / §2 "gap / absent / placeholder"
>   prose):** **P0-1** display name = TrueRise (`Info.plist`,
>   `AndroidManifest.xml`, `l10n.dart appBrandName`); **P0-6** 18+ age gate
>   (`birth_data_screen.dart`); **P0-7** app icon (iOS appiconset + Android
>   adaptive); **P0-8** store metadata (`docs/store-listing-en.md`, real
>   `pubspec` description); **P0-9** screenshots
>   (`screenshots/store/{en,de,fr,es,pt-BR}/`, raw).
> - **Authored, owner remainder:** **P0-4** privacy-policy content
>   (`docs/privacy-policy.md`) + app wiring **[DONE 2026-06-12]**: the
>   `TRUERISE_PRIVACY_POLICY_URL` public dart-define opens from Settings via
>   `url_launcher` (`LaunchMode.inAppBrowserView`), with fallback to the
>   in-app `PrivacyPolicyScreen` on empty default, unsafe URL, or launch
>   failure — owner hosting of the canonical public URL + legal sign-off
>   still pending;
>   **P0-5** Apple/Play forms (`docs/apple-privacy-labels.md`,
>   `docs/play-data-safety.md`) — console entry + legal sign-off still pending.
> - **Still owner-gated:** **P0-2** release signing (Android gradle wiring
>   done 2026-06-12: debug-signing fallback removed, release reads
>   `android/key.properties`; owner upload keystore + Play App Signing
>   enrollment + iOS distribution signing still pending), **P0-3** bundle-ID
>   decision, **P0-10** category confirm, **P0-11** demo-key rotation.
> - **Post-Appeeky category delta (2026-06-15):** **P0-10** current recommendation is **Lifestyle** on both the App Store and Google Play (`docs/store-listing-en.md` §1/§3.4; `docs/publication-readiness-current-status.md` P0-10). The older Utilities/Tools posture below is historical/superseded context, not the current console instruction.
> - **Shipped since this baseline (2026-06-12):** the privacy-safe
>   **share-card image** (Run 4 G9). This supersedes the baseline's "text
>   only / G9 not built / no `share_plus`" statements in §1, §2.3, §3, §8.2,
>   §10.3, and the §13 evidence rows: `share_plus` is now a dependency,
>   `lib/core/sharing/story_card_renderer.dart` renders the PNG story card,
>   and `ShareService.shareImagePng` shares it from the result screen
>   (`resultShareImageButtonKey`). Text and image share both carry only the
>   privacy-safe allow-list (time, rising when present, confidence, brand,
>   public share URL/caption). Direct Instagram Stories posting remains
>   optional / out of scope until a Meta/Facebook App ID exists.
> - **Still true:** the build is **not submittable today** — but the open
>   blockers are now owner/secret/legal/console items, not engineering artifacts.
> - **Removed since this baseline:** the optional bring-your-own
>   provider-credential entry has been taken out — its row no longer appears in
>   **Settings**, and the matching section was removed from the in-app **Privacy**
>   screen and from `docs/privacy-policy.md`. Live calculations still run;
>   provider credentials are simply no longer user-facing. The §2.1, §8.3, and
>   §12.2 entries below have been brought in line with the simplified Settings and
>   Privacy surfaces.
>
> The §6 ASO drafts are finalized in `docs/store-listing-en.md`; the §7 localized
> plan is realized in `docs/store-listing-tier1-localized.md` + the localized
> ARBs/screenshots. Re-read those for the current copy.

---

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

1. **Public-name mismatch — resolved in-repo (2026-06).** The display name is
   now **TrueRise** on both platforms (iOS `CFBundleDisplayName`, Android
   `android:label`) and in the in-app strings; store-name/trademark
   confirmation remains owner scope. *(Historical, original audit: the binary
   showed *Rectify* — iOS `CFBundleDisplayName=Rectify`, Android
   `android:label="rectify"` — and "Rectify" was baked into the in-app title,
   the Settings version row, and the privacy copy, while the brand, README,
   and share copy said TrueRise.)*
2. **Release signing.** The Android debug-signing fallback has been removed
   (2026-06-12): `android/app/build.gradle.kts` release now requires a
   complete `android/key.properties` + keystore and fails clearly without
   one. The remaining blockers are owner-side: upload keystore, Play App
   Signing enrollment, iOS distribution signing. *(Historical, original
   audit: release shipped with `signingConfig =
   signingConfigs.getByName("debug")`; a debug-signed AAB cannot go to Play
   production.)*
3. **No owner-hosted privacy-policy URL.** App wiring is done (2026-06-12):
   the `TRUERISE_PRIVACY_POLICY_URL` public dart-define opens from Settings
   via `url_launcher` (`LaunchMode.inAppBrowserView`), falling back to the
   in-app `PrivacyPolicyScreen` on empty default, unsafe URL, or launch
   failure. The owner-hosted canonical public URL is still absent; both
   stores require a reachable URL in the listing, and the same URL must be
   used in the build define and the store listings.
4. **Store privacy/data-safety form drafts are authored
   (`docs/apple-privacy-labels.md`, `docs/play-data-safety.md`); in-app copy
   is accurate.** In live mode the app transmits birth date, a birth-time
   estimate, precise birthplace latitude/longitude, and free-text life-event
   descriptions to a third-party API; demo mode stays offline, and no
   analytics/tracking SDKs are bundled. The in-app privacy copy discloses
   this live transmission in-repo (`privacy_policy_screen.dart` renders
   `privacyLiveTitle`/`privacyLiveBody` across EN/DE/ES/FR/PT). Owner/legal
   must still review/sign off on the drafts and enter the Apple privacy
   labels and Play Data Safety form in App Store Connect / Play Console.
5. **Age gate — resolved in-repo (2026-06).** The birth-date picker enforces an
   18+ floor (`lastDate: CalculationFlowState.latestAllowedBirthDate(now)`);
   the store age-rating questionnaire remains owner/console. *(Historical,
   original audit: the picker accepted any date from 1920 to today with no
   minimum-age floor.)*
6. **Default app icon — resolved in-repo (2026-06).** Real icon assets landed
   (iOS appiconset + Android adaptive icon). *(Historical, original audit: the
   build used the stock Flutter glyph.)*
7. **Store metadata + screenshots exist in-repo; console work remains.**
   Listing copy exists (`docs/store-listing-en.md`,
   `docs/store-listing-tier1-localized.md`) and raw screenshots are captured
   (`screenshots/store/{en,de,fr,es,pt-BR}/`); console entry, screenshot
   compositing, and upload remain owner scope.
8. **Localized listings are prepared in-repo** (l10n pipeline + localized ARBs
   + `docs/store-listing-tier1-localized.md`); native-speaker review and
   per-locale console character recount/upload remain. First submission can
   still be English Tier 0 if the owner prefers.

**Recommendation:** the repo-side work is prepared — config and compliance
changes (name, release signing guard, icon, age gate), English and localized
listing copy (`docs/store-listing-en.md`, `docs/store-listing-tier1-localized.md`),
and raw 6.7" screenshots for all five locales (`screenshots/store/`). Submission
is now gated by owner/secret/legal/console work: bundle-ID/name approval,
production proxy + share/privacy URLs, signing material, store forms, and
console upload. If the owner prefers, submit **English Tier 0 first** under **Lifestyle** on both the App Store and Google Play (current post-Appeeky recommendation; see `docs/store-listing-en.md` §1/§3.4 and `docs/publication-readiness-current-status.md` P0-10), with localized publication following native-speaker review and per-locale console recount/upload. This document specifies each step, labels every claim, and ends
with the owner decisions that gate submission.

---

## 2. Current verified app and store readiness state

### 2.1 What is real today

| Area | State | Evidence |
| --- | --- | --- |
| App completeness | MVP feature-complete; 177 tests + 1 integration green | `docs/qa-phase8-report.md` (2026-05-20) **[ASSUMED — not re-run this run]** |
| Live calculation | Real path to third-party API; demo path fully offline | `lib/data/api/dto/rectification_request_dto.dart`, `lib/features/settings/settings_screen.dart` demo toggle **[VERIFIED]** |
| Result UX | Hero time + rising + confidence, ≤2 alt candidates, evidence screen, demo pill, demo upgrade nudge | `lib/features/calculation_flow/screens/result_screen.dart` **[VERIFIED]** |
| Sharing | **Text** share and **image (story-card PNG)** share via `share_plus`, both PII-free by construction; OS share sheet w/ clipboard fallback for text | `lib/core/sharing/share_copy_builder.dart`, `lib/core/sharing/story_card_renderer.dart`, `lib/core/sharing/share_service.dart` (`shareImagePng`), result screen `resultShareImageButtonKey` **[VERIFIED]** |
| Privacy posture | On-device storage, no accounts, "Delete all data" | `lib/features/settings/privacy_policy_screen.dart`, `settings_screen.dart` **[VERIFIED]** |
| Analytics / crash reporting | **None wired** (no analytics SDK, no crash reporting) | `pubspec.yaml` (no firebase/sentry/posthog/amplitude); privacy screen text **[VERIFIED]** |
| iOS platform config | `CFBundleDisplayName=TrueRise` (2026-06; was `Rectify` at original audit), `CFBundleName=rectify`; no `NS*UsageDescription`; no ATS block; portrait+landscape | `ios/Runner/Info.plist` **[VERIFIED]** |
| Android platform config | `android:label="TrueRise"` (2026-06; was `rectify` at original audit); only `INTERNET` permission; release signing requires owner `android/key.properties` (debug-signing fallback removed 2026-06-12; was debug-signed at original audit) | `android/app/src/main/AndroidManifest.xml`, `android/app/build.gradle.kts` **[VERIFIED]** |
| Bundle identity | `namespace` + `applicationId` = `com.rectify.rectify`; version `1.0.0+1` | `android/app/build.gradle.kts`, `pubspec.yaml` **[VERIFIED]** |
| App icon | Real icon assets in repo (2026-06): iOS appiconset incl. 1024² + Android adaptive icon; was stock Flutter glyph at original audit | `ios/Runner/Assets.xcassets/AppIcon.appiconset/`, `android/app/src/main/res/mipmap-*` **[VERIFIED]** |
| Localization | l10n pipeline in repo (`l10n.yaml`, `flutter gen-l10n` via `pubspec.yaml`) with EN/DE/ES/FR/PT ARBs + generated `AppLocalizations`; native-speaker review and per-locale console character recount remain owner scope | `l10n.yaml`, `pubspec.yaml`, `lib/l10n/app_{en,de,es,fr,pt}.arb` **[VERIFIED 2026-06]** |
| Demo/review key | `.env` bundled as an asset; key recoverable from the binary | `pubspec.yaml` assets, `README.md` **[VERIFIED]** |
| Build pin | `dependency_overrides: objective_c: 9.3.0` (build-hook regression workaround) | `pubspec.yaml` **[VERIFIED]** |

### 2.2 What does NOT exist yet (store-facing)

- Owner-hosted public privacy-policy URL. **[absent — owner hosting pending;
  app wiring done 2026-06-12 via `TRUERISE_PRIVACY_POLICY_URL` +
  `url_launcher`, with in-app `PrivacyPolicyScreen` fallback]**
- Apple App Privacy ("nutrition label") answers and Play Data Safety form.
  **[VERIFIED — not authored]**
- Final listing metadata in the consoles. **[Updated 2026-06 — EN listing
  (`docs/store-listing-en.md`) + localized listings
  (`docs/store-listing-tier1-localized.md`) exist in repo; console character
  recount, trademark confirmation, and native-speaker review remain]**
- Final screenshot assets. **[Updated 2026-06 — raw screenshots exist in
  `screenshots/store/{en,de,fr,es,pt-BR}/` (five 6.7" frames per locale);
  device-frame/caption compositing, other device sizes, and console upload
  remain]**
- Release signing keystore/profile (Android) and a distribution provisioning
  setup (iOS). **[Android: gradle wiring done 2026-06-12 (debug fallback
  removed) — owner upload keystore still missing; iOS signing not in repo]**
- Real app icon + adaptive icon. **[Resolved 2026-06 — iOS appiconset +
  Android adaptive icon in repo]**
- Localized listings (DE/FR/ES/PT-BR) in the consoles. **[Updated 2026-06 —
  in-repo via `docs/store-listing-tier1-localized.md`; native-speaker review
  and per-locale console character recount remain]**

### 2.3 What is explicitly out of scope for first submission

Per `docs/mvp-scope.md` and `CLAUDE.md`: payments/IAP/paywalls, accounts/sync,
dark mode, chart rendering, PDF/report export, Vedic/KP toggles, and any
analytics SDK. None of these are submission blockers; do **not** pull them
forward to unblock the store. **[VERIFIED scope]** **[Updated 2026-06-12 —
the privacy-safe share-card image (Run 4 G9), listed here at baseline as a
deferred V1.5 growth lever, has since shipped in-repo (`share_plus` +
`StoryCardRenderer` + `shareImagePng`); it is no longer deferred and needs no
store-side action. See the status note at the top of this document.]**

---

## 3. Blocking pre-submission checklist (P0)

Each item below blocks first submission. ID maps to Run 4
(`docs/feature-gap-analysis.md`) where applicable.

| # | Blocker | Gap | Evidence | Fix owner-track |
| --- | --- | --- | --- | --- |
| P0-1 | **Public display name = TrueRise** across iOS `CFBundleDisplayName`, Android `android:label`, in-app title, Settings version row, privacy copy | G1 | **[DONE 2026-06]**: `Info.plist` and `AndroidManifest.xml` now carry TrueRise; in-app strings brand via `l10n.dart appBrandName`. *(Original audit: "Rectify  v1.0.0" at `settings_screen.dart:157`, "What Rectify stores" in `privacy_policy_screen.dart`.)* Store-name/trademark confirmation remains owner scope | Impl Run A **[done]** + owner name confirm |
| P0-2 | **Release signing** — generate upload keystore (Android) + distribution signing (iOS); Android debug-signing fallback already removed | G5 | Android wiring **[DONE 2026-06-12]**: `build.gradle.kts` release reads `android/key.properties` (validates `storePassword`/`keyPassword`/`keyAlias`/`storeFile`; absolute or `android/`-relative path; no debug fallback; release tasks fail with instructions when missing). Owner upload keystore + Play App Signing + iOS distribution signing still pending | Impl Run A + owner secrets |
| P0-3 | **Bundle-ID decision** — current ID is `com.rectify.rectify`; recommendation is `app.astrolium.truerise` (primary, `docs/bundle-id-recommendation.md`), to be decided **before first publish** (irreversible after) | G5 | `build.gradle.kts` `applicationId` **[VERIFIED]** | Owner decision (Sec. 12) → Impl Run A |
| P0-4 | **Hosted privacy-policy URL** reachable + linked in both listings | G2 | App wiring **[DONE 2026-06-12]**: `TRUERISE_PRIVACY_POLICY_URL` public dart-define; valid bare HTTPS URL opens from Settings via `url_launcher` (`LaunchMode.inAppBrowserView`); empty default / unsafe URL / launch failure falls back to in-app `PrivacyPolicyScreen`. Owner-hosted canonical public URL still pending; same URL must go into build define + store listings | Owner hosting + Legal |
| P0-5 | **Apple App Privacy labels + Play Data Safety** authored to match real data flow (incl. third-party transmission of birth data + life-event text + precise location in live mode) | G3 | `rectification_request_dto.dart` fields; `pubspec.yaml` (no analytics) **[VERIFIED]** | Owner + Legal (Sec. 4/5/9) |
| P0-6 | **Age gate / age rating** — in-app 18+ gate **[DONE 2026-06]**: birth-date picker `lastDate` uses `CalculationFlowState.latestAllowedBirthDate(now)` (`birth_data_screen.dart`; logic in `calculation_flow_state.dart`). Remaining owner action: complete the store age-rating questionnaire consistent with the 18+ gate | G6 | Picker floor wired in `birth_data_screen.dart`; age-gate (18+) tests in `test/features/calculation_flow/calculation_flow_controller_test.dart` **[VERIFIED present]** | Owner store age-rating questionnaire |
| P0-7 | **Real app icon** (iOS + Android adaptive) | G4 | **[DONE 2026-06]**: `ios/Runner/Assets.xcassets/AppIcon.appiconset/` + Android adaptive icon (`mipmap-*`) in repo. *(Original audit assumed the default glyph per `docs/qa-phase8-report.md` §6.)* Store icon review at submission remains | Impl Run A **[done]** |
| P0-8 | **Store metadata finalized** (title/subtitle/keywords/descriptions) | G7 | **[DONE in-repo 2026-06]**: `docs/store-listing-en.md` + `docs/store-listing-tier1-localized.md`; real `pubspec` description. Remaining owner scope: console character recount, trademark confirmation, native-speaker review | Owner console entry |
| P0-9 | **Screenshot set** captured for required device classes | G8 | **[DONE in-repo 2026-06 — raw]**: `screenshots/store/{en,de,fr,es,pt-BR}/`, five 6.7" frames per locale. Remaining design/owner scope: device-frame/caption compositing, other device sizes, console upload | Design compositing + owner upload |
| P0-10 | **Category positioning** confirmed: **Lifestyle** on both the App Store and Google Play (current post-Appeeky recommendation; older Utilities/Tools rationale is superseded historical context) | — | `docs/store-listing-en.md` §1/§3.4; `docs/publication-readiness-current-status.md` P0-10 | Owner confirm (Sec. 9) |
| P0-11 | **Demo/review key hygiene** — rotate to a low-budget capped key before public build; confirm `.env` exposure is acceptable for review | — | `README.md`, `pubspec.yaml` `.env` asset **[VERIFIED]** | Owner key rotation |

**Not P0 (do not block on these):** analytics SDK (G13, greenfield), localized
publication/review/upload
(G20/G22 artifacts are prepared in repo — localized ARBs, listing copy, raw
screenshots — so only native-speaker review and console work remain, and none
of it blocks an English Tier 0 submission). The privacy-safe share-card image
(G9), listed here at baseline as deferred V1.5, has since shipped in-repo
(2026-06-12) and needs no store-side action.

---

## 4. iOS App Store readiness

### 4.1 Binary / Xcode configuration

- **Display name.** `CFBundleDisplayName` is now **TrueRise** (2026-06; was
  `Rectify` at original audit). `CFBundleName` is still `rectify` — the short
  internal name, less user-visible; align it for consistency if desired.
  **[VERIFIED — resolved]**
- **Bundle identifier.** Currently `com.rectify.rectify`; recommended rebrand
  is `app.astrolium.truerise` (`docs/bundle-id-recommendation.md`). Decide
  **before** the first App Store Connect record exists — the bundle ID is
  immutable post-creation. **[VERIFIED / owner decision]**
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
- **Privacy policy URL.** Required field — still blocked on the owner-hosted
  canonical URL (P0-4); app wiring is done (`TRUERISE_PRIVACY_POLICY_URL` +
  in-app fallback, 2026-06-12). Use the same URL here as in the build define.
  **[VERIFIED]**
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

- **Application label.** `android:label` is now **TrueRise** (2026-06; was
  `rectify` at original audit). **[VERIFIED — resolved]**
- **Application ID.** `com.rectify.rectify`; same immutability caveat as iOS —
  decide before first upload. **[VERIFIED / owner decision]**
- **Release signing.** Gradle wiring done 2026-06-12: debug-signing fallback
  removed; release requires owner `android/key.properties` + keystore.
  Remaining: provide the real upload key and enroll in Play App Signing.
  **A debug-signed AAB will be rejected from production.**
  **[VERIFIED P0 — owner half pending]**
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
- **Privacy policy URL.** Required — still blocked on the owner-hosted
  canonical URL (P0-4); app wiring is done (`TRUERISE_PRIVACY_POLICY_URL` +
  in-app fallback, 2026-06-12). Use the same URL here as in the build define.
  **[VERIFIED]**
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

## 7. Localized publication package plan (DE, FR, PT-BR, ES)

> **Status: prepared in-repo, draft-ready.** The localized publication package
> exists: localized listing copy in `docs/store-listing-tier1-localized.md`
> and a working l10n pipeline with DE/FR/ES/PT ARBs
> (`lib/l10n/app_{de,es,fr,pt}.arb`). Do **not** publish locales until
> native-speaker review, the per-locale console character recount, and
> UI/listing consistency are verified — a localized listing over a mismatched
> in-app UI invites rejection and 1-star "not localized" reviews.
> **[VERIFIED 2026-06]**

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
| App icon (iOS) | 1024² + all sizes, no alpha | **[in repo 2026-06 — `AppIcon.appiconset` incl. 1024²; verify no-alpha at submission]** |
| App icon (Android) | Adaptive (fore/background) + legacy | **[in repo 2026-06 — adaptive `mipmap-anydpi-v26` + fore/background + legacy `ic_launcher.png`]** |
| iOS screenshots | 6.7" (required) + 6.5"; 5.5" optional; iPad if iPad-enabled | **[raw 6.7" captures in repo 2026-06 — `screenshots/store/{en,de,fr,es,pt-BR}/`; device-frame/caption compositing, 6.5" set, and console upload remain]** |
| Play screenshots | ≥2 phone (min 320px); 7"/10" tablet if tablet-enabled | **[raw phone captures in repo 2026-06 — same 6.7" set; compositing, tablet sizes (if tablet-enabled), and console upload remain]** |
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

> **Sharing status (updated 2026-06-12).** The app now ships **both** share
> surfaces: the privacy-safe **text** share (OS share sheet, clipboard
> fallback) **and** the privacy-safe **share-card image** (Run 4 **G9**) —
> `share_plus` + `StoryCardRenderer` render a PNG story card shared from the
> result screen (`resultShareImageButtonKey`). Both surfaces carry only the
> allow-list: time, rising when present, confidence, brand, and the public
> share URL/caption. Screenshots and copy may show either surface, but must
> depict only real, shipped UI — do not mock up direct Instagram Stories
> posting (optional, out of scope until a Meta/Facebook App ID exists) or any
> share content beyond the allow-list. **[VERIFIED in-repo]**

### 8.3 QA storyboard (end-to-end walkthrough to capture)

Capture both paths so reviewers and screenshots reflect reality:

1. Onboarding → New calculation → **birth-date picker** (note: age gate must be
   in place per P0-6 before capture). **[VERIFIED flow]**
2. Approximate time window → life-events entry → confirmation → loading →
   **result** (live path) **or** **Demo mode** result with the DEMO pill.
   **[VERIFIED flow]**
3. Result → "See how we got this" evidence → "Share result" (text share) →
   "Save to history". **[VERIFIED flow]**
4. Settings → Time format 12/24h → **Delete all data** (confirm wipe + return
   to onboarding) → Privacy screen. **[VERIFIED flow]**
5. Capture in **both** 12h and 24h time formats; P0-1 (TrueRise rename) has
   **landed** — verify no legacy "Rectify" string remains in any captured
   surface (title, Settings version, privacy copy). **[VERIFIED]**

---

## 9. Policy risk analysis and mitigation language

### 9.1 Apple Guideline 4.3(b) — astrology/fortune-telling saturation

- **Risk [ASSUMED — Run 2]:** Apple names fortune-telling/astrology as a
  saturated, rejection-prone category; disclaimers do **not** cure a 4.3
  rejection. The only known mobile-native BTR app (Vedic Samay) ships under
  **Utilities** — the working precedent.
- **Mitigation:**
  1. **Category = Lifestyle on both the App Store and Google Play (current post-Appeeky recommendation).** The earlier Utilities/Tools category mitigation is superseded historical context; keep the calculator-style copy discipline.
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
  2. **In-app privacy copy is updated** — `privacyLiveBody` (EN/DE/ES/FR/PT
     ARBs, rendered by `privacy_policy_screen.dart`) states that a **live**
     calculation sends birth data + events to the provider over HTTPS (demo
     does not). Remaining: hosted policy, store forms, and owner/legal
     confirmation of provider handling/retention. **[VERIFIED in-repo]**
  3. **Treat life-event free text + precise location as sensitive** in both
     stores' forms. **[VERIFIED]**
  4. **No tracking** declaration is honest today (no analytics SDK) — keep it
     honest if analytics is added later (Run 4 G13). **[VERIFIED]**

### 9.4 Children / age (COPPA + store age policies)

- **Resolved in-repo [VERIFIED, 2026-06]:** the birth-date picker enforces an
  18+ floor via `CalculationFlowState.latestAllowedBirthDate(now)`
  (`birth_data_screen.dart`), with age-gate tests (P0-6).
- **Remaining owner action:** confirm the store age rating is consistent with
  the 18+ gate — declare an **adult** target audience on Play, and answer
  Apple's age-rating questionnaire consistently. **[PROPOSED]**

### 9.5 Release-integrity / key-handling risk

- **Release signing material [updated 2026-06-12]:** the debug-signing
  fallback is removed in gradle; the owner upload keystore is still required
  (P0-2) — also a trust signal in review.
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

In-repo engineering is landed (display name, age gate, icon, metadata drafts,
raw screenshots, privacy copy, release-signing wiring). The remaining critical
path is owner/secret/legal/console work:

```
Owner gates                  ──►  Console finalization        ──►  Internal test  ──►  Submit EN Tier 0
(bundle-ID approval,              (final metadata re-count,        (both stores)       (Lifestyle)
 signing material,                 screenshot compositing +
 hosted privacy URL,               upload, demo/review key)
 Apple/Play privacy forms,
 category)
```

### 10.2 Stage detail

1. **Config & compliance (engineering) — mostly done in-repo.** Display name
   → TrueRise, age gate, app icon, in-app privacy-copy disclosure (Sec. 9.3),
   and release-signing **wiring** are landed. Remaining engineering depends
   only on owner inputs: bundle-ID approval, signing material (upload
   keystore + iOS distribution), and the hosted privacy URL. **[VERIFIED
   in-repo / owner-gated remainder]**
2. **Hosted privacy policy (owner + Legal).** Stand up a reachable URL that
   accurately describes the third-party transmission, on-device storage, demo
   mode, and deletion. Can proceed in parallel with
   Run A. **[PROPOSED]**
3. **Metadata + screenshots (owner + design).** The Sec. 6 metadata package
   and raw Sec. 8 storyboard screenshots are **prepared in-repo**. Remaining:
   console char re-count (post-trademark), screenshot compositing, other
   device sizes, and console upload. **[VERIFIED in-repo / console
   remainder]**
4. **Privacy/Data-Safety forms (owner + Legal).** Author Apple labels + Play
   Data Safety to match Sec. 9.3. **[PROPOSED]**
5. **Internal testing (engineering).** TestFlight internal + Play
   internal-testing track; run Play pre-launch report in **Demo mode**;
   on-device smoke on a real iOS + Android device (deferred in Phase 8).
   **[PROPOSED]**
6. **Submit English Tier 0** under **Lifestyle** on both stores with the reviewer notes from Sec. 9.6. **[PROPOSED]**
7. **Localized listings (prepared, review-gated).** The l10n pipeline,
   in-app translations, listing drafts, and raw localized screenshots are
   **done in-repo** (G20/G22). Publication waits on native-speaker review,
   per-locale console re-count/upload, and a UI/listing consistency check.
   Not on the first-submission (EN Tier 0) critical path. **[VERIFIED
   in-repo / review-gated]**

### 10.3 Parallelizable vs blocking

- **Blocking (must precede submit):** bundle-ID approval, signing material
  (upload keystore + iOS distribution), hosted privacy URL, privacy/
  Data-Safety forms, console metadata re-count, screenshot compositing +
  upload, demo/review key, real-device smoke.
- **Parallel (independent owner tracks):** privacy-URL hosting,
  privacy/Data-Safety forms, demo-key rotation, screenshot compositing.
- **Off critical path:** analytics (G13). The share-card image (G9) has
  since shipped in-repo (2026-06-12), so it is no longer pending work.
  Localized **publication** is owner/review gated (native-speaker review +
  per-locale console work), not local engineering gated — the in-repo l10n
  work (G20/G22) is done.

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

# Release guard preflight (iOS and Android) — must pass with the real
# proxy/share URLs; placeholders block a public release. Omit the two
# --allow-bundled-key flags if ASTRO_API_KEY was removed from .env.
dart run tool/release_env_guard.dart \
  --share-url "$TRUERISE_SHARE_URL" \
  --proxy-base-url "$RECTIFY_PROXY_BASE_URL" \
  --allow-bundled-key --purpose=review-capped

# Build the shippable artifacts (release env defines per README
# "Environment configuration"; iOS needs distribution signing, Android
# the upload keystore in android/key.properties)
flutter build ipa --release \
  --dart-define=RECTIFY_ENV=prod \
  --dart-define=RECTIFY_PROXY_BASE_URL="$RECTIFY_PROXY_BASE_URL" \
  --dart-define=RECTIFY_PROXY_PATH="$RECTIFY_PROXY_PATH" \
  --dart-define=RECTIFY_PROXY_APP_ID="$RECTIFY_PROXY_APP_ID" \
  --dart-define=TRUERISE_SHARE_URL="$TRUERISE_SHARE_URL" \
  --dart-define=TRUERISE_PRIVACY_POLICY_URL="$TRUERISE_PRIVACY_POLICY_URL"
flutter build appbundle --release \
  --dart-define=RECTIFY_ENV=prod \
  --dart-define=RECTIFY_PROXY_BASE_URL="$RECTIFY_PROXY_BASE_URL" \
  --dart-define=RECTIFY_PROXY_PATH="$RECTIFY_PROXY_PATH" \
  --dart-define=RECTIFY_PROXY_APP_ID="$RECTIFY_PROXY_APP_ID" \
  --dart-define=TRUERISE_SHARE_URL="$TRUERISE_SHARE_URL" \
  --dart-define=TRUERISE_PRIVACY_POLICY_URL="$TRUERISE_PRIVACY_POLICY_URL" \
  --android-project-arg=truerise.allowBundledApiKey=true \
  --android-project-arg=truerise.bundledApiKeyPurpose=review-capped
# The --android-project-arg=truerise.* pair is only the capped-review-key
# acknowledgement; omit it when ASTRO_API_KEY is removed from .env.
```

### 11.2 Listing/compliance verification (manual, in-console)

- [ ] Hosted privacy-policy URL returns 200 and matches in-app + Data-Safety
      claims (incl. third-party transmission). **[P0-4/P0-5]** (app wiring done
      in-repo 2026-06-12 — `TRUERISE_PRIVACY_POLICY_URL` + in-app fallback;
      owner hosting remains)
- [ ] Apple App Privacy labels authored; Play Data Safety form authored; both
      declare location + sensitive free-text + birth data **shared** with the
      provider in live mode; both declare **no tracking**. **[P0-5]** (drafts
      authored in-repo — `docs/apple-privacy-labels.md`,
      `docs/play-data-safety.md`; console entry + legal sign-off remain)
- [ ] Age gate present in build; store age ratings consistent. **[P0-6]**
      (in-app 18+ gate done in-repo with tests; owner store age-rating
      questionnaire remains)
- [ ] App icon present (no default glyph). **[P0-7]** (icon assets in repo —
      iOS appiconset + Android adaptive; store icon review at submission
      remains)
- [ ] Title/subtitle/keyword/description char counts re-counted in console.
      **[P0-8]** (listing copy in repo — `docs/store-listing-en.md` +
      localized variants; console re-count remains)
- [ ] Raw 6.7" screenshots are **in-repo** (P0-9); remaining submission work
      is compositing, other device sizes, and console upload. **[P0-9]**
- [ ] Category = Lifestyle on both the App Store and Google Play. **[P0-10]**
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

1. **Bundle ID:** current ID stays `com.rectify.rectify` until explicit owner
   approval. Recommendation is in `docs/bundle-id-recommendation.md`: primary
   `app.astrolium.truerise`; fallbacks `com.astrolium.truerise` (if only
   `astrolium.com` is controlled) or `com.truerise.app`. *Irreversible after
   first publish.* **[decision — awaiting owner]**
2. **Age-gate cutoff & store age rating:** PRD says "born before 2008"; confirm
   the exact floor and the resulting iOS/Play age rating. **[decision]**
3. **Hosted privacy-policy ownership + content:** who hosts, and confirm it
   names the **third-party provider** and its data retention. **[decision/Legal]**
4. **Demo/review key:** rotate to a low-budget capped key; confirm `.env`
   in-binary exposure is acceptable for review. **[decision]**
5. **Trademark clearance + App Store name availability for "TrueRise."**
   Not asserted here — must be cleared before locking metadata. **[decision]**
6. **Category confirmation:** Lifestyle on both the App Store and Google Play. **[decision]**
7. **Device matrix:** is iPad / Android tablet a target (affects screenshot
   sets + landscape QA)? **[decision]**
8. **Localized-listing go/no-go + launch sequencing** — artifacts are prepared
   in repo; native-speaker review and per-locale console character
   recount/upload remain. Locale voice choices also needed: PT-BR-only
   vs PT-PT fallback, German du/Sie, ES neutral vs es-419. **[decision — Run 5]**
9. **Hosted-policy/provider wording:** the in-app privacy screen already
   discloses live transmission (Sec. 9.3); owner/legal must confirm the hosted
   policy and store forms use matching provider handling/retention wording.
   **[decision/Legal]**

### 12.2 Source evidence appendix (read this run, read-only)

> **Baseline as read on 2026-06-02 — preserved unchanged.** Current state has
> since moved for four rows: display name = **TrueRise** (iOS + Android), real
> icon assets landed, Android release signing now reads the git-ignored
> `android/key.properties` with **no debug fallback**, and privacy-URL app
> wiring landed 2026-06-12 — the "no url_launcher" claim in the `pubspec.yaml`
> row below is historical; `url_launcher` is now a dependency and
> `TRUERISE_PRIVACY_POLICY_URL` opens from Settings with an in-app fallback.
> Likewise historical (superseded 2026-06-12): the `pubspec.yaml` row's "no
> share_plus" claim and the Run 4 row's "share-card image = V1.5" — `share_plus`
> is now a dependency and the privacy-safe share-card image (G9) is shipped
> in-repo; the share rows below describe the text surface only, which still
> exists alongside the image surface.
> See the status note at the top of this document.

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
| Settings: demo toggle, 12/24h, delete-all, privacy row, "Rectify v1.0.0" | `lib/features/settings/settings_screen.dart` (`:157`) | VERIFIED |
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
