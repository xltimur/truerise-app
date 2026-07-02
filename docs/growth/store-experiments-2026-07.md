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
