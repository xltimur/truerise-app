# ASO & Naming Strategy - TrueRise / Rectify (Run 3)

**Version:** 1.0 (Run 3 - Naming & ASO Direction)
**Date:** 2026-06-02
**Status:** Decision document for leadership; selects public name + ASO direction;
  input to Run 4 (Feature Gap Analysis)
**Linked to:** `docs/growth-thesis.md` (Run 1), `docs/competitor-aso-research.md`
  (Run 2), `docs/prd.md`, `docs/mvp-scope.md`, `docs/qa-phase8-report.md`,
  `docs/marketing-research.md`

**Scope discipline.** This run is strategy- and documentation-only. It does not
edit app code, change the bundle ID, alter store metadata in any console, build
screenshots, or implement features. It resolves the public-name question and
proposes App Store + Google Play metadata grounded in Run 1 and Run 2 evidence.
Decisions are separated from hypotheses and from validation tasks. No live
ranking, search volume, rating, or trademark clearance is invented; where a fact
needs a console or a lawyer, it is listed in the validation checklist (Section 11)
rather than asserted.

**Reading note on units.** App Store / Google Play character limits cited below
(title 30, iOS subtitle 30, iOS keyword field 100, Play short description 80,
Play long description 4000) are the documented platform limits as understood at
time of writing. Treat every character count in this document as approximate
("~N chars"); the store consoles are the source of truth and count localized
glyphs differently. All counts MUST be re-validated in App Store Connect / Play
Console at submission (Section 11).

---

## 1. Executive Decision

**Recommended public app name: `TrueRise`** (one word, English, retained
globally), presented with a descriptive functional tail that carries the search
weight - e.g. App Store title "TrueRise: Birth Time Finder" and subtitle
"Rectify your birth time." Keep `rectify` as the internal codename and project
name (no change). Bundle/package ID guidance was resolved 2026-06-23: final
first-publish ID is `ua.com.truerise.app` (see
`docs/bundle-id-recommendation.md`).

**Why.**

1. **Brand surface already leans TrueRise.** The README title is "TrueRise
   (codename `rectify`)", the recent commits are "TrueRise MVP demo" /
   "complete TrueRise MVP demo", and the shipped privacy-safe share copy stamps
   every shared result with "Calculated with TrueRise - birth-time
   rectification" (`lib/core/sharing/share_copy_builder.dart`). The organic
   share loop (Run 1 H3) is therefore already advertising "TrueRise"; renaming
   to anything else would orphan that equity.
2. **"Rectify" is search-ambiguous and policy-neutral but generic.** Run 2
   (§4.2, §6.1) found the English long-tail is crowded with web calculators and
   the bare token "rectify" collides with unrelated tools (data/photo
   rectification, GDPR "right to rectification", a TV series). A bare-word brand
   spends its differentiation on disambiguation.
3. **"TrueRise" carries the product's claim.** It reads as "the true rising" -
   the ascendant, the exact thing an unknown birth time hides and the hero card
   reveals (PRD F6.5). It fits the "Quiet Observatory" calm-precision tone (Run 1
   §2.1) and stays clear of "astrology / horoscope / zodiac / fortune", which
   Run 2 §10 shows is a live Apple 4.3(b) trigger.
