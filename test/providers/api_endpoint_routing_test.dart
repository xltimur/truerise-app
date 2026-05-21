import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rectify/data/api/rectification_api.dart';
import 'package:rectify/data/repos/rectification_repository.dart';
import 'package:rectify/data/secure/secure_key_store.dart';
import 'package:rectify/providers/core_providers.dart';
import 'package:rectify/providers/repo_providers.dart';

import '../helpers/fake_history_repository.dart';

/// Regression coverage for the live-endpoint routing bug.
///
/// `proApiKeyProvider` is a `FutureProvider`; before this fix the Dio /
/// API providers collapsed its `loading` state to "no key" and pinned
/// the very first submission to the proxy placeholder
/// (`POST /v1/rectification` on `proxy.invalid.example`, which fails
/// with a `connectionError`). With a key in the bundled `.env`, the
/// data layer must reach the live endpoint
/// `https://api.astrology-api.io/api/v3/rectification/search` instead —
/// synchronously, without waiting on the async secure-storage read.
ProviderContainer _container({
  required String? envKey,
  String? storedKey,
}) {
  final container = ProviderContainer(
    overrides: [
      envApiKeyProvider.overrideWithValue(envKey),
      secureKeyStoreProvider.overrideWithValue(
        InMemorySecureKeyStore(seed: storedKey),
      ),
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
      () {
        final container = _container(envKey: 'ask_test_env_key');

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
          reason: 'must not fall back to the proxy /v1/rectification path',
        );
      },
    );

    test('dioProvider targets the live provider base URL synchronously', () {
      final container = _container(envKey: 'ask_test_env_key');
      final dio = container.read(dioProvider);
      expect(dio.options.baseUrl, 'https://api.astrology-api.io');
    });

    test(
      'repository reports the key as configured so submit() reaches the '
      'network instead of returning MissingApiKeyFailure',
      () {
        final container = _container(envKey: 'ask_test_env_key');
        final repo = container.read(rectificationRepositoryProvider);
        expect(repo, isA<LiveRectificationRepository>());
        expect(
          (repo as LiveRectificationRepository).apiKeyIsConfigured,
          isTrue,
        );
      },
    );

    test(
      'routing still resolves to the live endpoint once the secure '
      'read settles',
      () async {
        final container = _container(envKey: 'ask_test_env_key');
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
  });

  group('auth-mode precedence', () {
    test('a Settings-entered key overrides the bundled .env key', () async {
      final container = _container(
        envKey: 'ask_env_key',
        storedKey: 'ask_user_entered_key',
      );
      await container.read(proApiKeyProvider.future);
      expect(container.read(activeApiKeyProvider), 'ask_user_entered_key');
    });

    test('with no key anywhere the API falls back to proxy mode', () async {
      final container = _container(envKey: null);
      await container.read(proApiKeyProvider.future);

      expect(container.read(activeApiKeyProvider), isNull);
      final api =
          container.read(rectificationApiProvider) as HttpRectificationApi;
      expect(api.path, '/v1/rectification');
      expect(
        container.read(dioProvider).options.baseUrl,
        'https://proxy.invalid.example',
      );
      final repo = container.read(rectificationRepositoryProvider);
      expect(
        (repo as LiveRectificationRepository).apiKeyIsConfigured,
        isFalse,
      );
    });
  });
}
