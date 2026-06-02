# TrueRise Localization String Audit (Run 5)

- **Document:** `docs/l10n-string-audit.md`
- **Version:** v1.0 (Run 5)
- **Date:** 2026-06-02
- **Model:** `claude-opus-4-8`
- **Status:** Read-only audit. No app code, config, ARB, or `l10n.yaml` created
  or changed. This inventory feeds a *future* extraction run (Impl Run C / G20).
- **Companion:** `docs/l10n-strategy.md` (locale priority, tone rules,
  terminology, QA plan, acceptance criteria).

**Evidence labels:** `[VERIFIED]` = read-only confirmed in this run against the
working tree (2026-06-02); `[ASSUMED]` = inferred; `[PROPOSED]` = recommendation.
Line numbers are from the working tree at audit time and should be re-confirmed
at extraction time (they drift with edits).

---

## 1. Executive summary

The app has **no localization infrastructure** and **~200+ hardcoded,
user-visible English string literals** spread across screens, sheets, widgets,
domain helpers, and demo data `[VERIFIED]`. Extraction is the gating task
(G20 / Impl Run C). This audit:

- confirms the empty-baseline facts (Section 2);
- inventories every user-visible string by module with file paths (Section 3);
- buckets them P0/P1/P2 for extraction order (Section 4);
- flags the strings that need ICU interpolation/plural/select and the
  formatting (time/date/number) that must move to `intl` (Section 5);
- calls out truncation/overflow risk surfaces (Section 6);
- flags sensitive product language requiring careful translation (Section 7);
- proposes implementation-ready extraction batches (Section 8);
- gives a grep-able verification checklist for "extraction complete" (Section 9).

**Three structural findings that shape extraction:**

1. **The widget layer is already locale-clean.** Result/card/picker widgets take
   *pre-formatted* strings and do no formatting; the formatting and the hardcoded
   copy live in the **callers** (screens). Extraction effort is concentrated in
   `lib/features/.../screens/` and a handful of sheets.
2. **Formatting debt is real and duplicated (G21).** Hand-rolled 12/24h AM/PM in
   5 files and hardcoded `Jan..Dec` month maps duplicated in 3 files must move to
   `intl` — fold into the same run.
3. **Accessibility labels are first-class strings.** Many `Semantics(label: ...)`
   values are full interpolated sentences read by screen readers; they must be
   extracted and translated, not skipped.

---

## 2. Confirmed no-l10n baseline

| Fact | How confirmed (read-only, 2026-06-02) | Result |
|---|---|---|
| No ARB files | `glob **/*.arb` | none `[VERIFIED]` |
| No `l10n.yaml` | `glob **/l10n.yaml` | none `[VERIFIED]` |
| No `AppLocalizations` / no `flutter_localizations` wiring | repo-wide grep for `AppLocalizations`, `flutter_localizations`, `localizationsDelegates`, `supportedLocales`, `GlobalMaterialLocalizations`, `gen-l10n` | matches only in `docs/` — **none in `lib/`, `pubspec.yaml`, or config** `[VERIFIED]` |
| No `flutter_localizations` dependency / no `generate: true` | `pubspec.yaml` grep | absent; only `intl: ^0.20.2` at `pubspec.yaml:53` (formatting lib, not l10n wiring) `[VERIFIED]` |
| App root has no locale config | `lib/app/app.dart:14-20` | `MaterialApp.router(title: 'Rectify', ...)`, no `locale` / `localizationsDelegates` / `supportedLocales` `[VERIFIED]` |
| Hardcoded UI strings | reads across `lib/features/**` and `lib/widgets/**` | pervasive Dart string literals (Section 3) `[VERIFIED]` |

**Conclusion:** clean greenfield. No partial/stale l10n setup to migrate;
extraction is additive.

---

## 3. Screen / module inventory of user-visible strings

Grouped by module. "Type" key: **V** = visible copy, **B** = button/CTA label,
**T** = title/header, **H** = helper/hint/placeholder, **S** = Semantics/a11y
label, **F** = format-derived (time/date/number), **D** = dynamic (runtime data),
**X** = interpolated/plural (cross-ref Section 5). Brand token "Rectify"
occurrences are flagged (see strategy Section 4 rule 3 — resolved via G1, not by
translation).

