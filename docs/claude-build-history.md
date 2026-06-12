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

---

## Stage: Live API Integration — astrology-api.io v3

**Date:** 2026-05-20  
**Branch:** main (uncommitted — per task instructions)

### What was done

Connected the app to the real astrology-api.io v3 rectification endpoint
(`POST /api/v3/rectification/search`) for provider-direct mode (user-owned
API key stored in flutter_secure_storage).

### Changed files

| File | Change |
|---|---|
| `lib/providers/core_providers.dart` | Added `providerBaseUrl` + `providerPath` to `RectifyBuildConfig`; `dioProvider` and `rectificationApiProvider` now switch base URL and path based on auth mode |
| `lib/data/api/dto/rectification_request_dto.dart` | Replaced proxy-era DTOs with v3 schema: `RectificationSearchRequestDto`, `SubjectDto`, `BirthDataV3Dto`, `TimeSearchDto`, `EventV3Dto` |
| `lib/data/api/dto/rectification_response_dto.dart` | Replaced with v3 schema: `RectificationSearchResponseDto`, `CandidateV3Dto`, `EvidenceV3Dto`, `SummaryV3Dto` |
| `lib/data/api/mappers.dart` | Full rewrite for v3 DTOs; event date format logic (YYYY-MM-DD / YYYY-MM / YYYY); category mapping table; approximate vs unknown time_search |
| `lib/data/api/rectification_api.dart` | Updated to use new DTO types; default path now `/api/v3/rectification/search` |
| `lib/core/failures.dart` | Added `MissingApiKeyFailure` |
| `lib/features/error_flow/error_routing.dart` | Added `MissingApiKeyFailure` → `unauthorized` screen mapping |
| `lib/data/repos/rectification_repository.dart` | Added `apiKeyIsConfigured` param; early `MissingApiKeyFailure` return when no key + non-demo mode |
| `lib/providers/repo_providers.dart` | Wires `proApiKeyProvider` → `apiKeyIsConfigured` in repo |
| `.env.example` | Added `RECTIFY_PROVIDER_BASE_URL` + `RECTIFY_PROVIDER_PATH` |
| `README.md` | Added live mode instructions section; updated `--dart-define` table |
| `docs/api-integration.md` | **New** — full endpoint reference, auth, payload, response, category mapping, local verification |
| `test/data/api/mappers_test.dart` | Rewritten for v3 DTOs; 15 tests |
| `test/data/api/rectification_api_test.dart` | Rewritten for v3 shapes; default path now v3 |
| `test/data/repos/rectification_repository_test.dart` | Added no-key guard tests; updated to v3 response shape |

### Verification

- `dart run build_runner build` — succeeded (241 outputs written)
- `flutter analyze` — No issues found
- `flutter test test/data/api test/data/repos test/features/calculation_flow test/widget/features/settings` — **62/62 passed**
- `flutter test` (full suite) — **194/194 passed**
- Secret audit: no real API keys in diff; `secret-key-xyz` in test is a fixture string; `.env` gitignored + absent

### Known limitations / follow-up

- Event category mapping table (`_providerCategoryMap` in `mappers.dart`) uses tags that match common API conventions. **Must be verified** against the full live OpenAPI spec at https://api.astrology-api.io/rapidoc before production release (the full spec was not machine-readable at the time of this stage).
- Response DTO field names (`birth_time`, `event_id`, `match_strength`, `calculation_id`) are inferred from the spec description. A curl dry-run with a real key should confirm the exact field names.
- No git commit / push was made per task instructions.

---

## Stage: Live API Integration QA/Fix — astrology-api.io v3 schema alignment

**Date:** 2026-05-20
**Branch:** main (uncommitted — per task instructions)

### Why this stage exists

The prior "Live API Integration" entry flagged two follow-ups: verifying
the event-category enum and confirming response field names. Both
items resolved in this stage by reading the actual OpenAPI spec
(`https://api.astrology-api.io/api/v3/openapi.json`) — the previous
WebFetch summarizer had returned "no rectification endpoints found", so
the spec was assumed unavailable; reading the raw 2.1 MB JSON revealed
both endpoints (`/api/v3/rectification/search` and
`/api/v3/rectification/glossary/event-categories`) with full schemas.

The discovered shape diverges from the previously inferred DTOs in
ways that would have caused **every real-mode submission to fail with
`MalformedResponseFailure`**, plus a silent bug where the approximate
time anchor was always 00:00 instead of the user's input.

### What was fixed

**Request** (`lib/data/api/dto/rectification_request_dto.dart`,
`lib/data/api/mappers.dart`):

- `subject.birth_data.hour` / `minute` now carry the user's
  approximate time. The provider uses these as the center of
  `time_search.delta_minutes`; sending 00:00 silently re-anchored the
  search to midnight.
- Removed `EventV3Dto.id` — the provider's `EventInput` schema has no
  `id` field. Events are correlated to scores via array position
  (`event_scores[].event_index`), and the mapper restores the domain
  `LifeEvent.id` from that index.
- Approximate `step_minutes` stays at 2 (provider default is 4); kept
  the existing finer-grain resolution.

**Response** (`lib/data/api/dto/rectification_response_dto.dart`,
`lib/data/api/mappers.dart`):

- `CandidateV3Dto` rewritten to match `CandidateResult`: `time` (was
  `birth_time`), `aggregate_score` + `normalized_score` (was a
  pre-normalized `confidence`), `grade` (WindowGrade), `event_scores`
  (was a top-level `evidence` list), `events_strongly_correlated`,
  `excluded` / `excluded_reason` / `error`, `anchor_grade`, and `chart`
  carried as a raw `Map<String, dynamic>?` for lazy ascendant
  extraction.
- New `EventScoreDto` (per-event scoring inside each candidate).
- `SummaryV3Dto` rewritten to `SearchSummary`: nested
  `ConfidenceAssessmentDto`, `peak_time`, `techniques_used`,
  `step_minutes`, etc. No `calculation_id` / `method` — those fields
  don't exist in v3.
- New optional top-level `computed_at`.
- `RectificationSearchResponseDto.evidence` removed (per-candidate now).
- Optional fields use `@Default(...)` so a partial / additive provider
  change doesn't take the whole response down with a
  `MalformedResponseFailure`.

**Mapper** (`lib/data/api/mappers.dart`):

- `responseToResult` now accepts `requestEvents` (passed from the
  repository) to translate `event_scores[].event_index` back into the
  user's `LifeEvent.id`.
- Domain confidence (0..1) ← `candidate.normalized_score / 100`.
- Domain ascendant ← `chart.planetary_positions[name="Ascendant"].sign`,
  fallback `chart.house_cusps[house=1].sign`; sign abbreviations
  ("Gem", "Lib") expanded to full words ("Gemini", "Libra").
- Domain evidence built from the rank-1 (non-excluded, non-errored)
  candidate's `event_scores`.
- `MatchStrength` bucketed from `total_score` against the candidate's
  local maximum (≥0.7 strong, ≥0.4 moderate, >0 weak, 0 none) — the
  provider's theoretical-max-per-category is not surfaced in the
  response, so the local-max heuristic stands in.
- `method` set to `summary.techniques_used.join('+')`;
  `apiCalculationId` permanently null (no source field in v3).

**Repository** (`lib/data/repos/rectification_repository.dart`):

- Passes `request.events` to `responseToResult` so the mapper can map
  `event_index` → `LifeEvent.id`.

**Docs** (`docs/api-integration.md`):

- Rewritten to reflect the actual v3 schemas (request / response /
  category mapping). Cleared the "must be verified" caveat from the
  previous stage.

**Tests**:

- `test/data/api/mappers_test.dart` — rewritten for the new shapes
  (anchor time, no `id`, normalized_score, ascendant extraction,
  bucket boundaries, event_index → id mapping, excluded candidate
  skipped for evidence).
- `test/data/api/rectification_api_test.dart` — updated fixture
  response JSON to real v3 shape; updated assertions
  (`summary.confidence.level` instead of `summary.calculationId`).
- `test/data/repos/rectification_repository_test.dart` — canned
  response updated to the new shape (event_scores instead of
  top-level evidence; chart with ascendant body).

### Demo / no-key paths

- Demo path untouched. `LiveRectificationRepository.submit(isDemo=true)`
  short-circuits before any DTO conversion; no schema dependency.
- `MissingApiKeyFailure` still returned before any HTTP call when the
  user hasn't entered a key — routes to the existing
  `ErrorScreenKind.unauthorized` screen (Settings deep-link), not a
  generic network error.

### Verification

- `dart run build_runner build` — succeeded (100 outputs written;
  freezed + json_serializable regenerated cleanly).
- `flutter analyze` — **No issues found**.
- `flutter test test/data/api test/data/repos` — **57/57 passed**.
- `flutter test` (full suite) — **206/206 passed** (previous stage
  reported 194; the delta is the 12 new mapper/response tests).
- Secret audit: `git diff` scanned for `api[_-]?key.*[:=]`, `bearer\s+[A-Za-z0-9]`,
  `secret\s*[:=]`, `sk-[A-Za-z0-9]`, `token\s*[:=]` — only legitimate code
  identifiers (`apiKeyIsConfigured`, `MissingApiKeyFailure`, the test
  fixture strings `pro-user-supplied-secret` and `secret-key-xyz`) and
  documentation references. No real keys in tracked files. `.env`
  remains untracked.

### Known limitations / follow-up

- `MatchStrength` bucketing uses the candidate's local max as the
  reference because the provider's theoretical-max-per-category isn't
  in the response. The provider does surface
  `events_strongly_correlated` (count of events at ≥70% of the
  category-specific max) which could replace this heuristic in a
  later pass.
- Six provider categories (`career_promotion`, `surgery`,
  `relationship_start`, `relationship_end`, `financial_loss`,
  `spiritual`) aren't represented in the domain `EventCategory` enum.
  Adding them is a domain change (Drift migration of stored events),
  out of scope for this QA fix.
- No git commit / push was made per task instructions.

## Stage: Demo APK with bundled .env API key — 2026-05-20

Owner requested a self-contained review build: APK that boots with a
working live ASTRO_API_KEY without the reviewer having to paste it into
the in-app Settings sheet. Old security boundary (key only in
`flutter_secure_storage`, never on disk) is relaxed for this demo build
only — Settings entry still wins when present.

### Files added / changed

- `pubspec.yaml` — added `flutter_dotenv: ^5.2.1`; declared `.env`
  under `flutter.assets:` so it ships inside the APK.
- `lib/main.dart` — calls `await dotenv.load()` inside a try/catch
  before `runApp`. Missing `.env` is tolerated (tests, stripped builds
  still run).
- `lib/providers/core_providers.dart` — new `envApiKeyProvider`
  exposes `dotenv.env['ASTRO_API_KEY']`. `proApiKeyProvider` now
  returns secure-storage key when non-empty, otherwise falls back to
  the env value. Proxy mode unchanged when both are absent.
- `lib/data/api/rectification_api.dart` — added `_unwrapEnvelope` so
  `HttpRectificationApi.rectify` peels the `{success, data, metadata}`
  wrapper returned by the live v3 endpoint before handing the inner
  body to the DTO parser. Bare-shape bodies (used by existing fake
  adapter tests) pass through unchanged.
- `test/data/api/rectification_api_test.dart` — added one test that
  feeds the enveloped wire shape through `HttpRectificationApi` and
  asserts the DTO parses cleanly and `rawJson` keeps the envelope.
- `docs/api-integration.md` — response payload section updated to
  show the actual wire envelope (`success` / `data` / `metadata`).
- `.gitignore` — replaced blanket `.env` / `.env.*` ignore with
  variant-only patterns (`.env.local`, `.env.dev`, `.env.staging`,
  `.env.prod`, `.env.*.local`) so the base `.env` is tracked.
- `.env.example` — rewritten preamble: documents that `.env` IS
  bundled, lists override hierarchy, calls out the binary-recovery
  caveat. Added `ASTRO_API_KEY=` slot.
- `README.md` — Live mode section now describes both override
  sources; environment configuration section updated to mention
  `flutter_dotenv`; GitHub-setup secret-tracking check no longer
  flags `.env`.
- `.env` (NEW, tracked) — holds the real ASTRO_API_KEY for the
  demo build. Not echoed in chat / commits.
- `release/truerise-app-demo.apk` (NEW, tracked) — built artifact.

### Live smoke test (1 paid request)

- `GET /api/v3/rectification/glossary/event-categories` — HTTP 200,
  0.55s, 0 credits — auth verified.
- `POST /api/v3/rectification/search` with synthetic non-personal
  payload (London, 1990-01-01 12:00, single `education` event 2015,
  ±30min delta) — HTTP 200, 1.6s, ~90KB body, 15 credits used.
- Response fed through `RectificationSearchResponseDto.fromJson` +
  `responseToResult` mapper via a throwaway `tool/live_smoke_check.dart`
  (deleted after) — 10 candidates parsed, top time 11:50, ascendant
  Aries, evidence item correctly linked back to the domain event id.
  Caught the envelope mismatch — the bug fix is the
  `_unwrapEnvelope` helper above.

### Verification

- `flutter pub get` — clean (one new package added: `flutter_dotenv`).
- `flutter analyze` — **No issues found**.
- `flutter test` (full suite) — **208/208 passed** (was 207; +1 for
  the new envelope test).
- `flutter build apk --release` — built
  `build/app/outputs/flutter-apk/app-release.apk` (62.9 MB) signed
  with debug keys, copied to `release/truerise-app-demo.apk`.
- `git status` — `.env`, `release/`, and `docs/api-integration.md`
  show as untracked (`??`) — git sees them and they are NOT ignored.
  No `git add` / `git commit` / `git push` was run.

### Security notes

- The bundled `.env` ships inside the APK as an asset; the key is
  recoverable from the binary. Owner is aware — this is a review /
  demo build. Production rollout should rip ASTRO_API_KEY out of
  `.env` and go through the proxy.
- `test/security/no_payment_or_secret_strings_test.dart` still passes
  because the key only ever reaches the app via `dotenv.env[…]` at
  runtime — there is no literal key string in `lib/`.

### Open items

- KGP deprecation warning during `assembleRelease` (shared_preferences_android
  still applies the Kotlin Gradle Plugin in the old way). Not a build
  blocker but will need a plugin upgrade ahead of a future Flutter SDK.
- 18 transitively-available newer package versions held back by
  constraints (objective_c is overridden intentionally; the rest are
  routine outdated reports). Not addressed in this stage.

## Stage: Final QA / repo audit before delivery — 2026-05-20

Read-only verification pass before the owner commits and pushes the
demo build to GitHub. No new feature work, no live API calls (the
previous stage already burned 15 credits on the smoke POST). Goal: make
sure the working tree is exactly what should go to the customer.

### What was verified

- **`.env`** — exists at repo root, 411 bytes, mode `-rw-------`,
  contains `ASTRO_API_KEY=ask_46a2085e…`. `git check-ignore -v .env`
  exits 1 → file is **not** ignored and will be picked up by `git add`.
- **`release/truerise-app-demo.apk`** — exists, 62 943 327 bytes
  (~62.9 MB), `git check-ignore -v` exits 1 → tracked. SHA-1
  `99ad6c5a7317dcd4e64d6ab32af91bc177754e03` matches
  `build/app/outputs/flutter-apk/app-release.apk` exactly, so the
  artifact is the current release build (no skip of `flutter build apk
  --release` needed).
- **`.gitignore`** — `.idea/`, `*.iml`, `.DS_Store`, `/build/`,
  `.dart_tool/`, `.flutter-plugins-dependencies`, `app.*.symbols`,
  `app.*.map.json`, `/coverage/`, `/android/app/{debug,profile,release}`,
  `android/local.properties`, `android/gradlew*`, gradle wrapper jar,
  `ios/Flutter/Generated.xcconfig`, `ios/Flutter/ephemeral/`,
  `ios/Runner/GeneratedPluginRegistrant.*`, `rectify.iml` — all
  ignored (confirmed via `git status --porcelain --ignored`). `.env`
  and `release/` deliberately tracked per the inline comment.
- **No stray tooling** — no `tool/`, no `scripts/`, no
  `.tmp-smoke*`, no `live_smoke_check.dart`, no `*.log`, no
  half-written tmp file under `lib/` or `test/`. The smoke script
  from the previous stage was already deleted.
- **No internal coordinator leaks** — `superpowers`, `compound-v`,
  `brainstorming`, `partition-reviewer`, `parallel-dispatcher`,
  `code-archaeologist`, `domain-expert`, `doc-validator`,
  `spec-reviewer`, `sidekick` appear only in
  `docs/claude-build-history.md` (historical log entries, already
  baked into the previous commit). No mention in `README.md`,
  `lib/`, `test/`, `docs/api-integration.md`, or any other shipped
  doc.
- **No `TODO` / `FIXME` / `HACK` / `XXX`** anywhere under `lib/`.

### Verification commands

- `flutter analyze` — **No issues found! (ran in 2.1s)**.
- `flutter test` — **208/208 passed** (`+208: All tests passed!`).
- `flutter build apk --release` — **not re-run**. The release APK
  on disk is byte-identical to the previous stage's build (SHA-1
  match), so a rebuild would only churn timestamps. The owner can
  re-run it manually if they want a fresh build stamp.
- `git status` after this stage shows the same untracked set as
  before (`.env`, `release/`, `docs/api-integration.md`), plus the
  two doc files this stage edited (`README.md`,
  `docs/claude-build-history.md`).

### Fixes applied this stage

- **`README.md`** (line 124): the inline comment in the
  `cp .env.example .env` snippet still said `# .env is git-ignored`,
  contradicting both the explicit policy a few sections later
  ("the base `.env` IS committed for the demo / review APK build")
  and the `.gitignore` comment block. Replaced with
  `# base `.env` is tracked (demo/review build); `.env.local` etc.
  are ignored`. README-only change; analyze + tests already passed
  and are unaffected.

### Open items (carried forward, not addressed here)

- `docs/superpowers/plans/` is an empty directory left over from the
  earlier tooling session. Git does not track empty dirs, so it will
  not enter the commit; harmless but the owner can `rmdir
  docs/superpowers/plans docs/superpowers` locally if desired.
- KGP deprecation warning and the 18 outdated transitive packages
  from the previous stage are unchanged — still tracked there, still
  non-blocking.
- `README.md` does not have a dedicated section pointing reviewers
  at `release/truerise-app-demo.apk`. The APK is mentioned in the
  Live-mode block ("a reviewer install the APK") but not by name /
  relative path. Cosmetic gap; not a delivery blocker.

### Git operations

- **None.** No `git add`, no `git commit`, no `git push` was run.
  All commit decisions stay with the owner.

## Stage: Bugfix — live endpoint routing + picker overflow — 2026-05-21

Two bugs were reported from a local run on the iPhone 17 Simulator:
three `RenderFlex overflowed` exceptions (317 / 374 / 6872 px) and a
live API request hitting `POST /v1/rectification` with
`DioExceptionType.connectionError`. No new features; bug fixes only.

### Bug 1 — live request routed to the proxy placeholder

- **Symptom.** `[rectify] → POST /v1/rectification` →
  `connectionError`. `/v1/rectification` on `proxy.invalid.example`
  (the deliberately-unroutable proxy default) is the proxy-mode
  endpoint, not the live provider endpoint.
- **Root cause.** `proApiKeyProvider` is a `FutureProvider` (it awaits
  the `flutter_secure_storage` read). `dioProvider` and
  `rectificationApiProvider` resolved the key with
  `maybeWhen(data: …, orElse: …)`, collapsing the `loading` state to
  "no key → proxy mode". The bundled `.env` key was therefore invisible
  during the async window and the data layer pinned itself to
  `proxyBaseUrl` + `proxyPath`.
- **Fix.** New `activeApiKeyProvider` (`lib/providers/core_providers.dart`)
  resolves the key **synchronously**: it returns the resolved
  `proApiKeyProvider` value, or — while that future is still in flight —
  falls back to the synchronously-available `envApiKeyProvider`
  (`.env` is loaded by `dotenv.load()` before `runApp`). `dioProvider`,
  `rectificationApiProvider`, and `rectificationRepositoryProvider`
  now read `activeApiKeyProvider`, so a bundled key puts the app in
  provider-direct mode (`https://api.astrology-api.io` +
  `/api/v3/rectification/search`) from the first build. A
  Settings-entered key still takes precedence and
  `ref.invalidate(proApiKeyProvider)` still propagates.
- **`.env` verification.** `.env` is bundled as a Flutter asset
  (`pubspec.yaml` → `flutter.assets`), `main.dart` calls
  `dotenv.load()`, and `envApiKeyProvider` reads `ASTRO_API_KEY`. With
  a key present the live path is used — the demo path is gated solely
  by `request.isDemo`, unaffected by this change.

### Bug 2 — RenderFlex overflows (bottom-sheet picker)

- All three overflows (317 / 374 / 6872 px) were the category (12),
  month (13), and year (~127) `BottomSheetPicker` lists rendering every
  option in a non-scrolling `Column`. **Already fixed** by the
  committed `dce738f` ("make bottom sheet pickers scrollable") —
  options now live in a `Flexible(ListView.separated)` capped at 75 %
  of screen height. Verified: the calc-flow / result / error screens
  and `add_event_sheet` all scroll or fit; no further layout change
  was needed.

