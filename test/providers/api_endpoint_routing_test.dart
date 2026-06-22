import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rectify/data/api/api_client.dart';
import 'package:rectify/data/api/rectification_api.dart';
import 'package:rectify/data/repos/rectification_repository.dart';
import 'package:rectify/data/secure/secure_key_store.dart';
import 'package:rectify/providers/core_providers.dart';
import 'package:rectify/providers/repo_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/fake_history_repository.dart';

/// Regression coverage for the live-endpoint routing bug.
///
/// `proApiKeyProvider` is a `FutureProvider`; before this fix the Dio /
/// API providers collapsed its `loading` state to "no key" and pinned
/// the very first submission to no-key public-host mode. With a key in
/// the bundled `.env`, the data layer must reach the live endpoint
/// `https://api.astrology-api.io/api/v3/rectification/search` instead —
/// synchronously, without waiting on the async secure-storage read.
///
/// Async only to resolve the mock [SharedPreferences] instance backing
/// `liveQuotaStoreProvider`; no provider inside the container is read
/// here, so the secure-storage race window stays open for the caller.
Future<ProviderContainer> _container({
  required String? envKey,
  String? storedKey,
  RectifyBuildConfig? buildConfig,
}) async {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  final prefs = await SharedPreferences.getInstance();
  final container = ProviderContainer(
    overrides: [
      if (buildConfig != null)
        buildConfigProvider.overrideWithValue(buildConfig),
      envApiKeyProvider.overrideWithValue(envKey),
      secureKeyStoreProvider.overrideWithValue(
        InMemorySecureKeyStore(seed: storedKey),
      ),
      sharedPreferencesProvider.overrideWithValue(prefs),
      historyRepositoryProvider.overrideWithValue(FakeHistoryRepository()),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('live endpoint routing (bundled .env key)', () {
    test(
      'rectificationApiProvider targets /api/v3/rectification/search '
      'synchronously, before the secure-storage read settles',
      () async {
        final container = await _container(envKey: 'ask_test_env_key');

        // Precondition: the async secure read is genuinely still in
        // flight — this is the race window the bug used to fail in.
        expect(
          container.read(proApiKeyProvider).isLoading,
          isTrue,
          reason: 'proApiKeyProvider should not have resolved yet',
        );

        final api = container.read(rectificationApiProvider);
        expect(api, isA<HttpRectificationApi>());
        expect(
          (api as HttpRectificationApi).path,
          '/api/v3/rectification/search',
          reason: 'must not leave provider-direct mode during startup',
        );
      },
    );

    test(
      'dioProvider targets the live provider base URL synchronously',
      () async {
        final container = await _container(envKey: 'ask_test_env_key');
        final dio = container.read(dioProvider);
        expect(dio.options.baseUrl, 'https://api.astrology-api.io');
        expect(
          dio.interceptors.whereType<AuthInterceptor>(),
          isNotEmpty,
          reason: 'provider-direct mode must attach the user/bundled key',
        );
      },
    );

    test(
      'repository keeps the local quota enforced for the bundled .env key',
      () async {
        final container = await _container(envKey: 'ask_test_env_key');
        final repo = container.read(rectificationRepositoryProvider);
        expect(repo, isA<LiveRectificationRepository>());
        expect(
          (repo as LiveRectificationRepository).liveQuotaStore,
          isNotNull,
          reason: 'quota store must be wired so live attempts are counted',
        );
        expect(
          repo.bypassLiveQuota,
          isFalse,
          reason: 'the bundled .env key alone must not bypass the quota',
        );
      },
    );

    test(
      'routing still resolves to the live endpoint once the secure '
      'read settles',
      () async {
        final container = await _container(envKey: 'ask_test_env_key');
        await container.read(proApiKeyProvider.future);

        expect(container.read(activeApiKeyProvider), 'ask_test_env_key');
        final api =
            container.read(rectificationApiProvider) as HttpRectificationApi;
        expect(api.path, '/api/v3/rectification/search');
        expect(
          container.read(dioProvider).options.baseUrl,
          'https://api.astrology-api.io',
        );
      },
    );

    test(
      'provider-direct mode uses the provider path when paths differ',
      () async {
        final container = await _container(
          envKey: 'ask_test_env_key',
          buildConfig: const RectifyBuildConfig(
            proxyBaseUrl: 'https://api-public.astrology-api.io',
            proxyAppId: '',
            proxyPath: '/proxy-only',
            providerBaseUrl: 'https://api.astrology-api.io',
            providerPath: '/provider-only',
            env: 'test',
          ),
        );

        final api =
            container.read(rectificationApiProvider) as HttpRectificationApi;
        expect(api.path, '/provider-only');
        expect(
          container.read(dioProvider).options.baseUrl,
          'https://api.astrology-api.io',
        );
      },
    );
  });

  group('auth-mode precedence', () {
    test('a Settings-entered key overrides the bundled .env key', () async {
      final container = await _container(
        envKey: 'ask_env_key',
        storedKey: 'ask_user_entered_key',
      );
      await container.read(proApiKeyProvider.future);
      expect(container.read(activeApiKeyProvider), 'ask_user_entered_key');
      final repo =
          container.read(rectificationRepositoryProvider)
              as LiveRectificationRepository;
      expect(
        repo.bypassLiveQuota,
        isTrue,
        reason: 'a user-entered key must bypass the local live quota',
      );
    });

    test('with no key anywhere the API uses the public no-key host', () async {
      final container = await _container(envKey: null);
      await container.read(proApiKeyProvider.future);

      expect(container.read(activeApiKeyProvider), isNull);
      final api =
          container.read(rectificationApiProvider) as HttpRectificationApi;
      expect(api.path, '/api/v3/rectification/search');
      expect(
        container.read(dioProvider).options.baseUrl,
        'https://api-public.astrology-api.io',
      );
      expect(
        container.read(dioProvider).interceptors.whereType<AuthInterceptor>(),
        isEmpty,
        reason: 'public no-key mode must not send Authorization',
      );
      // No-key submissions go through the public API host. The repository
      // must keep the local free-attempt quota enforced and never bypass it.
      final repo = container.read(rectificationRepositoryProvider);
      expect(
        (repo as LiveRectificationRepository).liveQuotaStore,
        isNotNull,
        reason: 'proxy-mode attempts must be counted against the free quota',
      );
      expect(repo.bypassLiveQuota, isFalse);
    });

    test('no-key mode uses the proxy/no-key path when paths differ', () async {
      final container = await _container(
        envKey: null,
        buildConfig: const RectifyBuildConfig(
          proxyBaseUrl: 'https://api-public.astrology-api.io',
          proxyAppId: '',
          proxyPath: '/proxy-only',
          providerBaseUrl: 'https://api.astrology-api.io',
          providerPath: '/provider-only',
          env: 'test',
        ),
      );
      await container.read(proApiKeyProvider.future);

      final api =
          container.read(rectificationApiProvider) as HttpRectificationApi;
      expect(api.path, '/proxy-only');
      expect(
        container.read(dioProvider).options.baseUrl,
        'https://api-public.astrology-api.io',
      );
    });
  });
}
