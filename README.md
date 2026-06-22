# TrueRise

TrueRise (codename `rectify`) is a Flutter mobile app for **birth-time
rectification**: given a person's approximate birth window plus a few
life events, it returns the most likely true birth time with a confidence
band and per-event evidence. The MVP ships an end-to-end **Demo Mode**
that runs the full input → loading → result → evidence flow with no API
key, no network, and no payment — see `docs/mvp-scope.md` for the full
acceptance criteria and `docs/prd.md` for product context.

- **Platforms:** iOS 15+, Android 10+ (Android `minSdk` set via Flutter
  defaults; see `android/app/build.gradle.kts`).
- **Stack:** Flutter 3.44 / Dart 3.12, Riverpod 3, go_router, Drift +
  sqlite3, Dio, flutter_secure_storage, Material 3.
- **Architecture & roadmap:** `docs/implementation-plan.md` (phase plan,
  security boundary, Appendix B `--dart-define` keys).

---

## Prerequisites

- **Flutter SDK** 3.44 / Dart 3.12 — `flutter --version` should print
  these. Repo is pinned via `pubspec.yaml`'s `sdk: ^3.12.0`.
- **Xcode** 15+ with the iOS 15 simulator runtime (for iOS builds and
  `flutter run` on Simulator).
- **Android Studio / Android SDK** with platform-tools and a `compileSdk`
  matching `flutter.compileSdkVersion`. `flutter doctor --android-licenses`
  must be accepted.
- **CocoaPods** for iOS (`sudo gem install cocoapods` if missing).

Run `flutter doctor -v` and resolve any red items before continuing.

---

## Quick start

```bash
# 1. Clone and install Dart/Flutter deps.
git clone <repo-url> astro-rectification-app
cd astro-rectification-app
flutter pub get

# 2. (Optional) Generate code for Riverpod / Freezed / Drift / json_serializable.
#    Only needed if you touch the annotated source.
dart run build_runner build --delete-conflicting-outputs

# 3. Sanity-check.
flutter analyze
flutter test

# 4. Run on the default device (simulator or attached device).
flutter run
```

`flutter run` with no `--dart-define` flags starts the app in **demo-only
mode** — there is no proxy base URL configured, so only the Demo flow is
reachable. That is the expected default for new clones.

### Running the Demo flow

The Demo flow is the canonical onboarding path and works offline:

1. Launch the app (`flutter run`).
2. Tap **Try Demo** on the onboarding screen, or enable
   *Settings → Demo mode* on subsequent runs.
3. Walk through the input flow with the prefilled mock data — the
   loading screen, result, and evidence screens are wired against
   hardcoded fixtures.
4. The result card is labeled **"Demo — not a real calculation"** and
   performs **zero** network calls.

Integration coverage of this flow lives in
`integration_test/demo_flow_test.dart` (run with
`flutter test integration_test/demo_flow_test.dart`).

### Running the Live mode (real astrology-api.io calculation)

Live mode calls the real astrology-api.io rectification API and costs
**15 credits per request**. No-key live calls use Oleg's public, owner-billed
API endpoint, `https://api-public.astrology-api.io`; user-key/provider-direct
calls use the canonical provider host, `https://api.astrology-api.io`. The key
is resolved at runtime by `proApiKeyProvider`, which prefers a value in secure
storage and otherwise falls back to the bundled `.env`:

1. **Bundled `.env` (demo / review builds).** `lib/main.dart` calls
   `dotenv.load(fileName: '.env')` at startup, and `proApiKeyProvider`
   reads `ASTRO_API_KEY` from that file when secure storage is empty.
   The committed `.env` lets a reviewer install the APK and run the live
   flow without typing a key. See `.env.example` for the security
   caveat — anything in `.env` is baked into the binary as an asset and
   is recoverable from the APK, so use a low-budget key only.
2. **Secure storage (read path).** When `flutter_secure_storage` holds a
   value it wins over the `.env` fallback. The shipped MVP UI no longer
   exposes a per-user key-entry screen, so this path is reserved for a
   future build; a stored value is never copied to SharedPreferences,
   Drift, logs, or request bodies.

Live flow:

1. Launch the app with `flutter run` (no special `--dart-define` needed
   for provider-direct mode — the provider URL is baked in as the
   default).
2. Disable **Demo mode** on the Settings screen if it is on.
3. From the home screen tap **New calculation**, fill in your birth
   data and life events, then tap **Rectify**.

With a key, the app connects to
`https://api.astrology-api.io/api/v3/rectification/search` with
`Authorization: Bearer <key>` and bypasses the local free quota. If no key is
configured (empty `.env` and empty secure storage), the app uses
`https://api-public.astrology-api.io/api/v3/rectification/search` without an
`Authorization` header and keeps the local **3 live requests / 24h** quota
enforced in-app.

