import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rectify/core/update/update_info.dart';
import 'package:rectify/core/update/update_info_fetcher.dart';
import 'package:rectify/core/update/update_policy.dart';
import 'package:rectify/data/prefs/settings_store.dart';
import 'package:rectify/features/app_update/update_controller.dart';
import 'package:rectify/providers/core_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Pins the provider-level wiring of [appUpdateDecisionProvider] — the
/// guards that the pure `UpdatePolicy` tests cannot see:
///
///   * disabled-by-default: an empty or invalid
///     `TRUERISE_VERSION_CHECK_URL` resolves to none **without touching
///     the network** (the fetcher is never called);
///   * demo boundary: a Settings demo-mode-default-ON build performs no
///     update-check fetch at all;
///   * the happy path still flows through to a soft decision;
///   * a failed fetch (the real fetcher collapses every failure mode to
///     `null`) stays silent.
class _RecordingFetcher extends UpdateInfoFetcher {
  _RecordingFetcher({this.result});

  /// What [fetch] hands back; `null` models the fetcher's fail-silent
  /// contract (timeout / non-2xx / malformed body all collapse to null).
  final UpdateInfo? result;

  final List<String> requestedUrls = <String>[];

  @override
  Future<UpdateInfo?> fetch(String url) async {
    requestedUrls.add(url);
    return result;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const validCheckUrl = 'https://updates.example.com/version.json';
  const storeUrl = 'https://truerise.com.ua/get';

  /// A payload that advertises a newer version than the installed
  /// `1.0.0+1`, so any silent outcome below is attributable to the guard
  /// under test rather than to an up-to-date payload.
  UpdateInfo newerVersionInfo() => UpdateInfo.tryParse(<String, Object?>{
    'latestVersion': '2.0.0',
    'storeUrl': storeUrl,
  })!;

  Future<ProviderContainer> makeContainer({
    required _RecordingFetcher fetcher,
    String? versionCheckUrl,
    bool demoModeDefault = false,
  }) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final prefs = await SharedPreferences.getInstance();
    if (demoModeDefault) {
      await SettingsStore(prefs).setDemoModeDefault(value: true);
    }
    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        updateInfoFetcherProvider.overrideWithValue(fetcher),
        packageInfoProvider.overrideWith(
          (ref) => PackageInfo(
            appName: 'TrueRise',
            packageName: 'app.truerise',
            version: '1.0.0',
            buildNumber: '1',
          ),
        ),
        if (versionCheckUrl != null)
          versionCheckUrlProvider.overrideWithValue(versionCheckUrl),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('appUpdateDecisionProvider — disabled by default', () {
    test('the unconfigured (empty) URL resolves to none without '
        'calling the fetcher', () async {
      final fetcher = _RecordingFetcher(result: newerVersionInfo());
      // No versionCheckUrl override: the provider reads the compile-time
      // default, which is empty in the test binary.
      final container = await makeContainer(fetcher: fetcher);

      final decision = await container.read(appUpdateDecisionProvider.future);

      expect(decision.urgency, UpdateUrgency.none);
      expect(fetcher.requestedUrls, isEmpty);
    });

    test('an invalid configured URL resolves to none without '
        'calling the fetcher', () async {
      const invalidUrls = <String>[
        'http://updates.example.com/version.json',
        'https://updates.example.com/version.json?token=abc',
        'not a url',
      ];
      for (final url in invalidUrls) {
        final fetcher = _RecordingFetcher(result: newerVersionInfo());
        final container = await makeContainer(
          fetcher: fetcher,
          versionCheckUrl: url,
        );

        final decision = await container.read(
          appUpdateDecisionProvider.future,
        );

        expect(decision.urgency, UpdateUrgency.none, reason: url);
        expect(fetcher.requestedUrls, isEmpty, reason: url);
      }
    });
  });

  group('appUpdateDecisionProvider — demo boundary', () {
    test('Settings demo-mode default ON resolves to none without '
        'calling the fetcher', () async {
      final fetcher = _RecordingFetcher(result: newerVersionInfo());
      final container = await makeContainer(
        fetcher: fetcher,
        versionCheckUrl: validCheckUrl,
        demoModeDefault: true,
      );

      final decision = await container.read(appUpdateDecisionProvider.future);

      expect(decision.urgency, UpdateUrgency.none);
      expect(fetcher.requestedUrls, isEmpty);
    });
  });

  group('appUpdateDecisionProvider — configured path', () {
    test('a valid URL and a newer advertised version produce a soft '
        'decision carrying the store URL and prompt tag', () async {
      final fetcher = _RecordingFetcher(result: newerVersionInfo());
      final container = await makeContainer(
        fetcher: fetcher,
        versionCheckUrl: validCheckUrl,
      );

      final decision = await container.read(appUpdateDecisionProvider.future);

      expect(decision.urgency, UpdateUrgency.soft);
      expect(decision.storeUrl, storeUrl);
      expect(decision.promptTag, '2.0.0');
      expect(fetcher.requestedUrls, <String>[validCheckUrl]);
    });

    test('a failed fetch (null payload) stays silent', () async {
      final fetcher = _RecordingFetcher();
      final container = await makeContainer(
        fetcher: fetcher,
        versionCheckUrl: validCheckUrl,
      );

      final decision = await container.read(appUpdateDecisionProvider.future);

      expect(decision.urgency, UpdateUrgency.none);
      // The fetch was attempted — the silence comes from the fail-silent
      // contract, not from a skipped check.
      expect(fetcher.requestedUrls, <String>[validCheckUrl]);
    });
  });
}
