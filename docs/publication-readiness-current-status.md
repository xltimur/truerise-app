# Publication Readiness — Current Status (TrueRise)

**Impl Run E.1 · 2026-06-03 · model `claude-opus-4-8` · documentation-only
reconciliation run.**

> **What this document is.** A current-state, evidence-based reconciliation of
> publication readiness, read directly from the repository at commit `887bdd8`.
> It **supersedes the status fields** in `docs/store-submission-readiness.md` §3
> (Run 6, 2026-06-02) and `docs/feature-gap-analysis.md` §4/§5/§10 (Run 4,
> 2026-06-02) **wherever the repo evidence has since changed**. Those documents'
> original prose is left intact as the 2026-06-02 baseline; each now carries an
> Impl Run E.1 banner pointing here.
>
> **Scope.** Documentation only. No app code, config, ARBs, generated l10n,
> assets, screenshots, `ios/`, `android/`, `pubspec.yaml`, README, or product
> features were modified or added. Source/config files were **read only** for
> evidence. No live store rankings, ratings, installs, trademark clearance, or
> store approvals are asserted.

---

## 1. Evidence labels

- **[DONE — VERIFIED]** — owner-independent artifact confirmed present in the
  repo this run (read at `887bdd8`).
- **[PARTIAL]** — the owner-independent part is done in-repo; a named
  owner/secret/legal/console step still remains.
- **[OWNER]** — blocked on an owner decision, secret, legal sign-off, or
  store-console action; not decidable or doable from code.
- **[OUT-OF-SCOPE]** — intentionally deferred (V1.5 / P1 / P2) per
  `docs/mvp-scope.md` and `CLAUDE.md`; do **not** pull forward to unblock the
  store.

The headline since 2026-06-02: the **engineering / owner-independent artifact**
side of the P0 set is now essentially complete. What remains on the critical
path is **almost entirely owner / secret / legal / console work** — see §5.

---

## 2. P0 blocker reconciliation (`store-submission-readiness.md` §3)

| # | Blocker | Run 6 (2026-06-02) | Current (2026-06-03) | Evidence read this run | What still remains |
| --- | --- | --- | --- | --- | --- |
| P0-1 | Public display name = TrueRise | gap | **[DONE — VERIFIED]** | `ios/Runner/Info.plist` `CFBundleDisplayName=TrueRise`; `android/.../AndroidManifest.xml` `android:label="TrueRise"`; `lib/l10n/l10n.dart:11` `appBrandName='TrueRise'`; no user-facing "Rectify" in `lib/features/settings`. (Run A.1) | none — `CFBundleName=rectify` + `com.rectify.rectify` retained as codename **by design** |
| P0-2 | Release signing (not debug) | debug-signed | **[OWNER]** (unchanged) | `android/app/build.gradle.kts` release `signingConfig = signingConfigs.getByName("debug")` | owner upload keystore + iOS distribution cert/profile; then a small gradle wiring step |
| P0-3 | Bundle-ID decision | owner | **[OWNER]** (unchanged) | `build.gradle.kts` `applicationId = "com.rectify.rectify"` | owner decision before first publish (irreversible after) |
| P0-4 | Hosted privacy-policy URL | absent | **[PARTIAL]** | Policy **content authored**: `docs/privacy-policy.md` (Run A.2). App still in-app only — `lib/features/settings/privacy_policy_screen.dart:18-19` notes the hosted-URL swap is pending; `url_launcher` **not** in `pubspec.yaml` | owner hosts the policy at a canonical URL → engineering wires `url_launcher` + adds the listing URL |
| P0-5 | Apple privacy labels + Play Data Safety | not authored | **[PARTIAL — authored prep]** | `docs/apple-privacy-labels.md`, `docs/play-data-safety.md` (Run A.2) map verified data flow to each form; in-app privacy copy now discloses live transmission (Run A.1) | owner/legal sign-off + actual console entry (both docs are explicitly "guidance, not a submission, not legal advice") |
| P0-6 | Age gate / age rating | absent | **[DONE — VERIFIED]** (gate) | `lib/features/calculation_flow/screens/birth_data_screen.dart:94,115` — picker `lastDate = CalculationFlowState.latestAllowedBirthDate(now)` (18+ floor, clamped). (Run A.1) | store age-rating questionnaire is a console/owner step |
| P0-7 | Real app icon | stock glyph | **[DONE — VERIFIED]** | iOS `Assets.xcassets/AppIcon.appiconset/` full set incl. `Icon-App-1024x1024@1x.png`, last modified in commit `72d6003`; Android adaptive icon `res/mipmap-anydpi-v26/ic_launcher.xml` + `ic_launcher_foreground.png` across densities + legacy `ic_launcher.png`. (Run A.3) | none (icon **visual** not re-rendered this doc-only run) |
| P0-8 | Store metadata finalized | placeholder | **[DONE — owner-independent]** | `docs/store-listing-en.md` ready-to-paste (Run A.4); `pubspec.yaml:2` description is real marketing copy, not "A new Flutter project." | console character re-count + trademark clearance for "TrueRise" (owner) |
| P0-9 | Screenshot set | absent | **[DONE — raw captures]** | `screenshots/store/{en,de,fr,es,pt-BR}/` — 5 frames each (`01-result-hero` … `05-privacy-policy`) + `manifest.json` + `README.md` (Runs A.5, D.4). 6.7" / 1290×2796 | device-frame/caption compositing, native-speaker caption review, other device sizes, console upload (owner/design) |
| P0-10 | Category positioning | owner | **[OWNER]** | Utilities (iOS) / Tools (Play) documented in `store-listing-en.md` §1 | select/confirm in console (owner) |
| P0-11 | Demo/review key hygiene | owner | **[OWNER]** (unchanged) | `pubspec.yaml` still bundles `.env` as an asset | rotate to a low-budget capped key before public build (owner secret) |