See `docs/api-integration.md` for the full endpoint reference and
`docs/implementation-plan.md` §9.5 for the security boundary.

---

## Environment configuration (`.env` + `--dart-define`)

The app reads `.env` at runtime via `flutter_dotenv` (loaded in
`lib/main.dart`, bundled as a Flutter asset declared in `pubspec.yaml`).
Today only `ASTRO_API_KEY` is consumed from `.env`; the other
`RECTIFY_*` keys below are still passed to the Flutter toolchain via
`--dart-define`. The committed [`.env.example`](.env.example) is the
template, and a real `.env` is committed for the demo / review build.

Typical workflow:

```bash
cp .env.example .env             # base `.env` is tracked (demo/review build); `.env.local` etc. are ignored
# edit .env with your local values

set -a; source .env; set +a
flutter run \
  --dart-define=RECTIFY_ENV="$RECTIFY_ENV" \
  --dart-define=RECTIFY_PROXY_BASE_URL="$RECTIFY_PROXY_BASE_URL" \
  --dart-define=RECTIFY_PROXY_PATH="$RECTIFY_PROXY_PATH" \
  --dart-define=RECTIFY_PROXY_APP_ID="$RECTIFY_PROXY_APP_ID" \
  --dart-define=TRUERISE_SHARE_URL="$TRUERISE_SHARE_URL" \
  --dart-define=TRUERISE_PRIVACY_POLICY_URL="$TRUERISE_PRIVACY_POLICY_URL"
```

Public release build (same keys, release mode). First run the guard
preflight — it covers both iOS and Android. The default no-key API host is
`https://api-public.astrology-api.io`; the share URL still needs a real or
owner-acknowledged value:

```bash
# Manual preflight (iOS and Android)
dart run tool/release_env_guard.dart \
  --share-url="$TRUERISE_SHARE_URL" \
  --proxy-base-url="$RECTIFY_PROXY_BASE_URL" \
  --provider-base-url="$RECTIFY_PROVIDER_BASE_URL" \
  --allow-bundled-key --purpose=review-capped
```

```bash
flutter build appbundle --release \
  --dart-define=RECTIFY_ENV=prod \
  --dart-define=RECTIFY_PROXY_BASE_URL="$RECTIFY_PROXY_BASE_URL" \
  --dart-define=RECTIFY_PROXY_PATH="$RECTIFY_PROXY_PATH" \
  --dart-define=RECTIFY_PROXY_APP_ID="$RECTIFY_PROXY_APP_ID" \
  --dart-define=TRUERISE_SHARE_URL="$TRUERISE_SHARE_URL" \
  --dart-define=TRUERISE_PRIVACY_POLICY_URL="$TRUERISE_PRIVACY_POLICY_URL" \
  --android-project-arg=truerise.allowBundledApiKey=true \
  --android-project-arg=truerise.bundledApiKeyPurpose=review-capped
```

The two `--android-project-arg=truerise.*` lines exist only to
acknowledge the bundled capped review key to the Android Gradle guard.
If `ASTRO_API_KEY` has been removed from `.env`, omit them — and omit
`--allow-bundled-key --purpose=review-capped` from the preflight. The
Gradle release guards also require real signing
(`android/key.properties`, see "Android signing" below) and read the
share/proxy values from the build's `--dart-define`s.

Public configuration keys (full reference: `docs/implementation-plan.md`
**Appendix B**):

| Key | Purpose |
|---|---|
| `RECTIFY_ENV` | `dev` / `staging` / `prod` — logger verbosity, Crashlytics. |
| `RECTIFY_PROXY_BASE_URL` | Base URL used for no-key live calls (default: `https://api-public.astrology-api.io`; can be replaced by an owner-controlled proxy). |
| `RECTIFY_PROXY_PATH` | Endpoint path appended to `RECTIFY_PROXY_BASE_URL` (default: `/api/v3/rectification/search`). |
| `RECTIFY_PROXY_APP_ID` | Public app identifier (NOT a secret; see Appendix B). |
| `TRUERISE_SHARE_URL` | Public share-link base for shared copy (bare HTTPS, no tracking params). |
| `TRUERISE_PRIVACY_POLICY_URL` | Optional public (non-secret) hosted privacy-policy page opened from Settings. Must be a bare HTTPS URL (no query/fragment/userinfo). Default is empty = disabled: the Settings row keeps the bundled in-app `PrivacyPolicyScreen`, which is also the fallback for unsafe values or launch failures. |
| `RECTIFY_PROVIDER_BASE_URL` | Provider-direct base URL for user/bundled API-key mode (default: `https://api.astrology-api.io`). |
| `RECTIFY_PROVIDER_PATH` | Provider-direct endpoint path (default: `/api/v3/rectification/search`). |
| `RECTIFY_GEOCODING_BASE_URL` | Public geocoding provider URL. |
| `RECTIFY_GEOCODING_PUBLIC_KEY` | URL/bundle-id-restricted `pk.…` token only. |

