# TrueRise Post-Launch Growth Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Improve TrueRise store conversion, first ratings, organic discoverability, and measured growth after both App Store and Google Play publication.

**Architecture:** Treat growth as a sequence of small, verifiable releases. Store-console work is tracked separately from repo work; repo work produces screenshots, docs, privacy-safe instrumentation, and release artifacts, while App Store Connect / Play Console actions are verified with dated evidence captures. Paid acquisition is gated until the store pages, ratings, and measurement loop can support traffic.

**Tech Stack:** Flutter/Dart app, App Store Connect, Google Play Console, App Store Product Page Optimization, Google Play Store Listing Experiments, Google Play Custom Store Listings, static landing site under `site/`, local docs under `docs/`, store screenshots under `screenshots/store/`.

## Global Constraints

- Current live baseline on 2026-07-02: App Store and Google Play are both live as `TrueRise: Birth Time Finder`, category `Lifestyle`, version `1.0.3`.
- App Store current public state: iOS version `1.0.3`, released `2026-07-01T04:35:40Z`, rating count `0`, languages `EN`.
- Google Play current public state: version `1.0.3`, updated `Jun 30, 2026`, category `Lifestyle`, package `ua.com.truerise.app`.
- Copy must keep probabilistic framing: use `estimate`, `most likely`, `candidate`, `confidence`; do not claim exact, guaranteed, definitive, deterministic, medical, psychological, legal, or financial value.
- No fake reviews, incentivized reviews, incentivized installs, keyword stuffing, competitor-brand keywords, hidden features, or misleading screenshots.
- Demo mode must stay offline and quota-free.
- Share and analytics surfaces must not include birth date, birthplace, coordinates, event text, labels, API keys, result IDs, contacts, or destination app names.
- Preserve unrelated working-tree changes; do not touch `site/version.json`, `test/unit/core/update/update_info_test.dart`, or `android/build/` unless a later task explicitly owns them.

---

## File And Console Map

- Create: `docs/growth/live-store-baseline-2026-07-02.md` - dated live-store evidence and risks.
- Modify: `screenshots/store/en/manifest.json` - final five-frame English screenshot order.
- Modify: `screenshots/store/de/manifest.json`, `screenshots/store/es/manifest.json`, `screenshots/store/fr/manifest.json`, `screenshots/store/pt-BR/manifest.json` - localized final screenshot orders after EN is accepted.
- Read/use: `screenshots/store/en-current-draft/01-problem-hook.png`, `screenshots/store/en-current-draft/02-life-events.png` - draft raw frames for the current story order.
- Generate: `screenshots/store/<locale>/composited/*.png` - final captioned screenshots only after manifests are no longer blocked.
- Create: `docs/growth/store-experiments-2026-07.md` - PPO / Play experiment definitions and results.
- Create: `docs/growth/review-acquisition-runbook.md` - compliant first-review plan and response templates.
- Create: `docs/growth/localization-rollout-2026-07.md` - native-review and publication checklist for DE/FR/ES/PT-BR.
- Create: `docs/growth/measurement-plan-2026-07.md` - metrics, events, privacy boundaries, and weekly reporting.
- Create: `docs/growth/custom-pages-and-listings-2026-07.md` - Apple CPP / Google custom listing map.
- Modify only if measurement implementation is approved: `lib/core/analytics/app_analytics.dart`, `test/unit/analytics/app_analytics_test.dart`, `docs/privacy-policy.md`, `docs/apple-privacy-labels.md`, `docs/play-data-safety.md`.
- Console: App Store Connect - screenshot slots, Product Page Optimization, Custom Product Pages, promotional text, What’s New.
- Console: Google Play Console - main listing, Store Listing Experiments, Custom Store Listings, ratings/reviews, store performance.

---

### Task 1: Capture Live Baseline And Screenshot Slot Risk

