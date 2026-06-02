# Competitor & ASO Research — TrueRise / Rectify (Run 2)

**Version:** 1.0 (Run 2 — Competitor & ASO Research)
**Date accessed for all live evidence:** 2026-06-02
**Status:** Evidence pack for leadership; input to Run 3 (ASO metadata)
**Linked to:** `docs/growth-thesis.md` (Run 1), `docs/marketing-research.md`
  (2026-05-19), `docs/prd.md`, `docs/mvp-scope.md`, `docs/qa-phase8-report.md`

**Scope discipline.** This run is research- and documentation-only. It does
not set final pricing, ASO metadata, or product scope — it tests the Run 1
thesis (`docs/growth-thesis.md` §11) against current evidence and hands a
clean evidence base to Run 3. Where a claim is directly observed it is marked
**Observed**; where it is reasoning on top of evidence it is marked
**Inference**. No ranking, rating, price, review, or screenshot has been
invented; absent evidence is stated as absent.

---

## 1. Executive Answer — Does Run 2 Confirm or Challenge Run 1?

**Run 2 confirms the Run 1 thesis on every load-bearing point, sharpens two,
and challenges none of the A1–A5 asks.**

- **Confirmed — the mobile-native consumer BTR lane is still essentially
  open.** Across English and native-language (DE/FR/ES/PT-BR) web evidence,
  the only dedicated, mobile-native birth-time-rectification *app* found is
  **Vedic Samay** (iOS, Vedic/KP, professional-leaning). Every other BTR
  solution is a web calculator, a human-astrologer service, or desktop
  software. This matches `docs/marketing-research.md` and Run 1 §11.1.
- **Confirmed — anti-positioning (A1).** Co-Star, CHANI, Nebula, and The
  Pattern all *require/request an exact birth time*, treat an unknown time as a
  degraded state (omit the ascendant and houses, or fall back to a sunrise/noon
  chart), and explicitly punt rectification to professional astrologers. None
  has shipped an algorithmic BTR-lite flow. The incumbents **manufacture the
  exact pain TrueRise resolves** — a tailwind, not a threat.
- **Confirmed and upgraded — the "Utilities, not horoscope" framing is also a
  policy-survival strategy.** Apple Guideline **4.3(b)** explicitly names
  "fortune telling" / "astrology, horoscopes … zodiac reports" as a saturated
  category subject to rejection unless the app offers a "unique, high-quality
  experience"; disclaimers do **not** cure a 4.3 rejection. Vedic Samay ships
  in the **Utilities** category. Run 1 §2.1 was right for tone *and* for review
  survival.
- **Sharpened — pricing.** The nearest mobile BTR competitor (Vedic Samay)
  prices a report at roughly **$1 at the entry tier** ($4.99 / 5 credits) down
  to **~$0.70 in bulk** ($34.99 / 50); the nearest dedicated web competitor
  (Cosmic Birthtime) charges **£28 per report**. The PRD's **~$4.99 per single
  credit** assumption is *in-region* — above the mobile-Vedic per-unit floor,
  far below the web-premium ceiling — but it is at the **premium end for a
  mobile single-shot**. Flag for the V1.5 IAP pricing decision; do not change
  the assumption now.
- **Sharpened — credibility headwind is stronger than Run 1 implied.** The
  field's gold-standard reference, Astrodienst (astro.com), **explicitly
  refuses to offer rectification** ("we know no reliable methods") in its EN,
  DE, FR, ES, and PT FAQs, and "no software can rectify; it needs an expert" is
  a recurring community view. This does not change strategy — TrueRise's
  probabilistic, evidence-first framing is the correct answer — but it raises
  the review-risk bar in sophisticated markets (Germany especially) and makes
  the honest-confidence copy non-negotiable.

**Bottom line:** keep A1–A5 as written. Two items move from "assumption" to
"evidence-backed": the Utilities/policy framing (A1) and the India sequencing
(A3, Tier 2). One watch-item is added for Run 3+/V1.5: pricing calibration and
EU credibility copy. Run 2 is good enough to feed Run 3.

---

## 2. Research Method & Access Limitations

**Tools used (2026-06-02):** live web search and page fetches against public
web pages, App Store listing pages, Google Play listing pages, and the
competitors' own sites. All evidence is dated to the access date above.

**Limitations — read before trusting any number below:**

1. **Web search ran from a US locale.** Native-language queries
   (Geburtszeitkorrektur, rectification heure de naissance, retificação hora
   de nascimento, rectificación hora de nacimiento) returned **open-web**
   results, **not** native App Store / Play Store *search rankings* in DE/FR/
   ES/PT/BR. Where this document says "who appears," it means the open web,
   which is a *proxy* for — not a measurement of — store ranking. Direct
   in-store ranking in those fronts remains unverified and is a Run 3 task
   (best done from App Store Connect / Play Console search-term tools, or a
   localized device/VPN check).
