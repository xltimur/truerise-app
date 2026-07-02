# TrueRise Localization Rollout - July 2026

## Locales

- de
- fr
- es
- pt-BR

## Gates Per Locale

- Native or near-native review completed.
- Name/subtitle/keyword fields recounted in App Store Connect.
- Play title and short description recounted in Play Console.
- Screenshot captions reviewed.
- Store privacy / age / support fields unchanged and valid.
- No deterministic or medical/legal/financial claims introduced.

## Publication Order

1. de
2. fr
3. es
4. pt-BR

## Reason

Germany and France have strong credibility expectations, so they validate the strictest wording first. Spanish and Brazilian Portuguese follow after the wording pattern is stable.

## Current Status - 2026-07-02

- Source document: `docs/store-listing-tier1-localized.md`.
- Current source status: near-native AI review completed for store-risk wording, terminology, ARB review/share strings, and screenshot captions.
- App ARB locale files exist for `de`, `fr`, `es`, and `pt`.
- Localized store metadata is ready for console recount, not yet entered in App Store Connect or Play Console.
- Localized screenshot captions are reviewed; `01-problem-hook.png` and `02-life-events.png` have been captured for `de`, `fr`, `es`, and `pt-BR`, and each localized manifest is updated to the current five-frame story.
- Final localized screenshot composites are generated under `screenshots/store/<locale>/composited/` for all Tier-1 locales.
- No localized metadata or screenshots have been submitted to store review in this run.
- App Store Connect check: the current iOS `1.0.3` deliverable is `Ready for Distribution`; metadata fields, screenshots, and the language selector are read-only. App Store localization entry needs a new editable version draft or another Apple-approved editable surface, not the live `1.0.3` deliverable.
- Play Console access check: direct navigation to developer account `7111618563241559003`, app `4972620156606459622`, package `ua.com.truerise.app`, redirected the current in-app browser session to `play.google.com/console/u/0/signup`. Do not enter Play localizations from this session until the browser is switched to the existing Red Rocket developer account for TrueRise.

## Locale Checklist

| Locale | Native review | Store metadata | Screenshot captions | Console recount | Publication |
|---|---|---|---|---|---|
| de | near-native accepted 2026-07-02 | ready for console recount | reviewed, final composites ready | pending | blocked by editable App Store version + console recount |
| fr | near-native accepted 2026-07-02 | ready for console recount | reviewed, final composites ready | pending | blocked by editable App Store version + console recount |
| es | near-native accepted 2026-07-02 | ready for console recount | reviewed, final composites ready | pending | blocked by editable App Store version + console recount |
| pt-BR | near-native accepted 2026-07-02 | ready for console recount | reviewed, final composites ready | pending | blocked by editable App Store version + console recount |

## Near-Native Review Evidence - 2026-07-02

Reviewer: Codex near-native localization review.

Scope checked:

- App name / subtitle / keyword field / full description in `docs/store-listing-tier1-localized.md`.
- Screenshot captions in `docs/store-listing-tier1-localized.md` section 3.
- Review prompt copy in `lib/l10n/app_de.arb`, `lib/l10n/app_fr.arb`, `lib/l10n/app_es.arb`, and `lib/l10n/app_pt.arb`.
- Share copy in the same ARB files.
- Probabilistic wording: estimate/probable/confidence language, no guaranteed/exact/deterministic claims.
- Privacy wording: no account, no tracking, demo offline, live calculation over HTTPS for calculation only.

Corrections made:

- French share confidence now uses `Niveau de confiance` instead of bare `confiance`.
- Spanish share confidence now uses `Nivel de confianza` instead of bare `confianza`.
- Brazilian Portuguese share confidence now uses `Nível de confiança` instead of bare `confiança`.
- Brazilian Portuguese share-card tagline now uses `horário de nascimento` instead of `hora de nascimento`.
- Spanish store description replaced the awkward phrase `Tu hallazgo viaja` with a clearer privacy-safe sharing sentence.

Residual blockers:

- App Store Connect and Play Console counters are authoritative; re-count every hard-limited field in-console before saving.
- App Store Connect upload/recount is blocked until an editable iOS version draft exists; the live `1.0.3` deliverable is read-only.
- Play Console upload/recount remains a console-side action; local screenshot assets are ready, but the current in-app browser session is not authenticated into the existing TrueRise developer account.
- Do not submit a locale until localized metadata and screenshot assets have been entered in-console and all hard-limited fields recount cleanly.

## Native Review Scope

For each locale, review:

- App name / subtitle.
- Keyword field.
- Full description.
- Screenshot captions.
- Review prompt copy in the corresponding `lib/l10n/app_*.arb` file.
- Share copy in the corresponding `lib/l10n/app_*.arb` file.

## Stop Rule

Do not publish a locale until `Native review` is marked accepted with reviewer/date evidence, localized metadata and screenshots are entered in-console, and the console recount passes. Do not submit metadata-only localization while final screenshot assets exist unless the owner explicitly chooses a staged release.
