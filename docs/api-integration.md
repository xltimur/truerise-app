# astrology-api.io Live Integration Reference

This document covers everything a developer needs to understand, test, and
debug the live rectification API integration.

The DTOs and mappers in `lib/data/api/` are aligned to the live OpenAPI
spec verified at <https://api.astrology-api.io/api/v3/openapi.json>.

---

## Endpoint

| Property | Value |
|---|---|
| Method | `POST` |
| URL | `https://api.astrology-api.io/api/v3/rectification/search` |
| Content-Type | `application/json` |
| Auth | `Authorization: Bearer <user-api-key>` |
| Cost | 15 credits per request |

Interactive docs: <https://api.astrology-api.io/rapidoc>  
OpenAPI JSON: <https://api.astrology-api.io/api/v3/openapi.json>

The category enum is also discoverable at runtime via
`GET /api/v3/rectification/glossary/event-categories` (0 credits).

---

## Authentication

The app uses **providerDirect** auth mode when the user has entered their own
astrology-api.io key in Settings.

- The key is stored exclusively in `flutter_secure_storage` (`lib/data/secure/secure_key_store.dart`).
- `lib/providers/core_providers.dart` → `proApiKeyProvider` reads the key asynchronously.
- When the key is present, `dioProvider` sets `baseUrl = config.providerBaseUrl` and
  `AuthInterceptor` adds `Authorization: Bearer <key>` to every request header.
- The key **never** appears in: SharedPreferences, Drift columns, log lines, or the POST body.
- When no key is configured, `LiveRectificationRepository.submit()` returns
  `MissingApiKeyFailure` immediately — no network call is made.

---

## Request payload (`RectificationSearchRequestDto`)

```json
{
  "subject": {
    "birth_data": {
      "year": 1990,
      "month": 5,
      "day": 14,
      "hour": 14,
      "minute": 0,
      "second": 0,
      "city": "Kyiv, Ukraine",
      "latitude": 50.4501,
      "longitude": 30.5234
    }
  },
  "time_search": {
    "delta_minutes": 60,
    "step_minutes": 4
  },
  "events": [
    {
      "category": "marriage",
      "date": "2014-06",
      "date_precision": "month"
    },
    {
      "category": "move",
      "date": "2021",
      "date_precision": "year"
    }
  ]
}
```

### `subject.birth_data.hour` / `minute` is the search anchor

In approximate mode the provider centers `time_search.delta_minutes` on
the value of `birth_data.hour:minute`. The mapper writes the user's
best-guess time there. In unknown mode it falls back to 12:00 — benign
because that mode uses an explicit `start`/`end` instead of the delta.

### `time_search` by mode

| Domain mode | Provider fields |
|---|---|
| `approximate` (known ± window) | `delta_minutes` (half-width), `step_minutes` (grid resolution) |
| `unknown` (full 24h) | `start: "00:00"`, `end: "23:59"`, `step_minutes` |

The app sends `step_minutes: 4` for both modes (`kRectificationStepMinutes`
in `lib/data/api/mappers.dart`). The provider rejects any search that
resolves to **more than 500 candidate times**; a 4-minute grid keeps the
24h `unknown` window at ~360 candidates and the widest `approximate`
window (±360) at ~180. A finer 2-minute grid produced ~719 candidates on
the 24h range and the request was rejected outright.

### Event `date` format

| Known precision | `date` value | `date_precision` |
|---|---|---|
| Day | `YYYY-MM-DD` | omitted (provider default `"exact"`) |
| Month only | `YYYY-MM` | `"month"` |
| Year only | `YYYY` | `"year"` |

### No `events[].id` field

The provider's `EventInput` schema has no `id`. Evidence is correlated
back to the request via array position (`event_scores[].event_index`).
The mapper restores the domain `LifeEvent.id` from that index.

---

## Event category mapping

Domain `EventCategory` tags map to provider category strings as follows.
Verified against the live OpenAPI spec (astrology-api.io v3, 2026-05-20).

| Domain tag | Provider string | Notes |
|---|---|---|
| `marriage` | `marriage` | |
| `divorce` | `divorce` | |
| `career_change` | `career_change` | |
| `job_loss` | `job_loss` | |
| `relocation` | `move` | provider enum value differs from domain tag |
| `child_birth` | `child_birth` | |
| `family_death` | `death_family` | provider uses reversed word order |
| `illness` | `health_diagnosis` | no `illness` in provider enum; nearest safe default |
| `accident` | `accident` | |
| `education` | `education` | |
| `financial` | `financial_gain` | no `financial` in provider enum; gain chosen as safer default |
| `other` | `other` | |

Mapping lives in `lib/data/api/mappers.dart` → `_providerCategoryMap`.

The provider also accepts six additional values the domain doesn't
surface yet: `career_promotion`, `surgery`, `relationship_start`,
`relationship_end`, `financial_loss`, `spiritual`.

---

## Response payload (`RectificationSearchResponseDto`)

The live API wraps every successful body in a thin envelope; the DTO
models only the **inner** business shape. `HttpRectificationApi.rectify`
peels the envelope (`{ success, data: { ... }, metadata }`) before
handing the inner object to the DTO parser.

Verified live wire shape (2026-05-20):

