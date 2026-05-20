# Design System — Rectify

**Version:** 0.1
**Date:** 2026-05-20
**Status:** MVP visual language and component tokens
**Linked to:** `docs/design-brief.md`, `docs/ascii-wireframes.md`, `docs/prd.md`

This document is the source of truth for the visual language of Rectify. Everything below is intended to be implemented directly in Flutter via a custom `ThemeData` + a small set of `ThemeExtension`s. The naming convention here maps 1:1 to suggested Dart constants — token names are deliberately verbose to make grep-ability and theme overrides easy.

---

## 0. How to read this document

- **Tokens** are the lowest-level decisions (a hex value, a font size, a spacing number). Tokens are named, not used literally.
- **Components** are made by composing tokens.
- **Patterns** are full screens or interaction shapes made of components.
- All values are in *logical points* (`pt`), which map to `dp` in Flutter and `pt` in iOS. Multiply by `devicePixelRatio` only when working with raster assets.

---

## 1. Core philosophy in tokens

The whole system follows three rules that govern token choice:

1. **Warm before neutral.** Every grayscale value has a faint warm bias — there is no pure `#000`, no pure `#FFF`, no pure `#888`.
2. **One accent, deployed sparingly.** A single warm clay/brass accent is the product's signature. Used for the primary CTA, the hero result moment, the active step indicator. Never for a "delete" button. Never decorative.
3. **Confidence is its own scale, not the brand palette.** Confidence colors (strong / moderate / weak / no match) are muted, accessibility-checked, and intentionally less saturated than the accent.

---

## 2. Color tokens

All values are sRGB hex. Names map to Dart constants in `lib/theme/colors.dart` (suggested).

### 2.1 Background scale (warm bone family)

| Token | Value | Use |
|---|---|---|
| `bg.canvas` | `#F1ECE1` | The outermost canvas — visible only outside the safe area / behind sheets |
| `bg.app` | `#FBF8F2` | Main app background. Every screen's default. |
| `bg.surface` | `#FFFFFF` | Elevated surfaces: cards, sheets, inputs |
| `bg.surface.sunken` | `#F4EFE5` | Subtle subdivision (e.g. read-only fields, evidence "no-match" cards) |
| `bg.surface.inverted` | `#15171C` | Deep mode — used for the result hero card and for dark-mode v2 |

`bg.app` has a barely-perceptible warmth — about 6% toward yellow vs. neutral. This is intentional. It makes the white surfaces above feel like *paper laid on paper*, not flat boxes.

### 2.2 Ink scale (text and lines)

| Token | Value | Use |
|---|---|---|
| `ink.strong` | `#16181D` | Primary text, headings, hero numerals |
| `ink.body` | `#2E3138` | Body text |
| `ink.muted` | `#5C5A54` | Secondary text, helper copy, captions |
| `ink.soft` | `#85827A` | Tertiary text, timestamps, "step 1 of 3" labels |
| `ink.faint` | `#B1AC9F` | Placeholder text, disabled state |
| `ink.line` | `#E4DFD2` | Dividers between rows |
| `ink.line.soft` | `#EFEAE0` | Subtle inner card dividers |

The ink scale is warm-tinted on purpose. `#16181D` reads as "ink black" but has a 1.5% blue-bias — slightly cooler than the warm background — which gives the type a subtle pop without feeling cold.

### 2.3 Accent (Rectify Clay)

A single warm clay / brass / sunrise tone. Used as the product signature.

| Token | Value | Use |
|---|---|---|
| `accent.clay` | `#B66A3F` | Primary CTA fill, active step, hero result accent |
| `accent.clay.hover` | `#A55B33` | Pressed / hover state |
| `accent.clay.deep` | `#7A4124` | Accent text on light background (legibility) |
| `accent.clay.tint` | `#F2E3D3` | Soft accent surface — selected chips, focus rings |
| `accent.clay.line` | `#E0BFA1` | Accent border (focused inputs) |

`#B66A3F` is the *only* warm color used at any saturation above 25%. It is the brand. Everything else recedes.

### 2.4 Deep contrast (Observatory Navy)

A deep, near-black blue-green. Used as the secondary anchor for nav surfaces, the hero result card, and as an alternative emphasis to clay where clay would feel hot.

