import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rectify/app/app.dart';
import 'package:rectify/data/models/time_window_mode.dart';
import 'package:rectify/data/repos/draft_repository.dart';
import 'package:rectify/data/secure/secure_key_store.dart';
import 'package:rectify/features/calculation_flow/screens/time_window_screen.dart';
import 'package:rectify/features/calculation_flow/state/calculation_flow_controller.dart';
import 'package:rectify/providers/core_providers.dart';
import 'package:rectify/providers/repo_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/fake_history_repository.dart';
import '../../../helpers/fake_rectification_repository.dart';

Future<SharedPreferences> _prefs() async {
  SharedPreferences.setMockInitialValues(<String, Object>{
    'settings.onboarding_done': true,
    'settings.demo_mode_default': true,
  });
  return SharedPreferences.getInstance();
}

ProviderScope _harness({
  required SharedPreferences prefs,
  required FakeHistoryRepository history,
  required FakeRectificationRepository rectifier,
  required InMemoryDraftRepository drafts,
}) => ProviderScope(
  overrides: [
    sharedPreferencesProvider.overrideWithValue(prefs),
    secureKeyStoreProvider.overrideWithValue(InMemorySecureKeyStore()),
    historyRepositoryProvider.overrideWithValue(history),
    rectificationRepositoryProvider.overrideWithValue(rectifier),
    draftRepositoryProvider.overrideWithValue(drafts),
  ],
  child: const RectifyApp(),
);

void main() {
  testWidgets('renders both modes and the derived range copy', (tester) async {
    final prefs = await _prefs();
    final history = FakeHistoryRepository();
    final rectifier = FakeRectificationRepository(history: history);
    final drafts = InMemoryDraftRepository();
    addTearDown(drafts.dispose);

    await tester.pumpWidget(
      _harness(
        prefs: prefs,
        history: history,
        rectifier: rectifier,
        drafts: drafts,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('New Calculation'));
    await tester.pumpAndSettle();

    final container = ProviderScope.containerOf(
      tester.element(find.byType(MaterialApp)),
    );
    container.read(calculationFlowControllerProvider.notifier)
      ..setBirthDate(DateTime.utc(1990, 5, 14))
      ..setBirthCityText('Kyiv, Ukraine');
    await tester.pumpAndSettle();

    // Continue → window step.
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.byType(TimeWindowScreen), findsOneWidget);
    expect(find.text('STEP 2 OF 3'), findsOneWidget);
    expect(find.text('I have an approximate time'), findsOneWidget);
    expect(find.text('I have no idea'), findsOneWidget);

    // Approximate copy is visible by default.
    expect(find.textContaining("We'll search between"), findsOneWidget);

    // Switch to unknown — the range copy disappears.
    await tester.tap(find.text('I have no idea'));
    await tester.pumpAndSettle();
    expect(
      container.read(calculationFlowControllerProvider).timeWindowMode,
      TimeWindowMode.unknown,
    );
    expect(find.textContaining("We'll search between"), findsNothing);
    expect(find.textContaining('entire 24-hour range'), findsOneWidget);
  });
}
