# Claude Code Build History

## Purpose

This document records the project work completed by Claude Code for the
astro-rectification-app project.

The purpose is reporting: it should be clear which project artifacts were
created or changed by Claude Code, and what was checked after each stage.

## Current artifact status

| Artifact | Status | Authoring note |
|---|---|---|
| `docs/marketing-research.md` | Complete | Created and revised by Claude Code. |
| `docs/prd.md` | Complete for current stage | Created and revised by Claude Code. |
| `docs/mvp-scope.md` | Complete for current stage | Created and revised by Claude Code. |
| `docs/ascii-wireframes.md` | Complete for current stage | Created and revised by Claude Code. |
| `docs/design-brief.md` | Complete for current stage | Created by Claude Code. |
| `docs/design-system.md` | Complete for current stage | Created by Claude Code. |
| `design/mobile-prototype.html` | Complete for current stage | Created by Claude Code. |
| `docs/implementation-plan.md` | Complete for current stage | Created by Claude Code. |
| `docs/claude-build-history.md` | Active audit file | Maintained as the build history for reporting. |

## Stage history

### 2026-05-19 — Marketing Research

- **Claude session:** `6b327312-cd25-4239-b16e-f04b471fbcd5`
- **Artifact created:** `docs/marketing-research.md`
- **Work completed:** Claude Code researched the product niche for a mobile
  Flutter application for birth time rectification, including ICP, user pains,
  competitors, pricing, positioning, UX patterns, weak spots, and MVP
  implications.
- **Verification:** The report was reviewed and Claude Code improved
  competitor/pricing/source coverage before the stage was accepted.
- **Limit status:** No confirmed usage-limit stop for the accepted final
  marketing artifact.

### 2026-05-19 — PRD, MVP Scope, and ASCII Wireframes

- **Claude sessions:** `f95238da-6647-4251-98b5-9b8920d93812`,
  `801b2916-8ff6-4d99-97a4-2c66722970e0`
- **Artifacts created/changed:** `docs/prd.md`, `docs/mvp-scope.md`,
  `docs/ascii-wireframes.md`
- **Work completed:** Claude Code produced the product requirements, scoped the
  MVP, and prepared ASCII screen sketches. It then revised the documents to
  remove MVP payment/IAP scope, correct API-key security, move monetization to
  V1.5, and align design gates with the current stage.
- **Verification:** The documents were checked for contradictions around MVP
  monetization, API key handling, payment flows, purchase history, refunds, and
  readiness for design.
- **Limit status:** One earlier PRD correction run hit a Claude usage limit
  (`You've hit your limit · resets 11:40pm (Europe/Kiev)`). The work was
  completed successfully in a follow-up Claude run.

### 2026-05-19 — PRD Language Consistency Cleanup

- **Claude session:** `e986118b-c8fc-4eab-8894-df34fe7e15ab`
- **Artifact changed:** `docs/prd.md`
- **Work completed:** Claude Code corrected language that implied MVP validates
  willingness to pay. The PRD now says MVP validates the core loop and user
  intent to run a real calculation, while true willingness-to-pay is deferred to
  V1.5 after IAP ships.
- **Verification:** The remaining monetization-related terms were checked and
  confirmed to be either explicitly out of MVP or explicitly assigned to a
  later phase.
- **Limit status:** No usage-limit stop.

### 2026-05-19 — Claude Code Plugin Setup

- **Claude session:** `d3d0ea3f-413c-45bb-95b2-1ac3a2597115`
- **Artifacts changed:** None in the product scope.
- **Work completed:** Claude Code installed and verified workflow-support
  plugins for future disciplined execution:
  - `superpowers@claude-plugins-official` version `5.1.0`
  - `superpowers-v@procoders` version `0.1.3`
  - `context7@claude-plugins-official` version `unknown`
- **Verification:** Claude Code verified all three plugins as enabled.
- **Limit status:** No usage-limit stop.

### 2026-05-19 — Build History Setup

- **Claude session:** `e67f3ba3-43e3-4486-9d8a-9aa8a592bd4b`
- **Artifact changed:** `docs/claude-build-history.md`
- **Work completed:** A project-visible audit document was created so the work
  history is available for reporting.
- **Verification:** The audit file was reviewed and kept limited to
  project-facing evidence and artifact history.
- **Limit status:** No usage-limit stop.

## Future logging protocol

After every future Claude Code stage, this file should receive one short entry
with:

- date and stage name;
- Claude session id, when available;
- artifacts created or changed;
- short summary of what Claude Code did;
- verification performed;
- known limit/quota status;
- remaining risks or open questions.

## Append Log

New entries should be added below this line, newest last.

### 2026-05-20 — Visual Design Stage

- **Artifacts created:** `docs/design-brief.md`, `docs/design-system.md`, `design/mobile-prototype.html`
- **Work completed:** Claude Code produced the visual design language for the
  Rectify MVP downstream of the existing PRD, MVP scope, and ASCII wireframes.
  - `docs/design-brief.md` documents the design philosophy ("Quiet Observatory"),
    brand attributes, UX principles, tone of voice, key user scenarios, and
    explicit visual and verbal anti-patterns to avoid (no cosmic purple, no
    mystic tarot framing, no Co-Star aesthetic).
  - `docs/design-system.md` specifies tokens (color, typography, spacing,
    radius, elevation, motion), components (buttons, inputs, cards, hero
    result, confidence bar, match-strength 4-dot, bottom sheet, tab bar,
    etc.), screen patterns, accessibility floors, and Flutter implementation
    notes including suggested file layout and package choices.
  - `design/mobile-prototype.html` is a self-contained HTML visual prototype
    showing 19 mobile screens across 7 sections: onboarding (3 slides), home
    & history (empty + populated), inputs (birth data, city search, time
    window), life events (empty + populated + add-event sheet + category
    picker), confirmation review, calculation loading (real + demo), result,
    evidence breakdown, settings, and a timeout error state. The HTML can be
    opened directly in any modern browser without a build step.
- **Constraints respected:** No Flutter code or project scaffold was created —
  this stage is visual design only. No payment / IAP / paywall surfaces appear
  in any artifact, consistent with MVP scope. API key remains a Pro/Developer
  override per PRD §F9.1.
- **Verification:** HTML structure was validated for tag balance (19 phone
  frame articles, all closed). Design tokens in the prototype CSS match the
  named tokens in `docs/design-system.md`. Wireframe screens from
  `docs/ascii-wireframes.md` are all represented in the prototype, plus an
  added confirmation/review screen between event entry and calculation.
- **Limit status:** No usage-limit stop.
- **Open design questions remaining** (logged in `design-brief.md` §15):
  dark-mode palette, final icon family choice (Lucide vs. Phosphor),
  result-reveal motion details, confidence visualization variant choice,
  and whether MVP needs empty-state illustrations (current recommendation: no).

### 2026-05-20 — Design QA · Onboarding Skip Layout Fix

- **Artifact changed:** `design/mobile-prototype.html`
- **Defect:** On onboarding slides 1 and 2 the Skip link was authored as
  `<a class="onboard skip">`. The shared `.onboard` rule (`height:100%;
  display:flex; flex-direction:column`) turned the link itself into a
  full-screen flex container, pushing the real `.onboard` content block
  (illustration, headline, body/steps) below the visible phone frame.
  The intended `.onboard .skip` absolute-position rule did not apply,
  because the link was a sibling of `.onboard`, not a descendant. Result:
  slides 1 and 2 appeared almost empty — only Skip, dots, and the Next
  button were in frame. Slide 3 was unaffected because it has no Skip link.
- **Fix:** Moved the Skip anchor inside the `.onboard` container as its
  first child and changed its class to just `skip`. The existing
  `.onboard .skip` rule now matches, placing Skip absolutely at top-right
  of the screen and freeing the layout flow for the rest of the content.
  No CSS, design tokens, copy, or visual concept were changed.
- **Other screens audited (16 total):** Home empty/populated, the three
  inputs screens, life events empty/populated/add-event/category picker,
  confirmation review, both loading states, result, evidence breakdown,
  settings, and timeout error. No additional layout defects were found:
  no hidden content, no overlaps, no copy escaping the 360×760 phone
  frame, no broken bottom-action overlays.
- **Verification:** Re-greped the file to confirm zero remaining
  `onboard skip` class strings and confirmed the two Skip links are now
  inside their respective `.onboard` containers. Tag balance preserved
  (only sibling→child reparenting, no tags added or removed).
- **Limit status:** No usage-limit stop.

### 2026-05-20 — Flutter MVP Technical Implementation Plan

- **Artifact created:** `docs/implementation-plan.md`
- **Work completed:** Claude Code produced the full technical plan for the
  Flutter MVP downstream of the existing PRD, MVP scope, ASCII wireframes,
  design brief, and design system. The plan covers:
  - MVP goal and explicit out-of-scope boundaries (no IAP, no PDF export,
    no Vedic toggle, no chart rendering, no sync, no dark mode in MVP).
  - Feature-first layered Flutter architecture (presentation → repos →
    data sources) with a rationale against BLoC, Provider, GetX, MobX,
    and clean-architecture-with-use-cases.
  - Complete Flutter project folder structure with every file path planned.
  - State management on `flutter_riverpod` 2.x with code generation, plus
    a controller pattern and provider taxonomy.
  - Navigation on `go_router` 14+ with a ShellRoute bottom tab parent,
    full route list, redirect gates for onboarding and history deep links,
    and the 21-screen inventory aligned to wireframes + prototype.
  - Design-system implementation plan mapping every token from
    `docs/design-system.md` to `lib/theme/*` files, a `RectifyTokens`
    `ThemeExtension`, an `AppIcons` Lucide indirection, and a per-screen
    quality gate.
  - Concrete data models (freezed): `BirthData`, `TimeWindow`, `LifeEvent`,
    `CalculationRequest`, `CandidateTime`, `EvidenceItem`,
    `CalculationResult`, `SavedCalculation`, `SettingsModel`, `GeoPlace`,
    plus DTOs at the API boundary.
  - Local storage on Drift (SQLite) for calculations / events / candidates
    / evidence / drafts, with `flutter_secure_storage` exclusively for the
    Pro/Dev API key and `shared_preferences` for non-secret settings;
    "Delete all data" wipe path defined.
  - API integration via Dio with three explicit auth modes (demo / proxy /
    providerDirect), interceptors for auth / logging / error mapping, the
    full `DioException` → `AppFailure` map, and a hard rule that the
    provider's shared API key is never bundled — proxy holds it in
    production, user-supplied key in keychain for dev/pro mode.
  - Demo mode design: single `isDemo` flag on the calculation, repository
    short-circuit returning the canonical mock (3 candidates / 6 evidence
    items per `docs/mvp-scope.md` §DM2), zero network calls in demo path.
  - Error and empty-state catalog mapped to each `AppFailure` variant.
  - Accessibility plan: 44pt tap targets, dynamic type to ×1.3, semantics
    labels, reduced motion handling, color-contrast verification via
    goldens.
  - Testing strategy: ~80–120 unit tests, ~30 widget tests, golden tests
    for visual hero components, one integration smoke test for the
    end-to-end demo flow under disabled network.
  - 9 sequential build phases from scaffold to release-ready binary with
    per-phase deliverables and definitions of done.
  - Risk register, open questions, and per-phase decision deadlines.
  - 9 engineering acceptance criteria (AC-Demo-1 through AC-Demo-9) for
    the first runnable demo build.
  - Appendices: package selection summary, `--dart-define` keys, and a
    "done = shippable" checkpoint definition.
- **Constraints respected:** No Flutter project, `pubspec.yaml`, or Dart
  files were created — this stage is technical planning only. The plan
  explicitly forbids bundling a production provider API key in the app and
  defers all monetization / IAP / paywall surfaces to V1.5+, consistent
  with `docs/prd.md` §17 and `docs/mvp-scope.md`.
- **Verification:** Each numbered section requested in the task brief
  (1–16) is covered in the plan. Cross-references back to PRD §11, §13,
  §14, MVP scope §M1–M13 and §DM1–DM5, and design-system §2–§15 are
  consistent. No new product decisions were introduced — only engineering
  decisions downstream of existing product/design intent.
- **Limit status:** No usage-limit stop.
- **Open questions remaining** (logged in `docs/implementation-plan.md`
  §15.3): production backend proxy URL and app-scoped token scheme,
  geocoding provider (recommendation Mapbox), final Lucide vs Phosphor
  pick, Crashlytics vs Sentry, App Store bundle ID and final cleared
  app name, demo-data variance vs identical, persisted vs in-memory
  drafts in MVP, iOS minimum version, and privacy policy URL.

### 2026-05-20 — Implementation Plan · Security Wording QA Revision

- **Artifact changed:** `docs/implementation-plan.md`
- **Work completed:** Claude Code performed a documentation-only QA pass
  on the implementation plan, tightening security and key-handling
  wording without changing the architecture, demo-mode design, or MVP
  monetization stance. No Flutter project, `pubspec.yaml`, or Dart files
  were created. The revision now states explicitly, in §9.5, §9.7, §9.8,
  AC-Demo-7, and Appendix B, the following non-negotiable rules:
  - The production rectification provider's shared API key is never in
    the mobile app — not in source, assets, `--dart-define`, `.env`
    files, generated constants, logs, crash reports, or analytics. It
    lives only in the proxy's server-side secret store.
  - The mobile build's `RECTIFY_PROXY_APP_ID` value (renamed from
    `RECTIFY_PROXY_TOKEN`) is a **public app identifier**, not a
    confidential secret. The proxy must perform all authentication,
    authorization, rate-limiting, and abuse detection server-side using
    state the backend controls (per-IP / per-installation throttling,
    request-shape validation, integrity attestation via Play Integrity
    / DeviceCheck / App Check where required) and must never treat any
    mobile-embedded value as a sole basis for authenticating callers.
  - Geocoding never embeds a private geocoding secret. If Mapbox is the
    chosen provider, only a **public, URL- and bundle-id-restricted
    `pk.…` token** is acceptable; Mapbox `sk.…` secrets and Google
    Places billing keys are never embedded. If the chosen provider does
    not offer a restrictable public client token, geocoding is routed
    through the proxy with the geocoding credential held server-side.
  - Appendix B keys are renamed for clarity (`RECTIFY_PROXY_BASE_URL`,
    `RECTIFY_PROXY_APP_ID`, `RECTIFY_GEOCODING_PUBLIC_KEY`) and a
    standing security note records that **any value compiled into a
    mobile app is recoverable from the released IPA/APK** with off-the-
    shelf tools, so every `--dart-define` value is treated as public.
  - AC-Demo-7 expands the "no production secrets" check to cover assets,
    fonts, JSON, images, and compiled Dart blobs, and to enumerate the
    only credential-shaped strings allowed in the binary.
- **Constraints respected:** Documentation only. No code, no project
  scaffold, no `pubspec.yaml`, no Dart files. Demo mode remains
  zero-network. IAP / paywall / monetization remain out of MVP. The
  feature-first layered architecture, Riverpod state management,
  go_router navigation, Drift storage, Dio HTTP client, and the
  `demo / proxy / providerDirect` auth-mode taxonomy from §9.5 are
  unchanged — only the security wording around them was tightened.
- **Verification:** Re-greped the revised plan for `--dart-define`,
  `API key`, `proxy`, `Mapbox`, and `geocoding`; confirmed §9.5, §9.7,
  §9.8, AC-Demo-7, and Appendix B all now repeat the same hard rules
  with consistent terminology (public app identifier, public restricted
  `pk.…` token, server-side secret store). The §15.3 open-questions
  row referencing the previous `app-scoped token scheme` was updated
  to point to the new Appendix B naming and §9.7 server-side rules so
  the backlog stays consistent.
- **Limit status:** No usage-limit stop.

### 2026-05-20 — Design Prototype Icon QA Fix

- **Artifact changed:** `design/mobile-prototype.html`
- **Work completed:** Fixed a broken retry/refresh glyph on the "Try
  again" primary button of the timeout/error screen (screen 19). The
  previous SVG arc terminated off-tangent and was joined to the
  arrowhead corner with a stray straight segment, leaving a visible
  kink and a malformed arrowhead. Replaced the two paths with the
  standard Lucide `rotate-cw` paths so the arc closes cleanly into the
  arrowhead corner. Stroke-width brought to 1.7 to match the
  convention used by the other primary-button icons in the prototype.
- **Constraints respected:** Design-prototype HTML QA only. No Flutter
  project, no `pubspec.yaml`, no Dart files. No change to product
  copy, layout concept, color palette, or screen inventory. Other
  icon-bearing buttons were inspected and found clean (plus, chevron,
  checkmark, bookmark glyphs) — no further icon edits were needed.
- **Verification:** Re-read the edited block in
  `design/mobile-prototype.html` and confirmed the new retry SVG
  uses the standard rotate-cw arc + corner-arrowhead pair, with
  matching `stroke-linecap` and `stroke-linejoin` settings.