**Files:**
- Create: `docs/growth/live-store-baseline-2026-07-02.md`
- Read: `docs/post-launch-aso-plan.md`
- Read: `docs/store-listing-en.md`

**Interfaces:**
- Produces: a dated baseline document used by every later task.
- Blocks: Task 2 until App Store iPhone screenshot slot status is known.

- [ ] **Step 1: Capture public iOS state**

Run:

```bash
curl -s --max-time 20 'https://itunes.apple.com/lookup?id=6783427864&country=us' \
  | jq '.results[0] | {
      trackName,
      sellerName,
      primaryGenreName,
      version,
      currentVersionReleaseDate,
      userRatingCount,
      languageCodesISO2A,
      screenshotUrls,
      ipadScreenshotUrls,
      trackViewUrl
    }'
```

Expected:
- `trackName` is `TrueRise: Birth Time Finder`.
- `primaryGenreName` is `Lifestyle`.
- `version` is `1.0.3`.
- `userRatingCount` is `0`.
- `languageCodesISO2A` is `["EN"]`.
- If `screenshotUrls` is empty, mark `P0 screenshot slot audit` as open.

- [ ] **Step 2: Capture public Google Play state**

Run:

```bash
curl -L -A 'Mozilla/5.0' --max-time 20 -s \
  'https://play.google.com/store/apps/details?id=ua.com.truerise.app&hl=en_US&gl=US' \
  | perl -0777 -ne '
    print "title=TrueRise: Birth Time Finder\n" if /TrueRise: Birth Time Finder - Apps on Google Play/;
    print "category=Lifestyle\n" if /\[\[\"Lifestyle\"/;
    print "version=1.0.3\n" if /\[\[\[\"1\.0\.3\"\]\]/;
    print "updated=Jun 30, 2026\n" if /\[\"Jun 30, 2026\"/;
    print "rating=Everyone\n" if /\[\"Everyone\"/;
  '
```

Expected:
- All five lines print.

- [ ] **Step 3: Verify App Store Connect screenshot slots**

Open App Store Connect for Apple ID `6783427864`.

Check:
- iPhone 6.7" screenshot slot contains five screenshots.
- iPhone 6.5" / required fallback slots are filled if App Store Connect requires them.
- iPad screenshots are not the only populated slot.

Decision:
- If iPhone slots are filled, record `OK - public Lookup empty screenshotUrls is not a console blocker`.
- If iPhone slots are empty, stop store experiments and complete Task 2 before any promotion.

- [ ] **Step 4: Save baseline document**

Create `docs/growth/live-store-baseline-2026-07-02.md` with:

```markdown
# TrueRise Live Store Baseline - 2026-07-02

## Verified Public State

- App Store: TrueRise: Birth Time Finder, Lifestyle, version 1.0.3, released 2026-07-01T04:35:40Z, rating count 0, languages EN.
- Google Play: TrueRise: Birth Time Finder, Lifestyle, package ua.com.truerise.app, version 1.0.3, updated Jun 30, 2026.

## Immediate Risks

- App Store iPhone screenshot slot status: [replace with OK or OPEN after Step 3].
- First ratings: 0 public ratings on App Store.
- Localization: live public App Store language is EN only.

## Next Task

Proceed to Task 2 if screenshot slots are open or raw screenshots need conversion uplift. Otherwise proceed to Task 3.
```

- [ ] **Step 5: Commit baseline**

Run:

```bash
git add docs/growth/live-store-baseline-2026-07-02.md
git commit -m "docs: capture live store growth baseline"
```

Expected:
- One docs-only commit.

---

### Task 2: Finalize Store Screenshot Story

**Files:**
- Modify: `screenshots/store/en/manifest.json`
- Use: `screenshots/store/en-current-draft/01-problem-hook.png`
- Use: `screenshots/store/en-current-draft/02-life-events.png`
- Generate after approval: `screenshots/store/en/composited/*.png`
- Modify after EN approval: localized manifests under `screenshots/store/{de,es,fr,pt-BR}/manifest.json`

