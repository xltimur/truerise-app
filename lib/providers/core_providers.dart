import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rectify/data/api/api_client.dart';
import 'package:rectify/data/api/rectification_api.dart';
import 'package:rectify/data/db/database.dart';
import 'package:rectify/data/prefs/settings_store.dart';
import 'package:rectify/data/secure/secure_key_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Build-time configuration carried via `--dart-define` per
/// Appendix B (`docs/implementation-plan.md`).
///
/// `RECTIFY_PROXY_APP_ID` is a **public app identifier**, not a
/// secret (see §9.5). Empty string is acceptable in tests / debug
/// builds — the production proxy gates traffic server-side anyway.
/// `proxyPath` is the rectification endpoint path on whichever
/// proxy / provider URL is configured; isolated here so a schema
/// migration is a one-line override (§9.3 — DTO + mapper stay put).
class RectifyBuildConfig {
  const RectifyBuildConfig({
    required this.proxyBaseUrl,
    required this.proxyAppId,
    required this.proxyPath,
    required this.providerBaseUrl,
    required this.providerPath,
    required this.env,
    this.requestTimeout = const Duration(seconds: 30),
  });

  factory RectifyBuildConfig.fromEnvironment() {
    return const RectifyBuildConfig(
      // Default points at an explicitly-invalid host so an unconfigured
      // release build fails fast (DNS error → NoNetworkFailure) instead
      // of silently leaking traffic. Configure with --dart-define.
      proxyBaseUrl: String.fromEnvironment(
        'RECTIFY_PROXY_BASE_URL',
        defaultValue: 'https://proxy.invalid.example',
      ),
      proxyAppId: String.fromEnvironment('RECTIFY_PROXY_APP_ID'),
      proxyPath: String.fromEnvironment(
        'RECTIFY_PROXY_PATH',
        defaultValue: '/v1/rectification',
      ),
      // Provider-direct mode: user supplies their own astrology-api.io key.
      // Base URL and path are public config — not secrets.
      providerBaseUrl: String.fromEnvironment(
        'RECTIFY_PROVIDER_BASE_URL',
        defaultValue: 'https://api.astrology-api.io',
      ),
      providerPath: String.fromEnvironment(
        'RECTIFY_PROVIDER_PATH',
        defaultValue: '/api/v3/rectification/search',
      ),
      env: String.fromEnvironment('RECTIFY_ENV', defaultValue: 'dev'),
    );
  }

  final String proxyBaseUrl;
  final String proxyAppId;
  final String proxyPath;

  /// Base URL used when the user has entered their own provider API key
  /// (providerDirect auth mode). Defaults to https://api.astrology-api.io.
  final String providerBaseUrl;

  /// Endpoint path used in providerDirect mode.
  /// Defaults to /api/v3/rectification/search.
  final String providerPath;

  final String env;
  final Duration requestTimeout;
}

/// Build configuration. Override in tests with
/// `ProviderScope(overrides: [buildConfigProvider.overrideWithValue(...)])`.
final buildConfigProvider = Provider<RectifyBuildConfig>(
  (ref) => RectifyBuildConfig.fromEnvironment(),
);

/// Synchronous handle to the resolved [SharedPreferences] instance.
///
/// Overridden in `main()` with the instance returned by
/// [SharedPreferences.getInstance], so every consumer (router gate,
/// settings controller, repositories) can read prefs without juggling
/// an `AsyncValue`. Tests override this with their own mocked prefs.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError(
    'sharedPreferencesProvider must be overridden during app bootstrap.',
  ),
);

/// Wraps the resolved [SharedPreferences] in our typed store.
final settingsStoreProvider = Provider<SettingsStore>(
  (ref) => SettingsStore(ref.watch(sharedPreferencesProvider)),
);

/// Secure-storage handle for the end-user-supplied Pro / Developer key.
final secureKeyStoreProvider = Provider<SecureKeyStore>(
  (ref) => SecureKeyStore(),
);

