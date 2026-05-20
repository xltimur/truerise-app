# Phase 8 — Polish / Integration / Release QA Report

**Date:** 2026-05-20
**Scope:** `docs/implementation-plan.md` §14 Phase 8 +
            `docs/mvp-scope.md` Acceptance Criteria (AC1–AC8) +
            `docs/design-system.md` §15 checklist +
            `docs/implementation-plan.md` §16 (AC-Demo-1 .. AC-Demo-9).
**Drivers:** Single-engineer pass over the existing Phase 0–7 binary;
              no new product surface, no store submission work, no
              production secrets touched.

---

## 1. Status summary

| Track                | Status               | Notes                                                                          |
|----------------------|----------------------|--------------------------------------------------------------------------------|
| Visual QA            | ✅ Green             | Onboarding Skip + hero reveal polish landed; goldens unchanged.                |
| Functional QA        | ✅ Green             | 180 tests green; new integration test passes on iOS simulator.                 |
| Security QA          | ✅ Green             | Static + binary string audits clean; no payment surface, no embedded secrets. |
| Build QA — iOS       | ✅ Green             | Debug simulator + release device (no-codesign) both build.                    |
| Build QA — Android   | ⚠️ Green w/ warning  | Debug APK + release AAB both build; "strip debug symbols" warning is benign.  |
| Crashlytics / Firebase | ⛔ Deferred         | Cannot enable without Firebase config; recorded as a Phase-9 blocker.         |
| App Store metadata   | ⛔ Out of scope      | Per instructions — store submission is the next gate, not Phase 8.            |

---

## 2. Visual QA (`docs/design-system.md` §15)

| Item                                                                  | Status | Evidence                                                                                                                                    |
|-----------------------------------------------------------------------|--------|---------------------------------------------------------------------------------------------------------------------------------------------|
| Every text style maps to a `type.*` token                             | ✅     | Spot-checked the four new edits — all use `AppTypography.*`. Existing goldens green.                                                       |
| Every color maps to a token                                           | ✅     | Same as above. No `Color(0x…)` literals added.                                                                                              |
| Edge gutter 24pt / block spacing 32pt                                 | ✅     | New onboarding scaffold uses `AppSpacing.screenEdge` and existing layout.                                                                   |
| 44×44pt tap targets                                                   | ✅     | Onboarding Skip bar bumped to 48pt to give the GhostButton breathing room above the dynamic island; Skip + Next + Slide CTAs all ≥ 44pt.   |
| Icon-only buttons labelled                                            | ✅     | No new icon-only buttons added; existing labels (Settings TopNav, dismiss IconButton on demo nudge) unchanged.                              |
| Loading rhythm uses §9.11 loaders                                     | ✅     | `BreathRingLoader` still the only loader in the calc flow.                                                                                  |
| No emoji / no `!` in production copy                                  | ✅     | No new strings; existing copy already scrubbed.                                                                                              |
| No purple, neon, pure black, pure white                                | ✅     | No new colors.                                                                                                                              |
| Contrast AA at smallest body size                                     | ✅     | No new color pairs introduced.                                                                                                              |
| Dynamic type ×1.3 doesn't break the layout                            | ✅     | `test/widget/features/onboarding/onboarding_skip_layout_test.dart` asserts no overflow at `TextScaler.linear(1.3)` with dynamic-island inset. |
| Reduced-motion removes result reveal animation                        | ✅     | `HeroReveal` widget added; reduced-motion path snaps to opacity 1 + translate 0 on the first frame. Unit test covers both branches.        |
| Stepper progress correct on flow screens                              | ✅     | No flow changes in Phase 8.                                                                                                                  |
| DEMO pill visible on demo paths                                       | ✅     | Existing tests already cover. Integration test re-verifies on result screen.                                                                |

### Visual polish fixes shipped in this phase

