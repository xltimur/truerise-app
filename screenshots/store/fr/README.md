# Store Screenshots - French Tier 1 (TrueRise)

**Impl Run D.4 + current-plan refresh · status updated 2026-07-02.**

Current five-frame store screenshot pack for `fr`. Raw PNGs are captured from the shipped Flutter UI in offline Demo mode; final caption-overlay PNGs are generated under `composited/` from the same raw frames and the reviewed caption plan in `docs/store-listing-tier1-localized.md §3`.

See `manifest.json` for machine-readable frame, payload, and generation details.

## Device / Format

- iPhone 6.7" / Pro Max portrait: 1290 x 2796 px, logical 430 x 932 @ DPR 3.0.
- Raw PNGs: no captions, no device bezels, real shipped widgets/routes/state.
- Final PNGs: `composited/<file>.png`, same pixel size, caption overlay baked in.

## Final Five-Frame Story

| # | File | Route | Caption |
|---|---|---|---|
| 1 | `01-problem-hook.png` | `/calc/window` | Vous ne connaissez pas votre heure de naissance exacte ? |
| 2 | `02-life-events.png` | `/calc/events` | Ajoutez les événements de vie dont vous vous souvenez. |
| 3 | `01-result-hero.png` | `/calc/result/:id` | Estimez votre heure de naissance et votre ascendant. |
| 4 | `02-evidence-breakdown.png` | `/calc/result/:id/evidence` | Voyez les indices derrière chaque heure candidate. |
| 5 | `03-privacy-demo-settings.png` | `/settings` | Privé par défaut. Essayez gratuitement, hors ligne. |

Raw source path: `<file>.png`. Final store-ready path: `composited/<file>.png`.

## Optional Raw Reference Frames

- `04-share-result.png` - shipped in-app share affordance, retained as a privacy-safe reference.
- `05-privacy-policy.png` - in-app privacy disclosure, retained as a backup privacy frame.

These optional raw frames are not part of the current final five-frame story unless a store-specific asset plan explicitly swaps them in.

## Share Payload Note

The share button label is localized as `Partager le résultat`. The emitted text is built by `lib/core/sharing/share_copy_builder.dart`, uses `AppLocalizations`, and remains privacy-safe: estimated time, rising sign, confidence, brand, and public share URL only. No birth date, birthplace, life events, labels, API IDs, or other PII are included.

```
Mon résultat d'heure de naissance avec TrueRise :
7:14 AM · Ascendant Gemini · Niveau de confiance : 78 %

Calculé avec TrueRise : rectification de l'heure de naissance
Trouvez votre heure de naissance : https://truerise.com.ua
```

## Capture / Generation Method

Raw frames are produced by `test/tool/raw_screenshot_capture_test.dart`: the real `RectifyApp` is rendered in a `RepaintBoundary` at store geometry, Demo mode drives the calculation flow offline, and one opt-in frame is written per `flutter test` process.

Final caption-overlay PNGs are produced by `test/tool/store_screenshot_compositor_write_harness_test.dart` through the guarded `runWriteCli` path and the real `dart:ui` renderer. The plain Dart write CLI stays no-write because it has no Flutter engine.

## Limitations

- Native OS share sheets cannot be captured by the host Flutter test binding; the optional share frame shows the in-app button instead.
- Values come from the canonical offline DEMO dataset, not a live API request.
- Only the iPhone 6.7" portrait geometry is present in this pack.
