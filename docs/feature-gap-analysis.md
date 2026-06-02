# Feature Gap Analysis - TrueRise / Rectify (Run 4)

**Version:** 1.0 (Run 4 - Feature Gap Analysis)
**Date:** 2026-06-02
**Model:** claude-opus-4-8 (run invoked explicitly under this model)
**Status:** Implementation-ready backlog for leadership; input to Run 5 (Localization Strategy)
**Linked to:** `docs/growth-thesis.md` (Run 1), `docs/competitor-aso-research.md`
  (Run 2), `docs/aso-naming-strategy.md` (Run 3), `docs/prd.md`,
  `docs/mvp-scope.md`, `docs/qa-phase8-report.md`, `docs/marketing-research.md`

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

**What the product already has [VERIFIED].** TrueRise ships a complete, offline
demo loop and a real-calculation loop: onboarding -> birth data + geocoding ->
time window -> life events (12 categories, soft 5-event warning) -> loading ->
ranked result (time + rising + confidence) -> per-event evidence -> history with
swipe-delete -> full data wipe. A three-mode API path (proxy / user-key /
demo-`.env`) keeps the provider secret off-device. Critically for the leadership
question, a **privacy-safe text share is already shipped**: `ShareCopyBuilder`
emits only time + rising + confidence + a "Calculated with TrueRise" tagline,
with **zero PII** (no birth city/date, no events, no labels, no API ids).

**What is missing [VERIFIED gaps].** Three things stand out. (1) The home-screen
app name is still **"Rectify"/"rectify"**, not "TrueRise" - a publication-blocking
config mismatch. (2) The shipped share is **text only**; there is no
privacy-safe **share-card image**, which is the actual unit of distribution on
Instagram/TikTok (visual platforms do not spread plain text). (3) There is **no
analytics or telemetry of any kind** wired, so the north-star (RRC/wk) and the
share-loop hypothesis (Run 1 H3) are currently **unmeasurable**. A fourth gap
corrects a strategy-doc assumption: the localization pipeline was *planned*
("ARB from day one", implementation-plan line 1282) but **was never built** - no
ARB files, no `flutter_localizations`, strings are hardcoded English. DE/FR/PT/ES
therefore need a real string-extraction refactor, not just translation.

**Top 3 feature priorities.**

1. **P0 - Pre-publication config gate** (display-name alignment to TrueRise,
   hosted privacy-policy URL, store privacy/data-safety labels, real app icon,
   bundle-ID confirmation). Pure store-policy blockers; no new product surface.
   Unblocks the Tier 0 English launch the whole growth plan depends on.
2. **P1 (highest growth leverage, V1.5) - Privacy-safe share-card IMAGE.** The
   one feature that converts the shipped (text) share loop into something that
   can actually spread on Instagram/TikTok. Explicitly V1.5 per PRD Section 17;
   gated on a pixel-level privacy review. Ranked #1 of growth features but *not*
   pulled into pre-publication.
3. **P1 - Privacy-safe funnel + share-loop analytics.** Cheap, high
   decision-value: without it, RRC/wk, demo->real conversion, and H3 cannot be
   measured, and every later growth bet is blind. Must exclude birth data and
   event content (PRD Section 13).

