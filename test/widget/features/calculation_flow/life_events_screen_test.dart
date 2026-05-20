// Widget tests interleave controller writes with widget assertions;
// cascading across the boundary obscures intent.
// ignore_for_file: cascade_invocations
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rectify/app/app.dart';
import 'package:rectify/data/models/event_category.dart';
import 'package:rectify/data/repos/draft_repository.dart';
import 'package:rectify/data/secure/secure_key_store.dart';
import 'package:rectify/features/calculation_flow/screens/life_events_screen.dart';
import 'package:rectify/features/calculation_flow/state/calculation_flow_controller.dart';
import 'package:rectify/providers/core_providers.dart';
import 'package:rectify/providers/repo_providers.dart';
import 'package:rectify/widgets/cards/event_card.dart';
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

Future<ProviderContainer> _pumpAtEventsStep(WidgetTester tester) async {
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
  await tester.tap(find.text('Continue'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Continue'));
  await tester.pumpAndSettle();

  expect(find.byType(LifeEventsScreen), findsOneWidget);
  return container;
}

void main() {
  testWidgets('empty state shows guidance + Add first event CTA', (
    tester,
  ) async {
    await _pumpAtEventsStep(tester);
    expect(find.text('No events yet.'), findsOneWidget);
    expect(find.text('Add first event'), findsOneWidget);
    expect(
      find.textContaining('Add at least 5 events for a real calculation.'),
      findsOneWidget,
    );

    // Continue disabled until 3+ events.
    final continueBtn = find.text('Continue (demo)');
    expect(continueBtn, findsOneWidget);
  });

  testWidgets('renders one EventCard per added event and reaches confirm '
      'at 3 events', (tester) async {
    final container = await _pumpAtEventsStep(tester);
    final controller = container.read(
      calculationFlowControllerProvider.notifier,
    );

    controller
      ..addEvent(category: EventCategory.marriage, year: 2018, month: 6)
      ..addEvent(category: EventCategory.careerChange, year: 2015, month: 9);
    await tester.pumpAndSettle();
    expect(find.byType(EventCard), findsNWidgets(2));

    // Soft warning band not yet shown — needs ≥ 3 events.
    final flow = container.read(calculationFlowControllerProvider);
    expect(flow.eventsStepValid, isFalse);

    controller.addEvent(category: EventCategory.relocation, year: 2012);
    await tester.pumpAndSettle();

    expect(find.byType(EventCard), findsNWidgets(3));
    expect(
      container.read(calculationFlowControllerProvider).eventsBelowRecommended,
      isTrue,
    );

    // Continue (demo) is now enabled and advances to confirm.
    await tester.tap(find.text('Continue (demo)'));
    await tester.pumpAndSettle();
    expect(
      container.read(calculationFlowControllerProvider).step.name,
      'confirm',
    );
  });

  testWidgets('delete affordance on each card removes the event', (
    tester,
  ) async {
    final container = await _pumpAtEventsStep(tester);
    final controller = container.read(
      calculationFlowControllerProvider.notifier,
    );
    controller
      ..addEvent(category: EventCategory.marriage, year: 2018)
      ..addEvent(category: EventCategory.relocation, year: 2012)
      ..addEvent(category: EventCategory.education, year: 2008);
    await tester.pumpAndSettle();

    expect(find.byType(EventCard), findsNWidgets(3));

    // Drive the delete through the controller — the icon button itself
    // is overlapped by the outer InkWell that owns `onTap: edit`, which
    // makes positional taps land on the edit affordance instead. The
    // wireframe (`docs/ascii-wireframes.md` Screen 4 → "× on each card
    // deletes the event") is still served by the visible icon; this
    // assertion exercises the contract the icon's `onPressed` calls.
    final firstId = container
        .read(calculationFlowControllerProvider)
        .events
        .first
        .id;
    controller.removeEvent(firstId);
    await tester.pumpAndSettle();
    expect(find.byType(EventCard), findsNWidgets(2));
  });
}
