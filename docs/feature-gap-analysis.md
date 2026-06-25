# Feature Gap Analysis - TrueRise / Rectify (Run 4)

**Version:** 1.0 (Run 4 - Feature Gap Analysis)
**Date:** 2026-06-02
**Model:** claude-opus-4-8 (run invoked explicitly under this model)
**Status:** Implementation-ready backlog for leadership; input to Run 5 (Localization Strategy)
**Linked to:** `docs/growth-thesis.md` (Run 1), `docs/competitor-aso-research.md`
  (Run 2), `docs/aso-naming-strategy.md` (Run 3), `docs/prd.md`,
  `docs/mvp-scope.md`, `docs/qa-phase8-report.md`, `docs/marketing-research.md`

> ## Current status as of 2026-06-03 - Impl Run E.1 (reconciliation)
>
> The body below is the 2026-06-02 (Run 4) baseline, preserved as historical
> evidence. Several P0 gaps have since been closed by Impl Runs A.1-A.5, C.1,
> and D.1-D.4. The authoritative current view is
> `docs/publication-readiness-current-status.md`. Status deltas to the Section 4
> matrix / Section 5 P0 list / Section 10 table (these SUPERSEDE the "MISSING /
> UNVERIFIED / BLOCKED / READY (doc)" labels below):
>
> - G1 display-name -> TrueRise: DONE [VERIFIED] (A.1) - `Info.plist`,
>   `AndroidManifest.xml`, `lib/l10n/l10n.dart` `appBrandName='TrueRise'`.
> - G4 app icon: DONE [VERIFIED] (A.3) - iOS appiconset + Android adaptive icon.
> - G6 COPPA/age gate: DONE [VERIFIED] (A.1) - 18+ floor in the date picker
>   (`birth_data_screen.dart`); corrects the Run 4 "UNVERIFIED".
> - G7 store metadata: DONE (A.4 EN + D.3 localized) - `docs/store-listing-en.md`,
>   `docs/store-listing-tier1-localized.md`; `pubspec.yaml` description replaced.
> - G8 store screenshots: DONE, raw (A.5 EN + D.4 localized) -
>   `screenshots/store/{en,de,fr,es,pt-BR}/`, 5 frames each.
> - G20 l10n pipeline: DONE [VERIFIED] (C.1) - `flutter_localizations`,
>   `generate: true`, `l10n.yaml`, `lib/l10n/app_en.arb` + extraction.
> - G22 translated UI + ASO metadata (de/fr/es/pt-BR): DONE in-repo (D.1/D.3/D.4);
>   native-speaker review + per-locale console re-count still remain. UPDATE
>   2026-06-12: the shipped share TEXT payload is now localized in-repo for
>   EN/DE/ES/FR/PT - `share_copy_builder.dart` takes `AppLocalizations` and
>   follows the active locale, superseding the earlier "English-only" caveat
>   (and the baseline G11/Section 6 descriptions of a single English string
>   below). Still privacy-safe: time + rising + confidence + brand + share URL
>   only; no birth data, events, coordinates, or API ids. Native-speaker review
>   of the share copy remains owner scope; not a P0 blocker.
> - Still OPEN / owner-gated: G2 (privacy URL - content authored; app wiring
>   done 2026-06-12, config-gated via the public
>   `--dart-define=TRUERISE_PRIVACY_POLICY_URL` with in-app fallback; the
>   owner-hosted public URL itself remains), G3 (Apple/Play forms authored,
>   console entry pending), G5 (bundle-id decision pending; Android release
>   signing wiring DONE 2026-06-12 - `build.gradle.kts` reads the git-ignored
>   `android/key.properties`, has no debug fallback, and fails requested release
>   tasks when signing material is missing; owner upload keystore + Play App
>   Signing enrollment + iOS distribution signing remain).
> - G9 privacy-safe share-card image: DONE in-repo as of 2026-06-12. This
>   SUPERSEDES every baseline statement below that calls the share-card image
>   MISSING, unbuilt, V1.5-only, or "VERIFIED ABSENT (no `share_plus` /
>   render-to-image package)" - i.e. the Section 1/2/4/6.2 rows, the
>   Section 11-13 deferral language, and the Section 14 `pubspec.yaml`
>   absence check. `share_plus` is now a dependency;
>   `lib/core/sharing/story_card_renderer.dart` renders the PNG story card
>   and `ShareService.shareImagePng` shares it from the result screen
>   (`_ShareImageButton`, `resultShareImageButtonKey`). Text and image share
>   both emit only the privacy-safe allow-list (time, rising when present,
>   confidence, brand, public share URL/caption) - the Section 6.3 guardrails
>   hold for both surfaces. Tests:
>   `test/widget/features/calculation_flow/result_share_test.dart`,
>   `test/unit/sharing/story_card_renderer_test.dart`. Direct Instagram
>   Stories posting remains optional / out of scope until a Meta/Facebook
>   App ID exists; the card shares via the OS share sheet.
> - OUT-OF-SCOPE, unchanged: G13 analytics (P1), G14 crash reporting (P1),
>   G23 PDF (V1.5), G24 IAP (V1.5).

**Scope discipline.** This run is strategy- and documentation-only. It does not
edit app code, config, store metadata, assets, screenshots, or localization
files, and it implements no features. It compares the Run 1-3 growth/ASO strategy
and Run 2 competitor evidence against the *current verified product* and produces
a prioritized gap backlog. Three evidence classes are kept separate throughout:
**[VERIFIED]** read directly from code/config on 2026-06-02; **[ASSUMED]** carried
from a strategy/PRD doc and not independently re-checked; **[PROPOSED]** a new
feature this document recommends. No live ranking, rating, install, review, or
trademark fact is invented.

**ASCII note.** This document uses ASCII punctuation (`-`, `->`, straight quotes)
per the Run 4 brief, even though sibling docs use em-dashes.

---

## 1. Executive Summary

**What the product already has [VERIFIED; updated 2026-06-12].** TrueRise ships
a complete, offline demo loop and a real-calculation loop: onboarding -> birth
data + geocoding -> time window -> life events (12 categories, soft 5-event
warning) -> loading -> ranked result (time + rising + confidence) -> per-event
evidence -> history with swipe-delete -> full data wipe. A three-mode API path
(proxy / user-key / demo-`.env`) keeps the provider secret off-device.
Critically for the leadership question, a **privacy-safe share is already
shipped in both text and image form**: `ShareCopyBuilder` emits only time +
rising + confidence + a "Calculated with TrueRise" tagline, and the story-card
renderer draws the same allow-list onto the PNG share card, with **zero PII**
(no birth city/date, no events, no labels, no API ids).

**What remains open [updated 2026-06-12; see status note].** The Run 4 baseline
gaps have largely been closed in-repo: the display name is TrueRise (G1), the
l10n pipeline plus DE/FR/ES/PT-BR translations exist (G20/G22), and the
privacy-safe share-card image ships alongside the text share (G9). What still
gates publication is owner/store work, not app code: the **hosted
privacy-policy URL** (content authored, app wiring config-gated; the public
page itself must be published), the **Apple privacy labels / Play Data Safety
forms** (authored; console entry pending), the **bundle-id decision plus
signing secrets** (upload keystore, Play App Signing enrollment, iOS
distribution signing), and **console entry plus native-speaker review** of the
localized metadata, screenshots, and share copy. Separately, there is still
**no analytics or telemetry** wired (P1 by design), so the north-star (RRC/wk)
and the share-loop hypothesis (Run 1 H3) remain unmeasured at launch.

**Top 3 priorities (current).**

