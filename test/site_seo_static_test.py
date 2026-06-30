import json
import re
import unittest
from html.parser import HTMLParser
from pathlib import Path
from xml.etree import ElementTree


ROOT = Path(__file__).resolve().parents[1]
SITE = ROOT / "site"
CANONICAL_HOST = "truerise.com.ua"
CANONICAL_ORIGIN = f"https://{CANONICAL_HOST}"
APP_STORE_URL = "https://apps.apple.com/app/truerise-birth-time-finder/id6783427864"
PLAY_STORE_URL = "https://play.google.com/store/apps/details?id=ua.com.truerise.app"


CANONICAL_PAGES = [
    SITE / "index.html",
    SITE / "uk" / "index.html",
    SITE / "support" / "index.html",
    SITE / "uk" / "support" / "index.html",
    SITE / "privacy" / "index.html",
    SITE / "uk" / "privacy" / "index.html",
    SITE / "what-is-birth-time-rectification" / "index.html",
    SITE / "uk" / "rektyfikatsiya-chasu-narodzhennya" / "index.html",
    SITE / "how-to-find-birth-time" / "index.html",
    SITE / "uk" / "yak-diznatysya-chas-narodzhennya" / "index.html",
    SITE / "natal-chart-time-accuracy" / "index.html",
    SITE / "uk" / "tochnist-chasu-narodzhennya-natalna-karta" / "index.html",
]

ARTICLE_PAGES = [
    SITE / "what-is-birth-time-rectification" / "index.html",
    SITE / "uk" / "rektyfikatsiya-chasu-narodzhennya" / "index.html",
    SITE / "how-to-find-birth-time" / "index.html",
    SITE / "uk" / "yak-diznatysya-chas-narodzhennya" / "index.html",
    SITE / "natal-chart-time-accuracy" / "index.html",
    SITE / "uk" / "tochnist-chasu-narodzhennya-natalna-karta" / "index.html",
]

SUPPORT_PAGES = [
    SITE / "support" / "index.html",
    SITE / "uk" / "support" / "index.html",
]


class HeadParser(HTMLParser):
    def __init__(self):
        super().__init__()
        self.meta = []
        self.links = []
        self.json_ld = []
        self._inside_json_ld = False
        self._json_ld_parts = []

    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        if tag == "meta":
            self.meta.append(attrs)
        elif tag == "link":
            self.links.append(attrs)
        elif tag == "script" and attrs.get("type") == "application/ld+json":
            self._inside_json_ld = True
            self._json_ld_parts = []

    def handle_endtag(self, tag):
        if tag == "script" and self._inside_json_ld:
            self.json_ld.append("".join(self._json_ld_parts).strip())
            self._inside_json_ld = False
            self._json_ld_parts = []

    def handle_data(self, data):
        if self._inside_json_ld:
            self._json_ld_parts.append(data)


def parse_page(path):
    parser = HeadParser()
    parser.feed(path.read_text(encoding="utf-8"))
    return parser


def json_ld_items(path):
    items = []
    for raw in parse_page(path).json_ld:
        data = json.loads(raw)
        if isinstance(data, dict) and isinstance(data.get("@graph"), list):
            items.extend(data["@graph"])
        else:
            items.append(data)
    return items


def items_by_type(path, schema_type):
    return [item for item in json_ld_items(path) if item.get("@type") == schema_type]


def meta_content(path, key, value):
    for meta in parse_page(path).meta:
        if meta.get(key) == value:
            return meta.get("content", "")
    return ""


