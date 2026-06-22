# Publication Readiness — Current Status (TrueRise)

**Reconciled 2026-06-15 (post-Appeeky) - current release-readiness state of the
repository working tree. Updates and supersedes the 2026-06-12 framing.**

> **What this document is.** A current-state, evidence-based reconciliation of
> publication readiness, read from the repository **working tree on
> 2026-06-15** after the post-Appeeky ASO/category and screenshot-caption
> documentation alignment landed in the post-Appeeky docs commits `29f5e6b`,
> `8447f96`, and `b00117a`, with the later category/listing and data-safety doc
> syncs across the sibling docs continuing through `c724109` (`116ce01`,
> `95baf06`, `0ccd986`, `21286ce`, then `2697f0f`, `e4ae8fb`, `18601a5`,
> `5c1ac56`, `c724109`); the most recent two refined this package — `5c1ac56`
> clarified the live-quota / reviewer notes (Demo offline, free live quota of 3
> live requests per rolling 24h, user-provided Astrology API key bypassing the
> shared quota) and `c724109` added the post-launch ASO runbook and the
> privacy/GDPR/DPA checklist. The guarded screenshot-compositor write CLI itself
> landed earlier in `f694fba`. It updates the earlier 2026-06-12 reconciliation (then
> committed through `98eddc8` with local work still awaiting the Codex-gated
> commit flow; that work has since been committed). It replaces the earlier Impl
> Run E.1 snapshot (2026-06-03, commit `887bdd8` - historical) and **supersedes
> the status fields** in `docs/store-submission-readiness.md` §3 (Run 6,
> 2026-06-02) and `docs/feature-gap-analysis.md` §4/§5/§10 (Run 4, 2026-06-02)
> **wherever the repo evidence has since changed**.
>
> **Scope.** Release-status / handoff document. No live store rankings,
> ratings, installs, DNS resolution, trademark clearance, production proxy
> availability, or store approvals are asserted; everything that requires an
> owner, legal, backend, or console action is listed as open in §5.
>
> **Owner handoff (added 2026-06-16).** The open §5a items are consolidated into
> a paste-ready owner handoff in `docs/release-handoff-owner-checklist.md`
> (prepared-in-repo vs. owner/backend/legal/store inputs, exact store-metadata
> values, privacy docs to review, proxy/signing/URL inputs, screenshot status,
> and the recommended owner action order). The exact local verification commands
> and their expected outcomes live in `docs/release-preflight-commands.md`.
> Both are derived from this status doc; if they ever disagree, this doc wins.

---

## 1. Evidence labels

- **[DONE — VERIFIED]** — owner-independent artifact confirmed present in the
  working tree this run (2026-06-15, after the post-Appeeky docs syncs through
  `c724109` — the latter two being `5c1ac56` live-quota / reviewer-note
  clarification and `c724109` post-launch ASO + privacy/GDPR/DPA checklists;
  this file is the current status sync).
- **[PARTIAL]** — the owner-independent part is done in-repo; a named
  owner/secret/legal/console step still remains.
- **[OWNER]** — blocked on an owner decision, secret, legal sign-off, or
  store-console action; not decidable or doable from code.
- **[OUT-OF-SCOPE]** — intentionally deferred (V1.5 / P1 / P2) per
  `docs/mvp-scope.md` and `CLAUDE.md`; do **not** pull forward to unblock the
  store.

The headline as of 2026-06-15 (post-Appeeky): the **engineering /
owner-independent artifact** side of the P0 set is complete in-repo, including
the release guards, quota UX, and sharing/onboarding work landed since the
2026-06-03 snapshot (§2a), plus the 2026-06-15 post-Appeeky ASO/category and
screenshot-caption documentation alignment now committed in-repo (§2, §3).
What remains on the critical path is **owner / secret / legal / backend /
console work only** — see §5.

---

## 2. P0 blocker reconciliation (`store-submission-readiness.md` §3)