1. **P0 - Owner/store publication gate.** Hosted privacy-policy URL, Apple/Play
   privacy and data-safety forms, bundle-id decision + signing secrets, and
   console entry. Pure store-policy blockers with no app-code work remaining;
   unblocks the Tier 0 English launch the whole growth plan depends on.
2. **P1 - Privacy-safe funnel + share-loop analytics.** Cheap, high
   decision-value: without it, RRC/wk, demo->real conversion, and H3 cannot be
   measured, and every later growth bet is blind. Must exclude birth data and
   event content (PRD Section 13).
3. **Publication/review follow-through on shipped l10n + share card.**
   Native-speaker review of translated UI/ASO/share copy, per-locale console
   re-counts, screenshot compositing/upload, and the pixel-level privacy review
   of the rendered card. Review and console work, not feature development.

**Honest framing (no virality overclaim).** A text share does not make an app go
viral, and neither does a share card by itself. The share card (now shipped
in-repo) is the *precondition* for any visual-platform distribution, not a
guarantee of it. Rank everything below by leverage x verification cost, and
measure before scaling.

---

## 2. Current Feature Inventory [VERIFIED 2026-06-02]

All rows read directly from code/config this run unless marked otherwise.

| Capability | Status | Evidence path |
|---|---|---|
| Onboarding (3-screen, skippable, first-launch only, persists flag) | SHIPPED | `lib/features/onboarding/onboarding_controller.dart`, `onboarding_screen.dart`; PRD F1 / scope M1 |
| New calculation flow (stepper) | SHIPPED | `lib/features/calculation_flow/screens/*`, `widgets/calc_step_scaffold.dart` |
| Birth details + city geocoding to lat/lon | SHIPPED | `screens/birth_data_screen.dart`, `geocoding/geocoding_service.dart`, `data/models/birth_data.dart`, `geo_place.dart`; PRD F2 / M2 |
| Time window (no-idea = 24h; approximate + width) | SHIPPED | `screens/time_window_screen.dart`, `data/models/time_window.dart`, `time_window_mode.dart`; PRD F3 / M3 |
| Life events (12 categories, month+year, add/delete/reorder, <=20) | SHIPPED | `screens/life_events_screen.dart`, `widgets/add_event_sheet.dart`, `data/models/life_event.dart`, `event_category.dart`; PRD F4 / M4 |
| Soft warning under 5 events (not a hard block) | SHIPPED | `life_events_screen.dart:136` ("Add at least 5 events for a real calculation."); PRD F4.4 |
| Demo mode / offline sample (3 candidates 78/61/44%, Gemini Rising, 6 evidence rows 2-strong/2-mod/1-weak/1-none) | SHIPPED | `lib/data/demo/demo_response.dart`; demo constructs no Dio (offline) per qa-phase8 AC-Demo-2; scope DM1-DM5 |
| Result screen (hero time + rising, confidence bar, up to 3 candidates, demo pill, reveal animation + reduced-motion) | SHIPPED | `screens/result_screen.dart`, `widgets/result/hero_result_card.dart`, `confidence_bar.dart`, `candidate_card.dart`, `hero_reveal.dart`; PRD F6 / M8 |
| Evidence breakdown (per-event Strong/Moderate/Weak/None + explanation, summary line) | SHIPPED | `screens/evidence_screen.dart`, `widgets/cards/evidence_card.dart`, `match_strength_dots.dart`, `data/models/evidence_item.dart`, `match_strength.dart`; PRD F7 / M9 |
| History (newest-first, tap = cached result, swipe-to-delete) | SHIPPED | `features/home/home_history_screen.dart`, `history_providers.dart`, `data/repos/history_repository.dart`, `widgets/cards/history_card.dart`; PRD F8 / M10 |
| Delete-all-data (wipes Drift + prefs + secure storage, count-aware copy, confirm) | SHIPPED | `features/settings/delete_all_data_sheet.dart` -> `SettingsController.deleteAllData()`; PRD F9.6 / M13 / AC4 |
| Draft persistence / retry-with-inputs primitive | SHIPPED (partial) | `data/repos/draft_repository.dart`; scope S3 (full "save and retry later" still open per qa-phase8 Section 6). Verified 2026-06-12: `CalculationFlowController.cancelSubmit()` aborts the in-flight Dio `CancelToken` and a submit-generation guard blocks late completion from clearing the draft / writing history / stealing navigation; error-route retry re-enters loading with preserved inputs; tests: `test/widget/features/calculation_flow/loading_screen_test.dart`, `test/data/api/rectification_api_test.dart`, `test/data/repos/rectification_repository_test.dart`, `test/widget/features/error_flow/error_routing_test.dart` |
| API path: 3 modes (proxy default, provider-direct via user key, demo `.env` fallback); fail-fast `proxy.invalid.example` default | SHIPPED | `lib/providers/core_providers.dart`, `data/api/api_client.dart` (`buildDio`, `mapDioException`), `rectification_api.dart`, `mappers.dart`; PRD Section 11 / M6 |
| Pro/Dev API key in device keychain (never SQLite/prefs) | SHIPPED | `data/secure/secure_key_store.dart`, `proApiKeyProvider`; PRD F9.1 / AC4 |
| Settings (time format 12/24h, demo toggle, version, privacy link, delete-all) | SHIPPED | `features/settings/*`; PRD F9 / M11 |
| In-app privacy policy screen | SHIPPED | `features/settings/privacy_policy_screen.dart`, `app/router.dart` (hosted URL still missing - see Section 5) |
| **Privacy-safe result share - text + image** (UPDATE 2026-06-12; was TEXT ONLY at the Run 4 baseline) | SHIPPED | `lib/core/sharing/share_copy_builder.dart` (PII-free: time + rising + confidence + tagline), `share_service.dart` (`rectify/share` channel + clipboard fallback; `shareImagePng`), `story_card_renderer.dart` (PNG story card), `result_screen.dart` `resultShareButtonKey` / `resultShareImageButtonKey`; tests: `test/widget/features/calculation_flow/result_share_test.dart`, `test/unit/sharing/story_card_renderer_test.dart` |
| No payment / IAP surface anywhere | VERIFIED ABSENT (by design) | no `in_app_purchase` in `pubspec.yaml`; `test/security/no_payment_or_secret_strings_test.dart`; PRD F10 / scope AC3 |
| No analytics / crash-reporting SDK | VERIFIED ABSENT | no `firebase*`, `sentry`, `posthog`, `amplitude` in `pubspec.yaml` or `lib/`; growth-thesis Section 6.5 |
| Share-card image (story-card PNG via `share_plus`) | SHIPPED (UPDATE 2026-06-12; VERIFIED ABSENT at the Run 4 baseline) | `share_plus` in `pubspec.yaml`; `lib/core/sharing/story_card_renderer.dart`, `ShareService.shareImagePng`; tests: `test/widget/features/calculation_flow/result_share_test.dart`, `test/unit/sharing/story_card_renderer_test.dart` |
| l10n pipeline (ARB / `flutter_localizations`) | SHIPPED (UPDATE: DONE C.1; VERIFIED ABSENT at the Run 4 baseline) | `l10n.yaml`, `generate: true`, `lib/l10n/app_{en,de,es,fr,pt}.arb` + generated `AppLocalizations`. The baseline absence finding corrected implementation-plan line 1282 ("ARB from day one"), which has since been implemented |
| Post-result feedback prompt (S1 "does this time feel plausible?") | SHIPPED | `features/calculation_flow/screens/result_screen.dart` + `result_screen_sections.dart` (Yes / Not sure / No); persists result id -> answer via `lib/data/prefs/result_feedback_store.dart`; wiped by delete-all-data (`SettingsRepository`); no network/PII; tests: `test/data/prefs/result_feedback_store_test.dart`, `test/widget/features/calculation_flow/result_screen_test.dart`; scope S1; growth-thesis H6 |
| COPPA age gate (born before 2008) | UNVERIFIED at Run 4 *(since DONE - see status note: 18+ floor in `birth_data_screen.dart`, A.1)* | required by PRD Section 13; not confirmed in code this run - flag for P0 verification |

