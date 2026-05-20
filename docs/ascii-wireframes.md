# ASCII Wireframes: Rectify MVP

**Version:** 0.1
**Date:** 2026-05-19
**For:** Design handoff — these wireframes define layout, hierarchy, and content for each screen.
**Not:** Pixel-perfect mockups. Typography, color, spacing, and component details are for the design system phase.

**Conventions:**
- `[ ]` = tap target / button
- `( )` = radio / toggle option
- `[___]` = text input field
- `▓▓▓▓` = filled progress / confidence bar
- `░░░░` = unfilled bar
- `◉` = selected radio; `○` = unselected
- `≡` = menu / list icon
- `×` = close / delete
- `‹` = back navigation
- `›` = forward / chevron

---

## Screen 1 — Onboarding (3-slide flow)

### Slide 1 of 3 — What is birth time rectification?

```
┌────────────────────────────┐
│                            │
│                            │
│         [ILLUSTRATION]     │
│     clock + birth chart    │
│         (80×80 px)         │
│                            │
│  Your birth chart depends  │
│    on your exact birth     │
│         time.              │
│                            │
│  Most people only know an  │
│  approximate time — or     │
│  nothing at all.           │
│                            │
│  Rectify narrows it down   │
│  using events from your    │
│  life.                     │
│                            │
│   ●  ○  ○                  │
│                            │
│  ┌──────────────────────┐  │
│  │       Next ›         │  │
│  └──────────────────────┘  │
│                            │
│         Skip               │
└────────────────────────────┘
```

**Notes:**
- Illustration: simple, non-mystical. Clock hands + abstract chart wheel outline.
- "Skip" goes directly to Birth Data Input (equivalent to tapping through all 3 slides).
- Dots: 3-dot progress indicator, tappable.

---

### Slide 2 of 3 — How it works

```
┌────────────────────────────┐
│                            │
│  How Rectify works         │
│                            │
│  ① Enter your birth date   │
│     and approximate time   │
│                            │
│  ② Add events from your    │
│     life — marriage, job   │
│     changes, moves, more   │
│                            │
│  ③ We calculate the most   │
│     probable birth time    │
│     and show you why       │
│                            │
│  The more events you       │
│  add, the more accurate    │
│  the result.               │
│                            │
│   ○  ●  ○                  │
│                            │
│  ┌──────────────────────┐  │
│  │       Next ›         │  │
│  └──────────────────────┘  │
│                            │
│         Skip               │
└────────────────────────────┘
```

**Notes:**
- Numbered steps are the key content. Keep copy short.
- Last line sets expectation: more events = better. Important for funnel.

---

### Slide 3 of 3 — Try it

```
┌────────────────────────────┐
│                            │
│                            │
│   Ready to find your       │
│   birth time?              │
│                            │
│                            │
│  ┌──────────────────────┐  │
│  │   Try demo first     │  │
│  └──────────────────────┘  │
│                            │
│  ┌──────────────────────┐  │
│  │  Start real          │  │
│  │  calculation         │  │
│  └──────────────────────┘  │
│                            │
│                            │
│  A demo shows you a        │
│  sample result first, with │
│  no account needed.        │
│                            │
│   ○  ○  ●                  │
│                            │
│                            │
└────────────────────────────┘
```

**Notes:**
- "Try demo first" is primary CTA (higher button, outlined or filled). Conversion research shows demo mode is critical.
- No price or payment shown — monetization is deferred to V1.5 (see mvp-scope.md). "Start real calculation" runs against configured API access, not a paywall.
- No "Skip" on this slide — the two CTAs replace it.

---

## Screen 2 — Birth Data Input

```
┌────────────────────────────┐
│ ‹  New Calculation         │
├────────────────────────────┤
│                            │
│  Step 1 of 3               │
│  ▓▓▓▓▓▓▓░░░░░░░░░░░░░░░░░  │
│                            │
│  Birth details             │
│                            │
│  Date of birth             │
│  ┌──────────────────────┐  │
│  │  March 15, 1990  ›   │  │
│  └──────────────────────┘  │
│                            │
│  City of birth             │
│  ┌──────────────────────┐  │
│  │  Kyiv, Ukraine    ×  │  │
│  └──────────────────────┘  │
│                            │
│  Label (optional)          │
│  ┌──────────────────────┐  │
│  │  My calculation      │  │
│  └──────────────────────┘  │
│  Used to identify this     │
│  calculation in history    │
│                            │
│                            │
│  ┌──────────────────────┐  │
│  │     Continue ›       │  │
│  └──────────────────────┘  │
│                            │
└────────────────────────────┘
```

