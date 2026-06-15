# Post-Launch ASO Plan - TrueRise

- **Document:** `docs/post-launch-aso-plan.md`
- **Date:** 2026-06-15
- **Model:** `claude-opus-4-8`
- **Status:** `[PLAN]` - local-only planning. Nothing here is executed against a
  live listing, an Appeeky account, an Apple Search Ads account, or any store
  console. It is the runbook to follow *after* the App Store / Google Play
  listing is live and the owner/billing actions below are taken.
- **Linked to:** `docs/competitor-aso-research.md` (Run 2 + Appeeky update
  Sec. 15), `docs/aso-naming-strategy.md` (Run 3 + Appeeky update Sec. 14),
  `docs/store-listing-en.md`, `docs/store-listing-tier1-localized.md`,
  `docs/growth-thesis.md`.

This plan closes the locally preparable post-launch ASO items. The work that
genuinely cannot run pre-launch (direct Appeeky audit, live rank tracking,
real PPO tests, Apple Search Ads) is written up as a runbook to execute once the
listing is live - it is not claimed as done.

---

## 1. Current status (pre-launch)

- **The listing is not live.** TrueRise has no published App Store / Google Play
  record yet, so every "live-listing-dependent" tool below is blocked.
- **Appeeky direct tools are locked until live.** Appeeky's ASO Audit,
  Opportunities, and rank-tracking tools cannot run on TrueRise because the
  manual app entry is "Not yet live"
  (`docs/competitor-aso-research.md` Sec. 15, Audit access limitation). They stay
  locked until the App Store listing is published.
- **The pre-launch Appeeky values are already exported.** Competitor keyword
  ranks + ratings/review counts and the `birth time` / `rising sign` / `rectify`
  popularity/difficulty scores are recorded in
  `docs/competitor-aso-research.md` Sec. 15.1 / 15.2. They do **not** need to be
  re-pulled before launch; the metadata interpretation built on them lives in
  `docs/aso-naming-strategy.md` Sec. 14.
- **Appeeky subscription is an owner/billing action, not a repo action.**
  Cancelling the Appeeky subscription now (the direct tools are locked, so the
  monthly cost has no further pre-launch return) and resubscribing at live launch
  (`docs/competitor-aso-research.md` Sec. 15.3) are account/billing decisions made
  in the Appeeky account by the owner. This repo does not perform, automate, or
  assert them.
- **2026-06-15 recheck - still pre-live; surfaced values are stale.** A same-day
  recheck (`docs/competitor-aso-research.md` Sec. 15.4) re-confirmed TrueRise is
  still "Not yet live" in Appeeky. The Opportunities view can show a breadcrumb /
  header reading `TRUERISE: BIRTH TIME FINDER`, but that header is **not** proof
  of valid TrueRise Opportunities - the underlying table still returned stale
  Vedic / Samay rows (`samaysheet`, `samaya`, `vedic astrology`) that are not
  TrueRise signal and must not drive metadata. Current Tracking was **0/100**, and
  Keyword Intelligence / rankings stay locked until the listing is live. The
  category field still showed **Utilities**, which is stale source metadata, not a
  reversal of the **Lifestyle** recommendation (`docs/store-listing-en.md` Sec. 1).
  The real Appeeky Audit / Opportunities / rank pull therefore remains an
  **after-live** action (Sec. 2), not something to run or trust pre-live.

**What is preparable now (and is done in this doc):** the after-live runbook
(Sec. 2), the tracking term set (Sec. 3), the experimentation matrix with honest
test mechanisms (Sec. 4), the per-locale keyword-research workflow (Sec. 5), and
the Apple Search Ads low-budget prep (Sec. 6).

---

## 2. After-live runbook - Appeeky ASO Audit + Opportunities

Run this only once the listing is published and indexed. Steps marked
**[owner/billing]** are account actions, not repo actions. Do **not** fabricate
or commit invented audit screenshots; only save real exports captured from a live
account.

### 2.1 Preconditions

1. App Store (and/or Google Play) listing is **live** and the app is findable by
   name in the store.
2. **[owner/billing]** Resubscribe to Appeeky for 1-2 months
   (`docs/competitor-aso-research.md` Sec. 15.3).
3. **[owner/billing]** Add/confirm the live TrueRise entry in Appeeky so the
   manual app entry flips from "Not yet live" to the live listing, which unlocks
   the direct tools (`docs/competitor-aso-research.md` Sec. 15).

> **Note (2026-06-15 recheck):** until that "Not yet live" -> live flip happens,
> an Opportunities breadcrumb / header that reads `TRUERISE: BIRTH TIME FINDER`
> is **not** proof the tool is returning valid TrueRise Opportunities - pre-live
> it still returned stale Vedic / Samay rows and Current Tracking was 0/100
> (Sec. 1; `docs/competitor-aso-research.md` Sec. 15.4). Only trust the
> Opportunities / rank data captured **after** the entry is live; this rerun is
> an after-live action only.

### 2.2 Run the audit + opportunities

4. Run the **ASO Audit** against the live listing. Capture the overall score and
   the per-area breakdown (title/subtitle/keywords/description/screenshots/
   ratings) as the tool presents them.
5. Run **Opportunities** and capture the recommended keyword adds/swaps, the
   reachable-term list, and any metadata change Appeeky suggests against the live
   index (not the pre-launch explorer estimates in Sec. 15.2).
6. Start **rank tracking** for the Sec. 3 term set and take a dated baseline
   snapshot.

### 2.3 What to save (real exports only)

- Save Appeeky's own CSV/PDF exports where the tool offers them, plus dated
  screenshots of the Audit score, the Opportunities list, and the first
  rank-tracking baseline.
- Suggested location and naming, to be created at capture time (not now):
  `docs/aso-audit-live/` with files like
  `appeeky-audit-YYYY-MM-DD.<png|csv|pdf>`,
  `appeeky-opportunities-YYYY-MM-DD.*`, and
  `appeeky-ranks-YYYY-MM-DD.*`. Capture from the live account; do not generate
  placeholder images.
- Keep the same evidence discipline as Sec. 15: these are **third-party tool
  figures**, dated, not direct store reads - label them so.

### 2.4 Which docs to update (after the real audit exists)

- `docs/competitor-aso-research.md` - add a new dated subsection under Sec. 15
  (e.g. "15.4 Live ASO Audit") recording the real audit/opportunity/rank
  figures; clearly separate them from the pre-launch Sec. 15.1/15.2 estimates.
- `docs/aso-naming-strategy.md` Sec. 14 - reconcile the recommended metadata
  (title/subtitle/keyword field/category) against the live Opportunities; if a
  change is warranted, propose it there with the before/after rationale.
- `docs/store-listing-en.md` (and `docs/store-listing-tier1-localized.md` if a
  locale field changes) - update the ready-to-paste strings only if the live
  audit justifies a change, then re-count in console.
- `docs/claude-build-history.md` - append a stage entry per the Documentation
  Protocol.

---

## 3. Tracking setup (post-launch rank tracking)

Track exactly these five terms in Appeeky (and any secondary rank tracker) once
the listing is live - the set agreed in
`docs/competitor-aso-research.md` Sec. 15.3 and
`docs/aso-naming-strategy.md` Sec. 14.6:

1. `rectify birth time`
2. `birth time finder`
3. `birth time rectification`
4. `rising sign`
5. `ascendant`

Reading guidance (from the pre-launch data, to interpret the live ranks against):

- `rectify birth time` / `birth time rectification` are the ownable, low-
  competition niche (difficulty 27 / 52, 0/50 in-name; Sec. 15.2) - expect these
  to be the most winnable.
- `birth time finder` is reachable for a focused app (TimePassages ranks #8;
  Sec. 15.1) but noisy (Sec. 15.2).
- `rising sign` and `ascendant` carry the volume but are held by incumbents with
  tens to hundreds of thousands of reviews; at a zero-review launch treat these
  as conversion / long-tail surface, not day-one ranking targets
  (`docs/aso-naming-strategy.md` Sec. 14.1).

Cadence: weekly snapshot for the first 4-6 weeks, then monthly. Always date each
snapshot and label it third-party tool data.

---

## 4. A/B / experimentation matrix