### Files changed

- `lib/providers/core_providers.dart` — added `activeApiKeyProvider`;
  `dioProvider` + `rectificationApiProvider` consume it.
- `lib/providers/repo_providers.dart` — `rectificationRepositoryProvider`
  derives `apiKeyIsConfigured` from `activeApiKeyProvider`.
- `test/providers/api_endpoint_routing_test.dart` — new; 6 tests
  proving the live endpoint is used (incl. the loading-window race),
  auth-mode precedence, and the no-key proxy fallback.
- `test/widget/sheets/bottom_sheet_picker_test.dart` — added a
  126-item year-list no-overflow regression test at an iPhone 17
  (402 × 874) viewport.

### Verification

- `flutter analyze` — **No issues found!**
- `flutter test` — **215/215 passed** (208 prior + 7 new). No live
  POST was made — credits untouched.

### Risks / open items

- The secure-storage-only path (a Settings key with no `.env` key)
  still has a sub-second async window before `proApiKeyProvider`
  resolves; harmless in practice (the key is read at startup, long
  before any submission) and self-corrects on resolution. Fully
  eliminating it would require resolving the secure key at bootstrap.
- Live provider-direct submission was not exercised end-to-end (would
  cost 15 credits); covered indirectly by the routing unit tests and
  the existing `HttpRectificationApi` suite.

### Git operations

- **None.** No `git add`, `git commit`, or `git push` was run.

## Stage: Bugfix — rectification badResponse (candidate cap) — 2026-05-21

Follow-up to the live-endpoint-routing fix: with requests now reaching
`POST /api/v3/rectification/search`, an iPhone 17 Simulator run
returned `DioExceptionType.badResponse` twice. The debug log hid the
HTTP status code, so the cause was not visible from the log alone.

### Root cause

`_buildTimeSearch` in `lib/data/api/mappers.dart` hard-coded
`step_minutes: 2`. For the "unknown" / 24h window (`00:00`–`23:59`) a
2-minute grid resolves to ~719 candidate times; astrology-api.io v3
caps a rectification search at **500 candidates**. The provider
rejected the request — and (a provider quirk) returned it as **HTTP
500** with `{"success":false,"error":{"code":"INTERNAL_ERROR",`
`"message":"Range produces 719 candidates, exceeds maximum 500…"}}`,
even though the OpenAPI spec documents this as `400`. `mapDioException`
mapped the 5xx to `ServerFailure` → the generic "Provider trouble"
screen with a futile "Try again". Approximate mode stayed under the cap
(≤360 candidates), so only the unknown-time path failed.

### Fixes

