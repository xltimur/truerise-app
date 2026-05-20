// Widget tests interleave controller writes with widget assertions;
// cascading across the boundary obscures intent.
// ignore_for_file: cascade_invocations
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rectify/app/app.dart';
import 'package:rectify/data/repos/draft_repository.dart';
import 'package:rectify/data/secure/secure_key_store.dart';
import 'package:rectify/features/calculation_flow/screens/birth_data_screen.dart';
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
  testWidgets(
    'Continue is disabled until a date and city are entered',
    (tester) async {
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
      // Navigate from home into the calc flow.
      await tester.tap(find.text('New Calculation'));
      await tester.pumpAndSettle();

      expect(find.byType(BirthDataScreen), findsOneWidget);
      expect(find.text('STEP 1 OF 3'), findsOneWidget);
      expect(find.text('Birth details'), findsOneWidget);

      // Without a date and city the Continue CTA is disabled.
      final container = ProviderScope.containerOf(
        tester.element(find.byType(BirthDataScreen)),
      );
      expect(
        container.read(calculationFlowControllerProvider).birthStepValid,
        isFalse,
      );

      // Fill the city and the date through the controller (the date
      // picker shows a native sheet, which is hard to drive in a
      // widget test). The visible CTA enables once both are set.
      final controller = container.read(
        calculationFlowControllerProvider.notifier,
      );
      controller
        ..setBirthCityText('Kyiv, Ukraine')
        ..setBirthDate(DateTime.utc(1990, 5, 14));
      await tester.pumpAndSettle();

      expect(
        container.read(calculationFlowControllerProvider).birthStepValid,
        isTrue,
      );
      expect(find.text('March 15, 1990'), findsNothing);
      expect(find.text('Kyiv, Ukraine'), findsWidgets);
    },
  );

  testWidgets('does not overflow on a 360x760 viewport', (tester) async {
    tester.view.physicalSize = const Size(360, 760);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

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

    expect(find.byType(BirthDataScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