4. **ASO is recovered by the descriptor, not the brand.** A coined brand has no
   organic search volume on day one; the title tail and subtitle ("Birth Time
   Finder", "Rectify your birth time") capture the long-tail intent that Run 1
   §7.2 and Run 2 §6 validated as low-competition.

**Material delta the leadership must note (corrects Run 1 §9.1; updated
2026-06-12).** Run 1 asserted "the shipped binary ... uses TrueRise as the
public/display name." At Run 3 time (2026-06-02) that was only half true: the
display/launcher labels still read "Rectify"/"rectify". That finding is now
**superseded** - the display-name alignment has shipped. Re-verified
2026-06-12:

| Surface | Current value | Says |
|---|---|---|
| README title | `# TrueRise` | TrueRise |
| Commit messages | "TrueRise MVP demo" etc. | TrueRise |
| In-app share copy | "Calculated with TrueRise ..." | TrueRise |
| iOS `CFBundleDisplayName` (home-screen icon label) | `TrueRise` | **TrueRise** |
| Android `android:label` (launcher label) | `TrueRise` | **TrueRise** |
| iOS `CFBundleName` / project / bundle ID | `rectify` / `ua.com.truerise.app` | rectify + final store ID |

So the **installed app icon now reads "TrueRise" on both iOS and Android**,
matching the brand/marketing surface. The remaining internal-only codename is
`CFBundleName` / project name `rectify`; the shipped store identity is now
`ua.com.truerise.app`.

**Decision asked of leadership:** confirm `TrueRise` as the public store name
(pending the clearance items in Section 11; the display-name alignment is
done), or instruct a clearance run on both `TrueRise` and `Rectify` before
deciding.

---

## 2. Naming Decision Matrix

Scoring is qualitative (High / Med / Low) and grounded in Run 1 / Run 2 evidence,
not invented volume or rating numbers. "ASO fit" = intent-match strength of the
name as a *searchable* token; brand names score Low here by nature and recover
ASO through the descriptor (Section 4).

| Dimension | TrueRise (brand) | Rectify (PRD working title) | Birth Time Finder (descriptive) | Birth Time Rectifier (descriptive) | Rising Sign Finder (descriptive) |
|---|---|---|---|---|---|
| ASO fit (name as search token) | Low alone / High w/ descriptor tail | Med (partial "rectify birth time" match, diluted by noise) | High (exact long-tail) | High (exact long-tail, lower volume word "rectifier") | Med-High (matches "rising sign" but that is a stretch/competitive term, Run 1 §7.2) |
| Policy risk (Apple 4.3(b), Run 2 §10) | Low (neutral, no astrology lexicon) | Low | Low | Low | Low-Med ("rising sign" is a chart term, not fortune-telling, but edges toward astrology framing) |
| Memorability / brandability | High | Med-High (generic action word) | Low (commodity phrase) | Low | Low |
| Trust / tone fit ("Quiet Observatory") | High ("true", precision, ascendant pun) | Med (precise but cold; "rectify" implies prior error) | Med (clear, no equity) | Med | Med |
| Locale portability (DE/FR/ES/PT-BR) | High as a kept-English brand; pun does not translate but brand travels | Low-Med (low-frequency English word; cognate "rectification" helps the descriptor, not the bare brand) | Low as fixed brand (would need translation); High as a *descriptor* | Low as brand / High as descriptor | Low as brand / Med as descriptor |
| Trademark / clearance | UNVERIFIED - clearance required; "rise/true" common in app names, moderate collision risk | UNVERIFIED - higher collision (software tools + TV series share the word) | Generic - weak protectability, low collision | Generic - weak protectability, low collision | Generic - weak protectability, low collision |
| Screenshot / store storytelling fit | High - "the true rising" ties directly to hero card (time + rising + confidence) | Med | High on clarity, Low on story | High on clarity, Low on story | Med (foregrounds rising sign, which is the value but also the astrology-adjacent surface) |

**Read.** No descriptive name wins as a *brand*: generic phrases are weakly
protectable, non-portable as fixed names, and any competitor can copy them.
"Rectify" carries real search-noise and collision risk (Run 2 §4.2/§6.1).
"TrueRise" wins on memorability, trust, tone, portability, and policy-neutrality,
and recovers its one weakness (no native search volume) by pairing with a
descriptive title tail and subtitle. The descriptive phrases are best used **as
the descriptor line, not as the brand** (Section 3).

---

## 3. Recommended Naming Architecture

- **Public brand (global, English, do not translate):** `TrueRise`.
- **Functional descriptor (the ASO-bearing line; localized per locale):**
  English default "Birth Time Finder" (title tail) and "Rectify your birth time"
  (subtitle). This is the line that carries long-tail keywords and that gets
  translated for Tier 1 locales (Section 9).
- **Internal codename / project (do not change):** `rectify`,
  `CFBundleName=rectify`. Already in place; keeps git history, CI, and the
  keychain service name stable.
- **Shipped bundle/package ID:** `ua.com.truerise.app`, implemented for first
  App Store Connect / Play Console records.
- **Home-screen display name (aligned as of 2026-06-12):**
  `CFBundleDisplayName` (iOS) and `android:label` (Android) are set to
  `TrueRise` - see Section 1 and Section 11.

**What NOT to use:**

- Do not ship a bare descriptive phrase ("Birth Time Finder") as the *brand* -
  not defensible, not portable, copyable by competitors.
- Do not put "astrology", "horoscope", "zodiac", "fortune", "psychic", "tarot",
  or "kundli" in the *brand* or the *primary* title/subtitle (Apple 4.3(b),
  Run 2 §10).
- Do not localize the brand token "TrueRise" itself (Section 9).
- Do not use the bare word "Rectify" as the public store name (search noise +
  collision, Run 2 §4.2/§6.1).
- Do not adopt any PRD §2 alternative (Natara, BirthLens, Ascendant, Tempus,
  Charted) - none is reflected in the binary, share copy, or README, and each
  re-opens a settled brand surface for no evidenced gain.

---

## 4. App Store (iOS) Metadata Strategy

### 4.1 Category

**Current recommendation (post-Appeeky, 2026-06-15): primary `Lifestyle`** (see
§14.4). This is where the astrology comparison set and audience sit; it trades
the earlier Utilities 4.3(b) caution for discoverability/featuring. Because the
category no longer carries the 4.3(b) shield, the §7 probabilistic/utility copy
rules matter more, not less, to keep the listing reading as a calculation tool.

**Superseded (earlier posture): primary Utilities, optional Secondary
Reference.** Rationale (Run 2 §10, evidence-backed): Apple Guideline 4.3(b) names
"fortune telling / astrology / horoscopes / zodiac reports" as a saturated
category subject to rejection, and disclaimers do not cure a 4.3 rejection. The
one real mobile-native BTR incumbent, Vedic Samay, ships in Utilities - a working
precedent, and the single-function calculation framing is the textbook 4.3
answer. This was the original recommendation and is retained as the
4.3(b)-risk-minimizing rationale, but it is **no longer the recommended
category** - the Appeeky-driven Lifestyle choice in §14.4 supersedes it, and the
earlier "do not select Lifestyle" instruction no longer applies.

> **Update 2026-06-15 (Appeeky audit):** the Appeeky audit recommends primary
> category **Lifestyle, not Utilities**, on discoverability grounds (the
> astrology competitors sit in Lifestyle; Utilities is argued to weaken
> discoverability/featuring and to risk reclassification). This reverses the
> earlier 4.3(b)-driven posture; the trade-off (4.3(b) review risk vs
> discoverability/featuring) has been resolved in favor of Lifestyle, now the
> current recommendation. See §14.4.

### 4.2 Title candidates (~30 char limit; validate in console)

Format = brand + one functional phrase. Counts approximate.

| Candidate | ~Chars | Note |
|---|---|---|
| `TrueRise: Birth Time Finder` | ~27 | Recommended high-intent default; "Birth Time Finder" is a Run 1 §7.2 long-tail target |
| `TrueRise - Birth Time Finder` | ~28 | Hyphen separator variant |
| `TrueRise: Find Birth Time` | ~25 | Verb-led variant |
| `Birth Time Finder: TrueRise` | ~27 | Keyword-first variant (front-loads the long-tail; brand second) |
| `TrueRise: Birth Time Rectify` | ~28 | Uses "rectify" token; slightly awkward as a verb tail |
| `TrueRise` | ~8 | Brand-only; wastes title ASO surface - use only if console flags the descriptor |

### 4.3 Subtitle candidates (~30 char limit; validate in console)

Plain-language intent capture, no mystic lexicon (Run 1 §7.3, design-system tone).

| Candidate | ~Chars | Note |
|---|---|---|
| `Rectify your birth time` | ~23 | Recommended; clean, action-led, adds the "rectify" token without it being the brand |
| `Birth time from life events` | ~27 | Adds "life events" token; describes the method |
| `Estimate your birth time` | ~24 | Probabilistic verb ("estimate") - reinforces the no-certainty posture |
| `Find your true birth time` | ~25 | Echoes the brand ("true") |

### 4.4 Keyword bank (grouped)

Apple indexes title + subtitle + keyword field together and de-duplicates, so the
keyword field should add tokens NOT already in the chosen title/subtitle. Treat
the field as reach, not exact-match incantation (Run 1 §7.3).

- **Group A - high-intent long-tail (primary, realistic top-10 ambition):**
  rectification, birth, time, finder, calculator, unknown, approximate, exact,
  accurate, ascendant, rising. (Run 1 §7.2; Run 2 §6.1 confirms web/Vedic-only
  competition on the app side.)
- **Group B - supporting astrology terms (reach; hidden field only, never the
  primary title/subtitle):** natal, chart, houses, sign, astrology. These are how
  the "Maya" persona searches; including them in the hidden field aids
  discoverability without putting astrology in the visible positioning.
- **Group C - too-competitive head terms (do NOT spend primary slots; optional
  low-priority reach at most):** horoscope, zodiac, birth chart, astrology
  (as a standalone head term). Run 1 §7.1 - not realistic top-10; including them
  burns relevance for no ranking. Prefer to omit rather than pad.
- **Group D - blocked / policy-risky (do NOT use anywhere - title, subtitle,
  keywords, or category):** fortune, fortune telling, psychic, tarot, oracle,
  divination, palm reading, "predict your future", "destiny". These both invite
  Apple 4.3(b) scrutiny (Run 2 §10) and pull the wrong audience (Run 1 §2.3).
  "kundli" is also avoided for Tier 0/1 (it signals the Vedic audience we are
  deliberately not marketing to pre-KP, Run 1 §4.3).

### 4.5 100-char keyword-field draft options (caveat: validate in App Store Connect)

These assume the recommended title ("TrueRise: Birth Time Finder") and subtitle
("Rectify your birth time"), so they avoid repeating birth, time, finder,
rectify, true, your. Counts are approximate; App Store Connect is authoritative
and localized counts differ.

- **Draft A (~98 chars), long-tail led + light astrology reach:**
  `rectification,ascendant,rising,natal,chart,calculator,unknown,accurate,exact,astrology,houses,sign`
- **Draft B (~90 chars), pure utility, no head terms:**
  `rectification,ascendant,rising,calculator,unknown,approximate,accurate,exact,natal,chart,houses`

Pick one after the title/subtitle are locked, then re-count in console. Do not
add "horoscope/zodiac/fortune" to recover characters - leave the field short
rather than pad with head/blocked terms.

---

## 5. Google Play Metadata Strategy

Play has no saturation-rejection signal equivalent to Apple 4.3(b) (Run 2 §10,
not re-verified this run - see Section 11), but its restricted-content and
health-claim policies still bind; the no-medical-claims non-goal (Run 1 §10)
covers that. **Current recommendation (post-Appeeky, §14.4): primary
Lifestyle** - mirroring the iOS choice, it places the listing where the
astrology-curious browse; the §7 4.3-style copy distancing then matters more, not
less. *Superseded (earlier posture):* **Tools**, chosen to mirror the old Apple
Utilities posture and the single-function framing and recommended then for
consistency - retained as historical rationale, not the category to select.

### 5.1 Title candidates (~30 char limit)

Same set as iOS (Section 4.2). Recommended: `TrueRise: Birth Time Finder` (~27).

### 5.2 Short description candidates (~80 char limit)

Play weights the short description for ranking; lead with intent + method.

| Candidate | ~Chars | Note |
|---|---|---|
| `Find your most likely birth time from your life events - with evidence.` | ~70 | Recommended; probabilistic ("most likely"), method ("life events"), trust ("evidence") |
| `Don't know your birth time? Estimate it from your life events, with evidence.` | ~77 | Question hook; "estimate" reinforces no-certainty |
| `Rectify your birth time from real life events. See the evidence behind it.` | ~73 | "rectify" + "evidence" |

### 5.3 Long description outline (~4000 char limit; first ~250 chars are the hook)

Play indexes the full long description and shows the first ~2-3 lines before
"read more", so the **first ~250 characters must front-load the value + the
primary long-tail phrase** without keyword stuffing.

- **First ~250 chars (above the fold):** the value proposition in plain language,
  using "birth time", "rectify/rectification", and "life events" naturally once
  each. Draft: "You don't know your exact birth time. TrueRise estimates your
  most likely birth time from the real events of your life - and shows you the
  evidence behind every candidate, with a confidence score. No exact time needed
  to start." (~245 chars - validate.)
- **Body section 1 - How it works:** enter approximate birth window + city ->
  add life events (marriage, moves, births, career, loss, etc.) -> get ranked
  candidate times with confidence and per-event evidence. Mirrors PRD F2-F7.
- **Body section 2 - Why it is trustworthy:** probabilistic, not deterministic;
  shows its work ("See how we got this"); your data stays on device; free
  offline demo before you commit anything (Run 2 §7 - the "is this accurate, can
  you show me why" axis; Run 1 §2.2).
- **Body section 3 - What it is and is not:** a focused birth-time calculation
  utility; not a horoscope feed, not fortune telling, not a Vedic super-app
  (Run 1 §2.3; supports the Play restricted-content posture).
- **Body section 4 - Privacy line:** data stored on device; nothing shared
  without explicit action; privacy-safe sharing shares only time + rising +
  confidence (verified feature, Section 8).
- **Closing line:** one natural-language repetition of the primary phrase
  ("birth time rectification") + a soft CTA ("Try the free demo").

### 5.4 Keyword placement guidance (no stuffing)

- Use each Group A long-tail phrase 1-2 times across short + long description in
  natural sentences; never as a comma list or repeated block (Play penalizes
  repetition and it reads as spam to reviewers).
- Put the single most important phrase ("birth time" + "rectify/rectification")
  in the title-tail, the short description, and the first 250 chars of the long
  description - that triple placement is the highest-signal, lowest-risk play.
- Keep Group C head terms (horoscope, zodiac) out of the title and short
  description; at most one incidental mention deep in the long description.
- Keep Group D blocked terms out entirely.

---

## 6. Query Strategy

### 6.1 Tier 0 (English) - realistic primary targets (top-10 ambition, 60-120 days)

Per Run 1 §7.2 and Run 2 §6.1 (lane confirmed open on the app side; only
web/Vedic competition). These are low-volume; top-10 yields small absolute
installs ("low tens per week" shape, Run 1 §5/§7.2) - breadth (locales) and the
share loop build volume, not any single term.

- "birth time rectification"
- "rectify birth time"
- "find my birth time"
- "birth time calculator"
- "birth time finder"
- "approximate birth time" / "unknown birth time"

### 6.2 Tier 0 - too-competitive, do NOT chase as primary (stretch at most)

Per Run 1 §7.1. Include in the hidden keyword field only as reach; do not build
the title/subtitle or success criteria around them, and do not promise top-10.

- "astrology", "horoscope", "zodiac", "birth chart"
- "ascendant calculator", "rising sign calculator" (generic-chart-calculator
  competition; Run 1 §7.2 marks these "stretch")

### 6.3 Locale-specific direction (DE / FR / ES / PT-BR)

Direction only, using Run 2 §6 observed native vocabulary - full translation is
Tier 1 localization work, not this run. The brand stays "TrueRise"; the
descriptor is what gets localized (Section 9).

- **DE:** Geburtszeitkorrektur, Geburtszeit berechnen, Geburtszeit unbekannt,
  Aszendent berechnen (stretch). Supply is web/service/desktop, no app (Run 2
  §6.2). Highest credibility bar (Section 9).
- **FR:** rectification heure de naissance, trouver / calculer mon heure de
  naissance, calcul ascendant heure inconnue (stretch). astrocalc.fr is the
  closest functional analog and is web-only (Run 2 §6.3) - design reference, not
  a store competitor.
- **ES:** rectificacion hora de nacimiento, calcular hora de nacimiento,
  calculadora ascendente (stretch). Calculators that degrade rather than rectify
  (Run 2 §6.4).
- **PT-BR:** retificacao hora de nascimento, calcular hora de nascimento,
  calcular ascendente (stretch). Strong astrology culture; practitioners expect
  10+ dated events - set that expectation in PT-BR copy (Run 2 §6.5).

In-store (native-front) ranking for these terms is unverified (Run 2 §2/§12.4);
it is a Tier 1 / Run 4+ console task, not a claim made here.

---

## 7. Policy-Safe Copy Rules

### 7.1 Apple 4.3(b) mitigation (Run 2 §10)

- Lead every visible surface (title, subtitle, first screenshot, first 250 chars
  of the Play description) with the **calculation function**, not with
  "astrology / horoscope / zodiac / fortune."
- **Category (updated 2026-06-15):** the original 4.3(b) mitigation chose
  **Utilities** (iOS) / **Tools** (Play) over a horoscope/Lifestyle slot. The
  current recommendation is **primary Lifestyle** on both stores (§4.1 / §5 /
  §14.4), so the category no longer acts as the 4.3(b) shield - the remaining
  bullets here carry that load instead.
- Demonstrate a **unique, single, high-quality function** (probable birth time
  from life events, with evidence) - this, not a disclaimer, is what answers 4.3.
- Keep the visible positioning indistinguishable from a calculator/utility; let
  the screenshots show a tool (Section 8).

### 7.2 Probabilistic / utility wording (non-negotiable, Run 1 §2.2/§10)

- Always "most likely" / "probable" / "estimate" / "candidate time" + a
  confidence percentage. Never "your birth time is X."
- Frame confidence as a range/score, never a guarantee (PRD §16).
- Use "shows the evidence" / "see how we got this" - the show-your-work trust
  wedge that Run 2 §7 identifies as the category's winning axis.

### 7.3 Words and claims to avoid (anywhere user-visible)

- Fortune-telling lexicon: fortune, destiny, predict your future, psychic, tarot,
  oracle, divination, palm reading (policy + wrong audience).
- Certainty claims: "exact", "guaranteed", "100%", "definitive", "proven" as a
  result claim (contradicts the probabilistic posture). ("exact" is fine only in
  the user's *problem* statement - "you don't know your exact time" - never in
  the result claim.)
- Medical / legal / financial framing of any kind (Run 1 §10, PRD §13).
- Deterministic astrology claims of any kind.

### 7.4 How to mention astrology without looking like another horoscope app

- Reference astrology as the **method context**, not the **product category**:
  "uses astrological transits and progressions to score candidate times" reads as
  a calculation method; "your daily horoscope" reads as a feed.
- Name the concrete deliverable (rising sign / ascendant, birth time) rather than
  the mood ("cosmic insight", "what the stars say").
- Keep astrology terms in the hidden keyword field (Group B) and deep body copy,
  not in the title/subtitle/first-screenshot. This is exactly the line Vedic
  Samay walks by sitting in Utilities (Run 2 §4.1/§10).

---

## 8. Screenshot / Storytelling Implications (for later store assets)

Run 2 §8 found the field rewards the order Run 1 §7.3 specified, and that this
order also reads as a "tool," reinforcing the 4.3 case. Screenshots are NOT built
in this run; this is direction for the later asset run.

1. **Screenshot 1 - the answer (hero).** The rectified time, the rising sign, and
   the confidence percentage on the result hero card (PRD F6.1-F6.4). Message:
   "Your most likely birth time - with a confidence score." This is the single
   value moment; it leads.
2. **Screenshot 2 - the evidence (trust).** The per-event evidence breakdown
   (PRD F7): each life event with Strong/Moderate/Weak match + the "X of Y events
   strongly supported this time" summary. Message: "See exactly why." Directly
   answers the category's "can you show me?" complaint (Run 2 §7).
3. **Screenshot 3 - demo / offline / privacy.** The offline demo badge + a
   privacy line. Message: "Try it free, offline, before you commit anything -
   your data stays on your device." The demo is the unique conversion lever no
   competitor offers (Run 2 §4.1/§12.2); it must appear in the listing.
4. **Screenshot 4 - share / result (verified feature).** The privacy-safe share
   is shipped: `ShareCopyBuilder` (`lib/core/sharing/share_copy_builder.dart`),
   the `resultShareButtonKey` button on the result screen, and the
   `rectify/share` platform channel (build-history 2026-05-22; Run 1 §6.4/H3).
   The privacy-safe image share is also shipped in-repo (as of 2026-06-12) via
   `share_plus`: `lib/core/sharing/story_card_renderer.dart`,
   `ShareService.shareImagePng`, and the `resultShareImageButtonKey` button on
   the result screen. Both text and image share expose only the rectified time,
   the rising sign when present, the confidence score, the brand, and the
   public URL/caption - never birth date, city, life events, coordinates, or
   API identifiers. Message: "Share your result - without sharing your private
   data." Safe to feature both text and image share; do not claim direct
   Instagram Stories integration.

Do not lead any screenshot with zodiac wheels, horoscope feeds, or mystic
imagery - that reintroduces the 4.3 surface the rest of the strategy removes.

---

## 9. Localization Implications

- **Public brand "TrueRise" stays English globally - do not translate or
  transliterate it.** It is a coined token; translating it destroys recognition
  and the already-shipped share-loop equity. (Run 1 §4.2 keeps the product
  English-only for Tier 0; Tier 1 localizes around the brand, not the brand.)
- **The descriptor is what gets localized** - the title tail, subtitle, short
  description, keyword field, and long description. Map to the Run 2 §6
  vocabulary: DE "Geburtszeitkorrektur" / "Geburtszeit berechnen", FR
  "rectification heure de naissance", ES "rectificacion hora de nacimiento",
  PT-BR "retificacao hora de nascimento."
- **Credibility tone differs by locale (Run 2 §6.2, §7, §12.3, W2):**
  - **DE - highest credibility bar.** The gold-standard reference (Astrodienst)
    publicly refuses rectification as unreliable, and pure auto-calc apps are
    described as rare. German copy must be the most sober: maximal honest-
    confidence framing, evidence-forward, zero hype. This is watch-item W2.
  - **FR / ES - "fetch the official record first" context.** Users are routinely
    told to get the birth certificate first; copy can acknowledge that and
    position TrueRise as the next step when the record is missing or unclear.
  - **PT-BR - strong astrology culture, higher event expectation.** Practitioners
    expect 10+ dated events; PT-BR copy should set the "more events = better
    result" expectation explicitly (matches PRD F4.4 soft warning).
- Brand-token-stays-English + descriptor-localized is the cheapest split that
  preserves recognition while capturing native long-tail (Run 1 §4.2: ASO text +
  ~250 strings, no product code change).

---

## 10. Decision Deltas from Run 1 (A1-A5) and Run 2 Watch-Items

| Source item | This run's position |
|---|---|
| **A1** Utility / probabilistic framing | **Honored and operationalized** into copy rules (Section 7) and screenshot order (Section 8). *(The category leg - originally Utilities/Tools - is superseded as of 2026-06-15: primary Lifestyle, §14.4; the probabilistic/tool-led copy framing is unchanged and matters more under Lifestyle.)* |
| **A2** "Maya" ICP first | **Honored** - keyword bank, copy, and screenshots target the English consumer enthusiast; "kundli" deliberately excluded from Tier 0/1 (Run 1 §4.3). |
| **A3** Tier 0 -> Tier 1 (DE/FR/PT-BR/ES) -> Tier 2 Hindi (gated) | **Honored** - Section 6.3 / Section 9 give Tier 1 descriptor direction only; no Hindi/India ASO proposed. |
| **A4** North-star RRC/wk | **Honored** - top-10 ambition framed only on realistic long-tail; head terms explicitly not success criteria. |
| **A5 / D1** Public name TrueRise vs Rectify | **Resolved: recommend TrueRise**, consistent with Run 2 §13 (D1). **Delta vs Run 1 §9.1 (superseded 2026-06-12):** at Run 3 time the binary's *display name* read "Rectify"/"rectify"; the alignment has since shipped and `CFBundleDisplayName` / `android:label` now read "TrueRise" (Section 1). Clearance steps remain open in Section 11. |
| **W1** Pricing calibration for V1.5 IAP | **Out of scope** for this run (no pricing here); carried to V1.5 gate per Run 2 §13. No price appears in any proposed metadata. |
| **W2** EU credibility copy (DE especially) | **Honored** - Section 9 makes German the most sober copy locale; probabilistic wording made non-negotiable (Section 7.2). |
| Run 2 §12.4 open verification items | **Carried** into Section 11 (in-store rankings, store ratings/installs, Play policy specifics, structured review sample). |

No A-level decision is re-opened. The factual correction Run 3 logged here
(display name not yet aligned in the binary) is superseded as of 2026-06-12:
the binary display/launcher name now reads "TrueRise" (Section 1).

---

## 11. Open Validation Checklist (before final store submission)

Decisions above are proposals; the following must be verified by a human / console
/ counsel before submission. Separated from the decisions deliberately.

**Naming / legal (blocking for the name decision):**
1. [ ] Trademark clearance for "TrueRise" in Tier 0 + Tier 1 jurisdictions
   (counsel / search - NOT done here, not assertable).
2. [ ] App Store name availability for "TrueRise" in each Tier 0 front (App Store
   Connect).
3. [ ] Domain availability check (`.com` + locale TLDs) for the brand.
4. [x] Align `CFBundleDisplayName` (iOS) and `android:label` (Android) to
   "TrueRise" - done; verified 2026-06-12 (both read "TrueRise" in the binary).

**Metadata / ASO (blocking for submission):**
5. [ ] Re-count every title/subtitle/short-description candidate in App Store
   Connect / Play Console (localized glyph counts differ from this doc's ~Ns).
6. [ ] Finalize and re-count the 100-char keyword field in console after
   title/subtitle lock.
7. [ ] Confirm final category selection in console - current recommendation is
   **primary Lifestyle** on both stores (§4.1 / §5 / §14.4); the earlier
   Utilities/Reference (iOS) / Tools (Play) posture is superseded.

**Carried from Run 2 §12.4 (informational, not blocking the name decision):**
8. [ ] In-store native-front search rankings for the Section 6 terms (App Store
   Connect / Play Console search-term tools or localized-device check).
9. [ ] Direct store ratings / review counts / install bands for competitors (not
   fetchable in Run 2).
10. [ ] Google Play astrology / restricted-content policy specifics
    (not re-verified in Run 2; Section 5 assumes no saturation-rejection).
11. [ ] Optional: structured review sample for Vedic Samay + 1-2 majors to
    quantify the Run 2 §7 qualitative themes.

**Privacy / policy gate (already partly covered by PRD §13):**
12. [ ] Hosted privacy-policy URL live before submission (deferred item, Run 1
    §9.4 / qa-phase8-report §6) - required by both stores.

---

## 12. Final Recommended Metadata Draft Set

Three clearly-marked options. All counts approximate - re-validate in console
(Section 11). The category leg shown in all three (Utilities on iOS / Tools on
Play) reflects the earlier posture and is superseded: the current recommendation
is primary **Lifestyle** on both stores (§14.4).

> **Update 2026-06-15:** the Appeeky audit defines the current launch package
> (subtitle `Estimate your rising sign`, a new iOS keyword field, a new Play
> short description, and a **Lifestyle** category), which supersedes the launch
> defaults below. See §14.

### Option C - Conservative (lowest policy risk, brand + neutral utility)

- **Title:** `TrueRise: Birth Time Finder` (~27)
- **Subtitle (iOS):** `Estimate your birth time` (~24)
- **Play short description:** `Find your most likely birth time from your life
  events - with evidence.` (~70)
- **iOS keywords (~90):**
  `rectification,ascendant,rising,calculator,unknown,approximate,accurate,exact,natal,chart,houses`
- **Posture:** zero head terms, maximal probabilistic wording; safest for DE and
  for 4.3 review.

### Option H - High-intent ASO (maximize long-tail capture)

- **Title:** `Birth Time Finder: TrueRise` (~27, keyword-first)
- **Subtitle (iOS):** `Rectify your birth time` (~23)
- **Play short description:** `Don't know your birth time? Estimate it from your
  life events, with evidence.` (~77)
- **iOS keywords (~98):**
  `rectification,ascendant,rising,natal,chart,calculator,unknown,accurate,exact,astrology,houses,sign`
- **Posture:** front-loads the long-tail phrase and adds light astrology reach
  (Group B); slightly higher review attention - keep screenshots tool-led.

### Option B - Brand-led (build the TrueRise brand first)

- **Title:** `TrueRise: Birth Time Finder` (~27)
- **Subtitle (iOS):** `Find your true birth time` (~25)
- **Play short description:** `Rectify your birth time from real life events. See
  the evidence behind it.` (~73)
- **iOS keywords (~90):**
  `rectification,ascendant,rising,calculator,unknown,approximate,accurate,natal,chart,houses,sign`
- **Posture:** brand token leads everywhere; relies on the share loop (H3) and
  descriptor tail for discovery; best if leadership prioritizes long-run brand
  equity over day-one keyword capture.

**Recommendation:** launch with **Option H** in Tier 0 (the lane is open and
day-one brand search is ~zero, so capturing long-tail intent matters most), and
re-evaluate toward **Option B** once brand search and the share loop produce
measurable branded installs (Run 1 H3). Use **Option C** verbatim for the German
(DE) front regardless, per the W2 credibility bar (Section 9).

---

## 13. Source / Evidence Appendix

**Project docs (authoritative for product decisions):**
- `docs/growth-thesis.md` (Run 1) - §2 category/anti-positioning, §3 ICP,
  §4 locale tiers, §5 north-star, §7.1/§7.2/§7.3 head-vs-long-tail + ASO posture,
  §9 D1-D5 (D1 name), §10 non-goals, §12 A1-A5 approval gate.
- `docs/competitor-aso-research.md` (Run 2) - §1 executive answer, §2 access
  limitations, §4.1-§4.2 (Vedic Samay Utilities precedent; "Rectify" search
  noise), §6.1-§6.5 locale vocabulary, §7 review-mining axis, §8 screenshot
  patterns, §10 Apple 4.3(b), §12 implications for Run 3, §13 A1-A5 deltas +
  W1/W2 + §12.4 open items.
- `docs/prd.md` - §2 app name working title + alternatives, §6 value prop /
  differentiation table, §8 non-goals, §13 privacy, §16 risks (App Store
  category row), §17 phases (share card shipped as privacy-safe story-card
  image share; future: Hindi, KP/Vedic, direct Instagram Stories pending
  Meta/Facebook App ID).
- `docs/marketing-research.md` - reused only for competitor pricing / ICP context
  already cited by Run 1/Run 2; no new external figure introduced here.
- `docs/qa-phase8-report.md` - deferred items (hosted privacy policy, app-icon
  glyph) feeding Section 11.

**Code / config verified in this run (2026-06-02, read-only):**
- `lib/core/sharing/share_copy_builder.dart` - share copy stamps "TrueRise -
  birth-time rectification"; PII-free (time + rising + confidence only).
- `lib/core/sharing/share_service.dart` - share feature present (build-history
  2026-05-22).
- `ios/Runner/Info.plist` - `CFBundleDisplayName=Rectify` at Run 3 time; since
  updated to `TrueRise` (re-verified 2026-06-12). `CFBundleName=rectify`
  (unchanged).
- `android/app/src/main/AndroidManifest.xml` - `android:label="rectify"` at
  Run 3 time; since updated to `TrueRise` (re-verified 2026-06-12).
- `android/app/build.gradle.kts` - `applicationId = "ua.com.truerise.app"`.
- `README.md` - title "TrueRise (codename `rectify`)".

**Run 2 external sources (cited there, not re-fetched here):** see
`docs/competitor-aso-research.md` §14 (Vedic Samay listing, Cosmic Birthtime,
Apple App Review Guidelines 4.3, locale long-tail pages, astro.com rectification
FAQs). No live ranking, search volume, rating, or trademark clearance is asserted
in this document; all such items are routed to Section 11.

---

## 14. Appeeky Audit Update (2026-06-15) - Revised Metadata Package & Category

**Basis.** Built on the Appeeky pre-launch data recorded in
`docs/competitor-aso-research.md` §15 (competitor keyword ranks + ratings, and
the `birth time` / `rising sign` / `rectify` keyword popularity/difficulty
scores). Appeeky's direct ASO Audit / Opportunities could not run pre-launch
(the manual app entry is "Not yet live"); these are recommendations to apply at
submission and then re-validate against the live listing.

### 14.1 Title and subtitle

- **Title - keep:** `TrueRise: Birth Time Finder` (~27). Unchanged from §4.2 /
  §12; `birth time` is reachable for a focused app (Appeeky: `birth time`
  difficulty 29 easy; TimePassages ranks #2 on it).
- **Launch subtitle:** `Estimate your rising sign` (~25). This replaces the
  earlier launch default (`Rectify your birth time` / `Estimate your birth
  time`) and leads with the highest-popularity term the audit surfaced (`rising
  sign`, popularity 55).
- **Caveat - `rising sign` is conversion / long-tail at launch, not an
  immediately winnable ranking.** Appeeky shows it at difficulty 53 with 0/50
  exact-name listings, and the term is held by incumbents with tens to hundreds
  of thousands of reviews (Co-Star #1 / ~205k, Nebula #3 / ~170k, The Pattern
  #4, TimePassages #5; `docs/competitor-aso-research.md` §15.1). TrueRise
  launches with zero reviews, so the subtitle works as a high-intent conversion
  line, not a day-one rank target.
- **Preserve the `rectify` / `rectification` niche.** It is the ownable,
  uncontested lane (Appeeky: `rectify birth time` difficulty 27, 0/50 in-name;
  §15.2). The `rectify` token is retained in the keyword field below, and the
  title's "Birth Time" + `rectify` keeps `rectify birth time` / `birth time
  rectification` coverage.

### 14.2 iOS keyword field (recommended)

```
rectify,ascendant,natal,chart,calculator,unknown,horoscope,astrology,houses,zodiac,moon,sun
```

**(91 / 100 characters.)** Built against the title `TrueRise: Birth Time
Finder` and the subtitle `Estimate your rising sign`, so it **intentionally
avoids duplicating** any title/subtitle word (truerise, birth, time, finder,
estimate, your, rising, sign) - Apple indexes name + subtitle + keywords
together and de-duplicates. It keeps the `rectify` niche token and, unlike the
§4.4 Group C/D guidance under the prior Utilities posture, **now includes
astrology head terms** (`horoscope`, `astrology`, `zodiac`, `moon`, `sun`);
that is a deliberate shift that pairs with the Lifestyle category in §14.4.
Re-count in App Store Connect after the title/subtitle are locked.

### 14.3 Google Play short description (recommended)

```
Estimate your birth time, rising sign & natal chart from life events.
```

Leads with `estimate` (probabilistic, not certainty) and names the three
deliverables (birth time, rising sign, natal chart) plus the method (life
events).

### 14.4 Category recommendation - Lifestyle (revises §4.1)

The audit recommends **primary category `Lifestyle`, not `Utilities`**, because:

- the astrology competitors above all sit in **Lifestyle**, so that is where the
  audience and the comparison set are;
- **Utilities weakens discoverability and featuring** for an astrology-adjacent
  app and may **risk reclassification**.

This **reverses** the earlier §4.1 / Run 2 §10 recommendation, which chose
Utilities specifically as the Apple **4.3(b)** survival posture (precedent: Vedic
Samay in Utilities). The two positions trade **discoverability/featuring
(Lifestyle)** against **4.3(b) review risk (Utilities)**; that trade-off has been
resolved in favor of **Lifestyle**, now the current recommendation across this
doc and `docs/store-listing-en.md`. Because the category no longer provides the
4.3(b) shield, the §7 probabilistic/utility copy rules matter **more**, not less,
to keep the listing reading as a calculation tool.

### 14.5 Screenshot caption direction

Order the captions problem-hook -> life events -> result -> evidence ->
privacy/demo. Use `estimate`; never `exact` or `guaranteed` as a result claim
(§7.3; `docs/store-listing-en.md` §6).

1. **Problem hook:** `Don't know your exact birth time?` ("exact" is allowed
   only in the user's *problem* statement, never as a result claim.)
2. **Life events:** the dated life-event input.
3. **Result:** estimated time + rising sign + confidence.
4. **Transparent evidence:** the per-event "see how we got this" breakdown.
5. **Privacy / offline demo:** on-device; offline demo before committing
   anything real.

### 14.6 Post-launch tracking (after the listing is live)

Track in Appeeky once the listing is live (resubscribe per
`docs/competitor-aso-research.md` §15.3): `rectify birth time`, `birth time
finder`, `birth time rectification`, `rising sign`, `ascendant`.

The full after-live runbook (Appeeky ASO Audit + Opportunities, this tracking
set, the experimentation matrix, per-locale keyword research, and Apple Search
Ads prep) lives in `docs/post-launch-aso-plan.md`.
