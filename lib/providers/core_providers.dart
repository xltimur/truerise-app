import 'package:dio/dio.dart';
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
      env: String.fromEnvironment('RECTIFY_ENV', defaultValue: 'dev'),
    );
  }

  final String proxyBaseUrl;
  final String proxyAppId;
  final String proxyPath;
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

/// Reactively-read snapshot of the end-user-supplied Pro / Developer
/// key (`docs/implementation-plan.md` §9.5).
///
/// `null` (or empty) means proxy mode — every other consumer flips to
/// provider-direct + Bearer header. Watching this provider is what
/// makes [dioProvider] rebuild on key rotation without leaking the
/// value past the data layer.
final proApiKeyProvider = FutureProvider<String?>((ref) async {
  final store = ref.watch(secureKeyStoreProvider);
  final key = await store.readProApiKey();
  return (key == null || key.isEmpty) ? null : key;
});

/// Configured [Dio] for the rectification provider
/// (`docs/implementation-plan.md` §9.5).
///
/// Rebuilds when `RECTIFY_PROXY_BASE_URL` or the Pro key change.
/// Disposes its predecessor so old `HttpClientAdapter` sockets don't
/// leak across rotations.
final dioProvider = Provider<Dio>((ref) {
  final config = ref.watch(buildConfigProvider);
  final keyAsync = ref.watch(proApiKeyProvider);
  final key = keyAsync.maybeWhen(data: (k) => k, orElse: () => null);
  final dio = buildDio(
    baseUrl: config.proxyBaseUrl,
    authMode: key == null ? AuthMode.proxy : AuthMode.providerDirect,
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
/// Phase 6 wires the real submission path. Demo runs short-circuit in
/// the repository (no HTTP client constructed) per §9.5 / §10.4; the
/// API instance built here is only consulted on the real path.
final rectificationApiProvider = Provider<RectificationApi>((ref) {
  final dio = ref.watch(dioProvider);
  final path = ref.watch(buildConfigProvider).proxyPath;
  return HttpRectificationApi(dio, path: path);
});
