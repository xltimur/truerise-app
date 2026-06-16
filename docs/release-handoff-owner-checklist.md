# Release Handoff - Owner Checklist (TrueRise)

**Purpose.** A single paste-ready handoff for the owner (Oleg) that consolidates
what is already done in the repo and what only the owner / backend / legal /
store consoles can finish. It does not change any decision; it points to the
authoritative source doc for each item.

**Authoritative status doc:** `docs/publication-readiness-current-status.md`
(per-blocker reconciliation, evidence, next-action ordering). This checklist is
a derived, condensed handoff - if anything here disagrees with that file, the
status doc wins.

**Local verification commands** for everything below live in
`docs/release-preflight-commands.md`. The latest dated run of those commands and
its exact results (2026-06-16: analyze clean, 648 tests green, release guard and
screenshot dry-run pass) is recorded in
`docs/release-verification-report-2026-06-16.md` - evidence only; it does not
unblock submission and changes no status below.

**Scope guard.** No live store rankings, installs, ratings, DNS resolution,
trademark clearance, production proxy availability, or store approvals are
asserted here. Every line that needs an owner, backend, legal, or console
action is called out as such.

---

## 1. Already prepared in-repo (owner-independent, done)

These are complete in the working tree and need no further engineering before
submission - only the owner inputs in sections 2-6.

- **Public display name = TrueRise** on both platforms and in-app
  (`CFBundleDisplayName`, `android:label`, `l10n.dart appBrandName`). P0-1.
- **18+ birth-date age gate** enforced in the date picker. P0-6.
- **Production app icon** in repo (iOS appiconset incl. 1024x1024 + Android
  adaptive icon). P0-7.
- **Store metadata finalized** (English Tier 0) in `docs/store-listing-en.md`
  and localized drafts in `docs/store-listing-tier1-localized.md`; real
  `pubspec.yaml` marketing description. P0-8. Exact values in section 3.
- **Raw 6.7" screenshots** for en/de/fr/es/pt-BR in
  `screenshots/store/<locale>/` (5 frames each + manifest + README); see
  section 6 for what remains. P0-9.
- **Release-signing wiring (Android)** - release reads `android/key.properties`
  with no debug-signing fallback; tasks fail with an actionable message when it
  is missing. Owner keystore still required (section 5). P0-2.
- **Privacy-policy app wiring** - `--dart-define=TRUERISE_PRIVACY_POLICY_URL`
  opens a validated bare-HTTPS URL from Settings, falling back to the bundled
  in-app `PrivacyPolicyScreen`. Owner-hosted URL still required (section 5). P0-4.
- **Release guards** - `tool/release_env_guard.dart` (+ the Android
  `validateReleaseBundledEnv` Gradle task) block a public release that ships the
  placeholder proxy/share URLs or an unacknowledged bundled API key.
- **Share payload localized + privacy-safe** (EN/DE/ES/FR/PT) - emits only
  time, rising sign, confidence, brand, share URL; no birth data, events, or
  coordinates. Text share and share-card image both shipped.
- **l10n pipeline** - gen-l10n EN/DE/ES/FR/PT ARBs + generated
  `AppLocalizations`, in sync.
- **Privacy/Data-Safety/GDPR draft package** authored (see section 4).
- **Post-launch ASO runbook** (`docs/post-launch-aso-plan.md`) for after the
  listing is live.

---

## 2. Owner / backend / legal / store inputs still required

The build is **not submittable today**. Every remaining blocker is an owner,
backend, legal, or console action - none is an engineering artifact. IDs map to
`docs/publication-readiness-current-status.md` section 2 / section 5a.

| # | Input | Type | Source / detail |
| --- | --- | --- | --- |
| P0-3 | Bundle-ID decision (before first store record; irreversible after) | Owner decision | `docs/bundle-id-recommendation.md` - section 5 below |
| P0-2 | Android upload keystore + Play App Signing; iOS distribution cert/profile | Owner secrets | section 5 below; `README.md` "Android signing" |
| P0-4 | Host the privacy policy at a canonical public URL | Owner hosting + legal | publish `docs/privacy-policy.md` content (fill `[OWNER/LEGAL]` blanks) |
| P0-5 | Apple privacy labels + Play Data Safety: legal sign-off + console entry | Owner + legal + console | section 4 below |
| P0-10 | Confirm category = Lifestyle in both consoles | Owner / console | `docs/store-listing-en.md` section 1 / 3.4 |
| P0-11 | Rotate the bundled demo/review key to a low-budget capped key (or remove it) | Owner secret rotation | `docs/api-integration.md` "Bundled review key" |
| - | Production proxy host + contract confirmation | Backend / owner | `docs/proxy-contract.md` - section 5 below |
| - | Resolvable share/invite landing URL (`truerise.app` is an unverified placeholder) | Owner / DNS | section 5 below |
| - | Support URL + Play support email/contact | Owner | required listing fields |
| - | Trademark clearance + App Store name availability for "TrueRise" | Owner / legal | gates metadata lock |
| - | Console character re-count + native-speaker review of localized copy/captions | Owner / content | gates localized (not EN Tier 0) listings |
| - | Age-rating questionnaires consistent with the 18+ gate; Play target audience = adults | Owner / console | - |
| - | Device matrix: is iPad / Android tablet a target? (affects screenshot sets) | Owner decision | - |

