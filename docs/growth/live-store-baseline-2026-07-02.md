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

## Next Task

Task 2 repo assets are prepared. Next required action is console upload / verification of the EN phone screenshots. Do not proceed to Task 3 launch actions until phone screenshots are final and live.