2. **Store ratings, review counts, and install bands were not fetchable.**
   App Store and Google Play listing pages render those numbers client-side;
   fetches returned page chrome only. Vedic Samay's listing yielded title,
   subtitle, category, and IAP prices but **no star rating** ("not visible").
   Any rating / install figure in this document therefore comes from a
   **third-party or marketing snippet, not a direct store read**, and is
   labelled as such.
3. **Reviews were not scraped from the stores.** Review *themes* below come
   from press articles, Quora, Medium, and app-review aggregators, cited per
   claim. They are **not** a structured review sample and several are dated
   2019–2025, not confirmed current. No review text has been invented.
4. **Two key competitors have no independent reviews at all.** Cosmic Birthtime
   (self-described "launched in 2025") and Vedic Samay surfaced **only
   developer/marketing copy** — no Trustpilot, Reddit, or forum corpus was
   found. Their capability claims are unverified vendor statements.
5. **Screenshots were not inspected directly.** See §8 — feature signals are
   read from listing *text*, not from the screenshot images themselves.

---

## 3. Competitor Map

All fields are **as observed/sourced on 2026-06-02**; blanks are honest gaps,
not zeros. "BTR" = automated birth-time rectification from life events.

| Product | Platform (observed) | Automated BTR? | Category / positioning | Pricing (observed) | Rating / scale (source — not store-verified) |
|---|---|---|---|---|---|
| **Vedic Samay** | iOS app | **Yes** (KP sub-lord) | Utilities; "Birth Time & Numerology"; pro/Vedic | Free + IAP: $4.99/5, $14.99/20, $34.99/50 report credits; 7 free on signup; no subscription | Rating not visible on listing |
| **Cosmic Birthtime** | Web only | **Yes** (AI "Oracle") | Dedicated BTR platform; casual–intermediate | £28 per report, no free tier; PDF deliverable | No independent reviews found; site "launched 2025" |
| **AI Pandit** (aipandit.app) | Web only | **Yes** (claimed) | Vedic AI BTR, "seconds-level precision" | **No price visible**; no app badge | None found |
| **AstroSage** | iOS + Android + web | No (BTR is an *article*, human service via consults) | Vedic super-app; India #1 | Free app + paid astrologer consults | 4.4★ / ~853k, 70M+ DLs, ~80% India share — *vendor/marketing figures* |
| **AskSoma** | Web + app (claimed) | "Birth Time Calculator" (claimed) | Kundli/AI Vedic | Free tier; "$7.99/mo" and "$12.99/mo Pro" (conflicting, self-published) | None independent |
| **Co-Star** | iOS + Android | No (unknown-time → degraded chart) | Daily horoscope / social | Free + ~$9/mo (per `marketing-research.md`) | 4.9★ / 70.8k *historical (2019–25), not confirmed current* |
| **CHANI** | iOS + Android | No (sunrise-chart workaround) | Western/Whole-Sign, mindfulness | Free + subscription (per `marketing-research.md`) | Help-center "Unknown Birth Time" article updated 2026-02-24 |
| **The Pattern** | iOS (+ Android) | No (edit/adjust time manually) | Psychology-flavoured natal | Free + IAP (per `marketing-research.md`) | — |
| **Nebula** | iOS + Android | No (points to live advisors) | Spiritual-guidance + psychic marketplace | Freemium (per sources) | — |
| **Web calculators** (astro-seek, astromix, clickastro, astro-app.net) | Web | Partial ("primary directions" / range-and-score) | Generic chart/rectification calculators | Mostly free / freemium | — |
| **Desktop BTR** (Vega 7 [BR], Samay Sutram 2.0 [IN], astropair [DE]) | Windows / web service | Yes (manual-assist) | Practitioner software | Vega 7 paid; Samay Sutram ₹1,200 | — |

---

## 4. Direct BTR Findings

### 4.1 Vedic Samay — the one real mobile-native BTR incumbent (iOS)
**Observed (App Store listing, 2026-06-02):**
- **Title / subtitle:** "Vedic Samay" — "Birth Time & Numerology." Developer
  **Amit Sethi**. **Category: Utilities.**
- **Pricing / IAP:** Free with in-app purchases — **5 Report Credits $4.99,
  20 Report Credits $14.99, 50 Report Credits $34.99**; **7 free credits on
  sign-up**; one-time credits, **no subscription**. (This corroborates the
  $4.99–$34.99 band in `docs/marketing-research.md` exactly.)
