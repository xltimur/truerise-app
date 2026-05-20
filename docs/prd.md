# PRD: Birth Time Rectification Mobile App

**Version:** 0.1 (MVP)
**Date:** 2026-05-19
**Status:** Draft — awaiting stakeholder review

---

## 1. Product Concept

A mobile-first Flutter application that helps users determine their probable birth time using astrological calculation (birth time rectification). The user enters their approximate birth window and a set of verified life events; the app calls an astrology API rectification endpoint and returns a ranked list of candidate birth times with confidence scores and per-event evidence.

The app is not a horoscope app, not a Vedic super-app, and not a live consultation platform. It solves exactly one problem clearly: "I don't know my birth time — what is it most likely to be?"

---

## 2. App Name

### Recommended working title: **Rectify**

*(Working title pending App Store name availability, domain availability, and trademark clearance. Does not block the design phase — use "Rectify" in all mockups and copy until cleared.)*

A single, action-oriented English word. Feels like a precision tool, not a mystical portal. Highly memorable, brand-able, and easy to search in app stores. Works globally without translation loss. Positions the app as a problem-solver, not an entertainment product.

### 5 Alternative Names

| Name | Rationale | Risk |
|------|-----------|------|
| **Natara** | Natal + *tara* (star in Sanskrit/Hindi). Dual resonance for India market. Unique and memorable. | Meaning not obvious to English-only users |
| **BirthLens** | Precision optics metaphor — brings clarity to an unknown. Directly descriptive of the value proposition. | Slightly literal; less brand-able |
| **Ascendant** | The rising sign is the key astrological element unlocked by knowing birth time. Well-known term for target audience. | Too jargon-heavy for casual/new users |
| **Tempus** | Latin for "time." Elegant, premium, universal across languages. | Abstract; doesn't signal astrology context |
| **Charted** | Past tense — implies completion ("finally charted"). Conveys the outcome: your birth chart now works. | Could be confused with map/data chart apps |

---

## 3. Problem Statement

Approximately 40–60% of astrology app users cannot determine their ascendant, house placements, or accurate transit/Dasha timing because they don't know their exact birth time. Hospital records were often rounded to the nearest quarter-hour; family memory is unreliable; records from older generations or other countries may be missing entirely.

Without an exact birth time, key astrological calculations — rising sign, house cusps, Dasha periods in Vedic astrology — are impossible. This means users are blocked from the most personalized and valuable parts of astrology.

The current alternatives are:
- **Professional human rectification:** $50–$320+ per session, delivered in 1–72 hours, inaccessible on mobile.
- **Desktop software (Jagannatha Hora):** Windows-only, requires expert astrological knowledge.
- **Web calculators (AstroSage, Cosmic Birthtime):** Poor mobile UX, often opaque outputs, some charge £28–$50 per report upfront without a free trial.
- **iOS-only apps (Vedic Samay):** KP-method only, steep learning curve, no onboarding for non-experts.

No mainstream, mobile-native, consumer-grade BTR app exists.

---

## 4. ICP and Personas

### Primary ICP

**Intermediate astrology enthusiast, age 25–40, female-skewed**
- Has used a birth chart or horoscope app (Co-Star, CHANI, Astro.com)
- Knows what a rising sign is and wants one
- Does not know their exact birth time
- Willing to pay $5–20 for a credible, explained answer
- Expects a modern mobile UX — not a web form from 2005
- English-speaking (V1 launch); Hindi-speaking (V1.5)

### Persona 1 — Maya, 29, UX Designer (San Francisco)

"I've been obsessed with my birth chart for two years, but every astrologer I follow says they can't give me accurate readings without my exact birth time. My mom thinks I was born around 7 AM, but the hospital only noted 'morning.'"

- Discovery channel: TikTok astrology creators, Instagram
- Willing to pay: $8–12 for a reliable calculation
- Key need: a result she can trust and explain to others
- Frustration: has tried Astro.com manual approach, found it overwhelming

### Persona 2 — Arjun, 34, Software Engineer (Bangalore)

