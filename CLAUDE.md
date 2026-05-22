# Claude Code Instructions

## Project

TrueRise (`rectify`) is a Flutter mobile app for birth-time rectification.
The project targets iOS 15+ and Android 10+.

Read these files before making non-trivial changes:

- `README.md`
- `docs/prd.md`
- `docs/mvp-scope.md`
- `docs/implementation-plan.md`
- `docs/design-system.md`
- `docs/api-integration.md`
- `docs/claude-build-history.md`

## Stack

- Flutter 3.44 / Dart 3.12
- Riverpod 3 with code generation
- go_router
- Drift + sqlite3
- Dio
- flutter_secure_storage
- shared_preferences
- Material 3
- very_good_analysis

## Working Rules

- Keep edits scoped to the requested task.
- Do not rewrite architecture without explaining the reason first.
- Do not add MVP scope that is explicitly deferred in `docs/mvp-scope.md` or
  `docs/implementation-plan.md`, especially payments, IAP, paywalls, accounts,
  sync, dark mode, chart rendering, export, or Vedic/KP toggles.
- Demo mode must remain offline and must not make network calls.
- Do not put secrets in source code, logs, Drift, SharedPreferences, generated
  output, or docs.
- Treat `.env`, provider API keys, signing files, Firebase configs, Sentry
  DSNs, and store credentials as sensitive.
- The app may read the demo/review `.env` only according to the security
  boundary documented in `README.md` and `docs/api-integration.md`.
- Use `flutter_secure_storage` for user-entered API keys only.
- Preserve generated files unless the task requires regenerating them.
- Do not edit `*.g.dart`, `*.freezed.dart`, or other generated files manually.
- If generated sources are stale, run build_runner instead of hand-editing.
- Before large or risky edits, inspect `git status --short` and avoid
  overwriting unrelated user changes.

## Claude Code Plugins

The user-level Claude Code plugin `superpowers@superpowers-marketplace`
from `obra/superpowers` is installed and enabled for this machine. The
official-marketplace duplicate is disabled to avoid duplicate always-on context.

Use the core Superpowers skills when they fit the work:

- Use `brainstorming` before broad feature or product behavior changes.
- Use `writing-plans` before multi-step implementation.
- Use `test-driven-development` for changes where a meaningful test can be
  written first.
- Use `systematic-debugging` for defects, crashes, regressions, or failing
  tests.
- Use `verification-before-completion` before reporting a fix as done.

The user-level Claude Code plugin `superpowers-v@procoders` is also installed
and enabled. Use it for substantial engineering work in this project,
especially when the task needs research before editing, multi-file
implementation, architecture-sensitive changes, or parallel review.

Expected behavior:

- Use `compound-v` before broad feature work or non-trivial refactors.
- Use `v-archaeology` when the implementation path depends on existing code
  structure or hidden coupling.
- Use `v-dispatch` only when the task can be split into clearly disjoint file
  sets.
- Do not invoke heavy parallel workflows for tiny single-file edits.
- Keep token usage in mind: `superpowers-v` adds always-on context and its
  invoked agents/skills have additional token cost.

## Common Commands

Install dependencies:

```bash
flutter pub get
```

Regenerate generated Dart sources after changing annotated models/providers:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Analyze:

```bash
flutter analyze
```

Run tests:

```bash
flutter test
```

Run the demo flow integration test:

```bash
flutter test integration_test/demo_flow_test.dart
```

Run the app on the default connected device/simulator:

```bash
flutter run
```

## Verification Expectations

For code changes, run the narrowest useful checks first. Prefer:

1. `dart format` on changed Dart files when formatting is needed.
2. `flutter analyze`.
3. Relevant focused tests.
4. Full `flutter test` when the change touches shared models, routing,
   persistence, repositories, or app-wide UI behavior.

If a command cannot run because Flutter/Xcode/Android tooling is missing in the
current environment, report that clearly and include the command that should be
run locally.

## Documentation Protocol

When Claude Code completes a meaningful project stage, append a short entry to
`docs/claude-build-history.md` with:

- date and stage name;
- Claude session id, when available;
- artifacts created or changed;
- short summary of the work;
- verification performed;
- known limit/quota status;
- remaining risks or open questions.
