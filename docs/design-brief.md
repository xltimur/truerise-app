# Design Brief — Rectify

**Version:** 0.1
**Date:** 2026-05-20
**Status:** Visual design direction for MVP
**Linked to:** `docs/prd.md`, `docs/mvp-scope.md`, `docs/ascii-wireframes.md`

---

## 1. Product, in one sentence

Rectify is a precision tool that turns a few life events into a calculated estimate of your birth time, with the math made readable.

It is not a horoscope app. It is not a Vedic super-app. It is not a chat-with-an-astrologer marketplace. The job is one job: *"I don't know my birth time — what is it most likely to be, and why?"*

The design has to make that job feel solvable, calm, and credible.

---

## 2. Who the design is for

**Primary persona — Maya, 29, design-literate, mid-funnel astrology user.**
She has used Co-Star and CHANI. She knows what a rising sign is. She does not know her exact birth time. She trusts beautiful, clearly-explained software. She is suspicious of apps that look like Tarot decks.

**Secondary — Arjun, 34, engineer in Bangalore.** Cares about precision and explanation. Will test the demo before committing.

**Tertiary — Elena, 38, professional astrologer.** Treats the app as a workbench tool. Wants speed, evidence, and trust.

Across all three: **they are adults who want quiet competence, not theatre.**

---

## 3. What we are explicitly *not* designing

These are the visual and tonal traps the category falls into. We avoid all of them.

- Cosmic purple gradients, starfield backgrounds, glitter, sparkles
- Tarot deck aesthetics, runes, sacred geometry as ornament
- "Your destiny awaits" copy
- Dark-mystical Co-Star irreverence ("You are a mess. Mercury did it.")
- Cheap Indian astrology app density (12 features per screen, accordion stacks, banner ads)
- Generic SaaS template (Notion-blue, Inter-on-white, "Welcome 👋")
- Wellness app pastel candy (gradient blobs, soft purple-pink, breathing circles)
- Fortune-telling theatre (drumroll modals, "your result is being summoned")

If the user shows a screen of Rectify to a friend, the friend should think *"oh, this is the precision app for figuring out your birth time"* — not *"oh, you're using one of those astrology apps."*

---

## 4. Design philosophy: "Quiet Observatory"

The visual and editorial spine of the product is the metaphor of a small, modern observatory journal.

A few images that anchor the metaphor:
- A folded page from a *Sky & Telescope* article
- A modernist museum object label next to a Kepler instrument
- The interior of a Muji notebook, used for serious work
- A neatly-formatted research footnote
- Morning light on parchment paper

What this means in practice:

- **Time is data, not destiny.** When we display the result, we treat it as a measurement (HH:MM, with confidence, with evidence) — not as a revelation.
- **The page is calm.** White space is generous. Ink is dark and warm. No surface fights for attention.
- **The work is shown.** Every result is accompanied by *why*. Evidence is not a hidden detail — it is one of the two hero objects in the entire app.
- **The product is a tool, not a personality.** The UI does not flirt with the user. It does not have a name like "Luna." It does its job and gets out of the way.

The observatory metaphor is *internal* — it directs our taste. It is **not literal**. There are no stars, telescopes, charts, or constellations in the UI as decoration.

---

## 5. Brand attributes

Five attributes, each with a one-line rule the design must obey.

| Attribute | Rule |
|---|---|
| **Calm** | The user should feel less anxious after opening the app, not more. |
| **Precise** | Every number is exact. Every label means exactly one thing. Nothing is vague. |
| **Transparent** | We never produce a result without showing how we got there. |
| **Warm** | Whites are warm. Edges are soft. Typography breathes. The product is not clinical. |
| **Modern** | 2026 mobile product, not 2015 web form. Native gestures, native rhythm. |

Tension to manage: *precise* + *warm*. We are not Stripe (precise-cold). We are not Headspace (warm-soft). We are between them — closer to **Things 3**, **Notion Calendar**, **Mercury**, **Linear**, and the editorial side of **The New York Times** apps.

---

## 6. Visual direction at a glance

Detailed tokens live in `design-system.md`. This section is the *intuition*, not the specification.