"I need my Kundli for an important family decision. The astrologer I consulted said my time might be off and the Dasha periods could be miscalculated. I want to verify before I spend on another full consultation."

- Discovery channel: Google ("birth time rectification app"), Reddit r/vedicastrology
- Willing to pay: ₹500–₹1,500 (~$6–18) per calculation
- Key need: KP-validated result he can bring to his astrologer
- Frustration: AstroSage takes 72 hours and has no mobile app

### Persona 3 — Elena, 38, Professional Astrologer (Toronto)

"I do 10–15 client consultations per month. For about half of them, birth time is uncertain. Manual rectification takes me 2–4 hours per client — I don't have time for that."

- Discovery channel: Professional astrology forums, Reddit r/astrologers
- Willing to pay: $30–80 per calculation or a monthly subscription
- Key need: fast candidate generation she can verify and present to clients
- Frustration: no reliable mobile tool; Jagannatha Hora is Windows-only

### Secondary Segments (V1.5+)

- **Astrology creators** (TikTok/YouTube/Instagram) — need shareable output, PDF reports
- **Vedic practitioners** — need KP/Nadi framing, Hindi language support

---

## 5. Jobs to Be Done (JTBD)

**Primary JTBD:**
> When I'm trying to get an accurate birth chart reading, but I don't know my exact birth time, I want to find the most probable birth time based on my life events, so I can finally use the full features of astrology apps and get accurate readings.

**Supporting JTBDs:**

| Trigger | JTBD | Outcome |
|---------|------|---------|
| Astrologer says results are inaccurate | Verify or correct an approximate birth time | Confident in chart accuracy |
| Found old birth certificate with unclear time | Narrow down from "around 3pm" to a specific range | Specific time to enter into chart apps |
| Major life decision coming (Vedic context) | Get accurate Dasha timing before deciding | Informed decision with astrological backing |
| Starting to take astrology seriously | Get a proper foundation for chart work | Rising sign + full chart for the first time |
| New astrology enthusiast, no birth time at all | Understand what options exist and try the process | Sense of whether rectification is worthwhile |

---

## 6. Value Proposition

**For the user:** "You don't know your exact birth time. Enter what you remember about your life, and we'll calculate the most likely time — with evidence."

**Differentiation vs. alternatives:**

| Dimension | Rectify | Human astrologer | Cosmic Birthtime | Vedic Samay |
|-----------|---------|-----------------|-----------------|-------------|
| Platform | iOS + Android | None | Web only | iOS only |
| Speed | Seconds | 1–72 hours | Minutes (web) | Minutes |
| Price | $4–9/calculation | $50–$320+ | £28/report | Free + credits |
| Evidence shown | Per-event | Varies | PDF only | Limited |
| Requires astrology knowledge | No | No | No | Yes |
| Demo mode | Yes | No | No | No |

**Unique value:** First mobile-native BTR app with consumer-grade UX, evidence transparency, and a free demo mode. Users can see what a result looks like before spending a cent.

---

## 7. MVP Goals

1. **Prove the core loop works end-to-end:** user inputs → API call → result with evidence → user understands what they got.
2. **Validate engagement and intent:** achieve 5%+ conversion from demo to a real calculation in the first 200 unique users. (Real monetization / IAP is **not** in MVP — see Section 17. Willingness-to-pay is validated in V1.5 once IAP ships.)
3. **Validate event entry UX:** ≥70% of users who start a calculation submit ≥5 life events.
4. **Establish baseline accuracy perception:** ≥60% of users rate the result as "believable" or "probably correct" in post-result prompt.
5. **Ship a stable, reviewable product** to App Store and Google Play with no critical crashes in first 30 days.

---

## 8. Non-Goals for MVP

The following are explicitly out of scope for MVP. Any request to add these during MVP development should be deferred to V1.5 or V2.

- PDF or image export of results
- Vedic / KP method toggle (MVP uses API default method)
- Birth chart rendering or visualization
- Live astrologer consultation booking
- Social sharing or community features
- Push notifications or personalized reminders
- In-app purchase, subscription billing, restore purchase, purchase history, or refund/credit restoration (MVP has no real monetization — only a pricing assumption for future phases; see Section 17)
- Hindi or any non-English language UI
- Multiple user profiles on one account
- Offline calculation (API dependency is acceptable for MVP)
- Syncing across devices
- Apple Watch or widget extensions
- In-app review request flows (defer to after V1 launch)