---

## 3. Competitor / Review / Screenshot-Derived Feature Expectations (from Run 2)

What users in this category have been *trained to expect*, grouped by source
class. Sourced from `docs/competitor-aso-research.md`; all carry Run 2's caveats
(US-locale web search != in-store rankings; ratings/installs not fetchable;
review themes are qualitative, not a structured sample).

### 3.1 Direct birth-time-rectification competitors

| Source | Feature expectation it sets | TrueRise position |
|---|---|---|
| **Vedic Samay** (iOS, Utilities, the one mobile-native BTR app) | Wizard life-event entry across ~12 categories; "hundreds of candidate times" with scoring; **free-credit trial** as the hook; PDF report; AI chart-study assistant | TrueRise matches the wizard + candidate scoring + evidence; its edge is the **offline demo** (no signup) and **no-jargon consumer UX**. Gaps vs Vedic Samay: PDF/report artefact (V1.5), and a trial/credit framing (deferred with IAP) |
| **Cosmic Birthtime** (web, GBP 28/report) | 3-step flow (birth data -> events -> result); rising sign + 12 houses unlocked; **PDF deliverable**; candid "estimate, not certainty" copy | TrueRise meets/exceeds on confidence + per-event evidence and on honest copy; lacks the shareable **PDF/report** artefact (V1.5) |
| **AI Pandit** (web, no price, no app) | "Seconds-level precision", zero-access encryption claims | No mobile presence; no expectation TrueRise must match now |
| Desktop BTR (Vega 7 BR, Samay Sutram IN, astropair DE) | Progression/sub-lord scoring "mountains", practitioner depth | Practitioner depth is V2-adjacent; not a consumer expectation |

### 3.2 Mainstream astrology apps (not BTR, but set user expectations)

| Source | Feature expectation it sets | TrueRise position |
|---|---|---|
| **Co-Star** | Chart "to the minute"; an "I don't know my birth time" option that **degrades** (no reliable ascendant) | TrueRise is the *answer* to that dead-end; keep the demo as proof |
| **CHANI** | Rising-sign-centric; "Unknown Birth Time" help article; workaround = set time to sunrise | Same: TrueRise is the downstream utility when the user hits the wall |
| **The Pattern / Nebula** | Manual time nudge; route uncertainty to human advisors | Confirms no incumbent computes BTR; anti-positioning holds |
| Category-wide (Run 2 Section 7) | "Is it accurate, and can you show me why?"; resentment of black-box output and aggressive paywalls | TrueRise already optimizes this axis (confidence + evidence) and has **no paywall** - a differentiator to protect |

### 3.3 Web calculators / services

| Source | Feature expectation it sets | TrueRise position |
|---|---|---|
| **astrocalc.fr** (closest functional analog) | Time-range input -> ascendant interval + **confidence level** + 24h graph + PDF | TrueRise matches confidence + evidence; lacks a visual graph and PDF (both V1.5+ candidates, not MVP) |
| **astroasist.com / carta-natal.es** | Ascendant-without-hour by elimination; degrade-to-noon | TrueRise rectifies rather than degrades - the differentiator |
| Brazilian practitioners (Run 2 Section 6.5) | Expect **10+ dated events** | Inform PT-BR copy + the soft event-count warning (already shipped) |

**Net read.** The category's table-stakes are: a guided multi-category event
wizard (HAVE), honest confidence (HAVE), show-your-work evidence (HAVE, a
strength), and a **shareable artefact** (UPDATE 2026-06-12: text + image
share card now SHIPPED; PDF still MISSING/V1.5).
The image artefact has since been matched in-repo (see status note / G9);
PDF remains the open competitor table-stake - see Sections 6 and 11.

---

## 4. Gap Matrix

Columns: Growth impact / ASO-store impact / Policy risk / Complexity are
qualitative (High/Med/Low). Phase: P0 (pre-publication), P1 (first growth wave),
V1.5 (gated on the V1.5 cut), P2 (later). "Owner" is the lead function.