```json
{
  "success": true,
  "data": {
    "candidates": [
      {
        "rank": 1,
        "time": "07:14",
        "aggregate_score": 18.4,
        "normalized_score": 78.0,
        "grade": "good",
        "events_strongly_correlated": 2,
        "event_scores": [
          {
            "event_index": 0,
            "event_date": "2014-06",
            "event_category": "marriage",
            "total_score": 9.1,
            "interpretation": "Venus return aligned with the event timing."
          }
        ],
        "chart": { "planetary_positions": [{"name": "Ascendant", "sign": "Gem"}], "... ": "" }
      }
    ],
    "density": [{"time": "07:14", "aggregate_score": 18.4, "normalized_score": 78.0}],
    "summary": {
      "confidence": {
        "level": "medium",
        "explanation": "Top candidates separated cleanly.",
        "gap_ratio": 0.18,
        "lift_ratio": 1.21
      },
      "peak_time": "07:14",
      "techniques_used": ["transit", "progression"],
      "step_minutes": 2
    },
    "computed_at": "2026-05-20T12:00:00Z"
  },
  "metadata": {
    "api_version": "3.2.0",
    "credits_used": 15,
    "request_id": "req_…"
  }
}
```

The full raw JSON body (envelope included) is persisted verbatim in the
`rawResponseJson` column of the `saved_calculations` Drift table for
support reproductions. The DTO ignores `density`, `metadata`,
`warnings`, and `pagination` — they are kept only in the raw blob.

### Domain mapping highlights

- **Confidence (0..1)** comes from `candidates[].normalized_score / 100`.
  The provider's `summary.confidence.level` is a human label (high /
  medium / low) and is not stored on the domain candidate.
- **Ascendant** is extracted from `candidates[].chart.planetary_positions`
  (entry with `name="Ascendant"`) and falls back to
  `chart.house_cusps[house=1].sign`. Sign abbreviations (`Gem`, `Lib`)
  are expanded to full words (`Gemini`, `Libra`).
- **Evidence** is built from the rank-1 (non-excluded) candidate's
  `event_scores[]`. Each `EventScore.event_index` is resolved back to a
  domain `LifeEvent.id` using the original request's event list.
- **MatchStrength** is bucketed from `EventScore.total_score`:
  `≥0.7 × candidate_local_max` → strong, `≥0.4` → moderate,
  `> 0` → weak, `0` → none. The local-max heuristic stands in for the
  provider's theoretical-max-per-category which is not returned
  directly in the response.
- **`method`** is set to `summary.techniques_used.join('+')` —
  there is no `calculation_id` or single-string method in the v3
  response, so `apiCalculationId` is always null.

### `confidence.level` values

`high` | `medium` | `low` | `n_a` (carried verbatim; unused by the UI today).

---

## Known limits

- **Cost:** 15 credits per request. Do not call the real endpoint in unit
  tests or hot-reload loops.
- **Candidate cap:** a search may resolve to at most **500 candidate
  times** (roughly `window ÷ step_minutes`). The app pins `step_minutes`
  to `4` to stay under the cap for every window it builds. An over-cap
  request is rejected *before* computation, so it costs **0 credits** —
  and (a provider quirk) the live API returns **HTTP 500** with
  `error.code = "INTERNAL_ERROR"` for it, even though the OpenAPI spec
  documents this as `400`. `mapDioException` maps a documented `400`/`422`
  to `BadRequestFailure`; the 4-minute grid keeps the over-cap case from
  arising at all.
- **Rate limiting:** 429 → `RateLimitedFailure` in the app.
- **Timeout:** 30s default (`config.requestTimeout`). Large event lists
  may be slow on the first request.
- **Credentials:** The user-supplied key is never rotated automatically. If
  the key is revoked, the next real-path submission returns
  `UnauthorizedFailure` (HTTP 401/403) and the UI shows an error screen.

---

## Local verification (no real credits spent)

### 1. Demo mode (offline, zero network calls)

```bash
flutter run   # no --dart-define needed
```

Toggle **Settings → Demo mode** on. Every submission uses hardcoded fixture
data (`lib/data/demo/demo_response.dart`).

### 2. Unit tests (FakeHttpAdapter)

```bash
flutter test test/data/api/
flutter test test/data/repos/
```

The fake adapter (`test/data/api/fake_http_adapter.dart`) intercepts Dio
at the transport layer — no network calls, no credits consumed.

### 3. curl dry-run against the live endpoint

```bash
# Replace <YOUR_KEY> with a real key — NOT committed to the repo.
curl -s -X POST https://api.astrology-api.io/api/v3/rectification/search \
  -H "Authorization: Bearer <YOUR_KEY>" \
  -H "Content-Type: application/json" \
  -d '{
    "subject": {
      "birth_data": {
        "year": 1990, "month": 5, "day": 14,
        "hour": 14, "minute": 0, "second": 0,
        "city": "Kyiv, Ukraine",
        "latitude": 50.4501, "longitude": 30.5234
      }
    },
    "time_search": { "delta_minutes": 60, "step_minutes": 4 },
    "events": [
      { "category": "marriage", "date": "2014-06", "date_precision": "month" }
    ]
  }'
```

Compare the response shape to `RectificationSearchResponseDto` in
`lib/data/api/dto/rectification_response_dto.dart`.

You can also list the canonical category enum without paying credits:

```bash
curl -s https://api.astrology-api.io/api/v3/rectification/glossary/event-categories \
  -H "Authorization: Bearer <YOUR_KEY>"
```

---

## File map

| Layer | File |
|---|---|
| Build config (URLs) | `lib/providers/core_providers.dart` |
| Dio factory + interceptors | `lib/data/api/api_client.dart` |
| API interface + HTTP impl | `lib/data/api/rectification_api.dart` |
| Request DTO | `lib/data/api/dto/rectification_request_dto.dart` |
| Response DTO | `lib/data/api/dto/rectification_response_dto.dart` |
| Domain ↔ DTO mappers | `lib/data/api/mappers.dart` |
| Repository (demo / no-key / real) | `lib/data/repos/rectification_repository.dart` |
| Secure key storage | `lib/data/secure/secure_key_store.dart` |
| Settings UI (key entry) | `lib/features/settings/api_key_sheet.dart` |
| Failures hierarchy | `lib/core/failures.dart` |