- **Function:** BTR Wizard — user enters verified life events across ~12
  categories (children's births, marriages, divorces, siblings, career,
  health, legal, settlement, parent status); the engine "evaluates hundreds of
  candidate birth times, scoring each … using sub-lord astronomical
  calculations" (KP). Also ships Cuspal Interlink charts (Placidus + sub-lord/
  sub-sub-lord), Dasha/Yoga timelines, Vedic numerology, live Panchang, and an
  "AI Chart Study" assistant. Self-claim: "the only app in the world" computing
  BTR from real life events.
- **Star rating / review count: not visible** on the fetched listing.

**Inference / opportunity for TrueRise (no non-goal violated):**
- Vedic Samay is **Vedic/KP and practitioner-shaped** — it is *not* the "Maya"
  product. Its existence validates the lane and the Utilities category while
  leaving the **Western, consumer, demo-first, no-jargon** position open. Our
  edge is exactly what it lacks: an **offline demo before any sale**, a
  **consumer onboarding** that needs no astrology literacy, and a **plain-
  language probabilistic result** — all already in the binary.
- It is **iOS-only**; Android remains uncontested by any dedicated BTR app
  (see §6). Confirms the cross-platform advantage in `docs/prd.md` §6.

### 4.2 Cosmic Birthtime — the closest *direct* (web) competitor
**Observed:** Web-only, **£28 per report, no free tier**; AI "Oracle" maps
life events to transits/progressions and returns a rising sign + birth time as
a **PDF report**; site self-describes as "launched in 2025." Its own FAQ is
candidly probabilistic: rectification "is an estimation process … cannot
guarantee absolute precision … a strong reference point, not an absolute
certainty." **No independent reviews / Trustpilot profile found.**
**Notable ASO behaviour:** it runs a **large fan of single-keyword SEO landing
pages** (e.g. `/birth-chart-rectification-calculator`, `/what-is-birthtime-
rectification`, `/rectification-astrology-free`, `/how-birth-time-
rectification-works`). **Inference:** they are farming the *same English long-
tail* TrueRise targets, but on the **web**, with **no App Store presence** — so
they do not contest our store rankings, and their candid "estimate, not
certainty" copy is a useful precedent our own copy can echo.

### 4.3 AI Pandit — still web-only, still no price
**Observed (aipandit.app, 2026-06-02):** a **web platform**, **no iOS/Android
badge**, **no visible pricing**; claims "AI-powered Vedic birth time
rectification with seconds-level precision," a six-stage pipeline (NASA JPL
ephemeris, Rashi grid, Dasha, KP sub-lord, etc.), and client-side AES-256-GCM
"zero-access" encryption. **Inference:** unchanged vs `marketing-research.md` —
no mobile app, opaque pricing, no review footprint. Does not move V1.5
sequencing (§11).

### 4.4 Human services & desktop software (the real BTR substitutes today)
**Observed across locales:** dedicated BTR is overwhelmingly delivered as a
**human astrologer service** (AstroSage BTR, indastro, sermasyo/escuelasermasyo
[ES], titividal/becoastral [BR], astrologie-conseil [FR], AstroNidan [IN]) or
**desktop software** (Vega 7 [BR, "acerto de hora," secondary-progression
"mountain" scoring], Samay Sutram 2.0 [IN, ₹1,200], astropair [DE, "world's
first online ascendant rectification"]). **Inference:** the substitute set is
slow, expensive, desktop-bound, or web-only — exactly the gap
`docs/marketing-research.md` "Weaknesses and Opportunities" predicted; it
remains open on mobile in 2026.

---

## 5. Big Astrology App Findings (Anti-Positioning Validation)

**The pattern is consistent across all four majors checked: exact birth time is
an input they demand, not an output they compute.**

- **Co-Star** (iOS+Android): builds the chart from date/time/place "down to the
  minute"; has an **"I don't know my birth time" option**, but unknown time
  yields a **degraded chart** (no reliable ascendant/houses) — *no
  rectification*. Tells users to "be as precise as possible."
- **CHANI** (iOS+Android): Whole-Sign system **centred on the rising sign**;
  maintains a dedicated **"Unknown Birth Time"** help article (**updated
  2026-02-24**). Workaround for unknown time = **set birth time to local
  sunrise** (align rising with sun) and read sun-sign content — a graceful
  degrade, **not** an estimate of the true time.
- **The Pattern** (iOS): requests birth time, lets users **manually edit/nudge**
  it (e.g. ±1 h for DST); no algorithmic rectification; noon default if unknown.
- **Nebula** (iOS+Android): uses the supplied time; **no rectification feature**;
  routes birth-time uncertainty to its **live astrologer/psychic marketplace**.
- **Sanctuary / TimePassages** (per `docs/marketing-research.md`, not
  re-fetched this run): live-consultation ($2.99/min) and one-time-purchase
  chart tool respectively — neither is a BTR product.

**Why this matters (Inference):** CHANI and Co-Star **make the rising sign the
headline** of the experience, so a Maya-persona user who lacks an exact time
hits the wall *inside the app she already uses* and is told to either guess or
consult a human. TrueRise is the **downstream utility** for that exact moment.
No incumbent is moving into algorithmic BTR; A1's anti-positioning holds.

---

## 6. Search-Neighbor / Keyword-Result Findings by Locale

**Method caveat (repeat):** these are **open-web** results from a US locale,
not in-store rankings. Classification legend: **[BTR]** dedicated rectification,
**[CALC]** generic chart/ascendant calculator, **[VEDIC]** kundli/Vedic,
**[SVC]** human service, **[SW]** desktop software, **[EDU]** astrologer/wiki
content, **[APP]** mobile app.

### 6.1 English (Tier 0)
Terms checked: "birth time rectification (app)", "find my birth time", "rising
sign / ascendant calculator", "birth time calculator", "approximate birth time."
Who appears: astro-seek `[CALC]`, astromix `[BTR/CALC]`, clickastro
`[VEDIC/CALC]`, astro-app.net `[CALC]`, Cosmic Birthtime `[BTR, web]`,
astro.com wiki `[EDU]`, AstroSage/Kundli sites `[VEDIC]`, **Vedic Samay
`[BTR, APP]`** — and Time Nomad `[APP, charting not BTR]`.
**Read:** the English long-tail is owned by **web calculators and Vedic/kundli
sites**, with exactly **one BTR app** (Vedic Samay). No Western consumer BTR app
ranks. Confirms Run 1 §7.2 — the lane is winnable on intent, not yet contested
by a like-for-like app.

### 6.2 German (DE)
Terms: "Geburtszeitkorrektur", "Geburtszeit Rektifikation", "Geburtszeit
unbekannt berechnen." Who appears: astro.com astrowiki `[EDU]`, astromeise.de
`[EDU]`, **astropair.com** ("weltweit erste Online-Aszendentenrektifikation")
`[SVC/SW, web]`, lebendige-astrologie / astrokosmos / partneratlas / astrovedic
`[EDU/SVC]`. **No mobile app surfaced.** Explicitly: "Reine Apps zur
automatischen Berechnung sind selten" (pure auto-calc apps are rare), and
Astrodienst **refuses** the service as unreliable.
**Read:** vocabulary and demand exist; supply is **web/service/desktop, no
app**. Highest credibility bar of all locales (see §7, §13).

### 6.3 French (FR)
Terms: "rectification heure de naissance (application)", "calcul ascendant
heure inconnue." Who appears: astro.com `[EDU]`, **astrocalc.fr** (time-**range**
input → ascendant interval **+ confidence level + 24 h graph + PDF**) `[CALC,
closest functional neighbour]`, macalculatriceenligne `[CALC]`, azurastrologue /
astrologie-conseil / radiovoyance / astrologis `[EDU]`. **No app surfaced.**
**Read:** astrocalc.fr is the single closest functional analog to TrueRise's
confidence-and-evidence output found in any locale — and it is **web-only,
French**. Useful design reference; not a store competitor.

### 6.4 Spanish (ES)
Terms: "rectificación hora de nacimiento (app)", "calcular hora de nacimiento
desconocida." Who appears: astro.com `[EDU]`, carta-natal.es (unknown-hour →
noon / 0° Aries / sun-on-ascendant) `[CALC]`, astroasist.com (free
ascendant-without-hour, elimination method) `[CALC]`, astroworld.es `[EDU]`,
sermasyo / escuelasermasyo `[SVC, school]`. **No app surfaced.**
**Read:** identical shape — calculators that *degrade* rather than rectify,
plus human services. App lane open.

### 6.5 Portuguese / Brazil (PT-BR)
Terms: "retificação hora de nascimento (aplicativo)", "calcular hora de
nascimento desconhecida." Who appears: astro.com `[EDU]`, constelar.com.br
`[EDU]`, titividal / becoastral `[SVC]`, **astroclub.com** (handles unknown
time, does **not** rectify) `[APP/site]`, **Vega 7 / sadhana.com.br** (Brazilian
**desktop** BTR with progression scoring) `[SW]`, astrologiaclassica /
seuhoroscopo `[EDU]`. **No mobile BTR app surfaced.**
**Read:** Brazil has strong astrology culture and clear BTR vocabulary; supply
is service + desktop. Brazilian practitioners typically request **10+ dated
events** — a useful expectation-setting datapoint for PT-BR copy.