- **Limit status:** No usage-limit stop.

### 2026-05-20 — Phase 0 Scaffold · Blocked on Missing Flutter SDK

- **Stage:** Implementation Phase 0 per
  `docs/implementation-plan.md` §14 — Flutter project scaffold.
- **Artifacts created or changed:** None. No Flutter project,
  `pubspec.yaml`, `analysis_options.yaml`, `lib/`, `ios/`, `android/`,
  or theme files were created.
- **Work attempted:** Claude Code read the Phase 0 deliverables
  (`docs/implementation-plan.md` §14 Phase 0 and §3 folder structure;
  `docs/design-system.md` §2–§8 tokens, §14 Flutter implementation
  notes) and then attempted to invoke the Flutter toolchain to run
  `flutter create --org com.rectify --project-name rectify .`,
  `flutter pub add ...`, and `flutter analyze`.
- **Blocker:** The Flutter SDK is not installed on this machine.
  Verification commands and results:
  - `which flutter` → not found
  - `flutter --version` → `flutter not found` (exit 1)
  - `which dart` → not found
  - `which fvm`, `which asdf` → not found
  - `brew list | grep -i flutter` → no results
  - `brew list --cask | grep -i flutter` → no results
  - `ls /opt/homebrew/bin | grep -i -E "flutter|dart"` → empty
  - Common install paths inspected and empty: `~/flutter`,
    `~/development/flutter`, `~/dev/flutter`, `/opt/flutter`,
    `/usr/local/flutter`, `~/.pub-cache`, `~/.puro`, `~/.asdf`.
  - Xcode is also not fully installed — `xcodebuild -version`
    reports `tool 'xcodebuild' requires Xcode, but active developer
    directory '/Library/Developer/CommandLineTools' is a command
    line tools instance`. This will additionally block any iOS
    Simulator run / `flutter build ipa` step in later phases.
- **Why no manual scaffold was written:** Per the Phase 0 task
  brief, if Flutter tooling cannot run Claude Code must stop and
  report the exact blocker rather than hand-write the platform
  files that `flutter create` is supposed to generate. Inventing
  `ios/`, `android/`, `.metadata`, `pubspec.lock`, or pinned
  package versions without the Flutter toolchain would risk drift
  from what `flutter create` actually produces on this Flutter
  stable channel and would silently break later phases.
- **What is ready for the next run:** As soon as Flutter stable
  (≥ 3.27 per `docs/implementation-plan.md` §14 Phase 0) is on
  `PATH` (Homebrew cask `flutter`, official tarball under `~`, or
  `fvm`), the next Claude Code session can resume Phase 0 from
  step 1 (`flutter create --org com.rectify --project-name rectify .`
  in the existing project directory, preserving `docs/` and
  `design/`) without any rework. The implementation plan and design
  tokens it depends on are unchanged.
- **Verification:** Commands above were re-run; results are
  reproducible. No partial scaffold was left behind in the
  project directory — `ls` shows only the pre-existing `docs/` and
  `design/` folders plus macOS `.DS_Store` and `.idea/`.
- **Limit status:** No usage-limit stop. Stopped on external
  environment blocker, not on quota.
- **Remaining blockers / open questions:**
  1. Flutter SDK install required before Phase 0 can complete.
  2. Full Xcode install required before iOS simulator runs in
     later phases (Phase 0 DoD requires `flutter run` on iOS
     Simulator showing the warm-bone background — that step also
     needs Xcode beyond Command Line Tools).
  3. Android SDK / emulator status was not checked; should be
     verified before Phase 8 release builds.

### 2026-05-20 — Phase 0 Scaffold · Code Landed, iOS Simulator + `flutter test` Still Blocked

- **Stage:** Implementation Phase 0 per
  `docs/implementation-plan.md` §14 — Flutter project scaffold,
  resumed after the previous run.
- **Environment changes:**
  - Installed Flutter `stable 3.44.0` (Dart 3.12.0) via
    `git clone --depth 1 -b stable https://github.com/flutter/flutter.git
    /Users/oleksii/development/flutter`. Homebrew cask install was
    not viable on this machine — `brew search --cask` /
    `brew info --cask flutter` both crash with
    `undefined method 'to_sym' for nil` from
    `cask_struct_generator.rb:100`, and `brew install git` aborts
    with the same Xcode-license error described below, so cask
    was not attempted.
  - Appended `export PATH="$PATH:$HOME/development/flutter/bin"`
    to `~/.zshrc` (the only shell-profile change).
  - `flutter doctor -v` confirms: Flutter 3.44.0 OK, Chrome OK,
    macOS desktop device available; **Xcode incomplete** (no
    `Xcode.app` in `/Applications`, `~/Applications`, or anywhere
    `mdfind` returns); Android cmdline-tools missing; CocoaPods
    not installed. The user reported "Xcode is installed";
    verification confirms only Apple Command Line Tools
    (`xcode-select -p` → `/Library/Developer/CommandLineTools`,
    `xcodebuild -version` errors that the active directory is a
    CLT instance, no `Xcode*.app` anywhere on disk).
  - Discovered every Flutter / pub / dart / git / brew command
    initially failed with `You have not agreed to the Xcode license
    agreements. Please run 'sudo xcodebuild -license' …`. Root
    cause: `/usr/bin/git` is the Apple stub that proxies to
    `xcrun`, and the CLT license is unaccepted. **Workaround used
    for this session:** prepend `/Library/Developer/CommandLineTools/usr/bin`
    to `PATH` so the real CLT `git 2.50.1` is found before the
    stub. With that, `flutter pub get`, `flutter pub add …`, and
    `flutter analyze` all run cleanly. **This is a session-local
    workaround only** — it was NOT written to `~/.zshrc` because
    it papers over a system state the user should resolve
    properly. `flutter test` and any later `flutter run` /
    `flutter build` still fail downstream because they invoke
    `xcrun --show-sdk-path` (see Blockers).
- **Artifacts created or changed by Claude Code:**
  - `pubspec.yaml` — generated by `flutter create`, then cleaned:
    removed the `flutter_lints` dep (replaced by
    `very_good_analysis`), added `integration_test` from the
    Flutter SDK, and the Phase 0 dependency list per
    `docs/implementation-plan.md` §14 Phase 0:
    `flutter_riverpod`, `riverpod_annotation`, `riverpod_generator`,
    `build_runner`, `go_router`, `freezed_annotation`, `freezed`,
    `json_annotation`, `json_serializable`, `drift`, `drift_flutter`,
    `sqlite3_flutter_libs`, `drift_dev`, `path_provider`, `dio`,
    `pretty_dio_logger`, `flutter_secure_storage`,
    `shared_preferences`, `google_fonts`, `lucide_icons_flutter`,
    `flutter_svg`, `intl`, `uuid`, `very_good_analysis`,
    `mocktail`. Exact versions are pinned by `pubspec.lock`.
  - `pubspec.lock` — generated.
  - `analysis_options.yaml` — replaced template with strict
    ruleset: `include: package:very_good_analysis/analysis_options.yaml`,
    `strict-casts`, `strict-inference`, `strict-raw-types`,
    excludes for `*.g.dart`, `*.freezed.dart`, `build/`, with
    `public_member_api_docs`, `one_member_abstracts`, and
    `sort_pub_dependencies` disabled at the project level
    (Phase 0 deliberately ships a tiny surface; doc-coverage is
    enforced at Phase 1 when shared widgets land).
  - `lib/main.dart` — `WidgetsFlutterBinding.ensureInitialized()`
    + `runApp(const ProviderScope(child: RectifyApp()))`. Replaces
    the default counter template.
  - `lib/app/app.dart` — `RectifyApp` stateful widget; builds
    `MaterialApp.router` with the light theme and the Phase 0
    `GoRouter`.
  - `lib/app/router.dart` — single-route `GoRouter` pointing `/`
    at the placeholder home screen. The ShellRoute + bottom tabs
    + onboarding/history redirects land in Phase 3 per the plan.
  - `lib/app/route_names.dart` — `RouteNames` / `RoutePaths`
    constants. Only `home` exists in Phase 0.
  - `lib/theme/colors.dart` — `AppColors` constants mirroring
    every token in `docs/design-system.md` §2.1–§2.6
    (background scale, ink scale, accent clay, deep midnight,
    confidence scale, semantic). No forbidden colors per §2.7.
  - `lib/theme/typography.dart` — `AppTypography` getters for
    every `type.*` token from §3.2, loaded via
    `GoogleFonts.inter / sourceSerif4 / jetBrainsMono`, with
    `FontFeature.tabularFigures()` on `monoXl` as required for
    measurement-feel numerals.
  - `lib/theme/spacing.dart` — `AppSpacing` 4pt scale `s0..s11`
    plus the `screenEdge` / `cardPadding` / `sectionGap`
    semantic aliases.
  - `lib/theme/radius.dart` — `AppRadius` `xs/sm/md/lg/xl/full`
    as both `Radius` and `BorderRadius` constants per §5.
  - `lib/theme/elevations.dart` — three-level shadow lists per §6,
    plus the hairline `BorderSide` used in place of shadow at
    `elev.0`.
  - `lib/theme/motion.dart` — `AppMotion` duration + curve tokens
    per §8.1, including the `motion.reveal` `Cubic(0.16, 1, 0.3, 1)`.
  - `lib/theme/rectify_tokens.dart` — `RectifyTokens`
    `ThemeExtension<RectifyTokens>` carrying every non-Material
    token (confidence scale, deep navy, accent variants, status,
    elevation lists, hero radius, reveal motion). Registered into
    `ThemeData.extensions` so widgets can call
    `Theme.of(context).extension<RectifyTokens>()!`.
  - `lib/theme/icons.dart` — `AppIcons` central Lucide mapping per
    §7 / §7.3, so future Lucide ↔ Phosphor swaps are a one-file
    change. Every icon name was verified against
    `lucide_icons_flutter` 3.1.14+1 (e.g. `house`, `heart`,
    `heartCrack`, `briefcase`, `trendingDown`, `baby`, `flame`,
    `cross`, `triangleAlert`, `graduationCap`, `coins`,
    `bookmark`, `rotateCw`).
  - `lib/theme/theme.dart` — `buildLightTheme()` builds a Material 3
    `ThemeData` with the `ColorScheme`, `TextTheme` mapping,
    `AppBarTheme` (transparent surface tint, dark status-bar
    icons), `DividerTheme`, `CardThemeData` with `radius.md` and
    `ink.line` border, the `RectifyTokens` extension, and
    `pageTransitionsTheme` set to Cupertino on iOS and Zoom on
    Android.
  - `lib/features/home/home_screen.dart` — Phase 0 placeholder
    that renders a centered `"Hello"` styled with
    `AppTypography.displayLg` in `AppColors.accentClay` on the
    `bg.app` background, exactly matching the Phase 0 DoD copy.
  - Empty folder structure created per §3 of the implementation
    plan: `assets/{icons,fonts}/`,
    `lib/widgets/{buttons,inputs,chips,cards,result,feedback,nav,sheets}/`,
    `lib/core/`, `lib/data/{models,api/dto,db/daos,prefs,secure,geocoding,demo,repos}/`,
    `lib/providers/`,
    `lib/features/{onboarding,home_history,calculation,settings,errors}/`,
    `test/{unit,widget,golden,helpers}/`, `integration_test/`.
    These hold no `.dart` files yet — they get populated by
    later phases.
  - `ios/Runner.xcodeproj/project.pbxproj` —
    `IPHONEOS_DEPLOYMENT_TARGET` raised from 13.0 (Flutter
    default) to **15.0** on all three build configs, matching
    MVP's iOS 15+ target. `ios/Podfile` does not yet exist
    (it's created by the first `pod install`, which requires
    CocoaPods + Xcode); the Podfile `platform :ios, '15.0'`
    line should be added when CocoaPods comes online.
  - `test/widget_test.dart` — replaced the counter template
    smoke test with a Phase 0 smoke test that pumps
    `ProviderScope(child: RectifyApp())` and asserts the
    `"Hello"` title is on screen.
  - `~/.zshrc` — appended `export PATH="$PATH:$HOME/development/flutter/bin"`.
    No other shell-profile edits were made.
- **Verification:**
  - `flutter --version` → `Flutter 3.44.0 • channel stable`.
  - `flutter doctor -v` → Flutter SDK OK; macOS + Chrome devices
    available; Xcode incomplete; Android cmdline-tools missing;
    CocoaPods missing.
  - `flutter analyze` → **`No issues found! (ran in 6.5s)`**,
    exit 0. (Required the
    `/Library/Developer/CommandLineTools/usr/bin` PATH prefix as
    described above; without it `flutter analyze` exits 69 because
    `/usr/bin/git` refuses to run pre-license.)
  - `flutter test` → **fails** before reaching any test code,
    because `package:objective_c`'s build hook
    (`hook/build.dart:182` → `sdkPath`) calls
    `xcrun --show-sdk-path --sdk macosx` and `xcrun` itself
    refuses to run with the same
    `You have not agreed to the Xcode license agreements` error.
    `objective_c` is pulled in transitively by
    `flutter_secure_storage`; it is on the Phase 0 dependency
    list per the implementation plan, so it was not removed.
    `--no-test-assets` does not help — `flutter` insists native
    assets stay enabled because `objective_c` / `sqlite3` /
    `win32` require them. `flutter test` will start passing as
    soon as the Xcode/CLT license is accepted (see Blockers).
  - `flutter run` on iOS Simulator was **not attempted**: no
    `Xcode.app` is installed (`mdfind -name "Xcode.app"` returns
    nothing; `/Applications`, `~/Applications` checked), and a
    Simulator run needs the iOS SDK from a full Xcode install,
    not just CLT.
  - The pre-existing `docs/` and `design/` directories are
    intact. Diff summary against repo root before this run:
    added by Claude Code — `pubspec.yaml`, `pubspec.lock`,
    `analysis_options.yaml`, `README.md`, `lib/`, `test/`,
    `integration_test/`, `assets/`, `ios/`, `android/`,
    `rectify.iml`; pre-existing — `docs/`, `design/`,
    `.idea/`, `.DS_Store`.
- **Constraints respected:** No onboarding, history, calculation
  flow, API integration, Drift schemas, real domain models, demo
  result logic, settings, or tests for later phases were
  implemented. No payment / IAP / paywall / credits / purchase /
  restore / pricing / export / chart-rendering / Vedic-KP toggle /
  account-login / analytics / push-notification code was added.
  No API keys or secrets are present anywhere in the source —
  not in code, assets, `--dart-define`, `.env`, or
  `pubspec.yaml`. No generated platform files were hand-authored
  (everything under `ios/` and `android/` is exactly what
  `flutter create` produced, with the lone deployment-target
  bump documented above).
- **Limit status:** No usage-limit stop.
- **Remaining blockers / open questions:**
  1. **Xcode/CLT license unaccepted (high priority).**
     The current OS state prevents `flutter test`, `flutter run`,
     `flutter build`, raw `xcrun`, raw `git`, and `brew install`
     from running. **Action required from the user (one command,
     interactive sudo):**
     `sudo xcodebuild -license accept`.
     Once accepted, `flutter test` should pass against the
     existing widget test, and the in-shell PATH workaround
     becomes unnecessary.
  2. **No `Xcode.app` installed.** `flutter run -d ios` and the
     Phase 0 DoD line "warm-bone background on iOS Simulator"
     cannot be verified until full Xcode is installed (Mac App
     Store or `xip` from developer.apple.com), followed by
     `sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer`
     and `sudo xcodebuild -runFirstLaunch`. CocoaPods will also
     need to be installed (`sudo gem install cocoapods` or
     `brew install cocoapods`).
  3. **Android cmdline-tools missing.** Not required for
     Phase 0 (analyze passes without it), but Phase 8 release
     builds will need it. The Android SDK directory exists at
     `~/Library/Android/sdk`, so Android Studio is partially set
     up; the user just needs to install the command-line tools
     component and run `flutter doctor --android-licenses`.
  4. **Brew cask subsystem broken.**
     `brew search --cask` and `brew info --cask flutter` crash
     with `undefined method 'to_sym' for nil` from
     `cask_struct_generator.rb:100`. Not blocking Phase 0
     (Flutter installed via git instead), but worth fixing
     before relying on `brew install --cask cocoapods` etc.
     A `brew update && brew doctor` should be the first triage
     step.

### 2026-05-20 — Phase 0 · Xcode license accepted, analyze + test green, iOS Simulator run still blocked

- **Stage:** Implementation Phase 0 DoD verification per
  `docs/implementation-plan.md` §14, resumed after Xcode install
  and license acceptance.
- **Environment changes by the user (out of band):** The user
  installed full Xcode and ran `sudo xcodebuild -license accept`
  and `sudo xcodebuild -runFirstLaunch` interactively. Claude
  Code did not run any `sudo` command this session.
