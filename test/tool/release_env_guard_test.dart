import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/release_env_guard.dart';

/// Obviously-fake key used to prove redaction; never a real credential.
const String _fakeKey = 'fake-test-key-A1B2C3-not-real';

/// Default share/invite URL; the owner-confirmed primary domain.
/// Passes the release gate without explicit acknowledgement.
const String _defaultShareUrl = 'https://truerise.com.ua';

/// Owner-controlled custom share URL: bare HTTPS, no query, fragment, or
/// userinfo, so it carries no tracking/personal identifiers.
const String _safeShareUrl = 'https://get.example.com';

/// Satisfies the share-url gate in tests that are about other gates.
const String _safeShareUrlArg = '--share-url=$_safeShareUrl';

/// Default RECTIFY_PROXY_BASE_URL; Oleg provided this public host for no-key
/// live API calls.
const String _defaultProxyUrl = 'https://api-public.astrology-api.io';

/// Default RECTIFY_PROVIDER_BASE_URL for user-key/provider-direct mode.
const String _defaultProviderUrl = 'https://api.astrology-api.io';

/// Owner-controlled proxy base URL: bare HTTPS, no query, fragment, or
/// userinfo.
const String _safeProxyUrl = 'https://proxy.example.com';

/// Owner-controlled provider-compatible base URL: bare HTTPS origin.
const String _safeProviderUrl = 'https://provider.example.com';

/// Satisfies the proxy-url gate in tests that are about other gates.
const String _safeProxyUrlArg = '--proxy-base-url=$_safeProxyUrl';

/// Safe geocoding public key: a pk.* public client token.
const String _safeGeocodingPublicKey = 'pk.test-geocoding-key';

/// Safe geocoding base URL: host-only HTTPS origin for Nominatim proxy.
const String _safeGeocodingBaseUrl = 'https://geo.example.com';

