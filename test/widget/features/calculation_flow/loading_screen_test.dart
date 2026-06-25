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
import 'package:rectify/data/models/geo_place.dart';
import 'package:rectify/data/repos/draft_repository.dart';
import 'package:rectify/data/secure/secure_key_store.dart';
import 'package:rectify/features/calculation_flow/screens/loading_screen.dart';
import 'package:rectify/features/calculation_flow/state/calculation_flow_controller.dart';
import 'package:rectify/providers/core_providers.dart';
import 'package:rectify/providers/repo_providers.dart';
import 'package:rectify/widgets/chips/demo_pill.dart';
import 'package:rectify/widgets/feedback/breath_ring_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/fake_history_repository.dart';
import '../../../helpers/fake_rectification_repository.dart';

Future<SharedPreferences> _prefs({bool demo = true}) async {
  SharedPreferences.setMockInitialValues(<String, Object>{
    'settings.onboarding_done': true,
    'settings.demo_mode_default': demo,
  });
  return SharedPreferences.getInstance();
}

const _kyiv = GeoPlace(
  displayName: 'Kyiv, Ukraine',
  country: 'Ukraine',
  latitude: 50.4501,
  longitude: 30.5234,
);

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

  testWidgets(
    'Cancel returns to confirm; the late submit completion neither '
    'navigates away nor clears the draft nor saves history',
    (tester) async {
      final prefs = await _prefs();
      final history = FakeHistoryRepository();
      final rectifier = FakeRectificationRepository(history: history);
      // Hold submit() open so Cancel races a genuinely in-flight call.
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
      final draftId = container.read(calculationFlowControllerProvider).id;

      container.read(routerProvider).go(RoutePaths.calcLoading);
      await tester.pump();
      await tester.pump();
      expect(rectifier.submissions, hasLength(1));
      expect(rectifier.lastCancelToken, isNotNull);
      expect(rectifier.lastCancelToken!.isCancelled, isFalse);

      await tester.tap(find.byKey(loadingCancelButtonKey));
      await tester.pumpAndSettle();

      // Cancel must abort the in-flight HTTP request on the wire, not
      // only ignore its late completion.
      expect(rectifier.lastCancelToken!.isCancelled, isTrue);

      String location() => container
          .read(routerProvider)
          .routerDelegate
          .currentConfiguration
          .uri
          .toString();
      expect(location(), RoutePaths.calcConfirm);

      // The in-flight submit now completes "successfully" — after a
      // cancel this must be a no-op for the user.
      rectifier.blocker!.complete();
      await tester.pumpAndSettle();

      expect(
        location(),
        RoutePaths.calcConfirm,
        reason: 'late completion must not steal navigation',
      );
      final state = container.read(calculationFlowControllerProvider);
      expect(
        state.readyToSubmit,
        isTrue,
        reason: 'the editable draft must survive the cancelled submit',
      );
      expect(
        drafts.read(),
        isNotNull,
        reason: 'the persisted draft must not be silently cleared',
      );
      final saved = await history.findById(draftId);
      expect(
        saved.isErr,
        isTrue,
        reason: 'a cancelled submission must not save a history row',
      );

      // The draft is still editable after the dust settles.
      controller.setLabel('still editable');
      expect(
        container.read(calculationFlowControllerProvider).label,
        'still editable',
      );
    },
  );

  testWidgets(
    'live mode: no DemoPill and live title are shown when demo is off',
    (tester) async {
      final prefs = await _prefs(demo: false);
      final history = FakeHistoryRepository();
      final rectifier = FakeRectificationRepository(history: history);
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
        ..selectGeoPlace(_kyiv)
        ..addEvent(category: EventCategory.marriage, year: 2018)
        ..addEvent(category: EventCategory.careerChange, year: 2015)
        ..addEvent(category: EventCategory.relocation, year: 2012);

      expect(
        container.read(calculationFlowControllerProvider).isDemo,
        isFalse,
        reason: 'demo is off in settings, draft must be live',
      );

      container.read(routerProvider).go(RoutePaths.calcLoading);
      await tester.pump();
      await tester.pump();

      // Live mode must show the live title, never the demo title or pill.
      expect(find.byType(DemoPill), findsNothing);
      expect(
        find.text('Calculating your probable birth time…'),
        findsOneWidget,
      );
      expect(find.text('Running demo calculation…'), findsNothing);

      // Release and let the result land.
      rectifier.blocker!.complete();
      await tester.pumpAndSettle();

      // Result must not carry isDemo=true.
      final saved = await history.findById(
        rectifier.submissions.single.id,
      );
      expect(saved.isOk, isTrue);
      expect(
        saved.valueOrNull?.result.isDemo,
        isFalse,
        reason: 'live result persisted to history must have isDemo=false',
      );
    },
  );
}