| # | Blocker | Run 6 (2026-06-02, historical) | Current (2026-06-15) | Evidence read this run | What still remains |
| --- | --- | --- | --- | --- | --- |
| P0-1 | Public display name = TrueRise | gap | **[DONE — VERIFIED]** | `ios/Runner/Info.plist` `CFBundleDisplayName=TrueRise`; `android/.../AndroidManifest.xml` `android:label="TrueRise"`; `lib/l10n/l10n.dart:11` `appBrandName='TrueRise'`; no user-facing "Rectify" in `lib/features/settings`. (Run A.1) | none — `CFBundleName=rectify` + `com.rectify.rectify` retained as codename **by design** |
| P0-2 | Release signing (not debug) | debug-signed | **[PARTIAL - wiring done, owner secrets pending]** (2026-06-12) | `android/app/build.gradle.kts` release now reads `android/key.properties` (no debug fallback); release tasks fail with an actionable error when it is missing/incomplete; debug builds unaffected | owner provides real upload keystore + Play App Signing enrollment; iOS distribution cert/profile still owner-side |
| P0-3 | Bundle-ID decision | owner | **[OWNER]** (unchanged) | `build.gradle.kts` `applicationId = "com.rectify.rectify"` | owner decision before first publish (irreversible after); current id stays `com.rectify.rectify` until explicit owner approval; recommended first-publish rebrand is `app.astrolium.truerise`, fallbacks in `docs/bundle-id-recommendation.md` |
| P0-4 | Hosted privacy-policy URL | absent | **[PARTIAL - wiring done, owner URL pending]** (2026-06-12) | Policy **content authored**: `docs/privacy-policy.md` (Run A.2). App wiring **done**: `url_launcher` in `pubspec.yaml`; the public, non-secret `--dart-define=TRUERISE_PRIVACY_POLICY_URL` (`AppLinks.privacyPolicyUrl`) opens a valid bare-HTTPS URL from Settings via `LaunchMode.inAppBrowserView`; empty default, unsafe values, and launch failures all fall back to the bundled in-app `PrivacyPolicyScreen` | owner/legal publishes the canonical public privacy-policy URL, builds with that URL in the dart-define, and uses the same URL in the store consoles/listing |
| P0-5 | Apple privacy labels + Play Data Safety | not authored | **[PARTIAL — authored prep]** | `docs/apple-privacy-labels.md`, `docs/play-data-safety.md` (Run A.2) map verified data flow to each form; in-app privacy copy now discloses live transmission (Run A.1) | owner/legal sign-off + actual console entry (both docs are explicitly "guidance, not a submission, not legal advice") |
| P0-6 | Age gate / age rating | absent | **[DONE — VERIFIED]** (gate) | `lib/features/calculation_flow/screens/birth_data_screen.dart:94,115` — picker `lastDate = CalculationFlowState.latestAllowedBirthDate(now)` (18+ floor, clamped). (Run A.1) | store age-rating questionnaire is a console/owner step |
| P0-7 | Real app icon | stock glyph | **[DONE — VERIFIED]** | iOS `Assets.xcassets/AppIcon.appiconset/` full set incl. `Icon-App-1024x1024@1x.png`, last modified in commit `72d6003`; Android adaptive icon `res/mipmap-anydpi-v26/ic_launcher.xml` + `ic_launcher_foreground.png` across densities + legacy `ic_launcher.png`. (Run A.3) | none (icon **visual** not re-rendered this doc-only run) |
| P0-8 | Store metadata finalized | placeholder | **[DONE — owner-independent]** | `docs/store-listing-en.md` ready-to-paste (Run A.4), refreshed 2026-06-15 from the Appeeky audit (post-Appeeky title/subtitle/keyword package + **Lifestyle** category; companion `docs/aso-naming-strategy.md` + `docs/competitor-aso-research.md`); `pubspec.yaml:2` description is real marketing copy, not "A new Flutter project." | console character re-count + trademark clearance for "TrueRise" (owner) |
| P0-9 | Screenshot set | absent | **[DONE — raw captures]** | `screenshots/store/{en,de,fr,es,pt-BR}/` — 5 frames each (`01-result-hero` … `05-privacy-policy`) + `manifest.json` + `README.md` (Runs A.5, D.4). 6.7" / 1290×2796. The post-Appeeky 5-frame caption / story plan (problem hook -> life events -> result -> evidence -> privacy) is aligned in `docs/store-listing-en.md` §5 and the per-locale `screenshots/store/<locale>/README.md` + `manifest.json` (2026-06-15); the existing PNGs remain pre-Appeeky raw / reference captures, not final composited listing images. Test-only compositor path/geometry + store-inventory guards now exist (`test/tool/screenshot_compositor.dart`, `test/tool/screenshot_compositor_test.dart`, `test/tool/store_screenshot_manifest_test.dart`); an in-memory `dart:ui`/Canvas renderer seam (`test/tool/store_screenshot_compositor_renderer.dart` + `…_test.dart`) now returns composited PNG **bytes** only, keeping `screenshot_compositor.dart` pure (focused tests cover the result-hero fixture + a long caption, asserting PNG magic, output size, bytes differing from the raw frame, and that no `composited/` dir is created); a manifest-driven planning seam (`test/tool/store_screenshot_compositor_plan.dart` + `…_test.dart`) builds validated `StoreScreenshotCompositeJob`s (locale, fileName, rawPath, outputPath, caption) from on-disk manifests only — validating supported locale, safe file names (`resolveCompositedTarget`), non-empty caption, and preserved locale/frame order — and renders nothing, writes no PNGs, creates no directories, and never calls the renderer (5 focused tests pass); an in-memory pipeline test (`test/tool/store_screenshot_compositor_pipeline_test.dart`) now wires the plan seam to the renderer seam: `buildAllCompositeJobs()` then renders a fast representative subset (`jobs.first` + `jobs.last`, not all 25 jobs) through `StoreScreenshotCompositorRenderer.render(StoreScreenshotCompositeInput(rawScreenshotPng: rawBytes, caption: job.caption))`, asserting rawPath present and outputPath absent before/after, PNG magic, output differing from the raw frame, decoded size `kRawScreenshotWidth` x `kRawScreenshotHeight`, captions taken from `job.caption` (no localized captions hardcoded), and no `screenshots/store/<locale>/composited` dir before/after across `supportedStoreLocales` (1 test passes; writes no files, creates no composited dirs); a runnable no-write dry-run CLI (`tool/store_screenshot_compositor_dry_run.dart` + `test/tool/store_screenshot_compositor_dry_run_test.dart`) now plans all 25 composited screenshots across the 5 locales (en, de, fr, es, pt-BR), validates every raw source exists and that no composited output already exists, and confirms it rendered nothing, wrote no files, and created no dirs — `dart run tool/store_screenshot_compositor_dry_run.dart` exits 0 (1 on validation fail, 64 on usage error), `--verbose` lists the 25 planned output paths (`+10` focused tests pass); a new IO-only write seam (`test/tool/store_screenshot_compositor_writer.dart` + `test/tool/store_screenshot_compositor_writer_test.dart`) now owns the harness's only disk-touching step — `writeCompositedScreenshots` reads each planned job's raw source, asks an injected renderer callback (returning `Uint8List`) for the composited bytes, and writes them under an injected root `Directory`, pre-flighting the whole batch (refusing a missing raw source or an existing output, the latter unless `allowOverwrite` is set) before any render/write and staying free of `dart:ui` — its 5 focused tests drive real IO entirely inside temp directories, so no `composited/` dir is ever created under the repo's `screenshots/store/` (`+5` tests pass). A guarded write CLI now wires the plan, renderer, and writer seams together (`tool/store_screenshot_compositor_write.dart` + `test/tool/store_screenshot_compositor_write_test.dart` (12 tests) + `test/tool/store_screenshot_compositor_write_harness_test.dart`, landed in commit `f694fba`): the default path is a no-write preview (exit 0, writes nothing), a real write requires BOTH `--write` and `--yes` (`--write` alone refuses, exit 64), and a plain `dart run tool/store_screenshot_compositor_write.dart --write --yes` refuses (exit 70) because real rendering needs the Flutter engine (`dart:ui`), pointing instead at the Flutter-compatible harness — that harness wires the real `dart:ui` renderer through `runWriteCli` into a temp dir and verifies it composites and writes a PNG there (never under the repo's `screenshots/store/`). No final composited / on-disk store PNGs have been generated in the repo (`find screenshots/store -name composited -type d` -> no output) | final composited App Store/Play PNG generation, final visual/design approval, native-speaker caption review, other device sizes, console upload (all owner/design) |
| P0-10 | Category positioning | owner | **[OWNER]** | Post-Appeeky recommendation is **Lifestyle** on both the App Store and Google Play, documented in `store-listing-en.md` Sec. 1 / Sec. 3.4 and `store-listing-tier1-localized.md` (those docs carry the earlier non-Lifestyle category rationale only as explicitly superseded historical context). A 2026-06-15 Appeeky recheck still showed TrueRise's category field as **Utilities**; that is stale third-party / source metadata, **not** a recommendation reversal - Lifestyle stands (`docs/competitor-aso-research.md` Sec. 15.4) | owner selects/confirms the final category in the store consoles |
| P0-11 | Demo/review key hygiene | owner | **[PARTIAL - release guard added, owner rotation pending]** (2026-06-12) | `pubspec.yaml` still bundles `.env` as an asset, but Android release/bundle tasks now fail (redacted message) on an unacknowledged `ASTRO_API_KEY` unless acknowledged via `--android-project-arg=truerise.allowBundledApiKey=true --android-project-arg=truerise.bundledApiKeyPurpose=review-capped` on `flutter build appbundle`; iOS/manual preflight: `dart run tool/release_env_guard.dart --share-url="$TRUERISE_SHARE_URL" --proxy-base-url="$RECTIFY_PROXY_BASE_URL" --provider-base-url="$RECTIFY_PROVIDER_BASE_URL" --allow-bundled-key --purpose=review-capped` (see `docs/api-integration.md`) | owner rotates the current embedded key (treat as throwaway) to a low-budget capped review key - or removes it - before public build |

