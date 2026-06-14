# Rectify Proxy Contract (Mobile <-> Backend Handoff)

Owner contract for the production rectification proxy. Audience: Oleg /
backend. The mobile app is already built against this contract; anything
the proxy changes here requires a coordinated app release.

## 1. Endpoint

- `POST /v1/rectification` is the path the app currently expects
  (build-time default).
- If the final proxy path differs, that is fine: the release build must
  then be given the real path via the `RECTIFY_PROXY_PATH` dart-define.
  No code change needed, but the value must be supplied before release.
- HTTPS only. The base host is supplied via `RECTIFY_PROXY_BASE_URL`.

## 2. Auth modes (who hits the proxy)

| Mode | Network | Hits proxy | Quota applies |
|---|---|---|---|
| Demo | None (fully offline) | No | No |
| Proxy (default free tier) | HTTPS to proxy | Yes | Yes |
| Provider-direct (user's own key) | HTTPS to api.astrology-api.io | No | No |

- Demo mode never makes a network call of any kind.
- A user-entered provider API key switches the app to provider-direct
  mode: requests go straight to the provider with the user's key as
  Bearer, bypassing the proxy and its shared quota entirely.
- The shared provider API key lives ONLY on the proxy, server-side. It
  is never bundled in, sent to, or visible from the app.

## 3. Quota

- Free tier: 3 live requests per rolling 24 hours per client.
- The quota and all anti-abuse limits MUST be enforced server-side using
  backend-controlled signals: caller IP, a per-install / device signal
  or fingerprint, and optionally Play Integrity (Android), App Attest
  (iOS), or Firebase App Check.
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

The mobile release build is configured via dart-defines; backend must
supply the final values:

- `RECTIFY_PROXY_BASE_URL`: real HTTPS proxy host (no trailing path).
  Unconfigured builds default to an invalid host and fail fast.
- `RECTIFY_PROXY_PATH`: rectification endpoint path; defaults to
  `/v1/rectification`. Required only if the final path differs.
- `RECTIFY_PROXY_APP_ID`: public app identifier sent as
  `X-Rectify-App-Id`. Not a secret, but must match what the proxy
  expects.