**Palette mood.** Warm off-white background (think parchment, but not yellow), deep ink text (warm near-black, never pure #000), and a single sophisticated accent — a clay / brass / sunrise tone, used sparingly for the moments that matter (primary CTA, result moment, key affirmations). One deep observatory blue-black as a secondary anchor for nav and headers. Confidence states use a tight, muted scale: sage, brass, stone, slate. No bright traffic-light reds and greens.

**Typography mood.** Two voices.

1. **A clean, modern sans for the entire UI.** Inter (or Söhne if licensed). Tight letterforms, generous line height, comfortable at small sizes. Carries 95% of the product.
2. **A serif for emotional anchors.** Used only for: onboarding hero copy, the result time, and section titles on the result/evidence screens. Editorial serif with personality but not nostalgia (Source Serif 4, Tiempos, GT Sectra, or similar). This serif is the *single tactic* that lifts the product out of "another SaaS app" into "considered consumer object."

A third, minor voice: **monospace numerals** for the result time itself (e.g., `7:14 AM`). Not for everything — just for the hero time, where the user is reading a measurement.

**Iconography mood.** Outline, 1.5pt stroke, geometric but warm. Never filled. Never with flourishes. Lucide / Phosphor-style. Categories use color-coded glyphs, not emoji — emoji is acceptable as a *placeholder* in wireframes but the shipped product uses a curated icon set.

**Motion mood.** Soft, short, never showy. 150–250ms eases. Layout transitions, not stagger choreography. Loading states use breath rhythm (1.5–2s pulse), not racing spinners. The result reveal is **slow on purpose** — a one-time deliberate beat (~600ms) where the time fades up. Everywhere else, the app is brisk.

**Composition mood.** One-column, mobile-first, generous side margins (24pt). Cards have soft borders, not heavy shadows. Bottom sheets feel like paper sliding up, not screens flipping. Lists breathe.

---

## 7. UX principles

The seven rules every screen has to obey.

1. **One screen, one decision.** No screen asks the user to make two unrelated choices.
2. **Progressive disclosure.** Show the simplest version first. Detail is one tap away, not on the same page.
3. **Show the work.** Any number we produce has a "why" within one tap. Evidence is a first-class object, not a footnote.
4. **Be honest about uncertainty.** Confidence is a percentage, a bar, and a label — never a verdict. Lower confidence is not hidden; it is explained.
5. **Calm pacing.** No surprise modals. No "Don't go!" exit prompts. No anxiety-inducing CTAs ("Last chance — calculate now"). The product trusts the user to come back.
6. **Demo before commit.** A new user must be able to see a realistic result without giving us anything. The demo path is a first-class flow, not a hidden corner.
7. **No jargon by default.** *Ascendant* becomes *rising sign*. *Transit* and *Dasha* live on the Evidence screen and only when the user has chosen to look there.

---

## 8. Tone of voice

Plain, precise, slightly editorial. Reads like *The Atlantic* on a quiet day — not like a fortune cookie, not like a SaaS marketing page.

**The voice has three jobs:**
1. Tell the user what to do next, in plain English.
2. Set expectations honestly (it's *probable*, not *certain*).
3. Explain results in a way a smart non-astrologer can follow.

**Do**
- "We narrowed it down to 7:14 AM, with 78% confidence."
- "Add at least 3 events to try the demo. Add 5 or more for a real calculation."
- "We couldn't find this city. Try a nearby larger city, or add the country."
- "This event didn't strengthen any candidate time."

**Don't**
- "✨ Your cosmic blueprint awaits!"
- "Venus is smiling on you today 💫"
- "Click here to unlock your TRUE birth time"
- "Oops! Something went wrong 😬"

**Punctuation rules.** No exclamation marks anywhere in the product. No emoji in copy. Em dashes are fine. Sentences are short. Read every paragraph out loud — if it doesn't sound like something a calm adult would say, rewrite it.

**Numbers.** Always use the digit form for measurements (`5 events`, not `five events`). Times in the user's selected format (12h or 24h). Confidence as integer percent.

---

## 9. Information hierarchy per screen

The product has three hero moments. Everything else is plumbing.

**Hero 1 — The result time.** When the calculation finishes, the user sees a large, serif, near-monospace numeral. *This is the moment the product exists for.* It should feel like flipping a page in a beautiful book.

**Hero 2 — The evidence list.** One tap from the result. This is where the product's credibility is built or lost. Each row says: *which event* + *how strongly it matched* + *what that means in one sentence*.

**Hero 3 — The first impression.** The onboarding's middle slide ("How Rectify works") is the moment the user decides whether this is "another astrology app" or "actually a tool." Treat it as a hero.

Everything else (birth-data form, time-window picker, event entry, settings) is *plumbing*. Plumbing must be calm, fast, and forgettable.

---

## 10. Key user scenarios (narrative)

These are the scenarios the design must make feel effortless.

### Scenario A — "Just looking" (Maya, demo path)

Maya opens the app for the first time. She scrolls through three short onboarding slides in about 25 seconds, taps **Try demo first**, and the app drops her into a pre-filled birth-data screen with realistic mock content. She glances at it, taps Continue, glances at the time-window screen (`±2 hours` is already selected, with the calculated range shown in plain English below), taps Continue, and lands on the events screen with 5 mock events already there.

She taps **Calculate (demo)**. The loading screen is short, calm, with rotating copy lines that explain what's happening. The result page fades up: **7:14 AM**, in a beautiful serif, with a confidence bar at 78%. A small "DEMO" pill is visible but doesn't shout. Below: two other candidate times, smaller. A single button: **See how we got this**.

She taps it. She sees five events, each with a strength label (Strong, Moderate, Weak, No match) and a one-sentence astrological explanation. The first two are pre-expanded. She thinks *"OK, this is actually a tool."* She closes the app.

**Design must make this 90-second flow feel like reading a well-typeset article — not filling out a form.**

### Scenario B — "Actually using it" (Maya, real path, second session)

She comes back two days later. Lands on the History screen, sees the demo result in the list (badged), taps **New Calculation** in the bottom tab. The birth-data form is now empty (this is hers, not the demo). She enters her real date, types "San Francisco," picks the autocomplete result, taps Continue. The time window screen — she selects "I have no idea," reads one short sentence explaining what that means, taps Continue.

The events screen is empty with a clear call-to-action. She taps **Add first event**, a bottom sheet slides up, she picks **Marriage**, picks month and year, taps Add. She repeats for four more events. The "Calculate" button below now reads **Calculate** (not "demo"). She taps it. The loading screen is the same calm rhythm — except there's no DEMO badge.

About 8 seconds later: her real result. She taps **Save to history**. Done.

**Design must make the real path indistinguishable in feel from the demo — same calm, same trust, just different data.**

### Scenario C — "Something went wrong" (Arjun, error path)

He's on a train, intermittent connection. Submits his calculation. Loading screen runs for 30 seconds, then transitions to an error screen with a warning icon, a single sentence ("The calculation is taking too long. Please try again."), and one reassurance ("Your inputs have been saved."). Two buttons: **Try again** and **Save and retry later**.

He taps Save and retry later. Goes back to history, where his attempt now sits as a *draft*. Two stops later, on better connection, he opens it from History, taps Retry, gets his result.

**Design must turn failure into a chapter, not a dead end.** Error states are part of the product, not afterthoughts.

### Scenario D — "Returning to a result" (Elena, pro)

Elena has run 14 calculations for clients. Her History screen shows them in a clean, scannable list — label, date, top time, confidence. She taps one to review, reads the result, taps into Evidence to remind herself which transit drove the top candidate. She does not need to re-calculate, and the app does not re-call the API.

**Design must respect repeat use.** Past results are first-class artifacts — they are read, not just stored.

---

## 11. Out of bounds (visual)

Treat this as a hard list. Anything matching these patterns is a defect.

- Purple, magenta, or pink as primary
- Gradients that span more than one hue family
- Glitter, sparkles, stars, moons, sun rays as decorative motifs
- Card backgrounds with cosmic textures or starfields
- Mandalas, runes, tarot card frames, sacred geometry
- Emoji used to convey product meaning (✨🌙🔮)
- Filled, cartoonish icons; gradient-filled icons
- Custom typography in a "mystical" serif (Cinzel, Trajan, etc.)
- Skeuomorphic paper textures with curled corners
- Cute mascot characters of any kind
- Drumroll / suspense animations on the result reveal — the reveal is one calm fade
- Loading screens with rotating planets
- "Powered by AI" / "Powered by NASA" badges in the UI

---

## 12. Out of bounds (verbal)

- Words: *cosmic*, *destiny*, *journey*, *blessed*, *energy*, *vibes*, *aligned*, *unlock*, *manifest*, *summon*
- Phrases: *the stars say*, *your cosmic blueprint*, *what the universe wants*, *your true self*
- Exclamation marks anywhere except possibly the demo result micro-copy (and even there, no)
- Sentences ending with emoji
- "Oops" / "Whoops" / "Uh oh" in error states

When in doubt, the test is: **could this copy appear in a Stripe Dashboard tooltip?** If yes, ship it. If it would feel weird there, rewrite.

---

## 13. Design success criteria

The design is succeeding when:

1. A new user, shown the app cold, can answer *"what does this app do?"* in one sentence within 5 seconds of looking at the home or first onboarding screen.
2. A non-astrologer can read the result screen and understand what a "rising sign" is without external help (one short line of context is enough).
3. The result moment **feels like a moment** — not like a form submission acknowledgment.
4. The evidence screen is the screen the user shows to their friends, not the result screen alone. Transparency is the share-worthy artifact.
5. No screen reads as "astrology" before it reads as "tool."
6. The error states are *boring*. A boring error state is a finished error state.
7. A second-time user gets to a new calculation in fewer than 3 taps from cold app launch.
8. The demo and real flow are visually indistinguishable except for the DEMO pill — so the demo accurately previews the real product.

---

## 14. Relationship to the Flutter implementation

This brief is platform-agnostic. The visual language must work natively on both iOS and Android without feeling like a port. That means:

- Native gestures (iOS swipe-back, Android back), native date/time pickers, native keyboards.
- Bottom sheets follow platform-idiomatic feel (iOS sheet drag indicator on top, Android material elevation).
- Typography is the same on both platforms (we ship Inter + the chosen serif via the `google_fonts` package — we do not fall back to San Francisco / Roboto for our product type).
- Tab bar on Android can adapt to Android norms but the visual language (warm parchment, ink, accent) stays identical.
- One theme, one identity, two platforms. No "iOS version" and "Android version" of the brand.

The detailed components and Flutter notes live in `design-system.md`.

---

## 15. Open design questions to resolve next

- **Dark mode.** Out of MVP scope for the prototype, but the palette and type must be designed with a dark variant in mind. Sketch a dark variant of the design system before shipping V1 builds.
- **Icon set.** Pick a single icon family (Lucide vs. Phosphor vs. custom) before component build. Wireframes use emoji — production does not.
- **Result-reveal motion.** One specific decision: does the result time *fade* up or *type* in? Recommendation: a single 600ms fade with a soft upward translate of 8pt. No typing effect.
- **Confidence visualization.** Bar vs. ring vs. arc. Recommendation: horizontal bar for the top result (clearer at glance), arc for the per-event match strength if we want a second visual mode — but the 4-dot pattern from the wireframes is already strong; stick with it unless there is a reason to upgrade.
- **Empty-state illustrations.** Are there any? Recommendation for MVP: **no.** A short line of copy and a single quiet glyph (1 SVG, monochrome) is enough. Illustrations are a V1.5 polish task, not an MVP requirement.

---

## 16. North-star comparison set

When in doubt about a design decision, look at how these products would solve it:

| For | Look at |
|---|---|
| Type hierarchy and editorial calm | The New York Times app, *The Browser* email |
| Forms and progressive disclosure | Stripe Dashboard, Linear, Mercury onboarding |
| The result-as-object moment | Apple Wallet card details, Things 3 task focus |
| List screens with rich detail | Notion Calendar, Cron, Things 3 |
| Bottom sheets and pickers | iOS native, Apple Maps, Things 3 quick-add |
| Empty states and loading | Linear, Height, Things 3 |
| Tone of error states | Stripe, GitHub |

When in doubt, look at *none* of these:

- Co-Star, The Pattern, Sanctuary, Nebula, Purple Garden, AstroSage, AstroTalk, any web astrology calculator, any horoscope newsletter design.

We are crossing a category line on purpose. The job of the design is to make that crossing feel inevitable.
