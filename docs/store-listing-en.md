# Store Listing — English Tier 0 (TrueRise)

**Impl Run A.4 · 2026-06-02 · model `claude-opus-4-8`.**
**Status: ready-to-paste English metadata for App Store Connect + Google Play
Console.** Finalizes the owner-independent part of **P0-8** in
`docs/store-submission-readiness.md` (store metadata + replace the `pubspec`
placeholder description). Screenshots, hosted URLs, signing, and the bundle-ID
decision remain owner work (see the checklist at the end).

> **How to use this file.** Each field below is the literal string to paste,
> with an approximate character count. **Re-count every field in the store
> console before locking** — App Store Connect and Play Console count glyphs
> differently from this file. Counts here were taken with a byte/character
> check; the only field where the count is load-bearing for a hard limit is the
> iOS keyword field (shown exactly). Nothing in this document asserts a store
> ranking, install count, rating, trademark clearance, or store approval; those
> are owner items.
>
> **Research preserved, not re-opened.** This finalizes the drafts in
> `docs/aso-naming-strategy.md` (Run 3) and `docs/store-submission-readiness.md`
> (Run 6) against the verified post-A.1/A.2/A.3 build; it does not change the
> conclusions in `docs/competitor-aso-research.md` (Run 2) or
> `docs/feature-gap-analysis.md` (Run 4).

> **Update 2026-06-15 (Appeeky audit - adopted as the current recommendation).**
> The pre-launch Appeeky audit revised several launch fields; those revisions are
> now the current recommendation and are reflected in the literal ready-to-paste
> strings below (no longer pending):
> - **Subtitle (§2.2):** `Estimate your rising sign`.
> - **iOS keyword field (§2.5):**
>   `rectify,ascendant,natal,chart,calculator,unknown,horoscope,astrology,houses,zodiac,moon,sun`
>   (91/100).
> - **Play short description (§3.2):** `Estimate your birth time, rising sign &
>   natal chart from life events.`
> - **Category (§1, §2, §3.4, §7):** primary **Lifestyle** (not Utilities/Tools).
>   This reverses the earlier 4.3(b)-driven Utilities/Tools posture, trading it
>   for discoverability/featuring. The superseded Utilities/Tools rationale is
>   retained below as historical context only, not as a current instruction to
>   paste.
> Rationale and supporting data: `docs/aso-naming-strategy.md` §14 and
> `docs/competitor-aso-research.md` §15.

---

## 1. Decision summary

- **Public brand:** **TrueRise** — one word, English, kept in every locale; the
  descriptor tail carries the search intent. Internal codename stays `rectify`;
  first-publish app identity is `ua.com.truerise.app`.
- **Positioning:** a focused **birth-time calculation tool** that estimates an
  unknown birth time from the user's own life events and returns candidate times
  with an **honest confidence score** and per-event evidence. The copy still
  leads with the calculation function and avoids horoscope/fortune-telling
  lexicon; under the current **Lifestyle** category (below) that tool-led,
  probabilistic framing matters more, not less, to keep the listing reading as a
  calculator. (The earlier posture treated the **Utilities** category itself as
  the Apple **4.3(b)** survival move - precedent: Vedic Samay ships in Utilities,
  `docs/competitor-aso-research.md` §10 - but that category choice is now
  superseded by the Appeeky-driven Lifestyle recommendation; the copy discipline
  it required is retained.)
- **Category recommendation (current, post-Appeeky):**
  - **App Store:** Primary **Lifestyle** - where the astrology comparison set and
    audience sit; trades the old Utilities 4.3(b) caution for
    discoverability/featuring (`docs/aso-naming-strategy.md` §14.4).
  - **Google Play:** **Lifestyle.**
  - *Superseded (historical):* App Store primary **Utilities** (+ optional
    Secondary **Reference**) and Google Play **Tools**, chosen as the Apple
    4.3(b) survival posture. Retained here as context only - no longer the field
    to enter.