**P0 tally:** 5 fully resolved in-repo (P0-1, P0-6, P0-7, P0-8, P0-9), 2 partial
with the artifact done and an owner/legal/console remainder (P0-4, P0-5), 4
purely owner/secret/decision/console (P0-2, P0-3, P0-10, P0-11).

---

## 3. Gap reconciliation (`feature-gap-analysis.md` G1–G8, G20, G22)

| Gap | Run 4 status | Current (2026-06-03) | Source run |
| --- | --- | --- | --- |
| G1 — display name → TrueRise | MISSING | **[DONE — VERIFIED]** | A.1 |
| G2 — hosted privacy-policy URL | PARTIAL (in-app only) | **[PARTIAL]** — content authored (`privacy-policy.md`); hosting + `url_launcher` wiring still pending | A.2 |
| G3 — Apple labels + Play Data Safety | MISSING | **[PARTIAL — authored prep]** — `apple-privacy-labels.md` + `play-data-safety.md`; console entry remains owner/legal | A.2 |
| G4 — real app icon | MISSING | **[DONE — VERIFIED]** | A.3 |
| G5 — bundle-id + release signing | OPEN | **[OWNER]** — bundle-id decision + signing material still pending (debug-signed) | — |
| G6 — COPPA / age gate | UNVERIFIED | **[DONE — VERIFIED]** — 18+ gate enforced in the date picker | A.1 |
| G7 — store metadata | READY (doc) | **[DONE]** — finalized EN (`store-listing-en.md`) + localized drafts (`store-listing-tier1-localized.md`); `pubspec` description updated | A.4, D.3 |
| G8 — store screenshots | MISSING | **[DONE — raw]** — EN + de/fr/es/pt-BR raw frames captured | A.5, D.4 |
| G20 — l10n extraction pipeline | MISSING | **[DONE — VERIFIED]** — `flutter_localizations` + `generate: true` + `l10n.yaml` + `lib/l10n/app_en.arb` + extraction | C.1 |
| G22 — translated UI + ASO metadata (de/fr/es/pt-BR) | BLOCKED on G20 | **[DONE — in-repo]** — `app_{de,fr,es,pt}.arb`, localized listing drafts, localized screenshots; native-speaker review + per-locale console re-count remain | D.1, D.3, D.4 |

**Note on G22 honesty caveat:** the shipped **share text payload** is still
English-only (`lib/core/sharing/share_copy_builder.dart` takes no
`AppLocalizations`), documented in the Run D.4 history entry. This is **not** a
P0 submission blocker; it is a localized-listing honesty note and a future
product improvement.

---

## 4. What changed since the 2026-06-02 baseline (the A / C / D runs)

From `docs/claude-build-history.md`:

- **A.1** — public brand → TrueRise, 18+ age gate, in-app live-transmission
  disclosure → resolves **P0-1, P0-6**, and owner-decision #9 (privacy-copy
  update).
- **A.2** — privacy policy + Apple labels + Play Data Safety package authored →
  resolves the **authoring** part of **P0-4 / P0-5** (hosting + console entry
  still owner).
- **A.3** — production app icon (iOS appiconset + Android adaptive) → resolves
  **P0-7 / G4**.
