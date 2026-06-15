# Store Screenshots — Portuguese (Brazil) Tier 1 (TrueRise)

**Impl Run D.4 · 2026-06-03 · model `claude-opus-4-8`.**

Localized raw store screenshot set for **pt-BR**, captured from the shipped
Flutter UI under the app's Brazilian Portuguese content bundle (`appLocale:
pt`). These are real widgets, routes, and state in offline Demo mode — not
marketing mockups.

See `manifest.json` for the machine-readable details.

> **Caption-plan status (updated 2026-06-15).** These are **pre-Appeeky raw /
> reference captures**, not the current final caption order. The current caption
> plan is the **post-Appeeky five-frame** story order (problem hook -> life
> events -> result -> evidence -> privacy / offline demo) in
> `docs/store-listing-tier1-localized.md` §3, `docs/store-listing-en.md` §5, and
> `docs/aso-naming-strategy.md` §14.5. The frames below cover
> **result / evidence / privacy / share**; they do **not** yet include a
> problem-hook frame or a life-events input frame, so final compositing will
> likely need those new frames recaptured/added. The old **share** frame is now
> optional/bonus, not a required frame. The per-frame `intendedCaption` values in
> `manifest.json` are the historical (pre-Appeeky) overlay drafts; the current
> overlay copy is the five-frame plan in `docs/store-listing-tier1-localized.md`
> §3.

## Device / format

- **iPhone 6.7" / Pro Max portrait** — **1290 x 2796 px** (logical 430 x 932 @
  DPR 3.0), with safe-area insets matching the English set.
- PNG raw frames. No caption overlays, no device bezels, no fabricated screens.

## Frames

| # | File | Screen (route) | What it shows |
|---|---|---|---|
| 1 | `01-result-hero.png` | Result (`/calc/result/:id`) | Portuguese result chrome, 7:14 AM, Gemini Rising, 78% confidence, alternate candidates, DEMO pill, evidence CTA, `Compartilhar resultado`. |
| 2 | `02-evidence-breakdown.png` | Evidence (`/calc/result/:id/evidence`) | Portuguese evidence screen with localized match cards and evidence prose. |
| 3 | `03-privacy-demo-settings.png` | Settings (`/settings`) | Portuguese settings, demo mode ON, time format, delete-all-data row, bottom nav. |
| 4 | `04-share-result.png` | Result (`/calc/result/:id`) | The shipped `Compartilhar resultado` affordance in context. |
| 5 | `05-privacy-policy.png` | Privacy (`/settings/privacy`) | Bonus privacy frame: on-device storage, offline demo, live-mode HTTPS. |

In the original pre-Appeeky plan, the first four frames were the required set and
frame 5 an optional bonus privacy frame. Under the current five-frame plan (see
the caption-plan status note above), this raw set no longer maps one-to-one to
the required frames: the problem-hook and life-events frames are not captured
yet, and the share frame is now optional/bonus.

> **Frames 3 and 5 refreshed (2026-06-03).** Both PNGs were re-captured from the
> current simplified **Settings** and in-app **Privacy** screens, using the same
> throwaway `/tmp` widget-test harness, iPhone 6.7" geometry, and offline
> Demo-mode capture method as the rest of the set.

## Share payload note

The in-app share button label is localized as **`Compartilhar resultado`**, but
the text emitted by `ShareCopyBuilder.build` is currently locale-invariant
English. This run documents the shipped behavior and does not change it. The
emitted payload is privacy-safe: it includes only estimated time, rising sign,
confidence, and brand. It does not include birth date, birthplace, life events,
or PII.

```
My TrueRise rectification result:
7:14 AM · Gemini Rising · 78% confidence

Calculated with TrueRise — birth-time rectification
```

## Capture method

A throwaway widget-test harness under `/tmp/rectify_shotcap` rendered the real
`RectifyApp` inside a `RepaintBoundary` and wrote
`boundary.toImage(pixelRatio: 3)` to PNG. Demo mode drove the canonical 6-event
calculation through the real calculation controller and router. The store locale
is `pt-BR`; the app locale resolves to `pt`, which carries Brazilian Portuguese
content. The harness preloaded bundled product fonts plus `MaterialIcons` and
`Lucide` package fonts so navigation, action, and bottom-tab icons render as
real glyphs.

Each frame was captured in its own `flutter test` process because this local
toolchain hangs/crashes during teardown after a `toImage` capture. The wrapper
waited for a valid 1290 x 2796 PNG, then terminated the stale tester process.

## Limitations

- The native OS share sheet cannot be captured from the host Flutter test
  harness; frame 4 shows the shipped share affordance.
- Caption overlays from `docs/store-listing-tier1-localized.md` §3 are proposed
  owner-composited copy and are not baked into these raw frames.
- The share text itself remains English-only until a future product change
  localizes `ShareCopyBuilder`.
- DEMO values come from the offline canonical dataset, not a live API request.
