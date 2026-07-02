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
- Localized screenshot captions are reviewed, but localized screenshot packs still use the historical pre-Appeeky raw frame order and need refreshed `01-problem-hook.png` / `02-life-events.png` frames before final composites.
- No localized metadata or screenshots have been submitted to store review in this run.

## Locale Checklist

| Locale | Native review | Store metadata | Screenshot captions | Console recount | Publication |
|---|---|---|---|---|---|
| de | near-native accepted 2026-07-02 | ready for console recount | reviewed, assets blocked | pending | blocked |
| fr | near-native accepted 2026-07-02 | ready for console recount | reviewed, assets blocked | pending | blocked |
| es | near-native accepted 2026-07-02 | ready for console recount | reviewed, assets blocked | pending | blocked |
| pt-BR | near-native accepted 2026-07-02 | ready for console recount | reviewed, assets blocked | pending | blocked |

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
- Localized screenshot manifests still reference pre-Appeeky raw captures and remain blocked for final compositing until the missing localized current-plan frames are captured.
- Do not submit a locale until localized screenshots either match the current five-frame story or the owner explicitly accepts metadata-only localization.

## Native Review Scope

For each locale, review:

- App name / subtitle.
- Keyword field.
- Full description.
- Screenshot captions.
- Review prompt copy in the corresponding `lib/l10n/app_*.arb` file.
- Share copy in the corresponding `lib/l10n/app_*.arb` file.

## Stop Rule

Do not publish a locale until `Native review` is marked accepted with reviewer/date evidence and the console recount passes. Do not generate localized final composites until each locale's screenshot manifest is updated from the pre-Appeeky raw frame order to the current five-frame story.