### 3.1 Onboarding — `lib/features/onboarding/onboarding_screen.dart`
- `Skip` (83) B
- `Your birth chart depends on your exact birth time.` (98-99) T
- `Most people only know an approximate time — or nothing at all. Rectify narrows it down using events from your life.` (101-103) V — **em-dash; "Rectify" brand**
- `How Rectify works` (107) T — **brand**
- Slide 2 body — multi-line numbered list with `\n` (109-115) V
- `Ready to find your birth time?` (119) T
- Slide 3 body (121-122) V
- `Try demo first` (141) B
- `Start real calculation` (146) B
- `Next` (153) B
- `Page ${current + 1} of $count` (205) S, X

### 3.2 Birth data — `lib/features/calculation_flow/screens/birth_data_screen.dart`
- `Date of birth` helpText (97) H
- `DateFormat('MMMM d, y')` (107) F
- `Birth details` (132) T
- `Continue` (135) B
- `Date of birth` / `Select date` (149-150) H
- `City of birth` / `Start typing a city` (157-158) H
- `Label (optional)` / `Shown in your history list.` / `e.g. My birth time` (178-181) H
- `Searching…` (214) V
- `No matches. Demo accepts the typed name.` (222) V

### 3.3 Time window — `lib/features/calculation_flow/screens/time_window_screen.dart`
- `_formatTime` literal `PM` / `AM` (32) F
- `± $minutes min` / `± 1 hour` / `± $hours hours` (36-38) X, F — plural + symbol
- `Approximate birth time` helpText (49) H
- `Search window` (66) T
- `Do you know an approximate birth time?` (107) T — **question (es ¿?)**
- `Continue` (113) B
- `I have an approximate time` (130) B
- `I have no idea` (134) B
- `Approximate time` / `Choose time` (142-143) H
- `Search window` (149) H
- range copy `We'll search between <start> and <end>.` (91-92) X
- `A wider window gives more candidates but may reduce precision.` (160-161) V
- `We'll search the entire 24-hour range...` (166-167) V
- `Adding more life events will help narrow it down.` (172) V

### 3.4 Life events — `lib/features/calculation_flow/screens/life_events_screen.dart`
- `_monthLabels` `Jan`..`Dec` (20-33) F — **DUPLICATE #1 of 3**
- `Life events  (${events.length} added)` / `Life events` (102-104) T, X
- `Add event` / `Add first event` (110) B
- `Continue (demo)` / `Continue` (115) B
- `Add memorable events from your life. The more you add, the better.` (129-130) V
- `Add at least 5 events for a real calculation. 3 for a demo.` (135-137) V — banner
- `No events yet.` (143) V
- `${events.length} events. Add 5+ for a stronger real calculation.` (153-155) V, X — plural
- uses `eventCategoryLabel()` (163) D->static (see 3.18)

### 3.5 Confirmation — `lib/features/calculation_flow/screens/confirmation_screen.dart`
- `_monthLabels` `Jan`..`Dec` (21-34) F — **DUPLICATE #2 of 3**
- `DateFormat('MMMM d, y')` (45) F
- hand-rolled AM/PM (47-56) F
- `_formatWindow` (58-62) F, X
- `Date pending` (79) V
- `—` (82) V (em-dash placeholder)
- `Full 24-hour window` (87) V
- `Confirm your calculation` (97) T
- `Back to edit` (103) B
- `Calculate (demo)` / `Calculate` (111) B
- `Birth details` (127) T
- `Date` (129) / `City` (130) / `Label` (132) — `_ReviewRow` labels V
- `Time window` (142) T
- `Life events (${flow.events.length})` (155) T, X
- uses `eventCategoryLabel()` (167) D->static
- `Demo mode — we'll show a sample result with no network request.` (187-188) V

### 3.6 Loading — `lib/features/calculation_flow/screens/loading_screen.dart`
- rotating copy: `Analyzing life events…`, `Mapping planetary transits…`, `Ranking candidates…` (19-23) V
- `Couldn't complete the calculation.` (114) V
- `flow.submitError` (120) D — **raw `failure.toString()` (Section 5.4 defect note)**
- `Running demo calculation…` / `Calculating your probable birth time…` (130-132) V
- `This usually takes under 10 seconds.` (150) V
- `Cancel` (158) B

### 3.7 Result — `lib/features/calculation_flow/screens/result_screen.dart`
- hand-rolled AM/PM (115-134) F
- `Result` (52) T
- `We couldn't find that result.` (84) V
- `It may have been deleted...` (85-87) V
- `Back to history` (89) B
- `${top.ascendant} Rising` (174) X, D — sign token is data, `Rising` suffix translatable
- `(sample data)` (175, 193) V
- `Other candidates` (182) T
- `See how we got this` (204) B
- `Share result` (235) B
- `Copied to clipboard` (242) V — SnackBar
- `Saved ✓` / `Save to history` (283) B — **`✓` glyph**
- `Demo upgrade nudge` (327) S
- `This was a demo.` (343) V
- `Dismiss` (352) S/tooltip
- `Run a real calculation with your own birth data.` (360) V
- `Start a new calculation` (367) B

