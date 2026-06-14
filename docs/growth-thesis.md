# Growth Thesis — TrueRise / Rectify

**Version:** 0.2 (Run 1 — Growth Thesis; accuracy + clarity review pass)
**Date:** 2026-06-02
**Status:** Draft for leadership approval before Run 2 (competitor research)
**Revision:** 0.2 (2026-06-02) — accuracy + clarity pass: metric/citation
  precision, approver bottom-line, ASO volume calibration, decision owner.
**Linked to:** `docs/prd.md`, `docs/mvp-scope.md`, `docs/marketing-research.md`,
  `docs/implementation-plan.md`, `docs/api-integration.md`,
  `docs/claude-build-history.md`, `docs/qa-phase8-report.md`

**Bottom line for the approver.** This document asks for one thing: approve
(or amend) the five items **A1–A5 in §12** — product category framing, the
"Maya" ICP, the Tier 0 → 1 → 2 market order, the Real Rectifications
Completed per Week north-star, and the five blocking decisions D1–D5 (§9).
Until A1–A5 are settled, no later run (competitor research, ASO, localization,
paid) starts. Everything between here and §12 is the evidence for those asks.

This document is the first decision document of the growth phase. It is
deliberately written before competitor research, ASO metadata work, or
localization. Its job is to lock product category, ICP, market priority,
the north-star metric, and the explicit non-goals so that every later
run (competitor scan, ASO, localization, copy, paid tests) inherits the
same frame.

Where claims rest on prior project docs they are cited; where they rest
on external sources, only sources already cited in
`docs/marketing-research.md` are reused. No new URLs are invented.

---

## 1. Strategic Frame (in one paragraph)

TrueRise is a **single-job mobile utility** — "I don't know my exact
birth time; tell me what it most likely was, with evidence." It is not
a horoscope app, not a wellness app, not a Vedic super-app. The whole
product (demo flow, real flow, share text, copy tone) is built around
one transactional value moment: the rectified time on the hero result
card. The growth strategy therefore optimizes for **intent capture on
long-tail birth-time-rectification queries** in mature App Store
markets, **using the offline demo as the conversion mechanism** that
proves the result is real before the user has to do anything — including
configure their own API key. We are explicitly **not** competing for
"astrology" / "horoscope" head terms, and we are explicitly **not**
running paid acquisition until V1.5 ships in-app purchase so that an
install can plausibly convert to revenue.

---

## 2. Product Category & Value Proposition

### 2.1 Category

**Utilities → Astrology Tools.** Closer in functional shape to a unit
converter or a tax estimator than to Co-Star / CHANI. A user opens
TrueRise to do one thing and (today) closes it again. There is no daily
loop. There is no feed.

This framing matters because it determines:

- **ASO category strategy** — we live with tools-class apps, not
  freemium-feed astrology apps. We do not need to win head terms; we
  need to own a transactional long-tail.
- **Tone** — calm, precise, observatory ("Quiet Observatory" design
  language per `docs/design-brief.md`). No purple, no tarot, no
  exclamation marks. Closer to Headspace or Notion than to Co-Star.
  This is already encoded in `docs/design-system.md` §2 (forbidden
  colors) and §3 (no italics for body, no emoji in copy).