| Token | Value | Use |
|---|---|---|
| `deep.midnight` | `#1B2735` | Hero result background, nav background variant |
| `deep.midnight.soft` | `#2A3A4A` | Hover state on midnight surfaces |
| `deep.midnight.tint` | `#E3E7EB` | Soft cool surface, used very sparingly |
| `deep.ink.on-midnight` | `#FBF8F2` | Text on midnight surfaces (the warm bone, not white) |

### 2.5 Confidence scale (status, evidence)

A four-step ordinal scale. Each step has a *color* and a *label* — they are always paired in the UI for accessibility (color-blind safety + screen reader semantics).

| Token | Value | Label in UI |
|---|---|---|
| `confidence.strong` | `#5C7355` | STRONG |
| `confidence.moderate` | `#B07F44` | MODERATE |
| `confidence.weak` | `#8E867B` | WEAK |
| `confidence.none` | `#808892` | NO MATCH |

All four are in the same lightness range (~45 L*) so no level visually shouts. The user reads the *position* in the scale, not the *temperature* of the color.

A short scale also exists for the top-level confidence percentage bar:

| Token | Range | Color |
|---|---|---|
| `confidence.bar.high` | 70–100% | `#5C7355` (strong sage) |
| `confidence.bar.mid` | 40–69% | `#B07F44` (brass) |
| `confidence.bar.low` | 0–39% | `#8E867B` (warm stone) |

### 2.6 Semantic (status, alerts)

| Token | Value | Use |
|---|---|---|
| `status.success` | `#5C7355` | Save confirmations, "Saved ✓" indicator |
| `status.warning` | `#B07F44` | Soft warnings (fewer than 5 events) |
| `status.danger` | `#8E3D2F` | Destructive actions only (Delete all data, swipe-delete) |
| `status.info` | `#1B2735` | Neutral informational chips, "DEMO" pill |

`status.danger` is deep terracotta, not stop-sign red. The product never panics.

### 2.7 Forbidden colors

These values must not appear in shipped UI. Catching them in a linter or visual review is acceptable.

- Pure `#000000`, pure `#FFFFFF`, pure `#888888` (use ink / bg tokens)
- Any purple, magenta, or pink hue (H ≈ 270–340)
- Bright traffic-light red `#E5394C` or bright candy green `#3CCB7F`
- Any neon (S > 90%) at any hue

---

## 3. Typography

### 3.1 Font families

Three families, loaded via `google_fonts` for cross-platform consistency.

| Token | Family | Source |
|---|---|---|
| `font.sans` | **Inter** | `GoogleFonts.inter()` |
| `font.serif` | **Source Serif 4** | `GoogleFonts.sourceSerif4()` |
| `font.mono` | **JetBrains Mono** | `GoogleFonts.jetBrainsMono()` |

Inter handles 95% of the product. Source Serif 4 is reserved for: onboarding hero copy, the result time, and a small number of section titles on the result/evidence screens. JetBrains Mono is reserved for the result time numerals only (it gives `7:14 AM` a measurement feel).

If `google_fonts` is unavailable at runtime, fall back to the platform default (San Francisco on iOS, Roboto on Android) — but only as a degraded mode, never as the design target.

### 3.2 Type scale

Numeric pairs are `(size pt / line-height pt)`. Tracking (letter-spacing) is in `em`.

| Token | Family | Size / LH | Weight | Tracking | Use |
|---|---|---|---|---|---|
| `type.display.xl` | serif | 56 / 60 | 400 | -0.02 | Result hero time (`7:14 AM`) |
| `type.display.lg` | serif | 36 / 42 | 400 | -0.015 | Onboarding hero ("Your birth chart depends on…") |
| `type.display.md` | serif | 28 / 34 | 400 | -0.01 | Result section ("Your most probable birth time") |
| `type.title.lg` | sans | 22 / 28 | 600 | -0.01 | Screen titles, "Past calculations" |
| `type.title.md` | sans | 18 / 24 | 600 | -0.005 | Card titles, "Life events (5 added)" |
| `type.title.sm` | sans | 15 / 20 | 600 | 0 | Inline section labels, "Confidence" |
| `type.body.lg` | sans | 17 / 26 | 400 | 0 | Long-form body copy, evidence explanations |
| `type.body.md` | sans | 15 / 22 | 400 | 0 | Default body, list items, descriptions |
| `type.body.sm` | sans | 13 / 18 | 400 | 0.01 | Helper text, captions |
| `type.label.md` | sans | 14 / 18 | 500 | 0.01 | Form labels, button labels |
| `type.label.sm` | sans | 12 / 16 | 500 | 0.04 | All-caps eyebrow labels: `STEP 1 OF 3`, `STRONG`, `DEMO` |
| `type.mono.xl` | mono | 56 / 60 | 500 | -0.02 | Used inside `type.display.xl` for the numerals only |