**Notes:**
- Date of birth: taps open native date picker (iOS wheel / Android material picker).
- City of birth: text field with live autocomplete dropdown (geocoding). Show first 5 results. × clears the field.
- City field shows flag/country when resolved.
- Step 1 of 3 progress bar at top. Keeps user oriented.
- "Continue" is disabled until date and city are both valid.

---

### City search dropdown (inline)

```
┌────────────────────────────┐
│                            │
│  City of birth             │
│  ┌──────────────────────┐  │
│  │  Kyi|               │  │
│  └──────────────────────┘  │
│  ┌──────────────────────┐  │
│  │ 🇺🇦  Kyiv, Ukraine    │  │
│  ├──────────────────────┤  │
│  │ 🇸🇾  Qamishlī, Syria  │  │
│  ├──────────────────────┤  │
│  │ 🇺🇦  Kyiv Oblast, UA  │  │
│  └──────────────────────┘  │
│                            │
└────────────────────────────┘
```

---

## Screen 3 — Time Window Setup

```
┌────────────────────────────┐
│ ‹  New Calculation         │
├────────────────────────────┤
│                            │
│  Step 2 of 3               │
│  ▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░░░░░  │
│                            │
│  Do you know an            │
│  approximate birth time?   │
│                            │
│  ┌──────────────────────┐  │
│  │ ◉ I have an approx.  │  │
│  │   time               │  │
│  └──────────────────────┘  │
│  ┌──────────────────────┐  │
│  │ ○ I have no idea     │  │
│  └──────────────────────┘  │
│                            │
│  Approximate time          │
│  ┌──────────────────────┐  │
│  │   7:00 AM        ›   │  │
│  └──────────────────────┘  │
│                            │
│  Search window             │
│  ┌──────────────────────┐  │
│  │   ± 2 hours      ›   │  │
│  └──────────────────────┘  │
│                            │
│  We'll search between      │
│  5:00 AM and 9:00 AM       │
│                            │
│  A wider window gives      │
│  more candidates but may   │
│  reduce precision.         │
│                            │
│  ┌──────────────────────┐  │
│  │     Continue ›       │  │
│  └──────────────────────┘  │
└────────────────────────────┘
```

**Notes:**
- Selecting "I have no idea" hides the time picker and window fields. Shows: "We'll search the full 24-hour range."
- Window picker options: ±30 min, ±1 hr, ±2 hr, ±3 hr, ±6 hr. Rendered as bottom sheet selector or segmented control.
- Dynamic copy below window picker shows the calculated range in human time (e.g., "5:00 AM – 9:00 AM").
- Time picker: native bottom sheet (iOS scroll wheel / Android time picker).

---

### "I have no idea" selected state

```
┌────────────────────────────┐
│                            │
│  ┌──────────────────────┐  │
│  │ ○ I have an approx.  │  │
│  │   time               │  │
│  └──────────────────────┘  │
│  ┌──────────────────────┐  │
│  │ ◉ I have no idea     │  │
│  └──────────────────────┘  │
│                            │
│  We'll search the entire   │
│  24-hour range. This may   │
│  produce more candidates   │
│  with lower confidence.    │
│                            │
│  Adding more life events   │
│  will help narrow it down. │
│                            │
└────────────────────────────┘
```

---

## Screen 4 — Life Events Input

### Empty state (first open)

```
┌────────────────────────────┐
│ ‹  New Calculation         │
├────────────────────────────┤
│                            │
│  Step 3 of 3               │
│  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░  │
│                            │
│  Life events               │
│                            │
│  Add memorable events from │
│  your life. The more you   │
│  add, the better.          │
│                            │
│  ╔══════════════════════╗  │
│  ║  Add at least 5      ║  │
│  ║  events for a real   ║  │
│  ║  calculation. 3 for  ║  │
│  ║  a demo.             ║  │
│  ╚══════════════════════╝  │
│                            │
│                            │
│       (empty area)         │
│                            │
│                            │
│  ┌──────────────────────┐  │
│  │   + Add first event  │  │
│  └──────────────────────┘  │
│                            │
│  ┌──────────────────────┐  │
│  │  Calculate  (demo)   │  │
│  └──────────────────────┘  │
└────────────────────────────┘
```

