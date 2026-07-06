# TrueRise Experiment Readout Runbook - July 2026

## Scope

Experiment: `2026-07 First Screenshot Hook`.

Hypothesis: the problem-first screenshot order improves product-page conversion versus the current result-first screenshot order.

Platforms:
- Google Play Store Listing Experiment, package `ua.com.truerise.app`, app ID `4972620156606459622`.
- App Store Product Page Optimization, Apple ID `6783427864`.

## Guardrail Before Readout

Do not change any of these before the readout is recorded:

- Default screenshots.
- App Store or Play title / subtitle / short description / full description.
- Localizations.
- Custom Product Pages or Custom Store Listings.
- Site links to custom destinations.
- Creator outreach traffic.
- Paid traffic.
- Price, availability, category, or age / privacy settings.

Reason: each item can change traffic quality or product-page conversion and would make the first screenshot test hard to interpret.

## Dates

- 2026-07-09: first Google Play readout target, counted from the observed 2026-07-02 start.
- 2026-07-10: first App Store PPO readout target, counted from the observed 2026-07-03 start.

If a console shows too little traffic or no result, keep the experiment running and record the reason instead of forcing a decision.

## Google Play Readout Steps

1. Open Play Console in the correct account:
   `https://play.google.com/console/u/2/developers/7111618563241559003/app/4972620156606459622/store-listing-experiments/overview`
2. Verify the app identity:
   - Developer: `Red Rocket Software`.
   - App: `TrueRise: Birth Time Finder`.
   - Package: `ua.com.truerise.app`.
3. Open experiment `2026-07 First Screenshot Hook`.
4. Record:
   - Experiment status.
   - Start date.
   - Control visitors.
   - Variant visitors.
   - Control first-time installers.
   - Variant first-time installers.
   - Control conversion rate.
   - Variant conversion rate.
   - Conversion delta / lift.
   - Confidence or Play Console recommendation.
   - Any country, language, or traffic-source caveat shown by Play Console.
5. Capture a screenshot or exact text summary for the evidence log.

## App Store PPO Readout Steps

1. Open App Store Connect:
   `https://appstoreconnect.apple.com/apps/6783427864/distribution/optimization`
2. Verify the app identity:
   - App: `TrueRise: Birth Time Finder`.
   - Apple ID: `6783427864`.
3. Open PPO `2026-07 First Screenshot Hook`.
4. Record:
   - Test status.
   - Start date.
   - Control impressions / page views shown by App Store Connect.
   - Treatment impressions / page views shown by App Store Connect.
   - Control first-time downloads.
   - Treatment first-time downloads.
   - Control conversion rate.
   - Treatment conversion rate.
   - Conversion delta / lift.
   - Confidence or App Store Connect result label.
   - Any territory, device, or source caveat shown by App Store Connect.
5. Capture a screenshot or exact text summary for the evidence log.

## Decision Rules

Apply the problem-first screenshots only when all are true:

- The console shows a positive conversion lift for the treatment.
- Confidence is at least 90%, or the console clearly marks the treatment as the winner.
- There is no obvious segment caveat that makes the result misleading.
- The readout has enough traffic to be useful, ideally at least 1,000 impressions or page views per side. If traffic is much lower, treat the result as directional only.

Continue the experiment when:

- Treatment is positive, but confidence or sample size is still weak.
- Results differ by store and neither store has a strong enough signal.
- The console says the experiment is still collecting data.

Stop or keep the control when:

- Treatment is negative with meaningful traffic.
- The console marks the treatment as worse.
- Screenshots caused a policy, quality, or message-risk issue.

Mark inconclusive when:

- Traffic is too low.
- Conversion lift is near zero.
- The stores disagree and neither result is statistically convincing.
- External changes polluted the measurement window.

## Post-Decision Actions

If Google Play treatment wins:

- Apply the winning screenshot order in Play Console only after recording the readout.
- Record the publication date and whether Play requires review.
- Then allow Play localization work to resume.

If App Store treatment wins:

- First check whether App Store Connect offers an `Apply Treatment` action.
- If available, apply only after recording the readout and any Apple review requirement.
- If unavailable because the live `1.0.3` deliverable is read-only, carry the winning screenshot order into the next editable version draft.

If treatment loses or is inconclusive:

- Keep current default screenshots.
- Do not publish problem-first screenshots as default.
- Prepare a second screenshot hypothesis only after the first experiment is closed or explicitly continued.

## Follow-On Order After Readout

1. Record readout in `docs/growth/store-experiments-2026-07.md`.
2. Update `docs/growth/measurement-plan-2026-07.md` with the weekly numbers.
3. Decide winner / continue / stop.
4. If the experiment is closed or safely decided, resume Tier-1 localization publication planning.
5. Create Apple Custom Product Pages and Google Play Custom Store Listings only after the screenshot decision is recorded.
6. Verify custom URLs before updating site links.
7. Start creator outreach only after destination URLs are verified.
8. Keep paid traffic blocked until experiment readout, budget / stop-loss, and monetization or explicit learning-test approval are all recorded.

## Readout Template

```markdown
## Experiment A Readout - YYYY-MM-DD

### Google Play

- Status:
- Start date:
- Control visitors:
- Variant visitors:
- Control first-time installers:
- Variant first-time installers:
- Control conversion:
- Variant conversion:
- Lift / delta:
- Confidence / recommendation:
- Evidence:
- Decision:

### App Store PPO

- Status:
- Start date:
- Control impressions / page views:
- Treatment impressions / page views:
- Control first-time downloads:
- Treatment first-time downloads:
- Control conversion:
- Treatment conversion:
- Lift / delta:
- Confidence / result label:
- Evidence:
- Decision:

### Combined Decision

- Decision: apply winner / continue / keep control / inconclusive.
- Reason:
- Next action:
- Changes intentionally not made:
```
