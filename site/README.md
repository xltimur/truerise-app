# TrueRise Static Landing Site

## What this is

Plain HTML/CSS static pages for https://truerise.app.
No build step. No npm. No external dependencies until explicitly approved.
This directory is completely independent from the iOS and Android app builds.
Only the contents of site/ are deployed; site/ itself is not part of iOS or
Android builds.

## Deployment

Deploy the contents of `site/` (not the `site/` directory itself) to the
web root of https://truerise.app. Every file in `site/` maps directly to
the URL it implies:

```
site/index.html    -> https://truerise.app/
site/privacy.html  -> https://truerise.app/privacy
site/support.html  -> https://truerise.app/support
site/404.html      -> https://truerise.app/404   (configure as error page)
site/robots.txt    -> https://truerise.app/robots.txt
```

No build step is required before deploying.

## URL structure

| URL                            | File             | Purpose                              |
|--------------------------------|------------------|--------------------------------------|
| `https://truerise.app/`        | `index.html`     | Marketing landing page               |
| `https://truerise.app/privacy` | `privacy.html`   | Privacy policy (required for stores) |
| `https://truerise.app/support` | `support.html`   | Support contact page                 |
| `https://truerise.app/404`     | `404.html`       | Custom 404 error page                |

## File/directory layout

```
site/
  index.html          <- public landing / share destination
  privacy.html        <- privacy policy draft page
  support.html        <- support and FAQ page
  404.html            <- custom 404
  robots.txt          <- search crawler rules
  assets/
    styles.css        <- single shared stylesheet
    fonts/            <- self-hosted Inter, Source Serif 4, JetBrains Mono
    img/              <- brandmark, favicon, og-card
  README.md           <- this file
```

## Owner / legal placeholders

The following placeholders appear in `docs/privacy-policy.md` and must be
filled before the privacy page goes live. Each placeholder is quoted in full
so the privacy page author knows exactly what to supply.

All [OWNER/LEGAL: ...] strings must be replaced with real values before any
page referencing them is published.

1. **Privacy policy header / controller section**

        [OWNER/LEGAL: insert the publisher's legal name, postal address, and the
        jurisdiction whose law governs this policy.]

2. **Location data section**

        [OWNER/LEGAL: if a future release adds a network-based
        geocoder, disclose that transmission here and update the app-store privacy
        labels accordingly.]

3. **Calculation provider section**

        [OWNER/LEGAL: name the calculation provider and link to its privacy policy;
        confirm whether requests go directly to the provider or through a
        TrueRise-operated backend; and state the provider's data-retention period, its
        processing region(s), and whether a data-processing agreement is in place. Do
        not publish this section as final until these are confirmed.]

4. **Analytics/crash section**

        [OWNER/LEGAL: if a future release adds analytics or crash reporting, update this
        policy and the store privacy labels **before** shipping that release.]

5. **Data retention section**

        [OWNER/LEGAL: state the calculation provider's retention period and how a user
        can request deletion of anything the provider may retain, or confirm that the
        provider does not retain request content.]

6. **Children's privacy section**

        [OWNER/LEGAL: confirm the minimum age stated here
        matches both the inside-the-app gate and the app-store age rating.]

7. **International transfers section**

        [OWNER/LEGAL: depending on where the calculation provider processes data, your
        information may be transferred across borders when you run a live calculation.
        State the regions and safeguards once the provider data-flow arrangement is
        confirmed.]

8. **Rights / deletion section**

        [OWNER/LEGAL: add the jurisdiction-specific
        rights language and the contact method/process for exercising these rights.]

9. **Contact section**

        [OWNER/LEGAL: insert a privacy contact email address and, if required in your
        jurisdiction, a postal address.]

10. **Support page / footer**

        [OWNER/LEGAL: support email]

## Local checks

From the repository root, serve the folder with:

```
python3 -m http.server 8080 --directory site
```

Then open:

- `http://localhost:8080/`
- `http://localhost:8080/privacy.html`
- `http://localhost:8080/support.html`
- `http://localhost:8080/404.html`

Check that:

- There are no external font, analytics, CDN, iframe, or remote script
  requests.
- There is no monetization or key-entry copy.
- The service disclaimer appears in HTML pages and includes entertainment and
  not medical/scientific/legal/financial guarantee language.
- Owner/legal placeholders remain visible in `privacy.html`, `support.html`,
  and this README until owner/legal review supplies real values.
- Inter and JetBrains Mono are copied from app TTF assets. Source Serif 4 is
  a local WOFF generated from the app TTF to keep whole-tree text greps clean.