**P0 tally:** 5 fully resolved in-repo (P0-1, P0-6, P0-7, P0-8, P0-9), 4
partial with the in-repo artifact done and an owner/legal/console remainder
(P0-2, P0-4, P0-5, P0-11), 2 purely owner decision/console (P0-3, P0-10).

### 2a. Additional release-readiness work in-repo (through 2026-06-15)

Beyond the numbered P0 lines, the following is now an in-repo artifact, all
committed (the earlier post-Appeeky docs commits began with
`29f5e6b`/`8447f96`/`b00117a` and later category/listing and data-safety doc
syncs continued through `c724109`, all before this status sync; the earlier
"local/uncommitted, pending the Codex-gated commit flow" caveat no longer
applies):

- **No-key live API guard + optional proxy contract** —
  `tool/release_env_guard.dart` (run by the Android release Gradle task; manual
  for iOS) allows Oleg's confirmed public no-key host
  `https://api-public.astrology-api.io` and validates custom API/proxy hosts as
  host-only HTTPS origins; `docs/proxy-contract.md` documents the current
  owner-billed public host plus the optional owner-controlled proxy contract.
  **Owner/backend remainder:** exact provider-side rate-limit numbers are not
  documented in OpenAPI/headers; request them from the owner/provider if needed.
- **API key / quota UX** — local 3-attempts-per-24h live-quota guard
  (`lib/data/prefs/live_quota_store.dart`); server 429 UX honoring
  `retryAfter`/`resetAt` (`RateLimitedFailure` + dedicated rate-limit error
  screen); demo mode stays fully offline and a user-entered provider key
  goes provider-direct to the canonical provider host, bypassing the no-key
  free quota. The no-key public host is owner-billed and Oleg-confirmed for
  mobile use; the local guard remains UX, not security.
- **Live coordinates guard** — live submissions can no longer silently send
  0,0: live flow requires resolved coordinates; the `?? 0` fallback is
  demo-only.
- **Onboarding demo/real mode** — every onboarding exit explicitly persists
  the mode its CTA advertises (demo vs. real calculation).
- **Share URL** — build-configurable via `--dart-define=TRUERISE_SHARE_URL`
  and release-guarded (the guard rejects non-bare-HTTPS values and requires
  explicit acknowledgement to ship the placeholder). A resolvable final URL
  remains owner (§5a).
- **UX / hygiene set** — share copy honors the 12h/24h time-format setting,
  low-confidence results get refine-input guidance, loading Cancel + error
  retry hardened, compliant in-app review prompt, P2 dependency/file hygiene
  (unused deps removed, `result_screen` split).
- **Reviewer notes — live-quota wording clarified** (`5c1ac56`,
  `docs/store-listing-en.md`, `docs/store-submission-readiness.md`): the
  reviewer / Data-safety notes now explicitly document that **Demo mode is
  offline** and consumes no quota, the **no-key live path** uses Oleg's
  owner-billed public host with the local **3 live requests per rolling
  24-hour window** UX guard, and a user who enters their own **Astrology API
  key** in Settings calls the canonical provider host directly and **bypasses
  the no-key quota** (provider-direct mode). The earlier "BYO key removed / no
  longer user-facing" note was stale and is corrected.
