# TrueRise Live Store Baseline - 2026-07-02

## Verified Public State

- App Store: TrueRise: Birth Time Finder, seller Mykosa OU, Lifestyle, version 1.0.3, released 2026-07-01T04:35:40Z, rating count 0, languages EN.
- Google Play: TrueRise: Birth Time Finder, Lifestyle, package ua.com.truerise.app, version 1.0.3, updated Jun 30, 2026, content rating Everyone.

## Evidence Commands

```bash
curl -s --max-time 20 'https://itunes.apple.com/lookup?id=6783427864&country=us' \
  | jq '.results[0] | {
      trackName,
      sellerName,
      primaryGenreName,
      version,
      currentVersionReleaseDate,
      userRatingCount,
      languageCodesISO2A,
      screenshotUrls,
      ipadScreenshotUrls,
      trackViewUrl
    }'
```

Result summary:
- `trackName`: `TrueRise: Birth Time Finder`
- `sellerName`: `Mykosa OU`
- `primaryGenreName`: `Lifestyle`
- `version`: `1.0.3`
- `currentVersionReleaseDate`: `2026-07-01T04:35:40Z`
- `userRatingCount`: `0`
- `languageCodesISO2A`: `["EN"]`
- `screenshotUrls`: `[]`
- `ipadScreenshotUrls`: five populated screenshot URLs
- `trackViewUrl`: `https://apps.apple.com/us/app/truerise-birth-time-finder/id6783427864?uo=4`

```bash
curl -L -A 'Mozilla/5.0' --max-time 20 -s \
  'https://play.google.com/store/apps/details?id=ua.com.truerise.app&hl=en_US&gl=US' \
  | perl -0777 -ne '
    print "title=TrueRise: Birth Time Finder\n" if /TrueRise: Birth Time Finder - Apps on Google Play/;
    print "category=Lifestyle\n" if /\[\[\"Lifestyle\"/;
    print "version=1.0.3\n" if /\[\[\[\"1\.0\.3\"\]\]/;
    print "updated=Jun 30, 2026\n" if /\[\"Jun 30, 2026\"/;
    print "rating=Everyone\n" if /\[\"Everyone\"/;
  '
```

Result:

```text
title=TrueRise: Birth Time Finder
category=Lifestyle
version=1.0.3
updated=Jun 30, 2026
rating=Everyone
```

## Immediate Risks

- App Store iPhone screenshot slot status: OPEN - public Lookup returns an empty `screenshotUrls` array while `ipadScreenshotUrls` has five assets. App Store Connect must be checked directly, and iPhone screenshots should be uploaded before store-page experiments or promotion.
- First ratings: 0 public ratings on App Store.
- Localization: live public App Store language is EN only.

## Console Follow-Up

- App Store Connect: verify iPhone 6.7" screenshots are populated for Apple ID `6783427864`; if empty, upload `screenshots/store/en/composited/` in manifest order before Product Page Optimization or external promotion.
- Google Play Console: upload or verify the same EN phone screenshot order from `screenshots/store/en/composited/` before starting Store Listing Experiments.

## 2026-07-02 Local Screenshot Update

- EN raw story is ready in `screenshots/store/en/manifest.json`: problem hook, life events, result hero, evidence, privacy/offline demo.
- EN final composites are generated under `screenshots/store/en/composited/` at `1290 x 2796`.
- Visual QA checked readable captions, no UI overlap in caption band, demo/sample data only, and no guaranteed-accuracy claims.
- Console upload and public propagation are still pending account-side actions; do not start Product Page Optimization, Store Listing Experiments, paid traffic, or creator outreach until phone screenshots are live.

## 2026-07-02 App Store Connect Check

- App Store Connect is authenticated for Mykosa OU and opened the correct app: `TrueRise: Birth Time Finder`, Apple ID `6783427864`.
- iPhone screenshot slots are not empty. The current `1.0.3` page shows the older result-first screenshot set: `01-result-hero.png`, `02-evidence-breakdown.png`, `03-privacy-demo-settings.png`, `04-share-result.png`, `05-privacy-policy.png`.
- The live app version is `Ready for Distribution`, so default App Store screenshots are read-only on this version. The compliant path for immediate screenshot learning is App Store Product Page Optimization; replacing the default screenshots requires a future editable app version.
- Follow-up App Store Connect check for localization: the same `1.0.3` deliverable keeps metadata, screenshots, and the language selector disabled. Tier-1 localizations and next-release copy cannot be entered on this live deliverable; create/use an editable version draft for default-page localization.
- Follow-up Play Console access check: direct navigation to developer account `7111618563241559003`, app `4972620156606459622`, package `ua.com.truerise.app`, redirects the current in-app browser session to `play.google.com/console/u/0/signup`. Play follow-up actions require switching the browser to the existing Red Rocket developer account, not creating a new account.

## Next Task

Task 2 repo assets are prepared and App Store screenshot slots are populated, but the current live default screenshots cannot be replaced on version `1.0.3`. Proceed to Task 3 through Product Page Optimization with the current result-first page as control and the problem-first screenshot set as treatment.

## 2026-07-03 Public Store Recheck

- App Store Lookup still reports `TrueRise: Birth Time Finder`, version `1.0.3`, release date `2026-07-01T04:35:40Z`, rating count `0`, language `EN`, empty iPhone `screenshotUrls`, and five `ipadScreenshotUrls`.
- Google Play public page still reports title `TrueRise: Birth Time Finder`, category `Lifestyle`, version `1.0.3`, update date `Jun 30, 2026`, and content rating `Everyone`.
- No public default-store metadata change was made during the first screenshot experiment window.
