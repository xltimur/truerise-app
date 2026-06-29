# Google Play Console — Data Safety Form Guidance — TrueRise

**Prepared:** 2026-06-02 · **Model:** claude-opus-4-8 · **Scope:** preparation
guidance only.

> This document maps TrueRise's **verified current behavior** to the Google Play
> Console *Data safety* form so the owner can complete it accurately. It is
> **not legal advice** and is **not** a submission. Items needing an owner/legal
> decision are marked `[OWNER/LEGAL]`. Do not invent provider contract terms,
> retention periods, or a data-processing agreement.

---

## 1. How Play frames the form

For each Google **data type** you declare whether your app **collects** it
and/or **shares** it, then for each: the **purpose(s)**, whether it is
**processed ephemerally**, and whether it is **required or optional**. Separately
you declare **security practices**: whether data is **encrypted in transit** and
whether users can **request deletion**.

Google's definitions:

- **Collected** = data transmitted **off the device**.
- **Shared** = data transferred to a **third party**. Transfers to a *service
  provider* processing **on your behalf**, transfers for legal reasons, and
  fully anonymized transfers are **excluded** from "shared."

Consequence for TrueRise: **demo mode transmits nothing**, so it neither collects
nor shares. **Live mode transmits data off-device**, so the app as a whole must
declare collection based on live-mode behavior.

## 2. Verified behavior this guidance is based on

| Fact | Evidence (read-only) | Confidence |
|---|---|---|
| Demo mode = **zero** network calls (no Dio constructed) | `lib/data/repos/rectification_repository.dart`, `lib/data/api/api_client.dart` | High |
| Live mode transmits over **HTTPS** to a third-party calculation provider | `lib/data/api/rectification_api.dart`; `https://…` base URLs | High |
| Transmitted: birth date; birth time + search window; city text; lat/lon; per-event category, date, optional free-text description | `lib/data/api/dto/rectification_request_dto.dart`, `lib/data/api/mappers.dart` | High |
| Birthplace **coordinates** are precise lat/lon (4 decimals) | `docs/api-integration.md`, `lib/data/models/geo_place.dart` | High |
| Geocoding may transmit typed city search text to the configured provider/proxy or to the device's native geocoding service; the on-device stub is only a last fallback | `lib/features/calculation_flow/geocoding/geocoding_service.dart` | High |
| Secure storage holds **only** the user-supplied provider key | `lib/data/secure/secure_key_store.dart` | High |
| Local-only DB + prefs; raw response stored locally | `lib/data/db/tables.dart`, `lib/data/prefs/settings_store.dart` | High |
| **No** analytics / crash / ads / tracking SDKs | full `pubspec.yaml`; no `firebase_*`, `sentry`, `*_ads`, advertising-ID libs | High |
| **No** accounts / login | `lib/app/router.dart` | High |
| **Delete all data** wipes DB + prefs + secure key | `lib/data/repos/settings_repository.dart` | High |

## 3. Collected vs Shared — the decision for TrueRise

- **Collected: Yes** for the live-mode fields in §2 — they are transmitted off
  the device. **Purpose: App functionality.** Not for ads/marketing. Not for
  analytics.
- **Shared: `[OWNER/LEGAL]` decision.** Whether sending data to the calculation
  provider counts as "shared" depends on the provider's status:
  - If the provider (or a TrueRise backend **proxy**) acts as a **service
    provider/processor on TrueRise's behalf** under a contract/DPA → it may be
    **excluded** from "shared" (still declared as collected).
  - If the provider is an **independent third party** with no such agreement →
    declare **Shared: Yes**.
  - **Conservative default while unconfirmed: declare Shared: Yes.**
- **Processed ephemerally:** the app does not retain the transmitted data on a
  TrueRise server (it stores results **locally**). Whether the *provider*
  processes ephemerally is `[OWNER/LEGAL]` to confirm; do **not** claim ephemeral
  processing for the provider without confirmation.

## 4. Recommended answers by Google data type

Only types that apply are expanded; everything else = **Not collected, Not
shared**.