---

## 9. Core User Flows

### Flow A — New user, demo mode

```
App open → Onboarding (3 screens) → Birth Data Input
→ Time Window Setup → Life Events Input (min 3 for demo)
→ [DEMO] Calculation Loading (mock) → Result Screen (mock data)
→ Evidence Breakdown → Prompt ("Run a real calculation")
→ Real Calculation (configured API access) → Real Result
```

*Note: In MVP, a real calculation is gated by configured API access (backend proxy in production, or a user-supplied API key in dev/pro mode), not by an in-app purchase. Monetization is deferred — see Section 17.*

### Flow B — Returning user, real calculation

```
App open → Home (History) → New Calculation
→ Birth Data Input (prefilled from last session)
→ Time Window Setup → Life Events Input
→ Calculation Loading (real API) → Result Screen → Evidence Breakdown
→ Save to History
```

### Flow C — Returning user, view past result

```
App open → Home (History) → Tap past calculation
→ Result Screen (cached) → Evidence Breakdown
```

### Flow D — API failure / timeout

```
Life Events submitted → Calculation Loading
→ [API error] → Error Screen
→ "Try again" (retry same request) or "Save for later" (save inputs locally)
```

---

## 10. Functional Requirements

### F1 — Onboarding

- F1.1: 3-screen onboarding on first launch only. Can be skipped.
- F1.2: Screen 1 explains what BTR is in plain language (no jargon).
- F1.3: Screen 2 explains what life events are needed.
- F1.4: Screen 3 offers "Try demo" or "Start for real" CTA.
- F1.5: Onboarding state persists; never shown again after completion.

### F2 — Birth Data Input

- F2.1: Required fields: date of birth (date picker), city of birth (searchable text field with geocoding).
- F2.2: Optional field: name or label for this calculation (for history).
- F2.3: City field resolves to latitude/longitude before API submission.
- F2.4: Date picker must support dates from 1920 to present.
- F2.5: Validation: city must resolve before proceeding; date cannot be in the future.

### F3 — Time Window Setup

- F3.1: User selects one of: "I have no idea" / "I have an approximate time."
- F3.2: If approximate time: time picker + window width selector (±30 min / ±1 hr / ±2 hr / ±3 hr / ±6 hr / Unknown = full day).
- F3.3: "I have no idea" sets window to full 24-hour range.
- F3.4: Brief copy explains why the window affects result quality.

### F4 — Life Events Input

- F4.1: Event has: category (picker), approximate date (month + year minimum), description (optional free text, max 200 chars).
- F4.2: Categories: Marriage/Partnership, Divorce/Separation, Career Change, Job Loss, Relocation (major), Birth of child, Death of close family member, Major illness or surgery, Accident or injury, Education milestone, Financial turning point, Other.
- F4.3: User can add up to 20 events per calculation.
- F4.4: Minimum 3 events to proceed in demo mode; minimum 5 events recommended for real calculation (soft warning at 3–4 events, not a hard block).
- F4.5: Events can be reordered or deleted before submission.
- F4.6: Date entry: month + year picker (not full date required — precision is contextual).
- F4.7: "Add event" button always visible; events render as a scrollable list of cards.

### F5 — Calculation

- F5.1: Before API call, app shows a loading screen with progress indication.
- F5.2: API call is made with birth data + time window + life events payload.
- F5.3: Timeout: 30 seconds. If no response, show error with retry option.
- F5.4: Demo mode: skip API call, return hardcoded mock response after 3-second simulated delay. No API key and no payment required.
- F5.5: Real calculation is gated by configured API access only — no in-app purchase in MVP. In production this is a backend proxy / serverless function holding the provider key; in dev/pro mode it is a user-supplied API key (Settings). See Section 11.
- F5.6: Monetization (IAP, credits, restore purchase) is **out of MVP scope**. MVP carries only a pricing assumption for future phases (see Section 17). No payment step is implemented or shown in the MVP flow.