/// Satisfies the geocoding gate in tests that are about other gates.
const String _safeGeocodingArg =
    '--geocoding-public-key=$_safeGeocodingPublicKey';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('release_env_guard_test');
  });

  tearDown(() async {
    await tempDir.delete(recursive: true);
  });

  Future<String> writeEnv(String content) async {
    final file = File('${tempDir.path}/.env');
    await file.writeAsString(content);
    return file.path;
  }

  group('default mode (no acknowledgement)', () {
    test('fails when ASTRO_API_KEY is present, with redacted output', () async {
      final path = await writeEnv('ASTRO_API_KEY=$_fakeKey\n');

      final result = runGuard([
        '--env-file=$path',
        _safeShareUrlArg,
        _safeProxyUrlArg,
        _safeGeocodingArg,
      ]);

      expect(result.exitCode, isNot(0));
      expect(result.message, contains('ASTRO_API_KEY'));
      expect(result.message, contains('redacted'));
      expect(
        result.message,
        isNot(contains(_fakeKey)),
        reason: 'the guard must never print the key value',
      );
    });

    test('fails for a quoted non-empty key too', () async {
      final path = await writeEnv('ASTRO_API_KEY="$_fakeKey"\n');

      final result = runGuard([
        '--env-file=$path',
        _safeShareUrlArg,
        _safeProxyUrlArg,
        _safeGeocodingArg,
      ]);

      expect(result.exitCode, isNot(0));
      expect(result.message, isNot(contains(_fakeKey)));
    });

    test('passes when the env file is missing', () {
      final result = runGuard([
        '--env-file=${tempDir.path}/does-not-exist',
        _safeShareUrlArg,
        _safeProxyUrlArg,
        _safeGeocodingArg,
      ]);

      expect(result.exitCode, 0);
    });

    test('passes when the key is absent', () async {
      final path = await writeEnv('OTHER_SETTING=1\n');

      expect(
        runGuard([
          '--env-file=$path',
          _safeShareUrlArg,
          _safeProxyUrlArg,
          _safeGeocodingArg,
        ]).exitCode,
        0,
      );
    });

    test('passes when the key is empty or commented out', () async {
      final empty = await writeEnv('ASTRO_API_KEY=\n');
      expect(
        runGuard([
          '--env-file=$empty',
          _safeShareUrlArg,
          _safeProxyUrlArg,
          _safeGeocodingArg,
        ]).exitCode,
        0,
      );

      final quotedEmpty = await writeEnv('ASTRO_API_KEY=""\n');
      expect(
        runGuard([
          '--env-file=$quotedEmpty',
          _safeShareUrlArg,
          _safeProxyUrlArg,
          _safeGeocodingArg,
        ]).exitCode,
        0,
      );

      final commented = await writeEnv('# ASTRO_API_KEY=$_fakeKey\n');
      expect(
        runGuard([
          '--env-file=$commented',
          _safeShareUrlArg,
          _safeProxyUrlArg,
          _safeGeocodingArg,
        ]).exitCode,
        0,
      );
    });
  });

  group('explicit allow mode', () {
    test('succeeds with --allow-bundled-key --purpose=review-capped and '
        'stays redacted', () async {
      final path = await writeEnv('ASTRO_API_KEY=$_fakeKey\n');

      final result = runGuard([
        '--env-file=$path',
        '--allow-bundled-key',
        '--purpose=review-capped',
        _safeShareUrlArg,
        _safeProxyUrlArg,
        _safeGeocodingArg,
      ]);

      expect(result.exitCode, 0);
      expect(result.message, contains('review-capped'));
      expect(result.message, contains('redacted'));
      expect(result.message, isNot(contains(_fakeKey)));
    });

    test('fails without a purpose', () async {
      final path = await writeEnv('ASTRO_API_KEY=$_fakeKey\n');

      final result = runGuard([
        '--env-file=$path',
        '--allow-bundled-key',
        _safeShareUrlArg,
        _safeProxyUrlArg,
        _safeGeocodingArg,
      ]);

      expect(result.exitCode, isNot(0));
      expect(result.message, contains('review-capped'));
      expect(result.message, isNot(contains(_fakeKey)));
    });

    test('fails with a wrong purpose', () async {
      final path = await writeEnv('ASTRO_API_KEY=$_fakeKey\n');

      final result = runGuard([
        '--env-file=$path',
        '--allow-bundled-key',
        '--purpose=production',
        _safeShareUrlArg,
        _safeProxyUrlArg,
        _safeGeocodingArg,
      ]);

      expect(result.exitCode, isNot(0));
      expect(result.message, isNot(contains(_fakeKey)));
    });
  });

  group('share URL gate', () {
    late String envPath;

    setUp(() async {
      // Key-free env so only the share-url gate decides the outcome.
      envPath = await writeEnv('OTHER_SETTING=1\n');
    });

    test('passes when --share-url is omitted: default is the owned primary '
        'domain and requires no explicit acknowledgement', () {
      final result = runGuard([
        '--env-file=$envPath',
        _safeProxyUrlArg,
        _safeGeocodingArg,
      ]);

      expect(result.exitCode, 0);
      expect(result.message, contains(_defaultShareUrl));
    });

    test('passes when the default URL is passed explicitly', () {
      final result = runGuard([
        '--env-file=$envPath',
        '--share-url=$_defaultShareUrl',
        _safeProxyUrlArg,
        _safeGeocodingArg,
      ]);

      expect(result.exitCode, 0);
    });

    test('passes with a custom bare HTTPS share URL', () {
      final result = runGuard([
        '--env-file=$envPath',
        '--share-url=$_safeShareUrl',
        _safeProxyUrlArg,
        _safeGeocodingArg,
      ]);

      expect(result.exitCode, 0);
    });

    test('blocks a custom share URL carrying a query string', () {
      final result = runGuard([
        '--env-file=$envPath',
        '--share-url=$_safeShareUrl/?ref=trk-q-77',
        _safeProxyUrlArg,
      ]);

      expect(result.exitCode, isNot(0));
      expect(
        result.message,
        isNot(contains('trk-q-77')),
        reason:
            'query values may carry tracking/personal identifiers and '
            'must never be printed',
      );
    });

    test('blocks a custom share URL carrying a fragment', () {
      final result = runGuard([
        '--env-file=$envPath',
        '--share-url=$_safeShareUrl/#trk-f-77',
        _safeProxyUrlArg,
      ]);

      expect(result.exitCode, isNot(0));
      expect(
        result.message,
        isNot(contains('trk-f-77')),
        reason:
            'fragment values may carry tracking/personal identifiers '
            'and must never be printed',
      );
    });

    test('blocks a non-HTTPS share URL', () {
      final result = runGuard([
        '--env-file=$envPath',
        '--share-url=http://get.example.com',
        _safeProxyUrlArg,
      ]);

      expect(result.exitCode, isNot(0));
    });

    test('blocks a share URL with userinfo', () {
      final result = runGuard([
        '--env-file=$envPath',
        '--share-url=https://trk-u-77@get.example.com',
        _safeProxyUrlArg,
      ]);

      expect(result.exitCode, isNot(0));
      expect(
        result.message,
        isNot(contains('trk-u-77')),
        reason:
            'userinfo may carry tracking/personal identifiers and '
            'must never be printed',
      );
    });

    test(
      'legacy --allow-default-share-url + --share-url-purpose=owner-confirmed '
      'flags are accepted as no-ops and the message notes they are no longer '
      'required',
      () {
        final result = runGuard([
          '--env-file=$envPath',
          '--allow-default-share-url',
          '--share-url-purpose=owner-confirmed',
          _safeProxyUrlArg,
          _safeGeocodingArg,
        ]);

        expect(result.exitCode, 0);
        expect(result.message, contains('no longer required'));
      },
    );

    test('legacy --allow-default-share-url alone is a no-op', () {
      final result = runGuard([
        '--env-file=$envPath',
        '--allow-default-share-url',
        _safeProxyUrlArg,
        _safeGeocodingArg,
      ]);

      expect(result.exitCode, 0);
    });

    test('legacy --share-url-purpose alone is a no-op', () {
      final result = runGuard([
        '--env-file=$envPath',
        '--share-url-purpose=owner-confirmed',
        _safeProxyUrlArg,
        _safeGeocodingArg,
      ]);

      expect(result.exitCode, 0);
    });
  });

  group('proxy URL gate', () {
    late String envPath;

    setUp(() async {
      // Key-free env so only the proxy-url gate decides the outcome.
      envPath = await writeEnv('OTHER_SETTING=1\n');
    });

    test(
      'passes when --proxy-base-url is omitted, using the public default',
      () {
        final result = runGuard([
          '--env-file=$envPath',
          _safeShareUrlArg,
          _safeGeocodingArg,
        ]);

        expect(result.exitCode, 0);
        expect(result.message, contains(_defaultProxyUrl));
      },
    );

    test('passes when the public default is passed explicitly', () {
      final result = runGuard([
        '--env-file=$envPath',
        _safeShareUrlArg,
        '--proxy-base-url=$_defaultProxyUrl',
        _safeGeocodingArg,
      ]);

      expect(result.exitCode, 0);
      expect(result.message, contains(_defaultProxyUrl));
    });

    test('passes with a real owner-controlled bare HTTPS proxy URL', () {
      final result = runGuard([
        '--env-file=$envPath',
        _safeShareUrlArg,
        '--proxy-base-url=$_safeProxyUrl',
        _safeGeocodingArg,
      ]);

      expect(result.exitCode, 0);
    });

    test('blocks a proxy URL carrying a query string and redacts it', () {
      final result = runGuard([
        '--env-file=$envPath',
        _safeShareUrlArg,
        '--proxy-base-url=$_safeProxyUrl/?token=trk-pq-77',
      ]);

      expect(result.exitCode, isNot(0));
      expect(
        result.message,
        isNot(contains('trk-pq-77')),
        reason:
            'query values may carry credentials/identifiers and must '
            'never be printed',
      );
      expect(result.message, contains('redacted'));
    });

    test('blocks a proxy URL with userinfo and redacts it', () {
      final result = runGuard([
        '--env-file=$envPath',
        _safeShareUrlArg,
        '--proxy-base-url=https://trk-pu-77@proxy.example.com',
      ]);

      expect(result.exitCode, isNot(0));
      expect(
        result.message,
        isNot(contains('trk-pu-77')),
        reason: 'userinfo may carry credentials and must never be printed',
      );
      expect(result.message, contains('redacted'));
    });

    test('blocks a proxy URL carrying a fragment', () {
      final result = runGuard([
        '--env-file=$envPath',
        _safeShareUrlArg,
        '--proxy-base-url=$_safeProxyUrl/#trk-pf-77',
      ]);

      expect(result.exitCode, isNot(0));
      expect(result.message, isNot(contains('trk-pf-77')));
    });

    test('blocks a non-HTTPS proxy URL', () {
      final result = runGuard([
        '--env-file=$envPath',
        _safeShareUrlArg,
        '--proxy-base-url=http://proxy.example.com',
      ]);

      expect(result.exitCode, isNot(0));
    });

    test('blocks a proxy URL carrying a path and redacts it', () {
      final result = runGuard([
        '--env-file=$envPath',
        _safeShareUrlArg,
        '--proxy-base-url=$_safeProxyUrl/v1',
      ]);

      expect(result.exitCode, isNot(0));
      expect(
        result.message,
        isNot(contains('/v1')),
        reason:
            'path segments may identify endpoints and must never be '
            'printed; RECTIFY_PROXY_PATH carries the endpoint path '
            'separately',
      );
      expect(result.message, contains('redacted'));
    });

    test('accepts a proxy URL with only a trailing slash', () {
      final result = runGuard([
        '--env-file=$envPath',
        _safeShareUrlArg,
        '--proxy-base-url=$_safeProxyUrl/',
        _safeGeocodingArg,
      ]);

      expect(result.exitCode, 0);
    });

    test(
      'accepts legacy default proxy acknowledgement but no longer requires it',
      () {
        final result = runGuard([
          '--env-file=$envPath',
          _safeShareUrlArg,
          '--allow-default-proxy-url',
          '--proxy-url-purpose=local-test-only',
          _safeGeocodingArg,
        ]);

        expect(result.exitCode, 0);
        expect(result.message, contains('no longer required'));
      },
    );

    test('legacy default proxy allow flag without a purpose still passes', () {
      final result = runGuard([
        '--env-file=$envPath',
        _safeShareUrlArg,
        '--allow-default-proxy-url',
        _safeGeocodingArg,
      ]);

      expect(result.exitCode, 0);
    });

    test('legacy default proxy wrong purpose still passes', () {
      final result = runGuard([
        '--env-file=$envPath',
        _safeShareUrlArg,
        '--allow-default-proxy-url',
        '--proxy-url-purpose=production',
        _safeGeocodingArg,
      ]);

      expect(result.exitCode, 0);
    });

    test('legacy default proxy purpose without allow flag still passes', () {
      final result = runGuard([
        '--env-file=$envPath',
        _safeShareUrlArg,
        '--proxy-url-purpose=local-test-only',
        _safeGeocodingArg,
      ]);

      expect(result.exitCode, 0);
    });
  });

  group('provider URL gate', () {
    late String envPath;

    setUp(() async {
      // Key-free env so only the provider-url gate decides the outcome.
      envPath = await writeEnv('OTHER_SETTING=1\n');
    });

    test('passes when --provider-base-url is omitted, using the canonical '
        'default', () {
      final result = runGuard([
        '--env-file=$envPath',
        _safeShareUrlArg,
        _safeProxyUrlArg,
        _safeGeocodingArg,
      ]);

      expect(result.exitCode, 0);
      expect(result.message, contains(_defaultProviderUrl));
    });

    test('passes with a custom bare HTTPS provider URL', () {
      final result = runGuard([
        '--env-file=$envPath',
        _safeShareUrlArg,
        _safeProxyUrlArg,
        '--provider-base-url=$_safeProviderUrl',
        _safeGeocodingArg,
      ]);

      expect(result.exitCode, 0);
    });

    test('blocks a provider URL carrying a query string and redacts it', () {
      final result = runGuard([
        '--env-file=$envPath',
        _safeShareUrlArg,
        _safeProxyUrlArg,
        '--provider-base-url=$_safeProviderUrl/?token=trk-vq-77',
      ]);

      expect(result.exitCode, isNot(0));
      expect(
        result.message,
        isNot(contains('trk-vq-77')),
        reason:
            'query values may carry credentials/identifiers and must '
            'never be printed',
      );
      expect(result.message, contains('redacted'));
    });

    test('blocks a provider URL with userinfo and redacts it', () {
      final result = runGuard([
        '--env-file=$envPath',
        _safeShareUrlArg,
        _safeProxyUrlArg,
        '--provider-base-url=https://trk-vu-77@provider.example.com',
      ]);

      expect(result.exitCode, isNot(0));
      expect(
        result.message,
        isNot(contains('trk-vu-77')),
        reason: 'userinfo may carry credentials and must never be printed',
      );
      expect(result.message, contains('redacted'));
    });

    test('blocks a provider URL carrying a path and redacts it', () {
      final result = runGuard([
        '--env-file=$envPath',
        _safeShareUrlArg,
        _safeProxyUrlArg,
        '--provider-base-url=$_safeProviderUrl/v3',
      ]);

      expect(result.exitCode, isNot(0));
      expect(
        result.message,
        isNot(contains('/v3')),
        reason:
            'path segments must never be printed; RECTIFY_PROVIDER_PATH '
            'carries the endpoint path separately',
      );
      expect(result.message, contains('redacted'));
    });
  });

  group('geocoding gate', () {
    late String envPath;

    setUp(() async {
      // Key-free env so only the geocoding gate decides the outcome.
      envPath = await writeEnv('OTHER_SETTING=1\n');
    });

    test(
      'passes when neither geocoding base URL nor public key is supplied',
      () {
        final result = runGuard([
          '--env-file=$envPath',
          _safeShareUrlArg,
          _safeProxyUrlArg,
        ]);

        expect(result.exitCode, 0);
        expect(
          result.message,
          contains('native platform geocoding'),
          reason:
              'missing explicit geocoding config must use native geocoding, '
              'not silently rely only on the offline stub',
        );
        expect(
          result.message,
          contains('RECTIFY_GEOCODING'),
          reason: 'message must still name the optional explicit config keys',
        );
      },
    );

    test('passes when a safe geocoding proxy base URL is supplied', () {
      final result = runGuard([
        '--env-file=$envPath',
        _safeShareUrlArg,
        _safeProxyUrlArg,
        '--geocoding-base-url=$_safeGeocodingBaseUrl',
      ]);

      expect(result.exitCode, 0);
      expect(
        result.message,
        contains('geocoding'),
        reason: 'passing message must confirm geocoding is configured',
      );
    });

    test('passes when a pk.* public key is supplied', () {
      final result = runGuard([
        '--env-file=$envPath',
        _safeShareUrlArg,
        _safeProxyUrlArg,
        '--geocoding-public-key=$_safeGeocodingPublicKey',
      ]);

      expect(result.exitCode, 0);
      expect(result.message, contains('redacted'));
      expect(
        result.message,
        isNot(contains(_safeGeocodingPublicKey)),
        reason: 'public key value must never be echoed',
      );
    });

    test('passes when both a base URL and a public key are supplied', () {
      final result = runGuard([
        '--env-file=$envPath',
        _safeShareUrlArg,
        _safeProxyUrlArg,
        '--geocoding-base-url=$_safeGeocodingBaseUrl',
        '--geocoding-public-key=$_safeGeocodingPublicKey',
      ]);

      expect(result.exitCode, 0);
    });

    test('blocks a sk.* private token and redacts its value', () {
      const skToken = 'sk.eyJ1IjoiZXhhbXBsZSJ9.secret';
      final result = runGuard([
        '--env-file=$envPath',
        _safeShareUrlArg,
        _safeProxyUrlArg,
        '--geocoding-public-key=$skToken',
      ]);

      expect(result.exitCode, isNot(0));
      expect(
        result.message,
        isNot(contains(skToken)),
        reason: 'private token value must never be printed',
      );
      expect(result.message, contains('redacted'));
      expect(
        result.message,
        contains('sk.'),
        reason:
            'message must describe the disqualifying prefix without '
            'printing the full value',
      );
    });

    test('blocks a geocoding base URL carrying a path and redacts it', () {
      final result = runGuard([
        '--env-file=$envPath',
        _safeShareUrlArg,
        _safeProxyUrlArg,
        '--geocoding-base-url=$_safeGeocodingBaseUrl/search',
      ]);

      expect(result.exitCode, isNot(0));
      expect(
        result.message,
        isNot(contains('/search')),
        reason: 'path segments must never be printed',
      );
      expect(result.message, contains('redacted'));
    });

    test('blocks a geocoding base URL with userinfo and redacts it', () {
      const urlWithUser = 'https://user@geo.example.com';
      final result = runGuard([
        '--env-file=$envPath',
        _safeShareUrlArg,
        _safeProxyUrlArg,
        '--geocoding-base-url=$urlWithUser',
      ]);

      expect(result.exitCode, isNot(0));
      expect(
        result.message,
        isNot(contains('user@')),
        reason: 'userinfo may carry credentials and must never be printed',
      );
      expect(result.message, contains('redacted'));
    });

    test('blocks a non-HTTPS geocoding base URL', () {
      final result = runGuard([
        '--env-file=$envPath',
        _safeShareUrlArg,
        _safeProxyUrlArg,
        '--geocoding-base-url=http://geo.example.com',
      ]);

      expect(result.exitCode, isNot(0));
    });

    test('accepts a geocoding base URL with only a trailing slash', () {
      final result = runGuard([
        '--env-file=$envPath',
        _safeShareUrlArg,
        _safeProxyUrlArg,
        '--geocoding-base-url=$_safeGeocodingBaseUrl/',
      ]);

      expect(result.exitCode, 0);
    });
  });

  test('rejects unknown arguments with usage help', () {
    final result = runGuard(['--bogus']);

    expect(result.exitCode, 2);
    expect(result.message, contains('Usage'));
  });
}