| Google category → type | Collected? | Shared? | Purpose | Required/Optional | Rationale + evidence | Confidence |
|---|---|---|---|---|---|---|
| **Location → Approximate location** | No | No | — | — | App derives no coarse device location. | High |
| **Location → Precise location** | **`[OWNER/LEGAL]`** (see §5) | `[OWNER/LEGAL]` | App functionality | Optional | Birthplace lat/lon (4 decimals) **meets Google's <3 km / precise test**, **but** it is a *birthplace the user selects*, not device location; **no** location permission is requested. Do not hide it. | Decision (key) |
| **Personal info → Other info** (Google lists **date of birth** here) | **Yes** | `[OWNER/LEGAL]` | App functionality | Required (for live result) | Birth **date** (and birth **time/window**) are transmitted in live mode. Google explicitly files date of birth under Personal info → Other info. | High |
| **Personal info → Name** | No | — | — | — | No name field. The optional calc **label** and free text *could* contain a name, but the label stays **on-device**; see free-text note below. | Medium |
| **Personal info → Email / Phone / Address / User IDs** | No | — | — | — | None collected; no accounts; no user/device ID. | High |
| **Personal info → Race/ethnicity, Political/religious beliefs, Sexual orientation** | `[OWNER/LEGAL]` | `[OWNER/LEGAL]` | App functionality | Optional | Only if a user types such content into a free-text life-event **description**. Unconstrained free text → possible. Owner/legal: decide disclosure. | Low / decision |
| **Financial info** (payment, purchase history, credit, etc.) | No | — | — | — | No payments/IAP. The `financial` event **category** is biographical text, not financial-account data. [OWNER/LEGAL confirm] | Medium |
| **Health and fitness → Health info** | `[OWNER/LEGAL]` | `[OWNER/LEGAL]` | App functionality | Optional | Life-event category `illness` (→ `health_diagnosis`), `accident`, and free-text descriptions may contain health info, **user-typed** (not from a health API). Owner/legal: decide disclosure; conservative = disclose. | Low / decision |
| **Messages / Photos / Audio / Files / Calendar / Contacts** | No | — | — | — | None of these surfaces or permissions exist. | High |
| **App activity** (interactions, in-app search history, installed apps, other user-generated content) | **`[OWNER/LEGAL]`** | `[OWNER/LEGAL]` | App functionality | Optional | The **free-text life-event descriptions** are user-generated content transmitted in live mode. Google has no generic "user content" bucket; the closest fits are **App activity → Other user-generated content** *or* **Personal info → Other info**. City search/geocoding can also transmit typed birthplace search text to a configured geocoding provider/proxy or native geocoding service; owner/legal should decide whether to disclose that under **App activity → In-app search history** or another chosen bucket. | Medium / decision |
| **Web browsing history** | No | — | — | — | None. | High |
| **App info and performance** (crash logs, diagnostics, performance) | No | No | — | — | No crash/diagnostics SDK. (README lists Crashlytics as a *future* follow-up — re-answer if added.) | High |
| **Device or other IDs** | No | No | — | — | No device/advertising ID collected. The constant `X-Rectify-App-Id` is an app-wide public identifier, not a per-user/-device ID. | High (note app-id) |

**Free-text note:** because event **descriptions** are unconstrained, the safest
posture is to either (a) disclose the broad bucket you choose for them and the
sensitive sub-types that could appear, or (b) constrain the field — an
`[OWNER/LEGAL]` + product decision.

## 5. The Precise-Location judgment call (do not hide it)

In live mode the app sends a **birthplace** latitude/longitude (e.g.,
`50.4501, 30.5234`) **when available**.

- **Conservative:** declare **Location → Precise location**, Collected: Yes,
  Shared per §3, Purpose: App functionality, **Optional** (only sent if the user
  provides a city and runs a live calc). Safer with Play review.
- **Alternative:** treat as non-location biographical data, because Google's
  Location types describe device location and the app requests **no** location
  permission and reads **no** GPS.

**Recommendation:** if uncertain, declare **Precise location** and document the
rationale. Either way, **do not omit it.** `[OWNER/LEGAL]` to finalize.

## 6. Security practices answers

- **Is all user data encrypted in transit?** **Yes.** All live requests use
  HTTPS (verified `https://` base URLs + Dio). Demo sends nothing. Confidence:
  High.
- **Do you provide a way for users to request that their data is deleted?**
  **Yes (in-app).** Settings → **Delete all data** wipes the local database, all
  preferences, and the stored API key. [OWNER/LEGAL: confirm whether users also
  need a way to request deletion of any data the **provider** may retain, and
  document that path or confirm no provider retention.]
- **Data collection is optional / user-initiated:** live transmission happens
  **only** when the user runs a live calculation; **demo mode is fully offline.**
  Within a live calc, birth date/time are required to get a result; city and
  coordinates are optional (nullable).

## 7. Ads / tracking / sale

- **No advertising or marketing** use of data.
- **No tracking**, no ad networks, no data brokers.
- **No sale** of personal data; nothing shared for advertising.
- The "no ads/tracking, no analytics, no crash SDK" claims are verified against
  the full `pubspec.yaml` dependency set.

## 8. Owner/legal checklist (Play)

- [ ] **Precise-location decision (§5):** declare birthplace coordinates as
      Precise location (conservative) or not; document the rationale.
- [ ] **Collected vs Shared (§3):** confirm whether the provider/proxy is a
      service provider (excluded from "shared") or a third party (Shared: Yes).
- [ ] **Health / sensitive personal info:** decide disclosure for `illness`/
      `accident` categories and free-text descriptions.
- [ ] **Free-text bucket:** choose App activity → Other UGC **or** Personal info
      → Other info for life-event descriptions, and stay consistent.
- [ ] **Provider retention + deletion path** for any provider-held data;
      provider privacy-policy URL; processing region(s).
- [ ] **Future SDKs:** if analytics/crash reporting (README's Crashlytics
      follow-up) is added, re-answer App info and performance.
- [ ] **Hosted policy URL:** enter the live `docs/privacy-policy.md` URL in the
      Play Console (Data safety *and* Store listing privacy fields).
- [ ] **Content rating / target audience:** confirm the questionnaire matches the
      in-app **18+** gate.

## 9. Unresolved questions

1. Provider = independent third party or contracted processor? (Drives
   Collected-vs-Shared.) — `[OWNER/LEGAL]`
2. Provider/proxy retention of request content and ephemeral-processing status.
   — `[OWNER/LEGAL]`
3. Final Precise-location classification for birthplace coordinates.
   — `[OWNER/LEGAL]`
4. Disclosure treatment of unconstrained free-text descriptions (health /
   sensitive). — `[OWNER/LEGAL]`