### F6 — Result Screen

- F6.1: Display top candidate birth time prominently (HH:MM format, local time of birth city).
- F6.2: Display confidence score as percentage (e.g., "78% confidence").
- F6.3: Display up to 3 candidate times ranked by confidence.
- F6.4: Confidence score visualized as a simple bar or ring — not just a number.
- F6.5: Brief interpretation copy: what this time means for the user's chart (rising sign name only — no full chart in MVP).
- F6.6: CTA: "See how we got this" → Evidence Breakdown screen.
- F6.7: CTA: "Save" saves result to history.
- F6.8: Demo mode results are clearly labeled "Demo — not a real calculation."

### F7 — Evidence Breakdown

- F7.1: List of all submitted life events.
- F7.2: Each event shows: event category + date, match strength indicator (Strong / Moderate / Weak / No match), brief explanation text from API response.
- F7.3: Match strength visualized with color + label (not just color — accessible design).
- F7.4: Summary line: "X of Y events strongly supported this birth time."
- F7.5: User can expand each event card for more detail.

### F8 — History

- F8.1: Home screen = list of past calculations, sorted by date descending.
- F8.2: Each list item shows: label/name, calculation date, top candidate time, confidence score.
- F8.3: Tap opens the cached result screen (no re-calculation).
- F8.4: Swipe to delete a history entry (with confirmation).
- F8.5: Empty state with CTA to start first calculation.

### F9 — Settings

- F9.1: Optional API key override — a **Pro / Developer** setting only, for power users / professional astrologers who have their own provider API key. When set, it is stored in the device keychain/keystore (never in SQLite or plain preferences) and used instead of the default backend proxy path. Blank by default; demo mode never uses it.
- F9.2: Demo mode toggle (always available, not just first launch).
- F9.3: Time format preference: 12h / 24h.
- F9.4: App version display.
- F9.5: Privacy policy link.
- F9.6: "Delete all data" option with confirmation.

### F10 — Monetization (Deferred — NOT in MVP)

MVP ships **without any real monetization**. The items below are a forward-looking pricing assumption only and must not be implemented in MVP.

- F10.1: *(V1.5)* Single IAP product: "1 Calculation Credit", assumed price ~$4.99 (to be confirmed before the V1.5 implementation/production gate).
- F10.2: *(V1.5)* Restore purchase, purchase history, and refund / credit-restoration flows.
- F10.3: *(MVP)* Only a non-blocking "this would be a paid calculation in the future" framing may appear in copy. No purchase, no price gate, no IAP SDK integration in MVP.
- F10.4: *(V2)* Evaluate subscription model based on V1.5 repeat-usage data.

---

## 11. API Integration Requirements

### Astrology API — Rectification Endpoint

**Base URL:** `https://api.astrology-api.io` (or equivalent configured endpoint)

**Authentication & key handling (correct architecture):**

The provider API key is a secret. A secret shipped inside a mobile app — even via `--dart-define`, an obfuscated constant, or the keychain at runtime — can be extracted from the binary or intercepted. It must never be the production trust boundary. Three modes:

1. **Demo mode:** no API key at all. Uses the hardcoded mock response. Works offline.
2. **Dev / Pro-user mode:** the user enters *their own* provider API key in Settings. It is stored in the device keychain/keystore and sent on the device's behalf. The risk is the user's own, not the app's shared secret.
3. **Production consumer mode:** the Flutter app calls a **backend proxy / serverless function** owned by us. That backend holds the provider key server-side and forwards rectification requests. The provider key is **never embedded in Flutter source, `--dart-define`, or the app bundle.**

The app uses `Authorization: Bearer <key>` only against the provider (mode 2) or talks to our proxy with a short-lived/app-scoped token (mode 3). The proxy URL and auth scheme are an open question to confirm before the implementation/production gate.

**Endpoint:** `POST /v1/rectification`

**Request payload (assumed schema — verify with API provider before dev start):**