---

### With events added

```
┌────────────────────────────┐
│ ‹  New Calculation         │
├────────────────────────────┤
│  Step 3 of 3               │
│  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  │
│                            │
│  Life events  (5 added)    │
│                            │
│  ┌──────────────────────┐  │
│  │ 💍 Marriage          │  │
│  │    June 2018         │  │
│  │    "Got married"     │  │
│  │                   ×  │  │
│  └──────────────────────┘  │
│                            │
│  ┌──────────────────────┐  │
│  │ 💼 Career change     │  │
│  │    Sep 2015          │  │
│  │                   ×  │  │
│  └──────────────────────┘  │
│                            │
│  ┌──────────────────────┐  │
│  │ 🏠 Relocation        │  │
│  │    Mar 2012          │  │
│  │    "Moved to Kyiv"   │  │
│  │                   ×  │  │
│  └──────────────────────┘  │
│                            │
│  ┌──────────────────────┐  │
│  │ 👶 Birth of child    │  │
│  │    Nov 2020          │  │
│  │                   ×  │  │
│  └──────────────────────┘  │
│                            │
│  ┌──────────────────────┐  │
│  │ 📚 Education         │  │
│  │    Jun 2008          │  │
│  │    "Graduated"       │  │
│  │                   ×  │  │
│  └──────────────────────┘  │
│                            │
│  ┌──────────────────────┐  │
│  │   + Add event        │  │
│  └──────────────────────┘  │
│                            │
│  ┌──────────────────────┐  │
│  │      Calculate       │  │
│  └──────────────────────┘  │
└────────────────────────────┘
```

**Notes:**
- Emoji icons per category (optional — icon set to be confirmed in design).
- × on each card deletes the event (no confirmation for delete).
- "Calculate" button shows "Calculate (demo)" in demo mode, "Calculate" in real mode. No price/payment in MVP — monetization deferred to V1.5.
- Button is disabled below 3 events in demo mode, below 5 shows a soft warning tooltip but doesn't block.
- Events are reorderable via long-press drag (optional for MVP — can defer to V1.5).

---

### Add Event — Bottom sheet

```
┌────────────────────────────┐
│                            │
│  Add life event            │
│  ─────────────────────     │
│                            │
│  Category                  │
│  ┌──────────────────────┐  │
│  │  Choose category  ›  │  │
│  └──────────────────────┘  │
│                            │
│  Date                      │
│  ┌──────────┐ ┌──────────┐ │
│  │ Month ›  │ │  Year ›  │ │
│  └──────────┘ └──────────┘ │
│  (Month is optional)       │
│                            │
│  Description (optional)    │
│  ┌──────────────────────┐  │
│  │                      │  │
│  │                      │  │
│  └──────────────────────┘  │
│  0 / 200                   │
│                            │
│  ┌──────────────────────┐  │
│  │      Add event       │  │
│  └──────────────────────┘  │
└────────────────────────────┘
```

---

### Category Picker (bottom sheet within bottom sheet)

```
┌────────────────────────────┐
│  Select category           │
│  ─────────────────────     │
│                            │
│  💍 Marriage / Partnership │
│  ────────────────────────  │
│  💔 Divorce / Separation   │
│  ────────────────────────  │
│  💼 Career change          │
│  ────────────────────────  │
│  📉 Job loss               │
│  ────────────────────────  │
│  🏠 Relocation (major)     │
│  ────────────────────────  │
│  👶 Birth of child         │
│  ────────────────────────  │
│  🕯️ Death of family member │
│  ────────────────────────  │
│  🏥 Major illness/surgery  │
│  ────────────────────────  │
│  🚑 Accident or injury     │
│  ────────────────────────  │
│  📚 Education milestone    │
│  ────────────────────────  │
│  💰 Financial turning pt.  │
│  ────────────────────────  │
│  ✦ Other                   │
│                            │
└────────────────────────────┘
```

---

## Screen 5 — Calculation Loading

