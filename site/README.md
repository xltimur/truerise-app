# TrueRise Static Site

Static HTML/CSS pages for `https://truerise.com.ua`.

No build step, backend, analytics, CDN, iframe, external font request, or remote
script is used. This folder is separate from the Flutter iOS and Android app.

## Pages

| URL                                            | File / directory                         | Purpose                         |
|------------------------------------------------|------------------------------------------|---------------------------------|
| `https://truerise.com.ua/`                     | `index.html`                             | English landing page            |
| `https://truerise.com.ua/uk/`                  | `uk/index.html`                          | Ukrainian landing page          |
| `https://truerise.com.ua/privacy/`             | `privacy/index.html`                     | English privacy policy          |
| `https://truerise.com.ua/uk/privacy/`          | `uk/privacy/index.html`                  | Ukrainian privacy policy        |
| `https://truerise.com.ua/support/`             | `support/index.html`                     | English support page            |
| `https://truerise.com.ua/uk/support/`          | `uk/support/index.html`                  | Ukrainian support page          |
| `https://truerise.com.ua/*birth-time*`         | guide directories                        | SEO guide pages in English      |
| `https://truerise.com.ua/uk/*chas*`            | `uk/` guide directories                  | SEO guide pages in Ukrainian    |
| `https://truerise.com.ua/sitemap.xml`          | `sitemap.xml`                            | XML sitemap for search engines  |
| `https://truerise.com.ua/robots.txt`           | `robots.txt`                             | Crawler directives              |

Legacy `privacy.html`, `support.html`, and `404.html` stay available for store
review links and point search engines to the canonical slash URLs.

## Deployment

Deploy the contents of `site/`, not the `site/` directory itself, to the
document root for `https://truerise.com.ua`.

**Correct upload target (verify path at deploy time):**

```text
/home/fv534148/truerise.com.ua/www/
```

> **WARNING — do NOT deploy into:**
> - `/home/fv534148/zootopia.kh.ua/` or any subdirectory of it
> - any WordPress installation directory (`wp-content/`, `wp-includes/`, etc.)
> - any folder belonging to an unrelated hosting account or domain
>
> Uploading to the wrong target would overwrite or contaminate an unrelated site.

Upload only public files:

```text
index.html
.htaccess
privacy.html
support.html
404.html
robots.txt
sitemap.xml
assets/
404/
privacy/
support/
uk/
how-to-find-birth-time/
natal-chart-time-accuracy/
what-is-birth-time-rectification/
```

Do not upload this README unless the hosting setup needs it.

## Store Review Checklist

- `https://truerise.com.ua/privacy.html` and
  `https://truerise.com.ua/privacy/` must be reachable before submission.
- `https://truerise.com.ua/support.html` and
  `https://truerise.com.ua/support/` must be reachable before submission.
- `support@truerise.com.ua` must be a working mailbox or forwarder before
  submission. (Owner action: create the mailbox or forwarder at the hosting
  provider after DNS is configured.)
- The privacy page must stay aligned with the app's store privacy labels.
- If the app later adds analytics, crash reporting, advertising, accounts, a new
  geocoder, or a different calculation provider flow, update the privacy page
  before shipping that build.

## Local Checks

From the repository root:

```bash
python3 -m http.server 8080 --directory site
```

Open:

```text
http://localhost:8080/
http://localhost:8080/uk/
http://localhost:8080/privacy.html
http://localhost:8080/privacy/
http://localhost:8080/support.html
http://localhost:8080/support/
http://localhost:8080/404.html
http://localhost:8080/sitemap.xml
```

Before deployment, scan the folder for remote scripts, third-party embeds,
commerce wording, and internal review tokens. The expected result is no matches.