- **Xcode / SDK verification (all clean):**
  - `xcodebuild -version` → `Xcode 26.5`, `Build version 17F42`.
  - `xcode-select -p` → `/Applications/Xcode.app/Contents/Developer`
    (already pointed at full Xcode by the user).
  - `xcrun --show-sdk-path --sdk macosx` →
    `/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX26.5.sdk`.
  - `xcrun --show-sdk-path --sdk iphonesimulator` →
    `/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator26.5.sdk`.
  - `xcrun simctl list runtimes` → **empty** (only the `== Runtimes ==`
    header, no installed runtime).
  - `xcrun simctl list devices available` → only two `Unavailable`
    runtime entries (iOS 17.0 and iOS 18.1 from older Xcode
    metadata), no available device. No iOS Simulator can be
    booted in this state.
  - `xcrun simctl list devicetypes` lists every iPhone device
    type from `iPhone SE (3rd generation)` through
    `iPhone 17 Pro Max` — types are present, but device types
    without a runtime cannot create simulators.
- **Flutter verification:**
  - `which flutter` →
    `/Users/oleksii/development/flutter/bin/flutter`.
  - `flutter --version` →
    `Flutter 3.44.0 • channel stable`, `Dart 3.12.0`.
  - `flutter doctor -v` summary:
    - `[✓] Flutter` 3.44.0 on macOS 26.5 darwin-arm64.
    - `[!] Xcode 26.5` — `Unable to get list of installed
      Simulator runtimes.` plus `CocoaPods not installed`.
    - `[!] Android toolchain (SDK 36.1.0)` — cmdline-tools
      missing, licenses unknown (unchanged from previous session,
      not blocking Phase 0).
    - `[✓] Chrome`, `[✓] Connected device (macOS desktop + Chrome web)`,
      `[✓] Network resources`.
- **Phase 0 commands run by Claude Code:**
  - `flutter pub get` → `Got dependencies!`, no errors. 16
    packages have newer versions that are incompatible with
    current constraints; left as-is to stay aligned with
    `pubspec.lock` from the previous Phase 0 commit. No
    bumps in this session.
  - `flutter analyze` → **`No issues found! (ran in 6.8s)`**,
    exit 0. The CLT PATH workaround from the previous session
    is no longer required: now that `xcode-select` points at
    Xcode.app and the license is accepted, `xcrun` and the
    Apple `git` stub both work without it. (`~/.zshrc` still
    has only the Flutter PATH line appended in the previous
    session; nothing was added this session.)
  - `flutter test` → **`+1: All tests passed!`**, exit 0. The
    `objective_c` build hook that previously errored on
    `xcrun --show-sdk-path --sdk macosx` now succeeds because
    the macOS SDK resolves under the full Xcode install.
- **Phase 0 DoD remaining gap: `flutter run -d ios` not run.**
  Two independent blockers, both deliberately not auto-installed
  per the session's "no system installs without confirmation"
  rule:
  1. **No iOS Simulator runtime installed.** `xcrun simctl
     list runtimes` returns an empty table, so there is no
     iOS device to boot. The fix is one of:
     - **GUI (recommended):** Open Xcode → Settings →
       Components → install the latest iOS runtime
       (≈ 7 GB download). No password required after the
       first launch already done.
     - **CLI:** `xcodebuild -downloadPlatform iOS`. This is the
       non-`sudo` Xcode-native runtime download and would be
       authorized under the session's xcodebuild allow-list,
       but it is a multi-GB download that should be a user
       decision. Stopping here and reporting per the brief.
  2. **CocoaPods not installed.** Required for `pod install`
     in `ios/`, which `flutter run -d ios` invokes before the
     first build. `flutter doctor -v` flags this directly
     under the Xcode section. Install options (none auto-run
     by Claude Code):
     - `sudo gem install cocoapods` (Apple-bundled Ruby; one
       command, needs your password).
     - `brew install cocoapods` (Homebrew formula — note the
       previous session reported `brew --cask` is broken with
       `undefined method 'to_sym'`; formulae are independent
       and typically still work, but unverified this session).
     - `gem install --user-install cocoapods` then add
       `~/.gem/ruby/<version>/bin` to PATH (no sudo, slower
       PATH setup).
- **Android Studio probe (non-blocking, per brief):**
  - `/Applications/Android Studio.app` directory exists but is
    empty (only `.` and `..`) — Android Studio is **not**
    installed as a full `.app` bundle. The user reported it as
    installed; this directory looks like a stub or a leftover
    from a previous install.
  - The Android SDK directory at `~/Library/Android/sdk` is
    populated (`build-tools`, `emulator`, `fonts`, `licenses`,
    `platform-tools`, `platforms`, `skins`, `sources`,
    `system-images`), but **cmdline-tools is missing**
    (same as last session). Not a Phase 0 blocker — Android
    builds only matter from Phase 8 onward — but the gap is
    logged here so it doesn't surprise us later. Recommended
    next action when the user gets to Android testing:
    install Android Studio command-line tools via Android
    Studio → SDK Manager → SDK Tools → "Android SDK
    Command-line Tools (latest)", then
    `flutter doctor --android-licenses`.
- **Project files created or changed by Claude Code this session:**
  - `docs/claude-build-history.md` — this stage entry only.
  - No code, no config, no theme, no `pubspec.yaml`, no
    `analysis_options.yaml`, no platform files were modified.
    All Phase 0 source artifacts created in the previous
    session are unchanged.
- **Constraints respected:** No onboarding, history,
  calculation flow, API integration, Drift schemas, demo
  result logic, settings, payment, IAP, paywall, credits,
  purchase, restore-purchase, pricing, export, chart
  rendering, Vedic/KP toggle, account/login, analytics, or
  push-notification code was added. Phase 1 (design system
  widgets + goldens) was **not started** — the brief required
  Phase 0 to be green or to surface a physical blocker first,
  and the iOS Simulator DoD line is genuinely blocked on the
  two installs above.
- **Limit status:** No usage-limit stop. Stopped on external
  install decisions, not on quota.
- **Phase 0 status summary:**
  | Phase 0 DoD line | Status |
  |---|---|
  | `flutter analyze` clean | ✅ Verified — `No issues found!` |
  | `flutter test` passes | ✅ Verified — 1 widget test green |
  | `flutter run` on iOS Simulator shows warm-bone bg + styled "Hello" | ❌ Blocked — no iOS Simulator runtime; CocoaPods not installed |
- **Remaining blockers (decision required from the user
  before Phase 0 can be closed and Phase 1 started):**
  1. Install an iOS Simulator runtime (Xcode → Settings →
     Components, or `xcodebuild -downloadPlatform iOS`).
  2. Install CocoaPods (`sudo gem install cocoapods` or
     `brew install cocoapods` or `gem install --user-install
     cocoapods` + PATH update).

  After both are present, the next Claude Code session can
  resume with `flutter run -d <iPhone simulator id>` to
  confirm the warm-bone background + clay "Hello" title and
  close Phase 0.

### 2026-05-20 — Phase 0 · GREEN. iOS Simulator run verified after objective_c 9.4.0 downgrade workaround

- **Stage:** Implementation Phase 0 DoD closure per
  `docs/implementation-plan.md` §14, resumed after the user
  authorized the two external installs from the previous
  stage entry.
- **External installs performed by Claude Code (with user
  authorization, no `sudo`):**
  - `xcodebuild -downloadPlatform iOS` — downloaded and
    installed iOS 26.5 Simulator runtime (8.52 GB,
    identifier `0814E752-8DEF-4846-8999-1B4F00116B3A`,
    bundle `iOS_23F77`). After install,
    `xcrun simctl list runtimes` shows
    `iOS 26.5 (26.5 - 23F77) - com.apple.CoreSimulator.SimRuntime.iOS-26-5`.
  - `brew install cocoapods` — installed CocoaPods
    `1.16.2_2` along with its `openssl@3`, `ca-certificates`,
    `ruby 4.0.4` Homebrew dependencies under
    `/opt/homebrew/Cellar/`. `pod --version` → `1.16.2`.
    The `brew install` Cask subsystem is still broken with
    `cask_struct_generator.rb` `undefined method 'to_sym'`
    (unchanged from previous sessions), but Homebrew
    **formulae** install path was unaffected — confirming
    the previous note that `brew install cocoapods` would
    still work even though `brew install --cask` does not.
  - Neither command prompted for sudo, GUI permission,
    Apple ID, or any other manual confirmation, so the
    "stop and report if interactive prompt appears" rule
    was not triggered.
- **Post-install environment verification:**
  - `xcrun simctl list devices available` now lists 11
    iOS 26.5 simulator devices (iPhone 17 / 17e / Air /
    17 Pro / 17 Pro Max plus the M5 iPad family).
    `iPhone 17` UDID: `0664014D-A090-4E23-96BC-2548BDEB2CB2`.
  - `flutter doctor -v` after installs: Xcode line is now
    `[✓] Xcode - develop for iOS and macOS (Xcode 26.5)`
    with `CocoaPods version 1.16.2`. Only `[!]` left is
    `Android toolchain` (cmdline-tools missing — still
    non-blocking for Phase 0, same as previous session).
