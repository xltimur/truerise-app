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
- Current iOS status: waiting for App Review approval; the PPO test is not live until Apple approves it.

## Google Play Setup - 2026-07-02

- Package: `ua.com.truerise.app`.
- Control: current live English phone screenshot order in Play Console.
- Variant asset source: `screenshots/store/en/composited/`.
- Experiment type target: Store Listing Experiment for graphics/screenshots only.
- Do not change short description, full description, icon, feature graphic, price, countries, or category during Experiment A.

## Experiment A Readout - YYYY-MM-DD

- iOS status:
- iOS conversion delta:
- Play status:
- Play conversion delta:
- Decision: continue / apply winner / stop inconclusive.
- Notes:
