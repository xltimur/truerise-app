# Store Screenshots - English CURRENT-PLAN DRAFT (TrueRise)

**DRAFT / NOT FINAL.** Captured 2026-06-16, model `claude-opus-4-8`.

This folder is a **draft scratch set** for the **current post-Appeeky
five-frame** store story order. It is **not** a shipped locale pack and it does
**not** replace or modify the canonical `screenshots/store/en` pack.

`en-current-draft` is intentionally **not** a supported store locale, so the
compositor dry-run / write pipeline (which only iterates the supported locales)
can never pick these frames up, and `rawScreenshotPath` /
`resolveCompositedTarget` reject the segment. See
`manifest.json` for the machine-readable version of everything below.

## Why this exists

The canonical `screenshots/store/{en,de,fr,es,pt-BR}` packs are valid raw
captures, but they pre-date the current five-frame plan in
`docs/store-listing-en.md` Sec. 5 (problem hook -> life events -> result ->
evidence -> privacy / offline demo). They cover result / evidence / privacy /
share but are **missing** a problem-hook frame and a life-events input frame.

This draft adds **only the two missing raw frames**, captured from the shipped
UI, and **references** (does not copy) the existing canonical frames that still
fit the current plan.

## Frames (current five-frame plan)

| # | File | Origin | Screen | Caption (owner-composited later) |
|---|------|--------|--------|----------------------------------|
| 1 | `01-problem-hook.png` | captured here (DRAFT) | TimeWindowScreen (`/calc/window`) | `Don't know your exact birth time?` |
| 2 | `02-life-events.png` | captured here (DRAFT) | LifeEventsScreen (`/calc/events`) | `Add the life events you remember.` |
| 3 | `../en/01-result-hero.png` | reference to canonical pack | ResultScreen | `Estimate your birth time and rising sign.` |
| 4 | `../en/02-evidence-breakdown.png` | reference to canonical pack | EvidenceScreen | `See the evidence behind every candidate.` |
| 5 | `../en/03-privacy-demo-settings.png` | reference to canonical pack | SettingsScreen | `Private by default. Try it free, offline.` |

The **share** frame (`../en/04-share-result.png`) is now **optional / bonus**
under the current plan, not one of the required five.

## Device / format

iPhone 6.7" / Pro Max portrait, **1290 x 2796 px** (logical 430 x 932 at DPR
3.0), PNG RGBA, with the same safe-area insets (top 177 px, bottom 102 px) as
the canonical pack. Captions are **not** baked in; overlay compositing and any
device framing are owner work.

## How the two new frames were captured

Committed harness: `test/tool/raw_screenshot_capture_test.dart`. It renders the
real `RectifyApp` inside a `RepaintBoundary` at the 1290 x 2796 store geometry,
drives a canonical offline **Demo-mode** flow (no network) through the real
`calculation_flow` controller and `go_router`, loads all bundled fonts (text +
MaterialIcons + Lucide) so glyphs and icons render real, and encodes one frame
via `RenderRepaintBoundary.toImage(pixelRatio: 3)`.

The harness writes **nothing** to the repository on a normal `flutter test`
run. Real on-disk writes happen **only** under an explicit env opt-in, one frame
per process (the `flutter_tester` shell hangs at finalization after a boundary
capture, so each frame needs its own process):

```
RECTIFY_CAPTURE_RAW_SCREENSHOTS=1 RECTIFY_CAPTURE_FRAME=problem-hook \
  flutter test test/tool/raw_screenshot_capture_test.dart
RECTIFY_CAPTURE_RAW_SCREENSHOTS=1 RECTIFY_CAPTURE_FRAME=life-events \
  flutter test test/tool/raw_screenshot_capture_test.dart
```

Each opt-in run flushes its PNG, then is expected to time out (the documented
finalization hang); verify the file on disk afterward. Every write path is
routed through `draftRawScreenshotPath`, which can only ever resolve inside this
draft folder, never a canonical `screenshots/store/<locale>` pack.

## Limitations / owner follow-ups

- **DRAFT only.** No caption overlays, no device bezels, no composited PNGs.
- **Frames 3-5 are references**, not copies; the canonical `en` pack is
  unchanged.
- **DEMO data** drives the referenced result / evidence frames; the DEMO badge
  is visible in-frame, consistent with the honest, probabilistic framing.
- Final listing assets still require: owner caption review, overlay / device
  compositing, any additional device sizes, and store-console upload. None of
  that is done here.
