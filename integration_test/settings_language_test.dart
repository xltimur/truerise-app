// Simulator-level smoke for manual interface-language selection +
// persistence (mvp-scope M11, design-system §10.7). It complements the
// flutter_test widget coverage in
// `test/widget/features/settings/settings_screen_test.dart` by proving
// the same flow under the `integration_test` binding, so
// `flutter test integration_test/settings_language_test.dart` is green on
// an iOS simulator.
//
// Everything runs against in-memory fakes — `SharedPreferences`
// mock values, an in-memory Drift executor, and an in-memory secure
// store — so the smoke is fully offline: no HTTP, no real API, and no
// reliance on platform plugins beyond what the mocks cover.

import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rectify/app/app.dart';
import 'package:rectify/app/route_names.dart';
import 'package:rectify/app/router.dart';
import 'package:rectify/data/db/database.dart';
import 'package:rectify/data/models/language_preference.dart';
import 'package:rectify/data/secure/secure_key_store.dart';
import 'package:rectify/providers/core_providers.dart';
import 'package:rectify/providers/settings_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Mock prefs that skip the onboarding gate so the router lands inside
/// the app and `SettingsScreen` is reachable without the carousel.
Future<SharedPreferences> _prefs() async {
  SharedPreferences.setMockInitialValues(<String, Object>{
    'settings.onboarding_done': true,
  });
  return SharedPreferences.getInstance();
}

/// Wraps [RectifyApp] in an offline ProviderScope. The default
/// `appDatabaseProvider` opens a real Drift file with a platform path no
/// plugin backs in this binding, and `DefaultSettingsRepository` (the
/// real writer the language radio drives) takes that database in its
/// constructor, so we hand it an in-memory executor. The secure store is
/// in-memory too. `sharedPreferencesProvider` is overridden with [prefs]
/// so the same store survives across a wrapper restart.
ProviderScope _wrap(SharedPreferences prefs) {
  return ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      secureKeyStoreProvider.overrideWithValue(InMemorySecureKeyStore()),
      appDatabaseProvider.overrideWith((ref) {
        final db = AppDatabase.forTesting(NativeDatabase.memory());
        ref.onDispose(db.close);
        return db;
      }),
    ],
    child: const RectifyApp(),
  );
}

/// Pumps [app], stretches the surface so the Language section's radio
/// rows are built without scrolling, navigates to Settings, and returns
/// the scope's container.
Future<ProviderContainer> _pumpOnSettings(
  WidgetTester tester,
  ProviderScope app,
) async {
  await tester.binding.setSurfaceSize(const Size(420, 1800));
  await tester.pumpWidget(app);
  await tester.pumpAndSettle();

  final container = ProviderScope.containerOf(
    tester.element(find.byType(RectifyApp)),
  );
  container.read(routerProvider).go(RoutePaths.settings);
  await tester.pumpAndSettle();
  return container;
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    // The Settings version footer reads platform package info.
    PackageInfo.setMockInitialValues(
      appName: 'rectify',
      packageName: 'app.truerise',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: '',
    );
  });

  testWidgets(
    'Settings language: English+Auto default → pick Deutsch persists de + '
    're-localizes → survives a wrapper restart, all offline',
    (tester) async {
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final prefs = await _prefs();

      // ── 1. First launch — Settings renders in English and Auto is the
      //       default. Nothing manual has been persisted yet.
      final container = await _pumpOnSettings(tester, _wrap(prefs));

      expect(find.text('Settings'), findsWidgets);
      expect(find.text('Automatic (device language)'), findsOneWidget);
      // German chrome is absent before any manual pick.
      expect(find.text('Automatisch (Gerätesprache)'), findsNothing);
      expect(find.text('Einstellungen'), findsNothing);

      expect(
        container.read(settingsControllerProvider).languagePreference,
        LanguagePreference.auto,
      );
      expect(prefs.getString('settings.language_preference'), isNull);

      // ── 2. Pick Deutsch. The endonym row label is constant across
      //       locales, so it is tappable regardless of the current UI
      //       language.
      await tester.ensureVisible(find.text('Deutsch'));
      await tester.tap(find.text('Deutsch'));
      await tester.pumpAndSettle();

      // Persisted to prefs and mirrored into controller state.
      expect(prefs.getString('settings.language_preference'), 'de');
      expect(
        container.read(settingsControllerProvider).languagePreference,
        LanguagePreference.german,
      );

      // MaterialApp.router re-localized live: the translated Auto label
      // and the app-bar title both switched to German; the English
      // strings are gone while the endonym row label stays constant.
      expect(find.text('Automatisch (Gerätesprache)'), findsOneWidget);
      expect(find.text('Automatic (device language)'), findsNothing);
      expect(find.text('Einstellungen'), findsWidgets);
      expect(find.text('Deutsch'), findsOneWidget);

      // ── 3. Restart the app wrapper over the SAME SharedPreferences and
      //       fresh fakes. The German preference must be preserved with
      //       no further user action.
      final restarted = await _pumpOnSettings(tester, _wrap(prefs));

      expect(prefs.getString('settings.language_preference'), 'de');
      expect(
        restarted.read(settingsControllerProvider).languagePreference,
        LanguagePreference.german,
      );
      // The restarted tree boots straight into German.
      expect(find.text('Automatisch (Gerätesprache)'), findsOneWidget);
      expect(find.text('Automatic (device language)'), findsNothing);
      expect(find.text('Einstellungen'), findsWidgets);
    },
  );
}