**Interfaces:**
- Consumes: Task 1 screenshot slot decision.
- Produces: final screenshots for App Store Connect and Play Console.

- [ ] **Step 1: Confirm current screenshot inventory**

Run:

```bash
find screenshots/store -maxdepth 3 -type f \( -name '*.png' -o -name 'manifest.json' \) | sort
```

Expected:
- Canonical locale packs exist under `screenshots/store/en`, `de`, `es`, `fr`, `pt-BR`.
- Draft current-plan frames exist under `screenshots/store/en-current-draft`.

- [ ] **Step 2: Update English manifest to final five-frame order**

Set English frame order to:

1. `01-problem-hook.png` - caption `Don't know your exact birth time?`
2. `02-life-events.png` - caption `Add the life events you remember.`
3. `01-result-hero.png` - caption `Estimate your birth time and rising sign.`
4. `02-evidence-breakdown.png` - caption `See the evidence behind every candidate.`
5. `03-privacy-demo-settings.png` - caption `Private by default. Try it free, offline.`

Implementation rule:
- Either copy the two draft raw frames into the canonical EN folder and update paths, or recapture them directly into `screenshots/store/en/`.
- Do not use `04-share-result.png` as one of the first five frames; keep it as optional bonus material.

- [ ] **Step 3: Remove final-composite blockers from EN manifest**

In `screenshots/store/en/manifest.json`:
- Set `captionPlanStatus` to `current_post_appeeky_5_frame_ready`.
- Set `currentCaptionPlanRequiresNewFrames` to `false`.
- Keep `captionsBakedIn` as `false`.

- [ ] **Step 4: Preview compositor plan**

Run:

```bash
dart run tool/store_screenshot_compositor_write.dart --verbose
```

Expected:
- EN is not listed as blocked.
- Other locales may still be blocked until their manifests are updated.
- No files are written.

- [ ] **Step 5: Generate final EN composites through the guarded Flutter path**

Use the existing Flutter-compatible write harness pattern. If a direct project command is not available, add a focused temporary or committed harness only for the EN write path, then run it against the real renderer and real repository root.

Acceptance criteria:
- `screenshots/store/en/composited/01-problem-hook.png` exists.
- `screenshots/store/en/composited/02-life-events.png` exists.
- `screenshots/store/en/composited/01-result-hero.png` exists.
- `screenshots/store/en/composited/02-evidence-breakdown.png` exists.
- `screenshots/store/en/composited/03-privacy-demo-settings.png` exists.
- Each output is `1290 x 2796`.
- Captions do not overlap app UI.
- Text fits on mobile preview.

- [ ] **Step 6: Visual QA**

Open each composited PNG and check:
- Frame 1 states the user problem.
- Frame 2 shows actual life-event input.
- Frame 3 shows estimated time, rising sign, and confidence.
- Frame 4 shows per-event evidence.
- Frame 5 shows privacy/offline demo.
- No screenshot implies guaranteed accuracy.
- No screenshot exposes real personal data.

- [ ] **Step 7: Upload EN screenshots**

Console actions:
- App Store Connect: upload EN final composites to iPhone screenshot slots first.
- Google Play Console: upload the same EN final composites to phone screenshots.

Verification:
- Public store page shows first three images in the intended order after propagation.
- App Store Lookup `screenshotUrls` issue is rechecked after propagation.

- [ ] **Step 8: Commit EN screenshot work**

Run:

```bash
git add screenshots/store/en screenshots/store/en-current-draft docs/growth/live-store-baseline-2026-07-02.md
git commit -m "chore(store): finalize English screenshot story"
```

Expected:
- Commit includes only screenshot assets/manifests and baseline status update.

---

### Task 3: Launch First Store Page Experiments

**Files:**
- Create: `docs/growth/store-experiments-2026-07.md`
- Read: `docs/store-listing-en.md`
- Read: `docs/post-launch-aso-plan.md`

