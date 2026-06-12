# Bundle ID / Package Namespace - Recommendation for Owner Decision

**Status:** OWNER DECISION REQUIRED - no identifiers changed yet.
**Date:** 2026-06-12
**Resolves:** P0-3 in `docs/publication-readiness-current-status.md` /
`docs/store-submission-readiness.md` Sec. 12.
**Scope of this doc:** recommendation only. Android `applicationId`/`namespace`
and the iOS bundle ID remain `com.rectify.rectify` until the owner confirms.

## Current state

| Surface | Value | File |
| --- | --- | --- |
| Android `applicationId` + `namespace` | `com.rectify.rectify` | `android/app/build.gradle.kts` |
| Android activity package | `com.rectify.rectify` | `android/app/src/main/kotlin/com/rectify/rectify/MainActivity.kt` |
| iOS app bundle ID | `com.rectify.rectify` | `ios/Runner.xcodeproj/project.pbxproj` (`PRODUCT_BUNDLE_IDENTIFIER`, plus `...RunnerTests` x 3 configs) |
| Public product name | TrueRise (unchanged by this decision) | store listings, `CFBundleDisplayName`, `android:label` |

Oleg proposed the `app.astrolium.*` namespace in Slack and is open to
alternatives.

## Recommendation

**Primary: `app.astrolium.truerise`**

**Fallbacks:**

1. `com.astrolium.truerise` - same structure, classic `com.` root; prefer this
   if the company controls `astrolium.com` but not `astrolium.app`.
2. `com.truerise.app` - brand-first namespace; only if the owner wants TrueRise
   to stand alone from any publisher umbrella **and** controls a matching
   TrueRise domain.

## Why

- **Decide before first store setup.** On Apple, the bundle ID becomes locked
  once builds or the App Store Connect app record depend on it. On Google
  Play, the `applicationId` / package name is effectively permanent for the
  listing once it is created and a build is uploaded or published, and it is
  visible in the public Play Store URL (e.g.
  `play.google.com/store/apps/details?id=app.astrolium.truerise`). Changing
  it later is not a normal rename - in practice it means a new app record and
  losing continuity - so the decision must land before any store record is
  created or a first artifact is uploaded.
- **Umbrella (publisher) namespace over product namespace.** Product names
  change more often than companies. `app.astrolium.<product>` scales cleanly
  to future apps under the same developer accounts and keeps one consistent
  publisher identity; a TrueRise rename later would not strand the ID in a
  foreign namespace.
- **Why `app.astrolium.truerise` is acceptable.** It is well-formed reverse-DNS
  for `astrolium.app`; all three segments are valid Java/Kotlin package
  identifiers (no hyphens, no leading digits, no reserved words), so it works
  unmodified as the Android `namespace` too; and it encodes
  publisher (`astrolium`) + product (`truerise`) the conventional way.
- **Why not keep `com.rectify.rectify` for public launch.** It is an internal
  codename, not a brand or a controlled domain: it would persist in the
  public Play URL, share/referral links, OAuth and deep-link configurations,
  and crash/support tooling, under a name nobody owns or markets. Technically
  it would work - keep it **only** if the owner deliberately chooses the
  legacy/codename route with that trade-off understood. (Inside the repo,
  `rectify` stays the codename/project name either way; that is independent
  of the shipped ID.)

## Owner must confirm before implementation

1. The publisher umbrella is **Astrolium** and the company controls (or will
   register) `astrolium.app` - or `astrolium.com`, which selects fallback 1.
2. The developer-account names (Apple Developer org / D-U-N-S, Google Play
   developer account) will be consistent with that publisher identity.
3. TrueRise name/trademark availability - needs owner/legal and store
   name-availability confirmation; not assessed here.
4. No App Store Connect record or Play listing has been created with
   `com.rectify.rectify` (none known as of this doc).
5. Final spelling, exactly, in writing - treat the ID as final once store
   setup begins; fixing it afterwards is not a normal rename.

## Implementation checklist (later - NOT in this step)

- [ ] Android: `applicationId` + `namespace` in `android/app/build.gradle.kts`.
- [ ] Android: move `MainActivity.kt` to the matching package path and update
      its `package` declaration; confirm `AndroidManifest.xml` needs no change.
- [ ] iOS: `PRODUCT_BUNDLE_IDENTIFIER` for Runner (3 configs) and RunnerTests
      (3 configs) in `project.pbxproj`.
- [ ] Re-create signing: iOS App ID + provisioning profiles; Android release
      keystore/Play App Signing tied to the new `applicationId`.
- [ ] Sweep configs that embed the ID when they appear: deep links / app
      links, share/store URLs (`TRUERISE_*` release config), Firebase/Sentry
      if added.
- [ ] Update docs: P0-3 rows in `publication-readiness-current-status.md` and
      `store-submission-readiness.md`, `aso-naming-strategy.md` identifier
      table.
- [ ] Verify: `flutter build` per platform, install + launch on device,
      `flutter test`, and grep for stale `com.rectify.rectify` references.
