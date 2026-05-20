import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rectify/app/app.dart';
import 'package:rectify/app/route_names.dart';
import 'package:rectify/app/router.dart';
import 'package:rectify/data/db/database.dart';
import 'package:rectify/data/models/time_format.dart';
import 'package:rectify/data/secure/secure_key_store.dart';
import 'package:rectify/features/settings/api_key_sheet.dart';
import 'package:rectify/features/settings/delete_all_data_sheet.dart';
import 'package:rectify/features/settings/privacy_policy_screen.dart';
import 'package:rectify/features/settings/settings_screen.dart';
import 'package:rectify/providers/core_providers.dart';
import 'package:rectify/providers/repo_providers.dart';
import 'package:rectify/providers/settings_controller.dart';
import 'package:rectify/widgets/buttons/_button_shell.dart';
import 'package:rectify/widgets/inputs/labeled_toggle.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/fixtures/sample_calculation.dart';
import '../../../helpers/fake_history_repository.dart';

Future<SharedPreferences> _prefs({
  Map<String, Object> extra = const <String, Object>{},
}) async {
  SharedPreferences.setMockInitialValues(<String, Object>{
    // Skip the onboarding gate so SettingsScreen renders directly.
    'settings.onboarding_done': true,
    ...extra,
  });
  return SharedPreferences.getInstance();
}

ProviderScope _wrap(
  SharedPreferences prefs, {
  InMemorySecureKeyStore? secure,
  FakeHistoryRepository? history,
}) {
  return ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      secureKeyStoreProvider.overrideWithValue(
        secure ?? InMemorySecureKeyStore(),
      ),
      historyRepositoryProvider.overrideWithValue(
        history ?? FakeHistoryRepository(),
      ),
      // The default `appDatabaseProvider` opens a real Drift file with
      // a platform-specific path that no `sqflite` plugin backs in
      // widget tests. Settings actions still go through the real
      // `DefaultSettingsRepository`, so we hand it an in-memory
      // executor instead.
      appDatabaseProvider.overrideWith((ref) {
        final db = AppDatabase.forTesting(NativeDatabase.memory());
        ref.onDispose(db.close);
        return db;
      }),
    ],
    child: const RectifyApp(),
  );
}

