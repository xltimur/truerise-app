# Rectify Proxy Contract (Optional Mobile <-> Backend Handoff)

Owner contract for an optional production rectification proxy. Audience:
Oleg / backend. As of 2026-06-22, Oleg confirmed
`https://api-public.astrology-api.io` for owner-billed public no-key app access,
so the mobile app defaults to that host and path
`/api/v3/rectification/search`. This document remains the handoff contract if
the owner later wants stronger backend-controlled quota, device attestation, or
server-side provider-key storage.

## 1. Endpoint

- Public no-key default: `POST /api/v3/rectification/search` on
  `https://api-public.astrology-api.io`.
- Optional owner-controlled proxy path: `POST /v1/rectification`.
- If the final proxy path differs, that is fine: the release build must
  then be given the real path via the `RECTIFY_PROXY_PATH` dart-define.
  No code change needed, but the value must be supplied before release.
- HTTPS only. The base host is supplied via `RECTIFY_PROXY_BASE_URL`.

## 2. Auth modes (who hits the proxy)

| Mode | Network | Hits proxy | Quota applies |
|---|---|---|---|
| Demo | None (fully offline) | No | No |
| Public no-key (default free tier) | HTTPS to api-public.astrology-api.io | No | Yes, local UX quota |
| Owner proxy (optional hard quota) | HTTPS to proxy | Yes | Yes, server-enforced |
| Provider-direct (user's own key) | HTTPS to api.astrology-api.io | No | No |

- Demo mode never makes a network call of any kind.
- No-key mode uses the Oleg-provided public host without an Authorization
  header. Oleg confirmed this owner-billed mode is intended for the mobile app
  and has service-side protection against mass requests. The app keeps the
  local 3-per-24h quota, but this is not a true backend-controlled per-device
  guarantee.
- A user-entered provider API key switches the app to provider-direct
  mode: requests go straight to the provider with the user's key as
  Bearer, bypassing the local free quota entirely.
- Provider-direct must stay on the canonical provider host by default. A
  2026-06-22 bounded invalid-key check against `api-public.astrology-api.io`
  returned `HTTP 200` with `x-auth-bypass: true`, meaning that host ignored the
  invalid Authorization value and used owner-billed bypass instead.
- Before release, run one owner-approved valid-key call against the canonical
  provider host to confirm that `POST /api/v3/rectification/search` accepts the
  same request schema with a real Bearer token. That check should be bounded
  because it consumes provider credits.
- If an owner-controlled proxy is introduced later, the shared provider API key
  lives ONLY on the proxy, server-side. It is never bundled in, sent to, or
  visible from the app.

## 3. Quota

- Current app UX quota: 3 live requests per rolling 24 hours per client.
- The quota and all anti-abuse limits MUST be enforced server-side using
  backend-controlled signals: caller IP, a per-install / device signal
  or fingerprint, and optionally Play Integrity (Android), App Attest
  (iOS), or Firebase App Check if the owner needs a hard quota.
- The public host's service-side mass-request protection is owner/provider
  asserted, not specified in the current OpenAPI contract: bounded checks found
  no documented `429` schema and no `RateLimit-*` / `X-RateLimit-*` headers on
  root/OpenAPI responses. Do not load-test the paid endpoint to force 429;
  request exact limits from the owner/provider instead.
- The app keeps a local 3-per-24h counter, but it is a UX / release
  guard only. It is trivially reset (reinstall, clear data, "Delete all
  data") and MUST NOT be treated as real protection.
- `X-Rectify-App-Id` identifies the app build, not a user or device. It
  is public and spoofable; do not use it as the sole rate-limit key.

## 4. Request / response shape

Pass-through. The proxy receives the same JSON body the app would send
to the provider (astrology-api.io v3 rectification search,
`POST /api/v3/rectification/search`), attaches the server-side provider
key, forwards it, and returns the provider response body unchanged on
success. The mobile DTO and mapper parse the provider's response shape
directly; the proxy must not rewrap or re-envelope successful
responses.

Request headers the app sends:

- `Content-Type: application/json`
- `Accept: application/json`
- `X-Rectify-App-Id: <public app id>` -- present when
  `RECTIFY_PROXY_APP_ID` is configured. This is a public identifier,
  NOT a secret. No `Authorization` header is sent in proxy mode.

## 5. Rate-limit response (429) -- required shape

When the quota is exhausted, return HTTP 429 with a JSON body:

```json
{
  "error": "rate_limited",
  "retryAfter": 5400,
  "resetAt": "2026-06-12T18:30:00Z"
}
```

- `retryAfter`: integer seconds until the client may retry.
- `resetAt`: ISO-8601 UTC timestamp when the quota window reopens.
- Send both when possible; the app tolerates either being absent.
- Snake_case variants (`retry_after`, `reset_at`) are also accepted,
  but prefer camelCase as above.
- The app uses these values to show the user when they can try again.

## 6. Other errors

The app maps statuses as follows; pass provider errors through where
sensible:

- `400` / `422`: payload rejected. Include a human-readable explanation
  in `error.message`, `message`, or `detail` (string or FastAPI-style
  list); the app surfaces it to the user.
- `401` / `403`: treated as unauthorized. From the proxy this signals a
  proxy/provider auth problem, not a user problem -- avoid emitting it
  for quota or abuse decisions (use 429).
- `408`: treated as a timeout.
- `5xx`: generic server failure; the app shows a retry screen. No body
  required, but a JSON `message` is welcome.
- App-side request timeout is 30 seconds; the proxy should respond
  (including provider latency) within that.

## 7. Logging / privacy constraints

The proxy MUST NOT log:

- request bodies or any birth data, life events, or notes they contain;
- response bodies containing computed results;
- the server-side provider API key or any user-supplied key;
- the `X-Rectify-App-Id` value tied to request content.

Method, path, status, latency, and the hashed/derived rate-limit key
are fine. Retain abuse-control data (IP, install signal) only as long
as needed for rate limiting.

## 8. Release env vars (app side, for reference)

The mobile release build is configured via dart-defines:

- `RECTIFY_PROXY_BASE_URL`: no-key live base host (no trailing path).
  Defaults to `https://api-public.astrology-api.io`.
- `RECTIFY_PROXY_PATH`: rectification endpoint path; defaults to
  `/api/v3/rectification/search`. Required only if the final path differs.
- `RECTIFY_PROXY_APP_ID`: public app identifier sent as
  `X-Rectify-App-Id`. Not a secret; useful for an owner-controlled proxy if
  one is introduced.
