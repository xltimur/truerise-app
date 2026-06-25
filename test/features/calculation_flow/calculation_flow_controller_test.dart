// Tests deliberately interleave controller calls with state assertions
// so the cascade lint doesn't help readability here.
// ignore_for_file: cascade_invocations
import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rectify/data/models/birth_data.dart';
import 'package:rectify/data/models/calculation_request.dart';
import 'package:rectify/data/models/event_category.dart';
import 'package:rectify/data/models/geo_place.dart';
import 'package:rectify/data/models/life_event.dart';
import 'package:rectify/data/models/time_window.dart';
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

const _kyiv = GeoPlace(
  displayName: 'Kyiv, Ukraine',
  country: 'Ukraine',
  latitude: 50.4501,
  longitude: 30.5234,
);

CalculationRequest _readyRequest({required bool isDemo}) => CalculationRequest(
  id: 'stale-draft-${isDemo ? 'demo' : 'real'}',
  isDemo: isDemo,
  birthData: BirthData(
    birthDate: DateTime.utc(1990, 5, 14),
    birthCity: 'Kyiv, Ukraine',
    birthLatitude: 50.4501,
    birthLongitude: 30.5234,
  ),
  timeWindow: TimeWindow.approximate(
    time: const TimeOfDay(hour: 7, minute: 30),
    windowMinutes: 120,
  ),
  events: const <LifeEvent>[
    LifeEvent(
      id: 'evt-1',
      category: EventCategory.marriage,
      year: 2018,
      sortOrder: 0,
    ),
    LifeEvent(
      id: 'evt-2',
      category: EventCategory.careerChange,
      year: 2015,
      sortOrder: 1,
    ),
    LifeEvent(
      id: 'evt-3',
      category: EventCategory.relocation,
      year: 2012,
      sortOrder: 2,
    ),
  ],
  createdAt: DateTime.utc(2026, 6, 23),
);

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

  group('Demo mode setting sync', () {
    test(
      'restores a stale real draft as demo when settings now say demo',
      () {
        drafts.write(_readyRequest(isDemo: false));
        final container = _container(
          prefs: prefs,
          rectifier: rectifier,
          drafts: drafts,
        );
        addTearDown(container.dispose);

        final state = container.read(calculationFlowControllerProvider);
        expect(state.isDemo, isTrue);
        expect(drafts.read()?.isDemo, isTrue);
      },
    );

    test(
      'restores a stale demo draft as real when settings now say real',
      () async {
        SharedPreferences.setMockInitialValues(<String, Object>{
          'settings.demo_mode_default': false,
        });
        final livePrefs = await SharedPreferences.getInstance();
        drafts.write(_readyRequest(isDemo: true));
        final container = _container(
          prefs: livePrefs,
          rectifier: rectifier,
          drafts: drafts,
        );
        addTearDown(container.dispose);

        final state = container.read(calculationFlowControllerProvider);
        expect(state.isDemo, isFalse);
        expect(drafts.read()?.isDemo, isFalse);
      },
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

  group('Age gate (18+)', () {
    final reference = DateTime(2026, 6, 2);

    test('latestAllowedBirthDate is minimumAgeYears before the reference', () {
      expect(
        CalculationFlowState.latestAllowedBirthDate(reference),
        DateTime(2008, 6, 2),
      );
    });

    test('isOldEnough treats the cutoff day as inclusive', () {
      // Exactly 18 on the reference day → allowed.
      expect(
        CalculationFlowState.isOldEnough(DateTime(2008, 6, 2), reference),
        isTrue,
      );
      // One day too young → blocked.
      expect(
        CalculationFlowState.isOldEnough(DateTime(2008, 6, 3), reference),
        isFalse,
      );
      // Comfortably adult / comfortably minor.
      expect(
        CalculationFlowState.isOldEnough(DateTime(1990, 6, 15), reference),
        isTrue,
      );
      expect(
        CalculationFlowState.isOldEnough(DateTime(2015, 6, 15), reference),
        isFalse,
      );
    });

    test('an under-age birth date never passes birthStepValid or next()', () {
      final container = _container(
        prefs: prefs,
        rectifier: rectifier,
        drafts: drafts,
      );
      addTearDown(container.dispose);
      final controller = container.read(
        calculationFlowControllerProvider.notifier,
      );

      // A child born ~5 years ago is unambiguously under 18 regardless of
      // the day this test runs, so the assertion is not date-flaky.
      final now = DateTime.now();
      controller
        ..setBirthDate(DateTime.utc(now.year - 5, 6, 15))
        ..setBirthCityText('Kyiv, Ukraine');

      expect(
        container.read(calculationFlowControllerProvider).birthStepValid,
        isFalse,
        reason: 'city is set but the date fails the 18+ gate',
      );

      // The flow refuses to advance off the birth step.
      controller.next();
      expect(
        container.read(calculationFlowControllerProvider).step,
        CalculationFlowStep.birth,
      );

      // Swapping in an adult date unblocks the step.
      controller.setBirthDate(DateTime.utc(now.year - 40, 6, 15));
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
        // Demo stays offline-friendly: a typed-only city (no geocoded
        // coords) still submits, with the documented 0,0 fallback.
        expect(rectifier.submissions.single.birthData.birthLatitude, 0);
        expect(rectifier.submissions.single.birthData.birthLongitude, 0);

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

  group('Live mode coordinates', () {
    late SharedPreferences livePrefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'settings.demo_mode_default': false,
      });
      livePrefs = await SharedPreferences.getInstance();
    });

    test(
      'live birth step is invalid and submit blocked without resolved '
      'coordinates',
      () async {
        final container = _container(
          prefs: livePrefs,
          rectifier: rectifier,
          drafts: drafts,
        );
        addTearDown(container.dispose);
        final controller = container.read(
          calculationFlowControllerProvider.notifier,
        );

        expect(
          container.read(calculationFlowControllerProvider).isDemo,
          isFalse,
          reason: 'demoModeDefault=false should seed a live draft',
        );

        // Typed city only — no geocoded place selected, so lat/lon stay
        // null and a live request must not be sendable.
        _populateValidBirth(controller);
        _populateThreeEvents(controller);

        final state = container.read(calculationFlowControllerProvider);
        expect(state.birthLatitude, isNull);
        expect(state.birthStepValid, isFalse);
        expect(state.readyToSubmit, isFalse);

        controller.next();
        expect(
          container.read(calculationFlowControllerProvider).step,
          CalculationFlowStep.birth,
          reason: 'live flow must not advance past birth without coords',
        );

        final result = await controller.submit();
        expect(result.isErr, isTrue);
        expect(
          rectifier.submissions,
          isEmpty,
          reason: 'a live request must never go out with 0,0 fallback coords',
        );
      },
    );

    test('selecting a geocoded place unblocks the live flow and submits '
        'the resolved coordinates', () async {
      final container = _container(
        prefs: livePrefs,
        rectifier: rectifier,
        drafts: drafts,
      );
      addTearDown(container.dispose);
      final controller = container.read(
        calculationFlowControllerProvider.notifier,
      );

      controller.setBirthDate(DateTime.utc(1990, 5, 14));
      controller.selectGeoPlace(_kyiv);
      _populateThreeEvents(controller);

      final state = container.read(calculationFlowControllerProvider);
      expect(state.birthStepValid, isTrue);
      expect(state.readyToSubmit, isTrue);

      final result = await controller.submit();
      expect(result.isOk, isTrue);
      expect(rectifier.submissions, hasLength(1));
      expect(rectifier.submissions.single.isDemo, isFalse);
      expect(
        rectifier.submissions.single.birthData.birthLatitude,
        _kyiv.latitude,
      );
      expect(
        rectifier.submissions.single.birthData.birthLongitude,
        _kyiv.longitude,
      );
    });

    test(
      'live submission produces a result with isDemo=false',
      () async {
        final container = _container(
          prefs: livePrefs,
          rectifier: rectifier,
          drafts: drafts,
        );
        addTearDown(container.dispose);
        final controller = container.read(
          calculationFlowControllerProvider.notifier,
        );

        controller.setBirthDate(DateTime.utc(1990, 5, 14));
        controller.selectGeoPlace(_kyiv);
        _populateThreeEvents(controller);

        final result = await controller.submit();
        expect(result.isOk, isTrue);
        expect(rectifier.submissions.single.isDemo, isFalse);

        final saved = await history.findById(
          rectifier.submissions.single.id,
        );
        expect(saved.isOk, isTrue);
        expect(
          saved.valueOrNull?.result.isDemo,
          isFalse,
          reason: 'a live result must never be persisted with isDemo=true',
        );
      },
    );

    test(
      'reset() after a demo run seeds the new draft from current '
      'settings, not from the old isDemo flag',
      () async {
        final container = _container(
          prefs: livePrefs,
          rectifier: rectifier,
          drafts: drafts,
        );
        addTearDown(container.dispose);
        final controller = container.read(
          calculationFlowControllerProvider.notifier,
        );

        // Manually flip the draft to demo (simulates a user who
        // had demo on and then turned it off in Settings).
        expect(
          container.read(calculationFlowControllerProvider).isDemo,
          isFalse,
        );
        controller.setIsDemo(value: true);
        expect(
          container.read(calculationFlowControllerProvider).isDemo,
          isTrue,
        );

        // reset() must re-read demoModeDefault (false in livePrefs),
        // not preserve the old state.isDemo = true.
        controller.reset();
        expect(
          container.read(calculationFlowControllerProvider).isDemo,
          isFalse,
          reason:
              'reset() should seed isDemo from settings, not from '
              'the previous draft',
        );
      },
    );

    test('typing after selecting a place clears coords and re-blocks the '
        'live flow', () {
      final container = _container(
        prefs: livePrefs,
        rectifier: rectifier,
        drafts: drafts,
      );
      addTearDown(container.dispose);
      final controller = container.read(
        calculationFlowControllerProvider.notifier,
      );

      controller.setBirthDate(DateTime.utc(1990, 5, 14));
      controller.selectGeoPlace(_kyiv);
      expect(
        container.read(calculationFlowControllerProvider).birthStepValid,
        isTrue,
      );

      // Editing the city text invalidates the previously resolved place.
      controller.setBirthCityText('Kyi');
      final state = container.read(calculationFlowControllerProvider);
      expect(state.birthLatitude, isNull);
      expect(state.birthLongitude, isNull);
      expect(state.birthStepValid, isFalse);
    });

    test('demo draft with the same typed-only city stays valid', () {
      final container = _container(
        prefs: livePrefs,
        rectifier: rectifier,
        drafts: drafts,
      );
      addTearDown(container.dispose);
      final controller = container.read(
        calculationFlowControllerProvider.notifier,
      );

      controller.setIsDemo(value: true);
      _populateValidBirth(controller);

      expect(
        container.read(calculationFlowControllerProvider).birthStepValid,
        isTrue,
        reason: 'demo mode keeps the offline typed-city path',
      );
    });
  });
}