| # | Feature / gap | Evidence source | Current status | Growth | ASO/store | Policy risk | Complexity | Phase | Owner notes |
|---|---|---|---|---|---|---|---|---|---|
| G1 | Display-name -> "TrueRise" (`CFBundleDisplayName`, `android:label`) | Run 3 Section 1; `ios/Runner/Info.plist`, `android/.../AndroidManifest.xml` [VERIFIED still "Rectify"/"rectify" at Run 4 baseline; TrueRise applied since - see status note] | MISSING (Run 4) -> DONE (A.1) | Med | High | Low | Low (config) | P0 | Config only, not a code edit. Bundle/package ID is now `ua.com.truerise.app` |
| G2 | Hosted privacy-policy URL (replace/augment in-app screen) | PRD Section 13; qa-phase8 Section 6; Run 3 Section 11 #12 | PARTIAL (in-app screen exists; app wiring done 2026-06-12, config-gated `TRUERISE_PRIVACY_POLICY_URL`) | Low | High (both stores require) | High if absent | Low (Legal publishes URL; no code left) | P0 | Legal publishes canonical URL; same URL goes in build define + listings |
| G3 | App Store privacy labels + Play Data Safety form | PRD Section 13; store policy | PARTIAL (authored prep - `docs/apple-privacy-labels.md` + `docs/play-data-safety.md` map the verified data flow to each form; was MISSING at the Run 4 baseline) | Low | High | High if wrong | Low-Med (form, no code) | P0 | Must match actual data flow (on-device + proxy/provider); owner/legal sign-off + actual console entry remain (both docs are "guidance, not a submission") |
| G4 | Real app icon (not default Flutter glyph) | qa-phase8 Section 6 (Run 4 baseline; icon assets landed since - see status note) | MISSING (Run 4) -> DONE (A.3) | Low | High (listing quality) | Low | Low-Med (design + `flutter_launcher_icons`) | P0 | Blocks store, not demo |
| G5 | Bundle-id + release-signing lock | qa-phase8 Section 5.3 / Section 6 | PARTIAL (bundle/package ID implemented 2026-06-23; Android signing wiring done 2026-06-12; owner keystore + iOS signing remain) | Low | High (submission) | Low | Low | P0 | Final ID is `ua.com.truerise.app`; owner provisions upload keystore + iOS distribution signing |
| G6 | COPPA age gate (born before 2008) | PRD Section 13 | UNVERIFIED (Run 4) -> DONE (A.1) | Low | Med | High if missing | Low | P0 | Implemented: 18+ floor via `CalculationFlowState.latestAllowedBirthDate` / `lastDate` in `birth_data_screen.dart`; tests in `test/features/calculation_flow/calculation_flow_controller_test.dart` |
| G7 | Store metadata (category **Lifestyle** on both stores post-Appeeky, title/subtitle/keywords) | Run 3 Sections 4-6, 12; refreshed 2026-06-15 from the Appeeky audit (`docs/store-listing-en.md` Section 1/3.4) | READY (doc) | Med | High | Med (4.3(b)) | Low (console, no code) | P0 | Copy from Run 3 Option H (DE uses Option C); category is **Lifestyle** on both stores post-Appeeky - the earlier Utilities/Tools category leg is superseded historical context (`docs/store-listing-en.md` Section 1/3.4) |
| G8 | Store screenshots (hero -> evidence -> demo -> share) | Run 3 Section 8 | DONE, raw (A.5 EN + D.4 localized; was MISSING at Run 4) | Med | High | Low | Med (design) | P0 | Raw captures in `screenshots/store/{en,de,fr,es,pt-BR}/` (5 frames per locale); remaining: device-frame/caption compositing, other device sizes if required, console upload, owner/design review. Lead with the tool, not zodiac art |
| G9 | **Privacy-safe share-card IMAGE** (Stories/feed) | PRD Section 17; Run 1 H3; Run 3 Section 8 | DONE in-repo (2026-06-12; was MISSING) - `story_card_renderer.dart`, `ShareService.shareImagePng`, `resultShareImageButtonKey`; tests `result_share_test.dart` + `story_card_renderer_test.dart` | **High** | Med | **Med-High (PII in pixels)** | Med-High | **V1.5 (shipped early)** | The Instagram lever; pixel-level privacy review of the rendered card remains owner scope |
| G10 | Share discoverability (prominent CTA, share from history, post-demo share prompt) | `result_screen.dart` / `result_screen_sections.dart` (`resultShareButtonKey`, `resultShareImageButtonKey`); `home_history_screen.dart` (history-row share); `result_screen_sections.dart` + `share_prompt_store.dart` (`resultDemoSharePromptKey` / `resultDemoSharePromptShareKey`); Run 1 H3 | SHIPPED, VERIFIED (2026-06-12) | Med | Low | Low (reuse PII-free builder) | Low | P1 | Cheap multiplier on the existing loop. Verified by `test/widget/features/calculation_flow/result_share_test.dart`, `test/widget/features/calculation_flow/result_demo_share_prompt_test.dart`, `test/widget/features/home/home_history_share_test.dart` (22 tests) |
| G11 | Share copy variants / light A-B | `share_copy_builder.dart` (single string) | MISSING | Low-Med | Low | Low | Low | P1 | Only meaningful once analytics exist (G13) |
| G12 | Referral / install attribution | no accounts (PRD Section 8) | MISSING | Low-Med | Low | Med (privacy) | Med | P2 | Limited pre-account; rely on store referrer + tagline first |
| G13 | **Privacy-safe funnel + share-loop analytics** | growth-thesis Section 6; [VERIFIED no SDK] | MISSING | **High (enables measurement)** | Med | **High (must exclude PII/events)** | Med | P1 | Without it RRC/wk + H3 are blind; explicit privacy decision (PRD Section 13) |
| G14 | Crash reporting (Crashlytics/Sentry) | qa-phase8 Section 6 | DEFERRED | Low | Med (quality) | Med (PII in payloads) | Med | P1 | Pairs with G13 SDK decision |
| G15 | Confidence explanation ("what 78% means") | PRD F6; Run 2 Section 7 | SHIPPED (2026-06-12) | Med | Low | Low | Low (content) | P1 | Anti-commodity trust surface. Explainer under the confidence bar (`resultConfidenceExplainerKey` in `result_screen.dart`; `_ConfidenceExplainer` in `result_screen_sections.dart`); l10n en/de/es/fr/pt; widget tests: `result_screen_test.dart` group "confidence explainer" |
| G16 | Method explanation ("transits + progressions") | PRD F6.5; Run 3 Section 7.4 | SHIPPED, GUARDED (test) | Med | Low | Low-Med (keep "method" not "fortune") | Low (content) | P1 | Reads as a tool, supports 4.3(b). Method copy (`resultConfidenceExplainerMethod`) ships in the same `_ConfidenceExplainer`; framing locked by `test/security/probabilistic_framing_test.dart` |
| G17 | Probabilistic-framing audit on result + share | Run 1 Section 2.2; design-system Section 9.7 | VERIFIED, GUARDED (test) | Low | Low | High if violated | Low | P1 | No certainty/medical/legal/financial language in result/share/demo copy; locked by `test/security/probabilistic_framing_test.dart` |
| G18 | Post-result feedback prompt (S1) | scope S1; growth-thesis H6 | SHIPPED (local-only) | Med (enables H6) | Low | Low (local only, no PII) | Low | P1 | One local question; no backend/network; `result_screen_sections.dart` + `result_feedback_store.dart`; delete-all wipes answers |
| G19 | Expandable evidence detail | PRD F7.5 | SHIPPED, VERIFIED (2026-06-12) | Low | Med (screenshot depth) | Low | Low | P2 | `widgets/cards/evidence_card.dart` (tap toggles collapsed/expanded explanation; semantics include match strength); `screens/evidence_screen.dart` passes `explanation`, strong/moderate default expanded via `_defaultExpandedFor`; tests: `test/widget/cards/cards_test.dart` + `test/widget/features/calculation_flow/evidence_screen_test.dart` (11 tests) |
| G20 | **l10n extraction pipeline** (`flutter_localizations` + gen-l10n + ARB + wiring) | [VERIFIED absent at Run 4]; corrects impl-plan line 1282 | DONE (C.1; was MISSING) - `l10n.yaml`, `generate: true`, `lib/l10n/app_en.arb` + extraction | Med (unlocks Tier 1) | High (locale ASO) | Low | Med-High (refactor) | P1 (pre-Tier-1) | Precondition for DE/FR/PT/ES; locale-agnostic - now satisfied |
| G21 | Locale-aware formatting audit (date/time/percent) | `core/formatting/app_date_format.dart`, `share_copy_builder.dart` | SHIPPED, VERIFIED (2026-06-12) | Low | Med | Low | Low | P1 | Date/time verified: `AppDateFormat` uses `intl` `DateFormat` for 12h/24h clock, long dates, month/year; `ShareCopyBuilder` accepts `TimeFormat`; result/history/evidence/time-window call sites honor `settings.timeFormat` in both 12h and 24h; tests: `app_date_format_test.dart`, `share_copy_builder_test.dart`, result-share/settings/history widget tests (64 tests). Percent formatting remains a separate copy/locale review |
| G22 | Translated ASO metadata + UI strings (DE/FR/PT/ES) | Run 1 Section 4.2; Run 3 Section 9 | DONE in-repo (D.1/D.3/D.4; was BLOCKED on G20) - localized ARBs + `docs/store-listing-tier1-localized.md`; native-speaker review + per-locale console re-count remain owner scope | Med | High | Med (DE credibility) | Med (translation) | V1.5 | Pipeline + translations landed; owner review gates publication |
| G23 | PDF / full-report export | PRD Section 17; Run 2 Section 3.1/4.2 | DEFERRED | Med | Med | Med (PII) | High | V1.5 | Competitor table-stake; not MVP |
| G24 | IAP / credits / paywall | PRD F10 / Section 17 | DEFERRED (by design) | n/a | n/a | n/a | High | V1.5 | Do NOT pre-empt; out of growth phase (Run 1 Section 10) |

---

## 5. P0 - Pre-Publication Fixes / Must-Have Gaps

These gate store submission for the Tier 0 English launch. None adds a new
product surface; all are config, content, asset, or policy. They map to the
Run 1 D4 P0 criterion (c) "required by store policy."

- **G1 - Display-name alignment (config task, NOT a code edit).** Set
  `CFBundleDisplayName` (iOS) and `android:label` (Android) to "TrueRise". Today
  the installed icon reads "Rectify"/"rectify" while every marketing surface and
  the in-app share tagline say "TrueRise" [VERIFIED `ios/Runner/Info.plist`,
  `android/app/src/main/AndroidManifest.xml`]. Keep `CFBundleName=rectify` as
  the internal codename. This is the single highest-confusion-risk pre-launch
  item and the cheapest to fix. *(Current state: DONE - `CFBundleDisplayName`
  and `android:label` are "TrueRise" since Impl Run A.1; final public-name /
  trademark approval remains an owner item.)*
- **G2 - Hosted privacy policy URL.** An in-app `PrivacyPolicyScreen` exists, but
  both stores require a publicly reachable URL on the listing and in the
  data-safety forms. App wiring is done and config-gated (2026-06-12): a valid
  bare-HTTPS `--dart-define=TRUERISE_PRIVACY_POLICY_URL` opens from Settings via
  `url_launcher`, with the in-app screen as default and fallback. What remains
  is owner-side: Legal publishes the canonical page and the same URL goes into
  the build define and store listings.
- **G3 - Privacy labels / Data Safety.** Apple privacy "nutrition" labels and
  the Play Data Safety form, accurate to the real flow: birth data + events are
  PII/sensitive, stored on-device, transmitted only on explicit submit to the
  proxy/provider; demo is fully offline; the share surface is PII-free.
- **G4 - App icon.** Replace the default Flutter glyph with the design-system
  clock-quadrant mark before submission. *(Current state: DONE - iOS
  appiconset + Android adaptive icon assets are in the repo since Impl Run A.3;
  store icon/screenshot review remains owner scope.)*
- **G5 - Bundle id + signing.** Bundle/package ID is implemented as
  `ua.com.truerise.app`; provision release signing (store-submission scope per
  qa-phase8 Section 5.3).
- **G6 - COPPA age gate.** PRD Section 13 requires a born-before-2008 gate on
  the date picker. *(Current state: DONE since Impl Run A.1 - the 18+ floor is
  enforced via `CalculationFlowState.latestAllowedBirthDate` / `lastDate` in
  `birth_data_screen.dart`; covered by
  `test/features/calculation_flow/calculation_flow_controller_test.dart`.)*
- **G7/G8 - Metadata + screenshots.** Already specified by Run 3 (category,
  title/subtitle/keywords, screenshot order). *(Current state: metadata is
  authored - `docs/store-listing-en.md` + localized variants; raw screenshots
  are captured in `screenshots/store/{en,de,fr,es,pt-BR}/`, 5 frames per
  locale. Remaining owner/design work: device-frame/caption compositing, other
  device sizes if required, console upload, owner/design review.)*

**Display-name note for leadership.** G1 is logged here because it is a
publication blocker, but it remains a *config* task. This run does not change it
(code/config out of scope), consistent with Run 3 Section 1 and Section 11 #4.

---

## 6. P1 - Growth / Social Features (Instagram-style Distribution)

This section answers the leadership question directly: *which functions help the
app spread through social/Instagram-style distribution, and what is missing.*

### 6.1 What already exists [VERIFIED] - the text share loop

The privacy-safe **text** share is shipped and is a genuine organic-loop
primitive (Run 1 H3): `ShareCopyBuilder.build()` produces, e.g.,
`"My TrueRise rectification result:\n7:14 AM . Gemini Rising . 78% confidence\n\nCalculated with TrueRise - birth-time rectification"`,
routed through the `rectify/share` channel with a clipboard fallback. It leaks
**no PII** by construction (no birth city/date, events, labels, or API ids). Keep
this exactly as-is; it is the safety model every richer share surface must match.

### 6.2 What is missing - and ranked by leverage x verification cost

| Rank | Feature | Why it is the lever | Leverage | Verification cost | Phase |
|---|---|---|---|---|---|
| 1 | **Privacy-safe share-card IMAGE** (square + 9:16 Story) rendering the same PII-free fields as text | SHIPPED in-repo 2026-06-12 (`StoryCardRenderer` + `shareImagePng`; see status note / G9). Instagram/TikTok are visual; the card is the *unit of distribution* on those platforms | High | High (pixel-level privacy review of the rendered card remains owner scope) | V1.5 (shipped early) |
| 2 | **Share discoverability** (G10): share CTA on the result hero, share from a history row, a post-demo "share this sample" prompt | SHIPPED, VERIFIED (2026-06-12) - no longer missing. Text + image share CTAs on the result (`resultShareButtonKey` / `resultShareImageButtonKey`), history-row share in `home_history_screen.dart`, one-time post-demo prompt (`resultDemoSharePromptKey`, `share_prompt_store.dart`) | Med | Low (done) | P1 (done) |
| 3 | **Analytics on the share loop** (subset of G13): share-tap count, share->return, store referrer | You cannot tell if any of this spreads without it; decides whether to invest in the card | Med-High (decision value) | Med (privacy-bound) | P1 |
| 4 | **Share copy variants** (G11): 2-3 tagline/wording variants | Marginal lift; only meaningful once #3 can measure it | Low-Med | Low | P1 |
| 5 | **Referral / attribution** (G12) | Real referral needs identity/accounts (a V2 non-goal); pre-account, lean on store referrer + the tagline | Low-Med | Med | P2 |

### 6.3 Privacy-safe viral mechanics and safety guardrails (non-negotiable)

Privacy is a **growth requirement here, not a constraint on it** - the category's
trust complaint (Run 2 Section 7) is exactly what a PII-leaking share would
trigger.

- The share-card image MUST render only {rectified time, rising sign, confidence,
  brand}. No birth city, no birth date, no life events, no label, no map, no
  chart. Same allow-list as `ShareCopyBuilder` today.
- The card must carry the probabilistic frame ("most likely" / "% confidence"),
  never a certainty claim (Run 1 Section 2.2).
- A pixel-level review (not just a code review) is an acceptance gate for the card
  - text in an image is easy to leak by accident (e.g. a debug overlay, a
  pre-filled label).
- No auto-posting, no contact-list access, no "invite your friends" address-book
  mechanic (these are policy and trust landmines and pull toward the V2 social
  graph non-goal).

### 6.4 Honest expectation setting

Do not promise virality. The card is necessary for visual-platform spread; it is
not sufficient. Sequence it *after* the analytics baseline (G13) so the decision
to build it - and to invest further - is evidence-led (Run 1 H3 is a test, not a
foregone conclusion).

---

## 7. P1 / P2 - Trust and Credibility Features

These keep TrueRise off the "another horoscope app" shelf (Run 2 Section 7; the
category wins on "is it accurate, can you show me why?").

- **Evidence transparency (HAVE - protect it).** Per-event Strong/Moderate/Weak/
  None + explanation + summary line is already the product's strongest
  differentiator. Expandable detail (G19, PRD F7.5) is verified/shipped:
  `evidence_card.dart` toggles the explanation on tap and
  `evidence_screen.dart` defaults strong/moderate evidence to expanded
  (covered by `cards_test.dart` and `evidence_screen_test.dart`).
- **Confidence explanation (G15, P1 - SHIPPED).** A short "what does 78%
  mean?" explainer that frames confidence as probability, not a guarantee, now
  renders under the confidence bar (`resultConfidenceExplainerKey` in
  `result_screen.dart`; `_ConfidenceExplainer` in `result_screen_sections.dart`;
  l10n keys `resultConfidenceExplainerTitle`/`Body`/`Method` in en/de/es/fr/pt).
  Covered by the "confidence explainer" group in
  `test/widget/features/calculation_flow/result_screen_test.dart`.
