# Implementation Plan — Rectify Flutter MVP

**Version:** 0.1
**Date:** 2026-05-20
**Status:** Technical plan, ready to scaffold against
**Linked to:** `docs/prd.md`, `docs/mvp-scope.md`, `docs/ascii-wireframes.md`, `docs/design-brief.md`, `docs/design-system.md`, `design/mobile-prototype.html`

This document is the engineering counterpart to the design and product docs above. It is the source of truth for: which Flutter architecture we use, what packages we add, how files are organised, how data flows, how API integration is gated, how the demo path works, and the build order from empty repo to a demo-ready binary.

It is deliberately specific. An engineer should be able to read this end-to-end and start scaffolding the Flutter project without further design or product analysis.

---

## 1. MVP Goal and Implementation Boundaries

### 1.1 Goal in one sentence

Ship a stable, mobile-native Flutter app (iOS 15+, Android 10+) that takes birth data + an approximate time window + a list of life events and returns a ranked list of probable birth times with confidence scores and per-event evidence — with a full, no-key, no-payment **demo path** that exercises every screen and a real-API path gated only by configured API access (backend proxy in production, or a user-supplied key in dev/pro mode).

### 1.2 In scope for this plan

- Flutter project scaffold targeting iOS and Android only (no web, desktop, watchOS, widget extensions).
- Implementation of the 9 wireframe screens from `docs/ascii-wireframes.md` plus the confirmation/review screen present in `design/mobile-prototype.html`.
- Design-system implementation per `docs/design-system.md` (tokens, components, theming).
- Demo mode with a hardcoded mock response matching `docs/mvp-scope.md` §DM2.
- Real rectification call via an injected HTTP base URL (proxy or provider directly).
- Local SQLite persistence for calculations, life events, candidate results, and settings.
- "Delete all data" wipe.
- Geocoding for the City of Birth field.
- Crash reporting (anonymous).
- Unit, widget, golden, and integration smoke tests.
- App-store-ready release builds.

### 1.3 Out of scope (do not build, do not stub)

These are out of MVP by product decision (see `docs/prd.md` §8 and `docs/mvp-scope.md` "Explicitly Deferred Features"). The plan must produce **no** code, models, screens, or scaffolding for any of them:

- In-app purchase, restore purchase, purchase history, credit ledger, paywall, price gate.
- PDF / image export, share sheets for results.
- Vedic / KP method toggle.
- Birth chart rendering.
- Hindi / any non-English locale (but the code is locale-aware — see §6.6).
- Live astrologer consultation, social, community.
- User accounts, login, server-side sync.
- Push notifications, in-app review prompts.
- Apple Watch, widgets, App Clips, instant apps.
- Dark mode (token scaffolding only — see §13).

If any of these crops up during build, treat it as scope creep, do not implement, and surface it for re-scoping.

### 1.4 What "MVP complete" means

`docs/mvp-scope.md` §"Acceptance Criteria" defines this. We restate the engineering-facing checklist in §16 below.

---

## 2. Recommended Flutter Architecture

### 2.1 Architecture style: Feature-first, layered

Rectify is small enough that any over-engineered architecture (clean architecture with 4+ layers, hexagonal, BLoC-with-events) will create more surface area than it removes. It is large enough that one big `main.dart` and a stateful widget tree will rot inside the first month.

We use a **feature-first, layered** architecture with three layers:

```
                ┌──────────────────────────┐
                │   Presentation layer     │  ConsumerWidgets, controllers
                │   (lib/features/*)       │  (StateNotifier / AsyncNotifier)
                └────────────┬─────────────┘
                             │
                ┌────────────▼─────────────┐
                │   Domain / repositories  │  Pure-Dart contracts
                │   (lib/data/repos/*)     │  RectificationRepository, etc.
                └────────────┬─────────────┘
                             │
              ┌──────────────▼──────────────┐
              │   Data sources              │  Dio client, Drift DAOs,
              │   (lib/data/api, lib/data/db│  flutter_secure_storage
              │    lib/data/secure)         │
              └─────────────────────────────┘
```

Each feature folder owns its screens, its local controllers, and its feature-specific widgets. Cross-feature widgets live in `lib/widgets/`. Layers below presentation are framework-agnostic plain Dart where possible.

### 2.2 Why this and not the alternatives

| Alternative | Why we rejected it |
|---|---|
| Plain StatefulWidget + lifting state up | Sufficient for two screens, falls apart at 10 screens, no testability story, no separation of fetch logic from UI. |
| Bloc | Heavier ceremony per feature (events, states, blocs, sealed classes), and we have no streaming-data feature. Riverpod gives the same testability with less code. |
| Provider (the package) | Riverpod is the same author's successor; the entire community has moved. No reason to start a new project on it. |
| GetX | Service-locator + reactive primitives bundled together; conflicts with Flutter idioms; community quality is uneven. Hard pass. |
| MobX | Annotation-driven reactivity is powerful but the build/codegen toolchain churn is not worth it for an MVP. |
| Clean architecture with use-case classes per action | Adds a "use case" layer between controller and repo that is pure indirection for an app this size. Skip. |

### 2.3 Architectural rules of the road

These are non-negotiable. Code review must enforce them.

1. **Widgets never call data sources directly.** Widgets read state from controllers/providers; controllers call repositories; repositories call data sources.
2. **Repositories return domain models, not DTOs.** DTOs live in `lib/data/api/dto/`. The mapping from DTO → domain model happens inside the repository.
3. **No `Provider.of`, no `Theme.of(context)` repeated in widget bodies.** Pull from theme once at the top of `build` into a local `final t = Theme.of(context);`.
4. **No singletons that hold mutable state.** All state lives in providers. The few unavoidable singletons (database, secure storage) are exposed via providers.
5. **Errors flow as typed sealed unions** (see §11). No throwing `String` across layer boundaries.
6. **The demo flow runs through the same controller as the real flow.** The branch happens once, inside the repository, based on a flag on the calculation. (See §10.)

---

## 3. Folder Structure

The target structure below covers MVP. Create empty folders during scaffold; populate them as phases land.