```
┌────────────────────────────┐
│                            │
│                            │
│                            │
│        ╔════════╗          │
│        ║        ║          │
│        ║   ( )  ║          │
│        ║  /   \ ║          │  ← animated ring / spinner
│        ║   \ /  ║          │
│        ╚════════╝          │
│                            │
│                            │
│   Calculating your         │
│   probable birth time…     │
│                            │
│                            │
│   ─────────────────────    │
│   Analyzing 5 life events  │
│   against planetary        │
│   positions                │
│   ─────────────────────    │
│                            │
│   This usually takes       │
│   under 10 seconds.        │
│                            │
│                            │
│                            │
│         [ Cancel ]         │
│                            │
└────────────────────────────┘
```

**Demo mode variant:**

```
┌────────────────────────────┐
│   ┌────────────────────┐   │
│   │  DEMO              │   │
│   └────────────────────┘   │
│                            │
│   Running demo             │
│   calculation…             │
│                            │
│   [spinner]                │
│                            │
│   This is a sample result. │
│   Real calculations use    │
│   your actual API data.    │
│                            │
└────────────────────────────┘
```

**Notes:**
- Rotating copy below spinner: cycles through "Analyzing life events…", "Mapping planetary transits…", "Ranking candidates…" — approximately 3-second intervals.
- Demo mode: "DEMO" badge at top, different copy below spinner.
- Cancel: navigates back to Life Events and aborts the in-flight request. No payment exists in MVP, so there is no charge, refund, or credit-restore concept here.

---

## Screen 6 — Result Screen

```
┌────────────────────────────┐
│ ‹  Result                  │
│                            ├
│  ┌──────────────────────┐  │
│  │ DEMO                 │  │  ← only if demo mode
│  └──────────────────────┘  │
│                            │
│  Your most probable        │
│  birth time                │
│                            │
│  ╔══════════════════════╗  │
│  ║                      ║  │
│  ║       7:14 AM        ║  │
│  ║                      ║  │
│  ║   Gemini Rising  ♊   ║  │
│  ║                      ║  │
│  ╚══════════════════════╝  │
│                            │
│  Confidence                │
│  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░  78% │
│                            │
│  ─────────────────────     │
│  Other candidates          │
│                            │
│  7:42 AM  Cancer ♋  61%   │
│  ▓▓▓▓▓▓▓▓▓▓▓░░░░░░░░░░     │
│                            │
│  8:03 AM  Cancer ♋  44%   │
│  ▓▓▓▓▓▓▓░░░░░░░░░░░░░░     │
│                            │
│  ─────────────────────     │
│                            │
│  ┌──────────────────────┐  │
│  │  See how we got this │  │
│  └──────────────────────┘  │
│                            │
│  ┌──────────────────────┐  │
│  │  Save to history     │  │
│  └──────────────────────┘  │
│                            │
│  ──── Demo result ─────    │
│  ┌──────────────────────┐  │
│  │  Run a real calc.    │  │
│  │  with your data      │  │
│  └──────────────────────┘  │
└────────────────────────────┘
```

**Notes:**
- Primary result: large time, rising sign name + glyph. No astrological jargon beyond rising sign name.
- Confidence bar: filled/unfilled horizontal bar. Color TBD in design (likely: high = green or accent, medium = amber, low = muted).
- Other candidates: simplified rows below — smaller type, same bar pattern.
- Demo mode: "DEMO" badge + "Run a real calculation" CTA at bottom. No price/payment shown — monetization deferred to V1.5.
- "Save to history" persists this calculation to local DB. If already saved (returning user), show "Saved ✓" instead.

---

## Screen 7 — Evidence Breakdown