/// Drift database. Disposed when the app shuts down.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// Demo-build fallback key sourced from the bundled `.env` asset
/// (loaded in `main.dart`). Returns `null` when `.env` is missing or
/// the slot is empty — tests, unbundled builds, and the canonical
/// proxy-mode path all see a clean `null`. Overridable in tests via
/// `envApiKeyProvider.overrideWithValue(null)`.
///
/// The end-user-supplied key in `flutter_secure_storage` always wins
/// over this fallback — see [proApiKeyProvider].
final envApiKeyProvider = Provider<String?>((ref) {
  // dotenv.env returns an empty Map if load() was never called, so this
  // is safe to read in tests that skip the bootstrap path.
  final raw = dotenv.env['ASTRO_API_KEY'];
  if (raw == null) return null;
  final trimmed = raw.trim();
  return trimmed.isEmpty ? null : trimmed;
});

/// Reactively-read snapshot of the active provider key
/// (`docs/implementation-plan.md` §9.5).
///
/// Priority order:
///   1. End-user-supplied key in `flutter_secure_storage` (Settings).
///   2. Demo-build fallback from the bundled `.env` (ASTRO_API_KEY).
///   3. `null` → proxy mode.
///
/// `null` (or empty) means proxy mode — every other consumer flips to
/// provider-direct + Bearer header. Watching this provider is what
/// makes [dioProvider] rebuild on key rotation without leaking the
/// value past the data layer.
final proApiKeyProvider = FutureProvider<String?>((ref) async {
  final store = ref.watch(secureKeyStoreProvider);
  final stored = await store.readProApiKey();
  if (stored != null && stored.isNotEmpty) return stored;
  return ref.watch(envApiKeyProvider);
});

/// The provider API key the data layer should act on **synchronously**.
///
/// [proApiKeyProvider] is a `FutureProvider`: until the secure-storage
/// read settles it reports `loading`. A consumer that collapses that
/// `loading` state to "no key" routes the very first submission to the
/// unconfigured proxy placeholder (`POST /v1/rectification` on
/// `proxy.invalid.example`) instead of the live provider endpoint.
///
/// The bundled `.env` key ([envApiKeyProvider]) is resolved
/// synchronously — `dotenv.load()` runs before `runApp` — so fall back
/// to it while the secure read is in flight. A bundled key alone
/// already guarantees provider-direct mode; a stored key, if present,
/// only swaps the bearer token once [proApiKeyProvider] resolves. This
/// keeps [dioProvider] and [rectificationApiProvider] on the live
/// endpoint from their first build.
final activeApiKeyProvider = Provider<String?>((ref) {
  final resolved = ref.watch(proApiKeyProvider);
  final envKey = ref.watch(envApiKeyProvider);
  return resolved.maybeWhen(data: (key) => key, orElse: () => envKey);
});

/// Configured [Dio] for the rectification provider
/// (`docs/implementation-plan.md` §9.5).
///
/// Selects base URL based on auth mode:
///   - providerDirect → config.providerBaseUrl (https://api.astrology-api.io)
///   - proxy          → config.proxyBaseUrl
///
/// Rebuilds when the Pro key changes, disposing old sockets cleanly.
final dioProvider = Provider<Dio>((ref) {
  final config = ref.watch(buildConfigProvider);
  final key = ref.watch(activeApiKeyProvider);
  final isProviderDirect = key != null && key.isNotEmpty;
  final dio = buildDio(
    baseUrl: isProviderDirect ? config.providerBaseUrl : config.proxyBaseUrl,
    authMode: isProviderDirect ? AuthMode.providerDirect : AuthMode.proxy,
    bearerToken: key,
    timeout: config.requestTimeout,
    proxyAppId: config.proxyAppId.isEmpty ? null : config.proxyAppId,
  );
  ref.onDispose(dio.close);
  return dio;
});

/// Configured `Dio`-backed rectification API
/// (`docs/implementation-plan.md` §9.5).
///
/// Selects the endpoint path based on auth mode:
///   - providerDirect → config.providerPath (/api/v3/rectification/search)
///   - proxy          → config.proxyPath
///
/// Demo runs short-circuit in the repository (no HTTP client constructed).
final rectificationApiProvider = Provider<RectificationApi>((ref) {
  final config = ref.watch(buildConfigProvider);
  final key = ref.watch(activeApiKeyProvider);
  final isProviderDirect = key != null && key.isNotEmpty;
  final path = isProviderDirect ? config.providerPath : config.proxyPath;
  return HttpRectificationApi(ref.watch(dioProvider), path: path);
});