**Weights used.** Inter at 400 (Regular), 500 (Medium), 600 (Semibold). No 700+. The product gets its weight from contrast and color, not heavy type.

**Italics.** Avoid. The serif is used at regular weight only. One exception: a very small italic inside the evidence explanation copy is acceptable for technical terms ("*Venus* crossed the 7th house cusp"). Do not italicize whole sentences.

### 3.3 Type rules

- **Headlines run two lines max.** If the copy is too long, edit the copy, don't shrink the font.
- **All-caps is reserved for eyebrows and labels.** Never used for body text. Tracking is always +0.04em on caps to compensate for tighter caps-spacing.
- **Numbers in measurements use tabular figures.** Enable `fontFeatures: [FontFeature.tabularFigures()]` on result-time and confidence-percentage widgets.
- **No underline for links.** Links are `accent.clay.deep` color. Underline only on press feedback.

---

## 4. Spacing and layout

### 4.1 Spacing scale (4pt base)

| Token | Value |
|---|---|
| `space.0` | 0 |
| `space.1` | 4 |
| `space.2` | 8 |
| `space.3` | 12 |
| `space.4` | 16 |
| `space.5` | 20 |
| `space.6` | 24 |
| `space.7` | 32 |
| `space.8` | 40 |
| `space.9` | 48 |
| `space.10` | 64 |
| `space.11` | 80 |

Default screen edge padding is `space.6` (24pt). Default in-card padding is `space.5` (20pt). Default gap between sibling sections is `space.7` (32pt).

### 4.2 Layout grid

Mobile only in MVP — no tablet or web layout.

- **Safe area:** respect platform safe areas top and bottom.
- **Edge gutter:** 24pt left/right, the whole product.
- **Vertical rhythm:** primary blocks separated by 32pt. Cards separated by 12pt.
- **Max content width inside a phone:** the screen width minus 48pt total.

### 4.3 Tap targets

Minimum 44 × 44 pt for any interactive element (iOS HIG floor). Most buttons in the product are 48pt tall. Card-level tap targets can be larger (full card press).

---

## 5. Radius

| Token | Value | Use |
|---|---|---|
| `radius.xs` | 6 | Small chips, the DEMO pill |
| `radius.sm` | 10 | Inputs, small buttons, list items |
| `radius.md` | 14 | Cards (default) |
| `radius.lg` | 20 | Bottom sheets (top corners only), large hero cards |
| `radius.xl` | 28 | The result hero card |
| `radius.full` | 999 | Avatar-style, dots, circular badges |

Cards prefer `radius.md` (14). Buttons prefer `radius.sm` (10) — slightly tighter than the cards they sit on, which creates a subtle visual hierarchy.

---

## 6. Elevation

The system is mostly flat. Three elevation levels exist:

| Token | Description | Shadow |
|---|---|---|
| `elev.0` | Flat. Distinguished by borders, not shadow. | none |
| `elev.1` | Floating card, modal | `0 1pt 2pt rgba(22,24,29,0.04), 0 2pt 8pt rgba(22,24,29,0.05)` |
| `elev.2` | Bottom sheet, active drag layer | `0 -2pt 4pt rgba(22,24,29,0.03), 0 -8pt 24pt rgba(22,24,29,0.08)` |

Cards in the main scroll use `elev.0` with a 1pt `ink.line` border. Floating elements (the FAB-style "Add event" or the bottom sheet) use `elev.1` or `elev.2`. **Avoid the Material default elevations** — they are too pronounced and read as "Android stock."

---

## 7. Iconography

### 7.1 Style

- Outline, 1.5pt stroke.
- 24 × 24pt default canvas; 20 × 20pt for inline use; 16 × 16pt for dense list rows.
- Color: inherits the surrounding text color by default (use `ink.muted` for icon-only buttons).
- Geometric but warm (rounded join, square cap).

### 7.2 Source

**Lucide** (recommended) or **Phosphor (Light)** as the production icon family. Both are open-source, both have Flutter packages (`lucide_icons`, `phosphor_flutter`). Pick one and stick to it for the whole product.