**Cross-locale conclusion (Observed pattern + Inference):** in **all four**
Tier-1 locales the BTR term is established and demanded, yet supply is
exclusively **web calculators that degrade, human services, or desktop
software**. No mobile-native consumer BTR app appears in any locale's open-web
top results. This is the strongest single confirmation of Run 1's market thesis
— tempered only by the in-store-ranking caveat in §2.

---

## 7. Review Mining — Praise, Complaints, Opportunity Matrix

**Sourcing caveat:** themes below are from press/aggregator/forum content
(cited in §14), not a structured store-review sample; Co-Star items are largely
2019–2025. Cosmic Birthtime and Vedic Samay have **no independent reviews**.

| Theme | Where seen (source class) | Praise | Complaint / risk | TrueRise opportunity (within current non-goals) |
|---|---|---|---|---|
| Accuracy belief | Co-Star (press/Quora) | "Accuracy UNREAL"; NASA-data trust | "Daily reading is total garbage"; houses miscalculated (a sign in multiple houses) | Lead with **evidence per event + confidence**, the thing black-box apps are dinged for |
| Birth-time literacy | Co-Star/CHANI/Pattern | Users *know* rising needs exact time | Unknown-time = dead end inside the app | Be the **explicit answer** to the dead end; demo proves it pre-sale |
| AI-BTR scepticism | astro.com (EN/DE/FR/ES/PT), engineer/forum blogs | — | "No reliable method"; "needs an expert"; "~29% trust AI astrology"; 2–3° ascendant errors warned | Never claim certainty; **probabilistic + show-your-work** is the trust wedge |
| Paywall resentment | Co-Star, industry | — | Paywalling a user's *own* daily reading; "countdown timer / cosmic emergency" pressure tactics; refund-delay complaints | **Offline demo, no pressure, no PII** is a differentiator — keep it |
| Support / delivery | industry-wide | — | Slow support, refund delays are the top non-product complaint class | Keep result instant + local; set honest expectations in copy |
| Method mismatch | Vedic vs Western | KP precision valued in India | Western-transit result into a Vedic-expecting user = "wrong method" | Hold the line: **no India marketing pre-KP** (A3) |

**Inference:** the repeated user language across the category is *"is this
accurate, and can you show me why?"* — precisely the axis TrueRise already
optimises (hero card → confidence → per-event evidence). The biggest reputational
landmines are **black-box output** and **aggressive monetisation**, both of
which the current product avoids by design.

---

## 8. Screenshot & Feature Patterns from Store Listings

**Direct-inspection caveat:** screenshot *images* were not analysed; the
following reads listing/marketing **text** and is labelled accordingly.

- **Vedic Samay (text signals):** wizard-style life-event entry across ~12
  categories → "hundreds of candidate times" with sub-lord scoring; PDF report
  generation; "7 free credits" surfaced as the trial hook; AI chart-study
  assistant. **Pattern:** lead with the *engine* and *credit trial*.
- **Cosmic Birthtime (web):** 3-step flow (birth data → life events → "Oracle"
  result), **rising sign + 12 houses unlocked on completion**, **PDF report** as
  the deliverable, candid accuracy disclaimer on-page.
- **Category-wide patterns (from `marketing-research.md` UX section + observed
  competitor copy):** progressive disclosure of inputs; **confidence scoring**
  shown honestly; **evidence/"receipts"** transparency; **shareable artefact**
  (PDF / screenshot) as perceived-value driver; **demo/dry-run** as the
  conversion lever.

**Implication for TrueRise screenshots (Run 3, not built here):** the field
rewards exactly the order Run 1 §7.3 specified — **rectified time + confidence
first, then the per-event evidence, then the offline-demo badge.** That sells a
*tool* and simultaneously distances the listing from the "horoscope/fortune
telling" copy that triggers Apple 4.3(b) (see §10).

---

## 9. Pricing Precedent & Willingness-to-Pay Implications

**Observed price points (2026-06-02):**

| Competitor | Unit | Price | Per-report (derived) |
|---|---|---|---|
| Vedic Samay (mobile, Vedic) | 5 credits | $4.99 | ~$1.00 |
| Vedic Samay | 20 credits | $14.99 | ~$0.75 |
| Vedic Samay | 50 credits | $34.99 | ~$0.70 |
| Cosmic Birthtime (web, Western) | 1 report | £28 | ~£28 (~$35) |
| AstroSage BTR (human service, per `marketing-research.md`) | 1 report | $50 / ₹3,250 | $50 |
| AI Pandit | — | not visible | — |

**Caveat:** whether one Vedic Samay BTR run consumes 1 credit or several is not
stated on the listing; "each chart analysis uses 1 credit" was reported in
search, so per-report ≈ entry-tier credit price is the best available read.