```json
{
  "birth_date": "1990-03-15",
  "birth_city": "Kyiv",
  "birth_lat": 50.4501,
  "birth_lon": 30.5234,
  "time_window": {
    "start": "05:00",
    "end": "09:00"
  },
  "life_events": [
    {
      "category": "marriage",
      "date": "2018-06",
      "description": "Got married in June 2018"
    },
    {
      "category": "career_change",
      "date": "2015-09",
      "description": "Started new job"
    }
  ]
}
```

**Expected response (assumed schema):**

```json
{
  "candidates": [
    {
      "time": "07:14",
      "confidence": 0.78,
      "ascendant": "Gemini",
      "events": [
        {
          "event_index": 0,
          "match_strength": "strong",
          "explanation": "Marriage in June 2018 aligns with Venus transit over 7th house cusp"
        }
      ]
    },
    {
      "time": "07:42",
      "confidence": 0.61,
      "ascendant": "Cancer",
      "events": [...]
    }
  ],
  "method": "western_transit",
  "calculation_id": "calc_abc123"
}
```

**Integration requirements:**

- IR1: Before a real calculation, the app must have a usable access path: either a reachable backend proxy (production) or a user-supplied API key in the keychain (dev/pro mode). Demo mode requires neither. The app must never bundle the provider's shared secret.
- IR2: Request timeout: 30 seconds. On timeout, surface an actionable error — do not silently fail.
- IR3: On HTTP 4xx: surface user-friendly error with specific guidance (e.g., 401 → "API key invalid, check Settings"; 400 → "Check your birth data and try again").
- IR4: On HTTP 5xx: show generic error with retry option; log error details locally.
- IR5: City-to-coordinates resolution must happen client-side (or via separate geocoding service) before the API call — do not pass city name string to rectification endpoint unless the API explicitly supports it.
- IR6: API response must be cached locally for the session so the user can navigate back to Results without re-calling.
- IR7: The `calculation_id` from the response must be stored with the history entry for potential support/debugging.
- IR8: Confirm with API provider: supported `category` enum values for life events, maximum number of events per request, rate limits per key, and whether the API supports a "dry run" mode for testing.

**Open questions for API provider (must resolve before development):**
- What is the full list of supported life event categories?
- What is the exact format for partial dates (month + year only)?
- Does the API support a sandbox/test mode with known expected outputs?
- What is the SLA / p95 response time?
- Is there a per-call cost on the provider side we need to model?
- Backend proxy: hosting choice (serverless function), proxy auth scheme (app-scoped token), and rate limiting — to confirm before the implementation/production gate, not before design.

---

## 12. Data Model Assumptions

### Entity: User

```
user_id         : UUID (device-generated, no server account in MVP)
created_at      : timestamp
settings        : JSON blob (time_format, api_key_override, demo_mode)
onboarding_done : boolean
```

### Entity: Calculation

```
calculation_id   : UUID (local) 
label            : string (optional, user-provided)
created_at       : timestamp
status           : enum [draft, submitted, complete, error]
demo_mode        : boolean

birth_date       : date (YYYY-MM-DD)
birth_city       : string
birth_lat        : float
birth_lon        : float
time_window_start: time (HH:MM) | null
time_window_end  : time (HH:MM) | null

api_calc_id      : string (from API response, nullable)
raw_response     : JSON blob (full API response, for debugging)
```

### Entity: LifeEvent

```
event_id         : UUID
calculation_id   : UUID (FK)
category         : enum (marriage, divorce, career_change, job_loss,
                         relocation, child_birth, family_death, illness,
                         accident, education, financial, other)
event_date_year  : integer
event_date_month : integer | null
description      : string | null (max 200 chars)
sort_order       : integer
```

### Entity: CandidateResult

```
result_id        : UUID
calculation_id   : UUID (FK)
rank             : integer (1 = top candidate)
birth_time       : time (HH:MM)
confidence       : float (0.0–1.0)
ascendant        : string | null
event_matches    : JSON blob (array of per-event match details from API)
```

### Storage