class SiteSeoStaticTest(unittest.TestCase):
    def test_htaccess_canonicalizes_https_non_www(self):
        htaccess = (SITE / ".htaccess").read_text(encoding="utf-8")

        self.assertIn("RewriteEngine On", htaccess)
        self.assertIn("RewriteCond %{HTTP_HOST} !^truerise\\.com\\.ua$ [NC]", htaccess)
        self.assertIn("RewriteCond %{HTTP:X-Forwarded-Proto} =http", htaccess)
        self.assertIn("https://truerise.com.ua/", htaccess)
        self.assertIn("[R=301,L]", htaccess)

    def test_public_pages_include_social_image_dimensions(self):
        for page in CANONICAL_PAGES:
            with self.subTest(page=page.relative_to(ROOT)):
                self.assertEqual(
                    meta_content(page, "property", "og:image:width"),
                    "1200",
                )
                self.assertEqual(
                    meta_content(page, "property", "og:image:height"),
                    "630",
                )

    def test_landing_software_application_schema_lists_both_stores(self):
        for page in [SITE / "index.html", SITE / "uk" / "index.html"]:
            with self.subTest(page=page.relative_to(ROOT)):
                software = items_by_type(page, "SoftwareApplication")
                self.assertEqual(len(software), 1)
                app = software[0]

                operating_systems = app.get("operatingSystem")
                download_urls = app.get("downloadUrl")
                same_as = app.get("sameAs")

                self.assertIsInstance(operating_systems, list)
                self.assertIn("Android", operating_systems)
                self.assertIn("iOS", operating_systems)
                self.assertIsInstance(download_urls, list)
                self.assertIn(PLAY_STORE_URL, download_urls)
                self.assertIn(APP_STORE_URL, download_urls)
                self.assertIsInstance(same_as, list)
                self.assertIn(PLAY_STORE_URL, same_as)
                self.assertIn(APP_STORE_URL, same_as)
                self.assertEqual(app.get("@id"), f"{CANONICAL_ORIGIN}/#software")

    def test_landing_has_website_schema(self):
        for page in [SITE / "index.html", SITE / "uk" / "index.html"]:
            with self.subTest(page=page.relative_to(ROOT)):
                website = items_by_type(page, "WebSite")
                self.assertEqual(len(website), 1)
                self.assertEqual(website[0].get("@id"), f"{CANONICAL_ORIGIN}/#website")
                self.assertEqual(website[0].get("url"), f"{CANONICAL_ORIGIN}/")

    def test_support_pages_include_faqpage_schema(self):
        for page in SUPPORT_PAGES:
            with self.subTest(page=page.relative_to(ROOT)):
                faq_pages = items_by_type(page, "FAQPage")
                self.assertEqual(len(faq_pages), 1)
                main_entity = faq_pages[0].get("mainEntity")
                self.assertIsInstance(main_entity, list)
                self.assertGreaterEqual(len(main_entity), 6)
                for entry in main_entity:
                    self.assertEqual(entry.get("@type"), "Question")
                    self.assertTrue(entry.get("name"))
                    accepted_answer = entry.get("acceptedAnswer")
                    self.assertIsInstance(accepted_answer, dict)
                    self.assertEqual(accepted_answer.get("@type"), "Answer")
                    self.assertTrue(accepted_answer.get("text"))

    def test_article_schema_has_dates_author_and_main_entity(self):
        for page in ARTICLE_PAGES:
            with self.subTest(page=page.relative_to(ROOT)):
                articles = items_by_type(page, "Article")
                self.assertEqual(len(articles), 1)
                article = articles[0]
                self.assertRegex(article.get("datePublished", ""), r"^2026-06-[0-9]{2}$")
                self.assertEqual(article.get("dateModified"), "2026-06-30")
                self.assertEqual(article.get("author", {}).get("name"), "TrueRise")
                self.assertTrue(article.get("mainEntityOfPage", {}).get("@id", "").startswith(CANONICAL_ORIGIN))

    def test_sitemap_has_lastmod_for_each_canonical_url(self):
        xml = (SITE / "sitemap.xml").read_text(encoding="utf-8")
        tree = ElementTree.fromstring(xml)
        namespace = {"sm": "http://www.sitemaps.org/schemas/sitemap/0.9"}
        urls = tree.findall("sm:url", namespace)
        self.assertEqual(len(urls), 12)

        for node in urls:
            loc = node.findtext("sm:loc", namespaces=namespace)
            lastmod = node.findtext("sm:lastmod", namespaces=namespace)
            with self.subTest(loc=loc):
                self.assertTrue(loc.startswith(CANONICAL_ORIGIN))
                self.assertEqual(lastmod, "2026-06-30")


if __name__ == "__main__":
    unittest.main()