Future<ProviderContainer> _pumpOnSettings(
  WidgetTester tester,
  Widget app,
) async {
  // The Settings screen is a tall scrollable; widget tests default to
  // an 800×600 surface where the lower rows (Delete all / Privacy /
  // version) live below the fold and never enter the lazy ListView.
  // Stretch the surface so every row is built and findable without
  // scrolling, then restore on tear-down.
  await tester.binding.setSurfaceSize(const Size(420, 1400));
  addTearDown(() => tester.binding.setSurfaceSize(null));

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
  testWidgets('renders every row described in design-system §10.7', (
    tester,
  ) async {
    final prefs = await _prefs();
    await _pumpOnSettings(tester, _wrap(prefs));

    expect(find.byType(SettingsScreen), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('API Key (Pro / Developer)'), findsOneWidget);
    expect(find.text('Not set'), findsOneWidget);
    expect(find.text('Demo mode'), findsOneWidget);
    expect(find.text('12-hour  (7:14 AM)'), findsOneWidget);
    expect(find.text('24-hour  (07:14)'), findsOneWidget);
    expect(find.text('Delete all data'), findsOneWidget);
    expect(find.text('Privacy Policy'), findsOneWidget);
    expect(find.text('Rectify  v1.0.0'), findsOneWidget);
  });

  testWidgets('demo toggle updates settings + persists to prefs', (
    tester,
  ) async {
    final prefs = await _prefs();
    final container = await _pumpOnSettings(tester, _wrap(prefs));

    expect(
      container.read(settingsControllerProvider).demoModeDefault,
      isFalse,
    );

    await tester.tap(find.byType(LabeledToggle));
    await tester.pumpAndSettle();

    expect(
      container.read(settingsControllerProvider).demoModeDefault,
      isTrue,
    );
    expect(prefs.getBool('settings.demo_mode_default'), isTrue);
  });

  testWidgets('time-format radio persists and is consumed by formatters', (
    tester,
  ) async {
    final prefs = await _prefs();
    final history = FakeHistoryRepository();
    await history.save(sampleRequest(), sampleResult());

    final container = await _pumpOnSettings(
      tester,
      _wrap(prefs, history: history),
    );

    // Pick 24-hour from the radio.
    await tester.tap(find.text('24-hour  (07:14)'));
    await tester.pumpAndSettle();

    expect(
      container.read(settingsControllerProvider).timeFormat,
      TimeFormat.h24,
    );
    expect(
      prefs.getString('settings.time_format'),
      TimeFormat.h24.tag,
    );

    // The Home / History list reads the same setting and renders the
    // 24-hour string.
    container.read(routerProvider).go(RoutePaths.home);
    await tester.pumpAndSettle();
    expect(find.textContaining('07:14'), findsOneWidget);
    expect(find.textContaining('7:14 AM'), findsNothing);
  });

  testWidgets('saving an API key flips the row to "Set" without echo', (
    tester,
  ) async {
    final prefs = await _prefs();
    final secure = InMemorySecureKeyStore();
    final container = await _pumpOnSettings(
      tester,
      _wrap(prefs, secure: secure),
    );

    // Open the ApiKeySheet.
    await tester.tap(find.text('API Key (Pro / Developer)'));
    await tester.pumpAndSettle();
    expect(find.byType(ApiKeySheet), findsOneWidget);

    // Type a key value and save.
    const secret = 'sk-test-NOT-A-REAL-KEY-12345';
    await tester.enterText(find.byType(TextField), secret);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save key'));
    await tester.pumpAndSettle();

    // Sheet dismissed.
    expect(find.byType(ApiKeySheet), findsNothing);

    // Row now reports "Set" — and the secret is nowhere in the visible
    // tree, satisfying the "never displayed after save" hard rule.
    expect(find.text('Set'), findsOneWidget);
    expect(find.text(secret), findsNothing);

    // Backing stores: secure storage has it; prefs flag flipped; no
    // SharedPreferences key carries the raw value.
    expect(await secure.readProApiKey(), secret);
    expect(prefs.getBool('settings.pro_api_key_configured'), isTrue);
    final dump = jsonEncode(<String, Object?>{
      for (final key in prefs.getKeys()) key: prefs.get(key),
    });
    expect(dump.contains(secret), isFalse);

    // SettingsModel does not carry the key either.
    final settings = container.read(settingsControllerProvider);
    expect(settings.toString().contains(secret), isFalse);
  });

  testWidgets('removing an API key resets the flag and wipes secure', (
    tester,
  ) async {
    final prefs = await _prefs(
      extra: <String, Object>{'settings.pro_api_key_configured': true},
    );
    final secure = InMemorySecureKeyStore(seed: 'sk-already-set');
    await _pumpOnSettings(tester, _wrap(prefs, secure: secure));

    expect(find.text('Set'), findsOneWidget);

    await tester.tap(find.text('API Key (Pro / Developer)'));
    await tester.pumpAndSettle();
    expect(find.byType(ApiKeySheet), findsOneWidget);

    // Sheet opens with the field empty — never echoes the stored key.
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.controller?.text ?? '', isEmpty);

    await tester.tap(find.text('Remove key'));
    await tester.pumpAndSettle();

    expect(find.byType(ApiKeySheet), findsNothing);
    expect(find.text('Set'), findsNothing);
    expect(find.text('Not set'), findsOneWidget);
    expect(await secure.readProApiKey(), isNull);
    expect(prefs.getBool('settings.pro_api_key_configured'), isFalse);
  });

  testWidgets('Delete all data wipes stores and routes to onboarding', (
    tester,
  ) async {
    final prefs = await _prefs(
      extra: <String, Object>{
        'settings.demo_mode_default': true,
        'settings.pro_api_key_configured': true,
      },
    );
    final secure = InMemorySecureKeyStore(seed: 'sk-going-away');
    final history = FakeHistoryRepository();
    await history.save(sampleRequest(), sampleResult());

    final container = await _pumpOnSettings(
      tester,
      _wrap(prefs, secure: secure, history: history),
    );

    await tester.tap(find.text('Delete all data'));
    await tester.pumpAndSettle();

    expect(find.byType(DeleteAllDataSheet), findsOneWidget);
    expect(find.textContaining('1 calculation'), findsOneWidget);

    // Two "Delete" labels exist: the destructive CTA in the sheet and
    // the row in the underlying settings card. Tap the one inside the
    // sheet.
    final deleteButton = find
        .descendant(
          of: find.byType(DeleteAllDataSheet),
          matching: find.text('Delete'),
        )
        .first;
    await tester.tap(deleteButton);
    await tester.pumpAndSettle();

    // Settings model reset to initial — onboardingDone flips false,
    // proApiKeyConfigured false, demoModeDefault false.
    final settings = container.read(settingsControllerProvider);
    expect(settings.onboardingDone, isFalse);
    expect(settings.proApiKeyConfigured, isFalse);
    expect(settings.demoModeDefault, isFalse);

    // Secure storage and prefs wiped.
    expect(await secure.readProApiKey(), isNull);
    expect(prefs.getKeys(), isEmpty);

    // Router redirected to onboarding (the first slide copy renders).
    expect(
      find.textContaining('Your birth chart depends on'),
      findsOneWidget,
    );
  });

  testWidgets('Privacy row pushes the in-app privacy screen', (tester) async {
    final prefs = await _prefs();
    await _pumpOnSettings(tester, _wrap(prefs));

    await tester.tap(find.text('Privacy Policy'));
    await tester.pumpAndSettle();

    expect(find.byType(PrivacyPolicyScreen), findsOneWidget);
    expect(find.text('What Rectify stores'), findsOneWidget);
    expect(find.text('Optional API key'), findsOneWidget);
    expect(find.text('Deleting your data'), findsOneWidget);
  });

  testWidgets(
    'destructive CTA in delete sheet uses the destructive button variant',
    (tester) async {
      final prefs = await _prefs();
      await _pumpOnSettings(tester, _wrap(prefs));

      // Settings card hosts a DestructiveButton too — opening the sheet
      // adds a second one.
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is RectifyButtonShell &&
              w.variant == RectifyButtonVariant.destructive,
        ),
        findsOneWidget,
      );

      await tester.tap(find.text('Delete all data'));
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
          (w) =>
              w is RectifyButtonShell &&
              w.variant == RectifyButtonVariant.destructive,
        ),
        findsNWidgets(2),
      );
    },
  );
}