- **A.4** — English store metadata finalized + `pubspec` description replaced →
  resolves owner-independent **P0-8 / G7**.
- **A.5** — English Tier 0 screenshot set captured → resolves **P0-9 / G8** (EN).
- **C.1** — l10n pipeline + English extraction → resolves **G20**.
- **D.1** — Tier 1 in-app translations (de/fr/es/pt-BR) → resolves UI side of
  **G22**.
- **D.2** — localized layout / overflow QA (commit `b740082`).
- **D.3** — Tier 1 localized store metadata drafts → localized **G7**.
- **D.4** — Tier 1 localized raw screenshots → localized **G8**.

---

## 5. Next-action ordering to submission

### 5a. Owner / secret / legal / console gated — the current critical path

These block first submission and **cannot be delegated to engineering** without
an owner input first. Roughly in dependency order:

1. **Bundle-ID decision** (P0-3 / G5) — keep `com.rectify.rectify` or rebrand to
   `com.truerise.*`. Irreversible after the first store record is created; gates
   App Store Connect / Play record creation.
2. **Release signing material** (P0-2 / G5) — generate the Android upload
   keystore (+ enroll in Play App Signing) and the iOS distribution
   certificate/profile. Owner secrets.
3. **Host the privacy policy** at a canonical URL (P0-4 / G2) — owner hosting of
   `docs/privacy-policy.md`'s content; legal review of provider naming/retention.
4. **Owner/legal sign-off + console entry** of the Apple privacy labels and Play
   Data Safety form (P0-5 / G3), using `apple-privacy-labels.md` /
   `play-data-safety.md` as the input.
5. **Demo/review key rotation** to a low-budget capped key (P0-11).
6. **Confirm category** Utilities (iOS) / Tools (Play) in console (P0-10).
7. **Trademark clearance + name availability** for "TrueRise" (gates metadata
   lock — `store-submission-readiness.md` §12).
8. **Console character re-count** + **native-speaker review** of localized
   copy/captions (gates the localized listings, not the EN Tier 0 listing).

### 5b. Engineering-delegatable next — but each waits on a 5a input

There is **no remaining owner-independent P0 engineering surface** that can be
completed standalone; the two genuine engineering tasks each need an owner input
first, and both are small:

- **Wire `url_launcher`** to open the hosted privacy URL and surface it in the
  listing — unblocked only once item 5a-3 picks the URL. Small.
- **Apply the release `signingConfig`** in `build.gradle.kts` — unblocked only
  once item 5a-2 produces the keystore. Small.
- **(Optional, design)** screenshot device-frame/caption compositing harness —
  but the Run D.4 spec deliberately leaves caption overlays to owner-composited
  work.
- **(Optional, product, not P0)** localize the share text payload
  (`share_copy_builder.dart`) — a future improvement, not a blocker.

### 5c. Out-of-scope for first submission — do NOT pull forward

Per `docs/mvp-scope.md` + `CLAUDE.md`: privacy-safe **share-card image** (G9,
V1.5), **analytics** (G13, P1), **crash reporting** (G14, P1), **PDF/report
export** (G23, V1.5), **IAP/paywall** (G24, V1.5), accounts/sync, dark mode,
chart rendering, Vedic/KP toggles. None is a submission blocker.

---

## 6. Residual risks & caveats for this run

- **Doc-only run — no Flutter tests executed** (not required; nothing in `lib/`,
  `test/`, ARBs, or config changed). The most recent green-test evidence is the
  Run D.4 localized QA (`localized_overflow_test.dart`,
  `localized_screens_test.dart`) plus the Phase 8 177+1 baseline
  (`docs/qa-phase8-report.md`, 2026-05-20, not re-run here).
- **App icon visual not re-verified.** P0-7 is marked DONE from repo assets +
  commit `72d6003` + the Run A.3 history entry, not from a visual render.
- **Screenshots are raw 6.7" captures only** — they still need device framing,
  marketing captions, native-speaker caption review, and additional device
  sizes before console upload; they are source assets, not final listing images.
- **P0-4 / P0-5 docs are preparation guidance**, explicitly "not legal advice"
  and "not a submission" — they do not themselves satisfy the store
  requirement; the owner/legal/console step is the gating action.
- **Share text payload is English-only** in all locales (per Run D.4) — a
  localized-listing honesty caveat, not a blocker.
- **The build remains not-submittable today** because P0-2, P0-3, P0-4, P0-5,
  P0-10, and P0-11 are open — but the blockers are now owner/secret/legal/
  console items, not engineering artifacts.