- **Post-launch ASO runbook** (`docs/post-launch-aso-plan.md`, `c724109`) —
  closes the locally preparable after-live ASO planning (Appeeky audit/
  opportunities follow-up, the experimentation/A-B matrix, per-locale keyword
  research, Apple Search Ads prep) as a runbook; **live execution stays blocked**
  until the listing is live and the owner takes the billing/account actions, so
  nothing here is asserted as executed against a live listing.
- **Privacy / GDPR / DPA checklist** (`docs/privacy-gdpr-dpa-checklist.md`,
  `c724109`) — collects the birth-data / life-events / provider
  controller-processor, DPA/SCC/subprocessor, retention, deletion, and
  data-subject-rights decisions for owner/legal sign-off; it is an owner/legal
  **draft, explicitly not legal advice** and asserts no compliance.

---

## 3. Gap reconciliation (`feature-gap-analysis.md` G1–G8, G20, G22)

| Gap | Run 4 status (historical) | Current (2026-06-15) | Source run |
| --- | --- | --- | --- |
| G1 — display name → TrueRise | MISSING | **[DONE — VERIFIED]** | A.1 |
| G2 — hosted privacy-policy URL | PARTIAL (in-app only) | **[PARTIAL]** — content authored (`privacy-policy.md`); app wiring done 2026-06-12 (config-gated `TRUERISE_PRIVACY_POLICY_URL`, in-app fallback); owner hosting + console/listing URL still pending | A.2 |
| G3 — Apple labels + Play Data Safety | MISSING | **[PARTIAL — authored prep]** — `apple-privacy-labels.md` + `play-data-safety.md`; console entry remains owner/legal | A.2 |
| G4 — real app icon | MISSING | **[DONE — VERIFIED]** | A.3 |
| G5 — bundle-id + release signing | OPEN | **[OWNER]** — bundle-id decision + signing material still pending (Android gradle wiring done 2026-06-12: release requires owner `key.properties`, no debug fallback) | — |
| G6 — COPPA / age gate | UNVERIFIED | **[DONE — VERIFIED]** — 18+ gate enforced in the date picker | A.1 |
| G7 — store metadata | READY (doc) | **[DONE]** — finalized EN (`store-listing-en.md`) + localized drafts (`store-listing-tier1-localized.md`), both refreshed 2026-06-15 from the Appeeky audit (post-Appeeky **Lifestyle** category + 5-frame caption plan; see §2 P0-8/P0-9/P0-10); `pubspec` description updated | A.4, D.3 |
| G8 — store screenshots | MISSING | **[DONE — raw]** — EN + de/fr/es/pt-BR raw frames captured | A.5, D.4 |
| G20 — l10n extraction pipeline | MISSING | **[DONE — VERIFIED]** — `flutter_localizations` + `generate: true` + `l10n.yaml` + `lib/l10n/app_en.arb` + extraction | C.1 |
| G22 — translated UI + ASO metadata (de/fr/es/pt-BR) | BLOCKED on G20 | **[DONE — in-repo]** — `app_{de,fr,es,pt}.arb`, localized listing drafts, localized screenshots; native-speaker review + per-locale console re-count remain | D.1, D.3, D.4 |

**Note on G22 (updated 2026-06-12):** the shipped **share text payload** is now
**localized in-repo for EN/DE/ES/FR/PT** —
`lib/core/sharing/share_copy_builder.dart` takes `AppLocalizations` and follows
the active locale (the earlier Run D.4 "English-only" caveat is resolved). The
payload stays privacy-safe: time + rising sign + confidence + brand tagline +
share URL only — no birth data, life events, coordinates, or API ids
(`test/unit/sharing/share_copy_builder_test.dart` proves distinct localized
headlines and no PII leaks per locale). Native-speaker review of the localized
share copy and the store-console/localized listing review remain owner scope.
Not a P0 submission blocker.

---

## 4. Historical baseline: the 2026-06-02 → 2026-06-03 A / C / D runs

Historical record, kept for traceability; current status lives in §2/§2a.
Later work (2026-06-04 through 2026-06-15: share/invite hardening, update
notification, the §2a set, and the 2026-06-15 post-Appeeky ASO/category +
screenshot-caption documentation alignment) is detailed per-stage in
`docs/claude-build-history.md`. From that file:

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

1. **Bundle-ID decision** (P0-3 / G5) — the app id remains `com.rectify.rectify`
   until the owner explicitly approves a change. Recommended first-publish
   rebrand: `app.astrolium.truerise`; fallback options are documented in
   `docs/bundle-id-recommendation.md`. This is an owner decision before first
   publish, not an engineering change to make without approval. Irreversible
   after the first store record is created; gates App Store Connect / Play
   record creation.
2. **Release signing material** (P0-2 / G5) — generate the Android upload
   keystore (+ enroll in Play App Signing) and the iOS distribution
   certificate/profile. Owner secrets. (Android gradle wiring landed
   2026-06-12: release builds read `android/key.properties` and refuse to
   fall back to debug signing; only the keystore itself is still missing.)
3. **Host the privacy policy** at a canonical URL (P0-4 / G2) — owner hosting of
   `docs/privacy-policy.md`'s content; legal review of provider naming/retention.
   App wiring is already done (2026-06-12): once the URL exists, build with the
   public `--dart-define=TRUERISE_PRIVACY_POLICY_URL=…` and use the same URL in
   the store consoles/listing — no further engineering step.
4. **Owner/legal sign-off + console entry** of the Apple privacy labels and Play
   Data Safety form (P0-5 / G3), using `apple-privacy-labels.md` /
   `play-data-safety.md` as the input.