### 3.8 Evidence — `lib/features/calculation_flow/screens/evidence_screen.dart`
- hand-rolled AM/PM (104-114) F
- `DateFormat('MMM y')` (119) F
- `Evidence` (50) T
- `We couldn't find that evidence.` (82) V
- body (83-85) V
- `Back to history` (87) B
- `Why $topTimeLabel?` (174) T, X
- `We don't have event-level evidence for this result.` (181) V
- `$strongCount of ${evidence.length} events strongly supported this time.` (182-183) V, X — plural
- `Event` fallback (200) V
- uses `eventCategoryLabel()` (199) D->static
- `item.explanation` D — demo/API prose (see 3.19)

### 3.9 Add-event sheet — `lib/features/calculation_flow/widgets/add_event_sheet.dart`
- `_monthLabels` `Jan`..`Dec` (16-29) F — **DUPLICATE #3 of 3**
- uses `eventCategoryLabel()` (121, 219) D->static
- `Select category` (115) T
- `Month` / `No month` (132, 135) H
- `Year` (149) H
- `Edit life event` / `Add life event` (211) T
- `Category` / `Choose category` (216, 220) H
- `Month` (228, 231) H
- `Year` (237, 240) H
- `Month is optional.` (248) H
- `Description (optional)` / `Anything that helps narrow timing` (256, 258) H
- `$length / $_maxDescriptionChars` (268) X, F — char counter
- `Save changes` / `Add event` (281) B

### 3.10 Home / history — `lib/features/home/home_history_screen.dart`
- `Rectify` (39) T — **brand**
- `Settings` (41) S
- `We couldn't load your history.\n$error` (52) V, X, D
- `No calculations yet.` (78) V
- `Run your first one to see results here.` (79) V
- `New Calculation` (81) B
- `DateFormat('MMMM d, y')` (96) F
- hand-rolled AM/PM (111-115) F
- `Delete this calculation?` (124) T
- `This removes "$label" from your history. The original data isn't kept anywhere else.` (126-127) V, X
- `Cancel` (133) B
- `Delete` (140) B
- `Past calculations` (167) T
- `My calculation` fallback label (178) V
- `${topCandidate!.ascendant} Rising` (185) X, D
- `(sample data)` (186) V
- `"$label" deleted.` (201) V, X — SnackBar
- `Couldn't delete this entry.` (204) V
- `Delete` (240) B

### 3.11 Settings — `lib/features/settings/settings_screen.dart`
- `API key` (57) T
- `API Key (Pro / Developer)` (63) V
- `Set` / `Not set` (64) V
- `Optional. Only for users with their own provider key...` (72-73) V
- `Calculation defaults` (82) T
- `Demo mode` (88) V
- `Run calculations with sample data (free, no network).` (90-91) V
- `Time format` (100) V
- `12-hour  (7:14 AM)` (107) V — **embeds a sample time**
- `24-hour  (07:14)` (111) V — **embeds a sample time**
- `Data` (118) T
- `Delete all data` (125) V
- `Removes all calculations and events from this device. Cannot be undone.` (131-132) V
- `About` (141) T
- `Privacy Policy` (145) V
- `Rectify  v1.0.0` (157) V — **brand + version**
- `$label, $value` (209) S, X

### 3.12 Delete-all-data sheet — `lib/features/settings/delete_all_data_sheet.dart`
- `Couldn't delete data. Try again.` (51) V
- generic: `This will permanently delete every calculation, event, and setting on this device. Cannot be undone.` (66-67) V
- count: `This will permanently delete ${_pluralize(count)} and every saved event and setting on this device. Cannot be undone.` (68-69) V, X
- `Delete all data?` (103) T
- `Delete` (115) B
- `Cancel` (120) B
- `_pluralize`: `1 calculation` / `$count calculations` (132) X — **manual plural (must become ICU)**

### 3.13 API-key sheet — `lib/features/settings/api_key_sheet.dart`
- `API key saved.` (80) V
- `API key removed.` (92) V
- `API Key (Pro / Developer)` (133) T
- `Paste your provider key to switch off the standard proxied path. The key is stored on this device only.` (138-139) V
- `API key` (146) H
- `Currently set — enter a new key to replace it` / `sk-…` (149-150) H — `sk-…` likely **do-not-translate** placeholder
- `Save key` (159) B
- `Remove key` (165) B
- `Cancel` (170) B