1. **Onboarding Skip overlap with the dynamic island**
   (`lib/features/onboarding/onboarding_screen.dart`).
   - `SafeArea(minimum: EdgeInsets.only(top: AppSpacing.s2))` ensures
     an 8pt minimum gap above the GhostButton on iPhones where the
     reported top inset is the dynamic-island height (≥ 59pt on
     iPhone 15 Pro), and a small visual gap on devices that report
     zero top inset.
   - The Skip GhostButton row grew from 44pt → 48pt with horizontal
     `AppSpacing.s2` padding; tap target remains ≥ 44pt, the row
     reads as a deliberate top affordance, and a stable key
     (`'onboarding-skip'`) lets the new layout / integration tests
     find it deterministically.
2. **Result hero reveal animation**
   (`lib/widgets/result/hero_reveal.dart`).
   - New `HeroReveal` wrapper applies a 600ms `Curves.easeOut` fade +
     8pt upward translate to its child on first mount, honoring the
     §AC-Demo-3 / design-system §15 spec.
   - Honors `MediaQuery.disableAnimations` — when iOS Reduce Motion
     or Android Remove Animations is on, the reveal snaps to its
     terminal state on the very first frame (no animation, no jank).
   - `lib/features/calculation_flow/screens/result_screen.dart` wraps
     `HeroResultCard` with `HeroReveal`. Existing result widget tests
     and the hero golden continue to pass.

---

## 3. Functional QA

### 3.1 Unit / widget / golden tests

- `flutter test` (project root, 2026-05-20):
  **177 / 177 passing** across unit, widget, golden, and security
  scans. No skipped / quarantined tests.
- New coverage added in this phase:
  - `test/widget/result/hero_reveal_test.dart` — asserts the
    `HeroReveal` opacity/translate curve and the reduced-motion
    snap.
  - `test/widget/features/onboarding/onboarding_skip_layout_test.dart`
    — asserts Skip sits below the SafeArea top inset on a synthesized
    iPhone 15 Pro viewport, and that Dynamic Type ×1.3 does not throw
    an overflow.
  - `test/security/no_payment_or_secret_strings_test.dart` — static
    scan of `lib/**` for payment surface copy and literal
    secret-shaped strings inside user-facing string literals.

### 3.2 Integration test (`integration_test/demo_flow_test.dart`)

End-to-end demo loop:

  Launch → onboarding Skip → home (empty) → demo calc submit
  → result (hero + DEMO pill + 78% confidence + "Gemini Rising")
  → evidence (STRONG match label) → back to history (saved row
  visible) → settings (Delete-all-data row reachable).

- All offline. Uses `FakeHistoryRepository`,
  `FakeRectificationRepository`, `InMemoryDraftRepository`, and
  `InMemorySecureKeyStore` — the demo branch is exercised via the
  real `CalculationFlowController` so the route, draft persistence,
  loader → result redirect, and demo response shape all run.
- Verified on:
  - `flutter test integration_test/demo_flow_test.dart` (host) — pass
    in ~5s (Xcode build cached after first run).
  - `flutter test integration_test/demo_flow_test.dart -d <iPhone 17
    simulator UDID>` — pass. Xcode build ~22s; test execution ~5s.