- All data stored locally using SQLite via a Flutter database package (e.g., sqflite or Drift).
- No server-side storage of user data in MVP.
- No user account / login in MVP.
- Raw API response stored as JSON blob per calculation for support and debugging purposes.

---

## 13. Privacy and Security Requirements

### Birth Data

- Birth date, birth city, and latitude/longitude are Personally Identifiable Information (PII) and must be treated accordingly.
- Data is stored only on-device in MVP. No server sync.
- Data is not transmitted to any third party other than the configured rectification endpoint (the provider directly in dev/pro mode, or our backend proxy in production) for the purpose of calculation.
- Birth/event data leaves the device only on explicit calculation submit. In production, the backend proxy must not log or retain PII beyond what is needed to forward the request.

### Life Events

- Life events (marriage, divorce, illness, death of family member) are sensitive personal data. Treat with the same care as health data.
- Events are transmitted to the API endpoint only when the user explicitly submits a calculation.
- No analytics events should include life event content.

### Analytics and Crash Reporting

- MVP may include anonymous crash reporting (e.g., Firebase Crashlytics). No PII in crash payloads.
- If behavioral analytics are added (e.g., event counts, screen visits), they must be anonymous and not tied to device ID or birth data.
- Analytics must be disclosed in the privacy policy.

### API Key Security

- **The provider's shared API key must never be embedded in the Flutter app.** Build-time injection (`--dart-define`), obfuscated constants, or storing it in the keychain at runtime are all extractable from a distributed binary and are **not** acceptable for the production trust boundary.
- **Production consumer mode:** the provider key lives only server-side, behind a backend proxy / serverless function we control. The app authenticates to the proxy with a short-lived or app-scoped token, never the raw provider key.
- **Dev / Pro-user mode:** a user-supplied API key (Settings override) is the user's own secret. It is stored in the device keychain/keystore — never in SQLite or shared preferences — and used only for that user's calls.
- **Demo mode:** no key of any kind; mock response only.

### Compliance

- Privacy policy must be linked in-app before any data submission (Settings + onboarding).
- "Delete all data" in Settings must wipe all local SQLite records and cached API responses.
- GDPR: Since no server-side data is stored in MVP, the main obligation is accurate disclosure of what is sent to the API provider.
- COPPA: App is not targeted at children. Add age gate (born before 2008) on date picker.

---

## 14. Error, Empty, and Loading States

### Loading States

| State | Copy | Visual |
|-------|------|--------|
| Geocoding city | "Finding your birth location…" | Inline spinner in city field |
| Calculation in progress | "Calculating your probable birth time…" | Full-screen animated loader |
| Demo calculation | "Running demo calculation…" | Same loader, but "DEMO" badge visible |

### Error States

| Error | User-facing copy | Action |
|-------|-----------------|--------|
| City not found | "We couldn't find this city. Try a nearby larger city or add the country." | Inline, stay on screen |
| API timeout (30s) | "The calculation is taking too long. Please try again." | Full-screen, "Try again" + "Save and retry later" |
| API 401 (invalid key) | "There's a problem with the API key. Check Settings or try demo mode." | Full-screen, "Go to Settings" |
| API 400 (bad input) | "There was a problem with your input. Please review your birth data." | Full-screen, "Review" |
| API 5xx | "Something went wrong on our end. Please try again in a moment." | Full-screen, retry |
| No internet | "No internet connection. Check your connection and try again." | Full-screen or snackbar |

### Empty States

| Screen | Empty condition | Copy + Action |
|--------|----------------|---------------|
| History | No calculations yet | "No calculations yet. Start your first one." + "New Calculation" button |
| Life events | No events added | "Add at least 3 events to run a demo, or 5 for a real calculation." + "Add event" button |

---

## 15. Success Metrics

### Launch Metrics (first 30 days)

| Metric | Target |
|--------|--------|
| App Store rating | ≥ 4.2 stars |
| Day 1 retention | ≥ 40% |
| Demo completion rate (started → demo result seen) | ≥ 50% |
| Demo-to-real-calculation conversion | ≥ 5% (paid conversion measured in V1.5 after IAP ships) |
| Crash-free sessions | ≥ 99% |
| Calculation error rate (API failures) | ≤ 5% |

