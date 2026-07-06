# TrueRise Store Experiments - July 2026

## Experiment A - First Screenshot Hook

Hypothesis: a problem-first screenshot improves product-page conversion versus a result-first screenshot for users who do not already know birth-time rectification.

Platforms:
- iOS: Product Page Optimization.
- Google Play: Store Listing Experiment.

Control:
- First screenshot: result hero.

Variant:
- First screenshot: "Don't know your exact birth time?"

Success metric:
- Store product-page conversion rate: product page views to first-time downloads.

Readout procedure:
- Use `docs/growth/experiment-readout-runbook-2026-07.md` for the 2026-07-09 Google Play readout and 2026-07-10 App Store PPO readout.

Guardrails:
- Do not change title, subtitle, short description, icon, or price during this experiment.
- Do not run paid traffic changes during this experiment.
- Run for at least 7 days or until the console reports a clear result.

## iOS Setup - 2026-07-02

- App Store Connect app: `TrueRise: Birth Time Finder`, Apple ID `6783427864`.
- Live version: `1.0.3`, status `Ready for Distribution`.
- Control screenshot order observed in App Store Connect: result hero, evidence breakdown, privacy/demo settings, share result, privacy policy.
- Treatment asset source: `screenshots/store/en/composited/`.
- Treatment name target: `2026-07 First Screenshot Hook`.
- Traffic split target: 50% treatment if App Store Connect allows this value for the current traffic level.
- Current limitation: the default App Store screenshot set is read-only on the already-live `1.0.3` version; PPO is the immediate compliant route for screenshot testing. Replacing the default page requires a future editable app version.

### iOS Console Progress - 2026-07-02

- Product Page Optimization test created in App Store Connect.
- Test name: `2026-07 First Screenshot Hook`.
- Test URL: `https://appstoreconnect.apple.com/apps/6783427864/distribution/optimization/0b611a4a-d75f-4666-af71-d3b7275ea2d4`.
- Treatment A ID in URL: `f3afd437-eccf-495a-a671-1b258efcc38a`.
- Treatment count: 1.
- Traffic split selected: 50%.
- Treatment A inherited screenshots were removed from the iPhone 6.9"/6.5" source slot before upload.
- Upload-ready temporary copies were generated at `1284 x 2778` under `/tmp/truerise-asc-upload/` from the committed EN composites.
- Chrome upload path used the native macOS file picker because Codex in-app browser automation returned `File uploads are not supported by Codex In-app Browser`.
- Treatment A iPhone 6.5" screenshots uploaded and verified in this order: `01-problem-hook.png`, `02-life-events.png`, `01-result-hero.png`, `02-evidence-breakdown.png`, `03-privacy-demo-settings.png`.
- App Store Connect required App Review before the PPO can run. The PPO item was added to review and submitted on 2026-07-02.
- Submission confirmation: `Submitted items: 1`; App Store Connect says review can take up to 48 hours.
- Review submission URL: `https://appstoreconnect.apple.com/apps/6783427864/distribution/reviewsubmissions/details/c2c57739-372f-4e98-9200-9a6d2dc33b2d`.
- Current iOS status after 2026-07-03 recheck: App Review is complete and the PPO is approved.
- Review submission detail confirmed in App Store Connect on 2026-07-03: `Проверка завершена`, object status `Одобрено`, submission ID `c2c57739-372f-4e98-9200-9a6d2dc33b2d`.
- App Store optimization page confirmed on 2026-07-03: `2026-07 First Screenshot Hook` is `В процессе (1 день)`, date range `3 июля 2026 г. - настоящее время`.
- First iOS PPO readout target: 2026-07-10, counting from the observed 2026-07-03 test start, provided App Store Connect has enough traffic for a useful signal.

## Google Play Setup - 2026-07-02

- Developer account verified in Play Console: `Red Rocket Software`, account ID `7111618563241559003`, signed in as `borodchenko@gmail.com`.
- App verified in Play Console: `TrueRise: Birth Time Finder`, Play app ID `4972620156606459622`, package `ua.com.truerise.app`.
- Experiment name: `2026-07 First Screenshot Hook`.
- Store listing: `Стандартная страница приложения`.
- Experiment type: `Эксперимент с графическими объектами по умолчанию`.
- Target metric: `Пользователи, впервые установившие приложение`.
- Variant count: 1.
- Audience split: 50%.
- Minimum detectable effect: 6%.
- Confidence level: 90%.
- Tested attribute: screenshots only.
- Variant name: `Problem-first screenshots`.
- Control: current live English phone screenshot order in Play Console.
- Variant source composites: `screenshots/store/en/composited/`.
- Google Play upload-ready assets: `screenshots/store/en/google-play-phone/`, generated at `1080 x 1920` with side padding because Google Play requires phone screenshots within a 9:16 or 16:9 aspect ratio.
- Uploaded variant screenshot order:
  1. `01-problem-hook.png`
  2. `02-life-events.png`
  3. `01-result-hero.png`
  4. `02-evidence-breakdown.png`
  5. `03-privacy-demo-settings.png`
- Play Console variant status after upload: `Готово · Скриншоты`.
- Publishing overview status after saving: one change pending under `Изменения, ещё не отправленные на проверку`.
- Pending change shown by Play Console: `Запуск эксперимента (2026-07 First Screenshot Hook)`.
- Submitted to Google review on 2026-07-02 after the Play Console confirmation dialog `Отправить 1 изменение на проверку?`.
- Follow-up Play Console check: `Обзор публикации` showed no unpublished changes, `Последняя публикация: 2 июля 2026 г.`, and Store Listing Experiments listed `2026-07 First Screenshot Hook` under `Не завершено`.
- Current Play experiment status: launched/running from 2026-07-02, 1 variant, 50% users.
- Do not change short description, full description, icon, feature graphic, price, countries, or category during Experiment A.

## Experiment A Readout - YYYY-MM-DD

- iOS status:
- iOS conversion delta:
- Play status:
- Play conversion delta:
- Decision: continue / apply winner / stop inconclusive.
- Notes:

For the full metric capture template, use `docs/growth/experiment-readout-runbook-2026-07.md`.

## Continuation Status - 2026-07-03

- Google Play experiment action: keep running without listing, metadata, icon, category, price, or localization changes until the first 7-day readout.
- First Play readout target: 2026-07-09, counting from the observed 2026-07-02 experiment start.
- App Store PPO action: keep the approved PPO running without default listing, screenshot, metadata, localization, or competing PPO/CPP changes until the first 7-day readout.
- First App Store PPO readout target: 2026-07-10, counting from the observed 2026-07-03 PPO start.
- Localizations, custom listings, outreach URLs, and paid acquisition remain downstream of this experiment so the screenshot test has a clean signal.

## Continuation Status - 2026-07-06

- Public App Store and Google Play versions were rechecked and both still report marketing version `1.0.3`.
- Local `site/version.json` and live `https://truerise.com.ua/version.json` both advertise `latestVersion` `1.0.3+4`, so the update endpoint is aligned with the public store builds.
- No experiment readout should be recorded yet: Google Play has not reached the planned 2026-07-09 first checkpoint, and App Store PPO has not reached the planned 2026-07-10 first checkpoint.
- Current action: keep both tests running and preserve a clean measurement window. Do not publish localization, custom listings, metadata refreshes, default screenshot changes, creator traffic, or paid traffic before the first readouts unless the owner explicitly accepts contaminated experiment data.
