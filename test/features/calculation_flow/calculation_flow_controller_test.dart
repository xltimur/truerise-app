// Tests deliberately interleave controller calls with state assertions
// so the cascade lint doesn't help readability here.
// ignore_for_file: cascade_invocations
import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rectify/data/models/event_category.dart';
import 'package:rectify/data/models/time_window_mode.dart';
import 'package:rectify/data/repos/draft_repository.dart';
import 'package:rectify/data/repos/rectification_repository.dart';
import 'package:rectify/features/calculation_flow/state/calculation_flow_controller.dart';
import 'package:rectify/features/calculation_flow/state/calculation_flow_state.dart';
import 'package:rectify/providers/core_providers.dart';
import 'package:rectify/providers/repo_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/fake_history_repository.dart';
import '../../helpers/fake_rectification_repository.dart';

ProviderContainer _container({
  required SharedPreferences prefs,
  required RectificationRepository rectifier,
  required DraftRepository drafts,
}) {
  return ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      rectificationRepositoryProvider.overrideWithValue(rectifier),
      draftRepositoryProvider.overrideWithValue(drafts),
    ],
  );
}

void _populateValidBirth(CalculationFlowController controller) {
  controller
    ..setBirthDate(DateTime.utc(1990, 5, 14))
    ..setBirthCityText('Kyiv, Ukraine');
}

void _populateThreeEvents(CalculationFlowController controller) {
  controller
    ..addEvent(category: EventCategory.marriage, year: 2018, month: 6)
    ..addEvent(category: EventCategory.careerChange, year: 2015, month: 9)
    ..addEvent(category: EventCategory.relocation, year: 2012);
}

