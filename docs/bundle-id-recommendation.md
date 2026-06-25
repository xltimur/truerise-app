# Bundle ID / Package Namespace - Final Decision

**Status:** IMPLEMENTED LOCALLY - final first-publish ID is `ua.com.truerise.app`.
**Date:** 2026-06-23
**Resolves:** P0-3 in `docs/publication-readiness-current-status.md` /
`docs/store-submission-readiness.md` Sec. 12.

## Final decision

The shipped application identity is:

| Surface | Value | File |
| --- | --- | --- |
| Android `applicationId` + `namespace` | `ua.com.truerise.app` | `android/app/build.gradle.kts` |
| Android activity package | `ua.com.truerise.app` | `android/app/src/main/kotlin/ua/com/truerise/app/MainActivity.kt` |
| iOS app bundle ID | `ua.com.truerise.app` | `ios/Runner.xcodeproj/project.pbxproj` (`PRODUCT_BUNDLE_IDENTIFIER`, plus `ua.com.truerise.app.RunnerTests`) |
| Public product name | TrueRise | store listings, `CFBundleDisplayName`, `android:label` |

## Why this spelling

The owner purchased `truerise.com.ua` as the primary public domain. Reverse-DNS
from that domain is `ua.com.truerise`; the app-specific suffix makes the final
ID `ua.com.truerise.app`.

This is different from `truerise.app.ua.com`. That spelling would imply a
namespace under `ua.com`, which is not the purchased primary domain.

## What changed

- Android `namespace` and `applicationId` were migrated from
  `com.rectify.rectify` to `ua.com.truerise.app`.
- Android `MainActivity.kt` moved to the matching Kotlin package path.
- iOS Runner bundle IDs were migrated to `ua.com.truerise.app`; RunnerTests use
  `ua.com.truerise.app.RunnerTests`.
- `tool/ios_release_preflight.dart` now blocks legacy `com.rectify.rectify` and
  any non-final Runner ID.
- `test/tool/release_identity_test.dart` guards the active Android/iOS configs
  against accidental reversion.

## Historical alternatives

Earlier planning discussed `app.astrolium.truerise`,
`com.astrolium.truerise`, and `com.truerise.app`. Those are now historical
references only. Do not use them for the first store records.

## Remaining owner/store work

- Apple: after the Apple Developer Program License Agreement is accepted, create
  the App Store Connect app record with Bundle ID `ua.com.truerise.app`.
- Apple: create distribution signing/provisioning for `ua.com.truerise.app` and
  fill `ios/ExportOptions.plist` from the tracked example.
- Google Play: create the app/listing and first AAB under package
  `ua.com.truerise.app`.
- Do not create App Store Connect / Play Console records using
  `com.rectify.rectify`; changing store identity after first upload is not a
  normal rename.
