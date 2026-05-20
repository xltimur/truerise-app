// Widget tests interleave controller writes with widget assertions;
// cascading across the boundary obscures intent.
// ignore_for_file: cascade_invocations
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rectify/app/app.dart';
import 'package:rectify/app/route_names.dart';
import 'package:rectify/app/router.dart';
import 'package:rectify/data/models/event_category.dart';
import 'package:rectify/data/models/time_window_mode.dart';
import 'package:rectify/data/repos/draft_repository.dart';
import 'package:rectify/data/secure/secure_key_store.dart';
import 'package:rectify/features/calculation_flow/screens/confirmation_screen.dart';
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
    'summary card shows birth, window, and events at the confirm step',
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
      await tester.tap(find.text('New Calculation'));
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(MaterialApp)),
      );
      final controller = container.read(
        calculationFlowControllerProvider.notifier,
      );
      controller
        ..setBirthDate(DateTime.utc(1990, 5, 14))
        ..setBirthCityText('Kyiv, Ukraine')
        ..setLabel('My calculation')
        ..setApproximateTime(const TimeOfDay(hour: 7, minute: 0))
        ..setWindowMinutes(120)
        ..setWindowMode(TimeWindowMode.approximate)
        ..addEvent(category: EventCategory.marriage, year: 2018, month: 6)
        ..addEvent(category: EventCategory.careerChange, year: 2015, month: 9)
        ..addEvent(category: EventCategory.relocation, year: 2012);
      await tester.pumpAndSettle();

      // Confirmation is reachable directly because the draft is valid;
      // the stepper screens themselves are exercised in their own tests.
      container.read(routerProvider).go(RoutePaths.calcConfirm);
      await tester.pumpAndSettle();

      expect(find.byType(ConfirmationScreen), findsOneWidget);
      expect(find.text('Confirm your calculation'), findsOneWidget);
      // Birth row.
      expect(find.text('May 14, 1990'), findsOneWidget);
      expect(find.text('Kyiv, Ukraine'), findsOneWidget);
      expect(find.text('My calculation'), findsOneWidget);
      // Window summary line.
      expect(find.textContaining('7:00 AM'), findsOneWidget);
      expect(find.textContaining('± 2 hours'), findsOneWidget);
      // Events count.
      expect(find.text('Life events (3)'), findsOneWidget);
      // Demo CTA.
      expect(find.text('Calculate (demo)'), findsOneWidget);
    },
  );
}