```
astro-rectification-app/
├── android/                          # Generated by `flutter create`
├── ios/                              # Generated by `flutter create`
├── assets/
│   ├── icons/                        # Brand mark, quiet glyphs (.svg)
│   └── fonts/                        # (empty — fonts loaded via google_fonts)
├── lib/
│   ├── main.dart                     # runApp + ProviderScope
│   ├── app/
│   │   ├── app.dart                  # RectifyApp (MaterialApp.router)
│   │   ├── router.dart               # go_router config + route paths
│   │   ├── route_names.dart          # const String names for every route
│   │   └── bootstrap.dart            # async init: Drift open, secure storage, crashlytics
│   ├── theme/
│   │   ├── colors.dart               # bg.*, ink.*, accent.*, deep.*, confidence.*, status.*
│   │   ├── typography.dart           # display.xl/lg/md, title.*, body.*, label.*, mono.xl
│   │   ├── spacing.dart              # space.0..11 as static const double
│   │   ├── radius.dart               # radius.xs/sm/md/lg/xl/full as BorderRadius
│   │   ├── elevations.dart           # elev.1 / elev.2 BoxShadow lists
│   │   ├── motion.dart               # durations + Curves
│   │   ├── rectify_tokens.dart       # ThemeExtension<RectifyTokens> for non-Material tokens
│   │   ├── theme.dart                # buildLightTheme(): ThemeData
│   │   └── icons.dart                # central Lucide icon mapping (so swap is one file)
│   ├── widgets/
│   │   ├── buttons/primary_button.dart
│   │   ├── buttons/secondary_button.dart
│   │   ├── buttons/ghost_button.dart
│   │   ├── buttons/destructive_button.dart
│   │   ├── inputs/input_field.dart
│   │   ├── inputs/date_picker_field.dart
│   │   ├── inputs/time_picker_field.dart
│   │   ├── inputs/city_search_field.dart
│   │   ├── inputs/radio_group.dart
│   │   ├── inputs/labeled_toggle.dart
│   │   ├── chips/chip_pill.dart
│   │   ├── chips/demo_pill.dart
│   │   ├── cards/app_card.dart
│   │   ├── cards/event_card.dart
│   │   ├── cards/candidate_card.dart
│   │   ├── cards/history_card.dart
│   │   ├── cards/evidence_card.dart
│   │   ├── result/hero_result_card.dart
│   │   ├── result/confidence_bar.dart
│   │   ├── result/match_strength_dots.dart
│   │   ├── feedback/breath_ring_loader.dart
│   │   ├── feedback/pulse_dot_loader.dart
│   │   ├── feedback/empty_state.dart
│   │   ├── nav/top_nav.dart
│   │   ├── nav/bottom_tab_bar.dart
│   │   ├── nav/stepper_header.dart
│   │   └── sheets/bottom_sheet_picker.dart
│   ├── core/
│   │   ├── result.dart               # sealed Result<T, F extends AppFailure>
│   │   ├── failures.dart             # sealed AppFailure hierarchy
│   │   ├── logger.dart               # debug/info/warn/error, no PII
│   │   ├── clock.dart                # injectable Clock for tests
│   │   ├── uuid.dart                 # uuid factory wrapper
│   │   └── formatters.dart           # time/date/percent formatting via intl
│   ├── data/
│   │   ├── models/
│   │   │   ├── birth_data.dart            # freezed
│   │   │   ├── time_window.dart           # freezed
│   │   │   ├── life_event.dart            # freezed + EventCategory enum
│   │   │   ├── calculation_request.dart   # freezed (request envelope)
│   │   │   ├── candidate_time.dart        # freezed
│   │   │   ├── evidence_item.dart         # freezed
│   │   │   ├── calculation_result.dart    # freezed
│   │   │   ├── saved_calculation.dart     # freezed (history row aggregate)
│   │   │   ├── settings_model.dart        # freezed
│   │   │   └── geo_place.dart             # freezed (geocoding result)
│   │   ├── api/
│   │   │   ├── api_client.dart            # Dio instance factory + interceptors
│   │   │   ├── dto/
│   │   │   │   ├── rectification_request_dto.dart   # json_serializable
│   │   │   │   ├── rectification_response_dto.dart
│   │   │   │   └── mappers.dart                     # DTO <-> domain conversions
│   │   │   └── rectification_api.dart     # POST /v1/rectification, returns DTO or AppFailure
│   │   ├── db/
│   │   │   ├── database.dart              # Drift database class
│   │   │   ├── tables.dart                # Calculations, LifeEvents, CandidateResults, Drafts
│   │   │   ├── daos/calculation_dao.dart
│   │   │   ├── daos/life_event_dao.dart
│   │   │   ├── daos/candidate_dao.dart
│   │   │   ├── daos/draft_dao.dart
│   │   │   └── migrations.dart
│   │   ├── prefs/
│   │   │   └── settings_store.dart        # shared_preferences wrapper for non-secret settings
│   │   ├── secure/
│   │   │   └── secure_key_store.dart      # flutter_secure_storage wrapper (API key only)
│   │   ├── geocoding/
│   │   │   └── geocoding_service.dart     # abstract + chosen implementation
│   │   ├── demo/
│   │   │   └── demo_response.dart         # the hardcoded mock per §DM2
│   │   └── repos/
│   │       ├── rectification_repository.dart       # contract + impl
│   │       ├── history_repository.dart
│   │       ├── settings_repository.dart
│   │       └── draft_repository.dart
│   ├── providers/
│   │   ├── core_providers.dart            # database, dio, clock, uuid, secure storage
│   │   ├── repo_providers.dart            # repos exposed as providers
│   │   ├── settings_providers.dart
│   │   ├── history_providers.dart
│   │   └── calculation_providers.dart     # current-calculation draft + flow controller
│   └── features/
│       ├── onboarding/
│       │   ├── onboarding_screen.dart
│       │   ├── onboarding_slide.dart
│       │   └── onboarding_controller.dart
│       ├── home_history/
│       │   ├── home_history_screen.dart
│       │   ├── history_list.dart
│       │   └── history_controller.dart
│       ├── calculation/
│       │   ├── birth_data_screen.dart
│       │   ├── time_window_screen.dart
│       │   ├── life_events_screen.dart
│       │   ├── add_event_sheet.dart
│       │   ├── category_picker_sheet.dart
│       │   ├── confirmation_screen.dart
│       │   ├── loading_screen.dart
│       │   ├── result_screen.dart
│       │   ├── evidence_screen.dart
│       │   └── calculation_controller.dart
│       ├── settings/
│       │   ├── settings_screen.dart
│       │   ├── api_key_sheet.dart
│       │   └── settings_controller.dart
│       └── errors/
│           ├── timeout_error_screen.dart
│           ├── no_internet_screen.dart
│           └── generic_error_screen.dart
├── test/
│   ├── unit/                # data/, core/, mappers/, formatters/
│   ├── widget/              # widgets/
│   ├── golden/              # golden_test.dart + goldens/*.png
│   └── helpers/
├── integration_test/
│   ├── demo_flow_test.dart
│   └── helpers.dart
├── docs/                    # existing
├── design/                  # existing
├── pubspec.yaml
├── analysis_options.yaml    # very_good_analysis or equivalent strict ruleset
└── README.md
```

Naming rules:
- File names: `snake_case.dart`.
- Class names: `PascalCase`, classes match file name 1:1 where there is one main class.
- Domain models: nouns, no `Model` suffix (`LifeEvent`, not `LifeEventModel`). DTOs get a `Dto` suffix.
- Providers: `<noun>Provider` suffix.

---

## 4. State Management

### 4.1 Choice: Riverpod 2.x with code generation

We use `flutter_riverpod` 2.6+ with `riverpod_annotation` + `riverpod_generator` for compile-safe providers and `AsyncNotifier` / `AsyncValue<T>` for async state.

### 4.2 Why Riverpod

- **Compile-safe providers.** A typo in a provider name is a build error, not a runtime null.
- **No `BuildContext` dependency for reading state.** Repositories and controllers stay free of Flutter framework imports.
- **First-class async.** `AsyncValue<T>` is `loading | data | error`, the exact shape the calculation flow needs.
- **Overrides for tests.** Every dependency is a provider; tests inject fakes via `overrides:` on `ProviderScope`. No DI container, no service locator.
- **Codegen ergonomics.** `@riverpod` annotation reduces boilerplate to a function definition with a return type.
- **Works seamlessly with go_router.** Routing reads providers via the `redirect` hook for the onboarding gate.

### 4.3 Provider taxonomy

| Provider kind | Use for | Example |
|---|---|---|
| `Provider<T>` | Stateless dependencies | `dioProvider`, `clockProvider`, `databaseProvider` |
| `FutureProvider<T>` | One-shot async reads | `appVersionProvider`, `geoSearchProvider(query)` |
| `StreamProvider<T>` | DB-backed lists | `historyProvider` (Drift stream) |
| `NotifierProvider<N, T>` | Sync mutable state | `currentDraftProvider` (the in-progress calculation) |
| `AsyncNotifierProvider<N, T>` | Async mutable state | `calculationFlowControllerProvider` (runs the API call, exposes `AsyncValue<CalculationResult>`) |

### 4.4 Controller pattern

Each feature has one controller class extending `Notifier` or `AsyncNotifier`. The controller:

- Holds the feature's UI state (typically a single freezed state class).
- Calls one or more repositories.
- Never imports `flutter/material.dart`.
- Is tested with `ProviderContainer` and overridden repo fakes.

The `CalculationFlowController` is the central piece: it holds the draft as the user moves through Birth Data → Time Window → Life Events → Confirmation, and it dispatches the calculation when the user taps **Calculate**.

### 4.5 Dependency wiring

`lib/providers/core_providers.dart` exposes the infrastructure dependencies (Dio, Drift database, secure storage, clock, uuid factory). Repo providers in `repo_providers.dart` `ref.watch` those core providers and return live repositories. Controllers `ref.watch` repo providers.

In tests, override the **lowest layer needed** (usually the repo provider) to avoid stubbing each leaf dependency.

---

## 5. Navigation Structure

### 5.1 Router: go_router 14+

go_router is the Flutter team's official router. We use the declarative variant (`GoRouter(routes: [...])`) with `ShellRoute` for the bottom-tab parent and `GoRoute` children for everything else.

### 5.2 Top-level structure

```
GoRouter
├── /onboarding                          (full-screen, no tab bar)
├── ShellRoute (bottom tab bar)
│   ├── /                                → Home / History (default)
│   ├── /history/:id                     → Result (cached)  ← also reachable from calc flow
│   ├── /settings
│   │   └── /settings/api-key            → API key bottom sheet (modal route)
│   └── /history/:id/evidence            → Evidence Breakdown
├── /calc                                (full-screen flow, no tab bar)
│   ├── /calc/birth                      → Birth Data Input
│   ├── /calc/window                     → Time Window Setup
│   ├── /calc/events                     → Life Events Input
│   ├── /calc/confirm                    → Confirmation review
│   ├── /calc/loading                    → Calculation Loading
│   └── /calc/result/:resultId           → Result Screen
│       └── /calc/result/:resultId/evidence → Evidence Breakdown
└── /error/:kind                         → Error screens (timeout / no-internet / generic)
```

### 5.3 Route names

All route names are constants in `lib/app/route_names.dart`. No string literals at call sites.

### 5.4 Gates and redirects

- **First-launch gate.** `GoRouter.redirect` reads `onboardingDoneProvider` (StreamProvider over Drift settings). If false, force `/onboarding`. The onboarding screen sets the flag on completion or skip.
- **History deep link.** `/history/:id` resolves the calculation by id; if not found, redirects to `/` with a snackbar.
- **Calc flow guard.** Routes under `/calc/*` require a current draft. If none exists (deep link or hot-reload during dev), redirect to `/calc/birth` and reset.

### 5.5 Back behaviour

- Back from `/calc/*` pops within the stack normally. Back from `/calc/birth` exits the flow with a confirm-discard sheet if there is data in the draft.
- iOS swipe-back works automatically with go_router; Android system back is handled by go_router.
- The Result screen does **not** allow back-into-loading. After the result is shown, the loading screen is removed from the stack with `go()` (not `push`).

### 5.6 Screen inventory (final list)

Counted against `docs/ascii-wireframes.md` + `design/mobile-prototype.html`:

1. Onboarding Slide 1
2. Onboarding Slide 2
3. Onboarding Slide 3
4. Home / History — empty
5. Home / History — populated
6. Birth Data Input (with City Search dropdown variant)
7. Time Window Setup (two states: approximate vs "no idea")
8. Life Events Input — empty
9. Life Events Input — populated
10. Add Event bottom sheet
11. Category picker sheet
12. Confirmation / review (from prototype)
13. Calculation Loading — real
14. Calculation Loading — demo
15. Result Screen
16. Evidence Breakdown
17. Settings
18. API Key bottom sheet
19. Error: Timeout / 5xx
20. Error: No Internet
21. Inline error: City not found