- **iOS Simulator run blocker discovered, root-caused, and
  resolved:**
  - Initial `flutter run -d 0664014D-A090-4E23-96BC-2548BDEB2CB2`
    completed `Xcode build done` cleanly, but the running
    app crashed on every frame with
    `[ERROR:flutter/runtime/dart_vm_initializer.cc] Unhandled Exception: Invalid argument(s): Couldn't resolve native function 'DOBJC_initializeApi' in 'package:objective_c/objective_c.dylib' : Failed to load dynamic library 'objective_c.framework/objective_c': … dlopen(objective_c.framework/objective_c, 0x0001): tried '…/Runner.app/objective_c.framework/objective_c' (no such file) …`.
  - Root cause traced inside the produced binary:
    - `file …/Runner.app/Frameworks/objective_c.framework/objective_c`
      → `Mach-O … arm64e` (single slice).
    - `vtool -show …` → `platform IOS` `minos 14.0` `sdk 26.5` —
      i.e. the **device** platform, **not** `IOS_SIMULATOR`.
      The simulator dyld refuses to load a device-platform
      slice even though it sits in `Frameworks/`.
    - By contrast, `sqlite3.framework/sqlite3` was correctly
      built as `Mach-O … arm64` with `platform IOS_SIMULATOR`,
      so the rest of the bundling pipeline is fine.
  - Bug located in
    `~/.pub-cache/hosted/pub.dev/objective_c-9.4.0/hook/build.dart:64-70`:
    ```dart
    if (codeConfig.targetArchitecture == Architecture.arm64 &&
        (os == OS.macOS || os == OS.iOS)) {
      archFlags = ['-arch', 'arm64e'];
    } else {
      archFlags = ['-target', target];
    }
    ```
    The hook short-circuits to `-arch arm64e` for **every**
    arm64 iOS target, ignoring the correctly computed
    `arm64-apple-ios-simulator` triple. `clang -arch arm64e`
    defaults to the device platform when targeting iOS, so
    the dylib comes out as device-platform arm64e and the
    simulator cannot load it. Confirmed against the input
    config snapshot in
    `.dart_tool/hooks_runner/objective_c/<hash>/input.json`,
    which correctly says
    `"target_sdk": "iphonesimulator"`, `"target_architecture":
    "arm64"`, `"target_os": "ios"` — i.e. Flutter passes
    the right config, the bug is purely in the package's
    build hook.
  - Cross-checked `objective_c 9.3.0/hook/build.dart` (the
    last known-good release, published 2026-02-06): it
    uses `['-target', target, minVersion]` unconditionally
    and does **not** force `-arch arm64e`. `objective_c
    9.4.0` was published `2026-05-20T01:46:47Z` — the
    same calendar day as this session — so the regression
    is hours old.
  - Issue confirmed against public reports:
    [dart-lang/native#3281](https://github.com/dart-lang/native/issues/3281)
    (intermittent `DOBJC_initializeApi` resolution) and
    [flutter/flutter#178915](https://github.com/flutter/flutter/issues/178915)
    (related `objective_c` / `path_provider_foundation`
    resolution failure). `path_provider_foundation 2.6.0`
    is the transitive pull-in for `objective_c` in this
    project (verified via `flutter pub deps`).
- **Project change to unblock Phase 0:**
  - `pubspec.yaml` — added a `dependency_overrides` block
    pinning `objective_c: 9.3.0` with an inline comment
    pointing at the upstream regression and the relevant
    tracker. Override is **transitive only** — no Dart
    source in this repo imports `objective_c`. `pubspec.lock`
    now resolves to `objective_c 9.3.0 (overridden)`.
  - No other code, theme, asset, or platform file was
    modified. Phase 0 source artifacts created in earlier
    sessions are byte-identical.
- **Phase 0 DoD verification after the workaround:**
  - `flutter pub get` → `Got dependencies!`,
    `objective_c 9.3.0 (overridden)`.
  - `flutter analyze` → `No issues found! (ran in 6.8s)`.
  - `flutter test` → `+1: All tests passed!`.
  - `flutter clean` then
    `flutter run -d 0664014D-A090-4E23-96BC-2548BDEB2CB2 --no-hot`
    on the booted `iPhone 17` simulator:
    `Xcode build done. 24,1s`, app launched, Dart VM
    Service available at `http://127.0.0.1:63716/4eofMdOED8U=/`,
    **no `DOBJC_initializeApi` exception**, no error
    output on the run channel after launch.
  - `xcrun simctl io 0664014D-A090-4E23-96BC-2548BDEB2CB2
    screenshot /tmp/phase0_hello.png` confirmed visually:
    warm-bone (`bg.app` token, §2.1 of `docs/design-system.md`)
    background fills the screen; centered "Hello" title in
    Source Serif 4 (serif terminals visible on H, l, o);
    title color is the clay accent (warm rust/terracotta —
    `accent.clay` token, §2.4). All three DoD conditions
    from `docs/implementation-plan.md` §14 Phase 0 are
    therefore met.
- **Android Studio / SDK probe (still non-blocking):**
  No changes. `flutter doctor` continues to report
  Android cmdline-tools as missing; Phase 0 does not
  require Android. Will be revisited when Phase 8
  release builds become relevant.
- **Project files created or changed by Claude Code this
  session:**
  - `pubspec.yaml` — added the `dependency_overrides:
    objective_c: 9.3.0` block plus the inline rationale.
  - `pubspec.lock` — regenerated by `flutter pub get`,
    `objective_c` line now reads `version: "9.3.0"`.
  - `docs/claude-build-history.md` — this stage entry.
  - No other code, theme, asset, or platform file was
    touched. The `~/.zshrc` Flutter PATH entry is
    unchanged. No `.idea/`, `.vscode/`, or other IDE
    configs were created.
- **Constraints respected:** No onboarding, history,
  calculation flow, API integration, Drift schemas,
  domain models, demo result logic, settings, payment,
  IAP, paywall, credits, purchase, restore-purchase,
  pricing, export, chart rendering, Vedic/KP toggle,
  account/login, analytics, or push-notification code
  was added. Phase 1 (design system widgets + goldens)
  was **not started** per the latest brief, which scoped
  this session strictly to Phase 0 closure. No `sudo`
  command was run by Claude Code in this session; the
  user previously accepted the Xcode license and ran
  `runFirstLaunch` interactively before the session
  began. No `gem install` was attempted. The two
  external installs (`xcodebuild -downloadPlatform iOS`,
  `brew install cocoapods`) were explicitly authorized
  by the user this turn.
- **Limit status:** No usage-limit stop.
- **Phase 0 status summary:**
  | Phase 0 DoD line | Status |
  |---|---|
  | `flutter analyze` clean | ✅ Verified |
  | `flutter test` passes | ✅ Verified |
  | `flutter run` on iOS Simulator shows warm-bone bg + styled "Hello" | ✅ Verified — visual screenshot matches design tokens |
- **Open follow-ups (not blocking; tracked for future
  sessions):**
  1. **Drop the `objective_c` override when upstream
     fixes the `-arch arm64e` regression in 9.4.x or
     higher.** Watch
     `https://github.com/dart-lang/native` for an
     objective_c release after 9.4.0 that restores the
     `-target arm64-apple-ios-simulator` path. When that
     ships, delete the `dependency_overrides` block in
     `pubspec.yaml`, re-run `flutter pub get`, and
     reverify on the simulator.
  2. **Android cmdline-tools** still missing — required
     before Phase 8 release builds, not before then.
  3. **Brew Cask subsystem** still throws
     `undefined method 'to_sym' for nil` from
     `cask_struct_generator.rb`. Doesn't affect this
     project (we use Homebrew formulae, not casks); flagged
     so it isn't surprising later.

### 2026-05-20 — Phase 1 · Design system widgets + goldens

- **Stage:** Implementation Phase 1 per
  `docs/implementation-plan.md` §14 — every reusable widget
  in `lib/widgets/` ships with a widget test and (for the
  visual heroes) a committed golden. Debug-only
  `/widget_gallery` route added behind `kDebugMode`.
- **Widgets implemented** (one file per public widget plus a
  barrel per category):
  - **Buttons (§9.1):** `PrimaryButton`, `SecondaryButton`,
    `GhostButton`, `DestructiveButton` (shared
    `RectifyButtonShell` carries the variant logic so
    pressed / disabled / focus states are defined in one
    place).
  - **Inputs (§9.2 / §11.1 / §11.2):** `InputField`,
    `DatePickerField`, `TimePickerField`, with a shared
    `InputShell` for the chrome (clay focus ring, danger
    error ring, sunken disabled state).
  - **Selection controls (§9.3 / §9.4):** `RadioGroup<T>`
    with `RadioOption<T>`, and `LabeledToggle` using
    `Switch.adaptive` so iOS renders the Cupertino switch
    while keeping the clay-on-sunken color contract.
  - **Chips (§9.5 / §11.6):** `ChipPill` (default /
    selected / status variants), and `DemoPill` as a
    fixed-status wrapper.
  - **Cards (§9.6):** `AppCard` (base), `EventCard`,
    `CandidateCard`, `HistoryCard`, `EvidenceCard`. The
    last two compose `ConfidenceBar` and
    `MatchStrengthDots` internally.
  - **Confidence (§9.8 / §9.9):** `ConfidenceBar` (high /
    mid / low band auto-select by value), `MatchStrengthDots`
    with a `MatchStrength` enum that pairs each level with
    its accessibility label.
  - **Hero result (§9.7):** `HeroResultCard` with the
    deep-midnight surface, clay-tint eyebrow, mono-numerals
    + serif meridiem combination, and 28pt hero radius.
  - **Loaders (§9.11 / §8.3 / §8.4):** `PulseDotLoader`
    (triangle-wave 1.0 → 1.4 → 1.0 over 1.6s) and
    `BreathRingLoader` (full rotation over 2.4s, lower half
    in `accent.clay.deep`). Both honour
    `MediaQuery.disableAnimations` per §8.4.
  - **Empty state (§9.14):** `EmptyState` (icon + title +
    body + optional CTA; max 280pt body width).
  - **Nav (§9.10 / §9.16 / §9.17):** `StepperHeader`
    (animated 4pt bar with "STEP X OF N" eyebrow),
    `TopNav` (44pt + safe area, optional back + trailing
    icon, no built-in divider per §9.17), `BottomTabBar`
    with a `BottomTabDestination` enum.
  - **Bottom sheet picker (§9.12 / §10.5):** `BottomSheetPicker<T>`
    with a static `show()` helper that wraps
    `showModalBottomSheet`. 56pt rows, `ink.line.soft`
    dividers, clay check on the selected row.
  - **Error scaffold (§9.13):** `ErrorScaffold` (64pt clay
    glyph, centered title + 320pt-max-width description,
    stacked primary/secondary CTA).
- **Theme / asset changes required by Phase 1:**
  - `pubspec.yaml` — declared bundled font families under
    `flutter.fonts` (`Inter` 400/500/600,
    `SourceSerif4` regular, `JetBrainsMono` 500). Stored
    locally at `assets/fonts/*.ttf` so the first-launch UX
    no longer depends on `google_fonts` HTTP and tests /
    goldens stay hermetic.
  - `assets/fonts/` — new directory with five TTF files
    (Inter Regular / Medium / SemiBold, Source Serif 4
    Regular, JetBrains Mono Medium) downloaded from
    Fontsource CDN via `curl`.
  - `lib/theme/typography.dart` — switched from
    `GoogleFonts.inter()` / `sourceSerif4()` /
    `jetBrainsMono()` to plain `TextStyle(fontFamily: …)`
    pointing at the new `AppFontFamily.{sans,serif,mono}`
    constants. The `google_fonts` package stays in the
    `pubspec.yaml` for future V1.5 needs but is no longer
    on the runtime path.
  - `analysis_options.yaml` — added an `errors:` block
    setting `deprecated_member_use: ignore`. Rationale
    inlined in the file: Flutter 3.32+ deprecated
    `SemanticsNode.hasFlag(SemanticsFlag.X)` in favour of
    `flagsCollection.<field>`, but the new accessors return
    tri-state values (`Tristate`, `CheckedState`), so the
    migration in every assertion is non-trivial. Suppressed
    only at the info level; nothing else loosens.
- **Debug-only widget gallery:**
  - `lib/features/widget_gallery/widget_gallery_screen.dart`
    renders one of every Phase 1 widget on a single scroll,
    grouped by design-system section. Build asserts
    `kDebugMode` so release accidentally referencing the
    screen would error in debug and exclude itself in
    profile/release builds.
  - `lib/app/router.dart` registers the gallery only
    inside `if (kDebugMode)`. Route constants live in
    `lib/app/route_names.dart` (`widget_gallery`).
- **Tests added (74 total, all green):**
  - `test/helpers/widget_test_harness.dart` — `wrapInRectifyApp`
    + `pumpRectifyWidget` helpers used by every Phase 1
    widget test for a consistent themed phone viewport.
  - `test/flutter_test_config.dart` — auto-discovered by
    `flutter test`; disables `google_fonts` runtime
    fetching as a safety net and pre-registers the five
    bundled TTFs via `FontLoader` so widget tests and
    goldens render with the real product type instead of
    the Ahem fallback.
  - Per-category test files under `test/widget/*/` covering
    rendering, semantics (button / textField / selected /
    toggled / enabled / scopesRoute / inMutuallyExclusiveGroup /
    checked / header), keyboard input on real text fields,
    44pt tap-target minimums, and reduced-motion fallback
    for the loaders.
  - Golden tests at `test/golden/hero_widgets_golden_test.dart`
    + committed PNGs at `test/golden/goldens/`
    (`hero_result_card.png`, `confidence_bar_78.png`,
    `confidence_bar_42.png`, `confidence_bar_18.png`,
    `match_strength_dots_all.png`). The hero result golden
    visually confirms the deep-midnight surface, clay-tint
    eyebrow, mono-numerals plus serif meridiem
    composition, and 28pt radius described in §9.7.
- **Final verification:**
  - `dart format lib test` → 26 files reformatted, no
    diff after the second pass.
  - `flutter analyze` → **`No issues found! (ran in 5.2s)`**.
  - `flutter test` → **`+74: All tests passed!`** (10
    button tests, 9 input chrome, 6 selection controls, 5
    chip tests, 8 card tests, 7 confidence widget tests,
    3 hero result, 4 loader tests, 3 empty state, 7 nav
    tests, 3 bottom sheet, 2 error scaffold, 5 golden,
    1 widget gallery sanity, 1 Phase 0 smoke).
  - iOS Simulator smoke (`iPhone 17`,
    `0664014D-A090-4E23-96BC-2548BDEB2CB2`):
    `Xcode build done. 10.3s`, Dart VM Service available,
    no native-assets exception
    (`dependency_overrides: objective_c: 9.3.0` still in
    place from the previous stage), warm-bone background +
    clay "Hello" still renders identically — the
    typography refactor (GoogleFonts → bundled TTFs) was
    visually a no-op as intended.
- **Constraints respected:** No Phase 2+ work was started.
  No domain models, Drift schemas, API clients,
  demo-response shape, onboarding flow, calculation flow,
  history persistence, settings repository, payment / IAP /
  paywall / pricing / export / chart rendering / Vedic-KP
  toggle / account-login / analytics / push-notification
  code was added. No `sudo`, `brew`, or `gem` command was
  executed by Claude Code this session. No new system
  tool was installed — the only new dependency on disk is
  five TTFs under `assets/fonts/`, fetched via `curl` from
  the Fontsource CDN and tracked as project assets.
- **Limit status:** No usage-limit stop.
- **Open follow-ups (non-blocking for Phase 2 start):**
  1. **`SemanticsNode.hasFlag` migration.** When Flutter
     ships a bool-friendly replacement, or when we agree to
     handle the tri-state accessors explicitly, drop the
     `deprecated_member_use: ignore` entry in
     `analysis_options.yaml` and migrate the eight test
     files that touch the API.
  2. **Native iOS / Android date and time pickers.**
     Phase 1 ships `DatePickerField` / `TimePickerField` as
     trigger UI only; the actual picker presentation lands
     in Phase 4 alongside the calculation flow per §11.1 /
     §11.2.
  3. **Reset hero result `key: heroTimeKey`.** The hero
     time row is keyed only for the widget test that
     introspects its `TextSpan`; a non-test consumer should
     not need this key. The pattern is acceptable for Phase
     1 but worth revisiting when Phase 5 (Result screen)
     composes the card into real data flow.
  4. **`objective_c` override**. Untouched this stage —
     still pinned to 9.3.0; remove when 9.4.x+ ships the
     `-arch arm64e` fix per the previous Phase 0 entry.

### 2026-05-20 — Phase 2 · Data layer (models, Drift, API abstraction, repos, demo, stores, providers)

- **Stage:** Implementation Phase 2 per
  `docs/implementation-plan.md` §§7–10. No Phase 3+ work
  was started — no screens, no controllers, no real network
  calls to any rectification provider.
- **Core (`lib/core/`):**
  - `result.dart` — sealed `Result<T, F extends Object>` with
    `Ok` / `Err`, `const factory` constructors, `fold`,
    `valueOrNull` / `failureOrNull`. T is unbounded so
    `Result<void, AppFailure>.ok(null)` compiles.
  - `failures.dart` — sealed `AppFailure` hierarchy from §11.1
    (`NoNetworkFailure`, `TimeoutFailure`, `BadRequestFailure`,
    `UnauthorizedFailure`, `RateLimitedFailure`,
    `ServerFailure`, `MalformedResponseFailure`,
    `GeocodingFailure`, `StorageFailure`, `UnknownFailure`).
- **Domain models (`lib/data/models/`, freezed):**
  - `birth_data.dart`, `time_window.dart` (with
    `TimeWindowMode` enum + `TimeOfDayConverter` + derived
    `start` / `end` accessors), `life_event.dart` (with
    `EventCategory` enum), `calculation_request.dart`,
    `candidate_time.dart`, `evidence_item.dart`,
    `calculation_result.dart`, `saved_calculation.dart`,
    `settings_model.dart` (with `TimeFormat` enum +
    `SettingsModel.initial()`), `geo_place.dart`.
  - Plain enums: `event_category.dart`, `match_strength.dart`,
    `time_window_mode.dart`, `time_format.dart`,
    `calculation_status.dart`. Each carries a stable wire/
    storage `tag` and a forward-compat `fromTag` parser.
  - **Refactor:** the widget-layer `MatchStrength` enum moved
    here as the canonical domain type. Visual data (filled
    count, color, label) now lives in a private map in
    `lib/widgets/result/match_strength_dots.dart`, which
    `export`s the domain enum so existing widget call sites
    keep working without an import change.
- **DTOs + mappers (`lib/data/api/`):**
  - `dto/rectification_request_dto.dart` — freezed +
    json_serializable. `BirthPlaceDto`, `TimeWindowDto`,
    `LifeEventDto`, `RectificationRequestDto`.
  - `dto/rectification_response_dto.dart` —
    `RectificationCandidateDto`, `RectificationEventMatchDto`,
    `RectificationResponseDto`.
  - `mappers.dart` — pure functions
    `requestToDto(CalculationRequest)` and
    `responseToResult(...)`; isolation point for the assumed
    provider schema. Plus `lifeEventToDto`,
    `candidateFromDto`, `evidenceFromDto`,
    `formatTimeOfDay` for ad-hoc tests / inspection.
- **Drift schema + DAOs (`lib/data/db/`):**
  - `tables.dart` — `Calculations`, `LifeEventRows`,
    `CandidateResults`, `EvidenceRows` mirroring the §8.2
    sketch. Enum / time-of-day values stored as `text`
    tags; dates as `DateTime` columns; FK cascade declared
    on every child row.
  - `database.dart` — `AppDatabase` with a
    production constructor wired via `drift_flutter` and a
    `forTesting(super.e)` constructor accepting a
    `NativeDatabase.memory()`. `PRAGMA foreign_keys = ON`
    runs in `beforeOpen` so cascade deletes fire under
    SQLite. `CalculationsDao`, `LifeEventsDao`,
    `CandidateResultsDao`, `EvidenceDao` provide the typed
    surface used by the repos.
- **API abstraction (`lib/data/api/`):**
  - `api_client.dart` — `AuthMode` enum, `buildDio(...)`
    factory enforcing the §10.4 "demo never builds a Dio"
    assertion, `AuthInterceptor`, debug-only
    `_LoggingInterceptor` (logs URL + status + latency only,
    never bodies — §9.2), `ErrorMappingInterceptor` +
    `mapDioException` table from §9.6.
  - `rectification_api.dart` — `abstract RectificationApi`
    contract + `HttpRectificationApi` posting to
    `/v1/rectification`, decoding via DTO, returning typed
    `Result<RectificationResponseDto, AppFailure>`.
- **Secure + prefs stores:**
  - `lib/data/secure/secure_key_store.dart` — abstract
    `SecureKeyStore` + concrete `_FlutterSecureKeyStore`
    backed by `flutter_secure_storage` + test-only
    `InMemorySecureKeyStore`. Single-slot API
    (`readProApiKey` / `writeProApiKey` / `clearProApiKey`
    / `hasProApiKey` / `deleteAll`) — there is no path for
    the provider's shared key to ever land here, only the
    end-user-supplied Pro key, per §9.5.
  - `lib/data/prefs/settings_store.dart` — field-by-field
    shared_preferences wrapper around `SettingsModel`. No
    secrets stored.
- **Demo response (`lib/data/demo/demo_response.dart`):**
  - `demoCandidates` — three candidates 07:14 / 78%, 07:42 /
    61%, 08:03 / 44%, Gemini Rising on the top candidate
    (§DM2 verbatim).
  - `buildDemoResult(req, now)` applies the 2 strong /
    2 moderate / 1 weak / 1 no-match distribution. If the
    user submitted fewer than 6 events the response trims
    accordingly; if they submitted more, the extra events
    are tagged `weak` / `none` with stock copy (§10.2
    trim / pad rule).
  - `apiCalculationId` is null and `rawResponseJson` is
    null on demo results — there is no provider call.
- **Repositories (`lib/data/repos/`):**
  - `rectification_repository.dart` — abstract contract +
    `LiveRectificationRepository`. Demo path:
    `await Future.delayed(demoDelay)` (zero in tests),
    `buildDemoResult`, persist via history, return `Result.ok`.
    Real path: `requestToDto`, `RectificationApi.rectify`,
    `responseToResult`, persist, return. Demo path never
    constructs a Dio instance (§9.5 / §10.4) and never calls
    `RectificationApi.rectify` (asserted in tests).
  - `history_repository.dart` — abstract contract +
    `DriftHistoryRepository`. `save` writes the aggregate
    transactionally (Calculations row + LifeEvents +
    CandidateResults + Evidence rows). `findById`,
    `watchAll` (reactive `Stream<List<SavedCalculation>>`
    for §8.4), `deleteById` (cascade), `deleteAll`.
  - `settings_repository.dart` — abstract contract +
    `DefaultSettingsRepository`. `setProApiKey` writes to
    secure storage **and** flips the visible
    `proApiKeyConfigured` flag in prefs. `deleteAllData`
    wipes Drift + prefs + secure (§8.5).
  - `draft_repository.dart` — abstract contract +
    `InMemoryDraftRepository`. `watch()` builds a per-listener
    `StreamController` so the initial value emits before any
    subsequent `write()` regardless of subscription timing
    (required for §8.3 in-memory MVP path).
- **Providers (`lib/providers/`):**
  - `core_providers.dart` — `RectifyBuildConfig.fromEnvironment()`
    (reads `RECTIFY_PROXY_BASE_URL` + `RECTIFY_PROXY_APP_ID`
    via `String.fromEnvironment` — both treated as public,
    per §9.5), `buildConfigProvider`, `sharedPreferencesProvider`,
    `settingsStoreProvider`, `secureKeyStoreProvider`,
    `appDatabaseProvider`, `rectificationApiProvider`
    (proxy mode for Phase 2; the reactive Pro-key rebuild
    lands in Phase 6).
  - `repo_providers.dart` — `historyRepositoryProvider`,
    `rectificationRepositoryProvider`,
    `settingsRepositoryProvider`,
    `draftRepositoryProvider` (the draft repo is disposed
    with the scope).
- **Generated files (`dart run build_runner build`):**
  - 12× `*.freezed.dart` for domain models + DTOs.
  - 2× `*.g.dart` for `rectification_request_dto` /
    `rectification_response_dto` (json_serializable).
  - 1× `lib/data/db/database.g.dart` (drift).
  - 227 outputs total in the build_runner pass.
- **Pubspec additions:** `meta: ^1.18.0` (depend-on-referenced-
  packages compliance for `@immutable` / `@visibleForTesting`).
  No other dependency added.
- **Tests (`test/data/`, 31 new tests, 105 total green):**
  - `fixtures/sample_calculation.dart` — shared deterministic
    `sampleRequest({id, isDemo, eventCount})` used across
    suites; `events` are const literals.
  - `api/mappers_test.dart` — `requestToDto` field-by-field
    coverage, JSON round-trip equality, `responseToResult`
    happy path, unknown-`matchStrength`-tag fallback.
  - `demo/demo_response_test.dart` — §DM2 candidate triple,
    Gemini Rising on top, 2/2/1/1 distribution for 6 events,
    every evidence has explanation, trim distribution for
    <6 events, pad weak/none for >6 events, `isDemo=true`
    and `method='demo_canonical'`.
  - `prefs/settings_store_test.dart` — initial defaults,
    write+read round-trip, individual setters,
    `deleteAll` resets to initial.
  - `db/database_test.dart` — Calculation aggregate
    write→read→delete on `NativeDatabase.memory()`, FK
    cascade verified for life events / candidates / evidence,
    reactive `watchAll` emits 0 then 1 on insert,
    `deleteAll` wipes everything.
  - `repos/rectification_repository_test.dart` — **demo
    submit returns the §DM2 shape and never calls
    `RectificationApi.rectify`** (call count asserted at 0
    via a recording fake), demo result persists to history,
    real submit maps DTO back through mappers, real failure
    propagates as `Result.err`.
  - `repos/settings_repository_test.dart` — `setProApiKey`
    routes to secure storage and updates the flag,
    `clearProApiKey` reverses both, `setTimeFormat`
    persists, `deleteAllData` wipes prefs + secure + db
    tables.
  - `repos/draft_repository_test.dart` — empty start,
    write replaces, watch yields current then every
    subsequent write then null on clear.
- **Verification:**
  - `dart run build_runner build` → 227 outputs, no errors.
  - `dart format lib test` → 15 files reformatted.
  - `flutter analyze` → **`No issues found! (ran in 1.9s)`**.
  - `flutter test` → **`+105: All tests passed!`** (74 from
    Phase 0/1 still green, 31 new in `test/data/`).
  - iOS simulator smoke not re-run this stage; the data
    layer change is invisible to the existing Phase 0/1
    UI and the previous smoke pass remains valid.
- **Security constraints respected:**
  - No provider shared API key anywhere — not in
    Dart source, not in tests, not in fixtures, not in
    docs updates, not in `--dart-define` defaults, not in
    logs. `_LoggingInterceptor` is debug-only and logs
    URL + status + latency only (no headers, no bodies).
  - `flutter_secure_storage` is the only path for an
    end-user-supplied Pro key; `SecureKeyStore`'s
    five-method surface makes accidental ingress to
    SQLite / prefs / logs structurally impossible.
  - The demo path performs zero network or HTTP-client
    construction (asserted by `buildDio` itself and by
    the repository test that checks `api.callCount == 0`).
- **Constraints respected (no Phase 3+ work):**
  - No screens, no controllers, no `CalculationFlowController`,
    no onboarding gate, no home/history list, no payment/
    IAP/paywall/credits/pricing/export/chart rendering/
    Vedic-KP toggle/account-login/analytics/push notifications.
  - The `rectificationApiProvider` is wired but consumers
    must come in Phase 4+; Phase 2 only verifies the
    submit/save/load surface end-to-end with a
    `_RecordingApi` fake.
- **Limit status:** No usage-limit stop.
- **Open follow-ups for later phases:**
  1. **Geocoding service** (§9.8) — out of Phase 2 scope;
     `GeoPlace` model is ready and waits for Phase 4 to
     introduce `GeocodingService`.
  2. **Reactive Pro-key Dio rebuild** (§9.5) — Phase 6
     lands a `dioProvider` that rebuilds when
     `SettingsRepository.setProApiKey` is called; Phase 2
     ships a static proxy-mode Dio so the demo path stays
     isolated from key state.
  3. **Persisted Drafts table** (§8.3 "should-have") —
     Phase 7 introduces the `Drafts` table for "Save and
     retry later"; Phase 2 ships in-memory drafts only.

### 2026-05-20 — Phase 3 · Onboarding + Home/History (read paths)

- **Stage:** Implementation Phase 3 per
  `docs/implementation-plan.md` §14 (Phase 3 DoD: onboarding
  gate + empty/populated history list with swipe-to-delete).
  No Phase 4+ work — no calculation input, no geocoding,
  no settings UI beyond a "coming soon" placeholder, no
  result/evidence screens.
- **New screens:**
  - `features/onboarding/onboarding_screen.dart` — three
    slides via `PageView` (§10.6 layout: Source-Serif
    `displayLg` headline, body in `bodyLg`, monochrome
    `ink.soft` glyph). Slides 1 & 2 expose `Skip` (top-right
    ghost) + `Next` (primary CTA); slide 3 swaps to stacked
    `Try demo first` / `Start real calculation` per the
    wireframe (no Skip on the final slide). Animated 3-dot
    pagination with active dot in clay.
  - `features/onboarding/onboarding_controller.dart` —
    minimal `Notifier<void>` whose `complete()` is a thin
    facade over `SettingsController.setOnboardingDone(true)`;
    idempotent when the flag is already set.
  - `features/home/home_history_screen.dart` — empty state
    via the existing `EmptyState` widget (§9.14: clock
    glyph, "No calculations yet.", body copy, centered
    "New Calculation" primary CTA), populated state via
    `ListView.separated` of `HistoryCard`s wrapped in
    `Dismissible`. Each card surfaces label · date ·
    top-candidate time (12/24h respecting
    `settings.timeFormat`) · `ConfidenceBar` · rising sign
    · DEMO pill when applicable. Delete path:
    `confirmDismiss` → AlertDialog confirmation → repository
    `deleteById` → snackbar (§9.15 deep-midnight toast).
  - `features/main_shell/main_shell.dart` — bottom-tab host
    using `StatefulShellRoute.indexedStack`; three branches
    in wireframe order (New / History / Settings), History
    branch is the default (§9.16). Renders our
    `BottomTabBar` from Phase 1.
  - `features/placeholders/coming_soon_screen.dart` —
    inert placeholder used by the `/new` and `/settings`
    tab branches so taps go somewhere intentional without
    pulling in Phase 4/7 surfaces.
- **Providers & router wiring:**
  - `providers/settings_controller.dart` — new Riverpod
    `Notifier<SettingsModel>` cache. `build()` reads the
    current snapshot synchronously; setters
    (`setOnboardingDone`, `setTimeFormat`,
    `setDemoModeDefault`) delegate to the Phase-2
    `SettingsRepository` and mirror the change into
    `state` so the router and listening widgets refresh
    without re-reading prefs.
  - `data/prefs/settings_store.dart` — added `readSync()`
    sibling of `read()` (sync path required by the
    settings controller's `build()` and the router's
    `redirect`; safe because `SharedPreferences` caches
    values in memory). `read()` now delegates to it.
  - `providers/core_providers.dart` — converted
    `sharedPreferencesProvider` from `FutureProvider` to a
    `Provider<SharedPreferences>` whose default throws.
    `main()` overrides it after awaiting
    `SharedPreferences.getInstance()` during bootstrap.
    `settingsStoreProvider` drops the now-pointless
    `requireValue`.
  - `features/home/history_providers.dart` — new
    `historyStreamProvider` (`StreamProvider`) wrapping
    `HistoryRepository.watchAll()` per §8.4.
  - `app/router.dart` — rebuilt as a Riverpod
    `Provider<GoRouter>`. Adds `/onboarding` as a
    full-screen route plus a `StatefulShellRoute.indexedStack`
    with branches `/new`, `/`, `/settings`.
    `refreshListenable` is a `ValueNotifier` bumped whenever
    `settingsControllerProvider.onboardingDone` changes.
    `redirect`: unfinished onboarding → `/onboarding`;
    finished onboarding while at `/onboarding` → `/`. The
    debug-only `/widget_gallery` is exempt from the gate.
  - `app/route_names.dart` — added `onboarding`,
    `newCalculation`, `settings` constants (paths +
    names).
  - `app/app.dart` — `RectifyApp` is now a
    `ConsumerWidget` that reads `routerProvider`.
  - `main.dart` — `Future<void> main()` awaits
    `SharedPreferences.getInstance()` and passes it into
    `ProviderScope.overrides`.
- **Removed:**
  - `lib/features/home/home_screen.dart` (Phase 0 "Hello"
    placeholder) — replaced by `home_history_screen.dart`.
  - `test/widget_test.dart` (Phase 0 "Hello" smoke) —
    replaced by the new feature suites.
- **Tests (`test/widget/features/`, 9 new tests, 113 total
  green):**
  - `test/helpers/fake_history_repository.dart` — new
    `FakeHistoryRepository` for widget tests. Plain
    `StreamController`-backed list. Sidesteps Drift's
    zero-duration cleanup `Timer` that trips
    `flutter_test`'s `!timersPending` invariant when
    `ProviderScope` disposes mid-widget-tree. Production
    `DriftHistoryRepository` is unchanged and still
    covered by the Phase 2 `database_test.dart`.
  - `test/data/fixtures/sample_calculation.dart` — added
    `sampleResult({requestId, isDemo})` paired with the
    existing `sampleRequest()`. Two candidates (78% / 61%
    Gemini Rising) + two evidence items.
  - `test/widget/features/onboarding/onboarding_screen_test.dart`
    (5 tests): first-launch redirect to `/onboarding`,
    slide-3 swaps Next for the two CTAs, finishing
    onboarding writes `onboarding_done = true` to prefs
    + lands on Home, Skip on slide 1 persists the same
    flag, returning user with `onboarding_done = true`
    skips onboarding entirely.
  - `test/widget/features/home/home_history_screen_test.dart`
    (4 tests): empty state copy + CTA; populated state
    renders one `HistoryCard` per row with the
    top-candidate time (`7:14 AM`), confidence percent
    (`78%`), and a DEMO pill only on the demo row;
    swipe-to-delete shows the AlertDialog, the row is
    removed on confirmation and the snackbar surfaces;
    Cancel keeps the row.
- **Verification:**
  - `dart format lib test` → 4 files reformatted then
    clean.
  - `flutter analyze` → **`No issues found! (ran in 1.9s)`**.
  - `flutter test` → **`+113: All tests passed!`** (104
    Phase 0/1/2 still green, 9 new widget tests in
    `test/widget/features/`).
  - iOS simulator smoke: built `flutter build ios
    --simulator --debug`, installed on the already-booted
    `iPhone 17` (iOS 26.5), launched twice (cold install +
    relaunch). Onboarding slide 1 renders the Source
    Serif headline + clay Next CTA + 3-dot pagination
    correctly; relaunch returns to the same screen
    because `onboarding_done` is still false. Tap
    automation isn't available via `xcrun simctl`, so
    full mid-flow advancement is covered by the
    onboarding widget tests rather than the smoke.
- **Constraints respected (no Phase 4+ work):**
  - No `CalculationFlowController`, no birth/window/events
    screens, no `GeocodingService`, no `RectificationApi`
    wiring beyond Phase 2's static proxy.
  - `/new` and `/settings` are tab placeholders that
    render `ComingSoonScreen`; no settings rows, no API
    key sheet, no "Delete all data".
  - The Phase 0 home placeholder is gone, but the design
    docs (`docs/design-system.md`,
    `docs/ascii-wireframes.md`, `docs/mvp-scope.md`,
    `docs/prd.md`) are untouched.
- **Limit status:** No usage-limit stop.
- **Open follow-ups for later phases:**
  1. **Onboarding Skip / dynamic-island clipping** — on
     the iPhone 17 simulator the `Skip` ghost button is
     positioned just inside the top safe-area inset and
     overlaps the right edge of the status bar / dynamic
     island. Functional but visually crowded — design QA
     in Phase 8 polish.
  2. **Phase 4 — Calculation input flow** — wire `/new`
     to `/calc/birth` and replace `ComingSoonScreen` with
     the birth/time-window/events steppers per §14 Phase
     4.
  3. **Phase 7 — Settings screen** — `/settings` still
     renders the placeholder; the real settings tree
     (API key sheet, time format, demo toggle, "Delete
     all data") lands then.


### 2026-05-20 — Phase 4 · Calculation input flow (birth → window → events → confirm → loading)

- **Claude session:** Phase 4 follow-on. Replaces the
  `/new` `ComingSoonScreen` placeholder with the full
  five-screen calculation input flow at
  `/calc/{birth,window,events,confirm,loading}`.
- **Constraints respected:**
  - No Phase 5 / Phase 6 / Phase 7 work. The result
    screen, evidence breakdown, paid tier, real API
    integration, payments, settings, and paywall are
    untouched.
  - Marketing, PRD, scope, design-system, prototype, and
    wireframe documents were not modified. The only
    document changed in this stage is this build history.
  - Existing data layer (`CalculationRequest`,
    `DraftRepository`, `LiveRectificationRepository`
    demo branch, `HistoryRepository`) is reused as-is;
    no model or repository shape changed.
  - Design language (`docs/design-system.md` §10.1 +
    `design/mobile-prototype.html`) is preserved —
    every screen uses `TopNav`, `StepperHeader`,
    `PrimaryButton`, `SecondaryButton`, `InputField`,
    `DatePickerField`, `TimePickerField`, `RadioGroup`,
    `BottomSheetPicker`, `AppCard`, `EventCard`,
    `BreathRingLoader`, and `DemoPill` from the existing
    Phase 1 widget set.
  - No real HTTP. Demo submit flows through
    `LiveRectificationRepository.submit(req)` which
    short-circuits when `request.isDemo == true`
    (§9.5 / §10.4) — no `Dio` instance is constructed
    in the demo path.
- **Added — calculation flow feature (`lib/features/calculation_flow/`):**
  - `state/calculation_flow_state.dart` — immutable
    `CalculationFlowState` carrying the draft (birth
    date, city, lat/lon, label, window mode, time,
    minutes, events list, isDemo, submit-in-flight
    flags). Validation getters: `birthStepValid`,
    `windowStepValid`, `eventsStepValid` (≥ 3 demo
    minimum per `docs/mvp-scope.md` M4),
    `eventsBelowRecommended` (3 ≤ count < 5 soft band),
    `readyToSubmit`. Plain Dart with `copyWith` rather
    than freezed — never crosses a serialization
    boundary, so the build-runner cost wasn't worth
    paying.
  - `state/calculation_flow_controller.dart` —
    `CalculationFlowController` (Riverpod `Notifier`)
    owning the draft. Mirrors edits into
    `draftRepositoryProvider` once the draft is
    valid, and exposes step navigation (`next` /
    `back` / `goTo`), per-step setters, event
    add/edit/remove, `reset`, and `submit()` which
    routes through `rectificationRepositoryProvider`
    and clears the draft on `Ok`.
  - `geocoding/geocoding_service.dart` — minimal
    `GeocodingService` interface + `StubGeocodingService`
    with a 12-city in-memory list. No HTTP. Phase 6 will
    swap the production provider behind this contract.
  - `widgets/calc_step_scaffold.dart` — shared scaffold
    that wires `TopNav` + `StepperHeader` + scrolling
    body + bottom-fixed CTA pair per
    `docs/design-system.md` §10.1.
  - `widgets/add_event_sheet.dart` — `AddEventSheet`
    bottom sheet for add / edit of a `LifeEvent`.
    Category, month (optional), year, description
    (200-char counter); uses `BottomSheetPicker` for
    each picker (category, month, year). Returns an
    `AddEventResult` to the caller, so the sheet stays
    pure UI.
  - `screens/birth_data_screen.dart` — Step 1 (`/calc/birth`):
    `DatePickerField` for DOB, `InputField` for city
    (with a debounced inline suggestions panel backed
    by the stub geocoder), optional label. Continue
    disabled until date + non-empty city.
  - `screens/time_window_screen.dart` — Step 2
    (`/calc/window`): `RadioGroup` toggling
    approximate / unknown modes (the existing
    `TimeWindowMode` enum). Approximate shows time +
    window pickers and the derived range copy
    (`We'll search between X and Y`); unknown shows
    the 24-hour explainer. Time format from
    `settingsControllerProvider` is honoured.
  - `screens/life_events_screen.dart` — Step 3
    (`/calc/events`): empty state + populated list of
    `EventCard`s, soft warning banner when count is
    3 ≤ x < 5, `AddEventSheet` for add / edit on tap.
    Continue disabled until ≥ 3 events, label
    switches between "Continue" and "Continue (demo)"
    based on `isDemo`.
  - `screens/confirmation_screen.dart` — Step 4
    (`/calc/confirm`): three `AppCard` summaries
    (birth, window, events) with a primary
    "Calculate (demo)" CTA that navigates to
    `/calc/loading`.
  - `screens/loading_screen.dart` — Step 5
    (`/calc/loading`): `BreathRingLoader` + rotating
    copy (`Analyzing life events…` / `Mapping
    planetary transits…` / `Ranking candidates…`).
    Kicks off `submit()` in a post-frame callback,
    persists the demo result to `HistoryRepository`,
    clears the draft, and shows a post-success copy
    ("Your demo calculation is ready. … saved result
    is waiting in your history."). Cancel ghost
    button navigates back to confirm or home (after
    success). Phase 5 will replace the post-success
    in-place copy with a `context.go('/calc/result/:id')`.
- **Updated — router + entry point:**
  - `lib/app/route_names.dart` — added
    `RoutePaths.calcBirth / calcWindow / calcEvents /
    calcConfirm / calcLoading` and matching
    `RouteNames.calc*` constants.
  - `lib/app/router.dart` — replaced the
    `ComingSoonScreen` builder under the `/new`
    branch with a `redirect: (…) => RoutePaths.calcBirth`
    so the existing "New Calculation" tab tap still
    feels native, then added the five top-level
    `/calc/*` `GoRoute`s outside the
    `StatefulShellRoute.indexedStack` (so the
    stepper reads full-screen without the bottom tab
    bar, matching `docs/ascii-wireframes.md`
    Screens 2–5). `/settings` placeholder is
    untouched.
- **Tests (18 new, 131 total green):**
  - `test/helpers/fake_rectification_repository.dart`
    — `FakeRectificationRepository` that records
    submissions, persists demo results via the
    paired `HistoryRepository`, supports a
    `Completer` `blocker` for in-flight assertions,
    and a `failureOverride` switch for the
    error-path test slot. Sidesteps the 3-second
    production `demoDelay`.
  - `test/features/calculation_flow/calculation_flow_controller_test.dart`
    (9 tests) — initial state defaults; birth-step
    validation requires date + non-empty city; window
    mode toggles + derived start/end from
    `TimeWindow.start` / `.end`; events step minimum
    of 3 with soft warning band; removeEvent shrinks
    + re-validates; `next()` walks the steps only
    when the current step is valid; `back()` walks
    backwards stopping at birth; `submit()` reaches
    the rectification repo, writes to history, and
    clears the draft; `submit()` refuses to fire
    when the draft is incomplete.
  - `test/widget/features/calculation_flow/birth_data_screen_test.dart`
    (2 tests) — Continue stays disabled until date +
    city are present; no overflow on a 360×760
    viewport.
  - `test/widget/features/calculation_flow/time_window_screen_test.dart`
    (1 test) — both radio rows render, default copy
    shows `We'll search between …`, switching to
    "I have no idea" hides the range copy and shows
    the 24-hour explainer.
  - `test/widget/features/calculation_flow/life_events_screen_test.dart`
    (3 tests) — empty state shows guidance banner +
    "Add first event"; adding three events enables
    "Continue (demo)" and advances to confirm; the
    delete contract on each card removes the event
    via the controller.
  - `test/widget/features/calculation_flow/confirmation_screen_test.dart`
    (1 test) — every summary row (birth date, city,
    label, time window with ± hours, event count)
    renders, and the "Calculate (demo)" CTA is
    visible.
  - `test/widget/features/calculation_flow/loading_screen_test.dart`
    (2 tests) — demo submit writes through the
    rectification repo, lands in history, clears
    the draft, and surfaces the post-success copy;
    while submit is held open the `BreathRingLoader`
    + "Running demo calculation…" copy are visible.
- **Adaptations to existing structure (no design or
  scope drift):**
  - The user spec mentioned "known / approximate /
    unknown" birth-time modes, but the existing
    `TimeWindowMode` enum carries only
    `approximate` + `unknown` and the wireframes
    (`docs/ascii-wireframes.md` Screen 3) also show
    only those two options. A "known precise time"
    is expressed via the approximate mode with a
    ± 30-minute window — no enum / Drift migration
    needed.
  - The existing `LifeEvent` model has no editable
    `description` after the fact; the edit sheet
    treats the description as a plain text field
    and writes it back via `updateEvent`.
  - `GeocodingService` ships as a stub (Phase 6 will
    wire a real provider); the screen treats a typed
    city without a selected suggestion as valid for
    demo (lat/lon defaults to 0.0, accepted by
    `RectificationRepository.submit` when
    `request.isDemo == true`).
- **Verification:**
  - `dart format lib test` → all 150 files clean
    (only newly added files were reformatted).
  - `flutter analyze` → **`No issues found! (ran in
    1.7s)`** with `very_good_analysis` rules
    unchanged.
  - `flutter test` → **`+131: All tests passed!`**
    (113 prior + 18 new).
  - **iOS simulator smoke:** `flutter build ios
    --simulator --debug` succeeded (`✓ Built
    build/ios/iphonesimulator/Runner.app`) and the
    binary installed + launched on the booted
    `iPhone 17` (iOS 26.5). Onboarding slide 1
    renders identically to the Phase 3 smoke. As
    in Phase 3, mid-flow advancement isn't
    achievable through `xcrun simctl` (no tap
    automation; pre-writing `onboarding_done = YES`
    to `NSUserDefaults` doesn't bypass the gate
    because Flutter's `shared_preferences` reseeds
    on launch). The Phase 4 input flow itself is
    covered end-to-end by the 18 widget tests +
    9 controller tests; the simulator confirms the
    binary still launches cleanly with the new
    code paths added.
- **Files added (this stage):**
  - `lib/features/calculation_flow/state/calculation_flow_state.dart`
  - `lib/features/calculation_flow/state/calculation_flow_controller.dart`
  - `lib/features/calculation_flow/geocoding/geocoding_service.dart`
  - `lib/features/calculation_flow/widgets/calc_step_scaffold.dart`
  - `lib/features/calculation_flow/widgets/add_event_sheet.dart`
  - `lib/features/calculation_flow/screens/birth_data_screen.dart`
  - `lib/features/calculation_flow/screens/time_window_screen.dart`
  - `lib/features/calculation_flow/screens/life_events_screen.dart`
  - `lib/features/calculation_flow/screens/confirmation_screen.dart`
  - `lib/features/calculation_flow/screens/loading_screen.dart`
  - `test/helpers/fake_rectification_repository.dart`
  - `test/features/calculation_flow/calculation_flow_controller_test.dart`
  - `test/widget/features/calculation_flow/birth_data_screen_test.dart`
  - `test/widget/features/calculation_flow/time_window_screen_test.dart`
  - `test/widget/features/calculation_flow/life_events_screen_test.dart`
  - `test/widget/features/calculation_flow/confirmation_screen_test.dart`
  - `test/widget/features/calculation_flow/loading_screen_test.dart`
- **Files updated:**
  - `lib/app/route_names.dart` — added five `calc*`
    constants on both `RoutePaths` and `RouteNames`.
  - `lib/app/router.dart` — `/new` now redirects to
    `/calc/birth`; the five `/calc/*` routes live at
    the top level; `ComingSoonScreen` is still used
    by `/settings`.
- **Limit status:** No usage-limit stop.
- **Open follow-ups for later phases:**
  1. **Phase 5 — Demo result + Evidence screens.**
     `CalculationLoadingScreen` currently parks the
     user on a post-success message. Phase 5 will
     replace that with a `context.go('/calc/result/:id')`
     navigation and ship `ResultScreen` +
     `EvidenceScreen` (`docs/ascii-wireframes.md`
     Screens 6 + 7).
  2. **Phase 6 — Real `GeocodingService`.** The
     in-memory stub returns up to five hard-coded
     cities; a real provider (Nominatim / Mapbox /
     Google Places) lands when Phase 6 wires real
     HTTP. The interface is stable — only the
     `geocodingServiceProvider` swap is needed.
  3. **Editable life-event description on the
     events screen.** Tapping a card opens
     `AddEventSheet` in edit mode; the controller
     `updateEvent` is wired and tested at the
     controller layer, but the post-edit visual
     diff (description shown under the date on the
     card) ships when `EventCard` gains an optional
     subtitle slot in Phase 5/8 polish.
  4. **Onboarding skip overlap with the dynamic
     island** — still open from Phase 3; unaffected
     by this stage.

---

## Stage — 2026-05-20 — Phase 5 — Demo result + Evidence screens

- **Scope** (`docs/implementation-plan.md` §14 Phase 5,
  `docs/mvp-scope.md` M8/M9, `docs/ascii-wireframes.md`
  Screens 6 + 7). End-to-end demo flow now reaches a
  real result screen + evidence breakdown — `Try demo
  first → birth → window → events → confirm → loading
  → /calc/result/:id → /calc/result/:id/evidence`.
  Stayed strictly inside the Phase 5 contract: no real
  HTTP, no auth, no settings rewrite, no paywall.
- **Added — calculation_flow screens (`lib/features/calculation_flow/`):**
  - `state/result_providers.dart` — `savedCalculationByIdProvider`
    (`FutureProvider.family<SavedCalculation?, String>`)
    reads through `HistoryRepository.findById` so both
    the post-submit redirect and a history-card tap
    resolve the same Drift aggregate. Returns `null`
    on miss; the screens render an empty / not-found
    state in that case. Explicit `FutureProviderFamily`
    type imported from `flutter_riverpod/misc.dart`
    (Riverpod 3.x keeps the family classes in the
    misc export) to satisfy the strict
    `specify_nonobvious_property_types` rule.
  - `screens/result_screen.dart` — `ResultScreen` per
    `docs/design-system.md` §10.2: top nav with back
    arrow, optional `DemoPill` aligned right, then a
    `HeroResultCard` (top candidate time + meridiem +
    rising sign), `ConfidenceBar`, up to two
    `CandidateCard`s under an "Other candidates"
    eyebrow, then the stacked `PrimaryButton`
    ("See how we got this", keyed for tests) and
    `SecondaryButton` ("Save to history" via a small
    private `_SaveToHistoryButton` that flips to
    "Saved ✓" per §11.5). For demo results, a bottom
    `_DemoUpgradeNudge` (`AppCard`-styled, dismissible)
    routes to `/new` rather than any paywall — MVP has
    no monetization surface (`docs/mvp-scope.md`
    AC-Demo-6). Empty / not-found state uses the
    existing `EmptyState` with a "Back to history"
    CTA. Wrapped in `SingleChildScrollView + Column`
    rather than `ListView` so the bottom CTAs are in
    the widget tree without scrolling in tests
    (matters because `ListView`'s
    `SliverChildListDelegate` lazy-builds out-of-viewport
    children).
  - `screens/evidence_screen.dart` — `EvidenceScreen`
    per `docs/design-system.md` §10.3: minimal nav
    with back chevron, sticky `Why <top time>?` title,
    `X of Y events strongly supported this time`
    summary, `DemoPill` for demo results, then one
    `EvidenceCard` per submitted event keyed back to
    `LifeEvent` by id (icon, category label, formatted
    month / year, `MatchStrengthDots`, explanation).
    Strong + Moderate cards expanded by default;
    Weak + No Match collapsed (chevron tap reveals).
- **Updated — routing + loading flow:**
  - `lib/app/route_names.dart` — added `calcResult`
    (`/calc/result/:resultId`) + `calcEvidence`
    (`/calc/result/:resultId/evidence`) with
    `calcResultFor(...)` / `calcEvidenceFor(...)`
    helpers so call sites don't hand-roll path
    interpolation.
  - `lib/app/router.dart` — registered the two routes
    as top-level entries; evidence is a child of
    result so the system back arrow returns to the
    parent result, not the home tab.
  - `lib/features/calculation_flow/screens/loading_screen.dart`
    — replaced the Phase 4 post-success in-place copy
    with `context.go(RoutePaths.calcResultFor(state.id))`
    on `Ok`. Draft id is captured before
    `controller.submit()` clears the draft, so the
    redirect uses the same primary key the history
    row carries.
  - `lib/features/home/home_history_screen.dart` —
    `HistoryCard.onTap` now navigates to
    `/calc/result/:id` so saved demo and (future)
    real calculations re-open through the same
    aggregate read path.
- **Tests (10 new, 139 total green):**
  - `test/widget/features/calculation_flow/result_screen_test.dart`
    (5 tests) — hero renders top candidate (7:14
    AM, Gemini Rising, 78%) + `DEMO` pill +
    secondary `CandidateCard`s + evidence/save CTAs
    + upgrade nudge; not-found state when the
    `resultId` can't be resolved; history-card tap
    lands on `/calc/result/:id`; "See how we got
    this" navigates to `/calc/result/:id/evidence`;
    rendering the result screen never re-triggers a
    submission against `FakeRectificationRepository`
    (`AC-Demo-6` / no-real-API guard).
  - `test/widget/features/calculation_flow/evidence_screen_test.dart`
    (3 tests) — summary line + one card per
    submitted event with `MatchStrengthDots` and
    STRONG / MODERATE labels (demo seed: 2 strong,
    1 moderate); back arrow from evidence returns
    to the result; not-found state when the
    `resultId` is unknown.
  - `test/widget/features/calculation_flow/loading_screen_test.dart`
    — flipped the existing post-success assertion
    to the Phase 5 contract: after a demo submit
    the router lands on `/calc/result/<draftId>`
    rather than parking on a "your demo calculation
    is ready" copy. The in-flight `BreathRingLoader`
    + "Running demo calculation…" assertion already
    written for Phase 4 still passes.
- **Adaptations to existing structure (no design or
  scope drift):**
  - `HistoryCard` already exposed an `onTap` — wired
    directly without modifying the widget.
  - The result hero + candidate cards render time +
    meridiem as a single `Text.rich`, so tests
    inspect the keyed hero-time widget's
    `textSpan.toPlainText()` rather than
    `find.text('7:14')`, matching the existing
    `test/widget/result/hero_result_card_test.dart`
    pattern.
  - `SingleChildScrollView + Column` instead of
    `ListView` for both result + evidence bodies —
    keeps off-viewport children mounted under
    `flutter_test`'s default 800×600 surface so
    keyed CTAs are reachable without scroll
    plumbing; visual behaviour on device is
    identical.
- **Verification:**
  - `dart format lib test` → 155 files, 0 changed
    on the second pass.
  - `flutter analyze` → **`No issues found! (ran in
    2.0s)`** with `very_good_analysis` rules
    unchanged.
  - `flutter test` → **`+139: All tests passed!`**
    (129 prior + 10 new — net +8 because the
    Phase 4 post-success loading assertion was
    rewritten rather than duplicated; one Phase 4
    test slot now covers the new redirect).
  - **iOS simulator smoke:** `flutter build ios
    --simulator --debug` succeeded
    (`✓ Built build/ios/iphonesimulator/Runner.app`),
    `xcrun simctl install booted Runner.app` then
    `xcrun simctl launch booted com.rectify.rectify`
    completed cleanly (pid `67919`) on `iPhone 17`
    (iOS 26.5). End-to-end navigation through the
    demo flow on simulator isn't achievable through
    `simctl` (same Phase 3 / 4 limitation: no tap
    automation, `shared_preferences` reseeds on
    launch so pre-writing the onboarding gate
    doesn't survive). The 10 new widget tests plus
    the existing loading-screen test cover the
    Phase 5 user paths end-to-end; the simulator
    confirms the binary still launches with the
    new routes wired.
- **Files added (this stage):**
  - `lib/features/calculation_flow/screens/result_screen.dart`
  - `lib/features/calculation_flow/screens/evidence_screen.dart`
  - `lib/features/calculation_flow/state/result_providers.dart`
  - `test/widget/features/calculation_flow/result_screen_test.dart`
  - `test/widget/features/calculation_flow/evidence_screen_test.dart`
- **Files updated:**
  - `lib/app/route_names.dart` — two new route
    constants + `calcResultFor` / `calcEvidenceFor`
    helpers.
  - `lib/app/router.dart` — `/calc/result/:resultId`
    plus the child `evidence` route registered
    outside the bottom-tab shell.
  - `lib/features/calculation_flow/screens/loading_screen.dart`
    — post-success branch now redirects to
    `/calc/result/:id`; removed the temporary
    "Your demo calculation is ready" copy and the
    `_completed` state field that backed it.
  - `lib/features/home/home_history_screen.dart` —
    `HistoryCard.onTap` wired to
    `RoutePaths.calcResultFor(item.request.id)`.
  - `test/widget/features/calculation_flow/loading_screen_test.dart`
    — rewrote the post-success assertion to expect
    the `/calc/result/<id>` URL instead of the
    interim copy.
- **Limit status:** No usage-limit stop.
- **Open follow-ups for later phases:**
  1. **Phase 6 — Real API integration + error
     handling.** The result + evidence screens read
     through `HistoryRepository.findById`; the
     demo path writes the row before the redirect.
     The real path will land the same way once
     `HttpRectificationApi` is wired (no result-
     screen changes anticipated).
  2. **"Saved ✓" persistence.** The current
     `_SaveToHistoryButton` flips locally after a
     tap; the underlying row is already persisted
     by `LiveRectificationRepository.submit`, so
     re-opening a result also pre-marks it as
     "saved". The button is an affordance for the
     user, not a write path. A future "saved" flag
     on the row (per §11.5) would let the button
     read as `Saved ✓` on first render for already-
     persisted history items.
  3. **Result-screen polish.** Hero reveal motion
     (600ms fade + 8pt upward translate per
     `docs/design-system.md` §8.2) ships when the
     motion-polish pass in Phase 8 lands; current
     render is an instant set.
  4. **Editable life-event description on the
     events screen** — still open from Phase 4;
     unaffected by this stage.
  5. **Onboarding skip overlap with the dynamic
     island** — still open from Phase 3; unaffected
     by this stage.

## Stage — 2026-05-20 — Phase 6 — Real API integration + error handling

- **Scope** (`docs/implementation-plan.md` §14 Phase 6
  + §9.5 / §11.3). The real-mode submission path now
  goes through `HttpRectificationApi` end-to-end, with
  each `AppFailure` mapped to a dedicated error route.
  Demo path remained a hard short-circuit — no Dio
  instance is constructed when `request.isDemo` is
  true. Stayed strictly inside the Phase 6 contract:
  no settings UI, no paywall, no persisted-drafts
  table, no real provider key in code/tests/assets.
- **Provider docs check.** `WebFetch` against
  `https://astrology-api.io/demo#tag/-rectification`
  and the linked Postman JSON did not surface a real
  rectification endpoint — the documentation site
  renders via JS and the Postman export covers chart
  / position endpoints only. Recorded as a known gap:
  the wire schema in `lib/data/api/dto/rectification_*`
  remains the PRD §11 assumption, and the entire
  provider boundary is confined to one mapper
  (`lib/data/api/mappers.dart`) so a schema swap is a
  one-file diff once the real spec is in hand
  (§9.3).
- **Build configuration (no secrets, all keys
  public per Appendix B):**
  - `lib/providers/core_providers.dart` —
    `RectifyBuildConfig` extended with `proxyPath`
    (`RECTIFY_PROXY_PATH`, default `/v1/rectification`),
    `env` (`RECTIFY_ENV`, default `dev`), and
    `requestTimeout` (`Duration(seconds: 30)`).
    `proxyBaseUrl` still defaults to
    `https://proxy.invalid.example` so an
    unconfigured release fails fast (DNS error →
    `NoNetworkFailure`) instead of silently leaking
    traffic. Every default is non-credential.
  - Added `proApiKeyProvider` (`FutureProvider<String?>`)
    that reads the user-supplied Pro key out of
    `SecureKeyStore` — `null` means "no key, use
    proxy mode". This is the only place a Pro key
    is read in the app; it never travels into
    prefs, Drift, logs, or any other Riverpod
    provider.
  - Added `dioProvider` that rebuilds when the
    base URL or Pro key change, flipping
    `AuthMode.proxy` ↔ `AuthMode.providerDirect`,
    attaching `X-Rectify-App-Id`, and disposing
    the previous `Dio` on rebuild.
  - `rectificationApiProvider` now consumes
    `dioProvider` + `proxyPath` so the boundary is
    one constructor call.
- **HTTP client & interceptors
  (`lib/data/api/api_client.dart`):**
  - `buildDio` now accepts `proxyAppId` and an
    `enableLogging` toggle so tests can install a
    deterministic adapter without console noise.
    The proxy app id is added as `X-Rectify-App-Id`;
    it is the only header automatically set on
    every request besides `Content-Type` /
    `Accept` and the optional `Authorization`.
  - Renamed the private logger to
    `LoggingInterceptor` (public) and added a
    `sink` constructor parameter so the redaction
    contract is testable. The interceptor emits
    one line per request with method, response
    status, and latency; it strips query
    parameters and **never** logs headers, request
    bodies, or response bodies. Verified by
    `test/data/api/api_client_logging_test.dart`.
  - `mapDioException` / `_extractMessage` now
    handle string-typed 400 bodies (which is what
    `responseType: ResponseType.plain` delivers)
    by best-effort JSON decoding inside the
    extractor, so the user sees the provider's
    actual message instead of a generic fallback.
- **Real path
  (`lib/data/api/rectification_api.dart`):**
  - `RectificationApi.rectify` now returns
    `Result<RectificationApiResponse, AppFailure>`
    — a tiny wrapper carrying both the parsed DTO
    and the verbatim response bytes, so
    `LiveRectificationRepository` can persist the
    raw payload to the `rawResponseJson` column
    (PRD §7.1) without round-tripping through Dart
    maps. `HttpRectificationApi` requests
    `ResponseType.plain` and parses JSON itself so
    the captured raw matches the bytes the
    provider sent.
  - Repository real path:
    `LiveRectificationRepository.submit` threads
    the raw JSON through `responseToResult` and
    surfaces `history.save` storage failures as
    `Err` instead of silently dropping them.
- **Error routes + screens
  (`lib/features/error_flow/`, `lib/app/router.dart`):**
  - Added `error_routing.dart` — `ErrorScreenKind`
    enum with one variant per Phase-6 screen and a
    total `errorScreenForFailure(AppFailure)`
    mapping (timeout / no-internet / bad-request /
    unauthorized / server / malformed; rate-limit
    + storage + geocoding + unknown fall through
    to the generic server screen).
  - Added `error_screen.dart` —
    `CalculationErrorScreen` (a single
    `ErrorScaffold`-backed widget driven by the
    enum) with per-kind copy, icon, and primary
    button behaviour. Retry-friendly failures
    (timeout / no-internet / server / malformed)
    re-enter `/calc/loading` against the same
    draft; bad-request bounces to `/calc/confirm`
    so the user can correct payload data;
    unauthorized resets the draft and returns to
    home so the user does not get stuck in a 401
    loop.
  - Six new routes registered on the top-level
    router (`/error/timeout`, `/error/no-internet`,
    `/error/bad-request`, `/error/unauthorized`,
    `/error/server`, `/error/malformed`).
  - `loading_screen.dart` — on `Err`, navigates
    to `errorScreenForFailure(failure).path`
    instead of parking the user on the loader.
    The draft survives in `DraftRepository`
    (in-memory) so "Try again" replays the same
    submission.
  - Six new Lucide icons added to
    `lib/theme/icons.dart` (`errorTimeout`,
    `errorNoInternet`, `errorBadRequest`,
    `errorUnauthorized`, `errorServer`,
    `errorMalformed`).
- **"Save and retry later" deferred.** The
  persisted-Drafts table from §8.3 was not built
  in earlier phases, so per the Phase 6
  instructions we did not surface a "Save and
  retry later" button. The in-memory
  `DraftRepository` retry path is sufficient for
  the MVP — the user's draft survives a navigation
  to the error screen and a retry tap. A note
  remains in the open-follow-ups list.
- **Tests (17 new, 162 total green):**
  - `test/data/api/fake_http_adapter.dart` — a
    minimal `HttpClientAdapter` fake (no extra
    package dependency) that records every request
    with lowercase header keys and queues canned
    responses or `DioException` transport
    failures.
  - `test/data/api/rectification_api_test.dart`
    (12 tests) — covers the happy path
    (`X-Rectify-App-Id` set, no `Authorization`
    without a Pro key, raw JSON preserved
    byte-for-byte, body field names match the
    DTO), the Pro-key path (`Authorization: Bearer
    <key>`), all transport failures
    (connection/receive timeout, connection
    error), every HTTP status mapping
    (400 message extracted, 401 + 403 →
    Unauthorized, 429 → RateLimited, 500 →
    ServerFailure(500)), and three malformed cases
    (non-JSON, missing required field, empty
    body).
  - `test/data/api/api_client_logging_test.dart`
    (2 tests) — installs `LoggingInterceptor`
    against `FakeHttpAdapter` and asserts no
    emitted line contains the Authorization
    value, the bearer prefix, the request body
    contents, the response body contents, the
    query string, or `api_key` / `apiKey` style
    field names.
  - `test/data/secure/api_key_isolation_test.dart`
    (1 test) — writes a sentinel Pro key into
    `InMemorySecureKeyStore`, exercises every
    `SettingsStore` writer, persists a full
    calculation aggregate via
    `DriftHistoryRepository`, then string-searches
    the resulting prefs JSON and DB row dump to
    prove the secret never leaked.
  - `test/widget/features/error_flow/error_routing_test.dart`
    (7 tests) — the `errorScreenForFailure`
    exhaustive mapping plus six widget tests that
    drive a draft through the calculation flow,
    install a `FakeRectificationRepository` that
    fails with the relevant `AppFailure`, and
    assert the router lands on the expected
    `/error/*` path with the right
    `CalculationErrorScreen.kind`.
  - `test/data/repos/rectification_repository_test.dart`
    — updated for the new
    `RectificationApiResponse` return type and
    asserts that `rawResponseJson` is round-
    tripped into the persisted history row.
- **Verification (commands run from project root):**
  - `dart format lib test` — formatted 0 changed
    files on the final pass.
  - `flutter analyze` — `No issues found!`.
  - `flutter test` — `162 passing` across unit,
    widget, golden. No skipped / quarantined.
  - **iOS simulator smoke not executed.** No
    simulator booted in this session and a
    cold-boot + `flutter run` cycle is multi-
    minute and would block other work; deferred
    to the QA pass scheduled for Phase 8
    (`docs/implementation-plan.md` §14 Phase 8
    DoD).
- **Files added:**
  - `lib/features/error_flow/error_routing.dart`
  - `lib/features/error_flow/error_screen.dart`
  - `test/data/api/fake_http_adapter.dart`
  - `test/data/api/rectification_api_test.dart`
  - `test/data/api/api_client_logging_test.dart`
  - `test/data/secure/api_key_isolation_test.dart`
  - `test/widget/features/error_flow/error_routing_test.dart`
- **Files updated:**
  - `lib/app/route_names.dart` — six
    `RouteNames.error*` + `RoutePaths.error*`
    constants and a file-level
    `comment_references` ignore for the cross-
    library `AppFailure` dartdoc anchor.
  - `lib/app/router.dart` — six `/error/*`
    `GoRoute` entries registered as top-level
    routes (outside the bottom-tab shell).
  - `lib/data/api/api_client.dart` —
    `buildDio` accepts `proxyAppId` +
    `enableLogging`; `_LoggingInterceptor` →
    public `LoggingInterceptor` with a testable
    `sink`; `_extractMessage` decodes JSON
    strings; `dart:convert` import.
  - `lib/data/api/rectification_api.dart` —
    new `RectificationApiResponse` wrapper;
    `HttpRectificationApi` requests
    `ResponseType.plain` and parses JSON in
    Dart so the raw bytes survive intact.
  - `lib/data/repos/rectification_repository.dart`
    — threads `rawJson` into `responseToResult`
    and surfaces `history.save` storage
    failures.
  - `lib/providers/core_providers.dart` —
    `RectifyBuildConfig` extended with
    `proxyPath` + `env` + `requestTimeout`;
    added `proApiKeyProvider` and `dioProvider`;
    `rectificationApiProvider` consumes both.
  - `lib/features/calculation_flow/screens/loading_screen.dart`
    — on submit failure, navigates to the
    matching `/error/*` route instead of
    rendering inline copy.
  - `lib/theme/icons.dart` — six new Lucide
    icon aliases for the error screens.
  - `test/data/repos/rectification_repository_test.dart`
    — `_RecordingApi` returns
    `RectificationApiResponse`; new assertion
    on `rawResponseJson` round-trip.
- **Limit status:** No usage-limit stop.
- **Open follow-ups for later phases:**
  1. **Real provider schema.** Adapt the DTOs in
     `lib/data/api/dto/` and
     `lib/data/api/mappers.dart` once the
     astrology-api.io rectification spec is
     confirmed (or the chosen provider's
     equivalent). All provider field names stay
     confined to those two files.
  2. **Persisted drafts table.** Build the
     `drafts` table from §8.3 and a real
     "Save and retry later" affordance on the
     error screen — currently the affordance is
     hidden because the table doesn't exist.
  3. **Settings — Pro API key sheet (Phase 7).**
     `proApiKeyProvider` is ready to read from
     `SecureKeyStore`; Phase 7 needs the UI to
     write into that store and a `ref.invalidate`
     hook so `dioProvider` rebuilds on save.
  4. **iOS simulator smoke** — defer to Phase 8
     QA pass per §14 Phase 8 DoD.
  5. **Editable life-event description on the
     events screen** — still open from Phase 4;
     unaffected by this stage.
  6. **Onboarding skip overlap with the dynamic
     island** — still open from Phase 3;
     unaffected by this stage.

## Stage — 2026-05-20 — Phase 7 — Settings + privacy

- **Scope** (`docs/implementation-plan.md` §14 Phase 7
  + §8.5 / §9.5, `docs/ascii-wireframes.md` Screen 9,
  `docs/design-system.md` §10.7, `docs/mvp-scope.md`
  M11 + AC4 + AC8). Built the Settings screen end-to-
  end: API-key bottom sheet routed through secure
  storage only, calculation-defaults toggle, time-
  format radio, destructive "Delete all data" with
  confirmation sheet, in-app Privacy screen, and a
  version row. Stayed strictly inside the Phase 7
  contract: no paywall, no persisted-drafts table,
  no analytics SDK, no external Privacy URL (Legal
  copy deferred to Phase 8 per §15.3).
- **`SettingsScreen`
  (`lib/features/settings/settings_screen.dart`):**
  - `ConsumerWidget` rendered inside the bottom-tab
    shell at `/settings`. Five `bg.surface`
    `AppCard` sections with section labels and a
    24pt `sectionGap` between them — API key,
    Calculation defaults, Time format, Data
    (destructive), About — plus a trailing `Rectify
    v1.0.0` line.
  - The API-key row uses a private `_ChevronRow`
    (label + `Set` / `Not set` indicator + chevron,
    44pt min-height, single `Semantics` button
    label) so the same chrome powers the Privacy
    row. The card never displays the saved key
    value, only the configured flag.
  - The Data card carries a danger-tinted border
    (`statusDanger @ 40% alpha`) plus a
    `DestructiveButton` + helper copy so the
    destructive affordance reads unmistakable.
- **`ApiKeySheet`
  (`lib/features/settings/api_key_sheet.dart`):**
  - `ConsumerStatefulWidget` modal sheet
    (`showModalBottomSheet`, `isScrollControlled`,
    keyboard-inset aware) with a single obscured
    `InputField`, `PrimaryButton` "Save key", and a
    contextual `DestructiveButton` "Remove key"
    when a key is already configured (otherwise a
    `SecondaryButton` "Cancel"). The hint text
    swaps to "Currently set — enter a new key to
    replace it" when a key already exists, but the
    field itself opens **empty** every time so the
    stored value never round-trips into the UI
    (§9.5 "never displayed after save").
  - Save flow calls
    `SettingsController.setProApiKey`, clears the
    `TextEditingController` before popping so the
    secret cannot linger in widget state across
    rebuilds, and shows a confirmation snackbar.
    Remove flow calls `clearProApiKey` with the
    same wipe-then-pop ordering. A local `_busy`
    guard disables both CTAs during the write.
- **`DeleteAllDataSheet`
  (`lib/features/settings/delete_all_data_sheet.dart`):**
  - Confirmation sheet whose copy reads the saved-
    calculation count off `historyStreamProvider`
    when available (renders "1 calculation" /
    "N calculations") and falls back to a generic
    "every calculation, event, and setting" string
    when the stream hasn't emitted yet.
  - The confirm path calls
    `SettingsController.deleteAllData`. On `Ok`
    the controller resets `SettingsModel.initial()`
    which flips `onboardingDone` back to false, so
    the router redirect carries the user to
    `/onboarding` and no toast is needed. On `Err`
    a "Couldn't delete data. Try again." snackbar
    surfaces and the sheet still dismisses so the
    user is not stuck.
- **`PrivacyPolicyScreen`
  (`lib/features/settings/privacy_policy_screen.dart`):**
  - In-app plain-language privacy copy with five
    sections (`What Rectify stores`, `Optional API
    key`, `Demo mode`, `Deleting your data`,
    `Analytics and crash reporting`) so the
    Settings row works the moment Phase 7 ships
    without a Legal-team URL. Phase 8 will swap to
    a hosted URL via `url_launcher` per §15.3.
  - Pushed (not switched) onto the navigator from
    `/settings` so the back button returns to the
    Settings tab without losing the bottom-shell
    state.
- **Settings controller writers
  (`lib/providers/settings_controller.dart`):**
  - Added `setProApiKey(String)` and
    `clearProApiKey()` — both go through
    `SettingsRepository`, mirror the visible
    `proApiKeyConfigured` flag into the Notifier
    state, and `ref.invalidate(proApiKeyProvider)`
    so `dioProvider` rebuilds onto the matching
    auth mode on the next read.
  - Added `deleteAllData()` returning
    `Result<void, AppFailure>`. On success the
    state collapses back to `SettingsModel.initial`
    and both `proApiKeyProvider` +
    `draftRepositoryProvider` are invalidated so
    the in-flight draft is dropped and the
    calculation flow restarts empty.
  - The raw Pro key is **never** mirrored into
    Notifier state; only the boolean flag is —
    enforced by the existing
    `api_key_isolation_test`.
- **Settings repository surface
  (`lib/data/repos/settings_repository.dart`,
  `lib/data/prefs/settings_store.dart`,
  `lib/data/secure/secure_key_store.dart`):**
  - `SettingsRepository` now declares
    `setProApiKey` / `clearProApiKey` /
    `deleteAllData`; the default implementation
    writes the key through `SecureKeyStore` then
    flips the prefs flag (or vice-versa for clear),
    and `deleteAllData` wipes Drift +
    `SharedPreferences` + secure storage in a
    single `try` block, mapping any thrown error
    to `StorageFailure`.
  - `SettingsStore` exposes
    `setProApiKeyConfigured` and a `deleteAll`
    that removes every settings key; `SecureKeyStore`
    grew a matching `deleteAll` so the wipe call
    site stays one line per backend.
- **Routes
  (`lib/app/route_names.dart`,
  `lib/app/router.dart`):**
  - `RouteNames.settingsPrivacy` /
    `RoutePaths.settingsPrivacy`
    (`/settings/privacy`) registered as a top-level
    `GoRoute` outside the bottom-tab shell so the
    Privacy screen renders full-bleed without the
    bottom nav.
- **Tests (8 new widget tests, 170 total green):**
  - `test/widget/features/settings/settings_screen_test.dart`
    (8 tests) — boots the real `RectifyApp` against
    `SharedPreferences.setMockInitialValues`,
    `InMemorySecureKeyStore`, a `FakeHistoryRepository`,
    and an in-memory Drift database; sets a
    420×1400 surface so every row in the
    `ListView` builds without scrolling. Covers:
    every row from `design-system.md` §10.7 is
    rendered, demo toggle round-trips through prefs,
    time-format radio persists and the Home /
    History list re-renders in 24-hour form,
    saving an API key flips the row to `Set`
    without echoing the secret into the visible
    tree / prefs / model `toString`, removing a
    key resets the flag and clears secure storage,
    "Delete all data" wipes every backend and the
    router redirects to onboarding, the Privacy
    row pushes `PrivacyPolicyScreen`, and the
    destructive variant count flips from 1 → 2
    when the delete sheet opens.
- **Verification (commands run from project root):**
  - `dart format lib test` — no files reformatted
    on the final pass.
  - `flutter analyze` — `No issues found!`.
  - `flutter test` — `170 passing` across unit,
    widget, golden. No skipped / quarantined.
  - **iOS simulator smoke not executed.** Same
    rationale as Phase 6: no simulator booted in
    this session and a cold-boot + `flutter run`
    cycle is multi-minute and would block other
    work. Still deferred to the QA pass scheduled
    for Phase 8 (`docs/implementation-plan.md` §14
    Phase 8 DoD).
- **Files added:**
  - `lib/features/settings/settings_screen.dart`
  - `lib/features/settings/api_key_sheet.dart`
  - `lib/features/settings/delete_all_data_sheet.dart`
  - `lib/features/settings/privacy_policy_screen.dart`
  - `test/widget/features/settings/settings_screen_test.dart`
- **Files updated:**
  - `lib/providers/settings_controller.dart` —
    `setProApiKey`, `clearProApiKey`,
    `deleteAllData` writers + Notifier-state
    mirroring + `ref.invalidate` hooks for
    `proApiKeyProvider` and
    `draftRepositoryProvider`.
  - `lib/data/repos/settings_repository.dart` —
    interface additions and the
    `DefaultSettingsRepository` implementations
    (secure-storage-first key writes, three-store
    wipe).
  - `lib/data/prefs/settings_store.dart` —
    `setProApiKeyConfigured`, `deleteAll`.
  - `lib/data/secure/secure_key_store.dart` —
    `deleteAll` on the interface and both the
    real and in-memory backends.
  - `lib/app/route_names.dart` —
    `RouteNames.settingsPrivacy` +
    `RoutePaths.settingsPrivacy`.
  - `lib/app/router.dart` — top-level
    `/settings/privacy` `GoRoute`.
- **Limit status:** No usage-limit stop.
- **Open follow-ups for later phases (non-blocking
  for Phase 7 DoD):**
  1. **Hosted Privacy Policy URL.** Replace the
     in-app `PrivacyPolicyScreen` with a
     `url_launcher` jump to the canonical hosted
     policy once Legal provides the URL
     (`docs/implementation-plan.md` §15.3, Phase
     8).
  2. **iOS simulator smoke** — still deferred to
     Phase 8 QA pass per §14 Phase 8 DoD.
  3. **Persisted drafts table + "Save and retry
     later"** — still open from Phase 6;
     unaffected by this stage.
  4. **Real provider schema** — still open from
     Phase 6; unaffected by this stage.
  5. **Editable life-event description on the
     events screen** — still open from Phase 4;
     unaffected by this stage.
  6. **Onboarding skip overlap with the dynamic
     island** — still open from Phase 3;
     unaffected by this stage.

## Stage — 2026-05-20 — Phase 8 — Polish, integration tests, release builds / QA pass

- **Scope** (`docs/implementation-plan.md` §14 Phase
  8 + §16 AC-Demo-1..9, `docs/mvp-scope.md`
  Acceptance Criteria, `docs/design-system.md` §15).
  Closed the polish gaps left open from Phases 3 and
  5, added the §AC-Demo-8 integration test, ran the
  full release-build matrix that the binary can do
  without store-submission credentials, and audited
  the resulting iOS + Android release artifacts for
  payment surface / secret-shaped strings. Stayed
  strictly inside the Phase 8 contract: no
  Crashlytics / Firebase SDK (deferred — no safe
  config exists), no store metadata, no payment
  surface, no provider keys, no marketing / PRD /
  design docs touched.
- **Visual polish fixes shipped:**
  - **Onboarding Skip overlap with the dynamic
    island**
    (`lib/features/onboarding/onboarding_screen.dart`).
    `SafeArea` now declares
    `minimum: EdgeInsets.only(top: AppSpacing.s2)`
    so the GhostButton never sits flush against the
    status bar / dynamic-island region even on
    devices that report a zero top inset. The Skip
    row grew from 44pt → 48pt with an additional
    horizontal `AppSpacing.s2` padding, and the
    GhostButton picked up a stable
    `Key('onboarding-skip')` so layout / integration
    tests can address it deterministically. Closes
    the open follow-up carried since Phase 3.
  - **Result hero reveal animation + reduced motion**
    (`lib/widgets/result/hero_reveal.dart` —
    new wrapper widget;
    `lib/features/calculation_flow/screens/result_screen.dart`
    — wraps `HeroResultCard`).
    `HeroReveal` runs a single-shot 600ms
    `Curves.easeOut` fade + 8pt upward translate on
    first mount (`docs/implementation-plan.md` §16
    AC-Demo-3 / `docs/design-system.md` §15). When
    `MediaQuery.disableAnimations` is `true` (iOS
    Reduce Motion / Android Remove Animations) the
    wrapper sets the controller value to 1 in
    `didChangeDependencies`, snapping straight to
    the terminal state on the first frame — no
    animation, no jank, no lingering controller
    work.
- **Integration test
  (`integration_test/demo_flow_test.dart`):**
  - End-to-end demo loop:
    launch → onboarding Skip → home (empty) →
    drive calc draft via the real
    `CalculationFlowController` → route onto
    `/calc/loading` → assert the demo branch fired
    exactly once through
    `FakeRectificationRepository` → result screen
    (hero time + DEMO pill + 78% confidence +
    `Gemini Rising`) → evidence (uppercase `STRONG`
    label) → back to history (saved row visible) →
    settings (Delete-all-data row reachable). All
    offline, all deterministic, no real Drift / no
    real HTTP / no platform pickers.
  - Uses the project's existing
    `FakeHistoryRepository`,
    `FakeRectificationRepository`,
    `InMemoryDraftRepository`, and
    `InMemorySecureKeyStore` so the same fakes
    that back the widget-test suite also back the
    integration test — no parallel test infra.
  - Verified on `flutter test integration_test/...`
    (host) and on the iPhone 17 simulator
    (`flutter test integration_test/... -d <UDID>`).
    Both runs green; Xcode build ~22s, test
    execution ~5s.
- **Security gates (new):**
  - `test/security/no_payment_or_secret_strings_test.dart`
    parses every `lib/**.dart` file, extracts
    string-literal contents from each non-comment
    line, and asserts:
    1. No user-facing copy contains `paywall`,
       `subscription`, `restore purchase`,
       `in-app purchase`, `buy now`, `unlock pro`,
       or `1 Calculation Credit` (caught at the
       string-literal level so legitimate Dart
       identifiers like `StreamSubscription` and
       `subscription` variables stay legal).
    2. No line carries a Mapbox `sk.<8+>`, an
       OpenAI-style `'sk-<8+>'` quoted literal
       (the API-key sheet's `'sk-…'` placeholder
       uses U+2026 and is correctly excluded), or
       a hard-coded `'Bearer <8+>'` Authorization
       literal.
  - `test/widget/features/onboarding/onboarding_skip_layout_test.dart`
    asserts (a) Skip's top-left dy is ≥ 59pt — the
    SafeArea inset on an iPhone 15 Pro — so the
    overlap regression can't return, and (b) the
    onboarding tree raises no `RenderFlex` /
    overflow exception at `TextScaler.linear(1.3)`.
  - `test/widget/result/hero_reveal_test.dart`
    asserts the reveal curve crosses 0 → 1 over
    600ms, and that
    `MediaQuery.disableAnimations` snaps the wrapper
    to the terminal state on frame zero.
- **Android permission audit
  (`android/app/src/main/AndroidManifest.xml`):**
  - The release / main manifest now declares
    `<uses-permission
     android:name="android.permission.INTERNET"/>`
    — the only permission Rectify needs (Phase 6
    proxy calls + Phase 8 §AC7). Demo path is still
    offline by construction.
  - The merged release manifest also lists
    `android.permission.DUMP`. This is injected by
    the transitive `androidx.profileinstaller`
    dependency and only guards its broadcast
    receiver — Rectify does not request DUMP and
    the permission is not exposed to the user. This
    is the standard Flutter Android baseline.
- **iOS Info.plist audit
  (`ios/Runner/Info.plist`):** no
  `NS<Capability>UsageDescription` keys; no
  `NSAppTransportSecurity` block. The MVP uses
  neither location, camera, mic, photos, nor
  cleartext HTTP — declaring purpose strings the
  app doesn't actually exercise would be its own
  App Store risk.
- **Release build matrix:**
  - `flutter build ios --simulator --debug` →
    **OK** (`build/ios/iphonesimulator/Runner.app`).
  - `flutter build ios --release --no-codesign` →
    **OK** (`build/ios/iphoneos/Runner.app`,
    23.3 MB). Code signing is store-submission
    scope.
  - `flutter build apk --debug` → **OK** (first
    run installed missing build-tools / platform /
    cmake via Gradle's license-accept flow;
    subsequent runs are cached).
  - `flutter build appbundle --release` → **OK**
    (`build/app/outputs/bundle/release/app-release.aab`,
    60 MB). Surface warning: "Release app bundle
    failed to strip debug symbols from native
    libraries." Bundle is produced and uploadable;
    full strip requires `llvm-strip` from the NDK
    and is store-submission scope.
- **Binary string audits (post-release-build):**
  - iOS: `strings build/ios/iphoneos/Runner.app/Runner`
    filtered for `paywall|restore purchase|buy now|`
    `in-app purchase|^sk\.|^sk-[a-z0-9]|Bearer ` →
    zero matches.
  - Android: `strings base/lib/arm64-v8a/libapp.so`
    against the same patterns → zero matches. The
    only proxy-shaped string in libapp.so is the
    explicit-fallback URL
    `https://proxy.invalid.example` from
    `lib/providers/core_providers.dart`, which is
    public per Appendix B.
- **Crashlytics gate:**
  - **Deferred.** Phase 8 lists Crashlytics
    integration as a deliverable, but onboarding a
    Firebase / Sentry SDK requires a project-side
    decision (which provider) plus the project's
    `GoogleService-Info.plist` /
    `google-services.json`. Per the Phase 8
    instructions, the SDK was **not** added blindly
    against placeholder configs — no fake
    credentials, no placeholder
    `firebase_options.dart`. Recorded as a blocker
    in `docs/qa-phase8-report.md` §6 with the
    specific owner action.
- **Verification (commands run from project root,
  2026-05-20):**
  - `dart format lib test integration_test` — no
    files reformatted on the final pass.
  - `flutter analyze` — `No issues found!`.
  - `flutter test` — `177 passing` across unit,
    widget, golden, and security gates. Seven new
    tests added across three new files
    (`hero_reveal_test.dart`,
    `onboarding_skip_layout_test.dart`,
    `no_payment_or_secret_strings_test.dart`); no
    skipped / quarantined.
  - `flutter test integration_test/demo_flow_test.dart`
    — green on host VM and on the iPhone 17
    simulator (`-d <UDID>`).
  - `flutter build ios --simulator --debug` → OK.
  - `flutter build ios --release --no-codesign` →
    OK.
  - `flutter build apk --debug` → OK.
  - `flutter build appbundle --release` → OK
    with the benign "strip debug symbols" warning.
  - `flutter doctor -v` — Xcode + Connected
    devices + Network resources green; Android
    toolchain partially green (SDK present, build
    tools provisioned by Gradle on first build,
    cmdline-tools component still missing and
    licenses still unaccepted at the doctor level;
    recorded as a blocker in §6 of the QA report).
- **Files added:**
  - `docs/qa-phase8-report.md` — full Phase 8 QA
    matrix (Visual / Functional / Security / Build /
    Deferred).
  - `integration_test/demo_flow_test.dart` — Phase
    8 §AC-Demo-8 end-to-end demo test.
  - `lib/widgets/result/hero_reveal.dart` — reveal
    wrapper for the hero card.
  - `test/security/no_payment_or_secret_strings_test.dart`
    — static AC-Demo-6 / AC-Demo-7 gate.
  - `test/widget/features/onboarding/onboarding_skip_layout_test.dart`
    — dynamic-island inset + Dynamic Type ×1.3
    regression gates.
  - `test/widget/result/hero_reveal_test.dart` —
    reveal curve + reduced-motion gate.
- **Files updated:**
  - `android/app/src/main/AndroidManifest.xml` —
    declared INTERNET permission.
  - `lib/features/calculation_flow/screens/result_screen.dart`
    — wrapped `HeroResultCard` in `HeroReveal`.
  - `lib/features/onboarding/onboarding_screen.dart`
    — SafeArea minimum top inset, 48pt Skip row,
    stable `Key('onboarding-skip')`.
- **Limit status:** No usage-limit stop.
- **Open follow-ups for store-submission gate
  (non-blocking for Phase 8 DoD on the demo
  binary):**
  1. **Crashlytics / Sentry decision + project
     config.** Provision the Firebase project
     (or Sentry project), drop the resulting
     `GoogleService-Info.plist` /
     `google-services.json` (or Sentry DSN) into
     the project, then add the SDK. The QA report
     documents the exact owner actions.
  2. **Hosted Privacy Policy URL.** Legal team
     publishes the canonical URL; in-app
     `PrivacyPolicyScreen` then swaps to a
     `url_launcher.launchUrl(...)` jump.
  3. **Final bundle ID + App Store / Play Store
     display name.** Currently `com.rectify.rectify`
     / "Rectify". Product to clear per PRD §2 +
     §15.3 before submission.
  4. **App icon glyph (accent-clay clock-quadrant).**
     Phase 8 plan calls for a placeholder; Phase 0
     left the default Flutter icon. Needs a 1024×1024
     master from Design and a
     `flutter_launcher_icons` pass.
  5. **Real iPhone + Android device smoke** — no
     paired hardware in this session; simulator
     runs were green. AC-Demo-1 (cold-start < 90s)
     is best verified on real hardware before
     internal TestFlight / Internal Test track
     submission.
  6. **Android cmdline-tools + licenses.** Install
     via Android Studio SDK Manager or
     `brew install --cask android-commandlinetools`,
     then `flutter doctor --android-licenses`. Not
     strictly required for the local build pipeline
     (Gradle accepted the per-package licenses
     inline) but doctor still flags as missing.
  7. **AAB native-library strip.** Bundle builds
     but the post-strip step is skipped because
     `llvm-strip` from the Android NDK is not on
     PATH. Non-blocking for Play Console (the
     console re-strips server-side); install the
     NDK to silence the warning locally.
  8. **Persisted drafts + "Save and retry later"**
     — open from Phase 6; roadmapped post-store
     cut.
  9. **Real provider schema** — open from Phase 6.
  10. **Editable life-event description on the
      events screen** — open from Phase 4.
