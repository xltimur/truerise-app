# TrueRise First Review Runbook

## Goal

Collect honest first reviews without incentives, gating, star requests, or manipulation.

## Current Implementation Check

- `ReviewPromptController` uses the native OS-owned review flow through `ReviewService.requestReview`.
- The app does not request a star count, offer rewards, branch on rating sentiment, or unlock features for reviews.
- The default cooldown is 120 days.
- Verification on 2026-07-02: `flutter test test/unit/reviews/review_prompt_controller_test.dart test/unit/reviews/review_strings_compliance_test.dart` passed.
- Re-verification on 2026-07-03: the same focused review tests passed, 9 tests total.

## Allowed Review Moments

- After a user completes a demo result and opens evidence.
- After a user completes a live result and opens evidence.
- After a user shares a result.

## Disallowed Review Moments

- Cold app launch.
- Before result screen.
- After an error.
- In exchange for extra attempts, discounts, keys, support, or features.
- With any mention of "5 stars".

## Manual Outreach Text

Thanks for trying TrueRise. If the result and evidence were useful, an honest App Store or Google Play review helps us understand whether this should be improved further. No pressure - feedback is useful either way.

## Review Response Rules

- Thank the user.
- Address the issue they named.
- Do not ask for a higher rating.
- Link only to support when it helps solve the issue.
- Never debate astrology belief or certainty; repeat that TrueRise provides estimates with evidence.

## Response Templates

### Positive review

Thank you for trying TrueRise. We built it to make uncertain birth times easier to work with while keeping the result honest and evidence-based.

### Accuracy concern

Thanks for the feedback. TrueRise estimates the most likely time from the events entered; it is not a guaranteed answer. Adding more dated events can change the confidence and candidate ranking.

### Privacy concern

Thanks for raising this. Demo mode runs offline. Live calculations send only the details needed to compute the result over HTTPS, and the app has no accounts, ads, analytics SDK, or tracking.

### Bug report

Thanks for reporting this. Please email support@truerise.com.ua with the device model, app version, and the screen where it happened so we can reproduce it.