- **Review-class** — we will be judged like a calculator (does it
  work, was the answer believable, did it crash) rather than like a
  daily astrology app (was today's reading insightful).

### 2.2 Value proposition

> "You don't know your exact birth time. Enter what you remember about
> your life, and we'll calculate the most likely time — with evidence."
> (per `docs/prd.md` §6)

The promise is **probabilistic, not deterministic.** This must remain
true in every surface: hero card, share text, App Store screenshots,
review responses. The rectified time is the most likely candidate
under the available evidence, accompanied by a confidence percentage
and a per-event evidence breakdown. No surface claims certainty, and
no surface implies medical, legal, financial, or fortune-telling
authority. (`docs/prd.md` §13, `docs/mvp-scope.md` §M12, and the QA
gate in `docs/qa-phase8-report.md` §4.1 already enforce this in code
via `test/security/no_payment_or_secret_strings_test.dart`.)

### 2.3 What the product is _not_

These are not just non-goals — they are **anti-positioning**, because
each one would drag us into a different market with a different ICP:

- Not a daily horoscope or feed (no Co-Star comparison)
- Not a tarot / oracle / divination tool (no mystic vocabulary)
- Not a Vedic super-app (Kundli / Dasha / KP) — until V1.5+
- Not a live consultation marketplace (no AstroTalk / Sanctuary
  comparison)
- Not a wellness / journaling / mindfulness product
- Not a chart rendering tool (deferred to V2 per `docs/prd.md` §17)

---

## 3. Initial ICP for Growth & App Store Launch

The single ICP for **growth and store launch** is the "Maya" persona
from `docs/prd.md` §4:

> **Intermediate astrology enthusiast, 25–40, female-skewed,
> English-speaking, has already used a horoscope app (Co-Star, CHANI,
> Astro.com), knows what a rising sign is and wants one, does not know
> their exact birth time, willing to pay $5–20 for a credible answer,
> expects a modern mobile UX.**

We treat the other two PRD personas — Arjun (India SWE, Vedic) and
Elena (professional astrologer, Toronto) — as **secondary** for this
phase:

- **Arjun (India / Vedic).** Real demand, but mismatched method. The
  v3 endpoint in use today (`docs/api-integration.md`) ships Western
  transit + progression by default. Marketing into the Vedic audience
  before KP/Nadi framing exists in the product will produce low
  ratings and "wrong method" reviews. The marketing research is
  explicit: *"Do not advertise in India for MVP"*
  (`docs/marketing-research.md` §"Risks", line 559 of `docs/prd.md`).
  Deferred — see §4.3.
- **Elena (professional astrologer).** High willingness to pay, but
  the product is not yet credible to a working astrologer:
  per-candidate methodological transparency is currently summarized
  (`techniques_used: ["transit","progression"]`), not auditable. The
  professional segment is V2-adjacent. Targeting it now risks
  negative reviews from the very voices that influence the wider
  market.

**Why "Maya" first.** Three reasons that are not just preference:

1. **TAM × accessibility.** The English-speaking intermediate
   enthusiast is the largest single segment with the lowest
   localization cost (zero — the app ships English-only today per
   `docs/implementation-plan.md` §1.3).
2. **Funnel fit.** This persona has *already* hit the wall the
   product solves ("my astrologer can't read my chart without my
   exact time") and arrives in a state of high intent. Demo-first
   onboarding converts this persona without any sale.
3. **Demo readiness.** The offline demo (`docs/mvp-scope.md` §M5,
   `docs/api-integration.md` "Demo mode") is already polished, ships
   in every binary, and exercises the full result + evidence + share
   surface. This is the right audience to *see* the product before
   we ask anything of them.

---

## 4. Target Markets — Priority Order

The user's brief raised a specific question: **where does the new
DE/FR/PT/ES request fit relative to the existing India/Hindi
direction?** This section answers it concretely.

### 4.1 Tier 0 — Launch (English App Store fronts)

**US, UK, CA, AU, IE, NZ.** These six are one localization (English),
share App Store conventions, and contain the densest population of the
"Maya" persona. The product is already built for them: copy is
English-only per `docs/prd.md` §8 and `docs/implementation-plan.md`
§1.3; the demo result data is in English; the design-system §3.2 type
scale and §11.3 city-search assume Latin input.

This tier requires **zero localization work**. The only Tier-0 effort
is ASO metadata, screenshots, and the App Store review draft.

### 4.2 Tier 1 — Next localization wave (DE, FR, PT-BR, ES)

These four locales should be the **next localization investment**,
ahead of Hindi, for the following reasons:

| Factor | DE / FR / PT-BR / ES | Hindi / India |
|---|---|---|
| App Store ARPU per install | High (DE especially) | Lower |
| Method match (Western transit) | Native fit | Mismatch — Vedic/KP expected |
| Localization scope | ASO text + ~250 in-app strings + privacy policy | All of that + Vedic method work in product |
| Long-tail BTR keyword competition | Very low | Moderate (Vedic-app saturation) |
| Risk of negative reviews from "wrong method" | Low | High (see `docs/prd.md` §16 risk table) |
| Product code changes required | None (locale-aware `intl` already in place per `docs/design-system.md` §14.4) | Vedic/KP method, KP-specific result copy, longer rollout |

The plan is **localization first, advertising second**. We translate
App Store metadata + the ~250 user-facing strings in `lib/` for these
four locales, ship a single update, and watch organic install lift
from long-tail keyword indexing in those App Store fronts. This is a
cheap experiment that does not require any product feature work.

PT-BR (Brazil) is the higher-value Portuguese variant given astrology
adoption rates and App Store size; ES is one locale shared by Spain
and most of Latin America with light variant work for `es-MX`.

### 4.3 Tier 2 — Hindi / India (V1.5, gated on Vedic framing)

Per `docs/prd.md` §17, Hindi localization sits in V1.5 alongside the
"Vedic / KP method framing (if API supports it)" item. The growth
thesis position is:

- **Keep Hindi in V1.5 as a *localization* item.** Translation pipeline
  work can begin in parallel with V1.5 product work.
- **Do not advertise into the India market until the in-app result
  surface uses KP / Nadi method labels.** Marketing a Western-transit
  rectifier into a Vedic-expecting audience is the single biggest
  predicted source of negative reviews and 1-star ratings in
  `docs/prd.md` §16 and `docs/marketing-research.md`.
- **Treat India as deprioritized for the *growth* phase**, not
  deprioritized for the product. The order is: DE/FR/PT-BR/ES
  localization → V1.5 IAP → V1.5 KP method → India ASO + marketing.

This is not a change in the V1.5 roadmap; it is a sequencing decision
inside that roadmap.

### 4.4 Tier 3+ — Everything else

Italian, Polish, Dutch, Japanese, Korean, Chinese (zh-Hans/zh-Hant)
are all post-V1.5 candidates, ranked on data we don't have yet. They
are out of scope for this phase entirely.

---

## 5. North-Star Metric

**North-star: Real Rectifications Completed per Week (RRC/wk).**

A "real rectification completed" is one full pass through the live
provider path (not demo) that returns a candidate set and reaches the
result screen — i.e. the user submitted real birth data + real life
events, the API returned, and the result was displayed. (Today's
binary instruments this state in `LiveRectificationRepository.submit()`
via `docs/api-integration.md`; the saved-calculation Drift row is the
ground truth.)

### Why this metric and not the alternatives

- **Not "installs."** Installs without completed rectifications mean
  the funnel is broken; chasing installs would mask the broken funnel.
- **Not "demo completions."** A demo completion is a *necessary
  middle* of the funnel, not the moment of product value. Tracking it
  alone could tempt us to optimize the demo at the expense of the
  real flow.
- **Not "DAU / MAU."** TrueRise has no daily loop and is not trying to
  manufacture one in this phase. Optimizing for DAU would push us
  toward becoming a horoscope app, which is the anti-positioning of
  §2.3.
- **Not "revenue" yet.** Revenue is genuinely undefined until V1.5
  IAP ships (`docs/prd.md` §17). Pre-IAP, the closest thing to
  revenue is "real calculation completed" — that is the action that
  *would* become a paid event in V1.5. Treating RRC/wk as the
  north-star today and revenue as the north-star post-IAP keeps the
  optimization target continuous across the IAP cut-over.

### Numerical target framing

Per `docs/prd.md` §15, MVP launch targets (first 30 days) are ≥5%
demo→real conversion and ≥50% demo completion; the §17 success gate
frames the same ≥5% against the first 200 unique users. RRC/wk in
the first 30 days is therefore expected to be a small absolute number
(low tens per week). The objective is **slope, not level**: month-on-
month RRC/wk growth is the leading indicator. A precise numerical
target is deliberately not set in this document — it will be calibrated
once we have one week of post-launch data, and committed to in the
post-launch Growth Review (Run 4 or later).

---

## 6. Supporting Metrics

The KPI tree below splits acquisition, activation, value-moment, and
quality. Each metric ties back to instrumentation that either already
exists in the binary or is cheap to add.

### 6.1 Acquisition (top of funnel)

| Metric | Source | Why we care |
|---|---|---|
| Store impressions per market | App Store Connect / Play Console | Indexing health for our long-tail keywords |
| Product page conversion (impression → install) | App Store Connect / Play Console | Quality of screenshots, icon, subtitle, first-line description |
| Source breakdown (browse / search / referrer) | App Store Connect | Tells us whether ASO or organic-share is driving installs |

### 6.2 Activation (install → first value)

| Metric | Source | Why we care |
|---|---|---|
| Install-to-demo-start rate | First-run analytics event | If onboarding loses the user, this is where |
| Demo completion rate (start → result viewed) | Analytics event on result screen mount | Maps directly to `docs/prd.md` §15 target (≥50%) |
| Evidence-screen open rate (post-demo) | Analytics event | Proxy for "does the user trust the answer" |

### 6.3 Value moment (the real rectification)

| Metric | Source | Why we care |
|---|---|---|
| Demo→real-calculation start rate | Analytics event | `docs/prd.md` §15 target (≥5%) |
| Real-calculation completion rate (start → result) | Analytics event | Catches API timeouts, key misconfiguration, drop-off |
| Share submitting ≥5 life events per real calculation | Analytics event | `docs/prd.md` §15 target (≥70% submit ≥5 events) |
| API failure rate (4xx / 5xx breakdown) | Existing `mapDioException` taxonomy in `lib/data/api/api_client.dart` | `docs/prd.md` §15 target (≤5% error rate) |

### 6.4 Quality & retention

| Metric | Source | Why we care |
|---|---|---|
| Result-share rate (taps of the new Share CTA) | Analytics event on `resultShareButtonKey` | Already shipped per build-history 2026-05-22; this is our organic-loop instrumentation |
| D1 / D7 retention | App Store Connect / Play Console | TrueRise has no daily loop by design — D1/D7 are a *health* signal, not a value signal |
| Rating / review rate | App Store Connect / Play Console | Update: a neutral, throttled in-app review prompt is now implemented in-repo with tests, superseding the earlier "organic only" stance; rating metrics themselves remain store-console scope, and no rating improvement is claimed |
| Crash-free sessions | Crashlytics (deferred; see `docs/qa-phase8-report.md` §6) | `docs/prd.md` §15 target (≥99%) |

### 6.5 Instrumentation status

Most events above need lightweight analytics. The project today has
**no analytics SDK wired** (Crashlytics is deferred per
`docs/qa-phase8-report.md` §6, and behavioural analytics is mentioned
only conditionally in `docs/prd.md` §13). Adding analytics is itself
an explicit Run 3 (or later) decision: it must respect the privacy
boundary (no birth data, no event content) per `docs/prd.md` §13.
**Do not ship behavioural analytics without that decision being made
deliberately.**

---

## 7. ASO / Search Targets — Head vs Long-Tail

This section sets the realistic ambition. It is intentionally not the
keyword list — that is Run 3 ASO work — but it locks the *strategy*.

### 7.1 Head terms (NOT immediately realistic for top-10)

The following terms are **not** realistic top-10 targets for TrueRise
on launch in any major locale, and we will not pretend otherwise in
ASO planning:

- "astrology"
- "horoscope"
- "tarot"
- "zodiac"
- "birth chart"
- "kundli" (Hindi market)
- "horóscopo" (ES/PT)
- "astrologie" (DE/FR)

The competition is Co-Star / CHANI / The Pattern / Sanctuary /
AstroSage / large-publisher horoscope apps with established install
bases and brand search. Optimizing for these in metadata burns
relevance signal without earning ranking. The PRD position
(`docs/prd.md` §16) — *don't market into India for MVP* — is the same
logic applied to one specific head-term market.

### 7.2 Long-tail targets (realistic top-10 ambition in 60–120 days)

These are intent-matched, low-volume, low-competition queries where
*the only product that actually solves the query* is TrueRise. Top-10
in 60–120 days post-launch is a credible — not guaranteed — target,
contingent on store metadata, first-week ratings, and Tier-1
localization landing.

Realistic ambition is not a step-change in installs. These terms are
genuinely low-volume; top-10 on them yields a small absolute number of
installs — the "low tens per week" shape of §5, not a hockey stick. The
install case is built by *breadth* (more Tier-1 locales, §4.2) and the
organic share loop (§6.4, H3), not by ranking any single keyword.

English (Tier 0):

- "birth time rectification"
- "rectify birth time"
- "find my birth time"
- "birth time calculator"
- "ascendant calculator" (more competitive — stretch)
- "rising sign calculator" (more competitive — stretch)
- "birth time finder"
- "approximate birth time"

DE (Tier 1):

- "Geburtszeitkorrektur"
- "Geburtszeit berechnen"
- "Geburtszeit unbekannt"
- "Aszendent berechnen" (stretch)

FR (Tier 1):

- "rectification heure de naissance"
- "trouver mon heure de naissance"
- "calcul ascendant" (stretch)

ES (Tier 1):

- "rectificación hora de nacimiento"
- "calcular hora de nacimiento"
- "calculadora ascendente" (stretch)

PT-BR (Tier 1):

- "retificação hora de nascimento"
- "calcular hora de nascimento"
- "calcular ascendente" (stretch)

The "stretch" items have meaningful competition from generic chart
calculators; they should be in metadata but not relied on for top-10.

### 7.3 ASO strategic posture

- **Title:** brand + one functional phrase. E.g. "TrueRise — Birth
  Time Finder" (English) once the brand decision in §9 lands.
- **Subtitle / short description:** intent capture in plain language,
  e.g. "Rectify your birth time from life events." No mystic
  vocabulary; matches the design-brief tone.
- **Keyword field (iOS) / long description (Android):** densely
  packed with the long-tail set above. Treat the keyword field as
  reach, not as exact-match incantation.
- **Screenshots:** lead with the rectified time + confidence + "See
  how we got this." Result hero card, then evidence, then demo
  badge. This sells the product as a *tool*, not as an aesthetic.
- **Reviews:** a neutral, optional in-app review prompt is now
  implemented in-repo (OS-owned via `in_app_review`, throttled, shown
  only after an eligible successful result share, with unit and widget
  tests). This supersedes the earlier "organic only" stance from
  `docs/prd.md` §8. Rating metrics remain App Store Connect / Play
  Console scope; no rating impact is claimed yet.

---

## 8. Growth Hypotheses to Validate in Later Runs

These are seven testable hypotheses for Runs 4+. Each is phrased so
that a single quantitative result decides whether to scale, kill, or
iterate. None of these are decisions to act on today; they are the
**experimental backlog** the growth phase will work through.

1. **H1 — Demo-first onboarding sustains ≥5% demo-to-real-calc
   conversion** at install volumes beyond 200 (the success gate in
   `docs/prd.md` §17 was set at the first 200 users). Test: rolling weekly cohorts.
   Kill if it falls below 3% on three consecutive cohorts.

2. **H2 — Long-tail BTR keywords reach top-10 in at least 4 of the 6
   English markets within 60 days of launch** without paid
   acquisition. Test: weekly App Store Connect "Search Terms" + Play
   Console keyword ranking. Kill if not at top-30 after 30 days
   (signals metadata or rating-volume problem, not strategy problem).

3. **H3 — Privacy-safe share text drives measurable organic referral
   installs** (shipped already per build-history 2026-05-22:
   `ShareCopyBuilder` exposes only rectified time + ascendant +
   confidence + tagline, no PII). Test: store referrer attribution
   for any installs that include the share tagline or co-occur with
   a share event spike. Decide whether to design a more discoverable
   share CTA in V1.5.

4. **H4 — DE/FR/PT-BR/ES localization lifts cross-market install
   share by ≥40% in those four locales within 60 days of the
   localized release.** Test: pre-vs-post install share by locale.
   Kill the additional locales (return to English-only) if uplift is
   under 10% — indicates the BTR demand signal in that locale was
   too thin for the localization cost.

5. **H5 — Pre-IAP, paid acquisition is structurally negative ROI**
   (because there is no install→revenue moment), but **once V1.5 IAP
   ships, a small paid test in the highest-CPI English market is
   ROI-positive within a 30-day attribution window.** Test: held
   until V1.5 IAP ships; small budget Apple Search Ads test on the
   long-tail keyword set in one English market.

6. **H6 — Users who submit ≥7 life events report "believable"
   results at a materially higher rate than users at 3–4 events.**
   PRD §15 already targets ≥60% "believable" and ≥70% submitting ≥5
   events. Test: the §S1 post-result feedback prompt joined to the
   event count. If true → strengthen the soft warning at low event
   counts (per `docs/prd.md` §F4.4) and refresh the screenshots to
   show ≥7 events as the canonical case.

7. **H7 — TrueRise can sustain ≥4.2 stars** at 1k+ ratings across
   English markets (`docs/prd.md` §15 target). Test: monthly
   rolling. Kill / pause new-market expansion if any market falls
   below 4.0 for two consecutive months — the leading indicator that
   our positioning or method is wrong for that market.

Optional H8 (held in reserve, not in the first wave): **Reddit and
TikTok BTR-specific creator outreach has a lower install cost than
paid search.** Held until we have organic baselines from H1–H4 to
compare against.

---

## 9. Decisions Required Before Next Runs

Five decisions block the productive start of Run 2 onward. Each is
phrased so it can be decided in a single approval round.

### 9.1 D1 — Public app name: TrueRise vs Rectify

**Current state.** The shipped binary, the README, and recent commit
messages use **"TrueRise"** as the public/display name (commits
`9389877` "TrueRise MVP demo" and `e4586eb`). `docs/prd.md` §2 still
lists **"Rectify"** as the recommended *working title* with the note
that App Store name availability, domain availability, and trademark
clearance are open. The codebase, bundle ID, and project name remain
`rectify` / `com.rectify.rectify`.

**Recommendation.** Confirm **TrueRise** as the public App Store name
and run the clearance checks (trademark, App Store name availability
in Tier 0 + Tier 1 locales, `.com` and locale TLD availability) **on
TrueRise specifically.** Keep `rectify` as the internal codename and
bundle ID. Rationale: the binary already says TrueRise, search
ambiguity ("Rectify" collides with several non-astrology tools in
multiple App Store fronts), and "TrueRise" carries the meaning the
product asserts (the true rising — the ascendant).

**Decision needed:** approve TrueRise pending clearance, or run
clearance on both and decide on results.

### 9.2 D2 — Locale order

**Recommendation.** Tier 0 (English fronts) → Tier 1 (DE / FR / PT-BR
/ ES, in parallel) → Tier 2 (Hindi, gated on Vedic method shipping).
See §4.

**Decision needed:** approve the order, or re-rank Tier 1 locales.

### 9.3 D3 — Hindi: V1.5 or deprioritized?

**Recommendation.** Keep Hindi *localization* in V1.5; defer Hindi
*marketing* until KP/Nadi method labels exist in the result and
evidence screens. See §4.3.

**Decision needed:** confirm this split, or fold Hindi entirely past
V1.5.

### 9.4 D4 — P0 feature selection criteria for the growth phase

The growth phase will inevitably surface "small" product asks (a
share-card image, a better empty-state CTA, an export, a "save and
retry later" flow, in-app review prompts, etc.). We need a single
criterion so these are not negotiated case-by-case.

**Recommendation.** A growth-phase feature is P0 if and only if it
either:

- (a) removes a measurable funnel-step drop in §6.2–§6.3 of ≥15
  percentage points, **or**
- (b) materially expands ASO surface area (a new long-tail keyword
  set, a new locale, a new sharable artefact), **or**
- (c) is required by App Store / Play Store policy for the chosen
  Tier 0 / Tier 1 markets.

Anything else (new content, new aesthetic, new method, new visual,
new edition) is V1.5 scope by default. Deferred items already
catalogued in `docs/qa-phase8-report.md` §6 (Crashlytics, hosted
privacy policy, bundle-ID lock, app-icon glyph, real-device smoke)
each must be re-evaluated against this criterion before they ship.

**Decision needed:** approve this criterion, or supply an alternative.

### 9.5 D5 — Pre-IAP paid acquisition stance

**Recommendation.** **No paid acquisition before V1.5 IAP ships.**
Today every install has no revenue moment (the user must bring their
own API key — `docs/api-integration.md`), so paid CAC is structurally
unrecoverable. This is a Hypothesis H5 deferral, not a hypothesis to
test pre-IAP.

**Decision needed:** approve the hold, or carve out a small
diagnostic budget for paid-test instrumentation only.

---

## 10. Explicit Non-Goals for This Phase

These are not "won't ship eventually" — they are "won't be built,
marketed, or planned for inside this growth phase." Same discipline
as `docs/mvp-scope.md` "Explicitly Deferred Features":

- **No backend social graph, accounts, login, sync.** V2 territory
  per `docs/prd.md` §17.
- **No in-app purchase, paywall, subscription, restore, credit
  ledger, refunds.** V1.5 territory; growth thesis explicitly does
  not pre-empt the IAP design.
- **No push notifications or behavioural retargeting.** Pushes are
  V1.5 candidates if data supports them. (A neutral in-app review
  prompt, originally listed here, has since been implemented in-repo
  with tests; see section 6.4.)
- **No medical, legal, or financial claims** in any copy, screenshot,
  share text, or store description. Confidence is probabilistic, and
  this is non-negotiable per `docs/prd.md` §13 and §16.
- **No deterministic astrology claims.** The product never says "your
  birth time is X." It says "your most probable birth time is X with
  N% confidence based on these events." This is enforced by the
  hero-card copy spec in `docs/design-system.md` §9.7 and by
  `ShareCopyBuilder` (build-history 2026-05-22).
- **No marketing into the India market** until KP/Nadi framing ships
  in V1.5 (§4.3).
- **No marketing into professional-astrologer channels** (Reddit
  r/astrologers, conferences, professional newsletters) — this
  audience belongs to V2 per §3.

---

## 11. What Run 2 (Competitor Research) Must Prove or Disprove

Run 1 commits to a thesis. Run 2's job is to attack that thesis with
evidence. Specifically, Run 2 must produce a defensible answer to:

1. **Mobile-native BTR competitors.** Is there a mobile-native BTR
   app already in the App Store / Play Store of any Tier 0 or Tier 1
   market with non-trivial download or rating volume? The marketing
   research (`docs/marketing-research.md`, 2026-05-19) says no, but
   that was three weeks ago and was scoped to English-language
   sources. Re-check **at least** the App Store fronts of US, UK, DE,
   FR, ES, PT, BR with native-language queries (Geburtszeit,
   rectification heure de naissance, retificação hora de nascimento,
   etc.).

2. **Long-tail keyword ranking reality.** For at least 5 of the long-
   tail terms in §7.2 per locale, who currently ranks top-10 in App
   Store / Play Store? If a generic horoscope app is ranking top-10
   on "birth time rectification" by accident, that is a structurally
   different competitive picture than a dedicated BTR app ranking.

3. **Pricing precedent and willingness-to-pay shape.** The PRD §17
   pricing assumption is ~$4.99 per credit. Is that consistent with
   what shipped competitors charge in 2026 in Tier 1 markets
   (specifically: Cosmic Birthtime at £28 per report — has it moved,
   does it offer in-app now; AI Pandit — has pricing surfaced;
   Vedic Samay credit packs — current EUR/GBP equivalents)? Run 2
   should not *set* IAP price (that is V1.5 product work) but it
   should test whether the assumption is in-region.

4. **App Store category / policy reality.** Does any major BTR or
   astrology app appear to have hit App Store rejection or category
   re-classification recently? (PRD §16 risk: "App Store rejection
   for vague astrology category policy.") This is rare but expensive
   if hit at submission.

5. **Anti-positioning validation.** Are the Co-Star / CHANI / The
   Pattern style horoscope apps publicly de-emphasizing or
   re-introducing BTR-adjacent features (rising sign, exact-time
   prompts)? If a major incumbent has quietly added a BTR-lite flow,
   we are in a different game.

6. **Hindi / India re-check.** Has any India-market BTR competitor
   surfaced or grown materially since the 2026-05-19 research? If
   AI Pandit (or similar) has launched mobile, the V1.5 sequencing
   in §4.3 may need to compress.

Run 2 should *not* propose a new ICP, a new market priority, or a new
north-star — it should accept or rebut the §3, §4, and §5 positions
in this document with evidence. Any re-opening of those decisions is
a Run 1.5 (revision of this document), not a Run 2 deliverable.

---

## 12. Approval Gate

Before Run 2 begins, the human reviewer should explicitly approve or
amend the following five items. Anything unapproved means Run 2 is
asked to investigate that item alongside its scope above.

| # | Item | Recommendation |
|---|---|---|
| A1 | Product category framing (utility, not horoscope; probabilistic, not deterministic) — §2 | Approve |
| A2 | Initial ICP = "Maya" persona for growth & store launch; Arjun and Elena are V1.5+ — §3 | Approve |
| A3 | Market priority: Tier 0 English fronts → Tier 1 DE/FR/PT-BR/ES localization → Tier 2 Hindi (gated on Vedic method) — §4 | Approve |
| A4 | North-star metric: Real Rectifications Completed per Week (RRC/wk); slope, not level — §5 | Approve |
| A5 | Five blocking decisions D1–D5 in §9 (name, locale order, Hindi sequencing, P0 criterion, pre-IAP paid hold) | Approve each, or supply amendments |

**Decision owner / target date:** ______ (set by the approver). Unsettled
items fold into Run 2's §11 investigation scope rather than blocking it; the
downstream execution work named below (ASO, localization, analytics, paid)
stays paused until A1–A5 are settled.

Once A1–A5 are approved, Run 2 (competitor research, scope per §11)
can start. Until then, ASO metadata work, localization quotes,
analytics SDK selection, and any paid-acquisition planning should
**not** start, because each of them depends on at least one of A1–A5
being settled.