---

## 3. Exact store metadata values (ready to paste)

Canonical source: `docs/store-listing-en.md`. **Re-count every field in the
store console before locking** - App Store Connect and Play Console count glyphs
differently. Only the iOS keyword field has a load-bearing count (shown below).

### App Store (English, US)

| Field | Limit | Value to paste |
| --- | --- | --- |
| App Name | 30 | `TrueRise: Birth Time Finder` (~27) |
| Subtitle | 30 | `Estimate your rising sign` (~25) |
| iOS keyword field | 100 | `rectify,ascendant,natal,chart,calculator,unknown,horoscope,astrology,houses,zodiac,moon,sun` (91/100) |
| Promotional Text | 170 | `docs/store-listing-en.md` section 2.3 (~138) |
| Full Description | 4000 | `docs/store-listing-en.md` section 2.4 |
| App Review Notes | - | `docs/store-listing-en.md` section 2.6 (replace `[OWNER: hosted URL]`) |
| Primary category | - | **Lifestyle** (post-Appeeky; supersedes the old Utilities posture) |

### Google Play (English, en-US)

| Field | Limit | Value to paste |
| --- | --- | --- |
| Title | 30 | `TrueRise: Birth Time Finder` (~27) |
| Short description | 80 | `Estimate your birth time, rising sign & natal chart from life events.` (~69) |
| Full description | 4000 | `docs/store-listing-en.md` section 3.3 |
| Reviewer notes | - | `docs/store-listing-en.md` section 3.5 (replace `[OWNER: hosted URL]`) |
| Category | - | **Lifestyle** |

- **Brand stays English** in every locale; only the descriptor tail localizes.
- **Localized listings (de/fr/es/pt-BR):** drafts in
  `docs/store-listing-tier1-localized.md`. Do not publish a locale until
  native-speaker review + per-locale console re-count are done. English Tier 0
  can ship first.
- **Compliance guardrails** (no deterministic/fortune-telling claims, astrology
  as method not promise, privacy-safe sharing only): `docs/store-listing-en.md`
  section 6. Apply to every visible surface and every later metadata edit.

---

## 4. Privacy / data-safety docs to review (legal sign-off + console entry)

All four are owner/legal drafts, explicitly **not legal advice and not a
submission**. They map the verified live-mode data flow (birth date, birth-time
estimate, precise birthplace coordinates, free-text life-event descriptions sent
to a third-party provider over HTTPS; demo mode fully offline; no
analytics/tracking SDKs).

| Doc | Owner action |
| --- | --- |
| `docs/privacy-policy.md` | Fill `[OWNER/LEGAL]` blanks; host at the canonical URL; name the third-party provider + its retention |
| `docs/apple-privacy-labels.md` | Legal sign-off; enter the App Privacy labels in App Store Connect |
| `docs/play-data-safety.md` | Legal sign-off; complete the Data Safety form in Play Console (incl. precise-location classification + Collected-vs-Shared call) |
| `docs/privacy-gdpr-dpa-checklist.md` | Resolve controller/processor, DPA/SCC/subprocessor, retention, deletion, and data-subject-rights decisions |

Keep the hosted policy, both store forms, the in-app privacy copy, and the
reviewer notes mutually consistent (especially the third-party transmission and
the "no tracking" declaration).

---

## 5. Proxy / signing / URL inputs (exact keys)

Non-secret release config is supplied at build time via `--dart-define`
(`README.md` "Environment configuration"). None of these values are secrets;
the real provider/billing credentials live only on the proxy, server-side.

**Proxy (backend) - `docs/proxy-contract.md`:**

- `RECTIFY_PROXY_BASE_URL` - real HTTPS proxy host, host-only origin (no path).
  Default `https://proxy.invalid.example` is a placeholder and **blocks** a
  public release.