Wireframes use emoji as placeholders. Production replaces emoji with the icon family at the visual-design pass.

### 7.3 Category icons (life events)

Each of the 12 life-event categories gets a single icon from the chosen family. Recommendations using Lucide:

| Category | Icon |
|---|---|
| Marriage / Partnership | `heart` |
| Divorce / Separation | `heart-crack` |
| Career change | `briefcase` |
| Job loss | `trending-down` |
| Relocation (major) | `home` |
| Birth of child | `baby` |
| Death of family member | `flame` (low-key, not a cross or skull) |
| Major illness / surgery | `cross` (medical) |
| Accident / injury | `triangle-alert` |
| Education milestone | `graduation-cap` |
| Financial turning point | `coins` |
| Other | `bookmark` |

None of these are filled. None are colored. They take their color from the row's text.

### 7.4 Forbidden icons

Stars, moons, suns, crystals, eyes, planets, zodiac glyphs, tarot cards. The two exceptions: the zodiac glyph for the rising sign on the result card (small, single, monochrome) and a small clock-quadrant glyph used as the brand mark.

---

## 8. Motion

### 8.1 Tokens

| Token | Duration | Curve |
|---|---|---|
| `motion.instant` | 0ms | linear |
| `motion.short` | 150ms | `Curves.easeOut` |
| `motion.medium` | 250ms | `Curves.easeOutCubic` |
| `motion.long` | 400ms | `Curves.easeOutCubic` |
| `motion.reveal` | 600ms | custom `Cubic(0.16, 1, 0.3, 1)` |

### 8.2 Where each is used

- `motion.short` — pressed states, ripple-like feedback, small toggles
- `motion.medium` — page transitions, bottom sheet open/close
- `motion.long` — empty-state fade-ins, evidence card expand
- `motion.reveal` — **the one moment the user feels we slowed down**: the result time fading in on the Result screen. 600ms fade + 8pt upward translate.

### 8.3 Loading rhythm

The indeterminate spinner does not "race." It pulses at ~1.6s per cycle (`scale: 1.0 → 1.06 → 1.0`, opacity: `1.0 → 0.7 → 1.0`). It feels like breath, not a stopwatch.

### 8.4 Reduced motion

Respect `MediaQuery.disableAnimations`. When set, all `motion.medium`+ durations collapse to `motion.short`, and the result-reveal becomes a crossfade with no translate.

---

## 9. Components

Each component below has: a short purpose, the tokens it composes, its states, and any platform notes.

### 9.1 Button

**Primary Button** — the main action on a screen.
- Background: `accent.clay`
- Label: `bg.app` (`#FBF8F2`)
- Padding: `space.4` vertical, `space.6` horizontal
- Radius: `radius.sm`
- Height: 52pt
- Type: `type.label.md` at weight 600
- States: default / pressed (`accent.clay.hover`) / disabled (`accent.clay` at 40% opacity, label at 60%)

**Secondary Button** — equally weighted alternative.
- Background: `bg.surface`
- Border: 1pt `ink.line`
- Label: `ink.strong`
- Same dimensions and type as Primary
- States: default / pressed (`bg.surface.sunken` background) / disabled (label `ink.faint`)

**Ghost Button** — tertiary, in-line.
- No background, no border
- Label: `accent.clay.deep`
- Height: 44pt
- Used for "Skip", "Cancel" in flows

**Destructive Button** — for delete.
- Background: `bg.surface`
- Border: 1pt `status.danger` at 40% alpha
- Label: `status.danger`
- Pressed state: `status.danger` background at 8% alpha
- Used only for "Delete all data," swipe-delete confirmation

### 9.2 Input field

- Height: 52pt
- Background: `bg.surface`
- Border: 1pt `ink.line`
- Radius: `radius.sm`
- Inner padding: 16pt horizontal, 14pt vertical
- Label: `type.label.md` in `ink.muted`, positioned 8pt above the field (not floating-on-top)
- Helper text below: `type.body.sm` in `ink.soft`
- Focus state: border becomes 1.5pt `accent.clay.line`, helper text optional shifts to `accent.clay.deep`
- Error state: border becomes 1.5pt `status.danger`, helper text becomes `status.danger`
- Disabled: background `bg.surface.sunken`, text `ink.faint`

**Date picker trigger** is an input field with a right-side chevron (`›`). Tapping opens a native platform picker (iOS wheel / Android material). The trigger displays the formatted date in `type.body.lg`.

