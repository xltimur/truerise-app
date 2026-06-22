# Release Preflight - Local Verification Commands (TrueRise)

**Purpose.** The exact local commands an owner/engineer runs before a release,
each with its expected outcome. Companion to
`docs/release-handoff-owner-checklist.md` (what still needs owner input) and
`docs/publication-readiness-current-status.md` (per-blocker status).

**Safety.** Every command here is safe and non-secret. URLs are non-secret by
design; real secrets (provider key, signing material) never appear in commands -
placeholders are redacted as `$VAR` or `<owner-...>`. Demo mode and all checks
below make **no** live API calls and spend **no** provider credits.

**Toolchain.** Flutter 3.44 / Dart 3.12. If a command cannot run because
Flutter/Xcode/Android tooling is missing, that is an environment gap, not a code
defect - report the command to run locally.

> **Important - guard argument form.** `tool/release_env_guard.dart` accepts
> value flags only in the **`--flag=value`** (equals) form, e.g.
> `--share-url=https://truerise.app`. The space form
> (`--share-url https://...`) is rejected as an unknown argument (exit 2).
> Older revisions of `README.md`, `docs/api-integration.md`, and
> `docs/store-submission-readiness.md` section 11.1 used the space form; those
> docs now use the equals form, so follow the equals form (in those docs and
> below). (`--allow-bundled-key`, `--allow-default-share-url`, and
> `--allow-default-proxy-url` are standalone flags and take no value.)

---

## 1. Docs-only verification (this handoff change)

```bash
git status --short
git diff --check                       # expect: no whitespace/conflict errors
# Scoped guard: confirm NO app code / asset / config changed
git status --short -- lib ios android test integration_test pubspec.yaml \
  pubspec.lock assets screenshots tool l10n.yaml
```

Expected: only `docs/*.md` files appear as changed/added; the scoped second
command returns **empty**.

Quick link/reference checks:

```bash
# The two new handoff docs exist and are cross-referenced
rg -l 'release-handoff-owner-checklist|release-preflight-commands' docs/
# No composited-screenshot directory was introduced anywhere
find screenshots/store -name composited -type d       # expect: no output
```

---

## 2. release_env_guard - the release-config gate

The guard runs four gates in order: **share URL -> no-key API URL -> provider
API URL -> bundled key**. It exits at the first failure. Exit codes: `0` = OK,
`1` = BLOCKED (a gate failed), `2` = usage error (unknown argument). The key
value is never printed; rejected custom URLs are never echoed.

### 2.1 Passing preflight (real owner values)

```bash
export PATH="$HOME/development/flutter/bin:$PATH"   # if flutter is not on PATH
dart run tool/release_env_guard.dart \
  --share-url="$TRUERISE_SHARE_URL" \
  --proxy-base-url="$RECTIFY_PROXY_BASE_URL" \
  --provider-base-url="$RECTIFY_PROVIDER_BASE_URL" \
  --allow-bundled-key --purpose=review-capped
```

Expected (`exit 0`): four OK/ACKNOWLEDGED lines -

```
ACKNOWLEDGED: bundled ASTRO_API_KEY (value redacted) accepted for purpose "review-capped". ...
OK: custom share URL accepted (bare HTTPS, no userinfo, no query, no fragment).
OK: custom proxy base URL accepted (host-only HTTPS origin, no path, ...).
OK: default/custom provider base URL accepted (...).
```

- `$TRUERISE_SHARE_URL` / `$RECTIFY_PROXY_BASE_URL` /
  `$RECTIFY_PROVIDER_BASE_URL` must be **bare** HTTPS (API/provider/proxy:
  host-only origin, no path). Anything with a path/query/fragment/userinfo is
  rejected (exit 1, value redacted). When omitted, `RECTIFY_PROXY_BASE_URL`
  defaults to `https://api-public.astrology-api.io` and
  `RECTIFY_PROVIDER_BASE_URL` defaults to `https://api.astrology-api.io`.
- **Drop** `--allow-bundled-key --purpose=review-capped` once `ASTRO_API_KEY`
  has been removed from `.env`; with no bundled key the guard prints
  `OK: no bundled ASTRO_API_KEY found`.

### 2.2 Expected failures when owner secrets/URLs are missing

| Command | Exit | Why |
| --- | --- | --- |
| `dart run tool/release_env_guard.dart` (no args) | `1` | default placeholder share URL `https://truerise.app` -> BLOCKED (share gate runs first) |
| `... --share-url=https://truerise.app` (default API host omitted) | `1` | BLOCKED: `https://truerise.app` is still the default share placeholder unless explicitly owner-confirmed |
| `... --share-url=https://x.example --proxy-base-url=https://p.example` (bundled key present, no ack) | `1` | BLOCKED: tracked `.env` bundles a non-empty `ASTRO_API_KEY` without acknowledgement |
| `... --allow-bundled-key` (no `--purpose`) | `1` | BLOCKED: `--allow-bundled-key` requires `--purpose=review-capped` |
| `... --share-url=https://truerise.app?utm=x` | `1` | BLOCKED: custom share URL not bare HTTPS (query present; value redacted) |
| `... --proxy-base-url=https://p.example/v1` | `1` | BLOCKED: proxy URL must be host-only (path belongs in `RECTIFY_PROXY_PATH`) |
| `... --provider-base-url=https://p.example/v1` | `1` | BLOCKED: provider URL must be host-only (path belongs in `RECTIFY_PROVIDER_PATH`) |
| `... --share-url https://x.example` (space form) | `2` | usage error: `--share-url` is an unknown argument; use `--share-url=...` |

Placeholder-acknowledgement escape hatch for the share URL:

```bash
# Ship the placeholder share URL on purpose (owner-confirmed):
dart run tool/release_env_guard.dart \
  --allow-default-share-url --share-url-purpose=owner-confirmed
```

