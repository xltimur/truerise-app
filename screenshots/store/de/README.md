# Store Screenshots — German Tier 1 (TrueRise)

**Impl Run D.4 · 2026-06-03 · model `claude-opus-4-8`.**

Localized raw store screenshot set for **de**, captured from the shipped Flutter
UI under the German app bundle. These are real widgets, routes, and state in
offline Demo mode — not marketing mockups.

See `manifest.json` for the machine-readable details.

## Device / format

- **iPhone 6.7" / Pro Max portrait** — **1290 x 2796 px** (logical 430 x 932 @
  DPR 3.0), with safe-area insets matching the English set.
- PNG raw frames. No caption overlays, no device bezels, no fabricated screens.

## Frames

| # | File | Screen (route) | What it shows |
|---|---|---|---|
| 1 | `01-result-hero.png` | Result (`/calc/result/:id`) | German result chrome, 7:14 AM, Gemini Rising, 78% confidence, alternate candidates, DEMO pill, evidence CTA, `Ergebnis teilen`. |
| 2 | `02-evidence-breakdown.png` | Evidence (`/calc/result/:id/evidence`) | German evidence screen with STARK/MITTEL/SCHWACH match cards and localized evidence prose. |
| 3 | `03-privacy-demo-settings.png` | Settings (`/settings`) | German settings, Demo-Modus ON, optional API key, time format, delete-all-data row, bottom nav. |
| 4 | `04-share-result.png` | Result (`/calc/result/:id`) | The shipped `Ergebnis teilen` affordance in context. |
| 5 | `05-privacy-policy.png` | Privacy (`/settings/privacy`) | Bonus privacy frame: on-device storage, optional API key, offline demo, live-mode HTTPS. |

Frames 1-4 are the required set. Frame 5 is an optional bonus privacy frame.

## Share payload note

The in-app share button label is localized as **`Ergebnis teilen`**, but the
text emitted by `ShareCopyBuilder.build` is currently locale-invariant English.
This run documents the shipped behavior and does not change it. The emitted
payload is privacy-safe: it includes only estimated time, rising sign,
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
calculation through the real calculation controller and router. The locale was
forced to `de` so `MaterialApp` resolved the German ARB bundle. The harness
preloaded bundled product fonts plus `MaterialIcons` and `Lucide` package fonts
so navigation, action, and bottom-tab icons render as real glyphs.

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
