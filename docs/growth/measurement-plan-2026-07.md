# TrueRise Measurement Plan - July 2026

## North Star

Real Rectifications Completed per Week.

## Store Metrics

- App Store product page views.
- App Store first-time downloads.
- App Store product page conversion.
- Google Play store listing visitors.
- Google Play first-time installers.
- Google Play store listing conversion.
- Ratings count.
- Average rating.
- Review themes.

## In-App Privacy Boundary

Allowed event names:
- app_open
- demo_started
- demo_completed
- live_started
- live_completed
- evidence_opened
- result_shared_text
- result_shared_image
- review_prompt_shown
- review_prompt_confirmed

Allowed event properties:
- app_version
- platform
- locale
- event_name
- timestamp_day

Forbidden event properties:
- birth date
- birthplace
- coordinates
- life-event category
- life-event text
- result time
- rising sign
- confidence
- calculation id
- API key
- contact
- destination app

## Measurement Mode Decision - 2026-07-02

Mode A: Store-console only for the first 14 days.

Reason:
- The immediate questions are product-page conversion, first download flow, ratings count, and review themes.
- The app currently promises no analytics SDK, tracking, ads, or accounts.
- Remote analytics should not be added until the privacy policy, App Store privacy labels, and Play Data Safety form are updated first.

## Mode A Weekly Report

Each Monday add:

```markdown
## Weekly Readout - YYYY-MM-DD

- App Store page views:
- App Store downloads:
- App Store conversion:
- Google Play visitors:
- Google Play installers:
- Google Play conversion:
- Ratings count:
- Reviews received:
- Top issue:
- Decision for next week:
```

## Experiment Measurement Checkpoints

- 2026-07-09: first Google Play Experiment A readout target, provided the experiment remains active from 2026-07-02 and has enough traffic for a useful signal.
- App Store PPO readout: start a separate 7-day window only after Apple approves the submitted Product Page Optimization test.
- Do not mix screenshot testing with localization, custom listings, paid traffic, or metadata refreshes during the first readout window.

## Mode B Gate

Before adding privacy-safe remote analytics:

- Create a separate implementation plan.
- Update `docs/privacy-policy.md`.
- Update `docs/apple-privacy-labels.md`.
- Update `docs/play-data-safety.md`.
- Add tests proving forbidden fields cannot be recorded.
- Record event names and coarse day timestamp only.
- Keep delete-all-data behavior accurate.