**Honest framing (no virality overclaim).** A text share does not make an app go
viral, and neither will a share card by itself. The share card is ranked first
among growth features because it is the *precondition* for any visual-platform
distribution, not because it guarantees it. Rank everything below by leverage x
verification cost, and measure before scaling.

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
| Draft persistence / retry-with-inputs primitive | SHIPPED (partial) | `data/repos/draft_repository.dart`; scope S3 (full "save and retry later" still open per qa-phase8 Section 6) |
| API path: 3 modes (proxy default, provider-direct via user key, demo `.env` fallback); fail-fast `proxy.invalid.example` default | SHIPPED | `lib/providers/core_providers.dart`, `data/api/api_client.dart` (`buildDio`, `mapDioException`), `rectification_api.dart`, `mappers.dart`; PRD Section 11 / M6 |
| Pro/Dev API key in device keychain (never SQLite/prefs) | SHIPPED | `data/secure/secure_key_store.dart`, `proApiKeyProvider`; PRD F9.1 / AC4 |
| Settings (time format 12/24h, demo toggle, version, privacy link, delete-all) | SHIPPED | `features/settings/*`; PRD F9 / M11 |
| In-app privacy policy screen | SHIPPED | `features/settings/privacy_policy_screen.dart`, `app/router.dart` (hosted URL still missing - see Section 5) |
| **Privacy-safe result share - TEXT ONLY** | SHIPPED | `lib/core/sharing/share_copy_builder.dart` (PII-free: time + rising + confidence + tagline), `share_service.dart` (`rectify/share` channel + clipboard fallback), `result_screen.dart` `_ShareResultButton` / `resultShareButtonKey` |
| No payment / IAP surface anywhere | VERIFIED ABSENT (by design) | no `in_app_purchase` in `pubspec.yaml`; `test/security/no_payment_or_secret_strings_test.dart`; PRD F10 / scope AC3 |
| No analytics / crash-reporting SDK | VERIFIED ABSENT | no `firebase*`, `sentry`, `posthog`, `amplitude` in `pubspec.yaml` or `lib/`; growth-thesis Section 6.5 |
| No share-card image / screenshot-render package | VERIFIED ABSENT | no `share_plus`, no `screenshot`/render-to-image package in `pubspec.yaml`; share is a custom MethodChannel |
| No localization pipeline (ARB / `flutter_localizations`) | VERIFIED ABSENT | no `*.arb`, no `l10n.yaml`, no `AppLocalizations`/`localizationsDelegates`/`generate: true`; only `intl` for formatting. Corrects implementation-plan line 1282 ("ARB from day one") which was never built |
| Post-result feedback prompt (S1 "does this feel plausible?") | NOT BUILT | no feedback-prompt widget in `lib/` (only demo copy contains "plausible"); scope S1 (Should-Have); growth-thesis H6 depends on it |
| COPPA age gate (born before 2008) | UNVERIFIED | required by PRD Section 13; not confirmed in code this run - flag for P0 verification |

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
strength), and a **shareable artefact** (PARTIAL - text only; image/PDF MISSING).
The shareable artefact is the single most consistent competitor feature TrueRise
has not yet matched, and it is also the growth lever - see Sections 6 and 11.

---

## 4. Gap Matrix

Columns: Growth impact / ASO-store impact / Policy risk / Complexity are
qualitative (High/Med/Low). Phase: P0 (pre-publication), P1 (first growth wave),
V1.5 (gated on the V1.5 cut), P2 (later). "Owner" is the lead function.