**Interfaces:**
- Consumes: Task 2 final screenshot assets.
- Produces: experiment definitions and results.

- [ ] **Step 1: Define Experiment A - first screenshot**

Create `docs/growth/store-experiments-2026-07.md` with this exact first experiment:

```markdown
# TrueRise Store Experiments - July 2026

## Experiment A - First Screenshot Hook

Hypothesis: a problem-first screenshot improves product-page conversion versus a result-first screenshot for users who do not already know birth-time rectification.

Platforms:
- iOS: Product Page Optimization.
- Google Play: Store Listing Experiment.

Control:
- First screenshot: result hero.

Variant:
- First screenshot: "Don't know your exact birth time?"

Success metric:
- Store product-page conversion rate: product page views to first-time downloads.

Guardrails:
- Do not change title, subtitle, short description, icon, or price during this experiment.
- Do not run paid traffic changes during this experiment.
- Run for at least 7 days or until the console reports a clear result.
```

- [ ] **Step 2: Configure iOS PPO**

In App Store Connect:
- Create Product Page Optimization test named `2026-07 First Screenshot Hook`.
- Use one treatment.
- Treatment changes screenshots only.
- Allocate 50% treatment traffic if current traffic is low.
- Keep icon and preview video unchanged.

Record in the doc:
- Start date.
- Traffic split.
- Treatment asset names.

- [ ] **Step 3: Configure Play Store Listing Experiment**

In Play Console:
- Create a store listing experiment for graphics/screenshots.
- Control is current EN screenshot order.
- Variant swaps first screenshot to the problem hook.
- Keep short description, full description, icon, and feature graphic unchanged.

Record in the doc:
- Start date.
- Country / language.
- Variant asset names.

- [ ] **Step 4: Weekly readout**

Every 7 days record:

```markdown
## Experiment A Readout - YYYY-MM-DD

- iOS status:
- iOS conversion delta:
- Play status:
- Play conversion delta:
- Decision: continue / apply winner / stop inconclusive.
- Notes:
```

- [ ] **Step 5: Commit experiment tracking doc**

Run:

```bash
git add docs/growth/store-experiments-2026-07.md
git commit -m "docs: define first store page experiment"
```

---

### Task 4: Build The First-Review Loop

**Files:**
- Create: `docs/growth/review-acquisition-runbook.md`
- Read: `lib/features/reviews/review_prompt_controller.dart`
- Read: `lib/features/reviews/review_invitation.dart`
- Read: `test/unit/reviews/review_strings_compliance_test.dart`

**Interfaces:**
- Produces: compliant first-rating workflow.
- Blocks: paid traffic until at least one review/rating baseline exists or the review request loop is confirmed working.

- [ ] **Step 1: Verify in-app review implementation**

Run:

```bash
flutter test test/unit/reviews/review_prompt_controller_test.dart test/unit/reviews/review_strings_compliance_test.dart
```

Expected:
- Tests pass.
- Review prompt copy does not mention stars or rewards.

- [ ] **Step 2: Create review runbook**

Create `docs/growth/review-acquisition-runbook.md`:

```markdown
# TrueRise First Review Runbook

## Goal

Collect honest first reviews without incentives, gating, star requests, or manipulation.

## Allowed review moments

- After a user completes a demo result and opens evidence.
- After a user completes a live result and opens evidence.
- After a user shares a result.

## Disallowed review moments

- Cold app launch.
- Before result screen.
- After an error.
- In exchange for extra attempts, discounts, keys, support, or features.
- With any mention of "5 stars".

## Manual outreach text

Thanks for trying TrueRise. If the result and evidence were useful, an honest App Store or Google Play review helps us understand whether this should be improved further. No pressure - feedback is useful either way.

## Review response rules

- Thank the user.
- Address the issue they named.
- Do not ask for a higher rating.
- Link only to support when it helps solve the issue.
- Never debate astrology belief or certainty; repeat that TrueRise provides estimates with evidence.
```