**Read against the PRD ~$4.99/credit assumption (`docs/prd.md` §F10.1):**
- **In-region: yes.** $4.99 sits between the mobile-Vedic per-unit floor (~$0.70–
  $1.00) and the web-premium ceiling (£28 / $50 human). It is defensible.
- **But it is premium for a single mobile shot.** The only mobile BTR
  comparable charges ~$1 for an entry report and discounts steeply in bulk.
  **Inference for V1.5 (not a decision here):** consider whether a single
  $4.99 credit reads as expensive next to Vedic Samay's $4.99-for-5, or whether
  TrueRise's Western-consumer-demo-first positioning + a *first-result-included*
  or *small-bundle* structure better matches the field. The demo already
  de-risks the "is it worth it" question Cosmic Birthtime charges £28 to answer.
- **WTP shape unchanged:** the human-service alternative ($50–$320+ in
  `marketing-research.md`) still anchors automated BTR as a bargain; the value
  story in `docs/prd.md` §6 holds.

**Do not set IAP price in this run** (V1.5 product work per Run 1 §11.3) — but
record that the assumption survived contact with current evidence.

---

## 10. Policy / Category / Copy Risk Observations

**Observed (Apple App Review Guidelines + developer reports, 2026-06-02):**
- **Guideline 4.3(b) "Spam"** explicitly lists "fortune telling" among
  saturated categories. The standard rejection wording: *"Your app primarily
  features astrology, horoscopes, palm reading, fortune telling or zodiac
  reports … we simply have enough of these types of apps … considered a form of
  spam."*
- **Disclaimers do not cure a 4.3 rejection** — 4.3 is about *duplication /
  saturation*, not liability. The path to approval is demonstrating a
  **unique, high-quality function.**
- Enforcement is reported as **inconsistent**; even adjacent apps (a tarot
  journal) have been caught.

**Why this is good news for TrueRise (Inference):**
- The **single-function calculation utility** framing is the textbook 4.3
  answer: TrueRise does one thing no horoscope app does (compute a probable
  birth time from life events). **Vedic Samay's survival in Utilities** is a
  working precedent.
- **Copy/category strategy (feeds Run 3):** make the **calculation USP the
  headline**; keep "astrology / horoscope / zodiac / fortune" out of the
  *primary* title/subtitle and category choice; pick **Utilities** (or
  Reference), not Lifestyle-horoscope. This serves relevance *and* 4.3 survival.