**Accuracy note - what Apple PPO can and cannot test.** Apple
**Product Page Optimization (PPO)** natively A/B tests only the **app icon,
screenshots, and app preview video** against the default page. PPO **cannot** test the **title,
subtitle, or keyword field** - those are metadata, not page treatments. Custom
Product Pages (CPP) likewise vary only screenshots/video/promo text, not the
title/subtitle. So title/subtitle experiments are **not** native A/B tests; they
require **sequential metadata releases** (ship variant A, measure, ship variant
B, compare with the seasonality caveat) and/or **indirect learnings** from Apple
Search Ads (which exact terms convert) and CPP audiences. Google Play **Store
Listing Experiments** can A/B icon, screenshots, short and full description, but
not the app title in the same native way - treat Play title changes as sequential
releases too.

**Priority: spend real native A/B budget on the first screenshot and the icon.**
Those are the elements PPO/Play experiments can actually test and that move
tap-through and conversion most.

| Element | Variants | Test mechanism (honest) | Native A/B? | Priority |
|---|---|---|---|---|
| **First screenshot** | A: hero result (estimated time + rising + confidence) vs B: problem-hook ("Don't know your exact birth time?") | iOS PPO treatment; Play Store Listing Experiment | **Yes** | **1 (do first)** |
| **App icon** | Current TrueRise mark vs one alternate (same brand, higher contrast/legibility at small size) | iOS PPO treatment; Play Store Listing Experiment | **Yes** | **2** |
| **Screenshot order / captions** | Post-Appeeky 5-frame order (`docs/store-listing-en.md` Sec. 5) vs an alternate caption set | iOS PPO / Play experiment | **Yes** | 3 |
| **Title** | `TrueRise: Birth Time Finder` vs `Birth Time Finder: TrueRise` (keyword-first) | **Sequential metadata release** + ASA term-conversion read; **not** a PPO test | No (sequential) | 4 (slow, confounded) |
| **Subtitle** | A: `Estimate your rising sign` (current, Appeeky) vs B: `Rectify your birth time` (earlier default, keeps the rectify intent) | **Sequential metadata release** + ASA read; **not** a PPO test | No (sequential) | 5 (slow, confounded) |

Notes:

- The two title candidates and the two subtitle candidates are exactly the live
  options in `docs/aso-naming-strategy.md` Sec. 4.2 / Sec. 14.1 and
  `docs/store-listing-en.md` Sec. 2.1 / Sec. 2.2 - this matrix does not invent
  new copy.
- Run **one** sequential metadata change at a time (title OR subtitle, not both),
  hold the creative constant, and allow a multi-week window so a metadata test is
  not confounded by a simultaneous screenshot test or by seasonality.
- Keep every visible variant inside the Sec. 6 compliance guardrails of
  `docs/store-listing-en.md` (no `exact`/`guaranteed` as a result claim; no
  fortune-telling lexicon).

---

## 5. Per-locale keyword research workflow (DE / FR / ES / PT-BR)

**This is keyword research, not translation.** The localized strings in
`docs/store-listing-tier1-localized.md` are machine-drafted starting points; they
are not validated keyword sets and not native-approved. Each locale needs its own
local keyword research, native review, and console recount before anything is
published.

Workflow per locale (DE, FR, ES, PT-BR):

1. **Seed.** Start from the seed terms already in repo:
   - `docs/growth-thesis.md` Sec. 7.2 (per-locale long-tail candidates),
   - `docs/aso-naming-strategy.md` Sec. 6.3 (locale direction),
   - the per-locale keyword fields in `docs/store-listing-tier1-localized.md`
     (DE Sec. 4, FR Sec. 5, ES Sec. 6, PT-BR Sec. 7).
   Head seeds (see those docs for the exact accented strings):
   - **DE:** Geburtszeitkorrektur, Geburtszeit berechnen, Geburtszeit unbekannt,
     Aszendent berechnen (stretch).
   - **FR:** rectification heure de naissance, calculer / trouver mon heure de
     naissance, heure de naissance inconnue, calcul ascendant (stretch).
   - **ES:** rectificacion hora de nacimiento, calcular hora de nacimiento, hora
     de nacimiento desconocida, calculadora ascendente (stretch).
   - **PT-BR:** retificacao hora/horario de nascimento, calcular horario de
     nascimento, horario de nascimento desconhecido, calcular ascendente
     (stretch).
