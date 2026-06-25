# Release Automation Options

**Status:** release path clarified 2026-06-23.
**App identity:** `ua.com.truerise.app`.
**Primary domain:** `https://truerise.com.ua`.

**Current Apple state (2026-06-23):** App ID and App Store Connect app record
exist, distribution signing/profile are installed locally, and
`flutter build ipa --release --export-options-plist ios/ExportOptions.plist`
successfully produced `build/ios/ipa/rectify.ipa`. Upload is blocked only on
App Store Connect upload authentication/API access.

## Current repo type

This repository is a Flutter app. There is no Expo app config (`app.json` /
`app.config.*`) and no EAS config (`eas.json`) in the project. Use the
Flutter-native release path as the primary path.

## Primary path: Flutter-native builds

### iOS

1. MYKYTA / the Account Holder accepts the latest Apple Developer Program
   License Agreement by 2026-07-07.
2. Use the existing App Store Connect record:
   - App name: `TrueRise`
   - Apple ID: `6783427864`
   - Bundle ID: `ua.com.truerise.app`
   - SKU: `ua.com.truerise.app`
3. Use the existing local signing setup:
   - Team ID: `T29RJZB64F`
   - Certificate: `DB3Y7P32VL`
   - Provisioning profile: `TrueRise App Store 2026`
   - Export options: `ios/ExportOptions.plist`
4. Run:

```bash
dart run tool/ios_release_preflight.dart \
  --privacy-policy-url=https://truerise.com.ua/privacy.html \
  --share-url=https://truerise.com.ua
flutter build ipa --release --export-options-plist ios/ExportOptions.plist
```

The current built IPA is `build/ios/ipa/rectify.ipa`.

Upload the IPA through Xcode Organizer, Transporter, or another Apple-supported
upload flow. `altool` is available locally; Transporter.app is not installed.
API upload command shape:

```bash
xcrun altool --upload-app --type ios \
  -f build/ios/ipa/rectify.ipa \
  --apiKey <KEY_ID> \
  --apiIssuer <ISSUER_ID>
```

Current blocker: App Store Connect API access is disabled for the current role.
The API page says only the Account Holder can request access, and the request
button is disabled. Owner must provide `.p8` + Key ID + Issuer ID, or sign in
through Xcode/Transporter with credentials that can upload builds. A direct
Xcode upload attempt using `destination=upload` also failed at the account step:
Xcode found the signed archive, but reported that App Store Connect access for
team `T29RJZB64F` is required in Xcode Accounts settings.

### Android

1. Create the Google Play app with package `ua.com.truerise.app`.
2. Enroll Play App Signing and generate the upload keystore.
3. Fill git-ignored `android/key.properties` from
   `android/key.properties.example`.
4. Run the release guard/build:

```bash
flutter build appbundle --release \
  --dart-define=RECTIFY_ENV=prod \
  --dart-define=TRUERISE_SHARE_URL=https://truerise.com.ua \
  --dart-define=TRUERISE_PRIVACY_POLICY_URL=https://truerise.com.ua/privacy.html
```

Add the required `RECTIFY_*` provider/proxy defines per `README.md`.

## Optional path: EAS / Expo automation

Slack mentioned an Expo org invite and API-key based automation. Treat that as
optional infrastructure, not the current primary path. This Flutter repo cannot
be submitted by EAS until someone deliberately adds and verifies the required
Expo/EAS configuration.

Do not spend release-critical time on EAS unless the owner explicitly decides to
standardize this Flutter app around that automation path.

## Owner/API access checklist

Apple owner-only or Account Holder/Admin tasks:

- Accept Apple Developer Program License Agreement.
- Request/enable App Store Connect API access and create an API key if
  automation is required; provide `.p8`, Key ID, and Issuer ID through a secure
  channel.
- Alternative: sign into Xcode/Transporter and upload the existing IPA manually.

Google Play owner tasks:

- Create Play Console app for `ua.com.truerise.app`.
- Create service-account JSON only if API submission automation is required.
- Add release manager/store presence permissions for the publishing operator.

Expo optional tasks:

- Keep the Expo org/admin invite only if the team wants to evaluate EAS.
- Add `eas.json`/Expo config in a separate implementation task before relying
  on Expo automation.

## References

- Apple: add a new app record:
  <https://developer.apple.com/help/app-store-connect/create-an-app-record/add-a-new-app/>
- Apple: App Store Connect API:
  <https://developer.apple.com/help/app-store-connect/get-started/app-store-connect-api/>
- Apple: role permissions:
  <https://developer.apple.com/help/app-store-connect/reference/account-management/role-permissions/>
- Apple: upload builds:
  <https://developer.apple.com/help/app-store-connect/manage-builds/upload-builds/>
- Flutter: iOS deployment:
  <https://docs.flutter.dev/deployment/ios>
- Expo EAS Build:
  <https://docs.expo.dev/build/introduction/>
- Expo EAS Submit:
  <https://docs.expo.dev/submit/introduction/>
- Expo EAS Update:
  <https://docs.expo.dev/eas-update/introduction/>
