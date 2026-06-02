# Store Screenshots — English Tier 0 (TrueRise)

**Impl Run A.5 · 2026-06-02 · model `claude-opus-4-8`.**

Owner-independent **P0** store screenshot set, captured from the **shipped
Flutter UI** (real widgets, routes, and state — not marketing mockups). These
satisfy the screenshot gate in `docs/store-submission-readiness.md` and the
4-frame storyboard in `docs/store-listing-en.md` §5.

See `manifest.json` for the machine-readable version of everything below.

## Device / format

- **iPhone 6.7" / Pro Max portrait** — **1290 × 2796 px** (logical 430 × 932 @
  DPR 3.0), with realistic notch/home-indicator safe-area insets
  (top 177 px, bottom 102 px).
- PNG, RGBA. Accepted by App Store Connect (6.7" slot) and usable for Google
  Play phone screenshots.

## Frames

| # | File | Screen (route) | What it shows |
|---|---|---|---|
| 1 | `01-result-hero.png` | Result (`/calc/result/:id`) | Most probable time **7:14 AM**, **Gemini Rising**, **78%** confidence, alternate candidates, **DEMO** pill, "See how we got this" CTA. |
| 2 | `02-evidence-breakdown.png` | Evidence (`/calc/result/:id/evidence`) | "Why 7:14 AM? 4 of 6 events strongly supported this time." Per-event **STRONG/MODERATE/WEAK** match cards. |
| 3 | `03-privacy-demo-settings.png` | Settings (`/settings`) | **Demo mode** toggle ON ("free, no network"), API key optional, time format, **Delete all data** ("Cannot be undone"). |
| 4 | `04-share-result.png` | Result (`/calc/result/:id`) | The shipped **Share result** button in context (see share-sheet note below). |
| 5 | `05-privacy-policy.png` | Privacy (`/settings/privacy`) | **Bonus.** In-app privacy disclosure: on-device storage, offline demo, live-mode HTTPS, no accounts. |

Frames 1–4 are the **required** set. Frame 5 is an optional bonus that
reinforces the privacy story; it is not one of the four mandated frames.

The marketing captions in `docs/store-listing-en.md` §5 are **intended
overlays** to be composited by the owner — they are **not** baked into these raw
frames.

## Frame 4 — share: exact text payload (privacy-safe)

The native **OS share sheet cannot be captured from the host `flutter test`
harness** (the test binding has no platform share-sheet surface). Frame 4
therefore shows the **shipped in-app "Share result" button**, which is the real
share affordance.

The text the share action emits is built by
`lib/core/sharing/share_copy_builder.dart` and is **privacy-safe** — it contains
only the estimated time, rising sign, confidence, and brand. **No birth date,
birthplace, life events, or any PII.** For the canonical demo result it is
**exactly**:

```
My TrueRise rectification result:
7:14 AM · Gemini Rising · 78% confidence

Calculated with TrueRise — birth-time rectification
```

This matches the "share without oversharing" / no-share-card guardrail in
`docs/store-listing-en.md` §6 and `docs/feature-gap-analysis.md`.

## How they were captured

A throwaway widget-test harness on the host VM rendered the real `RectifyApp`
inside a `RepaintBoundary` and wrote `boundary.toImage(pixelRatio: 3)` to PNG via
`dart:io`. **Demo mode** (offline — no network, no API key) drove a canonical
6-event calculation through the real `calculation_flow` controller, then
`go_router` navigated to each screen. Product fonts (Inter, SourceSerif4,
JetBrainsMono) were loaded from the bundled `FontManifest.json` so text renders
as real glyphs.

Each frame was captured in **its own process** (one screenshot per `flutter
test` invocation): on this toolchain the `flutter_tester` shell crashes with
SIGTERM the instant a *second* `RenderRepaintBoundary.toImage` runs in the same
isolate, but the first capture always flushes to disk first — so one-frame-per-
process yields all frames reliably. The harness lived under `/tmp` and was
removed after the run; **no `lib/`, `test/`, `assets/`, or app source was
modified**, and **no dependencies were added**.

## Limitations / owner follow-ups

- **No OS share-sheet frame** — host-harness constraint (above). Frame 4 shows
  the shipped Share button; the exact emitted text is documented above.
- **No caption overlays / device bezels** — raw resolution only. Compositing the
  §5 captions and any framing is owner work.
- **DEMO data** — values come from the offline canonical demo dataset, not a
  live calc; the **DEMO** badge is visible in-frame, consistent with the honest,
  probabilistic store framing.
- **6.7" portrait only** — the same harness can emit a Play/other-size variant by
  changing the view geometry if a second set is later required.
