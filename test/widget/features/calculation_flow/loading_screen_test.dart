// Widget tests interleave controller writes with widget assertions;
// cascading across the boundary obscures intent.
// ignore_for_file: cascade_invocations
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rectify/app/app.dart';
import 'package:rectify/app/route_names.dart';
import 'package:rectify/app/router.dart';
import 'package:rectify/data/models/event_category.dart';
import 'package:rectify/data/repos/draft_repository.dart';
import 'package:rectify/data/secure/secure_key_store.dart';
import 'package:rectify/features/calculation_flow/state/calculation_flow_controller.dart';
import 'package:rectify/providers/core_providers.dart';
import 'package:rectify/providers/repo_providers.dart';
import 'package:rectify/widgets/feedback/breath_ring_loader.dart';
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
    'loading screen submits the demo draft, persists to history, and '
    'navigates to the /calc/result/:id route',
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

      final container = ProviderScope.containerOf(
        tester.element(find.byType(MaterialApp)),
      );
      final controller = container.read(
        calculationFlowControllerProvider.notifier,
      );
      controller
        ..setBirthDate(DateTime.utc(1990, 5, 14))
        ..setBirthCityText('Kyiv, Ukraine')
        ..addEvent(category: EventCategory.marriage, year: 2018)
        ..addEvent(category: EventCategory.careerChange, year: 2015)
        ..addEvent(category: EventCategory.relocation, year: 2012);

      final draftId = container.read(calculationFlowControllerProvider).id;

      container.read(routerProvider).go(RoutePaths.calcLoading);
      await tester.pumpAndSettle();

      // Demo submit went through the rectification repository, the
      // result landed in history, the draft was cleared, and Phase 5
      // now redirects to /calc/result/:id rather than parking the
      // user on a post-success message.
      expect(rectifier.submissions, hasLength(1));
      expect(rectifier.submissions.single.isDemo, isTrue);
      final saved = await history.findById(
        rectifier.submissions.single.id,
      );
      expect(saved.isOk, isTrue);
      expect(drafts.read(), isNull);

      final location = container
          .read(routerProvider)
          .routerDelegate
          .currentConfiguration
          .uri
          .toString();
      expect(location, '/calc/result/$draftId');
    },
  );

  testWidgets(
    'shows the BreathRingLoader while the calculation is in flight',
    (tester) async {
      final prefs = await _prefs();
      final history = FakeHistoryRepository();
      final rectifier = FakeRectificationRepository(history: history);
      // Hold submit() open so the loader stays mounted long enough to
      // assert against it.
      rectifier.blocker = Completer<void>();
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

      final container = ProviderScope.containerOf(
        tester.element(find.byType(MaterialApp)),
      );
      final controller = container.read(
        calculationFlowControllerProvider.notifier,
      );
      controller
        ..setBirthDate(DateTime.utc(1990, 5, 14))
        ..setBirthCityText('Kyiv, Ukraine')
        ..addEvent(category: EventCategory.marriage, year: 2018)
        ..addEvent(category: EventCategory.careerChange, year: 2015)
        ..addEvent(category: EventCategory.relocation, year: 2012);

      container.read(routerProvider).go(RoutePaths.calcLoading);
      await tester.pump();
      await tester.pump();
      expect(find.byType(BreathRingLoader), findsOneWidget);
      expect(find.text('Running demo calculation…'), findsOneWidget);
      // Release the submit and let the screen settle in the post-success
      // state so no pending timers leak into the test runner.
      rectifier.blocker!.complete();
      await tester.pumpAndSettle();
    },
  );
}