void main() {
  late SharedPreferences prefs;
  late FakeHistoryRepository history;
  late FakeRectificationRepository rectifier;
  late InMemoryDraftRepository drafts;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'settings.demo_mode_default': true,
    });
    prefs = await SharedPreferences.getInstance();
    history = FakeHistoryRepository();
    rectifier = FakeRectificationRepository(history: history);
    drafts = InMemoryDraftRepository();
  });

  tearDown(() async {
    await drafts.dispose();
  });

  test('initial state lands on the birth step with empty draft', () {
    final container = _container(
      prefs: prefs,
      rectifier: rectifier,
      drafts: drafts,
    );
    addTearDown(container.dispose);

    final state = container.read(calculationFlowControllerProvider);
    expect(state.step, CalculationFlowStep.birth);
    expect(state.birthDate, isNull);
    expect(state.birthCity, '');
    expect(state.birthStepValid, isFalse);
    expect(state.eventsStepValid, isFalse);
    expect(state.readyToSubmit, isFalse);
    expect(
      state.isDemo,
      isTrue,
      reason: 'demoModeDefault=true should seed the draft as a demo run',
    );
  });

  group('Birth step validation', () {
    test('requires both a date and a non-empty city to be valid', () {
      final container = _container(
        prefs: prefs,
        rectifier: rectifier,
        drafts: drafts,
      );
      addTearDown(container.dispose);
      final controller = container.read(
        calculationFlowControllerProvider.notifier,
      );

      controller.setBirthDate(DateTime.utc(1990, 5, 14));
      expect(
        container.read(calculationFlowControllerProvider).birthStepValid,
        isFalse,
        reason: 'date alone is not enough',
      );

      controller.setBirthCityText('  ');
      expect(
        container.read(calculationFlowControllerProvider).birthStepValid,
        isFalse,
        reason: 'whitespace-only city does not count',
      );

      controller.setBirthCityText('Kyiv, Ukraine');
      expect(
        container.read(calculationFlowControllerProvider).birthStepValid,
        isTrue,
      );
    });
  });

  group('Window step mode selection', () {
    test('switches between approximate and unknown modes', () {
      final container = _container(
        prefs: prefs,
        rectifier: rectifier,
        drafts: drafts,
      );
      addTearDown(container.dispose);
      final controller = container.read(
        calculationFlowControllerProvider.notifier,
      );

      // default after construction
      expect(
        container.read(calculationFlowControllerProvider).timeWindowMode,
        TimeWindowMode.approximate,
      );

      controller.setWindowMode(TimeWindowMode.unknown);
      expect(
        container.read(calculationFlowControllerProvider).timeWindowMode,
        TimeWindowMode.unknown,
      );

      controller
        ..setWindowMode(TimeWindowMode.approximate)
        ..setApproximateTime(const TimeOfDay(hour: 6, minute: 0))
        ..setWindowMinutes(60);

      final state = container.read(calculationFlowControllerProvider);
      expect(state.windowMinutes, 60);
      expect(state.approximateTime, const TimeOfDay(hour: 6, minute: 0));
      // Window getter produces the expected start/end (5:00 / 7:00).
      expect(state.timeWindow.start, (5, 0));
      expect(state.timeWindow.end, (7, 0));
    });
  });

  group('Events step minimum', () {
    test('requires at least 3 events before continuing', () {
      final container = _container(
        prefs: prefs,
        rectifier: rectifier,
        drafts: drafts,
      );
      addTearDown(container.dispose);
      final controller = container.read(
        calculationFlowControllerProvider.notifier,
      );

      controller.addEvent(category: EventCategory.marriage, year: 2018);
      expect(
        container.read(calculationFlowControllerProvider).eventsStepValid,
        isFalse,
      );

      controller.addEvent(category: EventCategory.careerChange, year: 2015);
      expect(
        container.read(calculationFlowControllerProvider).eventsStepValid,
        isFalse,
      );

      controller.addEvent(category: EventCategory.relocation, year: 2012);
      expect(
        container.read(calculationFlowControllerProvider).eventsStepValid,
        isTrue,
      );
      // 3 ≤ count < 5 → soft warning band.
      expect(
        container
            .read(calculationFlowControllerProvider)
            .eventsBelowRecommended,
        isTrue,
      );
    });

    test('removeEvent shrinks the list and re-checks validity', () {
      final container = _container(
        prefs: prefs,
        rectifier: rectifier,
        drafts: drafts,
      );
      addTearDown(container.dispose);
      final controller = container.read(
        calculationFlowControllerProvider.notifier,
      );
      _populateThreeEvents(controller);

      final firstId = container
          .read(calculationFlowControllerProvider)
          .events
          .first
          .id;
      controller.removeEvent(firstId);

      final state = container.read(calculationFlowControllerProvider);
      expect(state.events, hasLength(2));
      expect(state.eventsStepValid, isFalse);
    });
  });

  group('Navigation', () {
    test('next() advances only when the current step is valid', () {
      final container = _container(
        prefs: prefs,
        rectifier: rectifier,
        drafts: drafts,
      );
      addTearDown(container.dispose);
      final controller = container.read(
        calculationFlowControllerProvider.notifier,
      );

      controller.next();
      expect(
        container.read(calculationFlowControllerProvider).step,
        CalculationFlowStep.birth,
        reason: 'step should not advance without a valid birth draft',
      );

      _populateValidBirth(controller);
      controller.next();
      expect(
        container.read(calculationFlowControllerProvider).step,
        CalculationFlowStep.window,
      );

      controller.next();
      expect(
        container.read(calculationFlowControllerProvider).step,
        CalculationFlowStep.events,
      );

      controller.next();
      expect(
        container.read(calculationFlowControllerProvider).step,
        CalculationFlowStep.events,
        reason: 'no events yet; step stays put',
      );

      _populateThreeEvents(controller);
      controller.next();
      expect(
        container.read(calculationFlowControllerProvider).step,
        CalculationFlowStep.confirm,
      );
    });

    test('back() walks the steps backwards', () {
      final container = _container(
        prefs: prefs,
        rectifier: rectifier,
        drafts: drafts,
      );
      addTearDown(container.dispose);
      final controller = container.read(
        calculationFlowControllerProvider.notifier,
      );
      _populateValidBirth(controller);
      _populateThreeEvents(controller);
      controller
        ..goTo(CalculationFlowStep.confirm)
        ..back();
      expect(
        container.read(calculationFlowControllerProvider).step,
        CalculationFlowStep.events,
      );
      controller.back();
      expect(
        container.read(calculationFlowControllerProvider).step,
        CalculationFlowStep.window,
      );
      controller.back();
      expect(
        container.read(calculationFlowControllerProvider).step,
        CalculationFlowStep.birth,
      );
      // Birth has no predecessor.
      controller.back();
      expect(
        container.read(calculationFlowControllerProvider).step,
        CalculationFlowStep.birth,
      );
    });
  });

  group('Demo submit', () {
    test(
      'submits through the rectification repository, persists to '
      'history, and clears the draft',
      () async {
        final container = _container(
          prefs: prefs,
          rectifier: rectifier,
          drafts: drafts,
        );
        addTearDown(container.dispose);
        final controller = container.read(
          calculationFlowControllerProvider.notifier,
        );
        _populateValidBirth(controller);
        _populateThreeEvents(controller);

        final initial = container.read(calculationFlowControllerProvider);
        expect(initial.readyToSubmit, isTrue);

        final result = await controller.submit();
        expect(result.isOk, isTrue);
        expect(
          rectifier.submissions,
          hasLength(1),
          reason: 'submit() reaches the rectification repository',
        );
        expect(rectifier.submissions.single.isDemo, isTrue);
        expect(rectifier.submissions.single.events, hasLength(3));

        // The demo path writes the result to history.
        await Future<void>.delayed(Duration.zero);
        expect(history.deleteAll, isNotNull);
        final saved = await history.findById(
          rectifier.submissions.single.id,
        );
        expect(saved.isOk, isTrue);

        // Draft is cleared after a successful submit, controller resets.
        expect(drafts.read(), isNull);
      },
    );

    test('refuses to submit when the draft is incomplete', () async {
      final container = _container(
        prefs: prefs,
        rectifier: rectifier,
        drafts: drafts,
      );
      addTearDown(container.dispose);
      final controller = container.read(
        calculationFlowControllerProvider.notifier,
      );

      final result = await controller.submit();
      expect(result.isErr, isTrue);
      expect(rectifier.submissions, isEmpty);
    });
  });
}