| # | Feature / gap | Evidence source | Current status | Growth | ASO/store | Policy risk | Complexity | Phase | Owner notes |
|---|---|---|---|---|---|---|---|---|---|
| G1 | Display-name -> "TrueRise" (`CFBundleDisplayName`, `android:label`) | Run 3 Section 1; `ios/Runner/Info.plist`, `android/.../AndroidManifest.xml` [VERIFIED still "Rectify"/"rectify"] | MISSING | Med | High | Low | Low (config) | P0 | Config only, not a code edit. Bundle id stays `com.rectify.rectify` |
| G2 | Hosted privacy-policy URL (replace/augment in-app screen) | PRD Section 13; qa-phase8 Section 6; Run 3 Section 11 #12 | PARTIAL (in-app screen exists) | Low | High (both stores require) | High if absent | Low (Legal + 1-line `url_launcher`) | P0 | Legal publishes canonical URL |
| G3 | App Store privacy labels + Play Data Safety form | PRD Section 13; store policy | MISSING | Low | High | High if wrong | Low-Med (form, no code) | P0 | Must match actual data flow (on-device + proxy/provider) |
| G4 | Real app icon (not default Flutter glyph) | qa-phase8 Section 6 | MISSING | Low | High (listing quality) | Low | Low-Med (design + `flutter_launcher_icons`) | P0 | Blocks store, not demo |
| G5 | Bundle-id + release-signing lock | qa-phase8 Section 5.3 / Section 6 | OPEN | Low | High (submission) | Low | Low | P0 | Confirm `com.rectify.rectify`; provision signing |
| G6 | COPPA age gate (born before 2008) | PRD Section 13 | UNVERIFIED | Low | Med | High if missing | Low | P0 | Verify in date picker; add if absent |
| G7 | Store metadata (category Utilities/Tools, title/subtitle/keywords) | Run 3 Sections 4-6, 12 | READY (doc) | Med | High | Med (4.3(b)) | Low (console, no code) | P0 | Copy from Run 3 Option H (DE uses Option C) |
| G8 | Store screenshots (hero -> evidence -> demo -> share) | Run 3 Section 8 | MISSING | Med | High | Low | Med (design) | P0 | Lead with the tool, not zodiac art |
| G9 | **Privacy-safe share-card IMAGE** (Stories/feed) | PRD Section 17; Run 1 H3; Run 3 Section 8 | MISSING | **High** | Med | **Med-High (PII in pixels)** | Med-High | **V1.5** | The Instagram lever; pixel-level privacy review mandatory |
| G10 | Share discoverability (prominent CTA, share from history, post-demo share prompt) | `result_screen.dart` (share only on result); Run 1 H3 | PARTIAL | Med | Low | Low (reuse PII-free builder) | Low | P1 | Cheap multiplier on the existing loop |
| G11 | Share copy variants / light A-B | `share_copy_builder.dart` (single string) | MISSING | Low-Med | Low | Low | Low | P1 | Only meaningful once analytics exist (G13) |
| G12 | Referral / install attribution | no accounts (PRD Section 8) | MISSING | Low-Med | Low | Med (privacy) | Med | P2 | Limited pre-account; rely on store referrer + tagline first |
| G13 | **Privacy-safe funnel + share-loop analytics** | growth-thesis Section 6; [VERIFIED no SDK] | MISSING | **High (enables measurement)** | Med | **High (must exclude PII/events)** | Med | P1 | Without it RRC/wk + H3 are blind; explicit privacy decision (PRD Section 13) |
| G14 | Crash reporting (Crashlytics/Sentry) | qa-phase8 Section 6 | DEFERRED | Low | Med (quality) | Med (PII in payloads) | Med | P1 | Pairs with G13 SDK decision |
| G15 | Confidence explanation ("what 78% means") | PRD F6; Run 2 Section 7 | MISSING | Med | Low | Low | Low (content) | P1 | Anti-commodity trust surface |
| G16 | Method explanation ("transits + progressions") | PRD F6.5; Run 3 Section 7.4 | PARTIAL | Med | Low | Low-Med (keep "method" not "fortune") | Low (content) | P1 | Reads as a tool, supports 4.3(b) |
| G17 | Probabilistic-framing audit on result + share | Run 1 Section 2.2; design-system Section 9.7 | LIKELY-PRESENT, verify | Low | Low | High if violated | Low | P1 | Confirm no certainty language anywhere |
| G18 | Post-result feedback prompt (S1) | scope S1; growth-thesis H6 | NOT BUILT | Med (enables H6) | Low | Low (local only, no PII) | Low | P1 | One local question; no backend |
| G19 | Expandable evidence detail | PRD F7.5 | VERIFY | Low | Med (screenshot depth) | Low | Low | P2 | Confirm vs PRD F7.5 |
| G20 | **l10n extraction pipeline** (`flutter_localizations` + gen-l10n + ARB + wiring) | [VERIFIED absent]; corrects impl-plan line 1282 | MISSING | Med (unlocks Tier 1) | High (locale ASO) | Low | Med-High (refactor) | P1 (pre-Tier-1) | Precondition for DE/FR/PT/ES; locale-agnostic |
| G21 | Locale-aware formatting audit (date/time/percent) | `intl` present; impl-plan line 1282 | PARTIAL | Low | Med | Low | Low | P1 | Verify `intl` formatters used, not hand-rolled |
| G22 | Translated ASO metadata + UI strings (DE/FR/PT/ES) | Run 1 Section 4.2; Run 3 Section 9 | BLOCKED on G20 | Med | High | Med (DE credibility) | Med (translation) | V1.5 | After pipeline + Run 5 strategy |
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
  `android/app/src/main/AndroidManifest.xml`]. Keep `com.rectify.rectify` and
  `CFBundleName=rectify`. This is the single highest-confusion-risk pre-launch
  item and the cheapest to fix.
- **G2 - Hosted privacy policy URL.** An in-app `PrivacyPolicyScreen` exists, but
  both stores require a publicly reachable URL on the listing and in the
  data-safety forms. Legal publishes the canonical page; swap/augment the in-app
  screen with `url_launcher`.
- **G3 - Privacy labels / Data Safety.** Apple privacy "nutrition" labels and
  the Play Data Safety form, accurate to the real flow: birth data + events are
  PII/sensitive, stored on-device, transmitted only on explicit submit to the
  proxy/provider; demo is fully offline; the share surface is PII-free.