### 3.14 Privacy policy — `lib/features/settings/privacy_policy_screen.dart`
- `Privacy` (27) T
- `What Rectify stores` (39) T — **brand**
- body (44-48) V — **sensitive (Section 7)**
- `Optional API key` (52) T
- body (57-61) V — **sensitive**
- `Demo mode` (65) T
- body (70-73) V — **sensitive**
- `Deleting your data` (77) T
- body (82-87) V — **sensitive**
- `Analytics and crash reporting` (91) T
- body (96-99) V — **sensitive**

### 3.15 Error screens — `lib/features/error_flow/error_screen.dart`
Seven `_ErrorCopy` records (title + description + primaryLabel) (31-90):
- timeout: `Calculation timed out` / desc / `Try again`
- noInternet: `Can't reach the network` / desc / `Try again`
- badRequest: `Something looked off in the data` / desc / `Review my draft`
- unauthorized: `Authorization required` / desc / `Open Settings`
- missingApiKey: `API key required` / desc (**mentions `astrology-api.io`** = do-not-translate proper noun) / `Open Settings`
- server: `Provider trouble on their end` / desc / `Try again`
- malformed: `Couldn't read the response` / desc / `Try again`
- secondary action `Back to history` (133) B
- (`error_routing.dart` and `core/failures.dart` carry **no** user-facing copy except via the dynamic leak in 5.4) `[VERIFIED]`

### 3.16 Navigation / shell
- `lib/widgets/nav/bottom_tab_bar.dart` — enum labels `NEW`, `HISTORY`, `SETTINGS` (9-11) V + S (used as `Semantics(label:)` at 87) — **uppercase tab labels**
- `lib/widgets/nav/stepper_header.dart` — `STEP $currentStep OF $totalSteps` (33) V, X; value `${...} percent` (37) S
- `lib/widgets/nav/top_nav.dart` — tooltip `Back` (55) S; `title` is passed in (D)
- `lib/features/main_shell/main_shell.dart` — none (composition only) `[VERIFIED]`
- `lib/features/placeholders/coming_soon_screen.dart` — none hardcoded; `title`/`message` passed in (D) `[VERIFIED]`

### 3.17 Feedback / result / card / input widgets
- `widgets/feedback/error_scaffold.dart` — `Semantics(label: '$title. $description')` (35) S, X
- `widgets/feedback/empty_state.dart` — `Semantics(label: '$title. $body')` (35) S, X
- `widgets/result/hero_result_card.dart` — default eyebrow `YOUR MOST PROBABLE BIRTH TIME` (22) V; Semantics `'$eyebrow: $time$meridiem, $risingSign'` (71-72) S, X
- `widgets/result/confidence_bar.dart` — default label `Confidence` (17) V; Semantics `'$label — $percent percent'` (46) S, X; `'$percent%'` (43) F
- `widgets/result/match_strength_dots.dart` — `STRONG` / `MODERATE` / `WEAK` / `NO MATCH` (28,32,36,42) V; Semantics `'Match strength ${label.toLowerCase()}'` (89) S, X
- `widgets/cards/candidate_card.dart` — Semantics `'Candidate $time$meridiem, $risingSign, confidence NN percent'` (37-39) S, X
- `widgets/cards/history_card.dart` — Semantics with `', demo'` suffix (43-46) S, X — **select on isDemo**
- `widgets/cards/evidence_card.dart` — Semantics `'${category}, ${date}, match ${strength.tag.replaceAll('_',' ')}'` (70-72) S, X — uses raw tag
- `widgets/cards/event_card.dart` — Semantics `'Event: $category on $date'` (36) S, X; `'Delete event $category'` (75) S, X
- `widgets/chips/demo_pill.dart` — default label `DEMO` (11) V; Semantics `'$label calculation badge'` (21) S, X
- `widgets/inputs/date_picker_field.dart` — Semantics fallback `not set` (65) S, X
- `widgets/inputs/time_picker_field.dart` — Semantics fallback `not set` (58) S, X
- `widgets/inputs/input_field.dart` — none hardcoded (all passed in) `[VERIFIED]`

### 3.18 Domain helper — `lib/features/calculation_flow/state/calculation_flow_state.dart`
- `eventCategoryLabel(EventCategory)` (317-330) — **12 display labels**: `Marriage / Partnership`, `Divorce / Separation`, `Career change`, `Job loss`, `Relocation (major)`, `Birth of child`, `Death of family member`, `Major illness / surgery`, `Accident or injury`, `Education milestone`, `Financial turning point`, `Other`. Dartdoc explicitly states "Phase 4 ships English copy only ... without depending on intl-localized bundles" — **a deliberate placeholder for localization** `[VERIFIED]`. Translate via ARB keyed by `EventCategory.tag`; **never** translate the stable `tag` values in `event_category.dart` (storage identifiers).
- `lib/features/calculation_flow/state/calculation_flow_controller.dart:215` — `BadRequestFailure('Calculation draft is incomplete.')` — an English message string; `:239` sets `submitError: failure.toString()` (see 5.4).