**City search field** is an input with: a left-side magnifying-glass icon, a right-side `×` (clear) when populated, and a live-suggestion dropdown attached below (see Pattern 11.3).

### 9.3 Radio group

- 24 × 24pt ring
- Selected: `accent.clay` ring 1.5pt + `accent.clay` filled 12pt inner dot
- Unselected: `ink.line` ring 1pt
- Label to the right at `type.body.md`
- Whole row is tappable (44pt minimum height)
- Rows separated by 1pt `ink.line.soft` divider

### 9.4 Toggle (switch)

- 48 × 28pt
- Off: track `bg.surface.sunken`, thumb `bg.surface` with 1pt `ink.line`
- On: track `accent.clay`, thumb `bg.surface`
- 200ms ease transition
- Use the platform-native iOS switch on iOS and a custom Material switch on Android — both follow these colors

### 9.5 Chip / pill

- Height: 28pt
- Padding: 6pt vertical, 12pt horizontal
- Radius: `radius.xs`
- Background:
  - Default: `bg.surface.sunken`
  - Selected: `accent.clay.tint`
  - Status (DEMO): `deep.midnight` with `bg.app` text
- Type: `type.label.sm` (uppercase, tracked)
- Border: optional 1pt `ink.line` for default

### 9.6 Card

The product's primary container.

- Background: `bg.surface`
- Border: 1pt `ink.line`
- Radius: `radius.md`
- Inner padding: 20pt (`space.5`)
- No drop shadow by default — borders carry the weight

**Variants:**

- **Event Card** (life events list) — left icon column 32pt wide, content column flex, right delete `×` 32pt wide. Inner dividers between rows are absent — each event is its own card.
- **Candidate Card** (result screen, secondary candidates) — single row, time + sign + confidence bar inline. Half the height of the hero card.
- **History Card** — label + date eyebrow, large time + confidence row, rising sign caption. 16pt top/bottom padding.
- **Evidence Card** — collapsed default: icon + category + date + 4-dot strength + STRONG/MODERATE/WEAK/NO MATCH label. Expanded: adds explanation paragraph below in `type.body.md`.

### 9.7 Hero result card

The single most decorated component in the product.

- Background: `deep.midnight`
- Text: `deep.ink.on-midnight`
- Radius: `radius.xl` (28pt)
- Padding: 32pt all sides
- Contents (vertical, centered):
  - Eyebrow `type.label.sm` "YOUR MOST PROBABLE BIRTH TIME" in `accent.clay.tint`
  - 24pt gap
  - The time in `type.display.xl` using `font.mono` for the numerals and `font.serif` for the `AM`/`PM`
  - 12pt gap
  - "Gemini Rising" in `type.title.md`, with a 16pt zodiac glyph after the name
- Optional 1pt inner border `rgba(255,255,255,0.06)` for a subtle bezel effect

This is the only place in the product that uses the deep midnight surface for an entire surface. It signals: *this is the answer.*

### 9.8 Confidence bar

- Horizontal track 8pt tall, `bg.surface.sunken`, full width
- Fill from left: bar color from `confidence.bar.high/mid/low` depending on % value
- Radius: 4pt
- Number label to the right of the bar: `type.title.sm` tabular figures
- Always paired with an accessible label like `Confidence — 78%`

### 9.9 Match strength indicator (4-dot)

A row of 4 dots, each 8pt diameter, 4pt apart.

- Strong: 3 filled + 1 outlined, dots = `confidence.strong`
- Moderate: 2 filled + 2 outlined, dots = `confidence.moderate`
- Weak: 1 filled + 3 outlined, dots = `confidence.weak`
- No match: 0 filled + 4 outlined, dots = `confidence.none`

Always paired with the text label to the right at `type.label.sm`. This is non-negotiable for accessibility — never color-only.

### 9.10 Stepper / progress (top-of-flow)

A 4pt-tall horizontal bar at the top of the calculation flow, full width minus screen gutter.

- Track: `bg.surface.sunken`
- Fill: `accent.clay`
- Animated when the user advances (`motion.medium`)
- Eyebrow above: "STEP 1 OF 3" in `type.label.sm`, `ink.soft`

### 9.11 Indeterminate loader

Two valid renderings; pick one per use case:

1. **Pulse dot** — a single 12pt dot in `accent.clay`, pulsing scale `1.0 → 1.4 → 1.0` over 1.6s. Used during short, in-line waits (city geocoding).
2. **Breath ring** — a 64pt ring of 1.5pt stroke in `accent.clay`, with the lower half darker (`accent.clay.deep`) and rotating one full turn over 2.4s. Used on the full-screen calculation loader.

### 9.12 Bottom sheet

- Background: `bg.surface`
- Radius: `radius.lg` on top corners only
- Elevation: `elev.2`
- 36pt drag handle (4pt tall, 36pt wide, `ink.line` color) centered 8pt below top edge
- Padding: 24pt sides, 16pt top (below the handle), 32pt bottom (above the safe area)
- Title: `type.title.md`, then 8pt rule, then content
- Dismiss: tap outside, drag down, or "Cancel" ghost button

### 9.13 Modal (full-screen for errors)

Same canvas as a regular screen with:
- A 64pt status glyph in `accent.clay` (warning, wifi-off, etc.)
- 32pt gap
- `type.title.lg` title centered
- 16pt gap
- `type.body.lg` description centered, 320pt max width
- 32pt gap
- Buttons stacked vertically (Primary + Secondary), full width minus gutter

### 9.14 Empty state

- 96pt vertical padding from the screen top edge of available space
- 48pt monochrome glyph (`ink.soft` color), centered
- 24pt gap
- `type.title.md` heading
- 8pt gap
- `type.body.md` description, max 280pt width, centered
- 24pt gap
- Primary CTA centered

### 9.15 Toast / inline error (snackbar)

- Background: `deep.midnight`
- Text: `deep.ink.on-midnight`
- Radius: `radius.sm`
- Padding: 12pt vertical, 16pt horizontal
- Position: 24pt above bottom safe area (above tab bar if present)
- Max width: screen width minus 48pt
- Auto-dismiss after 4s; tap to dismiss earlier
- One optional action label aligned right in `accent.clay.tint`

### 9.16 Tab bar (bottom)

- Background: `bg.surface`
- Top border: 1pt `ink.line`
- Height: 56pt above safe area inset
- 3 tabs: **New Calculation** (`+`), **History** (`clock-3`), **Settings** (`settings`)
- Active tab: icon and label in `accent.clay`
- Inactive: icon and label in `ink.muted`
- Label: `type.label.sm` (uppercase, tracked, 11pt at the tab bar — slightly tighter than full label.sm)
- Center tab (History) is the default destination after onboarding

### 9.17 Top navigation

- Height: 44pt + safe area
- Background: `bg.app`
- Title: `type.title.md`, left-aligned, after a 24pt gutter
- Back arrow `‹` (Lucide `chevron-left`, 24pt) at left for push-stack screens
- Right-side icon button optional (e.g., settings gear from History root)
- No bottom border. The page itself carries the divide via a 1pt `ink.line.soft` rule beneath the title row.

---

## 10. Screen patterns

These compose the components above into the recurring shapes of the product.

### 10.1 Stepped flow

Top: stepper bar + eyebrow ("STEP 1 OF 3"). Title `type.title.lg`. Body content. Single bottom-fixed primary button or pair (Secondary + Primary). The bottom button rests above the safe-area inset, with a 24pt gap above the button group and a 16pt gap below.

Used for: Birth Data Input, Time Window Setup, Life Events Input, Confirmation.

### 10.2 Hero result moment

Top: minimal nav (back arrow + "Result" title). DEMO pill if applicable, top-right of the hero card.
Body: the **hero result card** (section 9.7), then a confidence bar, then up to 2 secondary candidate cards in a tight list, then two stacked buttons: "See how we got this" (Primary) and "Save to history" (Secondary).
Below: if demo, a soft, non-blocking "This was a demo — run a real calculation with your data" prompt at the bottom, with a tertiary CTA.

### 10.3 Evidence breakdown

Vertical list of evidence cards. First 1–2 cards (Strong/Moderate) expanded by default. Weak/No-match cards collapsed by default, chevron to expand. Sticky summary line at top: "4 of 5 events strongly supported this time" in `type.body.lg`. No bottom CTA — this is a read-only screen, dismiss via back.

### 10.4 List + swipe action

Used for History. Each card is a tappable region. iOS swipe-left reveals a 96pt-wide "Delete" red action with confirmation; Android long-press opens a contextual menu. On confirm, the row collapses with a 250ms slide-up.

### 10.5 Bottom-sheet picker