- **Growth angle baked into the copy:** the listing emphasizes **privacy-safe,
  shareable insight** — a result you can share as a short line (time + rising +
  confidence) **without** sharing any birth data
  (`docs/feature-gap-analysis.md` §6.1). *(Updated 2026-06-12: the privacy-safe
  share-card IMAGE — Run 4 G9 — has since shipped in-repo alongside the text
  share; both carry only time, rising when present, confidence, brand, and the
  public share link. Listing copy may now reference the shipped share card,
  but must not imply direct Instagram Stories posting, which stays out of
  scope until a Meta/Facebook App ID exists.)*
- **Already true in the build (verified via Impl Run A.1/A.2/A.3):** display name
  is **TrueRise**; an in-app **18+ birth-date gate** is enforced; the privacy
  screen discloses live-mode transmission; the app icon is the production
  TrueRise mark; the privacy/data-safety package is drafted
  (`docs/privacy-policy.md`, `docs/apple-privacy-labels.md`,
  `docs/play-data-safety.md`).
- **What the owner still must provide (gates submission — not decidable here):**
  1. **Hosted privacy-policy URL** (publish `docs/privacy-policy.md`, fill its
     `[OWNER/LEGAL]` blanks) — required in both listings.
  2. **Support URL** (and Play's required support email / contact).
  3. **Bundle/package ID** — final first-publish ID is
     `ua.com.truerise.app`; create the first App Store Connect / Play Console
     records with this exact value.
  4. **Release signing** — Android upload keystore + Play App Signing; iOS
     distribution profile.
  5. **Screenshots** — pre-Appeeky raw/reference captures already exist in the
     repo (`screenshots/store/{en,de,fr,es,pt-BR}/`, 5 raw frames per locale,
     plus manifest/README), captured from the post-A.1/A.3 build **before** the
     §5 five-frame story order. They cover result/evidence/privacy/share;
     adopting the current §5 plan likely requires recapturing/adding a
     problem-hook frame and a life-events input frame. Remaining owner/design
     work: those new frames, device-frame + caption compositing, any additional
     device sizes the consoles require, console upload, and owner/design review.
  6. **Trademark clearance + App Store name availability** for “TrueRise.”
  7. **Console character re-count**, **category confirmation**, **age rating**
     consistent with the 18+ gate, **Apple privacy labels + Play Data Safety**
     completion, **precise-location classification** call, and **demo/review key
     rotation** (see §8).

---

## 2. App Store package (English, US)

### 2.1 App Name — limit 30

```
TrueRise: Birth Time Finder
```

(~27 chars.) Brand + the high-intent long-tail descriptor “Birth Time Finder.”

### 2.2 Subtitle — limit 30

```
Estimate your rising sign
```

(~25 chars.) Current recommendation (post-Appeeky): leads with the
highest-popularity term the Appeeky audit surfaced (`rising sign`) plus the
probabilistic verb `estimate`. Treat it as a high-intent conversion line, not a
day-one rank target - `rising sign` is held by incumbents with far more reviews
(`docs/aso-naming-strategy.md` §14.1).

- **Alternative (earlier launch default; keeps the "rectify birth time" intent):**
  `Rectify your birth time` (~23) - uses **rectify** as the domain verb, not the
  brand.
- **Conservative alternative (recommended verbatim for a future German front and
  for the most review-cautious posture):** `Estimate your birth time` (~24) -
  leads with the probabilistic verb.
- **Brand-echo alternative:** `Find your birth time` (~20).

### 2.3 Promotional Text — limit 170 (updatable without review)

```
Estimate an unknown birth time from real life events. Try the full demo offline before entering your own details.
```

(~113 chars.) Promo text is editable any time, so it carries the current
problem-first screenshot story and offline-demo hook. Plain alternative:
`An honest, private way to estimate your unknown birth time from the events you actually remember.` (~95).

### 2.4 Full Description

```
Do you know your exact birth time? Most people don't. Without it, your rising sign and house placements are guesswork. TrueRise estimates your most likely birth time from the life events you already remember, then shows the evidence behind every candidate. This process is called birth-time rectification: estimating a likely birth time from real, dated life events.

HOW IT WORKS
- Enter an approximate birth window (or "I don't know") and your birthplace.
- Add a few dated life events: moves, relationships, career changes, family milestones, and more.
- TrueRise scores candidate times using astrological timing methods (transits and progressions) and ranks them by confidence.
- Open "See how we got this" to review, event by event, why each candidate scored the way it did.

HONEST BY DESIGN
Rectification is an estimate, not a certainty. Every result is shown as a most-likely time with a confidence score and a few alternative candidates. It is never a guaranteed answer and never a prediction about your future. The more dated events you add, the clearer the estimate can become.

PRIVATE BY DEFAULT
- Your birth details and life events are stored on your device.
- No account, no sign-up, no profile.
- Demo mode runs the whole flow offline, with no network and no key, so you can try it before entering anything real.
- One tap in Settings erases all your data.
- A live calculation sends your birth and event details to a calculation provider over a secure connection only to compute your result. It is never used for advertising or tracking.

SHARE WITHOUT OVERSHARING
Share your result as a short line: your estimated time, rising sign, and confidence. No birth date, birthplace, or life events attached. Share the result while your private data stays with you.

WHO IT'S FOR
Anyone with an unknown or uncertain birth time who wants their rising sign and house placements. TrueRise is a focused birth-time calculator, not a horoscope feed.

TrueRise provides astrological birth-time estimates for personal interest. It does not provide medical, psychological, legal, or financial advice, and its results are not deterministic.

Try the free, offline demo. No birth time needed to start.
```

(Well under the 4000 limit. Leads with the calculation function and probabilistic
framing; mentions astrology only as the *method*; never uses fortune-telling
lexicon or certainty claims.)

### 2.5 iOS keyword field — limit 100 (comma-separated, no spaces)

The field must not repeat words already in the Name/Subtitle. With the current
Name `TrueRise: Birth Time Finder` and subtitle `Estimate your rising sign`, the
excluded set is `truerise, birth, time, finder, estimate, your, rising, sign`.
Apple indexes Name + Subtitle + keywords together and de-duplicates.

**Recommended (current, post-Appeeky):**

```
rectify,ascendant,natal,chart,calculator,unknown,horoscope,astrology,houses,zodiac,moon,sun
```

**(91 / 100 characters.)** Keeps the ownable `rectify` token and, paired with the
**Lifestyle** category, deliberately adds astrology head terms (`horoscope`,
`astrology`, `zodiac`, `moon`, `sun`) for reach (`docs/aso-naming-strategy.md`
§14.2).

**Conservative variant (earlier utility posture; assumes the earlier `Estimate
your birth time` subtitle - no astrology head terms, for a future German front /
safest 4.3 posture):**

```
rectification,ascendant,rising,calculator,unknown,approximate,accurate,natal,chart,houses
```

**(89 / 100 characters.)**

> The conservative variant above reflects the superseded Utilities posture, which
> deliberately omitted `horoscope`/`zodiac`/`fortune`. The current recommended
> field pairs with the Lifestyle category and intentionally includes astrology
> head terms; do not additionally add `fortune`. Re-count in App Store Connect
> after the Name/Subtitle are locked; localized glyph counts differ.

### 2.6 App Review Notes (draft)

```
TrueRise is a utility that estimates an unknown birth time from user-entered life events and returns candidate times with an honest confidence score. It is not a horoscope or fortune-telling app and makes no deterministic or predictive claims.

NO PAYMENT OR KEY REQUIRED TO REVIEW: enable Settings > Demo mode, which runs the full input > result > evidence flow entirely OFFLINE (no network, no API key, no purchase, and no live quota consumed). Demo results are clearly marked with a DEMO pill.

LIVE MODE (optional): a live calculation sends the user's birth date, approximate birth time/window, birthplace text and coordinates (when available), and life-event categories/dates/descriptions to a third-party calculation provider over HTTPS, solely to compute the result. It is not linked to any identity (the app has no accounts) and is not used for tracking. The no-key live path uses the owner-billed public provider host and is locally guarded to 3 live requests per rolling 24-hour window; Demo mode is offline and does not count against this quota. A user who enters their own provider API key in Settings calls the canonical provider host directly with that key and is not subject to the no-key quota.

PRIVACY & DATA: on-device storage only; no analytics, crash-reporting, advertising, or tracking SDKs; the app requests NO device Location permission (the coordinates describe a birthplace the user selects, not current device location); Settings > Delete all data erases all local data. Privacy policy: [OWNER: hosted URL].

AGE: the app enforces an in-app 18+ birth-date gate; please set the App Store age rating consistently.
```

(Authoritative data posture: `docs/apple-privacy-labels.md`. Replace
`[OWNER: hosted URL]` before submitting.)

---

## 3. Google Play package (English, en-US)

### 3.1 Title — limit 30

```
TrueRise: Birth Time Finder
```

(~27 chars.)

### 3.2 Short description — limit 80

```
Estimate your birth time, rising sign & natal chart from life events.
```

(~69 chars.) Current recommendation (post-Appeeky): leads with the probabilistic
verb `estimate` and names the three deliverables (birth time, rising sign, natal
chart) plus the method (life events) (`docs/aso-naming-strategy.md` §14.3).

- **Earlier launch default:** `Estimate your birth time from life events. Private, on-device.` (~62) - intent + method + privacy.
- **Evidence-forward alternative:** `Find your most likely birth time from your life events, with evidence.` (~70).
- **Question-hook alternative:** `Don't know your birth time? Estimate it from your life events, privately.` (~73).

### 3.3 Full description — limit 4000 (first ~250 chars are the hook)

```
You don't know your exact birth time, so your rising sign and houses are uncertain. TrueRise estimates your most likely birth time from the life events you remember, then shows the evidence behind every candidate with a confidence score. No exact time needed to start.

HOW IT WORKS
- Enter an approximate birth window (or mark it unknown) plus your birthplace.
- Add a few dated life events: moves, relationships, career changes, family milestones, losses, and more.
- TrueRise scores candidate birth times using astrological timing methods (transits and progressions) and ranks them by confidence.
- Tap "See how we got this" to review, event by event, why each candidate scored the way it did.

WHY IT'S DIFFERENT
Most astrology apps demand an exact birth time and treat an unknown one as a dead end. TrueRise is the tool for that exact moment: it estimates the time instead of asking you to guess. The more dated events you add, the stronger the estimate.

HONEST CONFIDENCE, NOT CERTAINTY
Birth-time rectification is a probabilistic estimate. Results are always shown as a most-likely time with a confidence score and a few alternatives. They are never a guaranteed answer and never a prediction about your future.

PRIVATE BY DEFAULT
- Your birth details and life events stay on your device.
- No account and no sign-up.
- Demo mode runs the entire flow offline with no network and no key, so you can try it first.
- Delete everything in one tap from Settings.
- A live calculation sends your details to a calculation provider over a secure (HTTPS) connection solely to compute your result; there is no advertising, analytics, or tracking.

SHARE WITHOUT OVERSHARING
Share your result as a short line: estimated time, rising sign, and confidence. No birth date, birthplace, or life events included. Share the result while your private data stays with you.

WHO IT'S FOR
Anyone with an unknown or uncertain birth time who wants their rising sign and house placements. TrueRise is a focused birth-time calculator, not a horoscope feed.

TrueRise provides astrological birth-time estimates for personal interest. It does not offer medical, psychological, legal, or financial advice, and its results are not deterministic.

Try the free demo. Offline, private, no birth time required.
```

### 3.4 Suggested category, tags, and search phrases

- **Category (current, post-Appeeky):** **Lifestyle.** (Superseded: **Tools**,
  the earlier utility-posture choice; see `docs/aso-naming-strategy.md` §14.4.)
- **Tags (pick from Play's fixed tag list; closest matches):** *Calculator* and
  *Utilities / Tools* still describe the function, and an astrology/horoscope tag
  now fits the Lifestyle placement; keep the visible listing copy
  calculation-led regardless (§6).
- **Search phrases to support naturally in the text (do not list them as a
  block):** birth time rectification, rectify birth time, unknown birth time,
  birth time calculator, find my birth time, approximate birth time, rising sign
  / ascendant from life events. Use each at most once or twice in real
  sentences; Play penalizes repetition.

### 3.5 Reviewer notes (draft)

```
TrueRise is a birth-time calculation tool that estimates an unknown birth time from user-entered life events, returning candidate times with a confidence score. No deterministic, predictive, medical, legal, or financial claims are made.

TEST WITHOUT LIVE CREDITS OR PAYMENT: Settings > Demo mode runs the complete flow OFFLINE (no network, no key, no purchase, no live quota consumed); demo results are marked with a DEMO pill. The Play pre-launch report can be run in Demo mode.

LIVE MODE (optional) transmits birth date, approximate birth time/window, birthplace text + coordinates (when available), and life-event categories/dates/descriptions to a third-party calculation provider over HTTPS, solely to compute the result; not linked to identity (no accounts), not used for tracking. The Data safety form should match this flow (see docs/play-data-safety.md): encrypted in transit = yes; in-app deletion = yes. The no-key live path uses the owner-billed public provider host and is locally guarded to 3 live requests per rolling 24-hour window; Demo mode is offline and does not count against this quota. A user who enters their own provider API key in Settings calls the canonical provider host directly with that key and is not subject to the no-key quota.

PRIVACY & DATA: on-device storage; no analytics/crash/ads/tracking SDKs; only the INTERNET permission is declared; no device Location permission (coordinates are a selected birthplace, not GPS). Privacy policy: [OWNER: hosted URL]. Target audience: adults; in-app 18+ gate. Set the content rating consistently.
```

---

## 4. ASO query mapping

How the chosen Name / Subtitle / keywords / description cover the searches a
real user would type. **Lane** follows the Run 3 grouping: **compete** =
high-intent long-tail where a new single-purpose app can realistically rank;
**stretch** = generic-calculator competition; **reach-only** = too-competitive
head term, hidden-field reach at most (no ranking promise). No top-10 position is
guaranteed for any term.

| Likely search | Lane | Where it is covered | Rationale |
|---|---|---|---|
| birth time rectification | compete | keyword `rectification`; description (“birth-time rectification…”) | The core intent and the app's actual job; lane is uncontested by a like-for-like app (Run 2 §6.1). |
| rectify birth time / unknown birth time | compete | Subtitle “Rectify your birth time”; short desc “unknown birth time”; keyword `unknown` | Highest-intent long-tail; placed in the visible, highest-signal slots. |
| find my birth time / birth time calculator | compete | Name “Birth Time Finder”; keyword `calculator` | Direct descriptor match; “calculator” reinforces the utility frame. |
| birth chart time finder | compete | Name tail “Birth Time Finder” + keyword `chart` | Title carries “Birth Time Finder”; `chart` adds the “birth chart” adjacency. |
| rising sign calculator / ascendant calculator | stretch | keywords `rising`, `ascendant`, `calculator`; description (“rising sign”) | Generic chart-calculator competition is heavy; targeted as reach, not a primary success metric. |
| approximate / accurate birth time | compete | keyword `approximate`* / `accurate`; short + full description | Names the user's problem (“approximate”) and benefit; *`approximate` is in the conservative keyword variant. |
| astrology birth chart / natal chart | reach-only | keywords `astrology`, `chart`, `natal` (hidden field, Option H); one incidental description mention | Too-competitive head terms; included only as light hidden reach so the visible listing stays utility-led (4.3(b)). |
| houses / ascendant (chart terms) | reach-only | keywords `houses`, `ascendant`, `sign` | Supporting astrology vocabulary in the hidden field; never in the visible title/subtitle. |

**Avoided on purpose (policy/relevance):** `horoscope`, `zodiac`, `fortune`,
`psychic`, `tarot`, `prediction`, `future`, `destiny` — Group D terms that raise
Apple 4.3(b) and misleading-claim risk and pull the wrong audience
(`docs/aso-naming-strategy.md` §4.4 / §7.3).

---

## 5. Screenshot copy plan (post-Appeeky 5-frame story order)

> **Updated 2026-06-15 (Appeeky audit).** The current caption plan is **five
> frames**, ordered **problem hook -> life events -> result -> evidence ->
> privacy / offline demo** (`docs/aso-naming-strategy.md` §14.5). It replaces the
> earlier four-frame answer -> evidence -> privacy -> share order. Every frame
> must still show **real, shipped UI** (`docs/store-submission-readiness.md`
> §8.2) and follow the §6 guardrails: use `estimate`, never `exact` or
> `guaranteed` as a *result* claim (`exact` is allowed only in the frame-1 *user
> problem* statement). Capture from a **post-A.1/A.3 build** (TrueRise name +
> production icon, no "Rectify" leak), in both 12h and 24h time formats.

| # | Frame (shipped UI) | Overlay / caption text |
|---|---|---|
| 1 | **Problem hook** - the unknown-birth-time entry point (intro / birth-window input that frames the problem) | `Don't know your exact birth time?` |
| 2 | **Life events** - the dated life-events input / list screen | `Add the life events you remember.` |
| 3 | **The result** - hero result card: estimated time + "X Rising" + confidence bar | `Estimate your birth time and rising sign.` |
| 4 | **The evidence** - "See how we got this" per-event breakdown + alternate candidates | `See the evidence behind every candidate.` |
| 5 | **Private & offline demo** - Demo pill + Settings / privacy posture (on-device, Delete all data, demo = no network) | `Private by default. Try it free, offline.` |

> **Status of the existing raw captures.** The PNGs already in
> `screenshots/store/{en,de,fr,es,pt-BR}/` are still useful **raw / reference**
> captures, but they were taken **before** this post-Appeeky story order. They
> cover **result, evidence, privacy, and share**; they do **not** yet include a
> problem-hook frame or a life-events input frame. Adopting the five-frame plan
> above therefore likely requires **recapturing / adding** a problem-hook frame
> and a life-events input frame; do not treat the existing PNGs as already
> satisfying this final plan.

> **Share frame is now optional / bonus** (not one of the required five). If a
> share frame is still composited as a bonus, it may show either shipped
> privacy-safe share surface: the `ShareCopyBuilder` text line (time + rising +
> confidence + "Calculated with TrueRise" + the public link) or the shipped
> privacy-safe **share-card image** (the `StoryCardRenderer` PNG: brand, time,
> rising when present, confidence, tagline; shared via `share_plus`, updated
> 2026-06-12). Both shipped share surfaces are privacy-safe; **direct Instagram
> Stories** posting stays out of scope until a Meta/Facebook App ID exists. Do
> not lead any frame with zodiac wheels, horoscopes, or mystic imagery.

Optional later: a Play **feature graphic** (1024x500) using the same
problem-first message; not required to submit.

---

## 6. Compliance guardrails (apply to every visible surface + future edits)

- **No deterministic claims.** Always “most likely” / “estimate” / “candidate” +
  a confidence score; never “your birth time is X,” “exact,” “guaranteed,”
  “100%,” “definitive,” or “proven” as a *result* claim.
- **No sensitive life predictions.** Do not predict future events, relationships,
  health outcomes, death, or fortune. Results describe a *time estimate*, nothing
  more.
- **No emergency / health / finance / legal advice.** Keep the explicit
  disclaimer (“not medical, psychological, legal, or financial advice”). Never
  frame the app as guidance for any such decision.
- **No fortune-telling lexicon.** Avoid fortune, psychic, tarot, oracle,
  divination, palm reading, destiny, “predict your future” — in title, subtitle,
  keywords, description, screenshots, and promo text.
- **Astrology as method, not promise.** Treat astrology as the calculation
  *method* and tone (transits/progressions that score candidate times), never as
  a visible fortune-telling *promise*; keep astrology/horoscope/zodiac out of the
  visible title/subtitle and the first screenshot (Apple 4.3(b)). This is a
  copy/positioning rule, not a store-category rule - the store category is
  **Lifestyle** (§1, §3.4).
- **Privacy-safe sharing only.** Any sharing copy must match the shipped share
  surfaces — text and the share-card image (both shipped as of 2026-06-12):
  time + rising (when present) + confidence + brand + the public share link,
  **no PII**. Depict only the shipped share UI; do not depict direct Instagram
  Stories posting (not built — requires a Meta/Facebook App ID) or any field
  beyond that allow-list.
- **Age gate 18+.** Listing tone, target-audience declaration (adults), and store
  age rating must all match the in-app 18+ birth-date gate.
- **Honest expectation-setting.** “More events = stronger estimate”;
  rectification cannot guarantee precision.

---

## 7. Final owner checklist (before locking the listing / submitting)

- [ ] **Hosted privacy-policy URL** live (publish `docs/privacy-policy.md`, fill
      all `[OWNER/LEGAL]` blanks) and entered in both consoles.
- [ ] **Support URL** (+ Play support email/contact) provided.
- [x] **Bundle/package-ID decision** made and applied locally:
      `ua.com.truerise.app` (immutable after first store record/upload).
- [ ] **Release signing** configured (Android upload keystore + Play App Signing;
      iOS distribution profile); release no longer debug-signed.
- [ ] **Screenshots** — pre-Appeeky raw/reference captures exist
      (`screenshots/store/{en,de,fr,es,pt-BR}/`, 5 raw frames per locale), taken
      before the §5 five-frame story order; the current §5 plan likely needs new
      problem-hook and life-events frames. Remaining: any recaptured/added
      frames, device-frame/caption compositing, other device sizes if the
      consoles require them, console upload, owner/design review.
- [ ] **Trademark clearance + App Store name availability** for “TrueRise”
      confirmed.
- [ ] **Character re-count** of Name/Subtitle/keywords/Title/short description in
      each console.
- [ ] **Category** confirmed: **Lifestyle** on iOS and Google Play (current
      post-Appeeky recommendation; the earlier Utilities/Reference (iOS) / Tools
      (Play) posture is superseded - see §1 and
      `docs/aso-naming-strategy.md` §14.4).
- [ ] **Age rating** questionnaires completed consistent with the **18+** gate;
      Play target audience = adults.
- [ ] **Apple App Privacy labels** entered (`docs/apple-privacy-labels.md`) and
      **Play Data Safety** form completed (`docs/play-data-safety.md`), including
      the **precise-location classification** call and Collected-vs-Shared
      decision.
- [ ] **Demo/review key rotation** to a low-budget, capped key; reviewer notes
      point to offline Demo mode.

---

## 8. Source / preserved conclusions

- `docs/aso-naming-strategy.md` (Run 3) — name = TrueRise + descriptor tail;
  keyword Groups A–D; Option H for Tier 0, Option C for DE; probabilistic copy
  rules. **Finalized here.** *(The Run 3 Utilities/Tools category leg is
  superseded by the 2026-06-15 Appeeky update - primary Lifestyle; see §1, §3.4,
  §7 above and `docs/aso-naming-strategy.md` §14.4.)*
- `docs/store-submission-readiness.md` (Run 6) — P0-8 scope; English Tier 0
  package; the Run 6 four-frame screenshot storyboard (since superseded by the
  §5 five-frame plan); reviewer-note language. **Closed here for the
  owner-independent part.**
- `docs/competitor-aso-research.md` (Run 2) — Vedic Samay = Utilities precedent;
  Apple 4.3(b) risk; “is it accurate, can you show me why?” axis. **Preserved.**
- `docs/feature-gap-analysis.md` (Run 4) — text share is PII-free and shipped;
  demo is offline. **Preserved.** *(The Run 4 conclusion that the image
  share-card was not yet built - deferred to V1.5 - is superseded as of
  2026-06-12: the privacy-safe share-card image has shipped in-repo; see the
  §5/§6 notes above and the status note in `docs/feature-gap-analysis.md`.)*
- `docs/privacy-policy.md`, `docs/apple-privacy-labels.md`,
  `docs/play-data-safety.md` (Run A.2) — authoritative data posture used in the
  reviewer notes (on-device storage; offline demo; live HTTPS transmission of
  birth/event data to a third-party provider; no accounts/analytics/tracking;
  18+ gate; geocoding disclosure). **Referenced, not changed.**