```
┌────────────────────────────┐
│ ‹  Evidence                │
├────────────────────────────┤
│                            │
│  Why 7:14 AM?              │
│                            │
│  4 of 5 events strongly    │
│  supported this time.      │
│                            │
│  ─────────────────────     │
│                            │
│  ┌──────────────────────┐  │
│  │ 💍 Marriage          │  │
│  │    June 2018         │  │
│  │                      │  │
│  │  ●●●○  STRONG        │  │
│  │                      │  │
│  │  Venus crossed the   │  │
│  │  7th house cusp in   │  │
│  │  June 2018, a key    │  │
│  │  marriage indicator. │  │
│  └──────────────────────┘  │
│                            │
│  ┌──────────────────────┐  │
│  │ 💼 Career change     │  │
│  │    Sep 2015          │  │
│  │                      │  │
│  │  ●●○○  MODERATE      │  │
│  │                      │  │
│  │  Saturn transit over │  │
│  │  10th house in 2015. │  │
│  │                   ›  │  │  ← expand for more detail
│  └──────────────────────┘  │
│                            │
│  ┌──────────────────────┐  │
│  │ 🏠 Relocation        │  │
│  │    Mar 2012          │  │
│  │                      │  │
│  │  ●●●○  STRONG        │  │
│  │                   ›  │  │
│  └──────────────────────┘  │
│                            │
│  ┌──────────────────────┐  │
│  │ 👶 Birth of child    │  │
│  │    Nov 2020          │  │
│  │                      │  │
│  │  ●○○○  WEAK          │  │
│  │                   ›  │  │
│  └──────────────────────┘  │
│                            │
│  ┌──────────────────────┐  │
│  │ 📚 Education         │  │
│  │    Jun 2008          │  │
│  │                      │  │
│  │  ○○○○  NO MATCH      │  │
│  │                      │  │
│  │  This event did not  │  │
│  │  strengthen any      │  │
│  │  candidate time.     │  │
│  └──────────────────────┘  │
│                            │
└────────────────────────────┘
```

**Notes:**
- Match strength: 4-dot visual (●●●○ = Strong, ●●○○ = Moderate, ●○○○ = Weak, ○○○○ = No match). Always shown with text label — not color-only (accessibility).
- Cards are expanded or collapsed. Strong and Moderate events expanded by default; Weak and No match collapsed by default (show › chevron to expand).
- "No match" events still shown — transparency is the value proposition. User should see that some events didn't help.
- Scroll: this screen scrolls freely. Bottom padding so last card is not hidden behind nav.

---

## Screen 8 — History

### Empty state

```
┌────────────────────────────┐
│  Rectify                   │
│                      [⚙]  │
├────────────────────────────┤
│                            │
│                            │
│                            │
│        (clock icon)        │
│                            │
│                            │
│  No calculations yet.      │
│                            │
│  Run your first one to     │
│  see results here.         │
│                            │
│                            │
│  ┌──────────────────────┐  │
│  │  New Calculation     │  │
│  └──────────────────────┘  │
│                            │
│                            │
├────────────────────────────┤
│         [+]  History  [⚙]  │
└────────────────────────────┘
```

---

### With calculations

```
┌────────────────────────────┐
│  Rectify                   │
│                      [⚙]  │
├────────────────────────────┤
│  Past calculations         │
│                            │
│  ┌──────────────────────┐  │
│  │ My calculation       │  │
│  │ May 15, 2026         │  │
│  │                      │  │
│  │    7:14 AM    78%    │  │
│  │    Gemini Rising     │  │
│  │                   ›  │  │
│  └──────────────────────┘  │
│                            │
│  ┌──────────────────────┐  │
│  │ DEMO                 │  │
│  │ Demo result          │  │
│  │ May 12, 2026         │  │
│  │                      │  │
│  │    7:14 AM    78%    │  │
│  │    (sample data)     │  │
│  │                   ›  │  │
│  └──────────────────────┘  │
│                            │
│  ← swipe left to delete    │
│                            │
│                            │
├────────────────────────────┤
│  [+] New   History    [⚙]  │
└────────────────────────────┘
```

**Notes:**
- Bottom tab bar: "New Calculation" (+ icon), "History" (clock icon, selected), "Settings" (gear icon).
- Swipe left on card → reveals red "Delete" button → tap to confirm (small inline confirmation, not a modal dialog).
- Demo results are badged "DEMO" in the list.
- Tap anywhere on card → navigates to Result screen with cached data.
- "New Calculation" at top right or via bottom tab — both work.

---

## Screen 9 — Settings

```
┌────────────────────────────┐
│ ‹  Settings                │
├────────────────────────────┤
│                            │
│  API Key (Pro / Developer) │
│  ┌──────────────────────┐  │
│  │  Not set          ›  │  │
│  └──────────────────────┘  │
│  Optional. Only for users  │
│  with their own provider   │
│  key. Leave blank for the  │
│  standard (proxied) path.  │
│                            │
│  ─────────────────────     │
│                            │
│  Demo mode                 │
│  Run calculations with     │
│  sample data (free)        │
│                   [  OFF ] │
│                            │
│  ─────────────────────     │
│                            │
│  Time format               │
│  ◉ 12-hour  (7:14 AM)      │
│  ○ 24-hour  (07:14)        │
│                            │
│  ─────────────────────     │
│                            │
│  Data                      │
│                            │
│  [ Delete all data ]       │
│  Removes all calculations  │
│  and events from this      │
│  device. Cannot be undone. │
│                            │
│  ─────────────────────     │
│                            │
│  [ Privacy Policy ]     ›  │
│                            │
│  ─────────────────────     │
│                            │
│  Rectify  v1.0.0           │
│                            │
└────────────────────────────┘
```