Counts as **9 unique route surfaces** in go_router (slides and sheets are within-route states).

---

## 6. Design System Implementation Plan

The mapping from `docs/design-system.md` into Flutter.

### 6.1 Tokens → static constants

All tokens become `static const` (or `static final` for things `Color` cannot express statically) in their respective theme files. No inline `Color(0x…)`, no inline magic numbers; lint rules forbid them.

```
lib/theme/colors.dart     →  class AppColors { static const bgApp = Color(0xFFFBF8F2); ... }
lib/theme/spacing.dart    →  class AppSpacing { static const s4 = 16.0; ... }
lib/theme/radius.dart     →  class AppRadius { static const md = BorderRadius.all(Radius.circular(14)); }
lib/theme/elevations.dart →  class AppElevation { static const elev1 = <BoxShadow>[...]; }
lib/theme/motion.dart     →  class AppMotion { static const medium = Duration(milliseconds: 250); }
```

### 6.2 Typography → TextTheme + named TextStyles

`lib/theme/typography.dart` defines a single `AppTextStyles` class with one `static TextStyle` per `type.*` token from §3.2 of the design system, all built from `google_fonts` families. We do **not** rely on the default `TextTheme` mapping — `headlineLarge`/`bodyMedium` slots in Material do not match our naming. Instead, the `TextTheme` is filled with our styles to keep Material widgets sensible, and feature code uses `AppTextStyles.displayXl` etc. directly.

### 6.3 Theme assembly

`lib/theme/theme.dart::buildLightTheme()` returns one `ThemeData`:

- `useMaterial3: true`
- `colorScheme`: built from `ColorScheme.fromSeed(seedColor: AppColors.accentClay)` with explicit overrides for surface/background/onSurface to our token values.
- `scaffoldBackgroundColor: AppColors.bgApp`
- `textTheme`: our `AppTextStyles` mapped into the closest Material slots so default widgets still look right.
- `inputDecorationTheme`, `elevatedButtonTheme`, `outlinedButtonTheme`, `textButtonTheme`, `bottomSheetTheme`, `appBarTheme`, `dividerTheme`: each themed to our spec.
- `extensions: [RectifyTokens(...)]`: the custom extension carrying confidence colors, demo pill colors, hero result card colors, and motion tokens that have no native Material slot.

### 6.4 Theme extension

```dart
class RectifyTokens extends ThemeExtension<RectifyTokens> {
  final Color confidenceStrong, confidenceModerate, confidenceWeak, confidenceNone;
  final Color heroSurface, heroOnSurface;
  final Duration revealDuration;
  // copyWith, lerp, ==, hashCode
}
```

Accessed via an extension method:

```dart
extension RectifyThemeX on BuildContext {
  RectifyTokens get tokens => Theme.of(this).extension<RectifyTokens>()!;
}
```

So features call `context.tokens.confidenceStrong` rather than threading the extension manually.

### 6.5 Component build order

Build components in the order the screens consume them (see §14 build phases). Each component:

1. Is implemented as a `StatelessWidget` unless internal animation requires `StatefulWidget`.
2. Takes an explicit `key` parameter when used in tests.
3. Reads only from `Theme.of` and `context.tokens` — no direct token imports inside widgets.
4. Has a corresponding widget test in `test/widget/`.
5. Hero / decorative components (`HeroResultCard`, `ConfidenceBar`, `MatchStrengthDots`, `BreathRingLoader`, `EvidenceCard`, `EventCard`, `HistoryCard`) additionally get a golden test in `test/golden/`.

### 6.6 Icons

Single source: **Lucide** via `lucide_icons_flutter` (or equivalent maintained Lucide package). All icon usages go through `lib/theme/icons.dart::AppIcons`:

```dart
class AppIcons {
  static const heart = LucideIcons.heart;
  static const briefcase = LucideIcons.briefcase;
  // …
  static const categoryIconFor = <EventCategory, IconData>{ … };
}
```

This isolates the package choice to one file so a future swap to Phosphor is trivial.

### 6.7 Fonts via google_fonts

`google_fonts` resolves Inter, Source Serif 4, and JetBrains Mono. On first run the package downloads and caches them. To avoid network reliance at first launch, bundle the .ttf files in `assets/fonts/` and configure `google_fonts` to use the bundled copies via its preload pattern. This is a `pubspec.yaml` decision documented here, not coded yet.

### 6.8 Spacing helpers

A few extension methods keep call sites tidy:

```dart
extension GapX on num {
  SizedBox get gapV => SizedBox(height: toDouble());
  SizedBox get gapH => SizedBox(width: toDouble());
}
// usage: 24.gapV, AppSpacing.s6.gapV
```

### 6.9 Quality gate per screen

`docs/design-system.md` §15 is the screen-completion checklist. Re-run it for every screen during phase 4–8. Items become CI-checkable later (lint rule for inline `Color`, lint rule for inline `TextStyle`).

---

## 7. Data Models

All models live in `lib/data/models/`. Every model uses `freezed` with `json_serializable` where it crosses an API/storage boundary. Models are **immutable**; mutations go through `copyWith`.

### 7.1 Domain models

`BirthData`
```
birthDate        : DateTime           // local date only, midnight UTC
birthCity        : String             // human label, e.g. "Kyiv, Ukraine"
birthLatitude    : double
birthLongitude   : double
label            : String?            // optional user-provided
```

`TimeWindow`
```
mode             : TimeWindowMode     // approximate | unknown
approximateTime  : TimeOfDay?         // only when mode == approximate
windowMinutes    : int?               // 30, 60, 120, 180, 360 — only when mode == approximate
// Derived: start, end (24h day if unknown; t-window..t+window otherwise)
```

`EventCategory` (enum, 12 values matching PRD §F4.2)
```
marriage, divorce, careerChange, jobLoss, relocation, childBirth,
familyDeath, illness, accident, education, financial, other
```

`LifeEvent`
```
id               : String             // uuid, local
category         : EventCategory
year             : int                // required, 1900..currentYear
month            : int?               // optional, 1..12
description      : String?            // optional, ≤ 200 chars
sortOrder        : int
```

`CalculationRequest` (envelope built before submission)
```
id               : String             // local uuid, used as draft and final id
isDemo           : bool
birthData        : BirthData
timeWindow       : TimeWindow
events           : List<LifeEvent>
createdAt        : DateTime
```

`CandidateTime`
```
rank             : int                // 1 = top
time             : TimeOfDay          // local time of birth city
confidence       : double             // 0.0–1.0
ascendant        : String?            // "Gemini", etc., may be null
```

`EvidenceItem`
```
eventId          : String             // FK to LifeEvent.id
matchStrength    : MatchStrength      // strong | moderate | weak | none
explanation      : String             // human-readable, from API
```

`MatchStrength` enum: `strong | moderate | weak | none`.

`CalculationResult`
```
requestId        : String             // == CalculationRequest.id
apiCalculationId : String?            // from API response, null in demo
candidates       : List<CandidateTime>     // up to 3
evidence         : List<EvidenceItem>      // one per submitted event
method           : String?            // "western_transit", etc.
isDemo           : bool
completedAt      : DateTime
rawResponseJson  : String?            // verbatim API JSON, for support
```

`SavedCalculation` (history aggregate)
```
request          : CalculationRequest
result           : CalculationResult
```

`SettingsModel`
```
demoModeDefault   : bool
timeFormat        : TimeFormat        // h12 | h24
onboardingDone    : bool
proApiKeyConfigured : bool            // does NOT contain the key itself
```

The API key is **never** in `SettingsModel`. It lives only in `flutter_secure_storage` (see §9.5).

`GeoPlace`
```
displayName      : String             // "Kyiv, Ukraine"
country          : String             // "UA" (ISO)
latitude         : double
longitude        : double
region           : String?            // optional state/region
```

### 7.2 DTOs (API)

`RectificationRequestDto`, `RectificationResponseDto`, and the nested `RectificationCandidateDto` / `RectificationEventMatchDto` live in `lib/data/api/dto/`. The shapes mirror the assumed schema in PRD §11. They are converted to/from domain models in `mappers.dart`.

Why DTOs at all: the assumed API schema is unconfirmed. When the real provider's schema differs, only the mappers need to change — domain models stay stable.

### 7.3 Drift tables (storage shape)

`lib/data/db/tables.dart` defines:

- `Calculations` (mirrors `CalculationRequest` + status enum + optional `api_calc_id`)
- `LifeEvents` (FK calculation_id)
- `CandidateResults` (FK calculation_id)
- `Evidence` (FK calculation_id, FK life_event_id)
- `Drafts` (single-row table for the in-progress calculation, optional — could also live in memory)

Each table has `createdAt` / `updatedAt` columns. Soft-delete is not used in MVP — delete is hard delete with cascade.

---

## 8. Local Storage Strategy

### 8.1 Storage technologies

| Concern | Technology | Why |
|---|---|---|
| Calculations, events, candidates, evidence, drafts | **Drift** (SQLite) | Typed queries + DAOs, code generation, stream-based reads for reactive UI, migrations API. |
| Non-secret settings (time format, demo toggle default, onboarding done) | **shared_preferences** | Simple K/V; reaches readiness before Drift on first launch. |
| Pro / Developer API key | **flutter_secure_storage** | Keychain on iOS, EncryptedSharedPreferences on Android. Per PRD §13 the API key must never live in Drift or shared_preferences. |
| Crash reports | **Firebase Crashlytics** (or Sentry) | Anonymous; no PII (see §13). |

### 8.2 Drift schema (initial)