- **G4 - App icon.** Replace the default Flutter glyph with the design-system
  clock-quadrant mark before submission.
- **G5 - Bundle id + signing.** Confirm `com.rectify.rectify`; provision release
  signing (store-submission scope per qa-phase8 Section 5.3).
- **G6 - COPPA age gate [UNVERIFIED].** PRD Section 13 requires a born-before-2008
  gate on the date picker; not confirmed in code this run. Verify; add if absent.
- **G7/G8 - Metadata + screenshots.** Already specified by Run 3 (category,
  title/subtitle/keywords, screenshot order). No code; console + design work.

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
| 1 | **Privacy-safe share-card IMAGE** (square + 9:16 Story) rendering the same PII-free fields as text | Instagram/TikTok are visual; plain text does not post or spread there. The card is the *unit of distribution* on those platforms | High | High (must privacy-review rendered pixels; needs a render-to-image dependency) | V1.5 |
| 2 | **Share discoverability** (G10): share CTA on the result hero, share from a history row, a post-demo "share this sample" prompt | Multiplies use of the loop that already exists, at near-zero risk (reuses the PII-free builder) | Med | Low | P1 |
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
  differentiator. Confirm expandable detail (G19, PRD F7.5).
- **Confidence explanation (G15, P1).** A short, tappable "what does 78% mean?"
  that frames confidence as probability, not a guarantee. Low effort, directly
  answers the category's #1 doubt.
- **Method explanation (G16, P1).** A plain-language "how we calculate this"
  (transits + progressions scoring candidate times) framed as *method*, not
  *fortune-telling* - this both builds trust and reinforces the Apple 4.3(b)
  utility posture (Run 3 Section 7.4).
- **Probabilistic-framing audit (G17, P1).** Sweep result + share + demo copy to
  confirm zero certainty/medical/legal language (design-system Section 9.7, PRD
  Section 13). Likely already clean; verify and lock with a test.
- **Post-result feedback prompt (G18, P1).** Local-only "Does this feel
  plausible?" (Yes/Not sure/No), stored on device. Enables Run 1 H6 (event-count
  vs believability) at zero backend and zero PII cost. NOT built today.
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
- **Localization-ready copy (BLOCKED on G20).** Store metadata can be localized in
  console now, but **in-app** screenshots in DE/FR/PT/ES require the l10n pipeline
  first (Section 9). This is the main asset-readiness dependency.
- **Store metadata support (READY).** Category, title/subtitle, keyword field, and
  long-description outline are specified in Run 3; no app code needed.
- **Privacy policy / data-safety readiness (P0, G2/G3).** Required before the
  listing can go live; see Section 5.

---

## 9. Localization Feature Gaps (DE / FR / PT-BR / ES)

**Headline correction [VERIFIED].** Run 1 Section 4.2 and Run 3 Section 9 assume
localization is "ASO text + ~250 strings, no product code change" because
implementation-plan line 1282 planned "all strings extracted into ARB from day
one." **That extraction was never implemented.** This run verified: no `*.arb`
files, no `l10n.yaml`, no `flutter_localizations` dependency, no `AppLocalizations`
/ `localizationsDelegates` / `supportedLocales` / `generate: true` anywhere in
`lib/`; UI strings are hardcoded English literals (e.g. `result_screen.dart`
"Result", "Share result", "See how we got this"; `delete_all_data_sheet.dart`
"Delete all data?"). Only `intl` (formatting) is present.

### 9.1 Must exist in code/content BEFORE translation begins

- **G20 - l10n pipeline (the precondition, locale-agnostic).** Add
  `flutter_localizations`, set up gen-l10n (`l10n.yaml` + `generate: true`),
  create the base `app_en.arb`, wire `MaterialApp.localizationsDelegates` +
  `supportedLocales`, and extract every user-facing literal in `lib/` into ARB
  keys. This is a real refactor (Med-High), not a translation task, and it is
  independent of *which* locales ship - so it can start as soon as it is
  greenlit, ahead of the Run 5 locale-set decision.
- **Demo + result + evidence + error copy** must all move into ARB, including the
  demo explanation strings in `lib/data/demo/demo_response.dart` (these are
  user-visible in the demo result).
- **Pluralization + interpolation** (e.g. "X of Y events", the delete-sheet count
  copy) must use ICU plural/placeholder forms in ARB, not string concatenation.