**Security boundary** (see `docs/implementation-plan.md` §9.7 and the
note at the top of Appendix B): every `--dart-define` value is compiled
into the released IPA/APK as a plain string and is trivially recoverable
from the binary. Therefore none of the keys above are confidential
secrets. The production rectification provider's API key, any Mapbox
`sk.…` token, and any third-party billing credential live **server-side
in the proxy** and never reach this repo. Any key held in
`flutter_secure_storage` is read only from there and is never copied to
SharedPreferences, Drift, logs, or request bodies.

---

## Android signing

Release signing follows the standard Flutter flow
(<https://flutter.dev/to/reference-keystore>). The template lives at
[`android/key.properties.example`](android/key.properties.example) — the
real `android/key.properties` and the `.jks` / `.keystore` it references
are git-ignored and must remain so.

```bash
cp android/key.properties.example android/key.properties
# edit android/key.properties: storePassword, keyPassword, keyAlias, storeFile
```

`android/app/build.gradle.kts` reads `android/key.properties` to sign
release builds; there is no debug-signing fallback. Release tasks
(`flutter build apk`, `flutter build appbundle`, `flutter run --release`)
fail with an actionable error when the file is missing, incomplete
(`storePassword`, `keyPassword`, `keyAlias`, `storeFile` are all
required), or points at a keystore that does not exist. `storeFile`
accepts absolute paths or paths relative to `android/`. Debug builds do
not need `key.properties`. The real Play upload keystore is owner-held
and not in the repo; Play App Signing enrollment is an owner step. See
`docs/qa-phase8-report.md` §6 for the full store-submission checklist.

---

## What is intentionally NOT in the repo

The following are git-ignored and must be provisioned locally / per
developer. None of them are required to run the demo flow.

- **IDE state** — `.idea/`, `*.iml`, `*.iws`, `*.ipr`.
- **Build output** — `/build/`, `.dart_tool/`, `.flutter-plugins-dependencies`,
  `app.*.symbols`, `app.*.map.json`, `/coverage/`, `/android/app/{debug,profile,release}`.
- **Environment overrides** — `.env.local`, `.env.dev`, `.env.staging`,
  `.env.prod`, `.env.*.local`. The base `.env` IS committed for the
  demo / review APK build (see `.env.example`); per-developer overrides
  stay local.
- **Android signing material** — `android/key.properties`,
  `**/*.keystore`, `**/*.jks` (only `android/key.properties.example`
  is committed).
- **Android local.properties** — generated from the local Flutter/SDK
  install.
- **Firebase / Crashlytics / Sentry configs** — `google-services.json`,
  `GoogleService-Info.plist`, Sentry DSNs. None are present in the repo;
  Crashlytics provisioning is an open follow-up (see
  `docs/qa-phase8-report.md`). If/when these are added, double-check
  that `.gitignore` excludes them.
- **CocoaPods build artifacts** — `ios/Pods/`, `Podfile.lock` per
  Flutter's defaults (re-resolved by `flutter run`).

---

## GitHub setup

The local repo already has an initial commit. To publish:

```bash
gh repo create <org>/astro-rectification-app --private --source=. --remote=origin
git push -u origin main
```

(or, without `gh`, create the empty remote in the GitHub UI and then
`git remote add origin <url> && git push -u origin main`.)

Before pushing for the first time, confirm `android/key.properties`
and any keystore files are **not** tracked (the committed `.env` is
intentional — see the section above):

```bash
git ls-files | grep -E '(key\.properties$|\.jks$|\.keystore$|google-services\.json|GoogleService-Info\.plist)'
# should print nothing
```

---

## Repo map

- `lib/` — Flutter source. `app/`, `features/`, `data/`, `providers/`,
  `theme/`, `widgets/`, `core/`.
- `test/` — unit + widget tests (includes `test/security/` static gates).
- `integration_test/` — end-to-end Flutter integration tests.
- `assets/fonts/` — bundled Inter / Source Serif 4 / JetBrains Mono.
- `docs/` — PRD, MVP scope, design brief, design system,
  implementation plan (with Appendix B), per-phase QA reports, and the
  Claude Code build history.
- `design/` — clickable HTML prototype used during the design phase.
- `android/`, `ios/` — platform shells. The Android Gradle setup is in
  Kotlin DSL (`*.gradle.kts`).