```
Calculations(
  id TEXT PRIMARY KEY,
  label TEXT NULL,
  status TEXT NOT NULL,           -- draft|submitted|complete|error
  is_demo INTEGER NOT NULL,
  birth_date TEXT NOT NULL,        -- ISO date
  birth_city TEXT NOT NULL,
  birth_lat REAL NOT NULL,
  birth_lon REAL NOT NULL,
  time_window_mode TEXT NOT NULL,  -- approximate|unknown
  approximate_time TEXT NULL,      -- HH:MM
  window_minutes INTEGER NULL,
  api_calc_id TEXT NULL,
  raw_response TEXT NULL,
  method TEXT NULL,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
)

LifeEvents(
  id TEXT PRIMARY KEY,
  calculation_id TEXT NOT NULL REFERENCES Calculations(id) ON DELETE CASCADE,
  category TEXT NOT NULL,
  year INTEGER NOT NULL,
  month INTEGER NULL,
  description TEXT NULL,
  sort_order INTEGER NOT NULL
)

CandidateResults(
  id TEXT PRIMARY KEY,
  calculation_id TEXT NOT NULL REFERENCES Calculations(id) ON DELETE CASCADE,
  rank INTEGER NOT NULL,
  birth_time TEXT NOT NULL,   -- HH:MM
  confidence REAL NOT NULL,
  ascendant TEXT NULL
)

Evidence(
  id TEXT PRIMARY KEY,
  calculation_id TEXT NOT NULL REFERENCES Calculations(id) ON DELETE CASCADE,
  life_event_id TEXT NOT NULL REFERENCES LifeEvents(id) ON DELETE CASCADE,
  match_strength TEXT NOT NULL,  -- strong|moderate|weak|none
  explanation TEXT NOT NULL
)
```

Indexes: `LifeEvents(calculation_id, sort_order)`, `CandidateResults(calculation_id, rank)`, `Evidence(calculation_id)`.

### 8.3 Drafts and retry

Two acceptable approaches; pick during phase 4:

- **In-memory only.** Drafts live in `currentDraftProvider`; lost on app kill. Simplest.
- **Persisted.** A `Drafts` table (single row, calculation_id == active draft) survives kills and enables the "Save and retry later" error path (per `docs/mvp-scope.md` §S3 should-have).

Recommendation: implement in-memory in MVP-must-have phase, then persisted drafts in the should-have phase 7. The error-screen "Save and retry later" button needs persisted drafts; if S3 slips, the button is hidden, not removed.

### 8.4 History reads

History is read via a Drift `Stream<List<SavedCalculation>>` exposed as a `StreamProvider`. The Home screen subscribes once. Swipe-delete issues a `DELETE` (cascade does the rest), the stream emits the new list, the UI animates the row out.

### 8.5 Delete-all

`SettingsRepository.deleteAllData()` does:

1. Drop and recreate the SQLite database file (or `DELETE FROM` on every table in a transaction).
2. Clear `shared_preferences`.
3. Clear `flutter_secure_storage`.
4. Reset Riverpod providers via `ref.invalidate(...)`.
5. Navigate to `/onboarding` (the onboarding flag is now back to false).

### 8.6 Migrations

