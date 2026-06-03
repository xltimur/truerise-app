import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rectify/app/app.dart';
import 'package:rectify/app/route_names.dart';
import 'package:rectify/app/router.dart';
import 'package:rectify/data/db/database.dart';
import 'package:rectify/data/secure/secure_key_store.dart';
import 'package:rectify/features/onboarding/onboarding_screen.dart';
import 'package:rectify/features/settings/api_key_sheet.dart';
import 'package:rectify/features/settings/delete_all_data_sheet.dart';
import 'package:rectify/features/settings/settings_screen.dart';
import 'package:rectify/providers/core_providers.dart';
import 'package:rectify/providers/repo_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/fake_history_repository.dart';

/// Localized full-screen overflow QA (D.2).
///
/// The widget-level suite (`localized_overflow_test.dart`) renders the
/// risky leaf components in isolation. This file drives the real router
/// under German so the surfaces that only exist inside a screen get
/// exercised with their actual translated copy:
///
///   • Settings `_ChevronRow` (API-key label "API-Schlüssel
///     (Pro / Entwickler)" + "Nicht festgelegt" value + chevron in one
///     row) — private, only reachable through `SettingsScreen`.
///   • The API-key and delete-all bottom sheets.
///   • The 3 onboarding slides + their stacked CTAs.
///
/// German is forced via the platform locale so `MaterialApp` resolves it
/// exactly as it would on a German device. A clean `takeException()`
/// after each navigation proves no `RenderFlex` overflow fired.

Future<SharedPreferences> _prefs({
  Map<String, Object> extra = const <String, Object>{},
}) async {
  SharedPreferences.setMockInitialValues(<String, Object>{...extra});
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
      appDatabaseProvider.overrideWith((ref) {
        final db = AppDatabase.forTesting(NativeDatabase.memory());
        ref.onDispose(db.close);
        return db;
      }),
    ],
    child: const RectifyApp(),
  );
}

void main() {
  Future<ProviderContainer> pumpGerman(
    WidgetTester tester,
    Widget app, {
    Size surface = const Size(360, 1500),
  }) async {
    tester.platformDispatcher.localesTestValue = const <Locale>[Locale('de')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);

    // A tall surface so the scrollable Settings list builds every row
    // (lazy ListView skips off-screen rows on the default 800×600).
    await tester.binding.setSurfaceSize(surface);
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();
    return ProviderScope.containerOf(
      tester.element(find.byType(RectifyApp)),
    );
  }

  testWidgets('onboarding slides + CTAs fit under German', (tester) async {
    final prefs = await _prefs();
    await pumpGerman(tester, _wrap(prefs), surface: const Size(360, 760));

    // Empty prefs → onboarding gate is open.
    expect(find.byType(OnboardingScreen), findsOneWidget);
    expect(tester.takeException(), isNull);

    // Page through all three slides; the last carries the stacked CTAs.
    final pageView = find.byKey(const ValueKey<String>('onboarding-pageview'));
    for (var i = 0; i < 2; i++) {
      await tester.fling(pageView, const Offset(-300, 0), 1000);
      await tester.pumpAndSettle();
      expect(
        tester.takeException(),
        isNull,
        reason: 'Onboarding slide ${i + 2} overflowed under German.',
      );
    }
  });

  testWidgets('settings rows + cards fit under German', (tester) async {
    final prefs = await _prefs(
      extra: <String, Object>{'settings.onboarding_done': true},
    );
    final container = await pumpGerman(tester, _wrap(prefs));
    container.read(routerProvider).go(RoutePaths.settings);
    await tester.pumpAndSettle();

    expect(find.byType(SettingsScreen), findsOneWidget);
    // The long API-key row label is the tightest German row.
    expect(find.text('API-Schlüssel (Pro / Entwickler)'), findsOneWidget);
    expect(find.text('Nicht festgelegt'), findsOneWidget);
    expect(
      tester.takeException(),
      isNull,
      reason: 'SettingsScreen rows overflowed under German.',
    );
  });

  testWidgets('API-key + delete-all sheets fit under German', (tester) async {
    final prefs = await _prefs(
      extra: <String, Object>{'settings.onboarding_done': true},
    );
    final container = await pumpGerman(tester, _wrap(prefs));
    container.read(routerProvider).go(RoutePaths.settings);
    await tester.pumpAndSettle();

    // API-key sheet.
    await tester.tap(find.text('API-Schlüssel (Pro / Entwickler)'));
    await tester.pumpAndSettle();
    expect(find.byType(ApiKeySheet), findsOneWidget);
    expect(
      tester.takeException(),
      isNull,
      reason: 'ApiKeySheet overflowed under German.',
    );
    // Dismiss.
    await tester.tap(find.text('Abbrechen'));
    await tester.pumpAndSettle();

    // Delete-all sheet.
    await tester.tap(find.text('Alle Daten löschen'));
    await tester.pumpAndSettle();
    expect(find.byType(DeleteAllDataSheet), findsOneWidget);
    expect(
      tester.takeException(),
      isNull,
      reason: 'DeleteAllDataSheet overflowed under German.',
    );
  });
}