Legacy proxy-placeholder acknowledgement flags are accepted but no longer
required; the default no-key API host is `https://api-public.astrology-api.io`.

---

## 3. Privacy-policy URL check

`TRUERISE_PRIVACY_POLICY_URL` is validated by the app at build time (bare HTTPS,
no query/fragment/userinfo; empty default keeps the in-app fallback). Confirm
the hosted URL resolves before putting it in the build and the consoles:

```bash
curl -sS -o /dev/null -w '%{http_code}\n' "$TRUERISE_PRIVACY_POLICY_URL"
# expect: 200
```

(Owner step - the canonical URL does not exist until legal/hosting publishes
`docs/privacy-policy.md`. Use the **same** URL in the build define and in both
store consoles.)

---

## 4. Screenshot finalization checks (no composited output)

```bash
# 1. No final/composited PNGs exist (must stay empty until owner/design renders)
find screenshots/store -name composited -type d        # expect: no output

# 2. Plan all composites without writing anything
dart run tool/store_screenshot_compositor_dry_run.dart  # expect: exit 0
#   -> "Dry run complete: wrote no files, created no directories, rendered nothing."
#   (also reports the 5 locale manifests still need the current 5-frame plan)
dart run tool/store_screenshot_compositor_dry_run.dart --verbose   # lists planned output paths
```

Exit codes for the dry-run CLI: `0` pass, `1` validation fail, `64` usage error.
The guarded write CLI (`tool/store_screenshot_compositor_write.dart`) stays
no-write by default; a real write needs both `--write` and `--yes` and the
Flutter engine (a plain `dart run ... --write --yes` exits `70`). Do not run it
in this handoff - final compositing is owner/design work.

Store screenshot locales present: `en`, `de`, `es`, `fr`, `pt-BR` (+ the
`en-current-draft` scratch frames, which are intentionally not a supported store
locale).

---

## 5. l10n / analyze / tests

```bash
# l10n is generated at build time (generate: true); regenerate explicitly with:
flutter gen-l10n
ls lib/l10n/app_*.arb        # expect 5: app_en app_de app_es app_fr app_pt

# Static analysis (very_good_analysis)
flutter analyze              # expect: No issues found!

# Full suite (touches shared models/routing/persistence) - last recorded
# full run: 648 passing on the 2026-06-16 sweep
flutter test

# Demo-flow integration test (offline)
flutter test integration_test/demo_flow_test.dart

# Release-env guard tests must run under flutter_test, NOT `dart test`
# (the test imports package:flutter_test; `dart test` fails to compile it):
flutter test test/tool/release_env_guard_test.dart
```

Notes:
- This handoff is **documentation-only**; `flutter analyze` / `flutter test`
  are not required to land it, but are the gate for any release build.
- `flutter test` count drifts as tests are added; treat "all pass" as the
  expectation and `648` (2026-06-16) as the last recorded figure (supersedes the
  earlier `+587` 2026-06-14 sweep). The dated command/result snapshot lives in
  `docs/release-verification-report-2026-06-16.md`. These checks being green
  proves the tree is engineering-clean; it does **not** unblock submission - the
  owner/backend/legal/store items in
  `docs/publication-readiness-current-status.md` Sec. 5a still gate any release.

---

## 6. Release builds (only after section 2 passes and owner inputs land)

Reference only - these need the owner keystore (Android) / distribution signing
(iOS) and real `--dart-define` values. Full reference: `README.md`
"Environment configuration".

```bash
set -a; source .env; set +a     # loads RECTIFY_*/TRUERISE_* for the defines

flutter build appbundle --release \
  --dart-define=RECTIFY_ENV=prod \
  --dart-define=RECTIFY_PROXY_BASE_URL="$RECTIFY_PROXY_BASE_URL" \
  --dart-define=RECTIFY_PROXY_PATH="$RECTIFY_PROXY_PATH" \
  --dart-define=RECTIFY_PROXY_APP_ID="$RECTIFY_PROXY_APP_ID" \
  --dart-define=TRUERISE_SHARE_URL="$TRUERISE_SHARE_URL" \
  --dart-define=TRUERISE_PRIVACY_POLICY_URL="$TRUERISE_PRIVACY_POLICY_URL" \
  --android-project-arg=truerise.allowBundledApiKey=true \
  --android-project-arg=truerise.bundledApiKeyPurpose=review-capped
# iOS: flutter build ipa --release  (run the section 2 guard manually first;
# there is no Gradle hook on iOS)
```

- The two `--android-project-arg=truerise.*` lines only acknowledge a bundled
  capped review key to the Android `validateReleaseBundledEnv` Gradle guard.
  **Omit both** (and the guard's `--allow-bundled-key --purpose=review-capped`)
  once `ASTRO_API_KEY` is removed from `.env`.
- The Android release guard also requires real signing
  (`android/key.properties`) and re-checks the share/proxy defines - a build
  with placeholder URLs or an unacknowledged key fails fast.

---

## 7. One-shot preflight summary

```bash
export PATH="$HOME/development/flutter/bin:$PATH"
git diff --check
find screenshots/store -name composited -type d            # expect: empty
flutter analyze                                            # expect: No issues found!
dart run tool/release_env_guard.dart \
  --share-url="$TRUERISE_SHARE_URL" \
  --proxy-base-url="$RECTIFY_PROXY_BASE_URL" \
  --provider-base-url="$RECTIFY_PROVIDER_BASE_URL" \
  --allow-bundled-key --purpose=review-capped              # expect: exit 0
```

If all four are clean and the owner inputs in
`docs/release-handoff-owner-checklist.md` sections 2-6 are satisfied, the
release is ready to build and submit (English Tier 0, Lifestyle).
