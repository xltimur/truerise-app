import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rectify/app/app.dart';
import 'package:rectify/data/secure/secure_key_store.dart';
import 'package:rectify/providers/core_providers.dart';
import 'package:rectify/providers/repo_providers.dart';
import 'package:rectify/providers/settings_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/fake_history_repository.dart';

Future<SharedPreferences> _prefs({
  bool onboardingDone = false,
  bool? demoModeDefault,
}) async {
  SharedPreferences.setMockInitialValues(<String, Object>{
    if (onboardingDone) 'settings.onboarding_done': true,
    'settings.demo_mode_default': ?demoModeDefault,
  });
  return SharedPreferences.getInstance();
}

ProviderScope _wrap(SharedPreferences prefs) => ProviderScope(
  overrides: [
    sharedPreferencesProvider.overrideWithValue(prefs),
    secureKeyStoreProvider.overrideWithValue(InMemorySecureKeyStore()),
    historyRepositoryProvider.overrideWithValue(FakeHistoryRepository()),
  ],
  child: const RectifyApp(),
);

void main() {
  testWidgets(
    'first launch with no onboarding flag redirects to onboarding',
    (tester) async {
      final prefs = await _prefs();

      await tester.pumpWidget(_wrap(prefs));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('Your birth chart depends on your exact'),
        findsOneWidget,
      );
      expect(find.text('Next'), findsOneWidget);
      expect(find.text('Skip'), findsOneWidget);
    },
  );

  testWidgets('advancing to the last slide swaps Next for the two CTAs', (
    tester,
  ) async {
    final prefs = await _prefs();

    await tester.pumpWidget(_wrap(prefs));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Try demo first'), findsOneWidget);
    expect(find.text('Start real calculation'), findsOneWidget);
    expect(find.text('Skip'), findsNothing);
    expect(find.text('Next'), findsNothing);
  });

  testWidgets(
    'finishing onboarding persists onboardingDone and lands on Home',
    (tester) async {
      final prefs = await _prefs();

      await tester.pumpWidget(_wrap(prefs));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Try demo first'));
      await tester.pumpAndSettle();

      // Settings model now reports the flag persisted.
      final container = ProviderScope.containerOf(
        tester.element(find.byType(RectifyApp)),
      );
      expect(
        container.read(settingsControllerProvider).onboardingDone,
        isTrue,
      );

      // Prefs got the write too — proves we went through the repository,
      // not just an in-memory toggle.
      final store = container.read(settingsStoreProvider);
      expect(store.readSync().onboardingDone, isTrue);

      // And the router took us off the onboarding screen.
      expect(find.text('TrueRise'), findsOneWidget);
      expect(
        find.textContaining('Your birth chart depends on'),
        findsNothing,
      );
    },
  );

  testWidgets('Skip on slide 1 also persists onboardingDone', (tester) async {
    final prefs = await _prefs();

    await tester.pumpWidget(_wrap(prefs));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    final container = ProviderScope.containerOf(
      tester.element(find.byType(RectifyApp)),
    );
    expect(
      container.read(settingsControllerProvider).onboardingDone,
      isTrue,
    );
    // Skip explicitly persists demoModeDefault = true — the safe demo
    // default while geocoding is stubbed.
    expect(
      container.read(settingsControllerProvider).demoModeDefault,
      isTrue,
    );
    expect(find.text('TrueRise'), findsOneWidget);
  });

  testWidgets('"Try demo first" persists demoModeDefault = true', (
    tester,
  ) async {
    final prefs = await _prefs(demoModeDefault: false);

    await tester.pumpWidget(_wrap(prefs));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Try demo first'));
    await tester.pumpAndSettle();

    final container = ProviderScope.containerOf(
      tester.element(find.byType(RectifyApp)),
    );
    expect(
      container.read(settingsControllerProvider).demoModeDefault,
      isTrue,
    );
    // Persisted, not just mirrored into the in-memory controller state.
    expect(prefs.getBool('settings.demo_mode_default'), isTrue);
    expect(find.text('TrueRise'), findsOneWidget);
  });

  testWidgets('"Start real calculation" persists demoModeDefault = false', (
    tester,
  ) async {
    // Seed demo=true so the assertion proves the CTA actively flipped it.
    final prefs = await _prefs(demoModeDefault: true);

    await tester.pumpWidget(_wrap(prefs));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start real calculation'));
    await tester.pumpAndSettle();

    final container = ProviderScope.containerOf(
      tester.element(find.byType(RectifyApp)),
    );
    expect(
      container.read(settingsControllerProvider).demoModeDefault,
      isFalse,
    );
    expect(prefs.getBool('settings.demo_mode_default'), isFalse);
    expect(find.text('TrueRise'), findsOneWidget);
  });

  testWidgets(
    'returning user with onboardingDone goes straight to Home',
    (tester) async {
      final prefs = await _prefs(onboardingDone: true);

      await tester.pumpWidget(_wrap(prefs));
      await tester.pumpAndSettle();

      expect(find.text('TrueRise'), findsOneWidget);
      expect(find.textContaining('Your birth chart depends on'), findsNothing);
    },
  );
}