- [ ] **Step 3: Prepare support response templates**

Add templates to the same file:

```markdown
## Response Templates

### Positive review
Thank you for trying TrueRise. We built it to make uncertain birth times easier to work with while keeping the result honest and evidence-based.

### Accuracy concern
Thanks for the feedback. TrueRise estimates the most likely time from the events entered; it is not a guaranteed answer. Adding more dated events can change the confidence and candidate ranking.

### Privacy concern
Thanks for raising this. Demo mode runs offline. Live calculations send only the details needed to compute the result over HTTPS, and the app has no accounts, ads, analytics SDK, or tracking.

### Bug report
Thanks for reporting this. Please email support@truerise.com.ua with the device model, app version, and the screen where it happened so we can reproduce it.
```

- [ ] **Step 4: Commit review runbook**

Run:

```bash
git add docs/growth/review-acquisition-runbook.md
git commit -m "docs: add first review acquisition runbook"
```

---

### Task 5: Publish Tier-1 Localizations

**Files:**
- Create: `docs/growth/localization-rollout-2026-07.md`
- Read: `docs/store-listing-tier1-localized.md`
- Read: `lib/l10n/app_de.arb`, `lib/l10n/app_es.arb`, `lib/l10n/app_fr.arb`, `lib/l10n/app_pt.arb`
- Modify after approval: localized screenshot manifests and generated assets.

**Interfaces:**
- Consumes: Task 2 screenshot pattern.
- Produces: DE/FR/ES/PT-BR store pages and localized conversion surfaces.

- [ ] **Step 1: Create localization rollout tracker**

Create `docs/growth/localization-rollout-2026-07.md`:

```markdown
# TrueRise Localization Rollout - July 2026

## Locales

- de
- fr
- es
- pt-BR

## Gates Per Locale

- Native or near-native review completed.
- Name/subtitle/keyword fields recounted in App Store Connect.
- Play title and short description recounted in Play Console.
- Screenshot captions reviewed.
- Store privacy / age / support fields unchanged and valid.
- No deterministic or medical/legal/financial claims introduced.

## Publication Order

1. de
2. fr
3. es
4. pt-BR

## Reason

Germany and France have strong credibility expectations, so they validate the strictest wording first. Spanish and Brazilian Portuguese follow after the wording pattern is stable.
```

- [ ] **Step 2: Native review DE**

Review these fields:
- App name / subtitle.
- Keyword field.
- Full description.
- Screenshot captions.
- Review prompt copy in `lib/l10n/app_de.arb`.
- Share copy in `lib/l10n/app_de.arb`.

Decision:
- If accepted, mark `de native review: accepted`.
- If changes are required, patch localized docs/ARB and run localized tests before console entry.

- [ ] **Step 3: Publish DE metadata**

Console actions:
- Add DE App Store localization.
- Add DE Google Play listing or translation.
- Upload DE screenshots after final compositing.

Verification:
- Public App Store locale URL renders DE metadata.
- Play `hl=de` URL renders DE metadata.

- [ ] **Step 4: Repeat for FR, ES, PT-BR**

Apply the same native-review and publication checklist. Do not publish a locale without the native-review line marked accepted in `docs/growth/localization-rollout-2026-07.md`.

- [ ] **Step 5: Commit localization rollout evidence**

Run:

```bash
git add docs/growth/localization-rollout-2026-07.md screenshots/store/de screenshots/store/es screenshots/store/fr screenshots/store/pt-BR lib/l10n docs/store-listing-tier1-localized.md
git commit -m "chore(store): prepare tier one localization rollout"
```

---

### Task 6: Establish Measurement Without Violating Privacy Promise

