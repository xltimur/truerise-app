# Privacy / GDPR / DPA Checklist - TrueRise

- **Document:** `docs/privacy-gdpr-dpa-checklist.md`
- **Date:** 2026-06-15
- **Model:** `claude-opus-4-8`
- **Status:** `[DRAFT - NOT LEGAL ADVICE]`. This is a preparation checklist
  derived from TrueRise's verified, shipped behavior. It is **not legal advice**,
  has **not** been reviewed by counsel, and asserts **no** regulatory compliance.
  Every item marked **[owner/legal]** is an owner or legal decision and must be
  resolved and approved by the owner/counsel before the listing or any hosted
  policy goes live. Do not invent provider contract terms, retention periods,
  processing regions, or a DPA - fill them with real, confirmed values.
- **Linked to:** `docs/privacy-policy.md`, `docs/apple-privacy-labels.md`,
  `docs/play-data-safety.md`, `docs/proxy-contract.md`,
  `docs/api-integration.md`, `docs/store-submission-readiness.md` Sec. 12.1.

**Why this exists.** TrueRise processes **birth data + life events** and, in live
mode, transmits them to a **third-party Astrology calculation provider** (possibly
via a proxy). Birth data plus dated life events are inherently identifying about a
real person, and free-text event descriptions can contain GDPR **special-category
data** (Art. 9). That raises controller/processor, transfer, and data-subject-
rights questions the shipped code cannot answer on its own. This checklist
gathers them in one place for owner/legal sign-off.

---

## 1. Data categories in scope

From the verified data posture (`docs/apple-privacy-labels.md` Sec. 2,
`docs/play-data-safety.md` Sec. 2, `docs/privacy-policy.md`):

| Category | Field(s) | Leaves device? | Notes |
|---|---|---|---|
| Birth date | year/month/day | Yes (live mode) | Identifying when combined with the rest. |
| Birth time + search window | approx time + width, or full-day range | Yes (live mode) | The core input. |
| Birthplace | city text + lat/lon (~4 decimals) | Yes (live mode) | Precise-location classification call - see Sec. 4. Birthplace the user picks, **not** device GPS; no Location permission requested. |
| Life events | category + date + optional free-text description (<=200 chars each) | Yes (live mode) | Free text is unconstrained. |
| Special-category data (GDPR Art. 9) | health (`illness`/`accident` categories, free text), and possibly religious belief / sexual orientation typed into free text | Yes (live mode, if user types it) | The central legal flag - see Sec. 3. |
| Calculation label | optional user label | **No** (on-device only) | Not in the request DTO; stays local. |
| Provider API key | user-entered key (secure storage) | To the provider only, as the user's own credential | Never sent to a TrueRise server; not our data to control. |
| IP address | network metadata | Seen by the receiving server | Inherent to any HTTPS request; not stored by us. |

Demo mode transmits **nothing** (offline); the app is declared on **live-mode**
behavior.

---

## 2. Controller / processor questions [owner/legal]

- [ ] **Who is the controller?** Confirm the publisher legal entity (the
      `[OWNER/LEGAL]` name in `docs/privacy-policy.md`) is the data controller for
      the live-mode processing.
- [ ] **Is the calculation provider a processor or an independent controller?**
      This single answer drives Apple "linked/third-party" framing and Play
      "Collected vs Shared" (`docs/apple-privacy-labels.md` Sec. 9 Q1,
      `docs/play-data-safety.md` Sec. 3). Processor (acting on our behalf, under
      contract) -> excluded from Play "shared"; independent third party ->
      **Shared: Yes**.
- [ ] **Is there a TrueRise-operated proxy in production?** If so, who operates
      it, and does it **log or retain** request content?
      (`docs/proxy-contract.md`, `docs/apple-privacy-labels.md` Sec. 3). A logging
      proxy changes the "we run no server that stores your content" statement.
- [ ] **Legal basis for processing.** Confirm the basis (live calc is
      user-initiated - consent is the likely basis). For special-category data,
      confirm whether **explicit consent** (Art. 9(2)(a)) is required and how it
      is obtained.
- [ ] **Children / age.** The app enforces an in-app 18+ birth-date gate
      (`docs/privacy-policy.md`, Children). Confirm the gate, the store age
      rating, and the policy text all state the same minimum age.

---

## 3. Special-category / free-text data [owner/legal]

- [ ] Decide how to treat **free-text life-event descriptions**, which can carry
      health, religious, or sexual-orientation content (Art. 9).
- [ ] Choose a posture: **(a) disclose** the relevant sensitive sub-types and
      obtain explicit consent, or **(b) constrain** the field (product change), or
      **(c) both**. (`docs/apple-privacy-labels.md` Sec. 4 Health/Sensitive rows;
      `docs/play-data-safety.md` Sec. 4 health / sensitive rows.)
- [ ] Confirm the `illness`/`accident` event categories map to health data and
      whether that triggers a Health disclosure in the store forms.

---

## 4. Precise-location classification [owner/legal]