5. **Demo/review key rotation** to a low-budget capped key (P0-11).
6. **Confirm category** in the store consoles (P0-10). Post-Appeeky
   recommendation is **Lifestyle** on both the App Store and Google Play
   (`store-listing-en.md` §1/§3.4, `store-listing-tier1-localized.md`); the
   final category selection/confirmation stays owner/console scope. A 2026-06-15
   Appeeky recheck still displayed the category as **Utilities** - treat that as
   stale source metadata, not a reason to switch; Lifestyle stands
   (`docs/competitor-aso-research.md` Sec. 15.4).
7. **Trademark clearance + name availability** for "TrueRise" (gates metadata
   lock — `store-submission-readiness.md` §12).
8. **Console character re-count** + **native-speaker review** of localized
   copy/captions (gates the localized listings, not the EN Tier 0 listing).
9. **Resolvable share/invite landing URL** (added Impl Run S4.1, 2026-06-04).
   Every share/invite surface embeds `AppLinks.shareUrl`, whose default is the
   **placeholder** `https://truerise.app` — a `curl` against that host
   currently does **not** resolve, so shipping as-is hands recipients a broken
   link. The link is now owner-configurable at build time via the public,
   non-secret `--dart-define=TRUERISE_SHARE_URL=…` (no code change needed).
   **Owner action before publication:** either register/own `truerise.app` and
   confirm it resolves, or build with `TRUERISE_SHARE_URL` set to the real
   resolvable landing/store URL. The default present in source is **not** proof
   of ownership or DNS resolution. (Whatever URL is chosen must stay a bare
   HTTPS URL with no tracking params — enforced by
   `AppLinks.isPrivacySafeShareUrl`, its tests, and the release guard, which
   refuses the placeholder without explicit owner acknowledgement.)
10. **No-key live API host** (owner/backend). Oleg provided
    `https://api-public.astrology-api.io` as an owner-billed public Astrology
    API host for no-key mobile calls. The app now defaults no-key live calls to
    that host and `/api/v3/rectification/search`; the local 3-per-24h UX quota
    remains enforced. A bounded 2026-06-22 invalid-key check showed this host
    ignores invalid `Authorization` values and returns `x-auth-bypass: true`, so
    provider-direct/user-key traffic stays on `https://api.astrology-api.io` by
    default. A separate owner-controlled proxy is now optional for stronger
    server-side quota/device attestation, not required for the app to reach the
    live API. **Release check still needed:** one owner-approved valid-key call
    against `https://api.astrology-api.io` to confirm the canonical host accepts
    the same rectification path/schema and that any bundled review key is capped
    and budgeted for real credit consumption.

### 5b. Engineering-delegatable — none blocking

There is **no remaining owner-independent P0 engineering surface**; the
engineering tasks identified earlier have all landed (each leaving only its
5a owner input):

- **Wire `url_launcher`** to open the hosted privacy URL — **[DONE
  2026-06-12]**: Settings opens an owner-configured
  `--dart-define=TRUERISE_PRIVACY_POLICY_URL` (validated bare HTTPS) via
  `LaunchMode.inAppBrowserView`, falling back to the bundled in-app
  `PrivacyPolicyScreen` when the define is empty (the default), unsafe, or the
  launch fails. Only the owner-hosted canonical URL from item 5a-3 remains,
  plus entering that URL in the store consoles/listing.
- **Apply the release `signingConfig`** in `build.gradle.kts` — **[DONE
  2026-06-12]**: release signing reads `android/key.properties` (validated:
  `storePassword`, `keyPassword`, `keyAlias`, `storeFile`; absolute or
  `android/`-relative `storeFile`), with no debug fallback. Only the
  owner keystore from item 5a-2 remains.