2. **Local research.** Expand each seed in a real keyword tool against the
   **native store front** (not a US-locale open-web proxy - that limitation is
   called out in `docs/competitor-aso-research.md` Sec. 2). Pull native
   popularity/difficulty/competition and find local long-tail the seeds miss.
3. **Native review.** A native (or near-native) speaker validates intent, idiom,
   and the honest-confidence wording per
   `docs/store-listing-tier1-localized.md` Sec. 0 gate 1 and Sec. 1. German has
   the highest credibility bar - review it hardest.
4. **Console recount.** Re-count every hard-limited field (name 30, subtitle 30,
   keyword field 100, Play short 80) in App Store Connect / Play Console; the
   doc's counts are a portable proxy only (Sec. 0 gate 3 / Sec. 8).
5. **Publish gate.** Only after research + native review + recount, and with the
   listing already live in that front, update the locale package in
   `docs/store-listing-tier1-localized.md` and submit.

Do not auto-translate the English keyword set into a locale and ship it: a
literal translation is not a researched keyword set.

---

## 6. Apple Search Ads - low-budget prep

**Gate first (from the growth docs).** No paid acquisition before V1.5 IAP
ships: pre-IAP there is no install->revenue moment, so paid is structurally
negative-ROI; a small Apple Search Ads test becomes ROI-positive only once V1.5
IAP ships (`docs/growth-thesis.md` Sec. 9.5 / H5, lines on D5 and the pre-IAP
paid hold). So this is **prep**, to run after the listing is live **and** the
V1.5 IAP gate is cleared - not a launch-day action.

When the gate is cleared, start deliberately small:

- **Campaign type:** start with **Search Results** only (not Search tab / Today
  tab / Discovery) - it is the highest-intent surface and the cheapest place to
  learn.
- **Keywords:** **exact-match, long-tail** terms only - the ownable niche set
  (`rectify birth time`, `birth time rectification`, `birth time finder`,
  `find my birth time`, `unknown birth time`). Do **not** bid broad/head terms
  (`rising sign`, `astrology`, `horoscope`) - they are expensive and held by
  incumbents (`docs/competitor-aso-research.md` Sec. 15.1).
- **Budget:** a **strict daily cap** and a low CPT cap; one English market first.
- **No scaling before signal.** Do not raise budget, add broad match, or add
  markets until there is a real **conversion / revenue** signal (tap ->
  install -> V1.5 purchase) inside the attribution window
  (`docs/growth-thesis.md` H5: ROI-positive within a 30-day window once IAP
  ships).
- **Feed it back:** which exact terms convert is the most useful input to the
  Sec. 4 title/subtitle sequential tests and to the Sec. 3 tracking read.

---

## 7. Sources (read-only)

- `docs/competitor-aso-research.md` Sec. 2 (US-locale caveat), Sec. 12.4,
  Sec. 15 (Appeeky pre-launch values, audit-locked-until-live limitation,
  subscription cancel/resubscribe recommendation, Sec. 15.3 tracking terms).
- `docs/aso-naming-strategy.md` Sec. 4.2 / 4.3 (title/subtitle candidates),
  Sec. 6.3 (locale direction), Sec. 14 (Appeeky metadata package),
  Sec. 14.6 (post-launch tracking terms).
- `docs/store-listing-en.md` Sec. 2 (live strings), Sec. 5 (screenshot caption
  plan), Sec. 6 (compliance guardrails).
- `docs/store-listing-tier1-localized.md` Sec. 0 (gates), Sec. 1 (terminology),
  Sec. 4-7 (per-locale packages and keyword fields).
- `docs/growth-thesis.md` Sec. 7.2 (locale long-tail), Sec. 9.5 / H5 (D5 pre-IAP
  paid hold; V1.5 IAP gate for Apple Search Ads).

No live store ranking, install count, rating, trademark clearance, or store
approval is asserted in this document. Appeeky/ASA figures referenced here are
pre-launch third-party estimates from the linked docs; the live numbers are
captured only by the Sec. 2 runbook, after launch.