- **Low-confidence next steps (G15 companion - SHIPPED, verified 2026-06-12).**
  When the top candidate lands in the low confidence band
  (`ConfidenceBar.isLowBand`), a guidance note (`_LowConfidenceNote` in
  `result_screen_sections.dart`, keyed by `resultLowConfidenceNoteKey`) gives
  concrete next steps: add more dated life events, review birth
  date/city/approximate time, or try a wider birth-time window. l10n in
  en/de/es/fr/pt. Covered by
  `test/widget/features/calculation_flow/result_screen_test.dart`,
  `test/security/probabilistic_framing_test.dart`, and
  `test/widget/l10n/localized_screens_test.dart`.
- **Method explanation (G16, P1 - SHIPPED, GUARDED).** The same explainer gives
  the plain-language "how we calculate this" (transits + progressions scoring
  candidate times) framed as *method*, not *fortune-telling* - building trust
  and reinforcing the Apple 4.3(b) utility posture (Run 3 Section 7.4). The
  three explainer strings are locked into the probabilistic-framing guard
  (`test/security/probabilistic_framing_test.dart`).
- **Probabilistic-framing audit (G17, P1 - DONE).** Result + share + demo
  user-visible English copy verified clean of certainty/medical/legal/financial
  claim language and required to carry a probabilistic marker (design-system
  Section 9.7, PRD Section 13). Locked by
  `test/security/probabilistic_framing_test.dart` (does not cover onboarding or
  ARB metadata).
- **Post-result feedback prompt (G18, P1 - SHIPPED).** Local-only "Does this
  time feel plausible?" (Yes/Not sure/No), stored on device
  (`result_screen_sections.dart` + `lib/data/prefs/result_feedback_store.dart`;
  delete-all-data wipes it; no network, no PII). Enables Run 1 H6 (event-count
  vs believability) at zero backend and zero PII cost.
- **Demo/sample result (HAVE - protect it).** The offline demo is the unique
  pre-sale trust lever no competitor offers (Run 2 Section 4.1). Do not dilute it;
  keep it offline (CLAUDE.md).
- **Privacy posture (HAVE - surface it more).** On-device storage, explicit-submit
  data flow, full wipe, PII-free share. This is a credibility asset; say it
  plainly in the listing and a settings "your data" line.
- **History/export (PARTIAL).** History HAVE; export (PDF/image, G23) is V1.5 and
  is also a competitor table-stake - schedule it there, not now.

---

## 8. P1 / P2 - ASO / Store Asset Features

What the *product* must provide so the store assets land (assets themselves are a
separate design run; this is the code/content readiness behind them).

- **Screenshot-worthy screens (HAVE).** Hero result, evidence breakdown, demo
  badge, and the share surface all already render per Run 3 Section 8's order. No
  code work to screenshot them; needs the real app icon (G4) and display name (G1)
  to avoid "Rectify" leaking into a screenshot frame.
- **Demo data quality (HAVE).** The canonical demo (78/61/44%, Gemini Rising,
  mixed evidence) is realistic-not-idealized per DM5 - good for a screenshot.
  Optional P2: a second demo persona for locale screenshots.
- **Localization-ready copy (UNBLOCKED - G20 done, C.1).** The l10n pipeline and
  DE/FR/ES/PT translations are in-repo, and raw localized in-app screenshots
  exist (`screenshots/store/{de,fr,es,pt-BR}/`). Remaining work is
  native-speaker review + console entry, not a pipeline dependency (Section 9).
- **Store metadata support (READY).** Category, title/subtitle, keyword field, and
  long-description outline are specified in Run 3; no app code needed.
- **Privacy policy / data-safety readiness (P0, G2/G3).** Required before the
  listing can go live; see Section 5.

---

## 9. Localization Feature Gaps (DE / FR / PT-BR / ES)

*(UPDATE 2026-06-12: the Run 4 absence finding below is historical - the l10n
pipeline and DE/FR/ES/PT translations have since landed via Impl Runs C.1 and
D.1-D.4; see the status note and the G20/G22 matrix rows.)*

**Headline correction [historical - VERIFIED at the Run 4 baseline,
2026-06-02].** Run 1 Section 4.2 and Run 3 Section 9 assumed localization was
"ASO text + ~250 strings, no product code change" because implementation-plan
line 1282 planned "all strings extracted into ARB from day one." At the Run 4
baseline that extraction had not been implemented: the read-only run verified
no `*.arb` files, no `l10n.yaml`, no `flutter_localizations` dependency, no
`AppLocalizations` / `localizationsDelegates` / `supportedLocales` /
`generate: true` anywhere in `lib/`; UI strings were hardcoded English literals
(e.g. `result_screen.dart` "Result", "Share result", "See how we got this";
`delete_all_data_sheet.dart` "Delete all data?"). Only `intl` (formatting) was
present.

**Current status (2026-06-12).** G20 is DONE in-repo (Impl Run C.1):
`flutter_localizations` is a dependency, `l10n.yaml` and `generate: true` are
in place, and `lib/l10n/app_{en,de,es,fr,pt}.arb` plus the generated
`AppLocalizations` exist and are wired. G22 translations (DE/FR/ES/PT) landed
via D.1-D.4. Still owner-gated, not app-code work: native-speaker review,
per-locale console keyword re-count, public privacy-policy URL, store console
forms, and proxy/signing.

### 9.1 Preconditions before translation could begin (now satisfied, C.1)

- **G20 - l10n pipeline (the precondition, locale-agnostic) - DONE (C.1).**
  `flutter_localizations` and gen-l10n (`l10n.yaml` + `generate: true`) are set
  up, `lib/l10n/app_en.arb` is the base, `MaterialApp.localizationsDelegates` +
  `supportedLocales` are wired, and user-facing literals in `lib/` are extracted
  into ARB keys. This was a real refactor (Med-High), not a translation task,
  and it landed ahead of the Run 5 locale-set decision as the baseline analysis
  recommended.
- **Demo + result + evidence + error copy** moved into ARB, including the demo
  explanation strings in `lib/data/demo/demo_response.dart` (these are
  user-visible in the demo result).
- **Pluralization + interpolation** (e.g. "X of Y events", the delete-sheet count
  copy) use ICU plural/placeholder forms in ARB, not string concatenation.

### 9.2 What landed after the baseline, and what still waits on the owner

- **Actual DE/FR/PT/ES translations (G22) - DONE in-repo (D.1-D.4).** These
  waited on G20 and the Run 5 Localization Strategy inputs (locale order,
  register, the DE credibility bar W2, PT-BR "10+ events" framing); both are
  now resolved and localized ARBs exist for de/es/fr/pt. Native-speaker review
  and the per-locale console keyword re-count remain owner scope before
  publication.
- **Locale-aware formatting (G21)** - audit verified/shipped (2026-06-12):
  date/time render via `intl` (`AppDateFormat`) across share/result/history in
  both 12h and 24h. Any remaining native-speaker review or per-locale copy
  tuning (e.g. decimal comma in percent copy) is owner scope if needed.
- **Brand token "TrueRise" stays English** in all locales (Run 3 Section 9) - do
  not add it to any ARB for translation.

### 9.3 Implication for sequencing

The localization cost was higher than the strategy docs assumed: it was
**pipeline refactor (G20) + translation (G22)**, not translation alone. Both
have since landed in-repo (C.1, D.1-D.4), so the correction is now historical.
The Tier 1 bet (Run 1 H4) is still sound; remaining sequencing cost is
owner-side only (native-speaker review, per-locale console re-counts, store
forms), not app code.