**Files:**
- Create: `docs/growth/measurement-plan-2026-07.md`
- Optional modify after approval: `lib/core/analytics/app_analytics.dart`
- Optional modify after approval: `test/unit/analytics/app_analytics_test.dart`
- Optional modify after approval: `docs/privacy-policy.md`
- Optional modify after approval: `docs/apple-privacy-labels.md`
- Optional modify after approval: `docs/play-data-safety.md`

**Interfaces:**
- Produces: weekly growth dashboard and a separate implementation decision for any remote analytics.
- Blocks: paid acquisition scaling.

- [ ] **Step 1: Create measurement plan**

Create `docs/growth/measurement-plan-2026-07.md`:

```markdown
# TrueRise Measurement Plan - July 2026

## North Star

Real Rectifications Completed per Week.

## Store Metrics

- App Store product page views.
- App Store first-time downloads.
- App Store product page conversion.
- Google Play store listing visitors.
- Google Play first-time installers.
- Google Play store listing conversion.
- Ratings count.
- Average rating.
- Review themes.

## In-App Privacy Boundary

Allowed event names:
- app_open
- demo_started
- demo_completed
- live_started
- live_completed
- evidence_opened
- result_shared_text
- result_shared_image
- review_prompt_shown
- review_prompt_confirmed

Allowed event properties:
- app_version
- platform
- locale
- event_name
- timestamp_day

Forbidden event properties:
- birth date
- birthplace
- coordinates
- life-event category
- life-event text
- result time
- rising sign
- confidence
- calculation id
- API key
- contact
- destination app
```

- [ ] **Step 2: Decide measurement mode**

Choose one:
- Mode A: Store-console only for first 14 days.
- Mode B: Add privacy-safe remote analytics with the allowed event schema above.

Decision rule:
- Use Mode A if store conversion and ratings are the only immediate questions.
- Use Mode B before paid acquisition, because paid traffic needs install-to-result visibility.

- [ ] **Step 3A: Mode A weekly report**

Each Monday add:

```markdown
## Weekly Readout - YYYY-MM-DD

- App Store page views:
- App Store downloads:
- App Store conversion:
- Google Play visitors:
- Google Play installers:
- Google Play conversion:
- Ratings count:
- Reviews received:
- Top issue:
- Decision for next week:
```

- [ ] **Step 3B: Mode B implementation spec**

If Mode B is chosen, create a separate implementation plan before coding. It must:
- Update privacy policy and store privacy declarations before release.
- Add tests proving forbidden fields cannot be recorded.
- Record event names and coarse day timestamp only.
- Keep delete-all-data behavior accurate.

- [ ] **Step 4: Commit measurement plan**

Run:

```bash
git add docs/growth/measurement-plan-2026-07.md
git commit -m "docs: define privacy-safe growth measurement plan"
```

---

### Task 7: Create Custom Pages And Listings For Intent Segments

**Files:**
- Create: `docs/growth/custom-pages-and-listings-2026-07.md`
- Modify if needed: `site/index.html`, `site/how-to-find-birth-time/index.html`, `site/what-is-birth-time-rectification/index.html`, `site/natal-chart-time-accuracy/index.html`

**Interfaces:**
- Consumes: Task 3 experiment result and Task 6 measurement decision.
- Produces: destination-specific pages for organic links, creator links, and later ads.

- [ ] **Step 1: Define segment map**

Create:

```markdown
# TrueRise Custom Pages And Listings - July 2026

## Apple Custom Product Pages

### CPP 1 - Unknown Birth Time
- Audience: users searching "unknown birth time" or "find my birth time".
- Lead screenshot: problem hook.
- Promo text: Estimate an unknown birth time from real life events. Demo mode is free and offline.

### CPP 2 - Rising Sign Uncertain
- Audience: users who know astrology apps but do not know exact birth time.
- Lead screenshot: result hero.
- Promo text: Your rising sign depends on birth time. TrueRise estimates a likely time and shows the evidence.

### CPP 3 - Privacy-First
- Audience: privacy-sensitive users and creators.
- Lead screenshot: privacy/offline demo.
- Promo text: Try a full offline demo before entering real birth data.

## Google Play Custom Store Listings

### Listing 1 - unknown-birth-time
- URL parameter: unknown-birth-time
- Short description: Estimate an unknown birth time from life events.

### Listing 2 - rising-sign
- URL parameter: rising-sign
- Short description: Estimate your birth time, rising sign & natal chart from life events.

### Listing 3 - privacy-first
- URL parameter: privacy-first
- Short description: Private birth-time estimates with an offline demo.
```

- [ ] **Step 2: Configure Apple CPPs**

In App Store Connect:
- Create the three CPPs above.
- Use screenshots matching the segment.
- Do not change the app name.
- Submit CPPs for review.

- [ ] **Step 3: Configure Google Play custom listings**

In Play Console:
- Create the three custom store listings above.
- Use URL targeting first.
- Reuse the default category, contact details, and privacy policy.

- [ ] **Step 4: Add landing links**

Update site pages so relevant sections point to:
- Default store links for general traffic.
- Segment custom listing URLs for specific pages once live.

Verification:

```bash
python3 -m unittest test/site_seo_static_test.py
```

Expected:
- Tests pass.

- [ ] **Step 5: Commit custom page/listing plan and site changes**

Run:

```bash
git add docs/growth/custom-pages-and-listings-2026-07.md site test/site_seo_static_test.py
git commit -m "feat(site): route growth pages to store intent listings"
```

---

### Task 8: Tighten Metadata And Release Notes

**Files:**
- Modify: `docs/store-listing-en.md`
- Create or update: `docs/growth/store-copy-changelog-2026-07.md`

**Interfaces:**
- Produces: safer, clearer store copy changes for next metadata submission.

- [ ] **Step 1: Replace generic update notes in next release**

Use this exact next `What's New` candidate:

```text
Improved store-ready release for TrueRise 1.0.3: offline demo, evidence review, privacy-safe sharing, and clearer update handling.
```

If the store rejects mention of store-ready release, use:

```text
Improved the offline demo, evidence review, privacy-safe sharing, and update handling.
```

- [ ] **Step 2: Refresh promotional text**

Use:

```text
Estimate an unknown birth time from real life events. Try the full demo offline before entering your own details.
```

Constraints:
- Under 170 characters.
- No keyword stuffing.
- No price claims.

- [ ] **Step 3: Commit copy changelog**

Run:

```bash
git add docs/store-listing-en.md docs/growth/store-copy-changelog-2026-07.md
git commit -m "docs: prepare next store copy refresh"
```

---

### Task 9: Creator And Organic Outreach

**Files:**
- Create: `docs/growth/creator-outreach-2026-07.md`

**Interfaces:**
- Consumes: Task 7 custom URLs.
- Produces: non-paid traffic experiments.

- [ ] **Step 1: Create creator outreach brief**

Create:

```markdown
# TrueRise Creator Outreach - July 2026

## Target Creator Types

- Astrology educators explaining birth charts.
- Creators who explain rising signs.
- Creators who answer "I don't know my birth time" questions.
- Newsletter/blog authors in astrology education.

## Offer

Free tool demo for content about unknown birth time. No claim that TrueRise is exact. The content angle is: "what to do when you don't know your birth time."

## Short Pitch

Hi [name],

I built TrueRise, a small app for people who don't know their exact birth time. It estimates a likely time from dated life events and shows a confidence score with event-by-event evidence. The full demo runs offline, so people can see how it works before entering real details.

If you ever cover rising signs or unknown birth times, this may be useful as a practical tool to mention. It is an estimate, not a guaranteed answer.

App Store: https://apps.apple.com/app/truerise-birth-time-finder/id6783427864
Google Play: https://play.google.com/store/apps/details?id=ua.com.truerise.app
Website: https://truerise.com.ua/
```