Used for: time window, category, month, year, time picker.
Sheet contains a list of options as 56pt-tall rows, separated by 1pt `ink.line.soft` dividers, each row is `type.body.lg` left-aligned, with a `✓` mark in `accent.clay` to the right of the currently selected option. Tap a row → animates the check, dismisses the sheet after 200ms, applies selection.

### 10.6 Onboarding slide

Top: skip ghost button (top right, 16pt safe-area inset). Body: 24pt margins, a single quiet glyph or quiet line illustration top-center (no painted illustrations), then `type.display.lg` (serif) headline, then `type.body.lg` body. Bottom: 3-dot pagination indicator, then a single primary button "Next." Final slide has two stacked buttons (Try demo first / Start real calculation) and no Skip.

### 10.7 Settings list

Vertical list of `bg.surface` cards grouped by section. Each row 56pt tall, label left, value/control right. Section headers in `type.label.sm` `ink.soft`. Destructive action ("Delete all data") sits in its own card with the destructive button style.

---

## 11. Specific interaction notes

### 11.1 Date picker

Use the native date picker on each platform. The trigger in the form is one of our Input components (section 9.2) and shows the formatted date. Date pickers must respect the COPPA gate (no dates after 2008 — see PRD §13).

### 11.2 Time picker

Same pattern as date picker — native wheel/material picker, our input as trigger.

### 11.3 City search (geocoding)

The City of Birth field is our Input component with:
- A left-side `search` icon
- An inline live spinner (Pulse dot variant, 9.11) at the right while the geocode request is in flight, *replacing* the right-side `×` until results return
- A dropdown panel below the field showing up to 5 results, each row 48pt tall, with a small country flag glyph at left, the city + country in `type.body.md`, and a small region/state in `type.body.sm` `ink.soft` below

When a result is selected, the field shows `City, Country` in `type.body.md` plus a small flag glyph. The right-side `×` returns.

### 11.4 Life event card swipe / delete