### Product Quality Metrics (first 90 days)

| Metric | Target |
|--------|--------|
| Users who submit ≥ 5 events | ≥ 70% of those who start a calculation |
| "Believable result" rating in post-result prompt | ≥ 60% |
| Repeat calculations (second calculation by same user) | ≥ 20% |
| Support tickets about data privacy | 0 critical |

---

## 16. Risks and Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|-----------|
| Users drop off during life event entry (too much friction) | High | High | Categorized pickers (not free text), progress indicator, 3-event minimum for demo |
| API accuracy ceiling (~70%) creates disappointment | Medium | High | Frame results as "probable time, not certain"; show confidence as a range, not a guarantee |
| Users under 25 have too few life events | Medium | Medium | Soft warning with explanation ("More events = better result"), no hard block |
| API provider changes pricing or endpoint schema | Medium | High | Abstract API layer; document schema assumptions; build demo mode first |
| App Store rejection for vague "astrology" category policy | Low | High | Ensure app is factual/calculation-based, not making medical or fortune-telling claims |
| Negative reviews if the real result feels worse than the demo (MVP); if the paid result feels worse than the demo (V1.5, after IAP) | Medium | High | Demo mock data should represent a realistic (not idealized) result |
| India market expects Vedic framing but V1 is Western | Medium | Medium | Do not advertise in India for MVP; add Vedic framing in V1.5 |
| Professional astrologers distrust automated output | Low | Low | Target casual/intermediate users in V1; don't market to professionals |
| Birth data exposure via API call | Low | High | HTTPS only; production calls go through our backend proxy (no shared secret in app); user-supplied keys in keychain; privacy policy disclosure |
| Provider key extracted from app binary | High (if bundled) | High | Never bundle the provider key; backend proxy holds it server-side in production; dev/pro mode uses the user's own key |

---

## 17. Product Phases

### MVP (this document)

**Goal:** Validate the core loop and user intent to run a real calculation. MVP has no payment, so it does **not** validate true willingness-to-pay — that is a V1.5 goal once IAP ships.

**Scope:** Birth data input → time window → life events → API call → result with confidence + evidence → history. Demo mode with mock result (no key, no payment). Real calculation via configured API access (backend proxy in production, or user-supplied key in dev/pro mode). **No IAP / payment in MVP** — pricing assumption only. iOS + Android.

**Timeline assumption:** 8–12 weeks from design-complete to App Store submission.

**Success gate:** 5%+ demo-to-real-calculation conversion in first 200 users; 99%+ crash-free sessions.

---

### V1.5 — Polish and Growth

**Unlocks after MVP:** Validated core loop and demo-to-real-calculation intent, stable API integration, ≥100 real calculations completed. (True willingness-to-pay is validated *within* V1.5 once IAP ships — see below — it is not an MVP precondition.)

Features to add:
- **Real monetization:** in-app purchase ("1 Calculation Credit"), restore purchase, purchase history, and refund / credit-restoration flows. This is the phase that validates true willingness-to-pay.
- PDF / image export of result for sharing (shareable card + full report)
- Multiple candidate times comparison view (side-by-side)
- Hindi language localization
- Vedic/KP method framing (if API supports it)
- Onboarding improvement based on drop-off data
- Event templates ("suggest events based on age")
- Astrology creator-friendly share card (branded screenshot)

Monetization consideration: After per-calculation IAP is proven, evaluate a subscription model ($7.99/month for unlimited calculations) based on repeat usage data.

---

### V2 — Platform and Community

**Unlocks after V1.5:** Subscription revenue proven; significant Hindi-speaking user base; positive professional astrologer feedback.

Features to add:
- Birth chart rendering from rectified time (via same or additional API)
- Professional astrologer verification tier (human review of automated result)
- Multi-profile support (for astrologers managing client calculations)
- Syncing across devices (requires server-side account)
- Transit and Dasha timeline from rectified time
- Community or social layer (compare results, share stories)
- API for third-party birth chart apps to use Rectify as a rectification module