- **(Optional, design — non-blocking)** screenshot device-frame/caption
  compositing — the non-rendering path/geometry core and the store-inventory
  guard are now done locally (`test/tool/screenshot_compositor.dart`,
  `test/tool/screenshot_compositor_test.dart`,
  `test/tool/store_screenshot_manifest_test.dart`), and an in-memory
  `dart:ui`/Canvas renderer seam now exists
  (`test/tool/store_screenshot_compositor_renderer.dart` +
  `test/tool/store_screenshot_compositor_renderer_test.dart`) that returns
  composited PNG **bytes** only, keeping `screenshot_compositor.dart` pure —
  focused tests cover the result-hero fixture and a long caption, asserting PNG
  magic, output size, bytes differing from the raw frame, and that no
  `composited/` dir is created. A manifest-driven planning seam
  (`test/tool/store_screenshot_compositor_plan.dart` +
  `test/tool/store_screenshot_compositor_plan_test.dart`) now builds validated
  `StoreScreenshotCompositeJob`s (locale, fileName, rawPath, outputPath,
  caption) from on-disk manifests only — `buildLocaleCompositeJobs` validates
  supported locale, safe file names via `resolveCompositedTarget`, non-empty
  caption, and preserved frame order; `buildAllCompositeJobs` reads the
  on-disk manifests for `supportedStoreLocales` and returns jobs in
  locale/frame order. It is test-only and non-rendering: it does not render
  images, write PNGs, create directories, or call the renderer (5 focused
  tests pass; `flutter analyze` clean). An in-memory pipeline test
  (`test/tool/store_screenshot_compositor_pipeline_test.dart`) now joins the
  plan seam to the renderer seam end-to-end without disk: it calls
  `buildAllCompositeJobs()`, renders a fast representative subset (`jobs.first`
  + `jobs.last`, not all 25 jobs) via `StoreScreenshotCompositorRenderer.render`
  with captions from `job.caption` (no localized captions hardcoded), and
  asserts rawPath present / outputPath absent before and after, PNG magic,
  output differing from the raw frame, decoded size `kRawScreenshotWidth` x
  `kRawScreenshotHeight`, and no `screenshots/store/<locale>/composited` dir
  across `supportedStoreLocales` (1 test passes; `flutter analyze` clean;
  writes no files, creates no composited dirs). A runnable no-write dry-run
  CLI now also exists (`tool/store_screenshot_compositor_dry_run.dart` +
  `test/tool/store_screenshot_compositor_dry_run_test.dart`): `dart run
  tool/store_screenshot_compositor_dry_run.dart` plans all 25 composited
  screenshots across the 5 locales (en, de, fr, es, pt-BR), validates every
  raw source exists and that no composited output already exists, and confirms
  it rendered nothing, wrote no files, and created no dirs (exit 0 on pass, 1
  on validation fail, 64 on usage error; `--verbose` lists the 25 planned
  output paths). It is local readiness evidence only — focused verification:
  `flutter test test/tool/store_screenshot_compositor_dry_run_test.dart` ->
  `+10` passed; `dart run tool/store_screenshot_compositor_dry_run.dart` and
  `… --verbose` -> exit 0 (25 paths listed); `flutter analyze` on the CLI plus
  its test, `store_screenshot_compositor_plan.dart`, and
  `screenshot_compositor.dart` -> No issues found; `find screenshots/store
  -name composited -type d` -> no output. An IO-only write seam
  (`test/tool/store_screenshot_compositor_writer.dart` +
  `test/tool/store_screenshot_compositor_writer_test.dart`) now owns the
  harness's single disk-touching step: `writeCompositedScreenshots` reads each
  planned job's raw source, asks an injected renderer callback (returning
  `Uint8List`) for the composited bytes, and writes them under an injected root
  `Directory`, creating only the `composited/` parent each output needs. It
  pre-flights the whole batch before any render/write — refusing a missing raw
  source or an already-existing output (the latter unless `allowOverwrite` is
  passed) — and stays free of `dart:ui`/Flutter (the pixel work lives behind
  the callback). Its 5 focused tests drive real IO entirely inside temporary
  directories, so they never create a `composited/` dir under the repo's
  `screenshots/store/`; focused verification: `flutter test
  test/tool/store_screenshot_compositor_writer_test.dart` -> `+5: All tests
  passed!`; `flutter analyze` on the writer, its test, and
  `store_screenshot_compositor_plan.dart` -> `No issues found!`; `git diff
  --check` on the two new files -> clean; `find screenshots/store -name
  composited -type d` -> no output. A guarded write CLI
  (`tool/store_screenshot_compositor_write.dart` +
  `test/tool/store_screenshot_compositor_write_test.dart` (12 tests) +
  `test/tool/store_screenshot_compositor_write_harness_test.dart`, landed in
  commit `f694fba`) now wires the plan, renderer, and writer seams into one
  explicit entrypoint, but writing stays deliberately hard to trigger: the
  default path is a no-write preview (exit 0, writes nothing), a real write
  requires BOTH `--write` and `--yes` (`--write` alone refuses, exit 64), and a
  plain `dart run tool/store_screenshot_compositor_write.dart --write --yes`
  refuses (exit 70) because real rendering needs the Flutter engine (`dart:ui`) —
  it declines and points at the Flutter-compatible harness. That harness
  (`store_screenshot_compositor_write_harness_test.dart`) wires the real
  `dart:ui` `StoreScreenshotCompositorRenderer` through `runWriteCli` into a
  temporary directory and verifies it composites and writes a real PNG there
  (PNG magic, bytes differing from the raw frame), asserting that no
  `composited/` dir is created under the repo's `screenshots/store/`. No final
  composited / on-disk store PNGs have been generated in the repo (`find
  screenshots/store -name composited -type d` -> no output). Final composited
  App Store/Play PNG generation, final visual/design approval, native-speaker
  caption review, other device sizes, and console upload all remain optional
  design/owner work (the Run D.4 spec deliberately leaves caption overlays to
  owner-composited work). This adds no owner-independent P0 surface — the §5b
  "none blocking" headline above still holds.
- **Localize the share text payload** (`share_copy_builder.dart`) — **[DONE
  2026-06-12]**: `ShareCopyBuilder.build` takes `AppLocalizations` and emits
  EN/DE/ES/FR/PT share copy following the active locale, still restricted to
  the privacy-safe allow-list (time, rising, confidence, brand, share URL).
  Only native-speaker review of the localized copy remains (owner, item 5a-8).

### 5c. Out-of-scope for first submission — do NOT pull forward

Per `docs/mvp-scope.md` + `CLAUDE.md`: **analytics** (G13, P1), **crash
reporting** (G14, P1), **PDF/report export** (G23, V1.5), **IAP/paywall**
(G24, V1.5), accounts/sync, dark mode, chart rendering, Vedic/KP toggles.
None is a submission blocker.

**No longer deferred — shipped in-repo (2026-06-12):** the privacy-safe
**share-card image** (G9), formerly listed here as V1.5. `share_plus` is a
dependency; `lib/core/sharing/story_card_renderer.dart` renders the PNG story
card and `ShareService.shareImagePng` (`share_service.dart`) shares it from
the result screen (`_ShareImageButton` in `result_screen_sections.dart`,
`resultShareImageButtonKey`). Text and image share both emit only the
privacy-safe allow-list — rectified time, rising/ascendant when present,
confidence, brand, and the public share URL/caption — and nothing else.
Covered by `test/widget/features/calculation_flow/result_share_test.dart` and
`test/unit/sharing/story_card_renderer_test.dart`. Direct Instagram Stories
posting remains optional / out of scope until a Meta/Facebook App ID exists;
the card goes out via the OS share sheet.

---

## 6. Residual risks & caveats for this run