---

## 10. Publication Readiness Gaps

| Area | Gap | Status | Action |
|---|---|---|---|
| App name config | Display name "Rectify" not "TrueRise" (G1) | DONE (A.1 - display name is TrueRise; trademark/name approval owner-pending) | Owner confirms store name |
| Category | **Lifestyle** on both the App Store and Google Play (post-Appeeky; the earlier Utilities (iOS) / Tools (Play) leg is superseded historical context) | OWNER (recommendation READY/doc - `docs/store-listing-en.md` Section 1/3.4, Run 3 Section 4.1/5) | Owner selects/confirms in store consoles |
| Metadata | Title/subtitle/keywords/short+long desc | READY (Run 3 Section 12) | Console; DE uses Option C |
| Privacy policy | Hosted URL (G2) | PARTIAL (app wiring done, config-gated) | Legal publishes; build with `TRUERISE_PRIVACY_POLICY_URL` + add URL to listings |
| Data safety | Apple labels + Play Data Safety (G3) | PARTIAL (authored prep - `docs/apple-privacy-labels.md` + `docs/play-data-safety.md` map the real flow) | Owner/legal sign-off + console entry |
| App icon | Default Flutter glyph (G4) | DONE (A.3 - iOS appiconset + Android adaptive icon in repo) | Store icon review at submission |
| Bundle id / signing | Lock + provision (G5) | PARTIAL (Bundle/package ID `ua.com.truerise.app` implemented 2026-06-23; Android gradle wiring done 2026-06-12 - no debug fallback, reads `android/key.properties`; owner keystore + iOS signing remain) | Owner: keystore + Play App Signing + iOS distribution signing |
| Age gate | COPPA born-before-2008 (G6) | DONE (A.1 - 18+ floor in the date picker, `birth_data_screen.dart`) | None in app; keep store age-rating answers consistent with the 18+ gate |
| Analytics / attribution | None wired (G13/G14) | MISSING | Privacy-bound decision; can launch without, but launch blind |
| Review-risk: 4.3(b) | Utility framing, no fortune lexicon | MITIGATED (Run 3 Section 7) | Hold metadata + screenshot discipline |
| Review-risk: payment surface | None present | VERIFIED CLEAN | Keep (scope AC3 test guards) |
| Review-risk: permissions | Android INTERNET only; iOS no privacy strings | VERIFIED CLEAN (qa-phase8 Section 4.4/4.5) | Keep |

**Analytics decision is the one judgment call here.** TrueRise *can* ship Tier 0
without analytics (it builds clean today), but it would launch unable to measure
its own north-star or share loop. Recommend a single privacy-respecting SDK
(local-first config, no birth data, no event content) as an early P1 - see G13.

---

## 11. Implementation Sequencing - Next 3 Claude Implementation Runs

After the strategy docs (through Run 5) are approved, these are the first three
*code* runs. Each is scoped to be independently verifiable and to honor the MVP
non-goals (no IAP, no accounts, no social graph, demo stays offline).

### Impl Run A - Pre-publication config gate (unblocks Tier 0 launch)
- Scope: G1 display-name -> "TrueRise"; G4 app icon; G5 bundle-id confirm +
  signing scaffolding; G2 swap to hosted privacy URL (`url_launcher`); G6 verify/
  add COPPA gate; prep G3 data-safety inputs (doc, not code).
- Why first: smallest surface, highest urgency, and it is the literal gate to the
  English launch the whole growth plan assumes.
- Out of scope: any new product feature.

### Impl Run B - Privacy-safe analytics + share-loop instrumentation + share reach
- Scope: G13 single privacy-respecting analytics SDK (no PII, no event content),
  instrument the Section 6.2 funnel events + share-tap/return; G10 share
  discoverability (since shipped + verified 2026-06-12: result CTA emphasis,
  share-from-history, post-demo share prompt); G18 local feedback prompt (since
  shipped); optionally G14 crash reporting if the same SDK choice covers it.
  Remaining Run B scope is the analytics/share-loop measurement (G13), which
  stays future P1.
- Why second: turns the launch from blind to measured and strengthens the
  *existing* (text) loop at low risk - before any expensive card work.
- Out of scope: the share-card image (depends on this baseline).

### Impl Run C - l10n extraction pipeline (locale-agnostic precondition for Tier 1)
- Scope: G20 add `flutter_localizations` + gen-l10n + base `app_en.arb`; extract
  all hardcoded user-facing strings (incl. demo copy) into ARB with ICU
  plural/placeholder forms; wire `MaterialApp`; G21 formatting audit. English
  behavior unchanged.
- Why third: it is a refactor that can run independently and is the gate for the
  DE/FR/PT/ES translation work that Run 5 will plan; doing it before translations
  means Tier 1 becomes a translation job, finally making the strategy-doc
  assumption true.
- Out of scope: the actual translations (G22) - those wait on Run 5 + this
  pipeline.

**Deferred to a later run (V1.5, explicitly not in the first three):** the
privacy-safe **share-card image** (G9). It is the #1 growth feature but is gated
on (a) the V1.5 scope opening, (b) the analytics baseline from Impl Run B telling
us the loop is worth the investment, and (c) a pixel-level privacy review.

---

## 12. Acceptance Criteria and Verification Checklist (per batch)

### Impl Run A - acceptance
- [ ] Installed app icon label reads "TrueRise" on both iOS and Android (manual
  device/simulator check); `CFBundleName=rectify` unchanged and app identity is
  `ua.com.truerise.app`.
- [ ] Privacy-policy link opens the hosted URL (manual); in-app fallback still
  reachable.
- [ ] Date picker rejects DOB after 2007-12-31 (widget test).
- [ ] App icon is the brand glyph, not the Flutter default (visual).
- [ ] `flutter analyze` clean; `flutter test` green; iOS + Android release builds
  succeed (per qa-phase8 build commands).
- [ ] Data-safety/label inputs drafted and matched to the real data flow (doc
  review).

### Impl Run B - acceptance
- [ ] Analytics events fire for the Section 6.2 funnel + share tap (debug log).
- [ ] **No-PII test:** an automated test asserts no event payload contains birth
  date, city, lat/lon, life-event text/category, label, or API id (PRD Section 13).
- [ ] Demo path remains network-free (extend the offline assertion to cover the
  analytics SDK in demo - no calls).
- [x] (G10 - done, verified 2026-06-12) Share CTA reachable from a result AND a
  history row; post-demo share prompt appears once per demo result
  (`test/widget/features/calculation_flow/result_share_test.dart`,
  `test/widget/features/calculation_flow/result_demo_share_prompt_test.dart`,
  `test/widget/features/home/home_history_share_test.dart` - 22 tests).
- [ ] Share still emits the PII-free string unchanged (existing share test holds).
- [x] (G18 - done) feedback answer persists locally, no network
  (`test/data/prefs/result_feedback_store_test.dart`,
  `test/data/repos/settings_repository_test.dart`,
  `test/widget/features/calculation_flow/result_screen_test.dart`).
- [ ] `flutter analyze` + `flutter test` green.

### Impl Run C - acceptance
- [ ] `l10n.yaml` + `app_en.arb` exist; `flutter gen-l10n` produces
  `AppLocalizations`; `MaterialApp` wires delegates + `supportedLocales`.
- [ ] No hardcoded user-facing string literals remain in `lib/` (grep/lint or a
  custom test asserting widgets read from `AppLocalizations`).
- [ ] English UI is byte-for-byte unchanged to the user (golden tests green).
- [ ] Plurals/counts ("X of Y events", delete-sheet count) use ICU forms, verified
  at count = 0/1/many (widget test).