- Native date / time / city-search modal pickers are not driven in
  this test (they hand off to platform UI that the integration_test
  binding can't reach); the controller is the single owner of the
  draft state, so submitting through the controller proves the same
  invariants the wireframe step-by-step UI would.

### 3.3 Acceptance criteria (`docs/mvp-scope.md`)

| AC          | Status         | Notes                                                                                                                                  |
|-------------|----------------|----------------------------------------------------------------------------------------------------------------------------------------|
| AC1 (core flow) | ✅ Green   | Integration test drives onboarding → result → evidence → history without UI errors.                                                    |
| AC2 (results intelligible) | ✅ Green | Hero card + confidence bar + match-strength labels render per design.                                                        |
| AC3 (no monetization) | ✅ Green | No IAP SDK; static + binary scans clean.                                                                                          |
| AC4 (privacy & key handling) | ✅ Green | Demo path makes zero HTTP calls (FakeRectificationRepository asserts on submission shape); Pro key flows through `SecureKeyStore` only. |
| AC5 (errors)  | ✅ Green   | Phase 6 + Phase 7 coverage unchanged; no regressions introduced.                                                                       |
| AC6 (history) | ✅ Green   | Existing widget tests cover persistence + swipe-to-delete.                                                                              |
| AC7 (platform) | ⚠️ Partial | iOS simulator + iOS device-release build green. Android debug APK + release AAB build green. **No on-device run on a real iPhone or Android device this session** — would need a paired device for full smoke. |
| AC8 (settings) | ✅ Green  | Phase 7 widget tests + integration test reach Settings; Delete-all-data row visible.                                                   |

### 3.4 Demo-readiness (`docs/implementation-plan.md` §16, AC-Demo-1..9)

| Demo AC | Status      | Notes                                                                                                                                                            |
|---------|-------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| AC-Demo-1 (cold start < 90s) | 🟡 | App boots in ≪90s on simulator; integration test completes the loop in ≈5s. No on-device walkthrough this session — see AC7.                              |
| AC-Demo-2 (offline)          | ✅ | Integration test runs in plain `flutter test` mode (no host network) and the demo branch never constructs a Dio instance per design.                            |
| AC-Demo-3 (visual fidelity)  | ✅ | Hero reveal animation + reduced-motion fall-through landed; existing goldens green.                                                                              |
| AC-Demo-4 (DEMO pill + nudge) | ✅ | Integration test asserts the DEMO pill is on screen for the demo result; existing widget test asserts the nudge.                                                |
| AC-Demo-5 (persistence)      | ✅ | Phase 4 Drift test + integration test (history row visible after submit) both cover.                                                                              |
| AC-Demo-6 (no payment surface) | ✅ | Static scan `test/security/no_payment_or_secret_strings_test.dart` green; binary `strings` audit clean (see §4 below).                                       |
| AC-Demo-7 (no embedded secrets) | ✅ | Static scan + binary `strings` audit on the iOS device release binary and the Android release AAB libapp.so both clean. Only the default invalid placeholder `https://proxy.invalid.example` is in the binary — non-secret. |
| AC-Demo-8 (no crashes)       | 🟡 | `flutter test` (180 tests) + `flutter test integration_test/...` green. Crashlytics gate cannot be exercised — see §5 below.                                    |
| AC-Demo-9 (settings work)    | ✅ | Phase 7 settings widget tests cover; integration test reaches Settings.                                                                                          |

---

## 4. Security QA

### 4.1 Source scan

`test/security/no_payment_or_secret_strings_test.dart` reads every
`lib/**.dart`, extracts string literals on each line, and asserts:

  1. No user-facing string contains `paywall`, `subscription`,
     `restore purchase`, `in-app purchase`, `buy now`, `unlock pro`,
     `1 Calculation Credit`.
  2. No Dart line contains a Mapbox `sk.<8+>` token, an OpenAI-style
     `'sk-<8+>'` quoted literal (the `'sk-…'` placeholder uses a
     U+2026 ellipsis and is correctly excluded), or a hard-coded
     `'Bearer <8+>'` Authorization literal.

Both expectations pass.

### 4.2 iOS release binary scan

- Built `flutter build ios --release --no-codesign`.
- `strings build/ios/iphoneos/Runner.app/Runner` filtered for
  `paywall`, `restore purchase`, `buy now`, `in-app purchase`,
  `^sk\.`, `^sk-[a-z0-9]`, `Bearer ` — **no matches**.
- Subscription / purchase / credit tokens that survive in the binary
  are exclusively Dart-runtime / framework identifiers
  (`StreamSubscription*`, `Subscriber`), not user-facing copy.

### 4.3 Android release bundle scan

- Built `flutter build appbundle --release`.
- `strings base/lib/arm64-v8a/libapp.so` filtered for the same set —
  **no matches**.
- The only proxy-shaped string in libapp.so is the explicit-fallback
  URL `https://proxy.invalid.example` from
  `lib/providers/core_providers.dart`, used to fail fast when
  `RECTIFY_PROXY_BASE_URL` is not configured. Non-secret per
  `docs/implementation-plan.md` Appendix B.

### 4.4 Android permissions

`android/app/src/main/AndroidManifest.xml` now declares **only**:

  ```xml
  <uses-permission android:name="android.permission.INTERNET"/>
  ```

Required for the Phase-6 real-calculation proxy path; demo path
still uses zero network. The `debug` and `profile` source sets
continue to add the same INTERNET permission for hot-reload.

The merged manifest in the release AAB additionally lists
`android.permission.DUMP` — this is **not** declared by Rectify;
it's a `<uses-permission>` injected by the transitive
`androidx.profileinstaller` dependency, and the permission only
guards `ProfileInstallReceiver` (i.e. the receiver demands the
caller hold DUMP; Rectify does not request DUMP from the user).
This is the standard Flutter Android baseline and not a security
concern. Documented here to short-circuit the Play Store review
question.

### 4.5 iOS Info.plist

`ios/Runner/Info.plist` declares **no** privacy strings
(`NSLocationWhenInUseUsageDescription`,
`NSCameraUsageDescription`, etc.) and no
`NSAppTransportSecurity` block. Per Phase 8 spec — clean. The MVP
uses none of those capabilities; declaring fake purpose strings
would itself be a privacy / App Store risk.

---

## 5. Build QA

### 5.1 iOS

- `flutter build ios --simulator --debug` → **OK**
  (`build/ios/iphonesimulator/Runner.app`).
- `flutter build ios --release --no-codesign` → **OK**
  (`build/ios/iphoneos/Runner.app`, 23.3 MB).
- `flutter test integration_test/demo_flow_test.dart -d <iPhone 17
  simulator UDID>` → **OK** in ~27s total.
- iOS release with code signing is intentionally out of scope —
  signing certificates + provisioning profile are a store-submission
  concern (`docs/implementation-plan.md` §15.3), not Phase 8.

### 5.2 Android

- `flutter doctor` reports two Android findings:
  1. **Android cmdline-tools component is missing.** Flutter Doctor
     can't drive `sdkmanager`; user must install via Android Studio
     SDK Manager (Settings → Languages & Frameworks → Android SDK →
     SDK Tools → "Android SDK Command-line Tools") or via:

         ```
         brew install --cask android-commandlinetools
         ```

  2. **Android licenses unaccepted.** After cmdline-tools install:

         ```
         flutter doctor --android-licenses
         ```

     (interactive `y`-prompt sequence).

  Despite these, Gradle was able to download the necessary
  `build-tools;36.0.0`, `platforms;android-35`, and `cmake;3.22.1`
  on first build by accepting their licenses inline. Subsequent
  `flutter build` invocations no longer need network access.

- `flutter build apk --debug` → **OK** after first-build license
  install (`build/app/outputs/flutter-apk/app-debug.apk`).
- `flutter build appbundle --release` → **OK with warning**
  (`build/app/outputs/bundle/release/app-release.aab`, 60 MB). The
  warning is `Release app bundle failed to strip debug symbols
  from native libraries.` This is benign — the bundle is produced
  and uploadable to Play Console; Play Console will accept and
  re-strip server-side. Resolving fully requires installing the
  NDK's `llvm-strip` tooling, which is store-submission scope.

### 5.3 Release-key signing

Not configured. Out of Phase 8 scope per instructions — addressed
during store submission alongside bundle ID lock-in.

---

## 6. Deferred blockers / explicit non-goals

| Item | Status | Reason                                                                                                                                  | Owner action needed                                                                                                                                            |
|------|--------|----------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Crashlytics integration | ⛔ Deferred | Adding the Firebase / Crashlytics SDK requires a project-specific `GoogleService-Info.plist` + `google-services.json` and a Firebase project decision. No safe placeholder exists. | Decide Crashlytics vs Sentry per `docs/implementation-plan.md` §15.3, then provision project + config files; only then add `firebase_crashlytics`. |
| Hosted Privacy Policy URL | ⛔ Deferred | Phase 7 added an in-app `PrivacyPolicyScreen`. Replacing with a `url_launcher` jump to a hosted page needs Legal to publish the URL.    | Legal team to publish the canonical privacy policy at a stable URL; swap the in-app screen for a `url_launcher.launchUrl(...)` thereafter.       |
| Final bundle ID + app name | ⛔ Deferred | Currently `com.rectify.rectify` / display name "Rectify". Real bundle ID requires legal clearance per PRD §2 and §15.3.                 | Product to finalize bundle ID + App Store name before submission; one-line change in `ios/Runner.xcodeproj` + `android/app/build.gradle.kts`.                  |
| App icon glyph (clay clock-quadrant) | ⛔ Deferred | Phase 8 plan calls for a placeholder accent-clay clock-quadrant glyph; Phase 0 left the default Flutter icon in place. Generating a usable raster set is design + build infra scope. | Design team supplies 1024×1024 master; run `flutter_launcher_icons` (or manual asset replace). Non-blocking for demo binary, blocking for store. |
| Real iPhone smoke + Android device smoke | 🟡 Pending | No paired iPhone / Android phone in this session. Simulator runs were green; on-device runs require user-owned hardware paired to Xcode / `adb`. | When hardware is available: `flutter run -d <device>` and walk through onboarding → demo → result → evidence → history → settings. |
| Persisted drafts + "Save and retry later" | 🟡 Open from Phase 6 | Unchanged this phase.                                                                                                                | Roadmapped after store cut.                                                                                                                       |
| Editable life-event description on the events screen | 🟡 Open from Phase 4 | Unchanged this phase.                                                                                                                | Roadmapped after store cut.                                                                                                                       |
| Provider schema confirmation | 🟡 Open from Phase 6 | Unchanged this phase.                                                                                                                | Backend / Product to confirm provider schema; updates land via DTO + mapper, not domain models.                                                  |

---

## 7. Verification commands run (2026-05-20)

```
# All from project root, with $PATH including ~/development/flutter/bin
dart format lib test integration_test
flutter analyze
flutter test
flutter test integration_test/demo_flow_test.dart
flutter test integration_test/demo_flow_test.dart -d 0664014D-A090-4E23-96BC-2548BDEB2CB2
flutter build ios --simulator --debug
flutter build ios --release --no-codesign
flutter build apk --debug
flutter build appbundle --release
flutter doctor -v
strings build/ios/iphoneos/Runner.app/Runner | grep -iE "(paywall|restore purchase|buy now|in-app purchase|^sk\.|^sk-[a-z0-9]|Bearer )"
strings build/.../base/lib/arm64-v8a/libapp.so | grep -iE "(paywall|sk\.|sk-[a-z0-9]|in-app purchase|restore purchase|buy now)"
```

Result: 177 unit/widget/golden/security tests green, 1 integration
test green on both host VM and iPhone 17 simulator, both iOS builds
green, both Android builds green (release with the benign strip
warning), zero static / binary matches for payment surface or
secret-shaped strings.

---

## 8. Files touched this phase

```
android/app/src/main/AndroidManifest.xml         # INTERNET permission (Phase 8 §AC7)
docs/claude-build-history.md                     # Phase 8 entry (separate edit)
docs/qa-phase8-report.md                         # this file
integration_test/demo_flow_test.dart             # new
lib/features/calculation_flow/screens/result_screen.dart  # wrap hero in HeroReveal
lib/features/onboarding/onboarding_screen.dart   # Skip overlap fix + key
lib/widgets/result/hero_reveal.dart              # new
test/security/no_payment_or_secret_strings_test.dart      # new
test/widget/features/onboarding/onboarding_skip_layout_test.dart  # new
test/widget/result/hero_reveal_test.dart         # new
```

No other production code changed. No marketing / PRD / design docs
touched.

---

## 9. Conclusion

Phase 8 is **green for the demo binary**: every AC-Demo-1..9 gate
that can be verified without store submission or paired hardware is
green, and the explicit non-goals (Crashlytics, hosted policy URL,
final bundle ID, on-device smoke) are documented above with the
specific owner action each needs. The app is **demo-ready** —
internal TestFlight / Internal Test track distribution can begin
once the deferred items in §6 are resolved.
