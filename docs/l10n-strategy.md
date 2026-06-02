# TrueRise Localization Strategy (Run 5)

- **Document:** `docs/l10n-strategy.md`
- **Version:** v1.0 (Run 5)
- **Date:** 2026-06-02
- **Model:** `claude-opus-4-8`
- **Status:** Planning / strategy only. No app code, config, ARB, or
  `l10n.yaml` created or changed in this run. This document describes a
  *future* implementation; it does not implement localization.
- **Companion:** `docs/l10n-string-audit.md` (string inventory + extraction
  batches). Read it alongside Section 11 (QA) and Section 12 (acceptance).

**Evidence labels used throughout:** `[VERIFIED]` = confirmed read-only in this
run against the working tree; `[ASSUMED]` = inferred from prior-run docs or
reasonable defaults, not re-proven here; `[PROPOSED]` = a recommendation for a
future owner decision. No live store rankings, install counts, ratings,
trademark status, or policy approvals are asserted anywhere in this document.

---

## 1. Executive summary

TrueRise ships today as an **English-only** Flutter app with **no localization
pipeline of any kind** `[VERIFIED]`: there are no `.arb` files, no `l10n.yaml`,
no `flutter_localizations` dependency, no `AppLocalizations`, and no
`localizationsDelegates` / `supportedLocales` wired into `MaterialApp.router`
(`lib/app/app.dart:14-20`). Every user-visible string is a hardcoded Dart
literal. This was a planned-but-unbuilt capability: the growth thesis (Run 1)
and ASO work (Runs 2-3) assume localized store listings and UI, and the feature
gap analysis (Run 4) logged the missing extraction pipeline as gap **G20**, the
locale-formatting issues as **G21**, and translated strings as **G22**.

This strategy proposes a **two-stage** path that keeps strategy and execution
cleanly separated:

1. **Impl Run C (G20) — locale-agnostic refactor.** Stand up the Flutter
   gen-l10n pipeline and extract every hardcoded string into an English base
   ARB (`app_en.arb`). No translation yet. The app stays visually identical in
   English but becomes *translatable*. This is the gating dependency for
   everything else.
2. **Impl Run D (G22) — Tier 1 translation.** Author target-language ARBs for
   **German, French, Spanish, and Brazilian Portuguese**, localize store
   metadata and screenshots, and localize privacy/legal copy. Gated entirely on
   Run C.

A locale-formatting fix (**G21**) — replacing hand-rolled AM/PM and hardcoded
month abbreviations with `intl` formatting — should ride **inside** Run C
because the same screens are already being edited for extraction.

**Brand rule, up front:** "TrueRise" is the global brand and stays English in
every locale. It is never placed in an ARB value for translation. Localized
**descriptors** (the ASO-bearing tail, e.g. "Birth Time Finder") *are*
translated. "Rectify" / `com.rectify.rectify` remains the internal codename and
bundle ID and is never user-facing translation surface.

**Locale priority `[PROPOSED]`:** DE > FR > ES > PT-BR for credibility-and-effort
reasons (Section 3). Tier 1 success is measured against growth-thesis hypothesis
**H4** (localization lifts non-English install share; kill criterion if the lift
is under the documented floor — see Section 9 and Run 1 §-H4) `[ASSUMED]`.

---

## 2. Verified current localization state

All items in this section were confirmed read-only in this run (2026-06-02).

| Check | Method | Result |
|---|---|---|
| ARB resource files | `glob **/*.arb` | **None found** `[VERIFIED]` |
| `l10n.yaml` config | `glob **/l10n.yaml` | **None found** `[VERIFIED]` |
| l10n wiring symbols (`AppLocalizations`, `flutter_localizations`, `localizationsDelegates`, `supportedLocales`, `GlobalMaterialLocalizations`, `gen-l10n`) | repo-wide grep | Matches **only** in `docs/` (`claude-build-history.md`, `feature-gap-analysis.md`, `implementation-plan.md`) — **never in `lib/`, `pubspec.yaml`, or any config** `[VERIFIED]` |
| `flutter_localizations` dependency | `pubspec.yaml` grep | **Absent** `[VERIFIED]` |
| `generate: true` flutter flag | `pubspec.yaml` grep | **Absent** `[VERIFIED]` |
| `intl` package | `pubspec.yaml:53` | `intl: ^0.20.2` present — **formatting only**, not localization wiring `[VERIFIED]` |
| App root config | `lib/app/app.dart:14-20` | `MaterialApp.router(title: 'Rectify', debugShowCheckedModeBanner: false, theme: ..., routerConfig: ...)` — **no** `locale`, `localizationsDelegates`, or `supportedLocales` `[VERIFIED]` |