- `lib/data/api/mappers.dart` — `step_minutes` 2 → 4
  (`kRectificationStepMinutes`, the provider's documented default). The
  24h window now resolves to ~360 candidates and the widest approximate
  window (±360) to ~180 — both well under 500.
- `lib/data/api/api_client.dart`:
  - `LoggingInterceptor.onError` now logs the HTTP status code and a
    sanitized, length-capped provider error message on `badResponse`
    (it previously printed only `✗ badResponse`, hiding the status).
    Request bodies, headers, and the `Authorization` value are still
    never logged; anything resembling a key/bearer token is redacted.
  - `mapDioException` now maps **422** (FastAPI request validation) to
    `BadRequestFailure` — it previously fell through to `UnknownFailure`
    → the server screen.
  - `_extractProviderMessage` (was `_extractMessage`) now understands
    the v3 `{error:{message}}` envelope and FastAPI `detail`
    string/list shapes, so a rejected payload surfaces the provider's
    own explanation on the bad-request "Review my draft" screen.
- `docs/api-integration.md` — `step_minutes` examples updated to 4;
  added the 500-candidate cap and the 500-vs-400 quirk to "Known
  limits".

### Authentication

Verified against the live OpenAPI spec: the endpoint's security scheme
is `BearerAuth` (`Authorization: Bearer <key>`). The diagnostic POST
passed auth — it reached business logic, not 401/403 — so the existing
`AuthInterceptor` Bearer header is correct. No auth change.

### Files changed

- `lib/data/api/mappers.dart`
- `lib/data/api/api_client.dart`
- `docs/api-integration.md`
- `test/data/api/mappers_test.dart` — `step_minutes` expectations
  2 → 4; new candidate-count-under-500 invariant test.
- `test/data/api/rectification_api_test.dart` — new 422 → `BadRequest`
  test and a v3 `{success,error}` envelope message-extraction test.
- `test/data/api/api_client_logging_test.dart` — new error-logging
  group: status + sanitized message on `badResponse`, key redaction.

### Verification

- `flutter analyze` — **No issues found!**
- `flutter test` — **220/220 passed** (215 prior + 5 new).
- One live diagnostic `POST /api/v3/rectification/search` was made to
  confirm the root cause. It was rejected before computation
  (`credits_used: 0` in the response) — **no credits were spent**.

### Git operations

- **None.** No `git add`, `git commit`, or `git push` was run.


### 2026-05-22 — Privacy-safe result sharing

- **Claude session:** `8663383f-924c-4eb2-a3b4-ff86a5008944`
- **Goal:** Add a "Share result" CTA to the result screen that exposes
  only the rectified time, ascendant, and confidence — never birth city,
  birth date, life events, labels, API IDs, or keys.

### Architecture

- `ShareService` abstract interface — `Future<bool> share(String text)`.
  Returns `true` when the native OS share sheet was invoked, `false`
  when the clipboard fallback was used. The result screen shows a
  "Copied to clipboard" SnackBar on `false`.
- `PlatformShareService` uses a `MethodChannel('rectify/share')` with
  `MissingPluginException` / `PlatformException` catch-and-fallback to
  `Clipboard.setData`.
- `ShareCopyBuilder.build(SavedCalculation)` — pure static method, no
  state, no IO. Outputs: rectified time (12-hour format), ascendant
  rising sign, confidence percent, and the app tagline.
- `shareServiceProvider` — overridable Riverpod `Provider<ShareService>`;
  widget tests override it with `FakeShareService`.

### Files created

- `lib/core/sharing/share_copy_builder.dart`
- `lib/core/sharing/share_service.dart`
  (`PlatformShareService` + `shareServiceProvider`)
- `test/unit/sharing/share_copy_builder_test.dart` — 10 unit tests
  (privacy guarantees, 12-hour format, null ascendant, empty candidates)
- `test/widget/features/calculation_flow/result_share_test.dart` —
  5 widget tests (button visible, tap calls service, text is non-empty,
  privacy text assertions, SnackBar on fallback, no SnackBar on native)
- `test/helpers/fake_share_service.dart`

### Files modified

- `lib/features/calculation_flow/screens/result_screen.dart` — added
  `_ShareResultButton` widget, `resultShareButtonKey` constant, imports.
- `ios/Runner/AppDelegate.swift` — registered `rectify/share`
  MethodChannel; uses `UIActivityViewController` with iPad popover.
- `android/app/src/main/kotlin/com/rectify/rectify/MainActivity.kt` —
  registered `rectify/share` MethodChannel; uses `Intent.ACTION_SEND`
  chooser.

### Verification

- `dart format` — 1 file reformatted (result_share_test.dart trailing comma), rest unchanged.
- `flutter analyze` — **No issues found!**
- `flutter test test/unit/sharing/share_copy_builder_test.dart test/widget/features/calculation_flow/result_share_test.dart` — **19/19 passed.**

### Known risks / open questions

- Android: `startActivity` inside the MethodChannel handler uses
  `FlutterActivity.startActivity` which requires the activity to be
  running — safe for the normal foreground path.

### Git operations

- **None.** No `git add`, `git commit`, or `git push` was run.

### 2026-06-02 — Growth Thesis (Run 1)

- **Artifact created:** `docs/growth-thesis.md` (v0.1).
- **Work completed:** Claude Code produced the first growth-phase
  decision document, written before competitor research, ASO metadata,
  localization, or any implementation. The document locks:
  - product category and value proposition (utility / probabilistic,
    not horoscope / deterministic);
  - initial ICP for growth and store launch ("Maya" persona from PRD
    §4; Arjun and Elena explicitly deferred);
  - market priority — Tier 0 English fronts (US/UK/CA/AU/IE/NZ) →
    Tier 1 DE / FR / PT-BR / ES localization → Tier 2 Hindi gated on
    Vedic/KP method shipping in V1.5; explicit answer to the
    India/Hindi vs DE/FR/PT/ES sequencing question;
  - north-star metric — Real Rectifications Completed per Week
    (RRC/wk), slope rather than level until post-launch data exists;
  - supporting metric tree across acquisition, activation, value
    moment, and quality, tied to PRD §15 targets and existing
    instrumentation in `lib/data/api/`;
  - ASO strategy — head terms ("astrology", "horoscope", "kundli",
    locale equivalents) explicitly *not* realistic top-10 targets;
    intent-matched long-tail BTR keyword set per Tier 0 and Tier 1
    locale defined as the realistic 60–120-day ambition;
  - seven growth hypotheses (H1–H7) plus one held-in-reserve H8,
    each with a kill criterion;
  - explicit non-goals — no social graph, accounts, IAP, push, in-app
    review prompt, medical/legal/financial/deterministic claims, no
    India marketing pre-Vedic, no professional-astrologer marketing;
  - five blocking decisions (D1–D5) for human approval: public name
    TrueRise vs Rectify, locale order, Hindi sequencing, P0 feature
    criterion, pre-IAP paid-acquisition hold;
  - scope of Run 2 (competitor research) — six concrete questions
    Run 2 must answer with evidence rather than re-litigating Run 1;
  - concise approval gate (A1–A5) the human must approve before any
    later run starts.
- **Constraints respected:** Documentation only. No Flutter / Dart code
  was authored or edited. `lib/`, `ios/`, `android/`, `test/`,
  `integration_test/`, `pubspec.yaml`, generated files, and build
  configs were not touched. All external claims in the document reuse
  sources already cited in `docs/marketing-research.md`; no new URLs
  were invented.
- **Verification:** Cross-checked the thesis against `docs/prd.md`
  (§2 working title, §4 ICP, §6 value prop, §8 non-goals, §11 API
  modes, §13 privacy, §15 metric targets, §16 risks, §17 phases),
  `docs/mvp-scope.md` (M5/DM1–DM5 demo readiness, deferred-features
  table), `docs/api-integration.md` (Bearer auth, 15-credit cost,
  500-candidate cap), `docs/marketing-research.md` (ICP segments,
  competitor pricing, "do not advertise in India for MVP"), and
  `docs/qa-phase8-report.md` (Crashlytics deferred, no embedded
  secrets, app-icon glyph deferred, store-submission scope) so that no
  recommendation contradicts existing product, design, or engineering
  decisions.
- **Limit status:** No usage-limit stop.
- **Open items for the next run:** Human approval of A1–A5 in the
  growth-thesis Approval Gate; on approval, Run 2 (competitor research
  per §11) can start.

### 2026-06-02 — Growth Thesis (Run 1) revision: claude-opus-4-8 review pass

- **Artifact changed:** `docs/growth-thesis.md` (v0.1 → v0.2).
- **Why:** The v0.1 draft was produced under the `opus` alias, which resolved
  to `claude-opus-4-7`. This pass re-reviewed it under `claude-opus-4-8`.
- **Work completed:** Verified the document against current sources — PRD §15
  metric targets, §17 phases/success gate, §16 India risk row (line 559),
  marketing-research competitor pricing (incl. Cosmic Birthtime £28) — and
  confirmed the cited code anchors still resolve (`ShareCopyBuilder` is
  genuinely PII-free, `resultShareButtonKey`, `LiveRectificationRepository
  .submit`, `mapDioException`, `techniques_used`). Corrected three
  metric/citation imprecisions: §5 and §8/H1 now attribute the "first 200
  users" gate to PRD §17 (not §15); §6.3's metric is relabelled to the
  ≥5-events *share* that matches its target. Added an approver bottom-line
  near the header, a decision-owner / target-date field on the §12 approval
  gate, and an ASO volume-calibration note in §7.2 (long-tail top-10 ⇒ small
  absolute installs, not a step change). Thesis, ICP, market order, and
  north-star are unchanged — a precision + clarity pass, not a re-litigation.
- **Constraints respected:** Documentation only. `lib/`, `ios/`, `android/`,
  `test/`, `integration_test/`, `pubspec.yaml`, generated files, and build
  configs were not touched.
- **Verification:** No code tests applicable (docs only). Ran `git diff --stat`
  and `git status --short`.
- **Limit status:** No usage-limit stop.
- **Open items for the next run:** Unchanged — human approval of A1–A5; on
  approval, Run 2 (competitor research per §11) can start.

### 2026-06-02 — Competitor & ASO Research (Run 2) [backfill]

- **Claude session:** not recorded — the original Run 2 process hit the
  5-hour usage limit immediately after writing the main document, before a
  build-history entry was appended. This entry is a concise **backfill**
  reconstructed on 2026-06-02 from `docs/competitor-aso-research.md` (v1.0)
  and current git state only; it does not add claims beyond that artifact.
- **Artifact created:** `docs/competitor-aso-research.md` (v1.0, Run 2).
  All live evidence dated 2026-06-02.
- **Work completed (per the artifact):** Evidence pack testing the Run 1
  thesis (`docs/growth-thesis.md` §11) against current web/App Store/Play
  evidence. Findings: confirms Run 1 on every load-bearing point, sharpens
  two, challenges none of A1–A5.
  - The mobile-native consumer BTR lane is still essentially open — the only
    dedicated mobile-native BTR app found is **Vedic Samay** (iOS,
    Vedic/KP, practitioner-leaning, **Utilities** category); every other BTR
    solution is a web calculator, human service, or desktop software.
  - Anti-positioning (A1) confirmed — Co-Star, CHANI, Nebula, The Pattern all
    *demand* an exact birth time and degrade without it; none computes BTR.
  - "Utilities, not horoscope" upgraded from tone to **policy survival** —
    Apple Guideline **4.3(b)** names fortune-telling/astrology as a saturated,
    rejection-prone category; disclaimers do not cure 4.3; Vedic Samay's
    Utilities placement is the working precedent.
  - Pricing — PRD ~$4.99/credit is in-region (between Vedic Samay's
    ~$0.70–$1.00/report floor and Cosmic Birthtime's £28 ceiling) but premium
    for a single mobile shot. No price set (V1.5 work).
  - Credibility headwind sharper than Run 1 implied — Astrodienst (astro.com)
    explicitly refuses rectification across EN/DE/FR/ES/PT; honest-confidence
    copy is mandatory, Germany especially.
  - Locale vocabulary confirmed for DE/FR/ES/PT-BR with no mobile BTR app in
    any locale; India re-check found no mobile BTR competitor that would force
    V1.5 sequencing to compress — Hindi stays a V1.5 *localization* item,
    India *marketing* deferred.
  - New watch-items: **W1** pricing calibration (V1.5 gate), **W2** EU
    credibility copy; four §12.4 verification items handed to Run 3.
- **Constraints respected (per the artifact):** Research- and
  documentation-only; no Flutter/Dart code authored or edited; no ranking,
  rating, price, review, or screenshot invented; absent evidence stated as
  absent.
- **Verification:** Reconstructed entry — verification reflects the artifact's
  own stated method (live web search/page fetches, 2026-06-02) and its §2
  access limitations (US-locale search ≠ in-store rankings; ratings/installs
  not fetchable). No code tests applicable.
- **Limit status:** Original Run 2 session stopped on the **5-hour usage
  limit** right after writing the document; this is why the entry is a
  backfill.
- **Open items for the next run (Run 3, now addressed):** ASO naming + metadata
  strategy; the §12.4 verification items (in-store rankings, store
  ratings/installs, Play policy specifics, structured review sample) carried
  forward as validation tasks.

### 2026-06-02 — ASO & Naming Strategy (Run 3)

- **Model:** `claude-opus-4-8` (run invoked explicitly under this model).
- **Artifact created:** `docs/aso-naming-strategy.md` (v1.0, Run 3).
- **Stage:** Stage 3 — resolve the public-name question (TrueRise vs Rectify)
  and propose App Store + Google Play metadata, grounded in Run 1 and Run 2.
- **Work completed:**
  - **Naming decision:** recommend **TrueRise** as the public brand (kept
    English globally), paired with a descriptive ASO-bearing tail
    ("Birth Time Finder" / "Rectify your birth time"); `rectify` /
    `com.rectify.rectify` stays the internal codename + bundle ID. Naming
    decision matrix scores TrueRise vs Rectify vs three descriptive
    alternatives across ASO fit, policy risk, memorability, trust, locale
    portability, trademark caveat, and storytelling fit.
  - **App Store strategy:** category **Utilities** (4.3(b) survival; Vedic
    Samay precedent); title/subtitle candidates within ~30-char limits;
    keyword bank grouped into high-intent long-tail / supporting astrology /
    too-competitive head / blocked-policy terms; two ~90–98-char keyword-field
    drafts with explicit console-validation caveats.
  - **Google Play strategy:** Tools category; title + ~80-char short
    description candidates; long-description outline with a first-~250-char
    hook; no-stuffing keyword placement guidance.
  - **Query strategy:** realistic Tier 0 long-tail top-10 targets vs
    too-competitive head terms; DE/FR/ES/PT-BR direction using Run 2 §6
    vocabulary (direction only, not full translation).
  - **Policy-safe copy rules:** 4.3(b) mitigation, probabilistic/utility
    wording, words/claims to avoid, and how to reference astrology as *method*
    not *category*.
  - **Screenshot storytelling:** hero (time+rising+confidence) → evidence →
    demo/offline/privacy → privacy-safe share; the share screenshot is grounded
    in the **verified** shipped feature (`ShareCopyBuilder`,
    `resultShareButtonKey`, build-history 2026-05-22) — no new share-card work
    claimed as done.
  - **Localization:** brand stays English; descriptor is localized; DE copy
    held to the highest credibility bar (W2).
  - **Decision deltas + watch-items, open validation checklist, and three
    marked metadata option sets** (Conservative / High-intent ASO / Brand-led).
- **Material correction surfaced:** Run 1 §9.1 overstated that the binary
  already uses "TrueRise" as its display name. Verified 2026-06-02 (read-only):
  iOS `CFBundleDisplayName=Rectify`, Android `android:label="rectify"`, while
  README, commit messages, and in-app share copy say "TrueRise." Aligning the
  display name is logged as a config-alignment validation item — **not changed
  in this run** (code/config out of scope).
- **Constraints respected:** Documentation only. No app code/config edited;
  `lib/`, `ios/`, `android/`, `test/`, `integration_test/`, `pubspec.yaml`,
  generated files, build configs, screenshots, assets, and localization files
  were not modified. `lib/core/sharing/`, `ios/Runner/Info.plist`,
  `android/.../AndroidManifest.xml`, `android/app/build.gradle.kts`, and
  `README.md` were **read only** to verify naming facts. No live ranking,
  volume, rating, or trademark clearance invented — all routed to the
  validation checklist.
- **Verification:** Ran `git diff --stat` and `git status --short`; confirmed
  only `docs/aso-naming-strategy.md` and `docs/claude-build-history.md` changed
  this run, with no app code paths touched. No code tests applicable (docs
  only).
- **Limit status:** No usage-limit stop.
- **Open items for the next run:** Section 11 validation checklist (trademark
  clearance, App Store name availability, display-name alignment, in-console
  character re-count, in-store rankings, Play policy specifics, hosted privacy
  policy). Run 4 (Feature Gap Analysis) can proceed.

### 2026-06-02 — Feature Gap Analysis (Run 4)

- **Model:** `claude-opus-4-8` (run invoked explicitly under this model).
- **Artifact created:** `docs/feature-gap-analysis.md` (v1.0, Run 4).
- **Stage:** Stage 4 — compare the Run 1-3 growth/ASO strategy and Run 2
  competitor evidence against the verified current implementation; produce an
  implementation-ready feature gap backlog answering "which functions help the
  app spread (especially social/Instagram-style sharing) and which missing
  functions should ship before publication or V1.5."
- **Work completed:**
  - **Verified feature inventory** with read-only evidence paths, every line
    labeled `[VERIFIED]` / `[ASSUMED]` / `[PROPOSED]` to keep observed behavior
    separate from proposals.
  - **Gap matrix G1-G24** (feature, evidence source, current status, growth
    impact, ASO/store impact, policy risk, complexity, suggested phase, owner
    notes).
  - **Top-3 priorities:** P0 display-name config gate (G1, TrueRise vs Rectify,
    config-only); the V1.5 privacy-safe share-CARD image as the real Instagram
    lever (ranked #1 growth, gated on a pixel-level privacy review, *not* pulled
    into pre-publication); P1 privacy-safe analytics (no SDK wired — greenfield).
  - Competitor expectations split into **direct BTR / mainstream astrology /
    web calculators**; P0 pre-publication, P1 growth/social, trust/credibility,
    ASO/store assets, localization (DE/FR/PT/ES), and publication-readiness
    gap sections.
  - **Three recommended implementation runs** (A pre-publication config gate;
    B privacy-safe analytics + share reach; C l10n extraction pipeline) with
    per-batch acceptance criteria, plus risks/non-goals and a source/evidence
    appendix.
- **Material correction surfaced:** Run 1 (§4.2/§6.5) assumed localization
  needs "no product code change." Direct read-only verification (no ARB files,
  no `flutter_localizations` in `pubspec.yaml`, hardcoded English literals)
  proves a string-extraction refactor **is** required. Logged as verified gap
  **G20** and the headline of §9. The earlier claim that no analytics SDK is
  wired was also confirmed by `pubspec.yaml` (no posthog/amplitude/firebase/
  sentry), so privacy-safe instrumentation is greenfield.
- **Constraints respected:** Documentation only. No app code edited; `lib/`,
  `ios/`, `android/`, `test/`, `integration_test/`, `pubspec.yaml`, generated
  files, build configs, screenshots, assets, and localization files were not
  modified — code paths (`lib/core/sharing/`, result/life-events screens,
  `core_providers.dart`, `pubspec.yaml`, `Info.plist`, `AndroidManifest.xml`)
  were **read only** to verify gaps. No live ranking, rating, install, review,
  or trademark clearance invented; absent evidence stated as absent. Privacy
  treated as a growth requirement (no PII in any proposed share/analytics
  surface).
- **Verification:** Ran `git diff --stat` and `git status --short`; confirmed
  only `docs/feature-gap-analysis.md` (new) and `docs/claude-build-history.md`
  changed this run, with no app code paths touched. No code tests applicable
  (docs only).
- **Limit status:** No usage-limit stop.
- **Open items for the next run:** Run 5 (Localization Strategy) can proceed —
  feed it the corrected localization-refactor finding (G20) as the central
  input. Privacy-safe analytics design (Run B) and the share-card privacy
  review (#1 growth lever) carry forward as parallel tracks; P0 config gate
  (G1) remains a pre-publication blocker.

### 2026-06-02 — Localization Strategy and String Audit (Run 5)

- **Model:** `claude-opus-4-8` (run invoked explicitly under this model).
- **Artifacts created:** `docs/l10n-strategy.md` (v1.0, Run 5, 14 sections) and
  `docs/l10n-string-audit.md` (v1.0, Run 5, 10 sections).
- **Stage:** Stage 5 — turn the Run 4 localization-refactor finding (G20) into an
  implementation-ready localization strategy plus a read-only audit of every
  user-visible hardcoded English string, so a future extraction run (Impl Run C)
  and Tier 1 translation run (Impl Run D) can proceed without rediscovery.
- **Work completed:**
  - **Strategy doc** covering: verified current l10n state; locale priority
    (DE > FR > ES > PT-BR, with Portuguese = PT-BR) and rationale; brand/naming
    rules (TrueRise stays English, descriptor localized, Rectify internal-only);
    the five-surface scope split (product UI / store metadata / screenshots /
    privacy-legal / support); binding translation principles (probabilistic,
    no fortune/medical/legal claims, honest-confidence wording, privacy-first,
    no paywall tone); a 10-term locale terminology table (DE/FR/ES/PT-BR) with
    recommended vs avoid forms; per-locale tone/risk notes; store-metadata
    direction per locale (no ranking certainty asserted); the G20 dependency +
    Run A->C->D sequencing; a QA plan (overflow, 12/24h, dates, percent, a11y,
    screenshots); acceptance criteria for Runs C and D; open owner decisions; and
    a source/evidence appendix.
  - **String audit** with: confirmed no-l10n baseline; a module-by-module
    inventory of ~200+ user-visible strings with file paths and line numbers
    (20 modules, type-tagged); P0/P1/P2 extraction buckets; an ICU
    interpolation/plural/select inventory plus the time/date/number formatting
    debt (G21); truncation/overflow risk surfaces with locale long-word
    offenders; sensitive-language translation notes; eight implementation-ready
    extraction batches (C0-C8); a grep-able "extraction complete" verification
    checklist; and an evidence appendix.
- **Key findings (verified read-only this run):**
  - **No localization pipeline exists at all** — no `.arb`, no `l10n.yaml`, no
    `flutter_localizations`, no `generate: true`, no `AppLocalizations`, and no
    `localizationsDelegates`/`supportedLocales` in `lib/app/app.dart`. The l10n
    wiring symbols appear **only in `docs/`**, never in `lib/`/`pubspec.yaml`/
    config. `intl: ^0.20.2` is present for formatting only. Clean greenfield;
    no stale setup to migrate. Confirms and sharpens Run 4 **G20**.
  - **Formatting debt (G21):** hand-rolled 12/24h AM/PM literals in 5 files and
    `Jan..Dec` month maps duplicated in 3 files; several `DateFormat` calls rely
    on default locale. Folded into the extraction run (Batch C1).
  - **Widget layer is already locale-clean** — result/card/picker widgets take
    pre-formatted strings; the copy + formatting debt lives in the screen
    callers. Extraction effort concentrates in `lib/features/.../screens/`.
  - **Accessibility `Semantics` labels are interpolated sentences** that must be
    extracted/translated; `match_strength_dots.dart` derives its spoken label via
    English `toLowerCase()` (an i18n trap flagged for fix).
  - **Dynamic error leak:** `loading_screen` shows `failure.toString()` (debug
    text), flagged as a small correctness fix to ride along with extraction
    (map `AppFailure` to localized copy, as the error screens already do).
  - **Brand handling:** TrueRise never enters an ARB for translation; the still-
    hardcoded `'Rectify'` literals (app title, top nav, settings version, privacy
    copy) are the pre-existing G1 display-name gap, to be resolved by Impl Run A
    before extraction — not "fixed" by the l10n run.
- **Constraints respected:** Documentation only. No app code, config, ARB,
  `l10n.yaml`, or `pubspec.yaml` created or changed; `lib/`, `ios/`, `android/`,
  `test/`, `integration_test/`, assets, screenshots, and generated files were
  **read only** for the audit. No localization implemented and no ARB files
  created. Outputs kept ASCII-safe except quoted target-language terms (DE/FR/ES/
  PT-BR) in the terminology tables, where correct diacritics are required. No live
  store rankings, install/download counts, ratings, review quotes, trademark
  clearance, or store-policy approvals invented; all such items routed to the
  strategy's owner-decision checklist. Every claim labeled VERIFIED / ASSUMED /
  PROPOSED.
- **Verification:** Ran `git status --short`, `git diff --stat`, and
  `git status --short -- lib ios android test integration_test pubspec.yaml assets
  l10n.yaml` (scoped) to confirm only the two new docs and this history file
  changed, with no app code paths touched. Confirmed both deliverables exist with
  all required sections (14 / 10). No code tests applicable (docs only).
- **Limit status:** No usage-limit stop.
- **Open items for the next run:** Run 6 can proceed. The localization
  implementation is sequenced as **Impl Run A (G1 brand/display name) -> Impl Run
  C (G20 extraction + G21 formatting) -> Impl Run D (G22 Tier 1 DE/FR/ES/PT-BR
  translation)**; none are started (code out of scope). Owner decisions before
  implementation: native-reviewer sign-off on terminology, PT-BR-only vs PT
  fallback, German du/Sie register, Spanish neutral vs es-419 split, zodiac
  sign-name localization approach, per-locale store character-limit re-counts,
  and hosted privacy-policy localization ownership. H4 (localization install-lift
  hypothesis) needs the privacy-safe analytics track (Run B) for measurement.

### 2026-06-02 — Store Submission Readiness (Run 6)

- **Model:** `claude-opus-4-8` (run invoked explicitly under this model).
- **Artifact created:** `docs/store-submission-readiness.md` (v1.0, Run 6,
  12 sections).
- **Stage:** Stage 6 — convert the Run 1-5 growth/ASO/localization strategy and
  the verified current implementation into an implementation-ready,
  evidence-labeled App Store + Google Play submission-readiness plan: P0
  blockers, per-store config, the English Tier 0 ASO package, localized-listing
  direction, the asset/screenshot/QA storyboard, policy-risk mitigation,
  release sequencing, and a verification checklist.
- **Work completed:**
  - **12 required sections** delivered: executive summary; current verified
    state; P0 blocking checklist; iOS readiness; Play readiness; English Tier 0
    ASO package; localized (DE/FR/PT-BR/ES) package plan (direction only);
    assets/screenshots/QA storyboard; policy risk + mitigation language;
    release sequencing + ownership tracks; verification checklist + commands;
    open owner decisions + source-evidence appendix.
  - **P0 blocker set fixed with verified evidence:** display-name mismatch (G1);
    debug-signed release (G5); bundle-ID immutability decision; missing hosted
    privacy-policy URL (G2); unauthored Apple privacy labels + Play Data Safety
    (G3); **absent age gate** (G6); default app icon (G4); placeholder/missing
    metadata (G7) + screenshots (G8); category positioning (Utilities/Tools);
    demo-key rotation hygiene. Localized listings flagged as blocked on G20/G22.
  - **English Tier 0 ASO package** restated as concrete drafts (title,
    subtitle, two keyword-field drafts, short + long description outline,
    promo text) with approximate char counts, an explicit console-recount
    caveat, high-intent long-tail vs too-competitive head-term separation, and
    **no top-10 guarantee**.
  - **Screenshot storyboard** (4 frames: answer -> evidence -> private/offline
    -> share) grounded in shipped UI, depicting the **text** share as the spread
    mechanism and explicitly **not** claiming the V1.5 share-card image (G9) as
    shipped.
- **Key findings (verified read-only this run):**
  - **Live data flow is broader than the in-app copy implies.** The outbound
    request DTO (`lib/data/api/dto/rectification_request_dto.dart`) sends birth
    date/time estimate, **precise birthplace latitude/longitude**, and
    **free-text life-event descriptions** to the third-party provider in live
    mode (demo mode sends nothing). The in-app privacy screen emphasizes
    "on-device only" and under-discloses this transmission -- a verified gap the
    hosted policy, Apple privacy labels, and Play Data Safety form must close.
  - **Brand leak is wider than just platform config.** Beyond iOS
    `CFBundleDisplayName=Rectify` and Android `android:label="rectify"`,
    "Rectify" is hardcoded in the Settings version row
    (`settings_screen.dart:157` "Rectify  v1.0.0") and the privacy copy
    (`privacy_policy_screen.dart`). G1 is a multi-site fix, not a one-line
    config change.
  - **Share is text-only and PII-free by construction**
    (`share_copy_builder.dart` includes only time/ascendant/confidence;
    `share_service.dart` uses the OS sheet + clipboard fallback). No
    `share_plus`/screenshot package exists, confirming the share-card image is
    genuinely unbuilt.
  - **Release is debug-signed** (`build.gradle.kts` release `signingConfig`
    = debug) and **no age gate** exists (`birth_data_screen.dart` firstDate
    1920 / lastDate now, no minimum-age floor) -- both confirmed P0.
- **Constraints respected:** Documentation only. No app code, config, assets,
  screenshots, generated files, tests, `pubspec.yaml`, `ios/`, `android/`,
  `lib/`, `integration_test/`, or l10n files were modified. `Info.plist`,
  `AndroidManifest.xml`, `build.gradle.kts`, `pubspec.yaml`, `README.md`, the
  sharing/result/settings/privacy screens, the request DTO, and the birth-data
  screen were **read only** for evidence. No live store rankings, install
  counts, ratings, review quotes, trademark clearance, or store approvals were
  invented; absent evidence stated as absent. Every load-bearing claim labeled
  VERIFIED / ASSUMED / PROPOSED.
- **Verification:** Ran `git status --short`, `git diff --stat`, and the scoped
  `git status --short -- lib ios android test integration_test pubspec.yaml
  assets l10n.yaml` to confirm only the new doc and this history file changed,
  with no app code paths touched; grepped the new doc's `^## ` headers to
  confirm all 12 sections exist. No code tests applicable (docs only).
- **Limit status:** No usage-limit stop.
- **Open items for the next run:** First-submission critical path is
  **Impl Run A** (display name -> TrueRise across config + 3 in-app string
  sites, bundle-ID decision, release signing, age gate, app icon, privacy-copy
  disclosure update) -> hosted privacy policy -> metadata + screenshots ->
  internal testing -> submit **English Tier 0** under Utilities/Tools.
  Owner decisions gate the run: bundle-ID keep-vs-rebrand, age cutoff + rating,
  hosted-policy ownership/content, demo-key rotation, TrueRise trademark
  clearance + App Store name availability, category confirmation, device matrix.
  Localized listings remain blocked on Impl Run C (G20 extraction) -> Run D
  (G22 DE/FR/ES/PT-BR translation).

### 2026-06-02 — Public Brand, Age Gate, Privacy Disclosure (Impl Run A.1)

- **Model:** `claude-opus-4-8` (run invoked explicitly under this model).
- **Session id:** `4b816090-6126-4a22-a04d-276d4595e48d`.
- **Stage:** First implementation run cut from the Run 6 P0 set. Closes three
  store-blocking gaps without touching deferred MVP scope: public display name
  (G1), absent age gate (G6), and the privacy-copy under-disclosure of live-mode
  transmission (subset of G2/G3). Release signing, hosted privacy URL, app icon,
  bundle-ID decision, metadata, and screenshots are intentionally **out of scope**.
- **Files changed (code/config):**
  - `ios/Runner/Info.plist` — `CFBundleDisplayName` Rectify -> TrueRise
    (`CFBundleName` left lowercase `rectify`; not the home-screen label).
  - `android/app/src/main/AndroidManifest.xml` — `android:label` rectify ->
    TrueRise (`applicationId`/namespace untouched).
  - `lib/app/app.dart` — `MaterialApp.router` title -> TrueRise.
  - `lib/features/home/home_history_screen.dart` — Home top-nav title -> TrueRise.
  - `lib/features/onboarding/onboarding_screen.dart` — slide copy: "How TrueRise
    works" and "TrueRise narrows it down" (+ a stale doc-comment).
  - `lib/features/settings/settings_screen.dart` — version row "TrueRise  v1.0.0"
    (two-space style preserved for the test assertion).
  - `lib/features/settings/privacy_policy_screen.dart` — rebranded headings/body
    and added a new "Live calculations" section disclosing that live (non-demo)
    runs send birth date/approx time, birthplace coordinates, and life-event
    descriptions to a third-party provider over HTTPS solely to compute the
    result, tied to no account.
  - `lib/features/calculation_flow/state/calculation_flow_state.dart` — added
    `minimumAgeYears=18`, `latestAllowedBirthDate(reference)`,
    `isOldEnough(birthDate, reference)`; folded the 18+ gate into `birthStepValid`.
  - `lib/features/calculation_flow/screens/birth_data_screen.dart` — date picker
    `lastDate` now the 18+ cutoff; `initialDate` clamped into
    `[1920-01-01, cutoff]` so a too-recent persisted draft can't trip
    `showDatePicker` asserts.
- **Files changed (tests):**
  - `test/features/calculation_flow/calculation_flow_controller_test.dart` — new
    `Age gate (18+)` group: boundary-inclusive cutoff (helpers tested against a
    fixed reference so they are not date-flaky), plus state/`next()` proof that an
    under-age date can neither validate the birth step nor advance the flow.
  - `test/widget/features/onboarding/onboarding_screen_test.dart`,
    `test/widget/features/settings/settings_screen_test.dart`,
    `integration_test/demo_flow_test.dart` — brand-string assertions updated to
    TrueRise. Internal `RectifyApp`/`pumpRectifyWidget`/`RectifyButtonShell`
    references intentionally unchanged.
- **Behavior changed:** App shows as TrueRise on the iOS/Android home screen, in
  the OS task switcher, on Home, in onboarding, in the settings version row, and
  throughout the privacy screen. The birth-date picker can no longer offer an
  under-18 date, and a persisted under-age draft is blocked from Continue/submit.
  The privacy screen now accurately distinguishes on-device storage, offline demo
  mode, and live-mode network transmission, and restates no-account/no-analytics/
  no-crash-reporting.
- **Design note:** Age cutoff is **dynamic 18+** (`now.year-18`, calendar-day
  inclusive) rather than the PRD's fixed "born before 2008", so the floor stays
  correct as time passes; helper functions take an injected reference, keeping the
  unit tests deterministic.
- **Verification:** `git status --short`, `git diff --stat`; `dart format` on the
  11 changed Dart files (0 reformatted); `rg -n "Rectify" lib ios android test
  integration_test` audited — every remaining hit is internal (Dart class/enum
  names, the `X-Rectify-App-Id` proxy header, test helpers, code/signing-template
  comments), no user-visible copy left. `flutter analyze` -> **No issues found**.
  Targeted tests green, then the **full `flutter test` suite: 242 passed**, and
  `flutter test integration_test/demo_flow_test.dart`: **1 passed**. Toolchain:
  Flutter 3.44.0 / Dart 3.12.0.
- **Limit status:** No usage-limit stop.
- **Open items / remaining P0 blockers (not in this run):** release signing
  (debug-signed release config, G5); hosted privacy-policy URL (G2) + authored
  Apple privacy labels / Play Data Safety (G3); app icon (G4); bundle-ID
  keep-vs-rebrand decision; store metadata (G7) + screenshots (G8); demo-key
  rotation. Localization of the new "Live calculations" copy is deferred to the
  Run C extraction. `CFBundleName`/`applicationId`/namespace deliberately remain
  `rectify` pending the bundle-ID decision.

### 2026-06-02 — Privacy Policy and Store Data Safety Package (Impl Run A.2)

- **Model:** `claude-opus-4-8` (run invoked explicitly under this model).
- **Session id:** not surfaced to the agent this run; omitted.
- **Stage:** Second implementation run from the Run 6 P0 set — produce the
  publication-ready privacy + data-safety package that the hosted privacy-policy
  URL (G2) and the Apple App Privacy / Play Data Safety forms (G3) depend on.
  **Documentation only:** no hosting, no store-console submission, and no app
  code, because those require owner accounts/hosting.
- **Artifacts created:**
  - `docs/privacy-policy.md` — hosted-page-ready **English** policy,
    "Effective date: June 2, 2026", grounded in verified behavior, with
    `[OWNER/LEGAL: …]` blanks for publisher name/contact/URL/jurisdiction and any
    naming of the calculation provider. Covers on-device storage, offline demo
    mode, the explicit live-mode transmission (birth date, approximate birth
    time/window, birthplace text + coordinates when available, life-event
    categories/descriptions over HTTPS solely to compute the result), the
    optional user-supplied API key in secure storage, deletion, no accounts, and
    no analytics/crash/tracking/advertising/sale.
  - `docs/apple-privacy-labels.md` — App Store Connect *App Privacy*
    questionnaire guidance: collected-by-developer vs transmitted-to-provider,
    per-category recommended answers with evidence + confidence, the
    Precise-Location judgment call, ATT (no prompt needed), reviewer note, owner
    checklist, and open questions.
  - `docs/play-data-safety.md` — Play Console *Data safety* guidance: data
    types, the Collected-vs-Shared decision, purposes, encrypted-in-transit,
    in-app deletion, optionality, no ads/tracking/analytics/crash, owner
    checklist, and open questions.
  - This `docs/claude-build-history.md` Run A.2 entry.
- **Grounding (verified read-only this run):**
  - Live mode transmits, over HTTPS, birth date, birth hour/minute + time-search
    window, city text, lat/lon, and per-event category/date/free-text
    description (`lib/data/api/dto/rectification_request_dto.dart`,
    `lib/data/api/mappers.dart`, `lib/data/api/rectification_api.dart`).
  - **Demo mode is fully offline** — the repository short-circuits before any
    HTTP and a Dio client is asserted *never* constructed in demo
    (`lib/data/repos/rectification_repository.dart`, `lib/data/api/api_client.dart`).
  - **City search/geocoding is an on-device stub** — search text is never
    transmitted (`lib/features/calculation_flow/geocoding/geocoding_service.dart`
    `StubGeocodingService`); the live calculation is the **only** user-data
    network egress. `google_fonts` is unreferenced in `lib/` (bundled fonts), so
    no font fetch.
  - Secure storage holds only the user-supplied `pro_api_key`
    (`lib/data/secure/secure_key_store.dart`); local Drift + prefs stay on
    device; Delete-all-data wipes DB + prefs + secure key
    (`lib/data/repos/settings_repository.dart`).
  - **No** analytics/crash/ads/tracking SDKs and **no** accounts (full
    `pubspec.yaml`; `lib/app/router.dart`). The optional calculation **label** is
    stored locally and is **not** sent to the provider.
- **Key decisions / framing:**
  - Birthplace lat/lon (4 decimals) meets the Apple/Google "precise location"
    resolution test but is a *birthplace the user selects*, not device location
    (the app requests no location permission). Both store docs present the
    conservative "declare Precise Location" option **and** the "Other Data / not
    device location" reading, flag it as the key `[OWNER/LEGAL]` call, and
    explicitly **do not hide** it.
  - Collected-vs-Shared (Play) and the provider's processor-vs-third-party
    status are left as `[OWNER/LEGAL]` decisions; conservative default = declare
    Shared while unconfirmed. No DPA, retention period, provider name, company
    name, address, email, or hosted URL was invented — all are marked
    placeholders.
- **Constraints respected:** Documentation only. No writes to `lib/`, `ios/`,
  `android/`, `test/`, `integration_test/`, `pubspec.yaml`, `pubspec.lock`,
  `l10n.yaml`/ARB, `assets/`, `screenshots/`, or `README.md`. No live web
  browsing. No claim of legal compliance or store approval. English only this
  run (localization deferred to the Run C/D pipeline).
- **Verification:** `git status --short`; `git diff --stat`; scoped
  `git status --short -- lib ios android test integration_test pubspec.yaml
  pubspec.lock assets l10n.yaml` → returned exactly the 13 pre-existing Run A.1
  files (all `M`, none added), confirming this run touched no forbidden paths;
  `rg -n "^#|^##|TODO|PLACEHOLDER|OWNER|LEGAL|Location|birthplace|coordinates|life-event|analytics|crash|tracking|advertising|demo"`
  across the three new docs confirmed the headings, the explicit live-mode field
  list, the `[OWNER/LEGAL]` placeholders, and the no-analytics/crash/tracking/
  advertising statements. No code/tests applicable (docs only); Flutter
  toolchain not invoked.
- **Limit status:** No usage-limit stop.
- **Open items (owner/legal, before submission):** host `docs/privacy-policy.md`
  and obtain its public URL (G2); fill every `[OWNER/LEGAL]` blank (publisher
  name/contact, jurisdiction, provider name + its privacy URL, retention,
  processing region, DPA); finalize the Precise-Location classification and the
  health/sensitive free-text treatment; confirm Collected-vs-Shared from the
  provider relationship; enter the App Privacy answers + Play Data Safety form
  (G3); confirm the store age rating matches the in-app 18+ gate; demo/review key
  rotation. Other P0s unchanged: release signing (G5), app icon (G4), bundle-ID
  decision, metadata (G7), screenshots (G8). Localized policy/forms remain
  blocked on the Run C extraction → Run D translation.

### 2026-06-02 — TrueRise App Icon / Launcher Icon Replacement (Impl Run A.3)

- **Model:** `claude-opus-4-8` (run invoked explicitly under this model).
- **Session id:** not surfaced to the agent this run; omitted.
- **Stage:** Narrow P0 store-readiness feature (resolves **G4 — app icon**).
  Replace the stock Flutter launcher icon with a production TrueRise icon for
  iOS and Android. No code, copy, or config behavior changed.
- **Motif / design rationale:** abstract **sunrise / rising-time / measurement**
  mark — a warm rising **sun** (vertical clay gradient, `accentClay`-family top
  `#CB794A` → `accentClayDeep #7A4124`) cresting a calibrated **horizon bar**, a
  thin **altitude arc** above it, and ruler-style **calibration ticks** below
  (the center reference tick taller). On a `deepMidnight #1B2735` →
  `deepMidnightSoft #2A3A4A` field with a subtle warm glow behind the sun
  (iOS/legacy only). Reads as birth-time *estimation/calibration*, **not**
  horoscope/fortune-telling. **No text, no Flutter logo, no zodiac glyphs, no
  purple/pink/neon.** Bone (`bgApp #FBF8F2`) for horizon/arc/ticks. Core
  silhouette (sun + horizon) stays legible at 20 px; fine ticks/arc degrade
  gracefully via area-downsampling.
- **Artifacts changed:**
  - iOS — **all 15** `ios/Runner/Assets.xcassets/AppIcon.appiconset/*.png`
    regenerated at the exact `Contents.json` pixel sizes (20→1024), every file
    **8-bit RGB, no alpha**; the `1024×1024` marketing icon is the master render.
  - Android legacy — `mipmap-{mdpi,hdpi,xhdpi,xxhdpi,xxxhdpi}/ic_launcher.png`
    replaced at **48/72/96/144/192** (full-bleed, opaque RGB).
- **Artifacts created:**
  - Android adaptive — `mipmap-{…}/ic_launcher_foreground.png` at
    **108/162/216/324/432** (transparent RGBA; motif scaled to the 66/108 safe
    zone, `scale≈0.62`).
  - `mipmap-anydpi-v26/ic_launcher.xml` (`adaptive-icon`: background
    `@color/ic_launcher_background`, foreground `@mipmap/ic_launcher_foreground`).
  - `values/ic_launcher_background.xml` (`ic_launcher_background = #1B2735`).
  - This `docs/claude-build-history.md` Run A.3 entry.
- **Generation method:** reproducible **pure-Python stdlib** renderer
  (`zlib`+`struct` PNG encoder, SDF shapes with analytic anti-aliasing,
  premultiplied area downsample) — Pillow/numpy/ImageMagick were **absent** and
  no packages were installed and no network used. Temp generator lived under
  `/tmp` and was **removed** after generation (nothing left in the repo).
- **Decisions / scope:** **AndroidManifest left untouched** — no `roundIcon`
  added: the manifest's `@mipmap/ic_launcher` resolves to the new adaptive XML
  on API 26+ (our Android floor is API 29, so every target device uses the
  adaptive icon), and round-only resources without a manifest reference would be
  dead. No Android-13 monochrome/themed layer this run. The pre-existing
  `android:label`/`CFBundleDisplayName` → "TrueRise" diffs are from Run A.1, not
  this run.
- **Constraints respected:** writes confined to the allowed icon/XML paths. No
  writes to `lib/`, `test/`, `integration_test/`, `pubspec.yaml`/`.lock`,
  `ios/Runner/Info.plist`, `ios/Runner.xcodeproj/`, `android/app/build.gradle.kts`,
  `AndroidManifest.xml`, `assets/`, `README`, or any doc other than this one. No
  secrets touched/logged. No claim of legal or store approval.
- **Verification:** `git status --short`, `git diff --stat`; scoped
  `git status --short` over the forbidden set showed only the **pre-existing
  A.1/A.2** dirty files (none added by this run) and confirmed `pubspec*`,
  `Runner.xcodeproj`, `build.gradle.kts` clean. A pure-Python PNG header/decoder
  audit confirmed: **iOS 15/15** files at the expected dims and **colortype RGB
  (2), no alpha**; Android legacy **48/72/96/144/192**; foregrounds
  **108/162/216/324/432**, **RGBA (6)**, transparent corners + opaque motif
  (alpha 0–255). The 1024 marketing icon **crc changed** (`1198400731` →
  `1099947752`), avg RGB `(54.8,57.0,64.5)` dark-navy, corner exactly
  deepMidnight `(27,39,53)`, sun pixel warm clay `(145,81,47)` — confirmed **no
  longer the Flutter logo**. Both new XML files parsed
  (`adaptive-icon` / `resources`). **`flutter build apk --debug` → `✓ Built
  app-debug.apk`** (~24 s; only an unrelated `shared_preferences_android` KGP
  deprecation warning); `unzip -l` confirmed `res/mipmap-anydpi-v26/ic_launcher.xml`
  + all `ic_launcher.png`/`ic_launcher_foreground.png` densities packaged.
  Toolchain: Flutter 3.44.0 / Dart 3.12.0, Android SDK at `~/Library/Android/sdk`.
- **Limit status:** No usage-limit stop.
- **Open items:** G4 (icon) resolved. Not done this run (out of scope): Android-13
  themed/monochrome icon layer, iOS dark/tinted icon variants, and round-icon
  resources. A designer pass is advisable before final submission, but the set is
  store-valid. Other P0s unchanged — release signing (G5), hosted privacy-policy
  URL (G2) + privacy labels/Data Safety (G3), bundle-ID decision, store metadata
  (G7), screenshots (G8), demo-key rotation.

### 2026-06-02 — English Store Metadata Finalization (Impl Run A.4)

- **Model:** `claude-opus-4-8` (run invoked explicitly under this model).
- **Session id:** not surfaced to the agent this run; omitted.
- **Stage:** Owner-independent part of **P0-8** (store metadata) in
  `docs/store-submission-readiness.md`. Produce a ready-to-paste **English Tier 0**
  metadata package for App Store Connect + Google Play, and replace the `pubspec`
  placeholder description. No app code, copy, config, or behavior changed.
- **Artifacts created:**
  - `docs/store-listing-en.md` — decision summary (brand TrueRise, utility/4.3(b)
    positioning, iOS **Utilities** + optional Reference / Play **Tools**, owner
    gating items); full **App Store** package (Name, Subtitle + 2 alts, Promo +
    alt, Full Description, iOS keyword field shown exactly, App Review Notes);
    full **Google Play** package (Title, Short + 2 alts, Full description, tags +
    search phrases + category, Reviewer notes); ASO query→placement mapping table
    (compete / stretch / reach-only lanes); 4-frame screenshot **copy** plan
    (captions only — no image files created); compliance guardrails; final owner
    checklist; preserved-source map.
  - This `docs/claude-build-history.md` Run A.4 entry.
- **Artifacts changed:**
  - `pubspec.yaml` — line 2 `description:` only, placeholder
    `"A new Flutter project."` → `"TrueRise estimates a likely birth time from
    your life events, with a confidence score and per-event evidence. Private and
    on-device."` (132 chars). No other key touched; deps and `pubspec.lock`
    untouched.
- **Finalized values (char counts re-verified this run):** iOS App Name
  `TrueRise: Birth Time Finder` (27/30); iOS Subtitle `Rectify your birth time`
  (23/30) + alts `Estimate your birth time` (24), `Find your real birth time`
  (25); iOS Promo (138/170); iOS keyword field recommended **92/100**
  (`rectification,ascendant,rising,natal,chart,calculator,unknown,accurate,astrology,houses,sign`,
  0 spaces, 11 terms) / conservative **89/100** (10 terms); Play Title 27/30;
  Play Short `Estimate your unknown birth time from real life events. Private,
  on-device.` (75/80). Full descriptions well under 4000.
- **Posture / decisions:** copy is utility-first and **probabilistic** (most-likely
  time + confidence, never certainty); astrology named only as *method*; no
  fortune-telling lexicon; explicit "not medical/psychological/legal/financial
  advice, not deterministic" line in both long descriptions. Sharing copy is tied
  to the **shipped PII-free text share** (time + rising + confidence + brand) — no
  image/share-card implied (unbuilt V1.5). Reviewer notes lead with **offline
  Demo mode** (no key/payment to review), disclose live-mode HTTPS field transfer
  to a third-party provider, note **no device Location permission** (birthplace
  coords are user-selected, not GPS), and carry an `[OWNER: hosted URL]`
  placeholder. Pulls authoritative data posture from `docs/apple-privacy-labels.md`
  / `docs/play-data-safety.md`; preserves Run 2/3/4/6 conclusions without changing
  them.
- **Constraints respected:** writes confined to `docs/store-listing-en.md`,
  `pubspec.yaml` (description line only), and this file. **No** edits to `lib/`,
  `test/`, `integration_test/`, `ios/`, `android/`, `assets/`, l10n, screenshots,
  `README`, privacy-policy docs, or existing research docs. No dependencies added;
  `pubspec.lock` not modified; no screenshots created and no simulator run. No
  secrets touched/logged. No deterministic/medical/legal/financial/fortune-telling
  claims. No store ranking/approval/trademark assertion. A.1/A.2/A.3 work left
  intact.
- **Verification:** `git status --short` (confirms only `docs/store-listing-en.md`
  added + `pubspec.yaml` and this doc modified by this run; all other dirty paths
  pre-existing from A.1/A.2/A.3); `git diff -- pubspec.yaml` (single-line
  description change); Python char-count check of every hard-limit field (results
  above — all within limits); Ruby `YAML.load_file` parse of `pubspec.yaml`
  succeeded (`name=rectify`, `description` len 132 → valid YAML).
- **Limit status:** No usage-limit stop.
- **Open items (owner, gate submission):** hosted privacy-policy URL; support
  URL/email; bundle/package-ID decision (before first store record); release
  signing; **screenshots** (next run, per the §5 copy plan); trademark clearance +
  App Store name availability; in-console character re-count; category & age-rating
  confirmation (18+); Apple privacy labels + Play Data Safety completion incl. the
  precise-location classification call; demo/review key rotation.

### 2026-06-02 — P0 Store Screenshot Set Capture, English Tier 0 (Impl Run A.5)

- **Model:** `claude-opus-4-8` (run invoked explicitly under this model).
- **Session id:** not surfaced to the agent this run; omitted.
- **Stage:** Owner-independent **P0 screenshot gate (G8)** in
  `docs/store-submission-readiness.md`. Capture an initial **English Tier 0**
  store screenshot set from the **shipped Flutter UI** (real widgets/routes/state,
  not mockups), per the 4-frame copy plan in `docs/store-listing-en.md` §5. No app
  code, copy, config, or behavior changed.
- **Artifacts created (all under `screenshots/store/en/`):**
  - `01-result-hero.png` — 1290×2796, 152,519 B. Result hero: most-probable
    **7:14 AM**, **Gemini Rising**, **78%** confidence bar, alternate candidates
    (7:42 AM 61% / 8:03 AM 44%), **DEMO** pill, "See how we got this" CTA.
  - `02-evidence-breakdown.png` — 1290×2796, 311,037 B. Evidence: "Why 7:14 AM?
    4 of 6 events strongly supported this time." Per-event **STRONG / MODERATE /
    WEAK** match cards.
  - `03-privacy-demo-settings.png` — 1290×2796, 193,204 B. Settings: **Demo mode**
    toggle ON ("free, no network"), optional API key, 12h/24h time format,
    **Delete all data** ("Cannot be undone").
  - `04-share-result.png` — 1290×2796, 152,519 B. Clean result viewport with the
    shipped **Share result** affordance visible in context (OS sheet not capturable
    — see limitations).
  - `05-privacy-policy.png` — 1290×2796, 433,627 B. **Bonus** frame: in-app
    Privacy screen (on-device storage, offline demo, live-mode HTTPS, no accounts).
  - `README.md` + `manifest.json` — capture method, per-frame map, intended §5
    caption overlays (not baked in), the verbatim **PII-free share text**, and the
    limitations below.
  - This `docs/claude-build-history.md` Run A.5 entry.
- **Method:** throwaway widget-test harness under `/tmp` (removed after the run;
  copied `test/helpers` fakes alongside it, also removed). Ran on the host VM via
  `flutter test`; rendered the real `RectifyApp` inside a `RepaintBoundary` and
  wrote `boundary.toImage(pixelRatio: 3)` → PNG with `dart:io`. **Demo mode**
  (offline — no network, no API key) drove a canonical **6-event** calculation
  through the real `calculation_flow` controller, then `go_router` navigated to
  each route. Product fonts (Inter / SourceSerif4 / JetBrainsMono) loaded from the
  bundled `FontManifest.json` so text renders as real glyphs. iPhone 6.7"/Pro Max
  geometry: physicalSize 1290×2796 @ DPR 3.0, safe-area insets top 177 / bottom
  102 px. **One frame per process** (one screenshot per `flutter test` run): on
  this toolchain `flutter_tester` crashes with SIGTERM the instant a *second*
  `toImage` runs in the same isolate, but the first capture always flushes to disk
  first — so per-process capture yields all five frames reliably.
- **Share payload (documented, PII-free):** frame 4's shipped Share action emits
  the `ShareCopyBuilder` text — only time + rising + confidence + brand, **no birth
  date / birthplace / events / PII**. For the canonical demo result, exactly:
  `My TrueRise rectification result:\n7:14 AM · Gemini Rising · 78% confidence\n\nCalculated with TrueRise — birth-time rectification`.
- **Limitations (in README/manifest):** the native **OS share sheet cannot be
  captured** from the host `flutter test` binding — frame 4 shows the shipped
  in-app Share button and the exact emitted text is recorded verbatim; frames are
  **raw resolution with no caption overlays / device bezels** (compositing the §5
  captions is owner work); values come from the **offline DEMO** dataset (DEMO
  badge visible in-frame, matching the honest/probabilistic store framing); **6.7"
  portrait only** (same harness can emit another size by changing view geometry).
- **Constraints respected:** writes confined to `screenshots/store/en/*` and this
  append-only file. **No** edits to `lib/`, `test/`, `integration_test/`, `ios/`,
  `android/`, `assets/`, l10n, `README.md`, `pubspec.yaml`, or `pubspec.lock`; **no
  dependencies added**; **no commit**. All UI is **real shipped Flutter UI** — no
  fabricated screens and no fake share-card image (text-share only). Bundled demo
  `.env` key never printed, logged, or written to any artifact. A.1/A.2/A.3/A.4
  dirty changes left intact.
- **Verification:** `sips` on all five PNGs → every file **1290×2796**, format
  PNG, non-zero bytes (sizes above); each frame **visually inspected** (image read)
  to confirm real glyphs/widgets and no `.notdef` tofu; `git status --short` →
  only `screenshots/` is newly added and this doc modified by this run, every other
  dirty path pre-existing from A.1–A.4; `/tmp` harness and copied fakes confirmed
  removed.
- **Limit status:** No usage-limit stop.
- **Open items (owner):** composite the §5 marketing captions / device bezels if
  desired; optional second **Play / other-size** variant; remaining P0 owner gates
  unchanged (hosted privacy-policy URL, support URL/email, bundle-ID decision,
  release signing, trademark clearance + App Store name availability, in-console
  character re-count, category & age-rating confirmation, Apple privacy labels +
  Play Data Safety completion, demo/review key rotation).

### 2026-06-03 — P0 Localization Pipeline + English Extraction (Impl Run C.1)

- **Model:** `claude-opus-4-8` (run invoked explicitly under this model).
- **Session id:** not surfaced to the agent this run; omitted.
- **Stage:** **G20 (localization infrastructure + English extraction)** and
  **G21 (locale-aware date/time/month formatting)** per
  `docs/l10n-string-audit.md`. Made the shipped UI translatable while keeping
  English behavior byte-stable. **Translations for de/fr/es/pt are explicitly
  out of scope** for this run and were **not** created.
- **What changed:**
  - **gen-l10n pipeline (G20):** `flutter_localizations` + `generate: true`
    (`pubspec.yaml`), `l10n.yaml`, and `lib/l10n/l10n.dart` (re-exports
    `AppLocalizations`, the `context.l10n` extension, and
    `const appBrandName = 'TrueRise'`). Generated `app_localizations.dart` +
    `app_localizations_en.dart` from a single **`lib/l10n/app_en.arb`** holding
    **214 user-visible message keys** with `@`-metadata. Covers onboarding,
    calc-flow (birth/window/events/confirm/loading), result + evidence, history
    + home, settings cluster + privacy, error screens, navigation/stepper,
    add-event sheet, demo labels, match-strength + event-category labels, and
    key `Semantics` labels. ICU **plural/select** used where counts/enums vary;
    the brand is held constant via a `{brand}` placeholder (passed
    `appBrandName`) so **"TrueRise" is never translated**; no "Rectify" brand
    strings reintroduced.
  - **Locale-aware formatting (G21):** `lib/core/formatting/app_date_format.dart`
    wraps `intl` `DateFormat` (clock time, long date `yMMMMd`, optional
    month/year, month abbrev) and replaced hand-rolled AM/PM logic and the
    duplicated month-name maps in the picker fields / nav widgets. **12h/24h**
    selection preserved; canonical demo sample times stay byte-stable
    (**7:14 AM** / **07:14**).
  - **Demo evidence prose (G20 P1, batch C8):** the six canonical evidence
    explanations moved out of `lib/data/demo/demo_response.dart` into ARB keys
    (`demoEvidence{StrongVenus,StrongSaturn,ModerateJupiter,ModerateSolarArc,
    WeakMercury,NoMatch}`, sensitive register: indication wording, not proof).
    Because `buildDemoResult` is data-layer (no `BuildContext`) but its prose is
    persisted like live results, a small `DemoEvidenceCopy` value object is
    resolved once on the loading screen (`DemoEvidenceCopy.fromL10n(context.l10n)`)
    and threaded `loading_screen → controller.submit → repository.submit →
    buildDemoResult`. The demo path remains **offline** — no `BuildContext` and
    no network reach the data layer.
- **Artifacts changed in this run:** `lib/l10n/app_en.arb`
  (+ regenerated `app_localizations.dart`, `app_localizations_en.dart`);
  `lib/data/demo/demo_response.dart`, `lib/data/repos/rectification_repository.dart`,
  `lib/features/calculation_flow/screens/loading_screen.dart`,
  `lib/features/calculation_flow/state/calculation_flow_controller.dart`,
  `lib/features/error_flow/error_screen.dart`,
  `lib/features/home/home_history_screen.dart`, the settings cluster
  (`settings_screen.dart`, `api_key_sheet.dart`, `delete_all_data_sheet.dart`,
  `privacy_policy_screen.dart`), and nav/input widgets
  (`top_nav.dart`, `stepper_header.dart`, `bottom_tab_bar.dart`,
  `date_picker_field.dart`, `time_picker_field.dart`). Tests:
  `test/data/demo/demo_response_test.dart`,
  `test/data/repos/rectification_repository_test.dart`,
  `test/helpers/fake_rectification_repository.dart`, the three calc-flow widget
  tests, and a new `test/helpers/demo_fixtures.dart`
  (`testDemoEvidenceCopy = DemoEvidenceCopy.fromL10n(AppLocalizationsEn())`).
  This `docs/claude-build-history.md` Run C.1 entry. The C0–C4 foundation
  (l10n.yaml, l10n.dart, app_date_format.dart, early-batch screens) plus store
  assets were already committed earlier in `72d6003` (made outside this run —
  see Notes).
- **Verification:** `flutter pub get` OK; `flutter gen-l10n` regenerated cleanly
  (English getters byte-identical to source copy); `dart format` on the run's
  non-generated Dart (1 file normalized, no logic change); `flutter analyze
  --no-pub` → **No issues found**; `flutter test --exclude-tags backend --no-pub`
  → **250 tests passed, 0 failed** (backend-tagged live-API tests excluded by
  design). `git diff --check` clean; `git status --short` shows only this run's
  files; `ls lib/l10n/*.arb` → **only `app_en.arb`** (no de/fr/es/pt). The
  existing "demo submit never calls RectificationApi.rectify" test still passes,
  confirming the demo path stays offline after the `DemoEvidenceCopy` threading.
- **Constraints respected:** **no commit, no push.** Only the single English
  ARB exists — no target-locale ARBs created. No deferred MVP scope added
  (no payments/IAP/accounts/sync/dark-mode/chart/export/Vedic toggles). No
  secrets in source/logs/ARB/generated/docs. Demo mode unchanged and offline.
  Generated files refreshed via gen-l10n only (no hand edits). No `ios/`,
  `android/`, `assets/`, or `README.md` edits.
- **Notes:** commit `72d6003 feat: prepare store assets and localization
  groundwork` (timestamped 2026-06-02, **made outside this agent run**) bundled
  store assets with the C0–C4 l10n groundwork; flagged here for owner
  visibility. Internal-only failure payloads (e.g. the `BadRequestFailure`
  string in the calc-flow controller) were intentionally **not** extracted —
  they are never rendered; user-facing error copy comes from the ARB.
- **Limit status:** No usage-limit stop.
- **Open items (owner / future run):** author de/fr/es/pt ARBs and wire
  `supportedLocales` for the target markets (deferred per this run's scope);
  re-screenshot any locale-specific store frames once translations land.

### 2026-06-03 — Tier 1 In-App Translation: de / fr / es / pt-BR (Impl Run D.1)

- **Model:** `claude-opus-4-8` (run invoked explicitly under this model).
- **Session id:** `8f8500f3-1a90-45f8-b470-8fabfe7c3cf6`.
- **Stage:** **G22 (Tier 1 translation)** per `docs/l10n-strategy.md` §1/§3 and
  the §12 acceptance list. Authored target-locale ARBs for German, French,
  Spanish, and Brazilian Portuguese on top of the English base extracted in
  Run C.1 (`c4ae0c6`). Translation-only run: no marketing/product features,
  store metadata, screenshots, payments, accounts, sync, dark mode, export,
  charts, or other deferred scope touched.
- **What changed:**
  - **Four target-locale ARBs created** in `lib/l10n/`: `app_de.arb`,
    `app_fr.arb`, `app_es.arb`, and `app_pt.arb`. Each holds **215 translated
    values** plus `@@locale`, in the same key order as `app_en.arb`, with
    **zero missing/extra keys** and **no `@`-metadata objects** (target ARBs are
    values-only by Flutter convention; gen-l10n reads descriptions/placeholders
    from the English template only).
  - **Tone/terminology per `docs/l10n-strategy.md` §6–§8** honored: probabilistic
    register preserved (no certainty words); **evidence → indication words**, never
    proof words (de *Hinweise/Anhaltspunkte* not *Beweise*; fr *indices* not
    *preuves*; es *indicios* not *pruebas*; pt *indícios* not *provas*);
    **confidence → probability/level** wording (de *Wahrscheinlichkeit*; fr/es/pt
    *niveau/nivel/nível de confiance/confianza/confiança*); privacy promises
    translated precisely; no horoscope/fortune-telling or paywall register; de
    uses the informal *du* throughout; es applies inverted *¿…?/¡…!*; pt uses
    Brazilian forms (*horário*, *compartilhar*, *Excluir*, *Configurações*).
  - **Invariants preserved across all four files:** the `{brand}` placeholder is
    never literalized ("TrueRise" never typed as text); all ICU placeholders,
    `plural` (`=1`/`other`), and `select` selector keywords
    (`strong`/`moderate`/`weak`/`none`/`true`/`other`) kept byte-identical;
    untranslated tokens held stable — `astrology-api.io`, `sk-…`, the canonical
    sample times `7:14 AM` / `07:14`, the `DEMO` pill label, `✓`, `±`, and `\n`.
    Demo-evidence astrology prose translated naturally, including conventional
    localized planet names (e.g. de *Merkur*, fr *Mercure*, es *Mercurio*, pt
    *Mercúrio*).
  - **No app/router wiring changes needed:** `lib/app/app.dart` already consumes
    the generated `AppLocalizations.localizationsDelegates` /
    `AppLocalizations.supportedLocales` (added in Run C.1). Adding the ARBs and
    regenerating auto-registered the new locales — confirmed
    `supportedLocales = [de, en, es, fr, pt]`.
- **Portuguese filename/locale deviation (flagged for owner/verifier):** the
  brief named `app_pt_BR.arb` (locale `pt_BR`), but `flutter gen-l10n` on
  Flutter 3.44 **hard-fails (exit 1)** for a region-only locale that lacks its
  base: *"Arb file for a fallback, pt, does not exist … a base locale … should
  exist as the fallback."* The binding strategy guide's own acceptance list
  (`docs/l10n-strategy.md` §12) specifies **`app_pt.arb` (pt-BR)** — a base `pt`
  file carrying Brazilian content. Resolution: the file is named **`app_pt.arb`**
  with `@@locale: "pt"` and Brazilian Portuguese content. This passes gen-l10n
  with no duplicate/empty files; generic `pt` and (future) `pt_BR` devices both
  resolve to the Brazilian translation. **Net effect vs. the brief:** the
  Portuguese ARB is `app_pt.arb` (not `app_pt_BR.arb`) and the supported locale
  is `pt` (not `pt_BR`). `lib/l10n` therefore contains exactly five ARBs:
  `app_en.arb`, `app_de.arb`, `app_fr.arb`, `app_es.arb`, `app_pt.arb`.
- **Artifacts changed in this run:** new `lib/l10n/app_de.arb`,
  `lib/l10n/app_fr.arb`, `lib/l10n/app_es.arb`, `lib/l10n/app_pt.arb`; regenerated
  `lib/l10n/app_localizations.dart` and new generated
  `app_localizations_{de,es,fr,pt}.dart`; this `docs/claude-build-history.md`
  Run D.1 entry. No edits to `lib/app/app.dart`, `l10n.yaml`, `pubspec.yaml`,
  source screens/widgets, `ios/`, `android/`, `assets/`, or `README.md`.
- **Verification:** `flutter gen-l10n` → **exit 0**, clean (no fallback error
  after the `app_pt.arb` resolution); `flutter analyze --no-pub` → **No issues
  found**; `flutter test --exclude-tags backend --no-pub` → **250 tests passed,
  0 failed**; `git diff --check` → **clean (exit 0)**; key-parity check → all
  four target ARBs have 215 keys, 0 missing, 0 extra, valid JSON;
  `ls lib/l10n/*.arb` → exactly `app_en`, `app_de`, `app_es`, `app_fr`,
  `app_pt`; generated `supportedLocales` = `[de, en, es, fr, pt]`.
- **Constraints respected:** **no commit, no push** (Codex verifies/commits
  after this run). Translation-only; no deferred MVP scope added; no secrets in
  source/logs/ARB/generated/docs; demo mode untranslated-token-safe and
  unchanged. Generated files refreshed via gen-l10n only (no hand edits).
- **Limit status:** No usage-limit stop.
- **Open items / risks (owner / future run):** (1) **`pt` vs `pt_BR`** — confirm
  whether a region-specific `pt_BR` listing is required; if so, keep `app_pt.arb`
  as the base and add a thin `app_pt_BR.arb` override (Flutter region-fallback
  pattern). (2) All terms remain **`[PROPOSED]`** pending native-speaker review
  per `docs/l10n-strategy.md` §13 (esp. de *du/Sie* register, es neutral vs
  es-419 split, evidence/confidence wording, privacy copy). (3) Per-locale
  **layout/overflow QA** (strategy §11) not run here — de compounds and Romance
  +15–20% length still need on-device checks (DEMO pill, tab labels, buttons).
  (4) Localized store metadata + screenshots (surfaces B/C, strategy §5/§9)
  remain out of scope. (5) A few subagent judgment calls flagged for review:
  pt `navSettings`→"AJUSTES" (short, for the narrow tab) vs *Configurações*
  elsewhere; pt `resultRisingSign`→"Ascendente em {sign}"; es plural-article
  assumptions in `evidenceWhyTitle`/`timeWindowRangeCopy` ("las {time}").
- **Limit/quota:** none hit.

### 2026-06-03 — Localized UI Layout / Overflow QA (Impl Run D.2)

- **Model:** claude-opus-4-8. **Session id:**
  `5234385b-48f9-4c13-b7e0-71780bc6bd5d`.
- **Predecessor:** continues from clean checkpoint `25063df` (Run D.1, Tier 1
  in-app translations de/fr/es/pt). Directly addresses Run D.1 open item #3
  ("Per-locale layout/overflow QA … de compounds and Romance +15–20% length
  still need checks — DEMO pill, tab labels, buttons"). No commit, no push —
  Codex verifies/commits after this run.
- **Goal:** confirm that text, buttons, icons and screens do not drift, overlap,
  truncate badly, or overflow once the longer German + Romance strings render,
  and fix only the surfaces that genuinely break. Scope limited to layout/
  overflow QA — no marketing, store metadata, screenshots, payments, accounts,
  sync, charts, dark mode, or export.
- **Method:** added localized render tests (German + French at text scale 1.0
  and Dynamic Type ×1.3) across the high-risk surfaces, relying on Flutter's
  in-test RenderFlex/RenderConstrainedBox overflow exceptions surfaced via
  `tester.takeException()`. Fixes applied empirically — only where a test
  actually flagged an overflow.
- **Finding:** the single genuine regression was the **bottom tab bar** label.
  Under German at Dynamic Type ×1.3 "EINSTELLUNGEN"/"VERLAUF" wrapped to a
  second line and overflowed the fixed 56pt slot by ~6px. Every other audited
  surface (top nav, stepper, time-format radios, date/category pickers,
  month/year row, evidence card, error scaffold, add-event sheet, settings
  `_ChevronRow`, API-key + delete-all sheets, onboarding slides/CTAs) rendered
  clean under de/fr — buttons were already protected (Flexible + maxLines:1 +
  ellipsis), top nav already ellipsizes, and Expanded-based rows wrap/grow
  without throwing.
- **Fix (1 file, design-preserving):** `lib/widgets/nav/bottom_tab_bar.dart` —
  wrapped the tab label in `FittedBox(fit: BoxFit.scaleDown)` with the Text set
  to `maxLines: 1, softWrap: false`. Normal-length labels render unchanged at
  11pt; only the rare long-label-at-large-scale case shrinks to fit, keeping
  the whole word readable instead of ellipsizing or wrapping. No other source
  files touched; no translation wording changed.
- **Artifacts changed in this run:**
  - `lib/widgets/nav/bottom_tab_bar.dart` (the only production fix).
  - `test/helpers/widget_test_harness.dart` — `wrapInRectifyApp` /
    `pumpRectifyWidget` gained optional `locale` + `textScaler` params.
  - `test/widget/l10n/localized_overflow_test.dart` (new) — leaf-component
    overflow matrix: bottom tabs (all 3 states), stepper, time-format radios,
    date picker (long category value + month/year row), evidence card, error
    scaffold (timeout + no-internet), add-event sheet; each under de/fr × scale
    {1.0, 1.3}.
  - `test/widget/l10n/localized_screens_test.dart` (new) — full-router German
    integration: onboarding 3 slides + CTAs, settings rows/cards (asserts the
    long "API-Schlüssel (Pro / Entwickler)" + "Nicht festgelegt" row), and the
    API-key + delete-all sheets.
  - this `docs/claude-build-history.md` Run D.2 entry.
- **Verification:** `flutter gen-l10n` → exit 0 (uses `l10n.yaml`); `flutter
  analyze --no-pub` → **No issues found**; `flutter test --exclude-tags backend
  --no-pub` → **262 tests passed, 0 failed** (was 250 in D.1 + 12 new localized
  cases); `git diff --check` → clean (exit 0). The bottom-tab fix was confirmed
  by a red→green cycle (test caught the 6px overflow before the fix, passed
  after).
- **Constraints respected:** no commit, no push; scope confined to layout/
  overflow QA; no deferred MVP scope added; demo mode untouched; no secrets in
  source/logs/ARB/generated/docs; generated l10n refreshed via gen-l10n only.
- **Residual risk / open items:** (1) Full-screen integration tests force the
  German *locale* but run at text scale 1.0 — reliably injecting Dynamic Type
  ×1.3 through the live `MaterialApp.router` is not straightforward, so the
  ×1.3 dimension is covered at the component level only. The settings
  `_ChevronRow` and demo nudge use Expanded labels that grow vertically rather
  than overflow, so ×1.3 risk there is low but unverified end-to-end.
  (2) The demo-upgrade nudge inside the result screen was reviewed by
  inspection (Expanded title wraps; body full-width; CTA is a protected button)
  rather than driven via the full demo flow. (3) On-device visual polish (exact
  ellipsis/shrink aesthetics of the German tab label at extreme Dynamic Type)
  still warrants a manual pass. (4) Translations remain `[PROPOSED]` pending
  native-speaker review (carried over from D.1).
- **Limit/quota:** none hit.

### 2026-06-03 — Tier 1 Localized Store Metadata Drafts: de / fr / es / pt-BR (Impl Run D.3)

- **Model:** claude-opus-4-8. **Session id:**
  `e51e703d-9c09-418e-911c-aa5df666f78e`.
- **Predecessor:** continues from clean checkpoint `b740082` (Run D.2, localized
  layout/overflow QA). Documentation only — no commit, no push.
- **Goal:** produce a ready-to-review localized **store-metadata** package for
  the four Tier 1 locales (de/fr/es/pt-BR), parallel to the English Tier 0
  listing (`docs/store-listing-en.md`). Drafts only — every string is
  `[PROPOSED]` and gated on native-speaker review before any console entry.
- **Scope guard:** documentation only. No app code, ARB translations, ios/
  android config, assets, screenshots, pubspec, tests, README, or privacy/data-
  safety docs, and no generated files were touched. No secrets. Brand token
  "TrueRise" kept verbatim in every locale; only descriptors localized.
- **What changed:** created `docs/store-listing-tier1-localized.md` — a single
  source covering, per locale: App Store package (app name ≤30, subtitle +
  alternative ≤30, promotional text ≤170, full description, iOS keyword field
  ≤100 with no comma-spaces, reviewer note) and Google Play package (title ≤30,
  short description ≤80, full description ≤4000, category/tags, search-phrase
  mapping, reviewer note); plus shared English canonical reviewer notes with
  optional localized one-liners, a screenshot-caption localization plan (4
  captions × 4 locales, no images produced), per-locale ASO query mapping
  (compete/stretch/reach-only lanes, avoided fortune-telling terms), per-locale
  owner/native-review checklists, a status/gates header, and a character-count
  summary table.
- **Terminology discipline:** honest-confidence wording per
  `docs/l10n-strategy.md` §7/§8 — confidence renders as Wahrscheinlichkeit /
  niveau de confiance / nivel de confianza / nível de confiança; evidence as
  Hinweise / indices / indicios / indícios (never Beweise/preuve/pruebas/
  provas). No horoscope/zodiac/fortune lexicon in any visible field; astrology
  appears only as the method (transits/progressions). pt-BR uses horário /
  compartilhar; es uses inverted ¿¡; de uses informal du.
- **pt-BR app-name constraint:** the high-intent `TrueRise: Horário de
  nascimento` is 31 chars (over the 30 limit) and is documented as the rejected
  alternative; primary name uses `TrueRise: Horário natal` (23), with the full
  "horário de nascimento" phrase carried in the subtitle / short description /
  full description where no hard limit applies.
- **Artifacts changed in this run:**
  - `docs/store-listing-tier1-localized.md` (new) — the localized metadata
    package.
  - this `docs/claude-build-history.md` Run D.3 entry.
- **Verification:** a throwaway counter (run from `/tmp`, **not** committed, to
  keep the working tree doc-only) NFC-normalizes and counts code points for all
  34 hard-limited fields — every published field is within limit (full
  descriptions de 2376 / fr 2534 / es 2299 / pt-BR 2397 of 4000; all names ≤28;
  all subtitles ≤29; promos ≤164; keyword fields ≤89), the one over-limit string
  (pt-BR 31-char name) is flagged and documented as rejected, and no keyword
  field contains a comma-space. With the doc present, the script also asserts
  every counted string appears in it **verbatim** (in-doc = yes for all 34),
  proving the published counts belong to the published strings. Grep checks: no
  "guarantee/#1/best/top-rated" marketing claims (only the two honest "not
  guaranteed" disclaimers); proof/certainty words appear only in negations and
  terminology-guidance rows; "TrueRise" intact 32× with no broken/localized
  variant; `[PROPOSED]` and native-review markers present. `git status` shows
  only the two intended docs; `git diff --check` → clean (exit 0).
- **Constraints respected:** documentation only; no commit, no push; no deferred
  MVP scope implied (no payments/IAP/paywall/accounts/sync/charts/dark-mode/
  export, and no share-card image — text share only); no deterministic,
  predictive, medical, legal, or financial claims; no secrets in source/logs/
  ARB/generated/docs; brand token kept English.
- **Residual risk / open items:** (1) all copy is `[PROPOSED]` machine drafts —
  native-speaker review is mandatory before publishing, German hardest (Run 2
  W2 credibility bar). (2) Owner gates still open: legal/privacy review of the
  localized privacy sentences, console re-count (consoles are authoritative; the
  script is a portable proxy), trademark/store-name availability per market,
  hosted localized privacy/support URLs, and final iOS/Play category + 18+
  age-rating decisions. (3) Screenshot captions are drafted, not produced — they
  need the same native review and must be baked into a future capture run. (4)
  fr/es/pt-BR keyword fields have spare characters; if a reviewer adds long-tail
  terms, re-count in-console.
- **Limit/quota:** none hit.

### 2026-06-03 — Tier 1 Localized Raw Store Screenshots: de / fr / es / pt-BR (Impl Run D.4)

- **Model:** claude-opus-4-8. **Session ids:** initial screenshot harness work
  `adb58a20-d415-4a59-8fb2-0293cc2b712a`; resumed capture/documentation work
  `bb16fc7d-5344-46bc-8bcd-6d619385f235`. No commit, no push by Claude —
  Codex verifies/commits after this run.
- **Predecessor:** continues from clean checkpoint `4ce66ef` (Run D.3,
  localized store metadata drafts).
- **Goal:** create owner-independent, localized, raw App Store / Play-ready
  screenshot source sets for Tier 1 locales: `screenshots/store/de/`,
  `screenshots/store/fr/`, `screenshots/store/es/`, and
  `screenshots/store/pt-BR/`.
- **Artifacts created:** each locale directory now contains five raw PNG frames:
  `01-result-hero.png`, `02-evidence-breakdown.png`,
  `03-privacy-demo-settings.png`, `04-share-result.png`, and
  `05-privacy-policy.png`; plus `README.md` and `manifest.json`. Store locale
  `pt-BR` maps to app locale `pt`, carrying Brazilian Portuguese content.
- **Capture method:** a throwaway `/tmp/rectify_shotcap` widget-test harness
  rendered the shipped `RectifyApp` from real widgets/routes/state in fully
  offline Demo mode. It forced the target locale, drove the canonical 6-event
  demo calculation through the real `calculation_flow` controller and router,
  then wrote `RenderRepaintBoundary.toImage(pixelRatio: 3)` PNGs at the same
  iPhone 6.7" / Pro Max target as the English set: **1290 x 2796 px**,
  logical 430 x 932 @ DPR 3, safe-area padding top 177 / bottom 102. The final
  capture pass explicitly preloaded bundled product fonts plus `MaterialIcons`
  and `Lucide` package fonts so navigation, bottom-tab, close, and row icons
  render as real glyphs instead of test-harness fallback squares.
- **Toolchain workaround:** this local `flutter_tester` shell hangs/crashes
  during teardown after a `toImage` capture. The harness captured one frame per
  process and a wrapper waited for an atomically renamed valid 1290 x 2796 PNG,
  then terminated only the stale tester process. No app source, tests, ARBs,
  pubspec, platform directories, assets, icons, or product behavior were
  changed.
- **Share behavior documented honestly:** frame 04 shows the shipped localized
  share affordance (`Ergebnis teilen`, `Partager le résultat`,
  `Compartir el resultado`, `Compartilhar resultado`). The native OS share
  sheet cannot be captured from the host Flutter test harness. The emitted
  share **text payload is still English-only** because
  `lib/core/sharing/share_copy_builder.dart` takes no `AppLocalizations` and
  hardcodes the English strings. Manifests document this as shipped behavior and
  record the exact privacy-safe payload; no share feature was changed.
- **Verification:** all 20 generated PNGs were checked with `sips` and are
  **1290 x 2796**; all four `manifest.json` files parse with
  `python3 -m json.tool`; each target locale directory has exactly 5 PNG + 1
  README + 1 manifest. Visual QA contact sheets were inspected after the final
  icon-font capture pass: frames are non-blank, localized chrome is present,
  key text/buttons are readable, and icons render correctly. Localized QA tests
  were run:
  `flutter test --exclude-tags backend --no-pub
  test/widget/l10n/localized_overflow_test.dart
  test/widget/l10n/localized_screens_test.dart` → pass. `git diff --check` →
  clean. `flutter analyze --no-pub` was not required because no app/test code
  changed.
- **Constraints respected:** raw screenshots only; no marketing caption overlays
  or device bezels baked in; no mocked share-card image; no live network/API
  use; no secrets; no deferred scope added.
- **Residual risks / owner follow-ups:** native-speaker review is still required
  for localized captions/copy before console upload; caption overlays are
  owner-composited work; share payload localization remains a future product
  improvement; only the 6.7" portrait screenshot size was generated in this run.
- **Limit/quota:** Claude CLI streams became noisy when image inspection emitted
  inline PNG data, so Codex completed file-level documentation and verification
  from the generated artifacts instead of relying on the final Claude prose.

### 2026-06-03 — Publication Readiness Reconciliation (Impl Run E.1)

- **Model:** claude-opus-4-8. **Session id:**
  `e0bca889-9521-4653-af63-fb56e8f029a1`. No commit, no push by Claude —
  Codex verifies/commits after this run.
- **Predecessor:** continues from clean checkpoint `887bdd8` (Run D.4 follow-up,
  localized screenshot history reorder).
- **Goal:** produce a current-state, evidence-based publication-readiness
  reconciliation after the completed A/C/D work, and reconcile the stale status
  fields in the Run 6 / Run 4 planning docs against the actual repo. Documentation
  only.
- **Method:** read-only audit at `887bdd8`. Verified each P0 blocker
  (`store-submission-readiness.md` §3) and G1-G8/G20/G22
  (`feature-gap-analysis.md`) directly against source/config: `ios/Runner/Info.plist`
  (`CFBundleDisplayName=TrueRise`), `android/.../AndroidManifest.xml`
  (`android:label="TrueRise"`), `android/app/build.gradle.kts` (release still
  debug-signed), `pubspec.yaml` (real description; `flutter_localizations` +
  `generate: true`; no `url_launcher`; `.env` still bundled),
  `lib/l10n/*.arb` (5 locales) + `lib/l10n/l10n.dart` (`appBrandName='TrueRise'`),
  `lib/features/calculation_flow/screens/birth_data_screen.dart` (18+ gate),
  `lib/features/settings/privacy_policy_screen.dart` (in-app only; hosted-URL swap
  still pending), iOS `AppIcon.appiconset` + Android adaptive
  `mipmap-anydpi-v26/ic_launcher.xml`, and `screenshots/store/{en,de,fr,es,pt-BR}/`.
- **Findings (what flipped since 2026-06-02):** resolved in-repo — P0-1/G1
  (display name), P0-6/G6 (18+ age gate), P0-7/G4 (icon), P0-8/G7 (metadata +
  pubspec desc), P0-9/G8 (raw screenshots EN+Tier1), G20 (l10n pipeline), G22
  (Tier 1 translations + localized listing/screenshots). Authored with an owner
  remainder — P0-4/G2 (privacy-policy content; hosting + `url_launcher` pending),
  P0-5/G3 (Apple/Play form guidance; console entry + legal pending). Unchanged /
  owner-gated — P0-2 (signing), P0-3 (bundle-ID), P0-10 (category), P0-11
  (demo-key rotation). Net read: the critical path is now almost entirely
  owner/secret/legal/console; no standalone owner-independent P0 engineering
  surface remains (the two small engineering tasks each need an owner input
  first).
- **Docs changed (4):** added `docs/publication-readiness-current-status.md`
  (authoritative current view + per-blocker reconciliation + next-action
  ordering); added an "Impl Run E.1" reconciliation banner to the top of
  `docs/store-submission-readiness.md` and `docs/feature-gap-analysis.md`
  (historical Run 6 / Run 4 prose preserved below each banner, explicitly marked
  superseded); appended this entry to `docs/claude-build-history.md`.
- **Verification:** `git diff --check` → clean (no whitespace errors);
  `git status --short` → only the 4 docs above (3 in `git status`; the 4th is
  this file); scoped `git status --short -- lib ios android test
  integration_test pubspec.yaml assets l10n.yaml lib/l10n README.md` → empty.
  Reconciliation marker "Impl Run E.1" confirmed present in all three readiness
  docs. **No Flutter tests were run — not required for a documentation-only
  change** (nothing in `lib/`, `test/`, ARBs, or config changed); the most recent
  green-test evidence remains Run D.4 localized QA plus the Phase 8 177+1 baseline
  (`docs/qa-phase8-report.md`, not re-run).
- **Constraints respected:** documentation only; no app code, tests, ARBs,
  generated l10n, assets, screenshots, `ios/`, `android/`, `pubspec.yaml`,
  README, or config modified; no network research; no features implemented; no
  secrets; no deferred V1.5/P1/P2 scope pulled forward; no commit/push by Claude.
- **Residual risks / owner follow-ups:** app-icon **visual** not re-rendered
  (DONE inferred from repo assets + commit `72d6003` + Run A.3); screenshots are
  raw 6.7" captures needing framing/captions/native review + more device sizes;
  P0-4/P0-5 docs are preparation guidance, not a submission or legal advice;
  share text payload remains English-only (Run D.4 caveat); the build is still
  not submittable until P0-2/3/4/5/10/11 (owner/secret/legal/console) close.
- **Limit/quota:** none hit; read-only audit run.

### 2026-06-03 — Rate-Limit (HTTP 429) Error UX (Impl Run F.1)

- **Model:** claude-opus-4-8. **Session id:** not captured in this run. Claude
  committed and pushed after verification (Codex monitors/verifies).
- **Predecessor:** continues from clean checkpoint `02e8bbc` (revert of the
  earlier rate-limit error screen experiment).
- **Goal:** give `RateLimitedFailure` (HTTP 429 from the shared proxy/provider) a
  dedicated, localized error screen instead of collapsing onto the generic server
  screen. No client-side quota counter, no device fingerprint, no
  RevenueCat/IAP/Supabase — the limit stays server/proxy-side and the app only
  reacts to 429.
- **Artifacts changed (code):** `lib/features/error_flow/error_routing.dart`
  (new `ErrorScreenKind.rateLimited`; `RateLimitedFailure` maps to it),
  `lib/app/route_names.dart` (`errorRateLimited` name + `/error/rate-limited`
  path), `lib/app/router.dart` (route registration),
  `lib/features/error_flow/error_screen.dart` (copy case; reuses the existing
  "Try again" retry CTA and draft-preserving retry path),
  `lib/theme/icons.dart` (`errorRateLimited = LucideIcons.hourglass`).
- **Artifacts changed (l10n):** added `errorRateLimitedTitle` /
  `errorRateLimitedBody` to all five ARBs (en/de/fr/es/pt); regenerated
  `lib/l10n/app_localizations*.dart` via `flutter gen-l10n` (no hand-edits to
  generated files).
- **Artifacts changed (tests/docs):**
  `test/widget/features/error_flow/error_routing_test.dart` (mapping + navigation
  now expect `/error/rate-limited`); `docs/implementation-plan.md` §9.6 429 row
  updated from "Generic error" to the dedicated screen; this entry.
- **Method:** TDD — updated the routing test to expect the new route, watched it
  fail (`/error/server` ≠ `/error/rate-limited`), then implemented to green.
- **Verification:** `flutter gen-l10n` → ok; `dart format` (6 changed files) →
  0 changed; `flutter analyze` → No issues found; focused
  `error_routing_test.dart` + `rectification_api_test.dart` → pass; full
  `flutter test` → 263 passed; `git diff --check` → clean; `git status` captured
  before/after commit.
- **Constraints respected:** no client usage counter; no per-device identifier;
  no subscriptions/paywall/IAP/RevenueCat/Supabase/backend; demo mode untouched
  and still offline; no API host changes beyond existing dart-define config; no
  broad refactor; no secrets.
- **Residual risks / owner follow-ups:** copy is engineer-drafted — native review
  of the de/fr/es/pt rate-limit strings is still recommended before store upload;
  429 `Retry-After` is not parsed, so the same screen is shown for a short rate
  limit and a daily quota (by design — no client-side counter).
- **Limit/quota:** none hit.

### 2026-06-03 — Consumer-Facing API-Key / Plumbing Removal (Impl Run G.1)

- **Model:** claude-opus-4-8. **Session id:** not captured in this run. No commit,
  no push by Claude — working tree left dirty for Codex to verify/commit.
- **Predecessor:** continues from clean checkpoint `87c5ccf` (Run F.1, rate-limit
  429 error screen).
- **Goal (P0, release-facing):** ordinary consumer users must not encounter
  API-key / BYOK / provider / proxy / proxied / shared-service / astrology-api.io /
  Pro-Developer / `sk-…` plumbing anywhere in normal app UI, the localization
  source ARBs, or store screenshot metadata. Preserve the demo + live-calculation
  concepts and the legally-required "third-party calculation provider" privacy
  disclosure; leave internal/technical docs (e.g. `docs/api-integration.md`) and
  the developer-facing README `.env`/security-boundary content intact in substance.
- **Artifacts changed — app code (5):** deleted
  `lib/features/settings/api_key_sheet.dart` (the per-user key-entry sheet);
  `lib/features/settings/settings_screen.dart` (removed the API-key Settings row
  and, after analyze flagged them, the now-dead `value`/`valueColor` params on the
  private `_ChevronRow`); `lib/features/settings/privacy_policy_screen.dart`
  (removed the "Optional API key" section + its stale dartdoc);
  `lib/features/error_flow/error_screen.dart` (the `unauthorized` and
  `missingApiKey` screens now use `errorTryAgain` and the draft-preserving retry
  path instead of `errorOpenSettings` + `controller.reset()` + routing into
  Settings); `lib/features/error_flow/error_routing.dart` (comment-only — rewrote
  the `missingApiKey` / `rateLimited` mapping comments to drop "deep-link into
  Settings" and "shared proxy/provider … own-key" language).
- **Artifacts changed — l10n (5 source + 6 generated):** removed the API-key string
  sets from all five ARBs (`apiKey*` sheet keys, `settingsApiKey*` /
  `settingsSectionApiKey` row keys, `privacyApiKeyTitle/Body`, and the now-unused
  `errorOpenSettings`) and neutralized the visible values of retained keys
  (`errorMissingApiKeyTitle/Body`, `errorUnauthorizedTitle/Body`, `privacyDemoBody`,
  `privacyDeleteBody`, and other error bodies) so no key/credentials/provider
  wording remains; internal key names required by the `ErrorScreenKind` enum
  (`errorMissingApiKey*`) stay, with neutral copy. Generic `fieldValueSemantic`
  was deliberately kept (still used by the date/time picker fields).
  `lib/l10n/app_localizations*.dart` regenerated via `flutter gen-l10n` — no
  hand-edits to generated files.
- **Artifacts changed — store metadata (10):**
  `screenshots/store/{en,de,fr,es,pt-BR}/manifest.json` and matching `README.md`
  — removed "optional API key" / "no key" wording from the frame-03 (Settings) and
  frame-05 (Privacy) descriptions and capture notes, and added an explicit
  `regenerationRequired` / stale-frame note: frames `03-privacy-demo-settings.png`
  and `05-privacy-policy.png` were captured before the API-key removal and must be
  re-shot before submission (the textual `shows`/`shippedWidgets` columns already
  describe the current API-key-free UI; no capture command is checked in).
- **Artifacts changed — docs (3):** `docs/privacy-policy.md` (removed the "Optional
  provider API key" section and all "no key" / "stored API key" / "backend proxy"
  phrasing; kept every "third-party calculation provider" legal disclosure);
  `docs/store-submission-readiness.md` (added one reconciliation header bullet under
  the Run E.1 banner marking the body's API-key-sheet references as stale historical
  evidence — the [VERIFIED] historical prose is preserved, not rewritten); root
  `README.md` (3 surgical edits to the live-mode key-sourcing list, the error-screen
  description, and the security-boundary sentence — `.env`/`sk.…`/security-boundary
  technical content preserved per CLAUDE.md, as the developer README is out of the
  consumer-facing audit scope).
- **Artifacts changed — tests (2):**
  `test/widget/features/settings/settings_screen_test.dart` and
  `test/widget/l10n/localized_screens_test.dart` — removed the API-key-row
  expectations that referenced UI that no longer ships.
- **Method:** scoped cleanup driven by a repeated grep audit (the terms in the Goal)
  over `lib/features`, the source ARBs, `screenshots/store`, `docs/privacy-policy.md`,
  and `docs/store-submission-readiness.md`; every surviving hit re-justified rather
  than blanket-deleted. Distinguished removed-feature references (deleted) from
  legally-required disclosures and internal/historical technical content (kept +
  annotated). `.env` secret values were never inspected or printed.
- **Verification:** `dart format` on the 6 touched Dart files → 0 changed;
  `flutter analyze --no-pub` → No issues found (after removing the `_ChevronRow`
  `unused_element_parameter` warnings that surfaced once the API-key row's only
  caller was gone); focused tests (settings_screen, error_routing, error_scaffold,
  localized_screens, localized_overflow) → 29 passed; full `flutter test` →
  261 passed. Final grep audit: `lib/features` and the ARBs retain only the internal
  `missingApiKey` enum/route names with neutral visible copy; `docs/privacy-policy.md`
  → no matches; the only `screenshots/store` and `store-submission-readiness.md` hits
  are the intentional stale-frame / reconciliation notes plus one real HTTPS endpoint
  in an ATS-compliance evidence block.
- **Constraints respected:** changes scoped to the consumer-facing surface; no
  unrelated refactor; demo mode untouched and still offline; live-calculation path
  and `proApiKeyProvider` secure-storage read path left functional (only the
  user-facing key UI removed); `docs/api-integration.md` and other technical docs
  not rewritten; no secrets in source/logs/Drift/SharedPreferences/docs; no commit
  or push.
- **Residual risks / owner follow-ups:** screenshot frames `03` and `05` still need
  re-capture before store upload (text metadata updated, PNGs are stale); the
  neutralized de/fr/es/pt error/privacy strings remain engineer-drafted and want a
  native-speaker pass; `store-submission-readiness.md` §2.1/§8.3/§12.2 still contain
  superseded API-key-sheet prose (flagged by the new reconciliation bullet, not
  excised, to preserve the historical-evidence record).
- **Limit/quota:** none hit.

### 2026-06-03 — Compliant In-App Review Prompt (Impl Run S2)

- **Model:** claude-opus-4-8. **Session id:** not captured in this run. Claude
  committed locally after verification; no push (per task).
- **Predecessor:** continues from `81ab747` (S1 privacy-safe result image
  sharing); worktree clean at start.
- **Scope note / deferral reconciliation:** `docs/mvp-scope.md` (line 154) and
  `docs/implementation-plan.md` (§1, line 45) list an in-app review prompt as
  *post-MVP* ("add after 30-day stability period"). It is implemented now under
  an explicit, detailed task instruction and is consistent with the post-MVP
  growth phase that S1 (sharing — itself a deferred growth lever) opened. It is
  not in CLAUDE.md's hard no-go list (payments/IAP/paywalls/accounts/sync/etc.).
  No scope docs were rewritten.
- **Goal:** invite an *honest* rating/review at a genuine positive moment, fully
  App Store / Play compliant — never asks for 5 stars, never incentivizes, never
  gates functionality, never branches on the rating value (the OS owns the rating
  UI and returns nothing).
- **Artifacts changed (code):** new `lib/core/reviews/review_service.dart`
  (`ReviewService` abstraction + `InAppReviewService` over the `in_app_review`
  plugin, `MissingPluginException`/`PlatformException`-guarded, + provider); new
  `lib/data/prefs/review_prompt_store.dart` (single `review.last_prompt_at_ms`
  throttle key; own namespace so a Settings data-wipe does not reset it); new
  `lib/features/reviews/review_prompt_controller.dart` (pure `ReviewPolicy`
  eligibility with injected clock + 120-day cooldown, UI-free
  `ReviewPromptController`, providers); new
  `lib/features/reviews/review_invitation.dart` (neutral, non-sentiment-gating
  pre-prompt dialog + `maybeInviteReview` orchestration); wired into
  `lib/features/calculation_flow/screens/result_screen.dart` after a *successful
  native* text/image share only (never the clipboard fallback). `pubspec.yaml` +
  `pubspec.lock` (add `in_app_review: ^2.0.12`, pulls `url_launcher`).
- **Artifacts changed (l10n):** added `reviewPromptTitle` / `reviewPromptBody` /
  `reviewPromptConfirm` / `reviewPromptDismiss` to all five ARBs
  (en/de/es/fr/pt); regenerated `lib/l10n/app_localizations*.dart` via
  `flutter gen-l10n` (no hand-edits to generated files).
- **Artifacts changed (tests):** `test/helpers/fake_review_service.dart`;
  `test/unit/reviews/review_policy_test.dart`;
  `test/data/prefs/review_prompt_store_test.dart`;
  `test/unit/reviews/review_prompt_controller_test.dart`;
  `test/unit/reviews/review_strings_compliance_test.dart` (scans all ARBs for
  5-star / rating-bait wording);
  `test/widget/features/calculation_flow/result_review_prompt_test.dart`
  (invite shown + native flow reached when eligible; not shown after the
  clipboard fallback; not shown within cooldown; decline consumes cooldown;
  image share also invites).
- **Method:** abstraction-first with focused unit + widget tests; verified the
  real `in_app_review` 2.0.12 API (`isAvailable`/`requestReview`) by inspecting
  the resolved package.
- **Verification:** `flutter gen-l10n` → ok; `dart format` → clean;
  `flutter analyze lib test` → No issues found; focused review tests + the
  existing `result_share_test.dart` → 32 passed (no regression); full
  `flutter test` → 291 passed. Integration test (`integration_test/`) not run —
  needs a device/simulator.
- **Constraints respected:** narrow scope (no referrals/invites/IG integration/
  analytics/accounts/paywalls/push/growth docs); existing architecture and test
  style preserved; demo mode still makes no app network calls (the review flow is
  an OS capability via platform channel, like S1's share sheet); no secrets.
- **Residual risks / owner follow-ups:** review copy (de/es/fr/pt) is
  engineer-drafted and wants a native-speaker pass; the native flow may legitimately
  show nothing (OS quota) — there is no store-listing fallback because the app has
  no published App Store ID yet; throttle is per-install (no cross-device/backend
  state, by design).
- **Limit/quota:** none hit.

### 2026-06-03 — Privacy-safe Share Discoverability (Impl Run S3 / G10)

- **Model:** claude-opus-4-8. **Session id:** not captured in this run. Claude
  committed locally after verification; no push (per task).
- **Predecessor:** continues from `f297f62` (S2 compliant in-app review prompt),
  which itself sits on `81ab747` (S1 privacy-safe result image sharing);
  worktree clean at start (`main` two local commits ahead of origin, not pushed).
- **Scope:** the low-risk subset of G10 (`docs/feature-gap-analysis.md` §6.2
  rank 2): make the *existing* PII-free share loop easier to reach. No new share
  payload, no share-card redesign, no analytics/crash SDK, no accounts/referrals/
  contacts/auto-posting/IG integration, no paywalls/IAP, no push.
- **Goal:** add share entry points from (a) the result screen CTA, (b) history
  rows, and (c) a one-time post-demo affordance — every one reusing the exact
  same `ShareCopyBuilder` / `ShareService` PII-free text payload (no birth
  city/date, life events, labels, coordinates, API ids, or user-entered text).
- **Target 1 — result CTA (improve "if needed"):** the result screen already
  had two clearly-labelled share GhostButtons directly under the primary CTA, so
  no structural change was warranted (no information removed, one-screen layout
  preserved). The only change is a recognizable share glyph (`AppIcons.share =
  LucideIcons.share2`) added to both the "Share result" and "Share image"
  buttons to raise visual discoverability of the existing affordances. S1/S2
  behavior (text + image share, clipboard fallback, and the S2 review invite on
  a *successful native* share only) is untouched.
- **Target 2 — share from history:** `HistoryCard` gains an optional `onShare`
  callback; when provided it renders a 44pt share `IconButton` in the eyebrow
  (the icon intercepts its own tap, so the card's open-result `onTap` does not
  also fire). `_PopulatedHistory` wires it to `ShareService.share(
  ShareCopyBuilder.build(item))` with the same "Copied to clipboard" SnackBar
  fallback. The affordance renders only when `onShare` is supplied, so existing
  `HistoryCard` widget tests and the hero goldens are unaffected. Reuses the
  existing `resultShare` ("Share result") string for the tooltip — no new
  translated string for this entry point.
- **Target 3 — one-time post-demo affordance:** a dismissible `_DemoSharePrompt`
  renders on a demo result the first time the user reaches one, gated by a new
  `SharePromptStore` (`share.demo_prompt_seen` boolean in its own key namespace,
  mirroring `ReviewPromptStore` so a Settings "Delete all data" wipe of the
  `settings.*` keys does not re-open it). It marks itself seen on display, so it
  is shown at most once, ever — non-annoying by construction. Its "Share sample"
  button reuses the same PII-free text share + clipboard fallback.
- **Review-prompt boundary (compliance):** neither the history share nor the
  post-demo affordance chains the S2 `maybeInviteReview` flow — a quiet utility
  share and a one-time nudge are not the celebratory positive moment that flow is
  reserved for, and stacking a rating dialog on top would read as a dark pattern.
  Both honour the fallback contract: a clipboard fallback surfaces a SnackBar and
  is never treated as a success moment. The S2 review invite remains wired to the
  result screen's two main share buttons on native success only, exactly as
  shipped. Each new entry point has a focused test asserting no review dialog and
  `requestReviewCount == 0`.
- **Artifacts changed — code (5):** `lib/theme/icons.dart` (`AppIcons.share`);
  `lib/widgets/cards/history_card.dart` (optional `onShare` + eyebrow share
  button); `lib/features/home/home_history_screen.dart` (`_shareRow` wiring,
  no review prompt); `lib/providers/core_providers.dart`
  (`sharePromptStoreProvider`); `lib/features/calculation_flow/screens/
  result_screen.dart` (share glyph on both CTAs + `_DemoSharePrompt` +
  `resultDemoSharePrompt*Key`s).
- **Artifacts created — code (1):** `lib/data/prefs/share_prompt_store.dart`.
- **Artifacts changed — l10n (5 source + 6 generated):** added
  `resultDemoShareLabel` / `resultDemoShareTitle` / `resultDemoShareButton` to all
  five ARBs (en/de/fr/es/pt); regenerated `lib/l10n/app_localizations*.dart` via
  `flutter gen-l10n` (87 insertions, 0 deletions across l10n — purely additive; no
  hand-edits to generated files).
- **Artifacts created — tests (3):** `test/data/prefs/share_prompt_store_test.dart`
  (4 unit tests); `test/widget/features/home/home_history_share_test.dart` (4
  widget tests: affordance present per row, PII-free share, clipboard fallback,
  no review invite); `test/widget/features/calculation_flow/
  result_demo_share_prompt_test.dart` (6 widget tests: shown once + marks seen,
  hidden when seen, absent on a real result, PII-free share, fallback SnackBar, no
  review invite).
- **Artifacts changed — tests (1):**
  `test/widget/features/calculation_flow/result_share_test.dart` (one added test
  asserting the share glyph on both result CTAs).
- **Method:** TDD throughout — each store/widget got a failing test first
  (verified RED), then minimal code to green. The "hidden once seen" demo-prompt
  test caught a real defect (the test key was on the always-present widget rather
  than the conditionally-rendered content) before it could mask the one-time
  guarantee; the key was moved onto the rendered container.
- **Verification:** `flutter gen-l10n` → ok; `dart format` on the 10 touched Dart
  files → 1 reformatted (no unrelated committed files mutated); `flutter analyze
  lib test` → No issues found; focused share/review/history/prefs cluster → 72
  passed; full `flutter test` → **306 passed** (was 291 after S2; +15 new);
  `git diff --check` → clean. Integration test (`integration_test/`) not run —
  needs a device/simulator.
- **Constraints respected:** all S1/S2 behavior preserved; PII-free payload
  reused unchanged at every new entry point (no birth city/date, events, label,
  coordinates, API ids, or user text); no review prompt on history/demo shares;
  no automatic sharing, contact access, or dark patterns; demo mode still makes
  no app network calls (share is an OS capability via platform channel /
  clipboard, like S1); no secrets; no deferred/out-of-scope surface added; no
  store-doc rewrites.
- **Residual risks / owner follow-ups:** the de/fr/es/pt copy for the three new
  demo-share strings is engineer-drafted and wants a native-speaker pass before
  store upload (consistent with the S1/S2/Run D translation caveats); the shipped
  share *text* payload remains English-only (`share_copy_builder.dart`, unchanged
  — a pre-existing localized-listing caveat, not introduced here); screenshot sets
  were not re-captured (the new affordances are reachable from already-screenshot
  surfaces).
- **Limit/quota:** none hit.

### 2026-06-04 — Localized Share Copy + Store Link (Impl Run S3)

- **Model:** claude-opus-4-8. **Session id:** `18f10063-ba7b-4928-9080-39e656050038`.
- **Naming note:** this is the user's plan item **S3 — Localized Share Copy +
  Store Link**. It is *not* the earlier "Impl Run S3 / G10" share-discoverability
  entry above (`9cddb8b`), which was mislabeled S3 in build history; the names
  collide but the work is different.
- **Predecessor:** continues from `9cddb8b` (share discoverability); worktree
  clean at start (`main` three local commits ahead of origin, not pushed).
- **Goal:** close the "shipped share text is English-only" caveat flagged by the
  previous entry. Localize the privacy-safe share text through the existing
  ARB/`AppLocalizations` pipeline and append a public landing/store link so a
  recipient can find the app — without leaking any private data.
- **What changed — share copy is now localized + linked:**
  `ShareCopyBuilder.build` gained a second parameter (`AppLocalizations l10n`)
  and now composes the shared text from three new ARB keys plus the two existing
  share keys it reuses (`resultRisingSign`, `shareCardConfidence`). The brand
  token (`appBrandName`) and the URL are passed in as placeholders so translators
  cannot alter them. Output shape (EN example):
  `My TrueRise rectification result:` / `7:14 AM · Gemini Rising · 78% confidence`
  / (blank) / `Calculated with TrueRise — birth-time rectification` /
  `Find your birth time: https://truerise.app`. The 12-hour `_formatTime` helper
  is deliberately unchanged (preserves S1 behavior and the existing time-format
  unit tests; locale-aware time formatting stays the separate G21 concern).
- **Store-link plumbing (placeholder, documented):** new `lib/core/app_links.dart`
  holds `AppLinks.landing` / `AppLinks.shareUrl` — a **non-secret** public URL
  (`https://truerise.app`), safe to ship in source/logs/shared text (contrast with
  API keys / proxy URLs / the demo `.env`, which stay secret). It is a single
  indirection point so shared copy never embeds a guessed or platform-wrong store
  URL. Replacement path is documented in the file: point `landing` at the live
  marketing page once minted, or add `appStoreUrl`/`playStoreUrl` constants and
  update `shareUrl`. The value has no tracking params and no PII.
- **All four share entry points covered:** the result-screen text share, the
  result-screen image-share caption, the one-time post-demo affordance, and the
  history-row share all pass `context.l10n` into the builder, so every surface
  shares the same localized, linked, PII-free payload. S1/S2 behavior preserved:
  image caption == text caption; the S2 review invite still fires only on a
  *successful native* result-screen share, never on history/demo share or the
  clipboard fallback.
- **Privacy copy:** unchanged — and verified non-contradictory. The added link is
  a static public URL with no personal data or tracking parameters, so it does
  not change what a share transmits about the user; the existing privacy/Settings
  copy (local-only storage, demo offline, what a *live calc* sends) still holds.
  No birth date, city, coordinates, life events, request label, API ids, raw
  response, or user-entered text is added to the share in any locale.
- **Artifacts created — code (1):** `lib/core/app_links.dart`.
- **Artifacts changed — code (3):** `lib/core/sharing/share_copy_builder.dart`
  (localized + linked, new `l10n` param); `lib/features/calculation_flow/screens/
  result_screen.dart` (3 call sites pass `l10n`); `lib/features/home/
  home_history_screen.dart` (1 call site passes `l10n`).
- **Artifacts changed — l10n (5 source):** added `shareCopyHeadline` /
  `shareCopyTagline` / `shareCopyGetApp` to all five ARBs (en template with
  `@`-metadata + de/fr/es/pt values, following `docs/l10n-strategy.md` §6–§8
  terminology and per-locale register: DE informal "du", FR "vous", ES "tú", PT
  "você"). **Generated `app_localizations*.dart` were intentionally NOT
  hand-edited** — they must be regenerated with `flutter gen-l10n` (the first
  verification step; `generate: true` also regenerates them at build time).
- **Artifacts changed — tests (2):**
  `test/unit/sharing/share_copy_builder_test.dart` (rewritten for the new
  signature; added store-link inclusion, per-locale localization, and a
  no-PII-across-all-five-locales sweep + a localized empty-candidate fallback
  test); `test/widget/features/calculation_flow/result_share_test.dart` (one added
  test asserting the end-to-end shared text contains `AppLinks.shareUrl`).
- **Verification — RUN AND PASSED (Codex verifier session):** the original
  implementation session could not run Bash — every invocation failed with
  `EPERM: operation not permitted, mkdir '~/.claude/session-env/<id>'` before the
  command ran, so verification was deferred to a follow-up session. That
  verification has now been completed by the Codex verifier and all checks pass:
  `flutter gen-l10n` ran successfully (regenerated the `app_localizations*.dart`
  sources from the new ARB keys); `dart format` on the touched Dart files
  (`lib/core/app_links.dart`, `lib/core/sharing/share_copy_builder.dart`,
  `lib/features/calculation_flow/screens/result_screen.dart`,
  `lib/features/home/home_history_screen.dart`,
  `test/unit/sharing/share_copy_builder_test.dart`,
  `test/widget/features/calculation_flow/result_share_test.dart`) reports clean
  after a Claude lint fix; `flutter analyze lib test` is clean; the focused
  share/review tests passed
  (`test/unit/sharing/share_copy_builder_test.dart`,
  `test/widget/features/calculation_flow/result_share_test.dart`,
  `test/widget/features/home/home_history_share_test.dart`,
  `test/widget/features/calculation_flow/result_demo_share_prompt_test.dart`,
  `test/widget/features/calculation_flow/result_review_prompt_test.dart`); the
  full `flutter test` suite passed with **314 tests**; and `git diff --check` is
  clean. Flutter is installed (3.44.0/Dart 3.12.0).
- **Constraints respected:** scoped change (no architecture rewrite); demo mode
  still makes no app network calls (the link is inert text, not a request); no
  accounts/referrals/rewards/contacts/IG integration/analytics/push/paywalls/IAP/
  backend; no deferred surface added; no secrets; no `*.g.dart`/generated-l10n
  hand-edits.
- **Residual risks / owner follow-ups:** (1) `AppLinks.landing` =
  `https://truerise.app` is a **placeholder** — confirm the domain is owned and
  resolves, or replace with the live landing/store URL before release. (2) the
  de/fr/es/pt share strings are engineer-drafted and want a native-speaker pass
  (consistent with the standing Run D translation caveat). (3) shared time still
  renders 12-hour AM/PM regardless of locale/user time-format setting — a
  pre-existing G21 formatting concern, intentionally out of this scope. (4) this
  run has been **verified** by the Codex verifier (see Verification above):
  gen-l10n + analyze + focused tests + full suite (314 tests) + `git diff --check`
  all pass. (5) Claude **committed the stage locally** (commit `feat: localize
  share copy with store link`); **not pushed** (still local-only, per task
  workflow).
- **Limit/quota:** none hit.

### 2026-06-04 — Invite a Friend (Lite) (Impl Run S4)

- **Model:** claude-opus-4-8. **Session id:**
  `62031429-ceac-42fb-bc41-c6e90f93d092` (implementation run).
- **Naming note:** this is the user's plan item **S4 — Invite Friend Lite**. It
  is explicitly *not* a referral/rewards program — only a soft, opt-in
  invitation.
- **Predecessor:** continues from `6db0b61` (S3 localized share copy); worktree
  clean at start (`main` ahead of origin, not pushed).
- **Goal:** add one opt-in "Invite a friend" affordance that opens the existing
  native share sheet with a localized, PII-free, branded invite carrying the
  public landing/store link — without accounts, referral codes, rewards,
  contacts access, tracking, or any new dependency.
- **What changed:**
  - New `lib/core/sharing/invite_copy_builder.dart` — `InviteCopyBuilder.build`
    takes only `AppLocalizations` (no `SavedCalculation` parameter, so there is
    structurally no path for birth data, events, labels, coordinates, or API ids
    to reach an invite). Composes three new ARB keys; brand (`appBrandName`) and
    `AppLinks.shareUrl` are passed as placeholders so translators cannot alter
    them. EN shape: `Try TrueRise — find your real birth time` / `It estimates a
    probable birth time from a few life events you remember.` / `Get the app:
    https://truerise.app`.
  - `lib/features/settings/settings_screen.dart` — added an opt-in "Invite a
    friend" chevron row (`settingsInviteButtonKey`) at the top of the existing
    About card, above Privacy Policy (separated by a hairline divider). Its
    `_invite` handler reads `shareServiceProvider`, shares `InviteCopyBuilder`
    text, and on the clipboard fallback surfaces the existing "Copied to
    clipboard" SnackBar. It **deliberately does not** chain `maybeInviteReview`
    — an invite is not the celebratory moment the review ask is reserved for.
    `_ChevronRow` gained `super.key` to host the test key.
  - l10n: 4 new keys per locale (`settingsInviteFriend`, `inviteCopyHeadline`,
    `inviteCopyBody`, `inviteCopyGetApp`) across EN/DE/ES/FR/PT; regenerated
    `app_localizations*.dart` via `flutter gen-l10n` (not hand-edited).
- **Tests added (TDD, red→green):**
  - `test/unit/sharing/invite_copy_builder_test.dart` (10 tests) — brand + link
    present, bare URL with no tracking params, localized per locale, expected
    per-locale prose, PII-free, no referral/reward/rating-bait wording.
  - `test/unit/sharing/invite_strings_compliance_test.dart` (5 tests) — scans
    the source `.arb` files so a future copy edit in any locale cannot turn the
    invite into an incentivised referral or "rate us" nudge: every locale defines
    the keys, no referral/reward/incentive language, no rating-bait, no tracking
    params in the link line, brand/link stay placeholders.
  - `test/widget/features/settings/settings_screen_test.dart` (+4 tests) — row
    renders; tapping shares a localized, branded, linked, PII-free invite; the
    invite never triggers the review prompt even when fully eligible
    (FakeReviewService available + no prior prompt); clipboard SnackBar on the
    fallback path.
- **Verification — RUN AND PASSED:** `flutter gen-l10n` succeeded; `dart format`
  on the five touched Dart files reports clean (0 changed); `flutter analyze lib
  test` → **No issues found!**; focused tests pass (the two new unit suites + the
  extended settings widget suite, 10/10); full `flutter test` → **333 tests, all
  passed** (was 314); `git diff --check` clean. Flutter 3.44.0 / Dart 3.12.0.
- **Constraints respected:** scoped change (no architecture rewrite); demo mode
  still makes no network calls (the invite is inert text via the share sheet, not
  a request); no accounts / referral / rewards / contacts / Instagram
  integration / analytics / push / paywall / IAP / backend; no new dependency
  (reuses `ShareService`/`FakeShareService`); no review-prompt chaining from the
  invite; no secrets; no manual edits to generated sources.
- **Residual risks / owner follow-ups:** (1) `AppLinks.shareUrl` is still the
  `https://truerise.app` **placeholder** — same standing owner action as S3
  (confirm/own the domain or swap for the live store link before release). (2)
  the DE/ES/FR/PT invite strings are engineer-drafted and want a native-speaker
  pass (standing Run D translation caveat). (3) committed locally by the S4
  finalization run; not pushed.
- **Limit/quota:** none hit.

### 2026-06-04 — Share/Invite Link Hardening (Impl Run S4.1)

- **Model:** claude-opus-4-8. **Session ids:** implementation
  `0c13b6b6-05c1-4fc5-852f-3c93d1ce1eee`; metadata cleanup
  `341c77b5-83f5-4a9c-ab83-d76379620320`.
- **Naming note:** follow-on hardening of **S4**'s share/invite link
  (`AppLinks.shareUrl`); labelled **S4.1**. **S5** (direct Instagram Stories)
  remains postponed pending a Meta/Facebook App ID + real-device QA and was
  **not** touched.
- **Predecessor:** continues from `3ddac87` (S4 Invite Friend Lite); worktree
  clean at start (`main` ahead of origin, not pushed).
- **Problem:** the single share/invite link `AppLinks.shareUrl =
  https://truerise.app` is a placeholder whose host **does not currently
  resolve** (verified by Codex via `curl`), so shipping as-is would hand
  recipients a broken link — and there is no owner-final landing/store URL yet.
- **Goal:** a safe, scoped hardening that (a) makes the link owner-configurable
  at build time without guessing a final URL, (b) preserves all current
  share/invite behaviour from one source of truth, (c) makes the privacy
  invariant testable, and (d) records an explicit pre-publication release gate.
- **What changed — `lib/core/app_links.dart`:**
  - `shareUrl` is now `String.fromEnvironment('TRUERISE_SHARE_URL',
    defaultValue: defaultShareUrl)`, following the same public/non-secret
    `String.fromEnvironment` build-config pattern used for the proxy/provider
    URLs in `lib/providers/core_providers.dart`. The owner can point every
    share/invite surface at the real URL with
    `--dart-define=TRUERISE_SHARE_URL=https://…` — **no code change**.
    `TRUERISE_SHARE_URL` is a **public** value (it ends up in shared text), not
    a secret.
  - New `defaultShareUrl` const holds the placeholder `https://truerise.app`;
    `landing` now aliases `shareUrl` so there is exactly **one** source of
    truth. Default value is unchanged, so all S1–S4 share/invite behaviour is
    preserved bit-for-bit when no define is supplied.
  - New pure validator `AppLinks.isPrivacySafeShareUrl(url)` — true only for a
    bare **HTTPS** URL with a host and **no** userinfo / query string /
    fragment (disallowing the query structurally rules out `utm_*` / `ref=` /
    `fbclid`-style tracking params). This is the testable expression of the
    invariant: both the default and any owner-supplied define can be checked
    without mutating the compile-time environment at runtime (Dart
    const-from-environment cannot be varied inside one test process).
  - The class doc now documents the build-time define and an explicit
    **⚠️ owner-confirm-before-release** gate.
- **Unchanged:** `ShareCopyBuilder` and `InviteCopyBuilder` still read the one
  `AppLinks.shareUrl` and still embed a bare HTTPS URL with no tracking params —
  no signature or behaviour change.
- **Tests (TDD, red→green):**
  - New `test/unit/core/app_links_test.dart` (11 tests). Wrote the validator
    tests first; verified **RED** (`Member not found:
    'AppLinks.isPrivacySafeShareUrl'`), then minimal GREEN. Covers the default
    invariant (HTTPS, no query/tracking, no fragment, passes the validator,
    `landing == shareUrl`) and the owner-configurable path through the
    validator (accepts representative custom HTTPS URLs incl. an App Store URL;
    rejects `http`/`ftp`, query strings, fragments, userinfo, empty, and
    scheme-less input).
  - `test/unit/sharing/share_copy_builder_test.dart` +
    `test/unit/sharing/invite_copy_builder_test.dart`: one assertion added to
    each existing "store link" group — the embedded source-of-truth URL must
    pass `AppLinks.isPrivacySafeShareUrl`.
- **Docs:** added owner item **#9** to
  `docs/publication-readiness-current-status.md` §5a (resolvable share/invite
  landing URL is a pre-publication owner gate; the in-source default is not
  proof of ownership/resolution; the `--dart-define` lever is documented); this
  build-history entry.
- **Verification — RUN AND PASSED:** `dart format` on the 4 touched Dart files
  → 1 reformatted (`app_links_test.dart`), no unrelated files mutated; `flutter
  analyze lib test` → **No issues found!** (after switching two doc-comment
  `[Builder]` references to backticks to clear `comment_references` — no import
  cycle introduced); focused share/invite/app_links cluster (the new unit suite
  + both copy-builder suites + invite-strings-compliance +
  `result_share_test.dart`) → **58 passed**; full `flutter test` → **344
  passed** (was 333 after S4; +11 new); `git diff --check` → clean. Flutter
  3.44.0 / Dart 3.12.0. Integration test not run (needs a device/simulator).
- **Constraints respected:** no app-runtime network calls (the link is inert
  text; the validator is pure, offline); no analytics/tracking params added; no
  platform-specific store guessing; **S5 Instagram integration untouched**; no
  new dependency; no `*.g.dart`/generated-l10n hand-edits; demo mode still makes
  no network calls; no secrets (`TRUERISE_SHARE_URL` is public, not a secret).
- **Residual risks / owner follow-ups:** (1) **OWNER, pre-publication:**
  `TRUERISE_SHARE_URL` default `https://truerise.app` is still a placeholder
  whose host does not resolve — the owner must register/own that domain and
  confirm DNS resolution, or build with `--dart-define=TRUERISE_SHARE_URL=` set
  to the real resolvable landing/store URL, before publishing. The default in
  source is not proof of ownership/resolution. (2) Codex verification required
  before local commit; **push remains not performed** unless explicitly
  requested.
- **Limit/quota:** none hit.

### 2026-06-04 — Deterministic English locale fallback

- **Artifacts created:**
  - `lib/l10n/locale_resolution.dart` — pure `resolveAppLocale` helper (language-code matching, English fallback)
  - `test/unit/l10n/locale_resolution_test.dart` — 7 focused unit tests
- **Artifact changed:** `lib/app/app.dart` — added `localeListResolutionCallback: resolveAppLocale` to `MaterialApp.router`
- **Work completed:** Flutter's default locale resolution picks the first supported locale (de) when no device language matches, causing German to appear on Japanese-only or other unsupported devices. A `localeListResolutionCallback` now iterates device-preferred locales in order, matches by language code (region tags like de-AT still resolve to de), and falls back to English when none match. The callback is wired into `MaterialApp.router`; no generated l10n files, routing, API, persistence, or product scope were touched.
- **Verification — RUN AND PASSED:** `dart format` on 2 changed files → 0 reformatted; `flutter analyze` → **No issues found!**; focused locale suite → **7 passed**; full `flutter test` → **351 passed** (was 344; +7 new). Flutter 3.44.0 / Dart 3.12.0. Integration test not run (needs a device/simulator).
- **Constraints respected:** no generated files edited; demo mode unchanged; no secrets; no MVP-deferred features touched; change is fully offline.
- **Residual risks / open questions:** none — callback delegates to the existing supported-locales list, so adding a new ARB locale automatically includes it without any change to the helper.
- **Limit/quota:** none hit.

### 2026-06-11 — App update notification (soft prompt + forced-update gate)

- **Session id:** not exposed in the environment (`CLAUDE_SESSION_ID` unset).
- **Artifacts created:**
  - `lib/core/update/app_version.dart` — `AppVersion` value type: tolerant `tryParse` for `1.2.3+45`-style versions, full ordering (semantic triple, build as tie-breaker)
  - `lib/core/update/update_info.dart` — tolerant parser for the owner-hosted version JSON (contract documented in the dartdoc: `latestVersion`, `minimumVersion`, `storeUrl`/`appStoreUrl`/`playStoreUrl`, shared + per-platform `message`), privacy-safe per-platform store-URL/message resolution
  - `lib/core/update/update_policy.dart` — pure `UpdatePolicy.decide` → `UpdateDecision{none|soft|force}`; force only with a valid store URL (degrades to dismissible soft otherwise — never traps the user); soft muted per advertised version once dismissed
  - `lib/core/update/update_info_fetcher.dart` — bare Dio GET (10 s timeouts, no auth headers/interceptors, separate from the rectification Dio stack); every failure collapses to `null`
  - `lib/core/update/store_launcher.dart` — `StoreLauncher` interface + `url_launcher`-backed impl (external mode), re-validates the URL before launch
  - `lib/data/prefs/update_prompt_store.dart` — per-version dismissal persistence (mirrors `ReviewPromptStore`)
  - `lib/features/app_update/update_controller.dart` — providers incl. `appUpdateDecisionProvider` (disabled-by-default URL gate → demo-default gate → fetch → policy)
  - `lib/features/app_update/update_gate.dart` — app-level `UpdateGate`: soft banner (AppCard chrome, Not now / Update) and full-screen forced gate (ErrorScaffold layout, `PrimaryButton`), failure SnackBar
  - tests: `test/unit/core/update/{app_version,update_info,update_policy}_test.dart`, `test/data/prefs/update_prompt_store_test.dart`, `test/widget/features/app_update/update_gate_test.dart`, `test/helpers/fake_store_launcher.dart`
- **Artifacts changed:** `lib/core/app_links.dart` (`versionCheckUrl` via `--dart-define=TRUERISE_VERSION_CHECK_URL`, **default empty = check disabled**; `isPrivacySafeStoreUrl` allowing only the Play-Store `?id=` query); `lib/app/app.dart` (`MaterialApp.router(builder: UpdateGate(...))`); `lib/providers/core_providers.dart` (`packageInfoProvider`); `lib/features/settings/settings_screen.dart` (M11 "App version" now real: `TrueRise  v{version} ({build})` from package_info_plus); 5 ARB files + regenerated `app_localizations*.dart` (`flutter gen-l10n`; 7 new `update*` keys × en/de/es/fr/pt); `pubspec.yaml` (+`package_info_plus ^9.0.1`, +`url_launcher ^6.3.2` — smallest flutter.dev-maintained plugin for handing a public HTTPS store URL to the OS); tests for app_links/settings updated.
- **Work completed (TDD):** runtime update notification. Owner hosts a public JSON; when `latestVersion >` installed → dismissible banner (once per advertised version); when `minimumVersion >` installed → non-dismissible full-screen gate whose only action opens the store. Check is fail-silent and structurally privacy-safe: bare GET of an owner-configured HTTPS URL, no identifiers, no tracking params (validators reject query strings except Play's `id`).
- **Demo boundary:** per-run demo (`isDemo`) is calc-flow state, not global at startup; the globally readable signal is the Settings "Demo mode" default — when ON the check is skipped entirely, so demo-defaulted builds make no update-check call; demo calculations never touch this path. With no `TRUERISE_VERSION_CHECK_URL` define the check never runs at all (also true for the whole current test/CI fleet).
- **Verification — RUN AND PASSED:** `flutter pub get` (via `pub add`); `dart format` on all changed Dart files → 2 reformatted; `flutter analyze` → **No issues found!**; focused suites: 54 unit (version/info/policy/store/app_links) + 10 widget (gate) — written first, watched fail, then green; full `flutter test` → **404 passed** (was 351; +53). Flutter 3.44.0 / Dart 3.12.0. `integration_test/demo_flow_test.dart` on the iPhone 17 Pro simulator (iOS 26.5) → **passed** (full offline demo flow under the new `UpdateGate`, with the new native plugins compiled in).
- **Constraints respected:** no Firebase/Sentry/analytics/accounts/payments; no secrets (the check URL and store URLs are public values); no generated-file hand-edits (`gen-l10n` regenerated); demo mode offline; deferred MVP scope untouched.
- **Residual risks / OWNER follow-ups:** (1) **OWNER:** host the version JSON on an owned HTTPS URL and build with `--dart-define=TRUERISE_VERSION_CHECK_URL=...` — until then the feature is dormant by design. (2) **OWNER:** fill real `appStoreUrl`/`playStoreUrl` values in that JSON once store listings exist (same release gate as `TRUERISE_SHARE_URL`). (3) Remote `message` is a single string per platform, not localized per locale — acceptable for an MVP-stage owner note; revisit if multilingual notes are needed. (4) The soft banner re-appears next cold start for a *newer* advertised version only; no time-based cooldown was added (per-version muting was judged sufficient).
- **Limit/quota:** none hit.

### 2026-06-11 — Amendment: tightened store-URL validation + update-provider tests

- **Session id:** not exposed in the environment (`CLAUDE_SESSION_ID` unset).
- **Artifacts changed:** `lib/core/app_links.dart` (`isPrivacySafeStoreUrl`
  tightened), `test/unit/core/app_links_test.dart` (new rejection cases);
  **created** `test/unit/features/app_update/update_controller_test.dart`.
- **Work completed:** review follow-up, two targeted fixes. (1)
  `AppLinks.isPrivacySafeStoreUrl` previously accepted *any* HTTPS URL whose
  sole query parameter was `id`; the query exception is now exact to the
  canonical Play Store web URL — host `play.google.com`, path
  `/store/apps/details`, single non-empty `id` (checked via
  `queryParametersAll`, so repeated `id`s are rejected too). Bare HTTPS URLs
  with no query remain allowed; `?id=` on other hosts, wrong Play paths, empty
  ids, extra params, userinfo, fragments, and non-HTTPS all rejected. (2)
  Provider-level tests for `appUpdateDecisionProvider` covering the guards the
  pure-policy tests could not see: empty/invalid `TRUERISE_VERSION_CHECK_URL`
  → `none` with the fetcher never called; Settings demo-mode default ON →
  `none` with the fetcher never called; valid URL + newer advertised version →
  `soft` with store URL + prompt tag; failed fetch (null payload) → silent
  `none`. Tests use provider overrides + a recording fake fetcher — no network.
- **Verification — RUN AND PASSED (TDD):** new validation tests written first
  and watched fail (3 failures), then green after tightening; the demo-boundary
  provider test was mutation-checked (guard removed → test fails, restored →
  green); `dart format` on 3 changed files → 0 reformatted; `flutter analyze`
  → **No issues found!**; focused suites (app_links 19, update controller 5,
  core/update 35, prompt store 3, update gate 10) → **72 passed**; full
  `flutter test` → **412 passed** (was 404; +8 new). Flutter 3.44.0 / Dart
  3.12.0. Integration test not rerun (no behavior change on the demo path).
- **Constraints respected:** no new dependencies; no generated-file edits; demo
  mode still performs no update-check network call (now pinned by a provider
  test); no secrets.
- **Residual risks:** none new — the OWNER follow-ups from the main 2026-06-11
  entry stand unchanged.
- **Limit/quota:** none hit.

### 2026-06-12 — P0: live-mode entry + coordinate correctness

- **Session:** Claude Code (id not exposed in-session).
- **Artifacts changed:** `lib/features/onboarding/onboarding_screen.dart`,
  `lib/features/onboarding/onboarding_controller.dart`,
  `lib/features/calculation_flow/state/calculation_flow_state.dart`;
  tests: `test/widget/features/onboarding/onboarding_screen_test.dart`,
  `test/features/calculation_flow/calculation_flow_controller_test.dart`.
- **Work completed:** (1) Onboarding CTAs now set the mode they advertise:
  `OnboardingController.complete()` takes a required `demoMode` and persists
  `demoModeDefault` before `onboardingDone`. "Try demo first" → `true`,
  "Start real calculation" → `false`, Skip → `true` (safe demo default while
  geocoding is stubbed; the stored fresh-install default stays `false` — every
  onboarding exit now writes an explicit value, so the raw default is never
  consumed for flow entry). (2) Live submissions can no longer silently send
  0,0: `birthStepValid` now requires resolved lat/lon when `isDemo == false`
  (new `hasResolvedCoordinates` getter); `toRequest()` keeps the `?? 0`
  fallback only for the demo branch and uses the non-null coords for live
  (guaranteed by `readyToSubmit`). Typing after selecting a city clears the
  coords (existing behavior), which now re-blocks live Continue/submit via the
  existing button gating — no UI changes needed.
- **Verification — RUN AND PASSED (TDD):** 5 new/extended tests written first
  and watched fail (demo CTA, real CTA, skip-sets-demo, live-blocked-without-
  coords, typing-clears-coords re-block), then green after the implementation;
  plus passing guards: geocoded place unblocks live flow and submits the
  resolved coords; demo typed-only city stays valid; demo submit asserts the
  0,0 fallback. `dart format` → 0 changed; `flutter analyze` → **No issues
  found!**; focused suites (onboarding + calc flow controller) → **23 passed**;
  full `flutter test` → **418 passed** (was 412; +6 new). Flutter 3.44.0 /
  Dart 3.12.0. Integration test not rerun (demo flow behavior unchanged;
  needs a device).
- **Constraints respected:** scope held to P0 item 1 — no Bundle ID, signing,
  privacy/share URL, time format, cancel/retry, low-confidence UX, or
  dependency work; demo mode stays offline; no secrets; no generated files.
- **Residual risks:** live mode with the stubbed geocoder only resolves 12
  hard-coded cities, so a live user whose city is missing is now blocked at
  the birth step (correct but a dead end until real geocoding lands); no
  inline "select a city from the list" hint yet — Continue is disabled
  without explanation; `setIsDemo` still has no UI surface inside the flow.
- **Limit/quota:** none hit.

### 2026-06-12 - Bundle ID recommendation doc (P0-3, owner decision)

- **Session:** Claude Code (id not exposed in-session).
- **Artifacts created:** `docs/bundle-id-recommendation.md`.
- **Work completed:** doc-only. Owner-facing recommendation for the bundle
  ID / package namespace decision (P0-3): primary `app.astrolium.truerise`,
  fallbacks `com.astrolium.truerise` and `com.truerise.app`; reasoning
  (store-identifier lock-in before first store setup, umbrella publisher
  namespace vs product namespace, why the proposed `app.astrolium.*` works,
  why `com.rectify.rectify` should not ship publicly unless deliberately
  chosen); owner-confirmation list (domain control, account naming, TrueRise
  name/legal availability - flagged as needing owner/legal confirmation, no
  legal assessment made); deferred implementation checklist.
- **Verification:** `git diff --check` clean; grep confirms
  `com.rectify.rectify` unchanged in `android/app/build.gradle.kts`,
  `MainActivity.kt`, and `project.pbxproj`; no code/identifier changes.
- **Limit/quota:** none hit.
- **Open question:** owner pick + confirmations in
  `docs/bundle-id-recommendation.md` Sec. "Owner must confirm".

### 2026-06-12 - Android release signing wiring (P0-2, no debug fallback)

- **Session:** Claude Code (id not exposed in-session).
- **Artifacts changed:** `android/app/build.gradle.kts`,
  `android/key.properties.example`, `README.md` (Android signing section),
  `docs/publication-readiness-current-status.md` (P0-2 row, tally, 5a/5b),
  `docs/store-submission-readiness.md` (status callout, exec summary item 2,
  P0-2 row).
- **Work completed:** release build type no longer falls back to debug
  signing. `build.gradle.kts` reads `android/key.properties` (template:
  `android/key.properties.example`), validates `storePassword`,
  `keyPassword`, `keyAlias`, `storeFile` (non-blank) plus keystore
  existence, resolves `storeFile` absolute or relative to `android/`
  (`rootProject.file`), and creates the `release` signing config only when
  complete. When missing/incomplete, a task-graph guard fails any requested
  release task with instructions (copy the example, provide the
  owner-supplied upload keystore); debug builds never need the file. No
  real secrets added; bundle ID / namespace untouched
  (`com.rectify.rectify`).
- **Verification - RUN AND PASSED:** `./gradlew :app:assembleDebug -m`
  without `key.properties` -> BUILD SUCCESSFUL; `./gradlew
  :app:assembleRelease -m` without it -> fails with the intended message;
  with an incomplete file -> "missing value(s) for: keyPassword,
  storeFile"; with a throwaway local keystore (absolute and
  `android/`-relative `storeFile`) -> `:app:validateSigningRelease`
  BUILD SUCCESSFUL. Throwaway keystore + `key.properties` deleted after.
  `git diff --check` clean. Full Flutter test suite not rerun (no Dart
  code changed).
- **Constraints respected:** no secrets in repo; `android/.gitignore`
  already excludes `key.properties` / `*.jks` / `*.keystore`; doc claims
  updated honestly (engineering wiring done, owner keystore + Play App
  Signing + iOS distribution signing still pending).
- **Residual risks:** owner upload keystore and Play App Signing enrollment
  remain the real-world blocker (P0-2 owner half); release-task detection
  matches task names containing "Release" for this module - standard
  assemble/bundle/validateSigning flows are covered, but an exotic custom
  task name without "Release" would not trip the guard; Gradle
  configuration cache (not enabled) would need a different guard wiring.
- **Limit/quota:** none hit.

### 2026-06-12 - Share copy respects the 12h/24h time-format setting

- **Session:** Claude Code (id not exposed in-session).
- **Artifacts changed:** `lib/core/sharing/share_copy_builder.dart`,
  `lib/features/calculation_flow/screens/result_screen.dart` (3 call
  sites), `lib/features/home/home_history_screen.dart`; tests:
  `test/unit/sharing/share_copy_builder_test.dart`,
  `test/widget/features/calculation_flow/result_share_test.dart`.
- **Work completed:** `ShareCopyBuilder.build` no longer hardcodes AM/PM:
  the private `_formatTime` helper was replaced by
  `AppDateFormat.clockTime` driven by a new backward-compatible named
  parameter `timeFormat` (defaults to `TimeFormat.h12`, preserving the
  original output for existing callers/tests). All four UI call sites now
  pass the live `settings.timeFormat`: result text share, result image
  caption share, demo share prompt, and history row share. Privacy
  guarantees unchanged - the builder still emits only time, ascendant,
  confidence, brand, and the public store link.
- **Verification - RUN AND PASSED (TDD):** new tests written first and
  watched fail (unit file failed to load on the missing parameter; the
  h24 widget test failed), then green: unit tests pin default/explicit
  h12 ("2:05 PM", no "14:05") and h24 ("14:05" / zero-padded "07:14", no
  AM/PM); widget test with `settings.time_format=h24` proves tapping
  Share result delivers 24-hour copy to the share service with no
  meridiem. `dart format` -> 0 changed; `flutter analyze` -> No issues
  found; focused suites (share copy unit, result share, demo share
  prompt, history share) -> 47 passed; full `flutter test` -> 423 passed
  (was 418; +5 new). `git diff --check` clean.
- **Constraints respected:** no PII added to share copy (locale-sweep
  privacy tests still green); no scope beyond time formatting.
- **Residual risks:** meridiem text follows `intl`'s default locale (as
  elsewhere in the app) rather than the share-copy l10n bundle - a
  pre-existing nuance, unchanged by this fix.
- **Limit/quota:** none hit.

### 2026-06-12 - Low-confidence result guidance (refine-input note)

- **Session:** Claude Code (id not exposed in-session).
- **Artifacts changed:**
  `lib/features/calculation_flow/screens/result_screen.dart` (new
  `_LowConfidenceNote` + keyed conditional render under the confidence
  bar), `lib/widgets/result/confidence_bar.dart` (named band constants +
  `ConfidenceBar.isLowBand` so the threshold has one source of truth),
  l10n: `app_{en,de,es,fr,pt}.arb` (+ regenerated
  `app_localizations*.dart` via `flutter gen-l10n`); tests:
  `test/widget/features/calculation_flow/result_screen_test.dart`.
- **Work completed:** results whose top candidate confidence sits in the
  ConfidenceBar low band (< 40%) now show a localized inline guidance
  note directly under the bar: EN "Low confidence result" / "Add more
  dated life events or narrow the birth-time window to improve the
  estimate." (+ de/es/fr/pt following each locale's existing
  terminology and address form). Tone is needs-more-input, not error;
  styling mirrors the events-step guidance banner tokens (clay tint,
  small radius) - no redesign, no nested cards. No refine CTA was
  added: the draft is cleared on successful submit and re-entering the
  calc flow cannot rehydrate a saved result's input without new state
  plumbing (id reuse would also overwrite the history row), which the
  task explicitly rules out as risky; the rationale is documented on
  the widget.
- **Verification - RUN AND PASSED (TDD):** 4 new widget tests written
  first and watched fail (file failed to load on the missing test key),
  then green: low (35%) shows note with exact EN copy while the rest of
  the result surface stays intact; boundary 39% shows it; boundary 40%
  does not; high (78% demo) does not. `dart format` -> 0 changed;
  `flutter analyze` -> No issues found; result-screen suite -> 9 passed;
  full `flutter test` -> 427 passed (was 423; +4). `git diff --check`
  clean.
- **Constraints respected:** generated l10n files regenerated, not
  hand-edited; same 40% threshold as the bar color via shared helper;
  no navigation/state plumbing added; demo/history flows untouched.
- **Residual risks:** de/es/fr/pt strings are my translations following
  existing in-file terminology - native-speaker review remains the
  standing caveat for all localized copy; "refine from result" CTA
  would need draft-rehydration plumbing (new id, mode handling) if the
  owner wants it later.
- **Limit/quota:** none hit.

### 2026-06-12 - Loading Cancel + error retry hardening

- **Session:** Claude Code (id not exposed in-session).
- **Artifacts changed:**
  `lib/features/calculation_flow/state/calculation_flow_controller.dart`
  (submit generation token + `cancelSubmit()`),
  `lib/data/repos/rectification_repository.dart` (optional `isCancelled`
  poll on `submit` + `submissionCancelledFailure` marker; live impl
  skips the history write when cancelled),
  `lib/features/calculation_flow/screens/loading_screen.dart` (Cancel
  now calls `cancelSubmit()`; stable `loadingCancelButtonKey`),
  `lib/features/error_flow/error_screen.dart` (stable
  `errorPrimaryActionKey`/`errorSecondaryActionKey`; no behavior
  change), `test/helpers/fake_rectification_repository.dart` (honors
  `isCancelled` like the live repo); tests:
  `test/widget/features/calculation_flow/loading_screen_test.dart`,
  `test/widget/features/error_flow/error_routing_test.dart`.
- **Work completed:** tapping Cancel on /calc/loading now abandons the
  in-flight submission instead of just leaving the route. The
  controller bumps a monotonic submit generation; when the orphaned
  submit future completes it (a) never navigates (pre-existing mounted
  guard), (b) no longer clears the editable draft - the cancelled-
  generation fold returns early leaving repo + state untouched - and
  (c) no longer saves a history row: the repository polls
  `isCancelled` after the slow part (demo delay / network round trip)
  and before `history.save`. Error-screen actions unchanged (already
  correct): retryable primary re-enters /calc/loading, badRequest
  primary returns to confirm, no-draft primary falls home, secondary
  resets + home; they are now pinned by tests via new stable keys.
- **Verification - RUN AND PASSED (TDD):** 5 new widget tests written
  first and watched fail (both files failed to load on the missing
  keys), then green: cancel-during-blocked-submit returns to confirm,
  and after the blocked submit completes the route stays confirm, the
  draft stays editable (state + repo) and no history row exists;
  retryable error fires a second submission and lands on
  /calc/result/:id after the fake recovers; badRequest primary goes to
  confirm without resubmitting; primary with no draft goes home with
  no exception; secondary clears the draft and goes home. `dart
  format` -> 0 changed; `flutter analyze` -> No issues found; focused
  loading + error suites -> 16 passed; full `flutter test` -> 432
  passed (was 427; +5). `git diff --check` clean.
- **Residual cancellation limits (documented by design):** (1) a
  cancelled real-mode submission does not abort the HTTP request - the
  round trip completes and only its outcome is discarded (true Dio
  cancel-token plumbing would be a broader change); (2) the
  cancellation poll runs once before `history.save`, so a cancel that
  lands mid-write can still persist the row (microsecond window, demo
  path in-memory); (3) cancelling does not refund any provider API
  usage already incurred.
- **Limit/quota:** none hit.