MVP ships schema v1. The migration framework (`Drift`'s `MigrationStrategy`) is wired from day one so v2 in V1.5 is a code change, not an architecture change.

---

## 9. API Integration

### 9.1 Endpoint contract (assumed)

From PRD §11, `POST {baseUrl}/v1/rectification`. Request and response shapes per the PRD JSON examples. Treat these as **assumed** until the provider confirms; the DTO + mapper layer is the place future schema changes land.

### 9.2 HTTP client: Dio

`lib/data/api/api_client.dart::buildDio({required String baseUrl, required AuthMode authMode, String? bearerToken})` returns a configured `Dio`:

- `baseUrl`
- `connectTimeout: 30s`
- `receiveTimeout: 30s`
- `sendTimeout: 30s`
- `headers`: `{ 'Content-Type': 'application/json', 'Accept': 'application/json' }`
- Interceptors:
  - `AuthInterceptor` — adds `Authorization: Bearer <token>` if a token is configured.
  - `LoggingInterceptor` — debug builds only; **never logs request body** (PII) or response body in release. Logs only URL, status, latency.
  - `ErrorMappingInterceptor` — converts `DioException` into our typed `AppFailure` hierarchy.

### 9.3 RectificationApi

`lib/data/api/rectification_api.dart`:

```
abstract class RectificationApi {
  Future<Result<RectificationResponseDto, AppFailure>>
      rectify(RectificationRequestDto request);
}

class HttpRectificationApi implements RectificationApi {
  HttpRectificationApi(this._dio);
  final Dio _dio;
  // POST /v1/rectification, parse JSON, return Result.ok or Result.err
}
```

### 9.4 RectificationRepository

`lib/data/repos/rectification_repository.dart`:

```
abstract class RectificationRepository {
  Future<Result<CalculationResult, AppFailure>>
      submit(CalculationRequest req);
}
```

Implementation `LiveRectificationRepository`:

1. If `req.isDemo`, return the hardcoded `demoResponse()` after a 3-second `await Future.delayed(...)`. **No HTTP call.**
2. Else build a `RectificationRequestDto` from the domain `CalculationRequest`, call `RectificationApi.rectify(...)`.
3. Map DTO → `CalculationResult` via `mappers.dart`.
4. Save the result + raw response JSON to Drift via `HistoryRepository`.
5. Return `Result.ok(calculationResult)`.

### 9.5 Auth modes and key handling

Three modes match PRD §11:

```
enum AuthMode { demo, proxy, providerDirect }
```

- `demo` — chosen when the `CalculationRequest.isDemo` flag is true (regardless of settings).
- `providerDirect` — chosen **only** when an end-user has personally entered their own Pro/Developer API key in the in-app Settings sheet. That key lives only in `flutter_secure_storage` (Keychain on iOS, Keystore-backed EncryptedSharedPreferences on Android) and is used as the Bearer token against the provider's URL. This mode exists so a Pro user can spend their *own* provider quota; the app itself never ships with a provider key.
- `proxy` — default for everyone else. Dio is built with the proxy base URL and a **public app identifier** (delivered via `--dart-define` at build time — see Appendix B). This identifier is *not* a confidential secret. It is a build-time string that exists only to label traffic from the official Rectify app for soft routing and rate-limit accounting on the proxy. Any string compiled into a mobile binary is trivially recoverable from the released IPA / APK with off-the-shelf tools, so the backend must never treat this value as proof of caller identity (see §9.7).

A `dioProvider` reads `settingsRepositoryProvider` + `secureKeyStoreProvider` and rebuilds the Dio instance reactively when the user adds or removes their own key in Settings.

**Hard rules** (enforced in code review, ideally in a lint):

- The production rectification provider's shared API key is **never** in the app. Not in Dart source, not in assets or asset bundles, not in `--dart-define`, not in any `.env` file compiled into the binary, not in `firebase_options.dart`, not in any string-typed constant or generated constant, not in logs, not in crash reports, not in analytics events, not in error messages shown to the user. The mobile app has no code path that can read, derive, or transmit that key. The production proxy holds it server-side (see §9.7).
- The only "credential-shaped" string allowed inside the mobile binary is the public proxy app identifier from `RECTIFY_PROXY_APP_ID` (and, if Mapbox is the chosen geocoder, a public restricted `pk.…` Mapbox token — see §9.8). Both are treated as **public**: recoverable by anyone with the binary, useful to the backend / provider only because of server-side restrictions (URL allow-list, bundle id, server-side rate-limiting), never as authentication on their own.
- `flutter_secure_storage` is the only storage location for an **end-user-supplied** Pro/Developer key — and only that key, only because the *user* chose to add their *own* provider credential. SQLite, `shared_preferences`, file system, in-memory globals beyond the lifetime of the request, logs, crash reports, analytics, and screenshots are all forbidden. The key is also never echoed back into the UI in plaintext after save, never copied into any DTO, and never included in any `rawResponseJson` blob written to history.
- Demo mode performs zero network requests, including no analytics ping, no telemetry, no font fetch, no crash-reporter handshake when demo is the entry point on a cold boot. Easiest verification: airplane mode + run demo → succeeds.

### 9.6 Timeout, retry, error handling

- **Timeout:** 30 s as configured on Dio. On timeout, the `ErrorMappingInterceptor` converts to `AppFailure.timeout`. UI navigates to the timeout error screen.
- **Retry:** No automatic retries. Retry is a user action via the error screen. (Automatic retries would mask provider quota issues and could double-charge on a future paid plan.)
- **Cancellation:** The loading screen Cancel button calls a `CancelToken` attached to the in-flight request. The controller transitions back to the previous screen.
- **HTTP status mapping:**

| Status | AppFailure | UX |
|---|---|---|
| 200 | (success) | Result screen |
| 400 | `AppFailure.badRequest(message)` | Error screen with "Review your birth data" |
| 401 / 403 | `AppFailure.unauthorized` | Error screen with "Check Settings or try demo" |
| 408 / timeout | `AppFailure.timeout` | Timeout error screen with retry + save-for-later |
| 429 | `AppFailure.rateLimited` | Generic error with "Please wait a moment" |
| 5xx | `AppFailure.serverError` | Generic error with retry |
| No network | `AppFailure.noNetwork` | No-internet screen |
| Malformed JSON | `AppFailure.malformedResponse` | Generic error |

### 9.7 Proxy assumption

The production proxy is a small serverless function (Cloud Run / Cloudflare Workers / Vercel) that:

- Accepts the same JSON payload the mobile app sends.
- Holds the real provider API key **only** in a server-side secret store (e.g. Google Cloud Secret Manager, Cloudflare Workers secret binding, Vercel encrypted env). The provider key never appears in any artifact that an end-user can download from the App Store or Play Store, never in a client log, never in a client-visible response body, never echoed back to the app.
- Forwards to the provider's `/v1/rectification` server-to-server.
- Returns the provider response verbatim, but with provider credentials stripped if the provider ever surfaces them in error bodies.
- Logs only request id, response status, and latency. **Never logs the request body** (birth data, life events, optional notes), **never logs the provider key**, **never logs the `RECTIFY_PROXY_APP_ID` value**, **never logs an end-user-supplied Pro key**, and redacts any header that could carry an authorization value.
- Performs all authentication, authorization, rate-limiting, and abuse detection **server-side**, using state the backend controls — per-IP and per-installation throttling, request-shape validation, and an integrity attestation layer where appropriate (Play Integrity API on Android, DeviceCheck / App Attest on iOS, or Firebase App Check as a wrapper). The `RECTIFY_PROXY_APP_ID` value compiled into the mobile binary is treated as a **public app identifier**, not a secret; the backend MUST NOT use it as the sole basis for authenticating callers or for granting any privileged behavior, because any value bundled into a mobile binary is trivially recoverable by an attacker with the IPA/APK.

This proxy is **out of MVP Flutter scope**, but the rules above are not optional — they define the security boundary the Flutter app is being designed against. The only proxy-related values configurable in the Flutter build are the proxy base URL and the public app identifier, both via `--dart-define` (Appendix B); no proxy "secret" of any kind is bundled, and the app contains no code path that would let one be bundled later by accident.

### 9.8 Geocoding service

City → lat/lon resolution must happen before submitting the rectification request (PRD §IR5). Options:

- **Google Places API** — best UX, but the keys it issues act as confidential billing credentials. An embedded Google key in a mobile binary is a billing-fraud risk regardless of URL restrictions and is **not acceptable** to ship inside the app. If we ever adopt Google Places, geocoding **must** be routed through the Rectify proxy and the Google key held in the same server-side secret store as the rectification key.
- **Nominatim (OSM)** — free, no key required, but has hard rate limits and a usage policy that disallows heavy commercial use; would require server-side caching and attribution, so realistically still implies a proxy.
- **Mapbox Geocoding** — solid free tier. Mapbox issues two token classes: **public** `pk.…` tokens that can be restricted by URL allow-list and bundle id (intended for client embedding), and **secret** `sk.…` tokens that are billing credentials. Only the public `pk.…` class is acceptable for embedding.

**Recommendation:** Mapbox for the MVP, using a **public, URL- and bundle-id-restricted `pk.…` token only**. We treat that token the same way we treat `RECTIFY_PROXY_APP_ID`: a public app identifier, recoverable from the binary, useful in practice because Mapbox enforces the URL / bundle-id allow-list server-side and we can rotate the token if it is abused. A Mapbox `sk.…` secret token is **never** embedded, never passed through `--dart-define`, and never stored in `flutter_secure_storage` either — it has no place in the mobile app at all. If, for any reason, the chosen geocoding provider does not offer a restrictable public client token (i.e., it only issues confidential keys), geocoding MUST be routed through the Rectify proxy instead, with the geocoding credential held in the same server-side secret store as the rectification key. The implementation lives behind a `GeocodingService` interface in `lib/data/geocoding/` so this swap is a one-file change. Final provider decision: §14 phase 4 — but the rule **"no private geocoding secret in the mobile binary"** is non-negotiable regardless of which provider is chosen.

---

## 10. Demo Mode

### 10.1 Goal

Demo mode must exercise every screen of the real flow with no network, no key, no payment, in a way that is visually identical except for the **DEMO** pill and the bottom upgrade nudge.

### 10.2 Implementation pattern

A single boolean (`isDemo`) lives on the `CalculationRequest`. It is set by the entry point:

- Onboarding slide 3 "Try demo first" sets `isDemo = true` on the new draft.
- Onboarding slide 3 "Start real calculation" sets `isDemo = false`.
- Home → "New Calculation" honours the Settings "Demo mode" toggle (default value of the new draft).

The `CalculationFlowController` stores the draft. Every screen reads `isDemo` from the draft to decide whether to show the DEMO pill and label the **Calculate** button.

When the user submits, the controller calls `RectificationRepository.submit(req)`. The repository's first line is:

```
if (req.isDemo) {
  await Future.delayed(const Duration(seconds: 3));
  return Result.ok(buildDemoResult(req));
}
```

`buildDemoResult` reads from `lib/data/demo/demo_response.dart`, which contains the spec from `docs/mvp-scope.md` §DM2:

- 3 candidate times: 07:14 / 78%, 07:42 / 61%, 08:03 / 44%.
- Top candidate ascendant: "Gemini Rising".
- 6 mock events with strengths: 2 strong, 2 moderate, 1 weak, 1 no match.
- Realistic explanation text per event.

If the user submitted fewer than 6 events, the demo response is **trimmed** down to the user's actual event count (we don't fabricate events the user didn't enter). If they submitted more than 6, the extra events are tagged "weak" or "no match" with stock explanations so every submitted event has corresponding evidence.

### 10.3 Demo result persistence

Demo results are saved to history exactly like real ones, with `is_demo = true` on the calculation row. The Home screen renders a DEMO pill on those cards (per `docs/ascii-wireframes.md` Screen 8 — populated).

### 10.4 No-network demo guarantee

The demo path must not touch the network for any reason — no Crashlytics ping at boot is required pre-demo, no font fetch at first paint. To guarantee this:

- Demo path completes only after `await Future.delayed(3s)` — no HTTP client is constructed for that request.
- Fonts are bundled (see §6.7) so `google_fonts` can resolve from local files without a fetch.
- The integration test `demo_flow_test.dart` runs with the network disabled (via an HTTP overrides that fails all requests) and must still complete the full flow.

### 10.5 Demo mode toggle in Settings

The Settings "Demo mode" toggle controls only the **default** for new drafts. The flow always honours the per-draft `isDemo` value chosen on the entry CTA. Users can still pick "Start real" from a draft started in demo mode — the controller flips the draft's flag at the moment the user picks the action.

### 10.6 Demo upgrade nudge

After viewing a demo result, the result screen shows a soft section (per design-system §10.2): "This was a demo — run a real calculation with your data." This is not a paywall, not a price gate, not blocking. Tapping it starts a fresh draft with `isDemo = false`. The nudge is dismissed per-result-view; it does not nag.

---

## 11. Error Handling and Empty States

### 11.1 Failure type

```dart
sealed class AppFailure {
  const AppFailure();
}
class NoNetworkFailure   extends AppFailure { … }
class TimeoutFailure     extends AppFailure { … }
class BadRequestFailure  extends AppFailure { final String message; … }
class UnauthorizedFailure extends AppFailure { … }
class RateLimitedFailure extends AppFailure { … }
class ServerFailure      extends AppFailure { final int status; … }
class MalformedResponseFailure extends AppFailure { … }
class GeocodingFailure   extends AppFailure { final String query; … }
class StorageFailure     extends AppFailure { final Object cause; … }
class UnknownFailure     extends AppFailure { final Object cause; … }
```

UI maps each variant to the right error surface per PRD §14 and `docs/ascii-wireframes.md` Error Screens. The mapping is centralised in a single function `failureToErrorSpec(AppFailure) → ErrorSpec` so screens stay dumb.

### 11.2 Result wrapper

```dart
sealed class Result<T, F extends Object> {
  const Result();
  factory Result.ok(T value)  = Ok<T, F>;
  factory Result.err(F failure) = Err<T, F>;
}
```

Repositories return `Result<T, AppFailure>` rather than throwing across layer boundaries. Controllers convert `Err` into `AsyncValue.error(...)` so widgets just `.when(...)` over `AsyncValue`.

### 11.3 Error screen catalog

Per `docs/ascii-wireframes.md`:

1. **Timeout / 5xx** — full-screen modal pattern from design-system §9.13: warning glyph, title, body ("Your inputs have been saved"), two stacked buttons ("Try again", "Save and retry later").
2. **City not found** — inline below the city field; not a full-screen.
3. **No internet** — full-screen, single "Try again" + footnote "You can still view past calculations in History."
4. **Bad request (400)** — full-screen with "Review your birth data" → pops to `/calc/birth`.
5. **Unauthorized (401/403)** — full-screen with "Go to Settings" → `/settings`.

All error screens reuse a single `ErrorScaffold` widget that takes an `ErrorSpec` (title, body, glyph, primary CTA, secondary CTA).

### 11.4 Empty states

Per design-system §9.14 (Empty state component):

| Screen | Empty condition | Glyph | Heading | Body | CTA |
|---|---|---|---|---|---|
| Home / History | No calculations | clock-3 | "No calculations yet." | "Run your first one to see results here." | "New Calculation" |
| Life Events | No events added | sparkles? bookmark? | (inline copy, not a full empty state) | "Add at least 5 events for a real calculation. 3 for a demo." | "+ Add first event" |
| History deep-link not found | Calculation deleted while open | bookmark-x | "Calculation not found." | "It may have been deleted." | "Back to History" |

### 11.5 No dead ends

Every error and empty state must have a clear, forward CTA. No back-only screens. The integration smoke test asserts every error route reaches a forward CTA within one tap.

---

## 12. Accessibility and Responsive Behaviour

### 12.1 Targets

- **iOS:** 15.0 and up. iPhone SE (1st gen — 320×568) as the smallest target. iPhone 15 Pro Max as the largest.
- **Android:** API 29 (Android 10) and up. Pixel 4a (393×851 logical) as the floor; small Android handsets at 360×640 must still render the full flow without overflow.

### 12.2 Responsive rules

- One-column layout everywhere; no `LayoutBuilder` branching for tablet (out of scope).
- Side gutter is always 24pt regardless of width.
- The hero result card scales the time numeral via `MediaQuery.textScaler.scale(56)` so it grows with dynamic type but caps at 1.5× of the design size to avoid layout breakage at 200% accessibility scaling.
- `Scaffold` uses `resizeToAvoidBottomInset: true` on every input screen; the bottom button group floats above the safe area inset.
- Lists are always `Scrollable`; nothing relies on no-scroll layout.

### 12.3 Dynamic type

- Inter scales linearly up to 1.3× system text size, then degrades gracefully (lines wrap, no truncation in form labels).
- Serif (Source Serif 4) scales the same.
- Tabular figures (`FontFeature.tabularFigures()`) on times and percentages to prevent visual jitter when digits change.

### 12.4 Semantics

- Every icon-only button has a `Semantics(label: …)`.
- The result time announces as `"7 14 AM, 78 percent confidence"` (per design-system §12).
- Match strength dots announce as `"strong match"`, `"moderate match"`, etc. — the visual dots are decorative (`excludeSemantics: true`).
- Form fields have proper `TextField` labels (not just visual labels) so screen readers announce them.

### 12.5 Color contrast

- All text/background pairs are pre-vetted in `docs/design-system.md` §2 and §12. We verify with `flutter_test_screenshot` + a contrast assertion during golden tests for hero components.

### 12.6 Reduced motion

- A single helper `bool reduceMotionOf(BuildContext)` reads `MediaQuery.disableAnimations`. Hero reveal animations replace the 600ms fade + 8pt translate with an instant set when this is true.

### 12.7 Platform-specific UI

- **Date/time pickers:** native (`showCupertinoModalPopup` with `CupertinoDatePicker` on iOS; `showDatePicker` / `showTimePicker` on Android) via a single `AppPickers` facade.
- **Bottom sheets:** `showModalBottomSheet` with our `BottomSheetPicker` content; design-system §9.12 says iOS-style drag handle on both platforms, so we don't branch.
- **Back gesture:** iOS swipe-back works out of the box via go_router; Android system back is wired by go_router.
- **Haptics:** light tap on primary CTA press, success haptic on save-to-history. No haptics elsewhere.

### 12.8 Performance budget

- 60fps target on iPhone 11 and Pixel 5 (per design-system §14.5).
- No animated illustrations, no Lottie.
- The breath-ring loader is custom-painted in `BreathRingLoader` — trivial.
- All list views use `ListView.separated` with item extents where possible.

---

## 13. Testing Strategy

### 13.1 Pyramid shape

```
            integration smoke   (1–2)
           ┌──────────────────────┐
            widget + golden     (~30)
           ┌──────────────────────┐
                  unit         (~80–120)
           ┌──────────────────────┐
```

We aim for a wide unit base (cheap, fast), a moderate widget layer focused on components and screens, golden tests on visual hero pieces, and one or two integration tests that exercise critical flows end-to-end.

### 13.2 Unit tests (`test/unit/`)

Cover:

- All `mappers.dart` DTO↔domain conversions (round-trip with sample JSON fixtures).
- `RectificationRepository`'s demo branch (`isDemo == true` returns the mock without touching `RectificationApi`).
- `failureToErrorSpec` returns the right `ErrorSpec` for each `AppFailure` variant.
- `TimeWindow.start / end` derivation for each window-minutes value and the "unknown" mode.
- `LifeEvent` sort order maintenance when events are added/deleted/reordered.
- Settings repository: get/set demo mode, time format, API-key-present flag.
- Date and time formatters honour 12h/24h preference.

Fakes:
- `FakeRectificationApi` returns canned `RectificationResponseDto` or a chosen failure.
- `FakeGeocodingService` returns canned places.
- `FakeSecureKeyStore` in-memory map.
- `FakeDatabase` via Drift's in-memory `NativeDatabase.memory()`.

### 13.3 Widget tests (`test/widget/`)

One test file per non-trivial widget. Focus on:

- Renders all visual states (default, pressed, disabled, error).
- Respects passed-in theme tokens (asserts color comes from `RectifyTokens`, not hard-coded).
- Semantics labels exist on icon-only buttons.
- Tap callbacks fire.

Screens get integration-style widget tests that pump the screen with a `ProviderScope(overrides: [...])` and verify the rendered output for each meaningful state (e.g., Life Events: empty / 1 event / 5 events / 20 events / over-limit).

### 13.4 Golden tests (`test/golden/`)

`flutter_test` golden infrastructure (or `alchemist` for cleaner per-platform handling). One golden per:

- `HeroResultCard` — high confidence, low confidence, demo badge.
- `ConfidenceBar` — 100%, 78%, 30%.
- `MatchStrengthDots` — each of 4 strengths.
- `EventCard` — each of 12 categories.
- `HistoryCard` — real and demo.
- `EvidenceCard` — collapsed + expanded.
- `BreathRingLoader` — paused frame.

Goldens are stored at `test/golden/goldens/<name>.png`. CI runs `flutter test --update-goldens` only on a labelled PR; otherwise it asserts against committed goldens.

### 13.5 Integration smoke tests (`integration_test/`)

One must-have:

- `demo_flow_test.dart`: launch the app, skip onboarding, choose demo mode in Settings, run the full flow (birth data → time window → life events with 3 mock entries → calculate → result → evidence → back to history → see saved demo). Asserts: every screen renders, every navigation works, the saved demo is visible in history.

One should-have (deferred if time-constrained):

- `error_flow_test.dart`: trigger each error screen via a faked failing repo, assert each has a working CTA.

### 13.6 Static analysis

- `analysis_options.yaml` extends `very_good_analysis` (strict ruleset).
- Custom lint rule (or a `dart_code_metrics` check) forbids inline `Color(0x…)` and inline `TextStyle(...)` literals in `lib/widgets/**` and `lib/features/**`.

### 13.7 CI strategy (recommended, not committed in MVP)

- On every push: `flutter analyze` + `flutter test --coverage` + golden assertion.
- On main: build iOS and Android release APK/IPA to verify the toolchain works.

---

## 14. Build Phases

Each phase ends with a working artifact you can run on a simulator. No phase introduces dead code awaiting later phases. Tests land **with** the code they cover.

### Phase 0 — Scaffold (½–1 day)

**Goal:** A green `flutter run` on iOS and Android with our theme applied to an empty home screen.

Deliverables:
- `flutter create --org com.rectify --project-name rectify .` then move project into the existing directory respecting current docs.
- Pin Flutter SDK channel (`stable`, ≥3.27).
- Add `pubspec.yaml` dependencies (read-only list — exact versions chosen at pub-add time):
  - `flutter_riverpod`, `riverpod_annotation`, `riverpod_generator`, `build_runner`
  - `go_router`
  - `freezed_annotation`, `freezed`, `json_annotation`, `json_serializable`
  - `drift`, `drift_flutter`, `sqlite3_flutter_libs`, `drift_dev`, `path_provider`
  - `dio`, `pretty_dio_logger`
  - `flutter_secure_storage`
  - `shared_preferences`
  - `google_fonts`
  - `lucide_icons_flutter` (or chosen Lucide package)
  - `flutter_svg`
  - `intl`
  - `uuid`
  - dev: `very_good_analysis`, `mocktail` (or `mockito`), `alchemist`, `integration_test`
- `analysis_options.yaml` with strict ruleset.
- Empty folder structure per §3.
- `lib/main.dart` runs `runApp(ProviderScope(child: RectifyApp()))`.
- `lib/app/app.dart` renders `MaterialApp.router` with a single placeholder home route.
- `lib/theme/{colors,typography,spacing,radius,elevations,motion,theme}.dart` populated from `docs/design-system.md`.
- `lib/theme/rectify_tokens.dart` defined and registered in the theme.

Definition of done:
- `flutter run` on iOS Simulator shows a warm-bone background with one styled "Hello" title using Source Serif 4 in the clay accent color.
- `flutter analyze` is clean.

### Phase 1 — Design system widgets + goldens (3–4 days)

**Goal:** Every reusable widget in `lib/widgets/` exists with a widget test and (where applicable) a golden.

Order of build (each item is a widget + test + golden if visual hero):

1. `PrimaryButton`, `SecondaryButton`, `GhostButton`, `DestructiveButton`
2. `InputField`, `DatePickerField`, `TimePickerField`
3. `RadioGroup`, `LabeledToggle`
4. `ChipPill`, `DemoPill`
5. `AppCard`, `EventCard`, `CandidateCard`, `HistoryCard`, `EvidenceCard`
6. `ConfidenceBar`, `MatchStrengthDots`
7. `HeroResultCard`
8. `BreathRingLoader`, `PulseDotLoader`
9. `EmptyState`
10. `StepperHeader`, `TopNav`, `BottomTabBar`
11. `BottomSheetPicker`
12. `ErrorScaffold`

Definition of done:
- Every widget has a widget test asserting it renders and is keyboard- and semantics-accessible.
- Hero components have committed goldens.
- A `/widget_gallery` debug-only screen renders one of each widget — useful for visual review and future contractor onboarding (gated behind `kDebugMode`, not shipped).

### Phase 2 — Data layer (2–3 days)

**Goal:** Drift DB opens, migrations run, all DAOs work, all freezed models build, mappers round-trip a fixture.

Deliverables:
- `lib/data/models/*.dart` — all freezed models with json (where needed).
- `lib/data/db/database.dart`, `tables.dart`, all DAOs, migrations.
- `lib/data/api/dto/*.dart` + mappers.
- `lib/data/api/api_client.dart` builder.
- `lib/data/api/rectification_api.dart` interface + `HttpRectificationApi`.
- `lib/data/repos/{rectification,history,settings,draft}_repository.dart` — contracts and implementations.
- `lib/data/secure/secure_key_store.dart`, `lib/data/prefs/settings_store.dart`.
- `lib/data/demo/demo_response.dart` — the canonical mock per §10.
- `lib/providers/{core,repo}_providers.dart`.

Definition of done:
- Unit tests for mappers, repos (with fakes), settings store, demo response.
- `RectificationRepository.submit(req with isDemo=true)` returns a `CalculationResult` matching `docs/mvp-scope.md` §DM2.
- A throwaway script (or test) writes a `Calculation` row, reads it back, deletes it.

### Phase 3 — Onboarding + Home / History (read paths) (2 days)

**Goal:** First-launch UX. Onboarding works. Home/History reads from Drift (empty state initially).

Deliverables:
- Routes `/onboarding` and `/`.
- `OnboardingScreen` with 3 slides.
- `OnboardingController` sets `onboardingDone` on completion or skip.
- `GoRouter.redirect` enforces onboarding gate.
- `HomeHistoryScreen` empty state + populated list (uses `StreamProvider<List<SavedCalculation>>`).
- Swipe-to-delete with confirmation snackbar; cascade delete via Drift.
- Bottom tab bar wired.

Definition of done:
- Widget tests for both empty and populated history.
- Manual run: tapping "Try demo first" navigates somewhere placeholder (calc flow not built yet → temp screen).

### Phase 4 — Calculation input flow (3–4 days)

**Goal:** A user can walk all input screens, build a draft, and reach the loading screen (which will short-circuit until phase 5).

Deliverables:
- Routes `/calc/{birth,window,events,confirm,loading}`.
- `CalculationFlowController` (AsyncNotifier or Notifier holding `CalculationRequest` draft).
- `BirthDataScreen` with date picker, city search field (`GeocodingService` integrated).
- `TimeWindowScreen` with both modes and the derived range copy.
- `LifeEventsScreen` with add/delete/reorder.
- `AddEventSheet` and `CategoryPickerSheet`.
- `ConfirmationScreen` (review before calculation).
- `LoadingScreen` with `BreathRingLoader` and rotating copy.
- Validation: continue buttons disable until requirements met.
- Soft warning on Life Events when 3 ≤ count < 5.

Definition of done:
- Widget tests for each screen, asserting the visible states (empty / valid / invalid).
- Manual run: completed walk from "Try demo first" → birth → window → events (3 mock items) → confirm → loading (still spins; no result yet).

### Phase 5 — Demo result + Evidence (2 days)

**Goal:** End-to-end demo flow works. From slide 3 to evidence screen, no network.

Deliverables:
- `CalculationFlowController.submit()` calls `RectificationRepository.submit(req)` and, on `Ok`, navigates to `/calc/result/:resultId`.
- `ResultScreen` renders `HeroResultCard` + `ConfidenceBar` + up to 2 `CandidateCard`s.
- DEMO pill rendered when `result.isDemo`.
- "See how we got this" → Evidence Breakdown.
- "Save to history" persists result via `HistoryRepository`, toggles to "Saved ✓".
- `EvidenceScreen` shows submitted events with strength + explanation.
- Demo upgrade nudge at bottom of result screen, dismissible per view.

Definition of done:
- Manual run: full demo flow from a cold start completes in well under 1 minute and shows realistic mock results.
- Integration test `demo_flow_test.dart` passes with the network disabled.

### Phase 6 — Real API integration + error handling (3 days)

**Goal:** Real-mode flow works against a stub backend (or a fake-server set up locally), and every error path lands on the correct screen.

Deliverables:
- `HttpRectificationApi` wired into `LiveRectificationRepository`.
- `AuthInterceptor`, `ErrorMappingInterceptor`, `LoggingInterceptor`.
- `dioProvider` rebuilds when API key in `SecureKeyStore` changes or proxy URL changes.
- Error routes `/error/{timeout,no-internet,bad-request,unauthorized,server,malformed}`.
- "Save and retry later" persists the draft (this requires the persisted-Drafts table — implement it now or hide the button if S3 slipped).
- A test harness that lets the integration test point Dio at a local fake HTTP server (e.g., `shelf`).

Definition of done:
- Unit tests covering each `DioException → AppFailure` mapping.
- Manual run: pointing the build at a fake server returning each status code surfaces the right error screen.

### Phase 7 — Settings + privacy (1 day)

**Goal:** Settings screen complete; "Delete all data" wipes everything; privacy policy opens.

Deliverables:
- `SettingsScreen` with all rows per design-system §10.7 and wireframe Screen 9.
- `ApiKeySheet` bottom sheet; writes to `SecureKeyStore` on save; never displays the key after save (replaced with "Set" indicator).
- Time format radio writes to `SettingsStore`; consumed by formatters everywhere.
- Demo toggle writes default for new drafts.
- "Delete all data" confirmation → `SettingsRepository.deleteAllData()` (see §8.5) → reroute to `/onboarding`.
- Privacy policy link opens in-app browser (`url_launcher` + `LaunchMode.inAppBrowserView`).

Definition of done:
- Manual run: set Pro API key, kill app, relaunch, key still works (without being readable in any storage browser).
- Unit test: `deleteAllData()` clears DB, prefs, and secure storage and resets onboarding flag.

### Phase 8 — Polish, integration tests, release builds (2 days)

**Goal:** App-store-ready binary for both platforms.

Deliverables:
- All `docs/design-system.md` §15 checklist items audited per screen.
- Reduced-motion behaviour verified manually.
- Dynamic type ×1.3 verified manually on each screen.
- Bundle ID, app name, app icon (placeholder accent-clay clock-quadrant glyph), launch screen.
- Crashlytics integration with anonymous device id; verify no PII in any payload.
- iOS Info.plist privacy strings (location is not used in MVP — keep clean).
- Android `AndroidManifest.xml` permissions (INTERNET only).
- Build `flutter build ipa` and `flutter build appbundle` successfully.

Definition of done:
- Both release binaries open and complete the demo flow.
- No `flutter analyze` warnings.
- All tests green.
- A 10-minute manual playthrough produces no crashes (matches `docs/mvp-scope.md` §AC1 spirit).

---

## 15. Risks, Assumptions, and Open Questions

### 15.1 Top engineering risks

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| Real API schema differs materially from PRD §11 assumptions | High | Medium | All API I/O goes through DTOs + mappers. Domain models are stable; only mappers and DTOs change. |
| Provider rate-limits or pricing block testing | Medium | Medium | Demo mode runs without the provider. Phase 6 uses a local fake server. |
| Geocoding provider free-tier limits hit during dev | Medium | Low | Cache results in-memory per session; debounce 300ms on the city field; allow swap of provider behind `GeocodingService`. |
| `flutter_secure_storage` flaky on Android in some emulators | Low | Medium | Document the bug; integration test asserts on real device, not emulator. |
| Drift codegen + freezed codegen churn slows builds | Medium | Low | Pin versions; use `build_runner watch` during heavy iteration; CI uses warm cache. |
| Time-zone handling for `birth_date` and `approximate_time` ambiguity | High | High | All birth-time inputs are stored as **wall-clock local time of the birth city**, not UTC. Mapper documents this explicitly. No DST conversion in MVP. |
| Confidence bar visualisation looks alarming at low values | Low | Medium | Design-system §2.5 sets confidence colors in same lightness range; review at QA pass. |
| Hero reveal animation feels too long on some devices | Low | Low | 600ms is a deliberate one-time beat; reduced-motion users get an instant set. |

### 15.2 Assumptions we are running on

- **API schema** per PRD §11 is correct enough for MVP development against a fake server. Provider confirmation is pre-implementation, not pre-design or pre-phase-2.
- **Backend proxy** will be built in parallel by another work-stream. The Flutter app accepts any `BASE_URL` via `--dart-define`, so it can be developed against a local stub indefinitely.
- **Geocoding** uses Mapbox (free tier) unless changed in phase 4.
- **Icon family** is Lucide.
- **Crash reporting** is Firebase Crashlytics (Sentry acceptable swap).
- **No analytics SDK in MVP.** If marketing pushes back, we can add a single privacy-respecting product analytics SDK (e.g., PostHog with local-first config) in V1.5.
- **Single locale (en-US) in MVP.** All strings are extracted into `arb` files from day one (via `flutter_localizations` + `intl`) so localization in V1.5 is a translation job, not a refactor.
- **Birth date floor 1920**, ceiling today minus the COPPA age-gate (born before 2008).
- **All times are local to the birth city.** No UTC math, no Olson DB lookup in MVP. If the API requires UTC, the mapper does that conversion; the UI displays local.

### 15.3 Open questions to resolve before each phase

| Question | Answer needed by | Owner |
|---|---|---|
| Production backend proxy base URL + public-app-identifier scheme (Appendix B); server-side auth/rate-limit design per §9.7 | Start of phase 6 | Backend |
| Final geocoding provider | Start of phase 4 | Product + Engineering |
| Lucide vs Phosphor — final pick | Start of phase 1 | Design (recommendation: Lucide) |
| Crashlytics vs Sentry | Start of phase 8 | Engineering |
| App Store bundle ID and final name (Rectify pending clearance, per PRD §2) | Start of phase 8 | Product |
| Mock data realism: should demo result data vary across demo runs, or stay identical? | Start of phase 5 | Product (recommendation: identical — predictability matters in demo) |
| Persisted drafts vs in-memory drafts in MVP | Start of phase 4 | Engineering (recommendation: in-memory in phase 4, persist in phase 6 alongside "Save and retry later") |
| iOS minimum: 15.0 vs 16.0 | Start of phase 0 | Product (recommendation: 15.0) |
| Privacy policy URL (must be reachable before phase 8) | Start of phase 8 | Legal |

### 15.4 Decisions that should not need revisiting

- Riverpod over BLoC, Provider, GetX, MobX.
- go_router over auto_route, beamer.
- Drift over Hive, ObjectBox.
- Dio over `http`.
- `freezed` for models.
- Lucide for icons.
- google_fonts for type, fonts bundled in assets.

If any of these come up for re-litigation in mid-build, treat it as scope risk and defer until V1.5.

---

## 16. Acceptance Criteria for First Runnable Demo

These are the engineering-facing checks for a "demo-ready" build — the build we share internally to validate that MVP is technically achievable, ahead of the full §16 (PRD/Acceptance) gate. This is end-of-Phase 5.

### AC-Demo-1 — Cold start to demo result in under 90 seconds

- [ ] A new install on iPhone 12 (simulator or device) completes: launch → onboarding (3 slides) → "Try demo first" → birth data (with prefilled mock data if from a demo entry, OR a user typing realistic data) → time window → 3 mock life events → calculate → result → evidence → back to history → see saved demo. Under 90 seconds with deliberate but unhurried interaction.

### AC-Demo-2 — Demo flow works offline

- [ ] With airplane mode on, the demo flow runs end-to-end and shows a result. No exception logs, no failed network calls.

### AC-Demo-3 — Visual fidelity matches design

- [ ] Spot-check on iPhone 12 and Pixel 5 (simulator) against `design/mobile-prototype.html` for each screen. No visual deviations larger than spacing differences within ±2pt.
- [ ] Hero result reveal: 600ms fade + 8pt upward translate visible. Reduced motion mode replaces it with an instant set.

### AC-Demo-4 — DEMO pill and copy

- [ ] DEMO pill visible on: loading screen, result screen, evidence screen, history list item.
- [ ] Demo upgrade nudge visible at bottom of result screen, dismissible.

### AC-Demo-5 — Persistence

- [ ] Killing and relaunching the app preserves the saved demo result in History.
- [ ] Swipe-to-delete on a history item removes it after confirmation.

### AC-Demo-6 — No payment surface

- [ ] No purchase, paywall, price tag, "credit", "restore purchase", or "buy" string appears anywhere in the binary. Confirmed via release-build APK/IPA `strings` grep.

### AC-Demo-7 — No production secrets in the binary

- [ ] `strings` on the release binary — and on every asset bundle, font file, JSON asset, image, `.dart_tool`-emitted constant, compiled Dart `.so` (Android) and `App.framework` (iOS) blob — contains **no** production rectification provider API key, **no** `sk-…`-style provider secret, **no** Mapbox `sk.…` secret token, **no** Google Places / Firebase / third-party billing key meant to be confidential, and **no** `Bearer <real-provider-key>` literal. The only credential-shaped strings allowed in the binary are the public proxy app identifier (`RECTIFY_PROXY_APP_ID`) and the public restricted Mapbox `pk.…` token if Mapbox is the chosen geocoder — both treated as recoverable and non-confidential per §9.5 / §9.8.
- [ ] `flutter_secure_storage` is the only place an **end-user-supplied** Pro/Developer API key is stored when set, and it is never written to logs, crash reports, analytics, screenshots, history rows, draft rows, `rawResponseJson` blobs, `shared_preferences`, or any Drift column.
- [ ] No `.env`, no `firebase_options.dart` field, no asset file, and no `--dart-define` value carries a value that the backend treats as a confidential secret (cross-checked against Appendix B).
- [ ] The release build talks to the proxy using `RECTIFY_PROXY_APP_ID` only; the proxy is responsible for all real authentication, rate-limiting, and abuse detection (§9.7), not the mobile binary.

### AC-Demo-8 — No crashes during the smoke flow

- [ ] Crashlytics shows zero crash events during a 30-minute internal soak.
- [ ] `flutter test` green across unit, widget, golden.
- [ ] `integration_test/demo_flow_test.dart` green on both iOS and Android simulators.

### AC-Demo-9 — Settings work

- [ ] Toggling 12h/24h time format updates all visible times across History and Result.
- [ ] Setting then clearing a Pro API key persists across app kill and is never displayed back in plaintext after save.
- [ ] "Delete all data" wipes all visible state and returns the user to onboarding.

When AC-Demo-1 through AC-Demo-9 are green, we are demo-ready and ready to begin Phase 6 (real API integration) with confidence.

---

## Appendix A — Package selection summary

| Package | Purpose | Notes |
|---|---|---|
| `flutter_riverpod` 2.6+ | State management | With `riverpod_annotation` + `riverpod_generator` for codegen. |
| `go_router` 14+ | Navigation | Official Flutter team router. |
| `drift` + `drift_flutter` + `sqlite3_flutter_libs` | Local DB | Drift's Flutter binding + bundled SQLite. |
| `dio` | HTTP client | Interceptors, cancellation, timeouts. |
| `flutter_secure_storage` | API key storage | Keychain / Keystore-backed. |
| `shared_preferences` | Non-secret settings | One simple K/V store. |
| `freezed` + `freezed_annotation` + `json_annotation` + `json_serializable` | Immutable models | Codegen heavy but worth it. |
| `google_fonts` | Type | Inter, Source Serif 4, JetBrains Mono. Bundled offline. |
| `lucide_icons_flutter` | Icons | Single source per design-system §7. |
| `flutter_svg` | SVG assets | Brand mark + quiet glyphs. |
| `intl` | Formatting | Times, dates, percentages; locale-aware from day one. |
| `uuid` | Local IDs | v4. |
| `url_launcher` | Privacy policy in-app browser | One use. |
| `firebase_crashlytics` (or `sentry_flutter`) | Crash reporting | Anonymous; no PII. |
| **dev** | | |
| `very_good_analysis` | Lint baseline | Strict. |
| `build_runner` + `freezed` + `json_serializable` + `riverpod_generator` + `drift_dev` | Codegen | Run once at scaffold; `watch` during heavy iteration. |
| `mocktail` | Mocks | Null-safe. |
| `alchemist` | Golden tests | Cleaner cross-platform goldens than raw `flutter_test`. |
| `integration_test` | Integration | Bundled with Flutter. |

---

## Appendix B — `--dart-define` keys (all public, all recoverable from the binary)

**Security note (read before adding any key here):** Every value passed via `--dart-define` is compiled into the mobile binary as a plain string and is **trivially recoverable** from the released IPA / APK with off-the-shelf tools (`strings`, `r2`, `Hopper`, simple `unzip` of the IPA). Therefore **no value listed in this table is a confidential secret** — they are public configuration. Anything that must remain secret (the production provider's rectification key, any Mapbox `sk.…` token, any Google Places billing key, any third-party billing credential) is held server-side in the proxy's secret store (§9.7) and never reaches the mobile build system. Keys are named with `_PUBLIC_`, `_APP_ID`, and `_URL` suffixes to make this expectation explicit at the call site, so nobody mistakes the value for a real credential.

| Key | Example | Used by | Confidentiality |
|---|---|---|---|
| `RECTIFY_PROXY_BASE_URL` | `https://proxy.rectify.app` | `dioProvider` (proxy mode) | Public URL. |
| `RECTIFY_PROXY_APP_ID` | `rectify-ios-public-app-id-v1` | `AuthInterceptor` (proxy mode) | **Public app identifier**, not a secret. Used by the proxy only as a soft routing / rate-limit label; per §9.7 the proxy MUST NOT authenticate solely on this value. Rotatable by shipping a new build. |
| `RECTIFY_GEOCODING_BASE_URL` | `https://api.mapbox.com` | `GeocodingService` | Public URL. |
| `RECTIFY_GEOCODING_PUBLIC_KEY` | `pk.xxx…` | `GeocodingService` | **Public, URL- and bundle-id-restricted** Mapbox `pk.…` token. **Never** a Mapbox `sk.…` secret, **never** a Google Places billing key, **never** any token billed against the publisher's account without server-side restrictions. If the chosen geocoding provider does not offer a restrictable public client token, this field is left empty and geocoding is routed through the proxy instead (§9.8). |
| `RECTIFY_ENV` | `dev` / `staging` / `prod` | `Logger` verbosity, Crashlytics enablement | Non-credential build flag. |

**Not in this table by design:** the production rectification provider's shared API key (server-side only, §9.7) and the end-user-supplied Pro/Developer API key (entered in the in-app Settings sheet by the user, stored exclusively in `flutter_secure_storage`, §9.5). Neither value ever travels through the build system or `--dart-define`.

`flavor`-style separation is **not** required for MVP — one binary configurable at build time is enough.

---

## Appendix C — Done = shippable

When all phases complete and AC-Demo-1 through AC-Demo-9 plus the broader `docs/mvp-scope.md` "Acceptance Criteria" are green, the binary is ready for internal TestFlight / Internal Test track distribution. App Store submission is a separate gate that follows the open questions in §15.3 (final name, bundle ID, privacy policy URL, etc.).