### 9.2 What can wait

- **Actual DE/FR/PT/ES translations (G22)** wait on both G20 and the Run 5
  Localization Strategy (locale order, register, the DE credibility bar W2,
  PT-BR "10+ events" framing).
- **Locale-aware formatting (G21)** is a smaller follow-on: confirm date/time/
  percent render via `intl` for the target locales (24h default in DE/FR, decimal
  comma, etc.). Audit, not rebuild.
- **Brand token "TrueRise" stays English** in all locales (Run 3 Section 9) - do
  not add it to any ARB for translation.

### 9.3 Implication for sequencing

The localization cost is higher than the strategy docs assumed: it is
**pipeline refactor (G20) + translation (G22)**, not translation alone. The Tier 1
bet (Run 1 H4) is still sound, but its cost line must include G20. Run 5 should
plan around this corrected baseline.

---

## 10. Publication Readiness Gaps

| Area | Gap | Status | Action |
|---|---|---|---|
| App name config | Display name "Rectify" not "TrueRise" (G1) | MISSING | Config change pre-submission |
| Category | Utilities (iOS) / Tools (Play) | READY (Run 3 Section 4.1/5) | Select in console |
| Metadata | Title/subtitle/keywords/short+long desc | READY (Run 3 Section 12) | Console; DE uses Option C |
| Privacy policy | Hosted URL (G2) | PARTIAL | Legal publishes; wire `url_launcher` |
| Data safety | Apple labels + Play Data Safety (G3) | MISSING | Fill to match real flow |
| App icon | Default Flutter glyph (G4) | MISSING | Design + generate |
| Bundle id / signing | Lock + provision (G5) | OPEN | Confirm + sign |
| Age gate | COPPA born-before-2008 (G6) | UNVERIFIED | Verify/add |
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
  discoverability (result CTA emphasis, share-from-history, post-demo share
  prompt); optional G18 local feedback prompt; optionally G14 crash reporting if
  the same SDK choice covers it.
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
  device/simulator check); `CFBundleName=rectify` and `com.rectify.rectify`
  unchanged.
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
- [ ] Share CTA reachable from a result AND a history row; post-demo share prompt
  appears once per demo result (widget tests).
- [ ] Share still emits the PII-free string unchanged (existing share test holds).
- [ ] (If G18) feedback answer persists locally, no network (widget + storage
  test).
- [ ] `flutter analyze` + `flutter test` green.

### Impl Run C - acceptance
- [ ] `l10n.yaml` + `app_en.arb` exist; `flutter gen-l10n` produces
  `AppLocalizations`; `MaterialApp` wires delegates + `supportedLocales`.
- [ ] No hardcoded user-facing string literals remain in `lib/` (grep/lint or a
  custom test asserting widgets read from `AppLocalizations`).
- [ ] English UI is byte-for-byte unchanged to the user (golden tests green).
- [ ] Plurals/counts ("X of Y events", delete-sheet count) use ICU forms, verified
  at count = 0/1/many (widget test).
- [ ] `intl` formatters drive date/time/percent (no hand-rolled formatting on
  user-visible numbers) - audit.
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
- **Chart rendering, push notifications, in-app review prompt, Apple Watch/widget.**
  V2 / post-MVP (PRD Section 8 / Section 17).
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
- `docs/implementation-plan.md` - line 1282 (planned "ARB from day one",
  not implemented - see Section 9), Section 9.5 API modes.
- `docs/marketing-research.md` - reused only via Run 1/Run 2 citations; no new
  external figure introduced.

**Code / config verified in this run (2026-06-02, read-only):**
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
- `pubspec.yaml` - confirms NO `in_app_purchase`, `firebase*`, `sentry`,
  `posthog`, `share_plus`, screenshot/render-to-image, or `flutter_localizations`;
  `intl` present.
- `ios/Runner/Info.plist` (`CFBundleDisplayName=Rectify`),
  `android/app/src/main/AndroidManifest.xml` (`android:label="rectify"`) -
  display-name mismatch (G1).
- Absence checks: no `*.arb`, no `l10n.yaml`, no `AppLocalizations`/
  `localizationsDelegates`/`supportedLocales`/`generate: true` in `lib/` (G20).

No live ranking, rating, install count, review count, or trademark clearance is
asserted in this document; all such items remain in the Run 3 Section 11
validation checklist.