- [ ] Make and **document** the call: declare birthplace lat/lon as **Precise
      Location** (conservative, reviewer-safe) or as biographical "Other Data".
      The coordinate resolution meets Apple/Google's precise test, **but** it is a
      birthplace the user selects, with no Location permission and no GPS read
      (`docs/apple-privacy-labels.md` Sec. 5; `docs/play-data-safety.md` Sec. 5).
      Either way, **do not omit it** from disclosure.

---

## 5. DPA / SCC / subprocessor / retention / security / deletion / incidents / DSR

All **[owner/legal]**; verify against the real provider/proxy contract - do not
invent terms.

### 5.1 DPA (data-processing agreement)
- [ ] If the provider/proxy is a **processor**, a GDPR Art. 28 **DPA** is in place
      and names purpose, duration, data types, and processor obligations.
- [ ] The DPA forbids the provider using request content for its own purposes.

### 5.2 International transfers / SCC
- [ ] Confirm the provider's **processing region(s)**
      (`docs/privacy-policy.md` "International data transfers" is a `[OWNER/LEGAL]`
      blank).
- [ ] If data leaves the EEA/UK, a valid transfer mechanism is in place
      (**SCCs** / UK IDTA / adequacy) and referenced in the policy.

### 5.3 Subprocessors
- [ ] Obtain the provider's **subprocessor** list and confirm flow-down terms and
      change-notification obligations.

### 5.4 Retention
- [ ] Confirm whether the **provider** retains request content, and for how long
      (`docs/privacy-policy.md` "Data retention and deletion" `[OWNER/LEGAL]`
      blank; `docs/apple-privacy-labels.md` Sec. 9 Q2;
      `docs/play-data-safety.md` Sec. 9 Q2). On-device data is retained until the
      user deletes it.
- [ ] Confirm whether any **proxy** retains logs, and the log-retention period.

### 5.5 Security
- [ ] Confirm in-transit encryption (**HTTPS verified** for live requests) and
      the provider's security measures (Art. 32). On-device data is protected by
      OS sandboxing/passcode; there are no accounts/passwords.

### 5.6 Deletion
- [ ] In-app **Settings -> Delete all data** wipes local DB + prefs + secure key
      (verified). Confirm a path to request deletion of any **provider-held** data,
      or confirm the provider retains nothing
      (`docs/play-data-safety.md` Sec. 6).

### 5.7 Incidents / breach
- [ ] Confirm breach-notification obligations (Art. 33/34): does the provider/
      proxy notify the controller of a breach, and within what window?

### 5.8 Data-subject rights (DSR)
- [ ] Confirm how access / rectification / erasure / portability / objection /
      restriction are handled. Because there are no accounts, on-device data is
      already user-controlled and deletable in-app; the open item is the **DSR
      path for any provider/proxy-held data** and the **contact method** for
      exercising rights (`docs/privacy-policy.md` "Your privacy rights" and
      "Contact" `[OWNER/LEGAL]` blanks).

---

## 6. What this must be reflected in (consistency gate)

The decisions above must be applied consistently across all four surfaces. They
must not contradict each other.

- [ ] **Privacy policy** (`docs/privacy-policy.md`): fill the `[OWNER/LEGAL]`
      blanks - publisher legal name + controller identity, provider name + link,
      direct-to-provider vs proxy, retention, processing region(s) + transfer
      safeguards, legal basis, special-category handling, DSR contact, age. Host
      it at a public URL before submission.
- [ ] **Apple App Privacy labels** (`docs/apple-privacy-labels.md`): apply the
      precise-location call (Sec. 4), the health/sensitive call (Sec. 3), the
      linked-vs-not-linked answer, and the provider relationship; enter the hosted
      policy URL.
- [ ] **Play Data Safety** (`docs/play-data-safety.md`): apply Collected-vs-Shared
      (processor vs third party), precise-location, health/sensitive, the
      free-text bucket choice, retention/deletion, and encrypted-in-transit = yes.
- [ ] **Reviewer notes** (`docs/store-listing-en.md` Sec. 2.6 / Sec. 3.5;
      `docs/store-listing-tier1-localized.md` Sec. 2): provider handling and
      privacy posture in the notes must match the policy and the two store forms.

If any answer changes (e.g. a future analytics/crash SDK, a network geocoder, or
a different provider), re-run this checklist and update all four surfaces
**before** that release ships.

---

## 7. Sources (read-only)

- `docs/privacy-policy.md` - drafted policy with `[OWNER/LEGAL]` blanks.
- `docs/apple-privacy-labels.md` - Apple App Privacy mapping; Sec. 5 location
  call; Sec. 8/9 owner-legal checklist + unresolved questions.
- `docs/play-data-safety.md` - Play Data Safety mapping; Sec. 3 collected/shared;
  Sec. 5 location; Sec. 8/9 owner-legal checklist + unresolved questions.
- `docs/proxy-contract.md`, `docs/api-integration.md` - provider/proxy data flow.
- `docs/store-submission-readiness.md` Sec. 12.1 - owner decisions (hosted-policy
  ownership + provider/retention wording).

This document asserts no regulatory compliance and no store approval. It is a
preparation checklist for owner/legal sign-off, not a legal opinion.