### 3.19 Demo data — `lib/data/demo/demo_response.dart`
- **6 evidence explanation strings** (45-57), user-visible on the evidence
  screen via `item.explanation`: 2 strong, 2 moderate, 1 weak, 1 none. Long prose
  (e.g. "A timed Venus return aligned with the candidate window, consistent with
  a partnership event.") `[VERIFIED]` — **sensitive register (Section 7)**.
- `method: 'demo_canonical'` (108) — internal token, **not user-visible**, do not
  extract.

### 3.20 Geocoding stub — `lib/features/calculation_flow/geocoding/geocoding_service.dart`
- 12 city `displayName` strings (`Kyiv, Ukraine`, `London, United Kingdom`,
  `Berlin, Germany`, ...) (29-104) — **proper nouns; do-not-translate**. This is
  a Phase-4 in-memory stub to be replaced by a real geocoder; not a translation
  target. Noted for completeness only `[VERIFIED]`.

---

## 4. Priority buckets for extraction

| Bucket | Definition | Modules |
|---|---|---|
| **P0** | On the golden path every user sees (onboarding -> demo/real -> result -> evidence) + global chrome + interrupting errors. A localized release is incoherent without these. | 3.1 onboarding, 3.2 birth data, 3.3 time window, 3.4 life events, 3.5 confirmation, 3.6 loading, 3.7 result, 3.8 evidence, 3.9 add-event sheet, 3.10 home/history, 3.15 error screens, 3.16 nav/shell (tabs, stepper, back), 3.18 `eventCategoryLabel`. Includes the formatting fixes (5.1-5.3) on these screens. |
| **P1** | Needed for a complete localized release but off the primary visual path; plus all accessibility labels and sensitive legal copy. | 3.11 settings, 3.12 delete-all sheet, 3.13 API-key sheet, 3.14 privacy policy, 3.17 widget Semantics/defaults (a11y), 3.19 demo evidence prose. |
| **P2** | Low-frequency, edge, or non-translatable; handle last or specially. | 3.4/3.5/3.8 fallbacks (`My calculation`, `Event`, `Date pending`), `sk-…` hint (do-not-translate), `not set` picker fallbacks, the dynamic `submitError` leak (needs a code fix, not just extraction — 5.4), `astrology-api.io` / city names / zodiac tokens / `method` token (do-not-translate or data). |

Recommended order: **P0 -> P1 -> P2**, but extract *whole files at once* (a file
straddling buckets is extracted in its highest bucket's batch — Section 8).

---

## 5. Strings requiring interpolation / plurals / selects, and formatting notes

### 5.1 Time formatting (12/24h) — move to `intl` (G21)
Hand-rolled AM/PM with literal `'AM'`/`'PM'` appears in `[VERIFIED]`:
`result_screen.dart` (115-134), `evidence_screen.dart` (104-114),
`time_window_screen.dart` (32), `confirmation_screen.dart` (47-56),
`home_history_screen.dart` (111-115). Plus `settings_screen.dart` embeds sample
times in option labels (107, 111). **Action:** replace with `intl`
`DateFormat.jm()` / locale + the user's `TimeFormat` setting; the hero/candidate/
history widgets already accept a separate `meridiem` param (empty for 24h) — keep
that contract, feed it from `intl`.

### 5.2 Date / month formatting — move to `intl` (G21)
`_monthLabels` `Jan..Dec` duplicated in **3 files** (`life_events_screen.dart`
20-33, `confirmation_screen.dart` 21-34, `add_event_sheet.dart` 16-29), plus
`DateFormat('MMMM d, y')` (`birth_data_screen.dart:107`,
`confirmation_screen.dart:45`, `home_history_screen.dart:96`) and
`DateFormat('MMM y')` (`evidence_screen.dart:119`) `[VERIFIED]`. **Action:** delete
the three maps; use locale-aware `DateFormat` so month names and date order
localize.

### 5.3 Numbers / percent
`confidence_bar.dart:43` renders `'$percent%'` and its Semantics says
`'... $percent percent'` (46) `[VERIFIED]`. **Action:** use `intl` `NumberFormat`
for percent (locale spacing/symbol; FR uses a non-breaking space before `%`).
`stepper_header.dart:37` `'${(progress*100).round()} percent'` is a11y text.

### 5.4 Dynamic error leak (defect-adjacent)
`loading_screen.dart:120` displays `flow.submitError`, which the controller sets
to `failure.toString()` (`calculation_flow_controller.dart:239`), e.g.
`ServerFailure(500)` or `BadRequestFailure(Calculation draft is incomplete.)`
`[VERIFIED]`. These are **debug strings, not localized copy.** **Action (note for
Run C, not this run):** map `AppFailure` to localized user copy (the error
*screens* already do this in `error_screen.dart`); do not extract `toString()`
output as translatable. Flag to owner — this is a small UX/i18n correctness fix
that rides along with extraction.

### 5.5 Interpolation + plural/select inventory (needs ICU)
Each of these must become an ICU message with placeholders, and the counted ones
must use `plural`; `isDemo`-style branches use `select`:

| String (source) | File:line | ICU need |
|---|---|---|
| `Page ${current+1} of $count` | onboarding 205 | placeholders |
| `± $minutes min` / `± 1 hour` / `± $hours hours` | time_window 36-38 | **plural** (min/hour) + symbol |
| `We'll search between <start> and <end>.` | time_window 91-92 | placeholders (2x time) |
| `Life events  (${events.length} added)` | life_events 102-104 | **plural** |
| `${events.length} events. Add 5+ ...` | life_events 153-155 | **plural** |
| `Life events (${flow.events.length})` | confirmation 155 | **plural** |
| `Why $topTimeLabel?` | evidence 174 | placeholder |
| `$strongCount of ${evidence.length} events strongly supported this time.` | evidence 182-183 | **plural** (events) + placeholder |
| `$length / $_maxDescriptionChars` | add_event_sheet 268 | placeholders (number format) |
| `We couldn't load your history.\n$error` | home_history 52 | placeholder (+ 5.4 caveat) |
| `This removes "$label" from your history. ...` | home_history 126-127 | placeholder |
| `"$label" deleted.` | home_history 201 | placeholder |
| `${ascendant} Rising` | result 174; home_history 185 | placeholder (sign=data) |
| `$count calculations` / `1 calculation` | delete_all_data_sheet 132 | **plural** |
| delete-data count sentence | delete_all_data_sheet 68-69 | nested placeholder (uses the plural) |
| `$label, $value` | settings 209 | placeholders (a11y) |
| `STEP $currentStep OF $totalSteps` | stepper_header 33 | placeholders |
| `$title. $description` / `$title. $body` | error_scaffold 35; empty_state 35 | placeholders (a11y) |
| `$eyebrow: $time$meridiem, $risingSign` | hero_result_card 71-72 | placeholders (a11y) |
| `$label — $percent percent` | confidence_bar 46 | placeholder + number (a11y) |
| `Match strength ${label.toLowerCase()}` | match_strength_dots 89 | **case-sensitivity trap** — `toLowerCase()` is English-centric; localize the label form directly |
| `Candidate $time$meridiem, $risingSign, confidence NN percent` | candidate_card 37-39 | placeholders + number (a11y) |
| history card Semantics incl. `, demo` | history_card 43-46 | **select** (isDemo) + placeholders (a11y) |
| `${category}, ${date}, match ${tag...}` | evidence_card 70-72 | placeholders (a11y); map tag->localized |
| `Event: $category on $date` / `Delete event $category` | event_card 36, 75 | placeholders (a11y) |
| `$label calculation badge` | demo_pill 21 | placeholder (a11y) |
| `$label, ${... 'not set'}` | date/time_picker_field 65/58 | placeholder + fallback string |

**Trap:** `match_strength_dots.dart:89` builds the a11y string by lowercasing the
English display label. That breaks in other locales (case rules differ; the
lowercased English word won't exist). Localize the spoken form as its own key.

---

## 6. Risk notes — truncation / overflow and locale-specific long words

Highest-risk surfaces (narrow, single-line, or fixed-width) `[VERIFIED widgets]`:

- **DEMO pill** (`demo_pill.dart`) — tiny chip; DE/ES equivalents are longer.
- **Bottom tab labels** `NEW`/`HISTORY`/`SETTINGS` (`bottom_tab_bar.dart`, 11pt,
  three equal-width slots) — DE "EINSTELLUNGEN" is far longer than "SETTINGS".
- **TopNav title** — single line with `TextOverflow.ellipsis`
  (`top_nav.dart:64-69`); long localized screen titles will clip.
- **History card label** — `maxLines: 1` + ellipsis (`history_card.dart:58-63`).
- **Event card category** — `maxLines: 1` + ellipsis (`event_card.dart:53-57`);
  `eventCategoryLabel` values like "Death of family member" already long, worse
  in DE.
- **Primary/secondary buttons** across the flow — fixed-height CTAs with long
  localized verbs ("Start real calculation" -> longer in every Tier 1 locale).
- **StepperHeader eyebrow**, **confidence percentage row**, **error titles**
  (centered, max 320pt in `error_scaffold.dart:59`).
- **Settings option labels** embedding sample times (107, 111) — layout assumes
  short text.

**Locale long-word offenders:** German compounds
("Geburtszeitkorrektur", "Lebensereignisse", "Datenschutzerklärung",
"Einstellungen"); Romance languages run ~15-20% longer than English overall.
**Mitigation:** pseudo-localization pass before real translations; test on the
smallest supported screen and at large OS text scale (strategy Section 11).

---

## 7. Translation notes for sensitive product language

Translate these with native review; literal fidelity is secondary to preserving
the product's honest, non-deterministic, privacy-first posture (strategy Section
6/7):

1. **Probabilistic framing** — `YOUR MOST PROBABLE BIRTH TIME`
   (hero_result_card 22), `Calculating your probable birth time…`
   (loading 130-132), `most probable`/`candidates`/`narrows it down` copy. Keep
   the hedge; never render as certainty.
2. **Confidence / evidence** — `Confidence` (confidence_bar 17),
   `STRONG/MODERATE/WEAK/NO MATCH` (match_strength_dots), evidence prose
   (demo_response 45-57), `$strongCount of N events strongly supported this time`
   (evidence). Use indication words, **not proof words** (DE Beweis / FR preuve /
   ES prueba / PT prova) and **not certainty words** for confidence (strategy
   7.1, Section 8).
3. **Privacy guarantees** — privacy policy bodies (privacy_policy_screen 44-99),
   `The key is stored on this device only.` (api_key_sheet 138-139),
   `Run calculations with sample data (free, no network).` (settings 90-91),
   `we'll show a sample result with no network request.` (confirmation 187-188),
   `The original data isn't kept anywhere else.` (home_history 126-127). These are
   **promises**; translate precisely, never soften or overstate (compliance risk).
4. **Demo vs real, no upsell** — `This was a demo.` / `Run a real calculation
   with your own birth data.` (result 343/360). Keep informational register; no
   "unlock/premium/upgrade" pressure (strategy 6.6).
5. **Life-event categories** — `eventCategoryLabel` incl. "Major illness /
   surgery", "Financial turning point" (calculation_flow_state 317-330). These
   are **user-selected event labels, not advice**; keep descriptive, no
   medical/financial-advice connotation.
6. **Do-not-translate tokens** — brand `TrueRise`; codename `Rectify`;
   `astrology-api.io`; `sk-…` key hint; zodiac sign tokens (data); city stub
   names; `method`/`tag`/enum storage identifiers. Hold these constant (ideally
   via placeholders so translators can't alter them).

---

## 8. Implementation-ready extraction batches (for Impl Run C / G20)

Extract whole files per batch (avoids half-localized files). Suggested order:

- **Batch C0 — pipeline bootstrap (no copy yet):** add `flutter_localizations` +
  `generate: true` (`pubspec.yaml`), add `l10n.yaml`, create empty
  `lib/l10n/app_en.arb`, wire `localizationsDelegates` + `supportedLocales: [en]`
  in `app.dart`. App still English, unchanged.
- **Batch C1 — formatting core (G21):** introduce a single locale-aware
  time/date/number formatting helper using `intl`; delete the 3 `_monthLabels`
  maps and all hand-rolled AM/PM; route `result`, `evidence`, `confirmation`,
  `time_window`, `home_history`, `birth_data`, and the settings sample-time
  labels through it. (Do this early so later batches extract clean copy, not
  format fragments.)
- **Batch C2 — onboarding + calc flow P0 part 1:** `onboarding_screen`,
  `birth_data_screen`, `time_window_screen`, `life_events_screen` (+
  `eventCategoryLabel` in `calculation_flow_state`).
- **Batch C3 — calc flow P0 part 2:** `confirmation_screen`, `loading_screen`,
  `add_event_sheet`; add the `AppFailure`->localized-copy map and stop showing
  `failure.toString()` (5.4).
- **Batch C4 — result/evidence + result widgets (P0):** `result_screen`,
  `evidence_screen`, `hero_result_card`, `candidate_card`, `confidence_bar`,
  `match_strength_dots` (fix the `toLowerCase()` a11y trap), `evidence_card`,
  `demo_pill`, `event_card`, `history_card`.
- **Batch C5 — home + global chrome (P0):** `home_history_screen`,
  `bottom_tab_bar`, `stepper_header`, `top_nav`, `error_scaffold`, `empty_state`,
  `date_picker_field`, `time_picker_field`, `coming_soon` callers.
- **Batch C6 — error screens (P0):** `error_screen` (7 records).
- **Batch C7 — settings cluster + legal (P1):** `settings_screen`,
  `delete_all_data_sheet` (convert `_pluralize` to ICU), `api_key_sheet`,
  `privacy_policy_screen`.
- **Batch C8 — demo prose (P1):** `demo_response` evidence explanations.

Each batch: extract literals to keyed ARB entries with `@`-metadata
(description + placeholder types), replace with `AppLocalizations`, run
`flutter analyze` + affected tests, confirm demo stays offline.

---

## 9. Verification checklist (extraction complete)

Run these after Run C; all must pass:

- [ ] `glob **/*.arb` returns `app_en.arb` (and later target ARBs).
- [ ] `glob **/l10n.yaml` returns one config.
- [ ] `pubspec.yaml` contains `flutter_localizations` + `generate: true`.
- [ ] `app.dart` has `localizationsDelegates` + `supportedLocales`.
- [ ] Grep `lib/` for hardcoded literals finds **none** user-visible: e.g.
      `'AM'`/`'PM'` literals gone; no `_monthLabels`; no `Text('...')` /
      `Semantics(label: '...')` with English literals; no `tooltip: '...'`,
      `helpText: '...'`, `hintText: '...'`, `label(s): '...'` literals on
      user-facing widgets. (Allowed: `Key`/`ValueKey` strings, route paths, enum
      `tag`s, `method` tokens, `sk-…` hint if intentionally kept, proper-noun
      data.)
- [ ] No `failure.toString()` shown to users (5.4 fixed).
- [ ] All counted strings use ICU `plural`; `isDemo`-style use `select`.
- [ ] `match_strength_dots` a11y no longer derives copy via `toLowerCase()`.
- [ ] `flutter analyze` clean; tests resolve copy via `AppLocalizations` and
      pass; `integration_test/demo_flow_test.dart` still offline + green.
- [ ] Pseudo-localization shows no clipping on smallest supported screen.

---

## 10. Source / evidence appendix

**Files read read-only this run (2026-06-02)** — see the file paths enumerated in
Section 3 (3.1-3.20) plus baseline checks in Section 2. Specifically:
`lib/app/app.dart`; `pubspec.yaml`; all `lib/features/calculation_flow/screens/*`;
`lib/features/calculation_flow/widgets/add_event_sheet.dart`;
`lib/features/calculation_flow/state/{calculation_flow_state,calculation_flow_controller}.dart`;
`lib/features/calculation_flow/geocoding/geocoding_service.dart`;
`lib/features/home/home_history_screen.dart`; `lib/features/settings/*`;
`lib/features/error_flow/{error_screen,error_routing}.dart`; `lib/core/failures.dart`;
`lib/features/main_shell/main_shell.dart`;
`lib/features/placeholders/coming_soon_screen.dart`; `lib/widgets/nav/*`;
`lib/widgets/feedback/{empty_state,error_scaffold}.dart`; `lib/widgets/result/*`;
`lib/widgets/cards/*`; `lib/widgets/chips/demo_pill.dart`; `lib/widgets/inputs/*`;
`lib/data/demo/demo_response.dart`; `lib/data/models/{event_category,match_strength,time_window_mode,calculation_status,time_format}.dart`.

**Method:** `glob` for `.arb`/`l10n.yaml`; repo-wide `grep` for l10n wiring
symbols and `eventCategoryLabel`; direct `Read` of each module above. Line numbers
are point-in-time and must be re-confirmed at extraction.

**Not asserted:** no live store data, ratings, install counts, or policy
approvals. Generated files (`*.g.dart`, `*.freezed.dart`) were **not** treated as
extraction targets. `pubspec.yaml`, `ios/`, `android/`, `test/`,
`integration_test/`, assets, and screenshots were **not** modified.

**Cross-references:** `docs/l10n-strategy.md` (Run 5),
`docs/feature-gap-analysis.md` (G20/G21/G22, Impl Runs A/C/D),
`docs/aso-naming-strategy.md` (Run 3), `docs/competitor-aso-research.md` (Run 2,
W2), `docs/growth-thesis.md` (Run 1, H4).