In the Life Events Input list, each event card has a visible `×` icon at the top-right corner (no swipe required for delete in the entry flow — speed matters here). One tap deletes without confirmation (it's a list-builder, not a destructive action).

### 11.5 Save to history confirmation

Tapping "Save to history" on the result screen animates the button label to "Saved ✓" in `confidence.strong` for 1.2s, then disables the button. No toast — the button itself is the feedback.

### 11.6 Demo badge ("DEMO" pill)

Appears as a chip (`status.info` variant, 9.5) on:
- Calculation loading screen (top, below the safe area)
- Result screen (top of the hero card, right-aligned overlay)
- Evidence screen (top, below the title)
- History list (badge on demo-result cards)

Never appears on Settings, Onboarding, or input screens.

---

## 12. Accessibility

Hard floors, not nice-to-haves.

- **Contrast.** All text/background pairs meet WCAG AA at the *minimum*; headlines (`type.title.lg`+) hit AAA. The ink/bg.app pair at smallest body size (13pt) was selected to clear AA with a margin. Confidence colors are paired with text labels — never communicate strength by color alone.
- **Tap targets.** 44 × 44pt minimum. Verified by overlay during design QA.
- **Dynamic type.** Respect system text-size preferences. The serif scale should grow proportionally; the mono scale uses tabular figures so layouts don't shift.
- **Screen reader.** Every icon-only button has a `Semantics(label: …)`. The result time is announced as "seven fourteen AM, 78 percent confidence."
- **Reduced motion.** Honor the OS setting (section 8.4).
- **Color-blind safety.** The confidence scale was checked against Protanopia, Deuteranopia, Tritanopia, and Achromatopsia simulations. The labels carry the meaning; the colors carry the ordering.

---

## 13. Light / dark

MVP ships **light mode only.** The token system is designed to support a dark variant later by remapping `bg.*` and `ink.*` to their dark equivalents while keeping `accent.clay`, `confidence.*`, and `status.*` unchanged.

Suggested dark-mode mapping (V1.5 target — not MVP):

| Light | Dark |
|---|---|
| `bg.canvas` `#F1ECE1` | `#0D1014` |
| `bg.app` `#FBF8F2` | `#15181E` |
| `bg.surface` `#FFFFFF` | `#1D2127` |
| `ink.strong` `#16181D` | `#F4EFE5` |
| `ink.body` `#2E3138` | `#D9D4C9` |
| `ink.muted` `#5C5A54` | `#A39E91` |
| `ink.line` `#E4DFD2` | `#2B2F38` |

The serif and clay accent are kept identical — they read beautifully on both modes.

---

## 14. Flutter implementation notes

### 14.1 Suggested file structure

```
lib/
  theme/
    colors.dart            // all color tokens as static const Color
    typography.dart        // text styles as static TextStyle
    spacing.dart           // static const double for the spacing scale
    radius.dart            // BorderRadius constants
    elevations.dart        // BoxShadow constants
    motion.dart            // Duration + Curve constants
    theme.dart             // assembles ThemeData
    theme_extensions.dart  // custom ThemeExtension for tokens not covered by ThemeData
  widgets/
    primary_button.dart
    input_field.dart
    event_card.dart
    history_card.dart
    candidate_card.dart
    evidence_card.dart
    hero_result_card.dart
    confidence_bar.dart
    match_strength_dots.dart
    bottom_sheet_picker.dart
    breath_ring_loader.dart
    pulse_dot_loader.dart
    demo_pill.dart
```

### 14.2 ThemeData strategy

Use Material 3 (`useMaterial3: true`) as the base but override aggressively:

- `colorScheme`: built from seed `accent.clay` with manual overrides for `surface`, `background`, `onSurface`, `onBackground`.
- `textTheme`: built from `google_fonts.interTextTheme()` and overridden per role.
- `elevatedButtonTheme`, `textButtonTheme`, `outlinedButtonTheme`: each themed to our token system. Don't rely on Material defaults.
- `inputDecorationTheme`: themed to our Input spec (radius, border, focus).
- `appBarTheme`: zero elevation, transparent background that adopts `bg.app`.

Custom tokens that don't map to Material concepts (confidence colors, the hero result card colors) live in a `RectifyTokens extends ThemeExtension<RectifyTokens>` so they're accessible via `Theme.of(context).extension<RectifyTokens>()`.

### 14.3 Recommended packages

- `google_fonts` — Inter, Source Serif 4, JetBrains Mono
- `lucide_icons` *or* `phosphor_flutter` — the production icon family
- `flutter_svg` — for the brand mark and the one or two quiet glyph illustrations
- `intl` — date/time formatting respecting locale and the 12h/24h setting

### 14.4 Localization-ready (V1.5, not MVP)

Even though MVP ships English-only, structure the theme and components to be locale-aware:
- Don't bake string lengths into widget widths (cards should wrap, not truncate, unless the design explicitly truncates a single line like history labels).
- Use `intl` for *all* number, date, and time formatting from day one.

### 14.5 Performance budget

- 60fps on iPhone 11 and Pixel 5 as the floor target. The product is light enough that this is easy if you avoid unnecessary `setState` rebuilds in the calculation flow.
- No animated background gradients, no animated illustrations, no Lottie. Custom-paint the breath ring and the pulse dot — they're trivial.

---

## 15. Quality checklist before any screen ships

Use this as a self-review gate before marking any screen "design complete."

- [ ] Every text style maps to a `type.*` token; no inline `TextStyle` literals
- [ ] Every color maps to a token; no inline `Color(0x…)` literals
- [ ] Edge gutter is 24pt; primary block spacing is 32pt
- [ ] Every tap target is 44×44pt or larger
- [ ] Every icon-only button has an accessible label
- [ ] Loading rhythm uses one of the two loaders (9.11), not a default `CircularProgressIndicator`
- [ ] No emoji in production copy
- [ ] No exclamation marks in production copy
- [ ] No purple, no neon, no pure black, no pure white
- [ ] The screen passes contrast AA at smallest body size
- [ ] Dynamic type ×1.3 doesn't break the layout
- [ ] Reduced-motion preference removes the result reveal animation
- [ ] If the screen is part of the calculation flow, it shows correct stepper progress
- [ ] If the screen is a demo path, the DEMO pill is visible

---

## 16. Component implementation checklist (post-MVP)

For each component above, the Flutter build is "done" when:

- It accepts a `ThemeData` and respects light/dark (even though dark is V1.5)
- It is implemented as a `StatelessWidget` where possible; `Stateful` only for components with internal animation state
- It has a corresponding `*_test.dart` widget test that snapshots default + pressed + disabled
- It is referenced in a `golden_test.dart` to catch unintended visual drift

This is not enforceable at the MVP design stage — it's a note for the implementation team to plan from day one.