- **2026-06-16 verification sweep (latest full-suite evidence).** A docs-only
  task re-ran the local checks and they passed: `flutter analyze` -> `No issues
  found!`; full `flutter test` -> 648 tests passed; `flutter test
  integration_test/demo_flow_test.dart` -> demo/offline flow passed; `flutter
  test test/tool/release_env_guard_test.dart` -> 38 passed; `dart run
  tool/release_env_guard.dart --share-url=... --proxy-base-url=...
  --provider-base-url=... --allow-bundled-key --purpose=review-capped`
  (illustrative bare-HTTPS placeholders, not the real owner URLs) -> exit 0;
  `dart run
  tool/store_screenshot_compositor_dry_run.dart` -> exit 0, planned 25 composites
  across the 5 locales while writing no files and rendering nothing; `git diff
  --check` clean and the tree stayed clean. The dated command/result snapshot is
  `docs/release-verification-report-2026-06-16.md`. The 648-test figure
  supersedes the earlier `+587` (2026-06-14) figure below as the latest
  full-suite evidence. This changes **no** blocker status: the engineering/local
  side is clean, but the release stays not-submittable on the owner/backend/legal
  /console items in Sec. 5a, and no final composited screenshots were generated.
- **Earlier 2026-06-14 full-suite sweep (superseded as the latest figure by the
  2026-06-16 sweep above; kept here for detail), run after
  the dry-run CLI and status sync** (the 2026-06-15 post-Appeeky changes were
  documentation-only - ASO/category/caption docs and this status sync - with no
  product code, test, or asset changes, so they did not require a re-run),
  recorded in
  `docs/claude-build-history.md` (a verification-only sweep run after the
  no-write store screenshot compositor dry-run CLI
  (`tool/store_screenshot_compositor_dry_run.dart`) and the publication
  status-doc sync landed; no product code, tests, or assets changed in it, and
  this reconciliation edited only this document). That sweep recorded: full
  `flutter test` -> `+587: All tests passed!` (587 tests); `flutter analyze` ->
  `No issues found!` (Claude saw `ran in 2.4s`, Codex `ran in 2.0s`); `dart run
  tool/store_screenshot_compositor_dry_run.dart` -> exit 0, planning 25
  composited screenshots across the 5 locales (`en`, `de`, `fr`, `es`,
  `pt-BR`) while writing no files, creating no directories, and rendering
  nothing, with `--verbose` -> exit 0 listing all 25 planned output paths;
  `find screenshots/store -name composited -type d` -> no output (no
  `screenshots/store/**/composited/` directories exist); and a scoped `git
  status` showing only the expected dirty/untracked paths with no
  `screenshots/store` entries (a benign `Running build hooks...` line appeared
  before the dry-run CLI output; the command still exited 0). This `+587` run
  supersedes the earlier `+571` renderer-seam figure from the prior 2026-06-14
  sweep and now covers the renderer, planning, pipeline, and dry-run CLI seams
  under one full suite; the still-useful Android Gradle sanity check from an
  earlier sweep remains on record: `./gradlew tasks --all` from `android/` with
  `JAVA_HOME` on the Android Studio bundled JBR -> `BUILD SUCCESSFUL in 16s`
  (Gradle 10 deprecation warning only; read-only task graph - no keystore use,
  no publish task). The compositor work stays no-write/in-memory with nothing
  wired into a screenshot rendering pipeline, so a recorded full-suite run now
  exists after the dry-run CLI without changing any blocker status - no final
  composited screenshots were generated and the owner/design approval still
  required is unchanged. The later manifest-driven planning seam
  (`test/tool/store_screenshot_compositor_plan.dart`) is likewise test-only and
  non-rendering, verified only by focused checks: `flutter test
  test/tool/store_screenshot_compositor_plan_test.dart` -> 5 tests passed;
  `flutter analyze` on the two new sources plus `screenshot_compositor.dart` ->
  `No issues found`; `find screenshots/store -name composited -type d` -> no
  output. It builds composite jobs from manifests only and produces no on-disk
  output, so it changes no blocker status and was not re-validated against the
  full suite. A later in-memory pipeline test
  (`test/tool/store_screenshot_compositor_pipeline_test.dart`) joins that plan
  seam to the renderer seam and was verified only by targeted checks: `flutter
  test test/tool/store_screenshot_compositor_pipeline_test.dart` -> 1 test
  passed; `flutter analyze` on the pipeline test plus
  `store_screenshot_compositor_plan.dart`,
  `store_screenshot_compositor_renderer.dart`, and `screenshot_compositor.dart`
  -> No issues found; `git diff --check` -> clean; ASCII-only source; `find
  screenshots/store -name composited -type d` -> no output. It renders a
  representative `jobs.first` + `jobs.last` subset in memory (not all 25 jobs),
  writes no files, and creates no composited dirs, so it adds no on-disk output
  and changes no blocker status; it does NOT create the final composed/on-disk
  screenshots and does NOT remove the owner/design approval still required.
  A later runnable no-write dry-run CLI
  (`tool/store_screenshot_compositor_dry_run.dart`) plans all 25 composited
  screenshots across the 5 locales, validates the raw sources exist and that no
  composited output already exists, and confirms it rendered nothing, wrote no
  files, and created no dirs; it was verified only by targeted checks: `flutter
  test test/tool/store_screenshot_compositor_dry_run_test.dart` -> `+10` tests
  passed; `dart run tool/store_screenshot_compositor_dry_run.dart` -> exit 0
  and `… --verbose` -> exit 0 with 25 output paths listed; `flutter analyze` on
  the CLI plus `test/tool/store_screenshot_compositor_dry_run_test.dart`,
  `store_screenshot_compositor_plan.dart`, and `screenshot_compositor.dart` ->
  No issues found; `git diff --check` -> clean; ASCII-only source; `find
  screenshots/store -name composited -type d` -> no output. The CLI is local
  readiness evidence only: it produces no on-disk output and changes no blocker
  status, does NOT create the final composed/on-disk screenshots, and does NOT
  remove the owner/design approval still required. A later IO-only write seam
  (`test/tool/store_screenshot_compositor_writer.dart` +
  `test/tool/store_screenshot_compositor_writer_test.dart`) owns the harness's
  only disk-touching step but writes through an injected root `Directory` using
  an injected renderer callback (returning `Uint8List`), so its 5 focused tests
  exercise real IO entirely inside temp directories and never create a
  `composited/` dir in the repo. It pre-flights a missing raw source and an
  existing output before rendering/writing (`allowOverwrite` required to replace
  an existing output) and was verified only by targeted checks: `flutter test
  test/tool/store_screenshot_compositor_writer_test.dart` -> `+5: All tests
  passed!`; `flutter analyze` on the writer, its test, and
  `store_screenshot_compositor_plan.dart` -> `No issues found!`; `git diff
  --check` on the two new files -> clean; `find screenshots/store -name
  composited -type d` -> no output. A later guarded write CLI
  (`tool/store_screenshot_compositor_write.dart` +
  `test/tool/store_screenshot_compositor_write_test.dart` (12 tests) +
  `test/tool/store_screenshot_compositor_write_harness_test.dart`, landed in
  commit `f694fba`) now wires the plan, renderer, and writer seams into one
  explicit entrypoint: its default path is a no-write preview (exit 0, writes
  nothing), a real write requires BOTH `--write` and `--yes` (`--write` alone
  refuses, exit 64), and a plain `dart run
  tool/store_screenshot_compositor_write.dart --write --yes` refuses (exit 70)
  because real rendering needs the Flutter engine (`dart:ui`), pointing instead
  at the Flutter-compatible harness, which wires the real `dart:ui` renderer
  through `runWriteCli` into a temp directory and verifies it composites and
  writes a PNG there without ever touching the repo's `screenshots/store/`. No
  final composited / on-disk store PNGs have been generated in the repo (`find
  screenshots/store -name composited -type d` -> no output); this changes no
  blocker status, and final composited App Store/Play PNG generation, final
  visual/design approval, native-speaker caption review, other device sizes, and
  console upload all remain owner/design work.