**Notes:**
- API key field is a **Pro / Developer** override only — hidden behind a low-emphasis row, blank ("Not set") by default. Tap → bottom sheet with text field and instructions. There is no app-bundled key to "fall back" to; blank means the standard backend-proxied path is used. No purchase history exists in MVP (monetization deferred to V1.5).
- Demo mode toggle: iOS-style toggle switch.
- Time format: radio buttons (◉/○).
- "Delete all data" → confirmation bottom sheet: "This will permanently delete X calculations. This cannot be undone." + red "Delete" button + Cancel.
- Privacy Policy opens in-app browser (SafariViewController / Chrome Custom Tab).
- App version: tappable 5x for debug info (optional easter egg — defer if not needed).

---

## Error Screens

### API Timeout / 5xx Error

```
┌────────────────────────────┐
│ ‹  Calculation             │
├────────────────────────────┤
│                            │
│                            │
│       (warning icon)       │
│                            │
│  Something went wrong      │
│                            │
│  The calculation is taking │
│  too long. Please try      │
│  again.                    │
│                            │
│  Your inputs have been     │
│  saved.                    │
│                            │
│                            │
│  ┌──────────────────────┐  │
│  │     Try again        │  │
│  └──────────────────────┘  │
│                            │
│  ┌──────────────────────┐  │
│  │  Save and retry      │  │
│  │  later               │  │
│  └──────────────────────┘  │
│                            │
│                            │
└────────────────────────────┘
```

---

### City Not Found (inline)

```
│  City of birth             │
│  ┌──────────────────────┐  │
│  │  Brody, Ukraine   ×  │  │
│  └──────────────────────┘  │
│  ⚠ City not found. Try a   │
│  nearby city or add the    │
│  country name.             │
```

---

### No Internet (full screen)

```
┌────────────────────────────┐
│                            │
│       (wifi-off icon)      │
│                            │
│  No internet connection    │
│                            │
│  Check your connection     │
│  and try again.            │
│                            │
│  ┌──────────────────────┐  │
│  │     Try again        │  │
│  └──────────────────────┘  │
│                            │
│  You can still view past   │
│  calculations in History.  │
│                            │
└────────────────────────────┘
```

---

## Navigation Architecture

```
                   ┌───────────────┐
                   │  Onboarding   │
                   │  (first launch│
                   │   only)       │
                   └───────┬───────┘
                           │
          ┌────────────────▼────────────────┐
          │          Bottom Tab Bar          │
          │   [+]  New  │  History  │  ⚙    │
          └────┬────────┴─────┬─────┴──┬────┘
               │              │        │
    ┌──────────▼──────┐  ┌────▼──┐  ┌──▼──────┐
    │  Birth Data     │  │History│  │Settings │
    │  Input          │  │       │  │         │
    └──────────┬──────┘  └────┬──┘  └─────────┘
               │              │
    ┌──────────▼──────┐       │
    │  Time Window    │  ┌────▼──────┐
    │  Setup          │  │  Result   │
    └──────────┬──────┘  │  (cached) │
               │         └───────────┘
    ┌──────────▼──────┐
    │  Life Events    │
    │  Input          │
    └──────────┬──────┘
               │
    ┌──────────▼──────┐
    │  Loading        │
    └──────────┬──────┘
               │
    ┌──────────▼──────┐
    │  Result Screen  │
    └──────────┬──────┘
               │
    ┌──────────▼──────┐
    │  Evidence       │
    │  Breakdown      │
    └─────────────────┘
```

**Notes:**
- New Calculation flow is a push navigation stack (‹ back at each step).
- History and Settings are tab-level destinations (no back nav within them).
- Result screen can be reached from: calculation flow (fresh result) OR history tap (cached result).
- Evidence Breakdown is always a child of Result Screen, never accessible directly.