**Interpretation.** The localization layer exists only as *planning prose* in
docs. The codebase is at a clean greenfield starting point: there is no partial,
half-wired, or stale l10n setup to reconcile or migrate. The refactor is
additive, not corrective.

**Two formatting facts that matter for l10n (detail in the audit, G21):**

- **Hand-rolled 12/24-hour time** with literal `'AM'` / `'PM'` strings appears in
  at least five places (`result_screen.dart`, `evidence_screen.dart`,
  `time_window_screen.dart`, `confirmation_screen.dart`,
  `home_history_screen.dart`) `[VERIFIED]`. The widget layer is already
  locale-ready in spirit — `HeroResultCard`, `CandidateCard`, `HistoryCard`,
  `TimePickerField`, `DatePickerField` all accept *pre-formatted* strings and do
  no formatting themselves (their dartdoc explicitly defers "locale and intl
  setup" to the caller) `[VERIFIED]`. The locale debt is concentrated in the
  **callers**, not the widgets.
- **Hardcoded English month abbreviations** (`Jan`..`Dec`) are duplicated in
  three files (`life_events_screen.dart`, `confirmation_screen.dart`,
  `add_event_sheet.dart`) `[VERIFIED]`, plus `DateFormat('MMMM d, y')` /
  `DateFormat('MMM y')` calls that rely on the default locale `[VERIFIED]`.

---

## 3. Locale priority and rationale

**Tier 1 target set `[ASSUMED from Run 1 §4.2 / Run 4 localization section]`:**
German (de), French (fr), Spanish (es), Portuguese — **Brazilian (pt-BR)**.

**Portuguese = PT-BR, not PT-PT `[PROPOSED]`.** Brazil is the larger
Portuguese-speaking mobile astrology market and the competitor vocabulary
captured in Run 2 §6 uses Brazilian forms (`retificação do horário de
nascimento`, `horário` rather than `hora`, `compartilhar` rather than
`partilhar`). Unless a future owner finds a Portugal-specific distribution
reason, ship a single `pt-BR` locale. A `pt` fallback can be added later if
PT-PT demand appears; the ARB tooling supports region fallback.

**Recommended sequencing rationale `[PROPOSED]`:**

| Rank | Locale | Why this order |
|---|---|---|
| 1 | **de** (German) | Highest credibility bar (Run 2 **W2**: Astrodienst/Astrodienst-class users expect rigor; a respected German source openly refuses rectification). German is the hardest copy to get right, so doing it first forces the honest-confidence tone discipline that benefits every other locale. Also the longest words = the worst overflow stress test (Section 6, Section 11). |
| 2 | **fr** (French) | Large astrology audience; well-defined vocabulary (Run 2 §6). Known wording traps around "preuve/confiance" (Section 8) make it a good second pass once the German tone rules are set. |
| 3 | **es** (Spanish) | Largest raw speaker base across multiple stores; reuses much Romance-language structure validated in French. Start with a neutral/international Spanish; defer es-MX/es-419 splits unless data demands. |
| 4 | **pt-BR** (Portuguese, Brazil) | Strong astrology engagement; vocabulary already captured. Sequenced last only because it benefits from the Romance-language patterns settled in fr/es. |

**Do not over-fit the order.** All four are Tier 1; if translation capacity
arrives in parallel, they can be authored concurrently — the order above is a
*priority for scarce review attention*, not a hard dependency chain. The only
hard dependency is that **all four depend on Run C (G20)** shipping first.

**Out of scope for this strategy `[ASSUMED from prd §8 non-goals,
mvp-scope V1.5]`:** Hindi and any non-Latin script locale. Hindi was explicitly
deferred to V1.5 in `docs/mvp-scope.md` ("requires translation pipeline") — the
very pipeline this document specifies (G20) is its prerequisite. RTL locales
(Arabic, Hebrew) are not in Tier 1 and would add bidirectional-layout QA cost;
defer.

---

## 4. Brand and naming rules

These rules are **invariant across all locales** and are the single most
important guardrail for the translation runs.

1. **"TrueRise" is the brand and stays English everywhere `[PROPOSED, aligned
   with Run 3 §9 + Run 4]`.** It is a proper noun. It is never translated,
   transliterated, or declined. It must **not** appear as a translatable value
   in any ARB file. If it appears in a sentence ("Welcome to TrueRise"), the
   surrounding sentence is translated but the token "TrueRise" is held constant,
   ideally via a placeholder so translators cannot accidentally alter it.
2. **Localized descriptors carry the ASO intent and *are* translated
   `[PROPOSED, Run 3 §9 / Run 2 §6]`.** The descriptive tail that does the
   keyword work — "Birth Time Finder", "Rectify your birth time" — becomes the
   localized hook (e.g. DE "Geburtszeit finden", FR "Trouvez votre heure de
   naissance"). The brand + descriptor pattern is: `TrueRise - <localized
   descriptor>`.
3. **"Rectify" / `com.rectify.rectify` is internal only `[VERIFIED codename
   usage in code; PROPOSED policy]`.** It is the codename and bundle/package ID.
   Note the *existing* user-visible string `'Rectify'` is still hardcoded in at
   least three places — `app.dart:15` (`title:`), the History top nav, the
   Settings version line, and the Privacy Policy body `[VERIFIED]`. That is the
   pre-existing brand-mismatch gap **G1** (display name), **not an l10n task**.
   The l10n run must not "fix" it by translating it; G1 is resolved separately
   (Impl Run A) by swapping the *English source* to the brand decision, after
   which the corrected English string is what gets extracted. Sequencing note in
   Section 10.
4. **Astrology-method, not astrology-category, framing survives translation
   `[ASSUMED from Run 3 policy-safe copy rules]`.** Localized copy references
   astrology as the *method* used to estimate a time, consistent with the
   Utilities/Tools category framing and 4.3(b) risk posture (Section 6, Section
   9). Translators must not "upgrade" the category framing into horoscope/fortune
   language to chase local astrology keywords.
5. **Provider/proper nouns stay untranslated `[VERIFIED present in code]`.**
   `astrology-api.io` (named in `error_screen.dart` copy), city names from the
   geocoding stub (`Kyiv, Ukraine`, `Berlin, Germany`, ...), and zodiac sign
   names returned by the API/demo (`Gemini`, `Cancer`, ...) are proper nouns.
   Zodiac **sign names** have conventional localized forms (DE "Zwillinge",
   FR "Gémeaux") — see Section 7 note — but in the current build the sign comes
   from API/demo data and is concatenated with a "Rising" suffix in the caller;
   that suffix is the translatable part, the sign token is data.

---

## 5. Localization scope split

Localization is not one workstream. Treat these five surfaces independently;
they have different owners, tools, and review gates.

| # | Surface | What it covers | Tooling / location | Run |
|---|---|---|---|---|
| A | **Product UI** | Every in-app string: screens, sheets, buttons, labels, helper text, snackbars, error copy, accessibility (Semantics) labels, dynamic interpolations. | gen-l10n ARB (`lib/l10n/app_*.arb`) + `AppLocalizations`. | C (extract) -> D (translate) |
| B | **Store metadata** | App name/title, subtitle, short + long description, keyword field (iOS), promo text. | App Store Connect / Play Console per-locale listings. **Not** in the binary. | D |
| C | **Screenshots** | On-image headline captions + the device-frame UI language shown. | Screenshot generation pipeline; localized device UI + localized caption layer. | D (depends on A being translated for in-device text) |
| D | **Privacy / legal copy** | In-app Privacy screen (`privacy_policy_screen.dart`), the hosted privacy policy URL target, store data-safety/privacy declarations. | UI part via ARB (surface A); hosted doc + console declarations separately. | C/D + legal review |
| E | **Support / FAQ** | Any external help/FAQ content and store support URL. | Out-of-repo content; not blocking. | D or later |

**Key implication:** Surface A (product UI) is the only one that needs the code
refactor (G20). Surfaces B, C, E are largely **out-of-binary** content and can be
drafted in parallel with Run C, but C's *device screenshots* and D's *in-app
privacy text* depend on A being translated. So the dependency spine is:
**G20 (extract) -> translate ARB -> {localized screenshots, localized in-app
privacy}**, with store text/keywords runnable in parallel.

---

## 6. Translation principles

These are **binding tone rules** for every locale. They exist to keep the app on
the right side of store policy (4.3(b)) and the honest-confidence positioning
that the whole product rests on. They override any literal-fidelity instinct a
translator might have.

1. **Probabilistic utility, never deterministic claims.** The product *estimates*
   a probable birth time and ranks candidates by confidence. Translations must
   preserve hedging ("most probable", "candidates", "narrows it down") and must
   never render these as certainties. `[VERIFIED source tone]` — e.g.
   `hero_result_card.dart` eyebrow is "YOUR MOST **PROBABLE** BIRTH TIME"; the
   word "probable" must survive translation, not be dropped for punchiness.
2. **No fortune-telling / horoscope register.** Do not translate into the local
   horoscope-marketing vocabulary even when it scores better on keyword volume.
   This is the 4.3(b) survival rule (Run 3) carried into copy `[ASSUMED]`.
3. **No medical, legal, or financial claims.** Life-event categories include
   "Major illness / surgery", "Financial turning point" `[VERIFIED
   `calculation_flow_state.dart:317-330`]`. These are *event labels the user
   picks*, not advice. Translations must stay descriptive (an event that
   happened) and never imply diagnosis, prognosis, or financial guidance.
4. **Honest confidence language.** "Confidence", "evidence", "strong/moderate/
   weak/no match" must translate to *indicative* terms, not *proof* terms.
   Specifically avoid words that mean "proof" (DE "Beweis", FR "preuve", ES
   "prueba", PT "prova") for the evidence concept — prefer "indication" words
   (Section 7, Section 8). This directly serves the German credibility bar (W2).
5. **Privacy-first copy.** The privacy promises ("stored on this device only",
   "no network request", "the original data isn't kept anywhere else") are
   product guarantees `[VERIFIED in privacy/settings/share copy]`. Translate them
   precisely; do not soften or overstate. A mistranslation here is a
   trust/compliance bug, not a style nit.
6. **Avoid paywall / upsell tone.** The current demo->real nudge is informational
   ("This was a demo. Run a real calculation with your own birth data.")
   `[VERIFIED `result_screen.dart`]`, not a hard upsell. Keep that register;
   no "unlock", "premium", "upgrade now" pressure language in any locale.
7. **Accessibility strings are real strings.** Many Semantics labels are
   interpolated sentences read aloud by screen readers (Section 7 of the audit).
   They must be translated with the same care as visible copy and must keep
   grammatical sense after placeholder substitution in each locale.

---

## 7. Locale terminology table

Target-language terms below intentionally use correct diacritics (the ASCII-safe
rule is waived for *quoted target terms*, since stripped accents would be wrong
and unusable). The **Recommended** column is the term to use in copy; the
**Avoid** column flags a tempting-but-wrong alternative. Final terms are
`[PROPOSED]` and must be confirmed by a native reviewer (Section 13).

### 7.1 Core concepts

| EN concept | DE (de) | FR (fr) | ES (es) | PT-BR (pt-BR) | Note |
|---|---|---|---|---|---|
| birth time rectification | Geburtszeitkorrektur | rectification de l'heure de naissance | rectificación de la hora de nacimiento | retificação do horário de nascimento | DE is one compound word -> longest token, overflow risk (S11). |
| find / discover birth time | Geburtszeit finden | trouver son heure de naissance | averiguar la hora de nacimiento | descobrir o horário de nascimento | ASO descriptor tail (S4 rule 2). |
| unknown birth time | unbekannte Geburtszeit | heure de naissance inconnue | hora de nacimiento desconocida | horário de nascimento desconhecido | Matches "I have no idea" flow. |
| rising sign / ascendant | Aszendent | ascendant | ascendente | ascendente | Pairs with a sign token (data); "Rising" suffix is the translatable part. |
| life events | Lebensereignisse | événements de vie | eventos de vida | eventos da vida | DE compound, long. |
| confidence | **Wahrscheinlichkeit** (avoid bare "Konfidenz") | **niveau de confiance** (avoid bare "confiance") | **nivel de confianza** / probabilidad | **nível de confiança** | "probability"/"confidence level" reads honest; bare "confidence/confiance" can imply trust/assurance. |
| evidence | **Hinweise** (avoid "Beweise") | **indices** (avoid "preuves") | **indicios** (avoid "pruebas") | **indícios** (avoid "provas") | "indications", never "proof" (Principle 4, W2). |
| demo | Demo | démo | demo / demostración | demo | Keep short for the DEMO pill (3-4 chars ideal; see S11). |
| offline | offline / Offline | hors ligne | sin conexión | off-line / offline | "sin conexión" is longer than EN -> button/label overflow check. |
| privacy | Datenschutz | confidentialité | privacidad | privacidade | DE "Datenschutz" is the legal-standard term, not "Privatsphäre". |
| share result | Ergebnis teilen | partager le résultat | compartir el resultado | compartilhar o resultado | BR "compartilhar" (not PT-PT "partilhar"). |

### 7.2 Supporting terms (high-frequency UI)

| EN | DE | FR | ES | PT-BR |
|---|---|---|---|---|
| Continue | Weiter | Continuer | Continuar | Continuar |
| Cancel | Abbrechen | Annuler | Cancelar | Cancelar |
| Delete | Löschen | Supprimer | Eliminar | Excluir |
| Settings | Einstellungen | Réglages | Ajustes | Configurações |
| History | Verlauf | Historique | Historial | Histórico |
| Date of birth | Geburtsdatum | Date de naissance | Fecha de nacimiento | Data de nascimento |
| City of birth | Geburtsort | Ville de naissance | Ciudad de nacimiento | Cidade de nascimento |
| Demo mode | Demo-Modus | Mode démo | Modo demo | Modo demo |

**Note on zodiac sign names.** Sign tokens (`Gemini`, `Cancer`, ...) currently
arrive as data and are concatenated with " Rising" in the caller `[VERIFIED
`result_screen.dart:174`, `home_history_screen.dart:185`]`. If a future run wants
fully localized sign names (DE "Zwillinge", FR "Gémeaux", ES "Géminis", PT
"Gêmeos"), that requires a **client-side sign-name lookup keyed by an English/ID
token**, not free translation of API strings — log as an owner decision (Section
13), out of scope for the first translation pass.

---

## 8. Locale-specific tone and risk notes

### 8.1 German (de) — highest credibility bar `[Run 2 W2]`
- German astrology users skew toward rigor; a credible local reference openly
  declines rectification. Over-promising reads as quackery faster here than in
  any other Tier 1 locale. **Lead with method and honesty**, not excitement.
- Use "Wahrscheinlichkeit" (probability), not "Konfidenz" (loanword, technical)
  and never "Sicherheit/Gewissheit" (certainty).
- Use "Hinweise/Anhaltspunkte" for evidence, never "Beweise" (proof).
- **Compound words are long.** "Geburtszeitkorrektur",
  "Lebensereignisse", "Datenschutzerklärung" stress narrow buttons, the DEMO
  pill, tab labels, and single-line truncating fields (Section 11).
- Formal vs informal address: **pick one register and hold it.** Recommend the
  informal "du" for a consumer self-discovery app `[PROPOSED]`, but this is an
  owner/native-reviewer call (Section 13) — mixing "du" and "Sie" looks
  unprofessional.

### 8.2 French (fr)
- Trap: "confiance" alone leans toward "trust"; use "niveau de confiance" for the
  confidence metric. "preuve" = legal/scientific proof — too strong for evidence;
  use "indices" or "éléments".
- Apostrophe + elision ("l'heure", "d'événements") must be correct; watch
  placeholder boundaries so interpolation doesn't break elision.
- French runs ~15-20% longer than English on average — the universal overflow
  multiplier to design against (Section 11).
- Gender agreement around interpolated nouns (e.g. a counted noun) needs ICU
  `select`/plural care, not naive concatenation (Section 5 of the audit).

### 8.3 Spanish (es)
- Trap: "evidencia" is acceptable but "indicios" is more honest for weak signals;
  never "pruebas" (proof). "confianza" alone risks the same trust connotation as
  French — prefer "nivel de confianza" or "probabilidad".
- Use neutral/international Spanish first; avoid Iberian-only ("ordenador",
  "móvil" specifics) and Mexico-only slang. Defer es-419/es-MX split unless data
  warrants `[PROPOSED]`.
- Inverted punctuation (¿ ¡) must be applied for questions/exclamations —
  several source strings are questions ("Do you know an approximate birth time?")
  and need "¿...?" wrapping, which naive translation memory sometimes drops.

### 8.4 Brazilian Portuguese (pt-BR)
- Use BR forms: "horário" (not "hora") for clock time in this domain,
  "compartilhar" (not "partilhar"), "Configurações", "Excluir".
- "indícios" over "provas" for evidence; "nível de confiança" / "probabilidade"
  for confidence.
- Run 2 noted a BR-flavored "10+ events" framing direction for store copy
  `[ASSUMED Run 2/3]` — keep that as a *metadata* nuance, not a UI string change.
- BR Portuguese also runs longer than English; same overflow discipline as the
  Romance locales.

---

## 9. Store metadata direction per locale

This section gives **direction**, not final approved listings, and asserts **no**
ranking certainty (no "top-10" guarantees). It builds on Run 3's three option
sets (Conservative / High-intent / Brand-led) and Run 2 §6 vocabulary.

**Pattern for all locales:** `TrueRise - <localized descriptor>` for the
title/name, with the brand token held constant (Section 4).

| Locale | Title/name direction | Subtitle / short-desc theme | Keyword themes (field/long-desc) | Screenshot headline direction |
|---|---|---|---|---|
| de | `TrueRise - Geburtszeit finden` | honest, method-led: estimate the probable birth time from life events | Geburtszeitkorrektur, Geburtszeit, Aszendent berechnen, unbekannte Geburtszeit | "Deine wahrscheinliche Geburtszeit" + evidence + privacy/offline. Use Run 3 **Option C (Conservative)** for DE given W2. |
| fr | `TrueRise - Heure de naissance` | trouver/estimer son heure de naissance via les événements de vie | rectification heure de naissance, ascendant, heure de naissance inconnue | "Votre heure de naissance la plus probable" + indices + confidentialité. |
| es | `TrueRise - Hora de nacimiento` | averigua tu hora de nacimiento probable a partir de eventos de vida | rectificación hora de nacimiento, ascendente, hora de nacimiento desconocida | "Tu hora de nacimiento más probable" + indicios + privacidad. |
| pt-BR | `TrueRise - Horário de nascimento` | descubra seu horário de nascimento provável pelos eventos da vida | retificação horário de nascimento, ascendente, horário de nascimento desconhecido | "Seu horário de nascimento mais provável" + indícios + privacidade. |

**Constraints carried from Run 3 `[ASSUMED]`:** iOS category Utilities, Play
category Tools (4.3(b) posture); respect ~30-char iOS title and ~30-char
subtitle limits *per locale* (localized strings are longer — DE especially may
not fit and may need a shorter descriptor); iOS keyword field ~100 chars
*per locale*; no keyword stuffing in Play long description. **All character
counts must be re-validated in-console per locale** — do not trust estimates
(Section 13). Tier 0 (English) may use Run 3 **Option H (High-intent)**; DE
should stay Conservative.

**Measurement tie-in `[ASSUMED Run 1 H4]`:** the localization bet is justified
by hypothesis **H4** (localized listings lift non-English install share within
the documented window) with a documented kill criterion. Track per-locale
install share and listing conversion; do not claim a ranking outcome in advance.

---

## 10. Implementation dependency on the G20 l10n extraction pipeline

**Everything in this strategy is gated on G20** (the locale-agnostic refactor =
**Impl Run C** in `docs/feature-gap-analysis.md`). Translation (G22 / Run D)
cannot begin until there is a base ARB to translate.

**Run C scope (what "G20 done" means) `[PROPOSED, consistent with Run 4 Run-C
acceptance criteria]`:**

1. Add `flutter_localizations` (SDK) + set `generate: true` in `pubspec.yaml`.
2. Add `l10n.yaml` (template `app_en.arb`, output `AppLocalizations`,
   `lib/l10n/` source dir).
3. Create `lib/l10n/app_en.arb` containing **all** extracted English strings with
   stable keys, ICU placeholders/plurals/selects where needed (audit Section 5),
   and `@`-metadata descriptions for translators.
4. Wire `localizationsDelegates` + `supportedLocales: [en]` into
   `MaterialApp.router` (`lib/app/app.dart`).
5. Replace every hardcoded literal with `AppLocalizations.of(context)!.<key>`,
   **including Semantics/accessibility labels**.
6. **Fold G21 in here:** replace hand-rolled AM/PM and hardcoded month maps with
   `intl` (`DateFormat.jm()` / locale-aware patterns) so the formatting is
   locale-driven, since these files are already being touched.
7. Centralize the three duplicated `_monthLabels` maps — they disappear once
   `intl` formatting replaces them.

**Sequencing with G1 (display-name / brand) `[VERIFIED dependency]`:** the
hardcoded `'Rectify'` brand strings (Section 4 rule 3) should be reconciled to
the final brand **before or during** extraction so the *correct* English source
is what lands in `app_en.arb`. Order: **Impl Run A (G1 brand/display name) ->
Impl Run C (G20 extract + G21 format) -> Impl Run D (G22 translate)**. If A
slips, extract the current literal as-is and treat the brand correction as a
single key change later — do not block C on A.

**Why strategy-before-code (this run's posture):** extracting 200+ strings into
keys is a large, mechanical, high-blast-radius diff across `lib/`. Settling the
terminology (Section 7), tone rules (Section 6), brand rules (Section 4), and
plural/placeholder needs (audit Section 5) *first* means the keys and ICU shapes
are right the first time and translators get clean metadata. That is the entire
justification for Run 5 preceding Run C.

---

## 11. QA plan

Localization QA is mostly **layout and formatting** QA. The translation being
"correct" is necessary but not sufficient — the app must not break visually.

### 11.1 Length / overflow (the dominant risk)
- **Pseudo-localization pass first:** before real translations, run a
  pseudo-locale (accented + ~40% padded strings) to surface every clipping
  point cheaply.
- **German stress test:** DE compounds ("Geburtszeitkorrektur",
  "Lebensereignisse", "Datenschutzerklärung", "Einstellungen") are the worst
  case. Verify: primary/secondary buttons, the **DEMO pill** (`demo_pill.dart`,
  very narrow), **bottom tab labels** ("NEW/HISTORY/SETTINGS" -> longer in DE),
  `TopNav` titles (single-line ellipsis at `top_nav.dart:64-69`), `StepperHeader`
  eyebrow, history card label (ellipsis), and `eventCategoryLabel` values in the
  category picker.
- **Romance +15-20% pass:** fr/es/pt-BR on the same surfaces.
- Verify text does not truncate meaning on the smallest supported screen.

### 11.2 Time formatting (12/24h)
- After G21, confirm `intl` honors the user's TimeFormat setting **and** the
  locale: 12h shows localized AM/PM (or locale equivalent), 24h shows "07:14"
  with no meridiem token, across `result`, `evidence`, `confirmation`,
  `time_window`, `home_history`, and the hero/candidate/history cards (which take
  pre-formatted strings + a separate meridiem param — verify empty-meridiem path
  for 24h locales).

### 11.3 Date / month formatting
- Replace hardcoded `Jan..Dec` and `DateFormat('MMMM d, y')` / `'MMM y'` with
  locale-aware patterns; verify month names localize and date order matches
  locale convention (DE "2. Juni 2026", not "June 2, 2026").

### 11.4 Numbers, percent, decimals
- Confidence renders as `'$percent%'` (`confidence_bar.dart:43`) and Semantics
  says "NN percent". Verify percent formatting/spacing per locale (some locales
  use a space before %, FR uses non-breaking space). Verify any decimal display
  uses locale separators (comma vs period) via `intl` `NumberFormat`.

### 11.5 Inputs, labels, buttons, small screens
- Field labels, helper text, placeholders, picker sheet titles, char counters
  ("$length / $max" in `add_event_sheet.dart`), and all CTA buttons checked for
  overflow and for correct grammar after placeholder substitution.
- Re-run on the smallest supported device and at large OS text-scaling.

### 11.6 Plurals / interpolation correctness
- Every counted string (events count, candidate count, "X of Y events",
  calculations count, page "X of Y") must use ICU plural/select and read
  correctly in each locale's plural rules (see audit Section 5 inventory).

### 11.7 Accessibility (screen reader)
- All translated Semantics labels read as natural sentences in each locale;
  interpolated values land in grammatical positions.

### 11.8 Screenshot localization
- Device-frame UI must render in the target locale (depends on translated ARB).
- On-image caption layer translated and re-laid-out for length (German headlines
  may need smaller type or reflow).
- Regenerate the store screenshot set per locale; verify the privacy-safe share
  screenshot still shows no PII in every locale.

---

## 12. Acceptance criteria for a future implementation run

**For Impl Run C (G20 extraction + G21 formatting) to be "done":**
- [ ] `flutter_localizations` added; `generate: true` set; `l10n.yaml` present.
- [ ] `lib/l10n/app_en.arb` exists; **zero** user-visible hardcoded literals
      remain in `lib/` (verified by the audit's grep checklist, Section 9 of the
      audit), including Semantics labels.
- [ ] `localizationsDelegates` + `supportedLocales` wired in `app.dart`; app
      builds and runs in English with no visible change.
- [ ] All AM/PM and month formatting goes through `intl`; the three duplicated
      `_monthLabels` maps are gone.
- [ ] All counted/interpolated strings use ICU placeholders/plurals/selects with
      translator-facing `@`-metadata.
- [ ] `flutter analyze` clean; existing tests updated to resolve strings via
      `AppLocalizations` and passing; demo flow still offline.
- [ ] Pseudo-localization pass shows no clipping on the smallest supported screen.

**For Impl Run D (G22 Tier 1 translation) to be "done":**
- [ ] `app_de.arb`, `app_fr.arb`, `app_es.arb`, `app_pt.arb` (pt-BR) complete,
      keys 1:1 with base, native-reviewer approved (Section 13).
- [ ] `supportedLocales` includes all four; in-app language follows device locale
      with English fallback.
- [ ] Tone rules (Section 6) and terminology (Section 7) honored; no proof-words
      for evidence, no certainty-words for confidence, brand token never
      translated.
- [ ] Per-locale QA (Section 11) passed, including DE overflow and FR/ES/pt-BR
      length passes.
- [ ] Localized store metadata + screenshots prepared; character limits
      re-validated in-console per locale.
- [ ] Localized in-app privacy copy + hosted policy + console data-safety
      declarations consistent and legal-reviewed.

---

## 13. Open validations and owner decisions

`[PROPOSED]` items that a human owner / native reviewer must confirm before or
during the implementation runs:

1. **Native-speaker review** of every term in Section 7 and all final ARB values
   per locale (the terms here are proposals, not approvals).
2. **PT-BR vs PT-PT:** confirm Brazilian-only is acceptable for v1; decide if a
   `pt` fallback is needed.
3. **German register:** "du" vs "Sie" — pick one project-wide.
4. **Spanish variant:** neutral es first vs es-419/es-MX split — confirm.
5. **Zodiac sign names:** decide whether to localize sign names via a client-side
   lookup (and how to key it) or keep API/data sign tokens English. Out of scope
   for the first pass unless approved.
6. **Brand/display-name (G1) timing:** confirm Run A lands before Run C so the
   correct English brand string is extracted; resolve the `'Rectify'` literals in
   `app.dart`, top nav, settings version, and privacy copy.
7. **Store character limits per locale:** re-count title/subtitle/keyword fields
   *in console* for each locale (DE descriptor may not fit ~30 chars).
8. **Hosted privacy policy localization** ownership and URL strategy
   (per-locale URL vs single multilingual page) — legal sign-off required.
9. **Translation method/vendor:** human vs MT-plus-review; either way, native
   review of sensitive copy (privacy, evidence, confidence) is mandatory.
10. **H4 measurement plumbing:** confirm per-locale install-share / conversion
    tracking exists (ties to the separate privacy-safe analytics track, Run B)
    so the localization bet can be evaluated against its kill criterion.

---

## 14. Source / evidence appendix

**Read-only this run (working tree, 2026-06-02):**
- `lib/app/app.dart` — `MaterialApp.router`, no l10n wiring, `title: 'Rectify'`.
- `pubspec.yaml` — `intl: ^0.20.2`; no `flutter_localizations`; no
  `generate: true`.
- Repo-wide checks: no `**/*.arb`, no `**/l10n.yaml`; l10n symbols only in
  `docs/`.
- Calc-flow screens: `onboarding_screen.dart`, `birth_data_screen.dart`,
  `time_window_screen.dart`, `life_events_screen.dart`, `confirmation_screen.dart`,
  `loading_screen.dart`, `result_screen.dart`, `evidence_screen.dart`,
  `widgets/add_event_sheet.dart`, `state/calculation_flow_state.dart`
  (`eventCategoryLabel`), `state/calculation_flow_controller.dart`.
- Home/settings: `home/home_history_screen.dart`, `settings/settings_screen.dart`,
  `settings/delete_all_data_sheet.dart`, `settings/api_key_sheet.dart`,
  `settings/privacy_policy_screen.dart`.
- Error flow: `error_flow/error_screen.dart`, `error_flow/error_routing.dart`,
  `core/failures.dart`.
- Shell/placeholders/nav: `main_shell/main_shell.dart`,
  `placeholders/coming_soon_screen.dart`, `widgets/nav/top_nav.dart`,
  `widgets/nav/bottom_tab_bar.dart`, `widgets/nav/stepper_header.dart`.
- Widgets: `widgets/feedback/empty_state.dart`,
  `widgets/feedback/error_scaffold.dart`, `widgets/result/hero_result_card.dart`,
  `widgets/result/confidence_bar.dart`, `widgets/result/match_strength_dots.dart`,
  `widgets/cards/candidate_card.dart`, `widgets/cards/history_card.dart`,
  `widgets/cards/evidence_card.dart`, `widgets/cards/event_card.dart`,
  `widgets/chips/demo_pill.dart`, `widgets/inputs/input_field.dart`,
  `widgets/inputs/date_picker_field.dart`, `widgets/inputs/time_picker_field.dart`.
- Data: `data/demo/demo_response.dart` (user-visible evidence prose),
  `data/models/event_category.dart`, `match_strength.dart`, `time_window_mode.dart`,
  `calculation_status.dart`, `time_format.dart`,
  `features/calculation_flow/geocoding/geocoding_service.dart` (city stub).

**Prior-run docs referenced (not re-verified line-by-line this run):**
- `docs/feature-gap-analysis.md` (Run 4) — G20 / G21 / G22; Impl Runs A/B/C;
  §9 localization-refactor correction.
- `docs/aso-naming-strategy.md` (Run 3) — brand=English/descriptor=localized;
  §6.3 locale vocab; §9 localization implications; metadata Options C/H/B.
- `docs/competitor-aso-research.md` (Run 2) — §6 locale vocabulary; **W2** German
  credibility bar.
- `docs/growth-thesis.md` (Run 1) — §4.2 Tier 1 locale order; **H4** localization
  hypothesis + kill criterion; §7.2 long-tail keywords.
- `docs/prd.md` (§8 non-goals, §13 privacy), `docs/mvp-scope.md` (Hindi = V1.5,
  "requires translation pipeline").

**Not asserted:** no live store rankings, install/download counts, ratings,
review quotes, trademark clearance, or store-policy approvals. All such items are
routed to Section 13 for human validation.