- **Runner note for the release-env guard test.** `dart test
  test/tool/release_env_guard_test.dart` is the wrong runner for that file - it
  imports `package:flutter_test/flutter_test.dart`, which the standalone Dart
  test runner cannot compile, so it fails on that import. That is a runner
  mismatch, not a code defect; the correct command is `flutter test
  test/tool/release_env_guard_test.dart` (38/38 after adding provider-base URL
  coverage). Local
  analyzer/test/build status is therefore clean - the release remains blocked
  by owner/proxy/store/signing/privacy-URL decisions (see §5a), not by
  engineering or local test status.
- **The 2026-06-12 work is now committed** (the earlier post-Appeeky doc
  alignment began with `29f5e6b`/`8447f96`/`b00117a` and the later
  category/listing and data-safety doc syncs continued through `c724109` — most
  recently `5c1ac56` live-quota / reviewer-note clarification and `c724109`
  post-launch ASO + privacy/GDPR/DPA checklists — all before this status sync);
  the earlier "local and uncommitted, pending the Codex-gated commit flow"
  caveat no longer applies; use the committed tree plus this document.
- **App icon visual not re-verified.** P0-7 is marked DONE from repo assets +
  commit `72d6003` + the Run A.3 history entry, not from a visual render.
- **Screenshots are raw 6.7" captures only** — the post-Appeeky 5-frame
  caption / story plan is now documented (`docs/store-listing-en.md` §5 plus the
  per-locale `screenshots/store/<locale>/README.md` + `manifest.json`, aligned
  2026-06-15), but the PNGs themselves remain pre-Appeeky raw / reference
  captures. They still need device framing, the planned marketing-caption
  compositing, native-speaker caption review, and additional device sizes before
  console upload. No composited / final listing images exist in the repo; the
  store screenshots are still source assets plus compositor tooling only, not
  final listing images.
- **EN current-plan draft frames captured (2026-06-16, commit `828620d`).** The
  two frames the post-Appeeky five-frame plan was missing - problem hook and
  life events - are now captured as RAW, clearly-labeled DRAFT scratch frames in
  `screenshots/store/en-current-draft/` (`01-problem-hook.png`,
  `02-life-events.png`) via a committed offline Demo-mode Flutter-test harness
  (`test/tool/raw_screenshot_capture_test.dart`); frames 3-5 reference the
  canonical `en` pack unchanged. `en-current-draft` is deliberately NOT a
  supported store locale, so the compositor write/dry-run pipeline never consumes
  it. No canonical `screenshots/store/<locale>` pack was overwritten, no final
  composited PNGs were generated (`find screenshots/store -name composited -type
  d` -> no output), and the guarded compositor write path
  (`tool/store_screenshot_compositor_write.dart`) is unchanged and still refuses
  final writes for the pre-Appeeky manifests. This does not change P0-9: final
  screenshot submission still requires owner/design visual approval,
  native-speaker localized caption review, additional device sizes if the
  consoles require them, caption/device compositing, and console upload - all
  owner/design work.
- **P0-4 / P0-5 docs are preparation guidance**, explicitly "not legal advice"
  and "not a submission" — they do not themselves satisfy the store
  requirement; the owner/legal/console step is the gating action.
- **Share text payload is localized in-repo (EN/DE/ES/FR/PT)** as of
  2026-06-12 via `AppLocalizations` — the Run D.4 "English-only" caveat no
  longer applies. Native-speaker review of the localized share copy remains
  owner scope; not a blocker.
- **The build remains not-submittable today** because P0-2 (keystore), P0-3,
  P0-4 (hosted URL), P0-5, P0-10, and P0-11 (key rotation) are open, plus the
  exact no-key host/rate-limit sign-off (§5a-10) and a resolvable share URL
  (§5a-9) — but every blocker is now an owner/secret/legal/backend/console
  item, not an engineering artifact.