- [x] (G21 - date/time done, verified 2026-06-12) `intl` formatters drive
  date/time (12h/24h) on share/result/history via `AppDateFormat` +
  `ShareCopyBuilder` (`app_date_format_test.dart`, `share_copy_builder_test.dart`,
  result-share/settings/history widget tests - 64 tests); percent formatting
  remains a separate copy/locale review.
- [ ] `flutter analyze` + `flutter test` (incl. goldens) green.

### Share-card image (future V1.5) - acceptance (recorded now, not for the first 3)
- [ ] Rendered card contains ONLY time + rising + confidence + brand; pixel review
  confirms no PII (manual, blocking).
- [ ] Card carries the probabilistic frame; no certainty/medical/legal text.
- [ ] Export works offline for a demo result; no network in demo.
- [ ] No auto-post, no contacts access.

---

## 13. Risks and Non-Goals (do NOT build yet)

- **Share-card image before a privacy review (G9).** High user-trust blast radius
  if PII leaks into pixels. Gate on pixel review + V1.5 scope; do not rush it into
  pre-publication to chase the Instagram question.
- **Analytics that capture PII or event content (G13).** Would violate PRD
  Section 13 and is the category's exact trust complaint. Privacy-bound or not at
  all.
- **IAP / paywall / credits (G24).** V1.5; out of the growth phase entirely (Run 1
  Section 10). Do not let "trial/credit" competitor framing pull it forward.
- **Accounts / social graph / referral-by-identity / multi-device sync.** V2
  non-goals (PRD Section 8). Real referral needs identity - skip pre-account.
- **PDF / full report (G23).** Competitor table-stake but V1.5; high complexity +
  PII surface. Not now.
- **India / Hindi marketing + Vedic/KP method.** Gated on KP framing (Run 1
  Section 4.3); a "wrong method" review risk if marketed early.
- **Head-term ASO** (astrology/horoscope/zodiac) and **fortune-telling lexicon.**
  Burns relevance and invites Apple 4.3(b) (Run 3 Section 7).
- **Chart rendering, push notifications, Apple Watch/widget.**
  V2 / post-MVP (PRD Section 8 / Section 17). The in-app review prompt,
  originally deferred here, is since implemented in-repo as a neutral
  OS-owned prompt with tests; rating metrics remain App Store Connect /
  Play Console scope, and no rating impact is claimed.
- **Diluting the offline demo.** It is the unique conversion + trust lever; keep
  it offline and network-free (CLAUDE.md).

**Distraction check.** Every item above either creates policy/privacy risk, is
high-complexity for the current stage, or pulls focus from the long-tail BTR
utility positioning. The disciplined path is: ship Tier 0 (Impl Run A) -> measure
(Impl Run B) -> unlock Tier 1 (Impl Run C) -> then, evidence in hand, invest in
the share card and V1.5.

---

## 14. Source / Evidence Appendix

**Project docs (authoritative for product decisions):**
- `docs/growth-thesis.md` (Run 1) - Section 2 category/anti-positioning,
  Section 4 locale tiers + "no product code change" assumption (corrected in
  Section 9 here), Section 5 north-star, Section 6 metric tree + Section 6.5 "no
  analytics SDK", Section 9 D1-D5, Section 10 non-goals, H1/H3/H4/H6 hypotheses.
- `docs/competitor-aso-research.md` (Run 2) - Section 3 competitor map, Section 4
  direct BTR (Vedic Samay Utilities, Cosmic Birthtime PDF), Section 5
  anti-positioning, Section 6 locale vocabulary, Section 7 review axis, Section 8
  screenshot patterns, Section 10 Apple 4.3(b), Section 12.2 feature-gap note.
- `docs/aso-naming-strategy.md` (Run 3) - Section 1 display-name correction,
  Section 4-6 metadata, Section 7 policy-safe copy, Section 8 screenshot order,
  Section 9 localization, Section 11 validation checklist.
- `docs/prd.md` - Section 4 personas, F1-F10 functional reqs, Section 8 non-goals,
  Section 13 privacy/security, Section 16 risks, Section 17 phases (V1.5 share
  card / PDF / Hindi / KP).
- `docs/mvp-scope.md` - M1-M13 must-haves, S1-S4 should-haves, deferred table,
  DM1-DM5 demo requirements, AC1-AC8.
- `docs/qa-phase8-report.md` - Section 4 security/permissions, Section 5 build,
  Section 6 deferred blockers (Crashlytics, hosted privacy URL, bundle id, app
  icon, on-device smoke).
- `docs/implementation-plan.md` - line 1282 (planned "ARB from day one"; not
  implemented at the Run 4 baseline, since implemented via C.1 - see Section 9),
  Section 9.5 API modes.
- `docs/marketing-research.md` - reused only via Run 1/Run 2 citations; no new
  external figure introduced.

**Code / config verified at the Run 4 baseline (2026-06-02, read-only) -
historical snapshot, not current truth; superseded items are listed in the
current-status block immediately below:**
- `lib/core/sharing/share_copy_builder.dart`, `share_service.dart` - PII-free
  text share + `rectify/share` channel + clipboard fallback.
- `lib/features/calculation_flow/screens/result_screen.dart` - share button
  (`resultShareButtonKey`), hero, confidence, candidates, demo nudge.
- `lib/data/demo/demo_response.dart` - canonical offline demo data.
- `lib/features/settings/delete_all_data_sheet.dart`,
  `lib/features/settings/privacy_policy_screen.dart` - wipe + in-app policy.
- `lib/features/calculation_flow/screens/life_events_screen.dart:136` - soft
  5-event warning.
- `lib/features/onboarding/onboarding_controller.dart` - onboarding persistence.
- `lib/providers/core_providers.dart`, `lib/data/api/*` - proxy/provider/demo API
  modes, `proxy.invalid.example` fail-fast.
- `pubspec.yaml` - at the Run 4 baseline showed NO `in_app_purchase`,
  `firebase*`, `sentry`, `posthog`, `share_plus`, screenshot/render-to-image,
  or `flutter_localizations`; `intl` present. (Historical: `share_plus` and
  `flutter_localizations` have since been added - see the current-status block
  below.)
- `ios/Runner/Info.plist` (`CFBundleDisplayName=Rectify`),
  `android/app/src/main/AndroidManifest.xml` (`android:label="rectify"`) -
  display-name mismatch (G1).
- Absence checks (historical, Run 4 baseline): at 2026-06-02 there were no
  `*.arb` files, no `l10n.yaml`, and no `AppLocalizations`/
  `localizationsDelegates`/`supportedLocales`/`generate: true` in `lib/` (G20).

**Current repo status (2026-06-12), superseding the Run 4 baseline where
noted:**
- `pubspec.yaml` now includes `share_plus` and `flutter_localizations`;
  `in_app_purchase`, `firebase*`, `sentry`, and `posthog` remain absent.
- `lib/core/sharing/story_card_renderer.dart` exists (share-card PNG, G18).
- `l10n.yaml` and `generate: true` exist; `lib/l10n/app_{en,de,es,fr,pt}.arb`
  and the generated `AppLocalizations` are in the repo (G20/G22 in-repo done).
- Still owner-gated, not app-code done: native-speaker review of DE/FR/ES/PT,
  per-locale console keyword re-count, public privacy-policy URL, store console
  forms, and proxy/signing.

No live ranking, rating, install count, review count, or trademark clearance is
asserted in this document; all such items remain in the Run 3 Section 11
validation checklist.