- This directly confirms the `docs/prd.md` §16 risk row ("App Store rejection
  for vague astrology category policy") as a **live, specific** risk and
  upgrades its mitigation from "ensure factual/calculation-based" to a concrete
  metadata rule.

**Google Play:** no comparable saturation-rejection signal surfaced this run;
Play's risk is more about restricted-content / health-claim policy, which the
no-medical-claims non-goal (Run 1 §10) already covers. **Not independently
re-verified this run — flag for Run 3.**

---

## 11. Hindi / India Re-Check

**Observed (2026-06-02):**
- **AstroSage** dominates Indian digital astrology — *reported* (vendor/
  marketing, not store-verified) at ~80% market share, 70M+ downloads, 4.4★/
  ~853k reviews, 1.2M DAU / 11M MAU, KP system, 9 languages. **But its app does
  not ship automated BTR** — birth-time rectification appears as an *educational
  article* and as a *human astrologer consultation*, not a one-tap feature. The
  app *requires* an accurate time for Kundli.
- **AI Pandit** remains **web-only, no price, no app** (§4.3).
- Indian BTR supply is otherwise **human service** (indastro, AstroNidan) or
  **desktop software** (Samay Sutram 2.0, ₹1,200).

**Conclusion (confirms Run 1 §4.3 / A3):** **no India-market mobile BTR
competitor has emerged that would force V1.5 sequencing to compress.** The
dominant incumbent has *not* automated mobile BTR, and the market is Vedic/KP-
expecting — reinforcing the "wrong method" review risk for a Western-transit
app and the decision to **gate India marketing on KP/Nadi framing** (Run 1
§4.3, `docs/prd.md` §16, line 559). Hindi stays a V1.5 *localization* item;
India *marketing* stays deferred.

---

## 12. Implications for Later Runs

### 12.1 ASO naming & metadata strategy (Run 3)
- **Category:** target **Utilities** (precedent: Vedic Samay), not a horoscope/
  Lifestyle slot — for relevance *and* Apple 4.3(b) survival (§10).
- **Title/subtitle:** lead with the **calculation function** ("Birth Time
  Finder" / "Rectify your birth time from life events"); keep
  astrology/horoscope/zodiac/fortune out of the *primary* line.
- **Long-tail:** the Run 1 §7.2 set is validated as low-competition on the app
  side; Cosmic Birthtime is farming the same terms **on the web only**, so app
  rankings are uncontested by a like-for-like product. In-store ranking still
  needs Run 3 verification (App Store Connect / Play Console search terms).
- **Screenshots:** rectified time + confidence → per-event evidence → demo
  badge (§8), which also reads as a "tool," reinforcing the 4.3 case.

### 12.2 Feature-gap analysis (no build in this run)
- **Closest functional references** to study (web, non-competing): **astrocalc.fr**
  (range → confidence + 24 h graph + PDF) and **astroasist.com / carta-natal.es**
  (ascendant-without-hour elimination). TrueRise already matches/exceeds these on
  confidence + per-event evidence; the **shareable PDF/image** (V1.5 per
  `docs/prd.md` §17) is the one common artefact we lack — keep it V1.5.
- **Demo-first** remains the unique conversion lever no competitor offers — do
  not dilute it (`CLAUDE.md`: demo stays offline, no network).

### 12.3 Localization strategy (Tier 1)
- Demand and vocabulary confirmed in DE/FR/ES/PT-BR → the Run 1 Tier-1
  localization bet is evidence-backed.
- **Germany needs the most careful credibility copy** (Astrodienst refusal +
  "Königsdisziplin"/controversial framing); **Brazil** copy should set the
  "~10 dated events" expectation; **France/Spain** users are routinely told to
  fetch the official birth record first — copy can acknowledge that and position
  TrueRise as the next step when records fail.

### 12.4 Open verification items handed to Run 3
1. In-store (native-front) search rankings for the §6 terms — App Store Connect
   / Play Console or localized-device check.
2. Direct store ratings / review counts / install bands (not fetchable this run).
3. Google Play astrology-policy specifics (not re-verified this run).
4. A small structured review sample for Vedic Samay + 1–2 majors, if Run 3
   wants quantified review themes rather than the qualitative §7 read.

---

## 13. Decision Deltas Against A1–A5

| # | Run 1 ask | Run 2 verdict | Evidence basis |
|---|---|---|---|
| **A1** | Utility / probabilistic, not horoscope / deterministic | **Keep — upgraded** | Vedic Samay sits in Utilities; Apple 4.3(b) makes the utility framing a *policy* necessity, not just tone (§10). Big apps don't compute BTR (§5). |
| **A2** | "Maya" ICP first; Arjun/Elena later | **Keep** | The open lane is *Western consumer*; the one BTR app (Vedic Samay) and India incumbents are Vedic/practitioner (§4.1, §11). |
| **A3** | Tier 0 EN → Tier 1 DE/FR/PT-BR/ES → Tier 2 Hindi (gated) | **Keep — evidence-backed** | BTR demand/vocabulary confirmed in all Tier-1 locales with no app competition (§6); no India mobile BTR competitor forces compression (§11). |
| **A4** | North-star = Real Rectifications Completed / wk | **Keep** | Nothing in competitor evidence challenges the metric; demo-first conversion lever is unique to us (§7, §12.2). |
| **A5** | D1–D5 (name, locale order, Hindi, P0 criterion, pre-IAP paid hold) | **Keep** | D1 name: "Rectify" collides with web BTR-calculator/SEO noise (§4.2, §6.1), supporting "TrueRise" public name + clearance. D5: no install→revenue moment changes pre-IAP; hold stands. |

**New watch-items (not A-level changes):**
- **W1 — Pricing calibration for V1.5 IAP.** $4.99/credit is in-region but
  premium for a single mobile shot vs Vedic Samay; revisit structure (first
  result included / small bundle) at the V1.5 pricing gate (§9).
- **W2 — EU credibility copy.** Germany especially: the gold-standard reference
  refuses rectification; honest-confidence copy is mandatory (§6.2, §7, §12.3).

**Investigate further (Run 3):** the four open verification items in §12.4.

---

## 14. Source Appendix (accessed 2026-06-02)

**Direct BTR — apps / web / services**
- Vedic Samay (App Store, US): https://apps.apple.com/us/app/vedic-samay/id6759082693 — title/subtitle "Birth Time & Numerology", Utilities, IAP $4.99/$14.99/$34.99, 7 free credits; rating not visible.
- Vedic Samay (App Store, AU mirror): https://apps.apple.com/au/app/vedic-samay/id6759082693
- Cosmic Birthtime pricing: https://www.birthchartrectification.com/birth-chart-rectification-pricing — £28, no free tier, PDF.
- Cosmic Birthtime accuracy/FAQ: https://www.birthchartrectification.com/birth-time-rectification-accuracy — "estimation … not absolute certainty"; "launched 2025."
- Cosmic Birthtime (SEO landing examples): https://www.birthchartrectification.com/birth-chart-rectification-calculator , /what-is-birthtime-rectification , /how-birth-time-rectification-works
- AI Pandit: https://aipandit.app/ — web only, no app badge, no price.
- AskSoma kundli-app comparison (self-published): https://asksoma.ai/compare/best/best-kundli-apps.html
- Web calculators: https://horoscopes.astro-seek.com/birth-time-rectification-calculator-primary-directions , https://astromix.net/en/rectification/ , https://www.clickastro.com/birth-time-calculator , https://astro-app.net/rectification.php?lang=en
- Desktop/service BTR: https://www.sadhana.com.br/vega/manual_v7/acerto.htm (Vega 7, BR) , https://www.horizonaarc.com/Kundli-Software/Samay-Sutram-2 (Samay Sutram 2.0, IN) , https://www.astropair.com/Geburtszeitkorrektur-Geburtsdaten.137.0.html (DE)

**Big astrology apps**
- Co-Star: https://www.costarastrology.com/ ; https://apps.apple.com/us/app/co-star-personalized-astrology/id1264782561 ; https://play.google.com/store/apps/details?id=com.costarastrology&hl=en_US (rating/installs not fetchable)
- CHANI "Unknown Birth Time" guidance: https://www.chani.com/astro-education/how-can-i-work-with-my-astrology-chart-if-i-dont-know-my-birth-time ; app: https://apps.apple.com/us/app/chani-your-astrology-guide/id1532791252
- The Pattern: https://www.thepattern.com/natalchart ; https://thepattern.zendesk.com/hc/en-us
- Nebula: https://apps.apple.com/us/app/nebula-horoscope-astrology/id1459969523 ; https://play.google.com/store/apps/details?id=genesis.nebula&hl=en_US

**Locale long-tail (open-web, US locale — not in-store rankings)**
- DE: https://www.astro.com/astrowiki/de/Geburtszeitkorrektur ; https://www.astromeise.de/astrologie/geburtszeitkorrektur/ ; https://www.astropair.com/Geburtszeitkorrektur-Geburtsdaten.137.0.html
- FR: https://astrocalc.fr/calcul-ascendant/ ; https://macalculatriceenligne.com/astrologie/calcul-ascendant/ ; https://azurastrologue.fr/2021/04/18/theme-sans-heure-de-naissance/
- ES: https://carta-natal.es/hora-desconocida.php ; https://www.astroasist.com/es/calculadora-de-ascendente-sin-hora/ ; https://escuelasermasyo.com/rectificacion-carta-natal/
- PT-BR: https://constelar.com.br/tecnica-astrologica/teoria/retificacao-hora-nascimento/ ; https://titividal.com.br/atendimentos/astrologia/retificacao-de-hora/ ; https://www.sadhana.com.br/vega/manual_v7/acerto.htm
- astro.com "unknown time" FAQs (EN/DE/FR/ES/PT): https://www.astro.com/astrowiki/en/Chart_Rectification ; https://www.astro.com/faq/fq_de_time_g.htm ; .../fq_de_time_f.htm ; .../fq_de_time_s.htm ; .../fq_de_time_p.htm

**Policy / category**
- Apple App Review Guidelines: https://developer.apple.com/app-store/review/guidelines/
- 4.3 fortune-telling rejection reports: https://www.quora.com/My-app-got-rejected-by-the-App-Store-due-to-4-3-Spam-primary-function-of-fortune-telling-What-should-I-do-next-to-surpass-the-review ; https://developer.apple.com/forums/thread/737999 ; https://www.imore.com/apple-rejects-developers-horoscope-app-says-app-store-has-enough

**India re-check**
- AstroSage app: https://play.google.com/store/apps/details?id=com.ojassoft.astrosage&hl=en_IN (rating/installs not fetchable) ; BTR article: https://www.astrosage.com/magazine/birthtimerectification.asp ; AstroSage BTR service (per `marketing-research.md`): https://buy.astrosage.com/service/birth-time-rectification

**Review-theme sources (press/aggregator/forum — not store-scraped, some 2019–25)**
- Co-Star: https://justuseapp.com/en/app/1264782561/co-star-personalized-astrology/reviews ; https://www.quora.com/Has-the-astrology-app-Co-Star-proven-to-be-accurate-for-you-What-are-some-examples
- AI-BTR accuracy commentary: https://www.grahai.com/blog/how-accurate-is-ai-astrology ; https://my-zodiac-ai.com/blog/ascendant-calculation-errors-ai-astrology-accuracy

**Reused project sources (already cited in `docs/marketing-research.md`):** see
that file's Sources section for Vedic Samay, Cosmic Birthtime, AstroSage BTR,
AI Pandit, Co-Star/CHANI, Sanctuary, TimePassages, and market-size citations.
No market-size or pricing figure has been newly invented in this document.
