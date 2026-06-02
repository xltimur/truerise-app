# TrueRise Privacy Policy

**Effective date: June 2, 2026**

> **OWNER/LEGAL PLACEHOLDERS — read before publishing.** This policy is
> drafted from TrueRise's verified, shipped behavior so it can be hosted as a
> public web page once the owner fills every clearly marked `[OWNER/LEGAL: …]`
> blank (publisher legal name, contact email, hosted URL, governing
> jurisdiction, and any naming of the third-party calculation provider). It is
> **not legal advice**, has **not** been reviewed by counsel, and makes **no**
> claim of regulatory compliance or guaranteed app-store approval. A legal
> review is recommended before this page goes live. Do not invent the missing
> values — fill them with the real ones.

---

## At a glance

- **No accounts.** TrueRise has no sign-up, login, or user profile.
- **Your data lives on your device.** Everything you enter is stored locally.
- **Demo mode is fully offline.** It makes no network calls and uses no key.
- **Live calculations** send your birth and life-event details to a third-party
  calculation provider over an encrypted (HTTPS) connection, **only** to
  compute your result.
- **No analytics SDK, no crash reporting, no advertising, no tracking.** We do
  not sell your data and do not share it for advertising.
- **You can erase everything** from **Settings → Delete all data**, or by
  uninstalling the app.

---

## Who provides TrueRise

[OWNER/LEGAL: insert the publisher's legal name, postal address, and the
jurisdiction whose law governs this policy.] In this policy, "TrueRise," "we,"
"us," and "our" refer to that publisher; "you" means the person using the app.

TrueRise is a birth-time rectification tool: you provide an approximate birth
window and a few life events, and the app estimates a likely birth time with a
confidence band and per-event evidence.

## TrueRise has no user accounts

There is no registration, login, password, or cloud profile. We do not assign
you a user ID, and nothing you enter is uploaded to a "TrueRise account,"
because none exists.

## What you enter, and where it is stored

When you use the app you may enter: a birth date; a birthplace (city text and,
when resolved, its latitude/longitude coordinates); a time window (an
approximate time and width, or "unknown"); life events (a category, a date, and
an optional free-text description of up to 200 characters each); and an optional
label for the calculation. The app also stores the results it produces.

All of this is stored **locally on your device** — in an on-device database and
in the app's local preferences. For support and troubleshooting, the app also
keeps the raw response it receives for a live calculation in that local
database. None of this on-device content is uploaded to a server run by us (we
run none for your content).

## City search runs on your device

In this release, the birthplace you type is matched against a small built-in,
on-device list to fill in coordinates. **Your city search text is not sent to
any geocoding service.** [OWNER/LEGAL: if a future release adds a network-based
geocoder, disclose that transmission here and update the app-store privacy
labels accordingly.]

## Demo mode is offline

Demo calculations run entirely on your device. They make **no** network calls
and use **no** API key, and demo results are clearly labelled so they are not
confused with real readings.

## Live calculations — what leaves your device

When you run a **live** (non-demo) calculation, TrueRise sends the following to
a third-party birth-time **calculation provider** over an encrypted **HTTPS**
connection, **solely to compute your result**:

- your **birth date** (year, month, day);
- your **approximate birth time and the time window** you choose — or, if you
  mark the time as unknown, a full-day search range;
- the **birthplace** text and its latitude/longitude **coordinates**, when
  available;
- for each **life-event**: its **category**, its **date**, and the optional
  free-text **description** you wrote.

This data is transmitted only when you start a live calculation, only to perform
that calculation, and is **not** tied to any account (there are none) and is
**not** used by us to build a profile of you.

As with any internet request, the receiving server necessarily sees your
device's IP address as part of delivering the response.

**Reviewer note (not a permission request):** TrueRise does **not** request
device Location permission and does **not** read GPS or current-device location.
The coordinates above describe a *birthplace you select*, not where you are now.

[OWNER/LEGAL: name the calculation provider and link to its privacy policy;
confirm whether requests go directly to the provider or through a TrueRise
backend proxy; and state the provider's data-retention period, its processing
region(s), and whether a data-processing agreement is in place. Do not publish
this section as final until these are confirmed.]

## Optional provider API key

Advanced users may paste their own provider API key in **Settings**. When set,
that key is stored **only** in the platform secure store (iOS Keychain / Android
Keystore). It is never written to the local database, preferences, logs, or
crash reports, is never placed in the body of a request, and is never shown back
to you after you save it. It is used only as the credential that authorizes your
own live calculations. You can remove it at any time by clearing the field or
using **Delete all data**.

## What we do not do

- **No third-party analytics SDK.**
- **No crash reporting or diagnostics SDK.**
- **No advertising and no ad SDKs**; we use no advertising identifiers.
- **No cross-app or cross-site tracking.**
- **We do not sell your personal data**, and we do not share it for advertising
  or cross-context behavioral advertising.
- **No data brokers.**

[OWNER/LEGAL: if a future release adds analytics or crash reporting, update this
policy and the store privacy labels **before** shipping that release.]

## Data retention and deletion

- On-device data stays on your device until you remove it.
- **Settings → Delete all data** wipes the local database, all app preferences,
  and the stored API key; the wipe completes before the app returns you to
  onboarding.
- **Uninstalling** the app removes all local data.
- [OWNER/LEGAL: state the calculation provider's retention period and how a user
  can request deletion of anything the provider may retain, or confirm that the
  provider does not retain request content.]

## Children

TrueRise is intended for **adults (18+)**. The app enforces an in-app 18+
birth-date gate and is not directed to children, and we do not knowingly collect
data from anyone under 18. [OWNER/LEGAL: confirm the minimum age stated here
matches both the in-app gate and the app-store age rating.]

## Security

We use HTTPS for all live requests and store any user-supplied API key in the
platform secure store. Because there are no accounts, there is no password to be
breached. On-device data is protected by your device's own security (passcode,
biometrics, and OS sandboxing). No method of transmission or storage is 100%
secure, so we cannot guarantee absolute security.

## International data transfers

[OWNER/LEGAL: depending on where the calculation provider processes data, your
information may be transferred across borders when you run a live calculation.
State the regions and safeguards once the provider/proxy arrangement is
confirmed.]

## Your privacy rights

Depending on where you live (for example, under the EEA/UK GDPR or California's
CCPA/CPRA), you may have rights to access, correct, delete, port, or object to
the processing of your personal data. Because TrueRise stores your data on your
device and runs no accounts, you already control that data directly and can
delete it in the app at any time. [OWNER/LEGAL: add the jurisdiction-specific
rights language and the contact method/process for exercising these rights.]

## Changes to this policy

We may update this policy from time to time. When we do, we will revise the
"Effective date" above and, for material changes, highlight them in the app or
on this page.

## Contact

[OWNER/LEGAL: insert a privacy contact email address and, if required in your
jurisdiction, a postal address.]

---

## About the service

TrueRise provides astrological birth-time **estimates** for personal interest
and entertainment. It does **not** provide medical, psychological, legal, or
financial advice, and its results are **not** certain or deterministic. Use your
own judgment for any decision.