- [ ] **Step 2: Prepare tracking sheet**

Add columns:
- Creator
- Channel
- Contact URL
- Audience fit
- Sent date
- Reply
- Store URL used
- Notes

- [ ] **Step 3: Send 20 targeted pitches**

Rules:
- No mass spam.
- Personalize the first sentence.
- Do not offer payment for positive reviews.
- Do not ask creators to claim accuracy.

- [ ] **Step 4: Commit outreach brief**

Run:

```bash
git add docs/growth/creator-outreach-2026-07.md
git commit -m "docs: add creator outreach brief"
```

---

### Task 10: Paid Acquisition Gate

**Files:**
- Create: `docs/growth/paid-acquisition-gate-2026-07.md`

**Interfaces:**
- Consumes: Task 3, Task 4, Task 6.
- Produces: decision to start or defer paid traffic.

- [ ] **Step 1: Create paid gate**

Create:

```markdown
# TrueRise Paid Acquisition Gate - July 2026

## Paid Traffic Is Blocked Until

- Store screenshots are final and live.
- First store experiment has a winner or an inconclusive result after a full run.
- Review loop is active and compliant.
- Measurement mode is selected.
- At least one of these is true:
  - in-app purchase exists, or
  - the goal is a capped learning test with a fixed loss budget.

## Allowed First Campaign

- Apple Search Ads Search Results only.
- One English market.
- Exact match only.
- Daily cap: owner-defined fixed loss budget before launch.

## Allowed Keywords

- birth time rectification
- birth time finder
- find my birth time
- unknown birth time
- rectify birth time

## Disallowed Keywords

- astrology
- horoscope
- zodiac
- psychic
- tarot
- co-star
- chani
- competitor app names
```

- [ ] **Step 2: Decide first paid test**

Decision:
- If no monetization and no fixed learning budget, defer paid traffic.
- If learning budget is approved, run exact-match ASA only and stop at the budget cap.

- [ ] **Step 3: Commit paid gate**

Run:

```bash
git add docs/growth/paid-acquisition-gate-2026-07.md
git commit -m "docs: define paid acquisition gate"
```

---

## Execution Order

1. Task 1 - live baseline and screenshot slot audit.
2. Task 2 - final screenshot story and upload.
3. Task 3 - first screenshot A/B experiment.
4. Task 4 - first-review loop.
5. Task 5 - Tier-1 localizations.
6. Task 6 - measurement plan and analytics decision.
7. Task 7 - custom pages/listings.
8. Task 8 - metadata/release-note refresh.
9. Task 9 - creator outreach.
10. Task 10 - paid acquisition gate.

## Stop Conditions

- Stop before Task 3 if App Store iPhone screenshot slots are empty.
- Stop before Task 5 if native review is unavailable for a locale.
- Stop before any remote analytics implementation if privacy policy and store declarations are not updated first.
- Stop before paid acquisition if measurement mode is not selected.
- Stop any tactic that requires incentivized reviews, fake installs, hidden functionality, or misleading claims.

## Final Verification

Run after every repo-affecting task:

```bash
git diff --check
```

Run after any Flutter code change:

```bash
flutter analyze
flutter test
```

Run after any static-site change:

```bash
python3 -m unittest test/site_seo_static_test.py
```

Run before claiming a store state changed:

```bash
curl -s --max-time 20 'https://itunes.apple.com/lookup?id=6783427864&country=us' | jq '.results[0] | {version,currentVersionReleaseDate,userRatingCount,languageCodesISO2A,screenshotUrls,ipadScreenshotUrls}'
curl -L -A 'Mozilla/5.0' --max-time 20 -s 'https://play.google.com/store/apps/details?id=ua.com.truerise.app&hl=en_US&gl=US' | rg -n 'TrueRise: Birth Time Finder|Estimate your birth time|Lifestyle|1.0.3'
```