- `RECTIFY_PROXY_PATH` - rectification endpoint path; default
  `/v1/rectification`. Only required if the final path differs.
- `RECTIFY_PROXY_APP_ID` - public app id sent as `X-Rectify-App-Id` (not a
  secret; must match what the proxy expects).
- Backend must enforce the free-tier quota (3 live requests / rolling 24h)
  server-side and return the documented 429 shape. The on-device counter is UX
  only, not real protection.

**Share / privacy URLs:**

- `TRUERISE_SHARE_URL` - real resolvable bare-HTTPS landing/store URL. Default
  `https://truerise.app` is an **unverified placeholder** (a `curl` does not
  resolve it today); register/own it or supply the real URL. Must be bare HTTPS,
  no query/fragment/userinfo.
- `TRUERISE_PRIVACY_POLICY_URL` - the same canonical privacy URL used in the
  store consoles; bare HTTPS. Empty default keeps the in-app fallback screen.

**Signing - `README.md` "Android signing":**

- Android: create `android/key.properties` (`storePassword`, `keyPassword`,
  `keyAlias`, `storeFile`) + the `.jks`/`.keystore`; enroll in Play App Signing.
  Both files stay git-ignored.
- iOS: distribution certificate + provisioning profile in Xcode / App Store
  Connect.

**Demo/review key - `docs/api-integration.md`:**

- The tracked `.env` bundles `ASTRO_API_KEY` as an asset (extractable from any
  public binary). Before a public build, **either** remove it **or** rotate it
  to a low-budget, capped, rotatable review key and acknowledge it explicitly
  (`--allow-bundled-key --purpose=review-capped`).

---

## 6. Screenshot finalization status

- **What exists:** raw 6.7" (1290x2796) captures for en/de/fr/es/pt-BR in
  `screenshots/store/<locale>/` (5 frames each + `manifest.json` + `README.md`).
  These are **pre-Appeeky raw / reference** captures, not final listing images.
- **Draft scratch frames:** the two frames the current five-frame plan was
  missing (problem hook, life events) are captured as clearly-labeled RAW DRAFTs
  in `screenshots/store/en-current-draft/` (deliberately not a supported store
  locale, so the compositor pipeline never consumes it).
- **No composited / final PNGs exist** in the repo
  (`find screenshots/store -name composited -type d` returns nothing). The
  compositor tooling is no-write/guarded; final writes are deliberately hard to
  trigger.
- **Current caption plan:** post-Appeeky 5-frame story order (problem hook ->
  life events -> result -> evidence -> privacy/offline demo) in
  `docs/store-listing-en.md` section 5.
- **Remaining owner/design work:** device framing + caption compositing,
  native-speaker localized caption review, any additional device sizes the
  consoles require, final visual/design approval, and console upload. None of
  this is an engineering blocker.

---

## 7. Recommended next owner action order

Roughly dependency-ordered; items 3-8 can run in parallel once 1-2 are decided.

1. **Bundle-ID decision** (P0-3). Recommended first-publish rebrand
   `app.astrolium.truerise` (fallbacks `com.astrolium.truerise`,
   `com.truerise.app`); code stays `com.rectify.rectify` until explicit
   approval. Irreversible after the first store record - gates record creation.
2. **Trademark clearance + name availability** for "TrueRise" - gates metadata
   lock.
3. **Release signing material** (P0-2) - Android upload keystore + Play App
   Signing enrollment; iOS distribution cert/profile.
4. **Host the privacy policy** (P0-4) at a canonical URL; build with
   `TRUERISE_PRIVACY_POLICY_URL` and use the same URL in both consoles.
5. **Legal sign-off + console entry** of Apple privacy labels and Play Data
   Safety (P0-5), using the section 4 drafts.
6. **Stand up the production proxy** per `docs/proxy-contract.md`; confirm host +
   endpoint path; supply `RECTIFY_PROXY_BASE_URL` (+ `RECTIFY_PROXY_PATH` if it
   differs) at build time.
7. **Resolvable share URL** - register/own `truerise.app` or supply the real
   `TRUERISE_SHARE_URL`.
8. **Rotate the demo/review key** (P0-11) to a low-budget capped key, or remove
   it from `.env`.
9. **Confirm category = Lifestyle** (P0-10), complete age-rating questionnaires
   consistent with the 18+ gate, provide the support URL/email.
10. **Run the preflight** (`docs/release-preflight-commands.md`), build the
    release artifacts, finalize screenshots, and submit **English Tier 0** under
    Lifestyle; follow with localized listings after native-speaker review.
