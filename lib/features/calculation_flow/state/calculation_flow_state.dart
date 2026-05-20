// `[[type]]`-style doc references to neighbouring symbols (e.g.
// `[CalculationFlowController]`) live in another library; the analyzer
// would otherwise flag every cross-file dartdoc anchor.
// ignore_for_file: comment_references
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show TimeOfDay;

import 'package:rectify/data/models/birth_data.dart';
import 'package:rectify/data/models/calculation_request.dart';
import 'package:rectify/data/models/event_category.dart';
import 'package:rectify/data/models/geo_place.dart';
import 'package:rectify/data/models/life_event.dart';
import 'package:rectify/data/models/time_window.dart';
import 'package:rectify/data/models/time_window_mode.dart';

/// Linear position inside the calculation flow
/// (`docs/ascii-wireframes.md` Screens 2–4 + Confirmation).
///
/// `birth`, `window`, and `events` map to the three numbered steps
/// shown in the stepper header. `confirm` and `loading` sit after the
/// stepper bar but reuse the same flow controller so the draft state
/// survives back-navigation.
enum CalculationFlowStep {
  birth(1),
  window(2),
  events(3),
  confirm(4),
  loading(5);

  const CalculationFlowStep(this.indicatorPosition);

  /// 1-indexed position within the four-card flow. Used by the
  /// stepper header on steps 1–3 only.
  final int indicatorPosition;

  /// Total numbered steps shown in [StepperHeader]; confirm + loading
  /// share Step 3's bar at full width.
  static const int totalNumberedSteps = 3;
}

/// Allowed minute deltas for the approximate-mode window width
/// (`docs/mvp-scope.md` M3 + `docs/ascii-wireframes.md` Screen 3).
const kWindowMinuteOptions = <int>[30, 60, 120, 180, 360];

/// Immutable draft + UI state owned by `CalculationFlowController`.
///
/// Plain Dart rather than freezed: this object never crosses a layer
/// boundary (no serialization, no DB round-trip), so the build-runner
/// cost outweighs the type-safety win. `copyWith` keeps the call sites
/// short.
@immutable
class CalculationFlowState {
  const CalculationFlowState({
    required this.id,
    required this.createdAt,
    required this.step,
    required this.birthDate,
    required this.birthCity,
    required this.birthLatitude,
    required this.birthLongitude,
    required this.label,
    required this.timeWindowMode,
    required this.approximateTime,
    required this.windowMinutes,
    required this.events,
    required this.isDemo,
    required this.submitting,
    required this.submitError,
  });

  /// Build a fresh draft for [CalculationFlowController.build].
  ///
  /// `demoDefault` mirrors `SettingsModel.demoModeDefault` so the
  /// Phase 4 walk-through is identical for a demo user (the only mode
  /// the MVP can actually execute end-to-end without a network round
  /// trip).
  factory CalculationFlowState.initial({
    required String id,
    required DateTime createdAt,
    required bool isDemo,
  }) => CalculationFlowState(
    id: id,
    createdAt: createdAt,
    step: CalculationFlowStep.birth,
    birthDate: null,
    birthCity: '',
    birthLatitude: null,
    birthLongitude: null,
    label: '',
    timeWindowMode: TimeWindowMode.approximate,
    approximateTime: const TimeOfDay(hour: 12, minute: 0),
    windowMinutes: 120,
    events: const <LifeEvent>[],
    isDemo: isDemo,
    submitting: false,
    submitError: null,
  );

  /// Hydrate the draft from a persisted `CalculationRequest`.
  ///
  /// Used when the user backs into a flow that already had a draft
  /// resting in [DraftRepository].
  factory CalculationFlowState.fromRequest(CalculationRequest request) =>
      CalculationFlowState(
        id: request.id,
        createdAt: request.createdAt,
        step: CalculationFlowStep.birth,
        birthDate: request.birthData.birthDate,
        birthCity: request.birthData.birthCity,
        birthLatitude: request.birthData.birthLatitude,
        birthLongitude: request.birthData.birthLongitude,
        label: request.label ?? '',
        timeWindowMode: request.timeWindow.mode,
        approximateTime:
            request.timeWindow.approximateTime ??
            const TimeOfDay(hour: 12, minute: 0),
        windowMinutes: request.timeWindow.windowMinutes ?? 120,
        events: request.events,
        isDemo: request.isDemo,
        submitting: false,
        submitError: null,
      );

  /// Stable id assigned at flow start. Re-used by [DraftRepository] and
  /// by `RectificationRepository.submit` so a successful demo write
  /// lands in history under the same primary key the user sees while
  /// editing.
  final String id;
  final DateTime createdAt;
  final CalculationFlowStep step;

  /// Birth-date stored as a UTC midnight to avoid TZ drift when the
  /// caller round-trips via `Drift`.
  final DateTime? birthDate;
  final String birthCity;
  final double? birthLatitude;
  final double? birthLongitude;
  final String label;

  final TimeWindowMode timeWindowMode;
  final TimeOfDay approximateTime;
  final int windowMinutes;

  final List<LifeEvent> events;
  final bool isDemo;

  /// `true` while [CalculationFlowController.submit] is awaiting the
  /// (demo) repository call. The loading screen reads this to pick
  /// between the spinner and the post-failure copy.
  final bool submitting;
  final String? submitError;

  CalculationFlowState copyWith({
    String? id,
    DateTime? createdAt,
    CalculationFlowStep? step,
    Object? birthDate = _sentinel,
    String? birthCity,
    Object? birthLatitude = _sentinel,
    Object? birthLongitude = _sentinel,
    String? label,
    TimeWindowMode? timeWindowMode,
    TimeOfDay? approximateTime,
    int? windowMinutes,
    List<LifeEvent>? events,
    bool? isDemo,
    bool? submitting,
    Object? submitError = _sentinel,
  }) => CalculationFlowState(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    step: step ?? this.step,
    birthDate: birthDate == _sentinel ? this.birthDate : birthDate as DateTime?,
    birthCity: birthCity ?? this.birthCity,
    birthLatitude: birthLatitude == _sentinel
        ? this.birthLatitude
        : birthLatitude as double?,
    birthLongitude: birthLongitude == _sentinel
        ? this.birthLongitude
        : birthLongitude as double?,
    label: label ?? this.label,
    timeWindowMode: timeWindowMode ?? this.timeWindowMode,
    approximateTime: approximateTime ?? this.approximateTime,
    windowMinutes: windowMinutes ?? this.windowMinutes,
    events: events ?? this.events,
    isDemo: isDemo ?? this.isDemo,
    submitting: submitting ?? this.submitting,
    submitError: submitError == _sentinel
        ? this.submitError
        : submitError as String?,
  );

  /// Whether the Birth Data step has the inputs required to advance.
  /// City lat/lon may be null in MVP (geocoding is stubbed); the
  /// repository accepts demo coords so we only gate on the user-typed
  /// surface: a chosen date and a non-empty city string.
  bool get birthStepValid => birthDate != null && birthCity.trim().isNotEmpty;

  /// Whether the Time Window step is internally consistent. The radio
  /// always carries a mode and `approximateTime` defaults to noon at
  /// flow start, so the step is structurally valid by construction.
  /// Kept as a getter so future validation (e.g. forcing the user to
  /// confirm the picker) has a single hook.
  bool get windowStepValid => true;

  /// `true` when the user has supplied enough events to submit the
  /// demo flow (≥ 3 per `docs/mvp-scope.md` M4 / `docs/ascii-wireframes.md`
  /// Screen 4).
  bool get eventsStepValid => events.length >= 3;

  /// 3 ≤ count < 5 — the soft warning band on the events step
  /// (`docs/implementation-plan.md` §14 Phase 4 DoD).
  bool get eventsBelowRecommended => events.length >= 3 && events.length < 5;

  /// `true` when the draft can be sent to the repository — every step
  /// holds a valid value. Confirm and Loading screens rely on this.
  bool get readyToSubmit =>
      birthStepValid && windowStepValid && eventsStepValid;

  /// Build the resolved `TimeWindow` for the current state.
  TimeWindow get timeWindow => switch (timeWindowMode) {
    TimeWindowMode.unknown => TimeWindow.unknown(),
    TimeWindowMode.approximate => TimeWindow.approximate(
      time: approximateTime,
      windowMinutes: windowMinutes,
    ),
  };

  /// Build the resolved `CalculationRequest` snapshot. Throws if
  /// [readyToSubmit] is false; callers guard with the boolean first.
  CalculationRequest toRequest() {
    if (!readyToSubmit) {
      throw StateError(
        'CalculationFlowState.toRequest called before readyToSubmit.',
      );
    }
    return CalculationRequest(
      id: id,
      isDemo: isDemo,
      birthData: BirthData(
        birthDate: birthDate!,
        birthCity: birthCity.trim(),
        birthLatitude: birthLatitude ?? 0,
        birthLongitude: birthLongitude ?? 0,
        label: label.trim().isEmpty ? null : label.trim(),
      ),
      timeWindow: timeWindow,
      events: events,
      createdAt: createdAt,
      label: label.trim().isEmpty ? null : label.trim(),
    );
  }

  /// Replace the geocoded city / coords from a [GeoPlace] hit.
  CalculationFlowState withCity(GeoPlace place) => copyWith(
    birthCity: place.displayName,
    birthLatitude: place.latitude,
    birthLongitude: place.longitude,
  );

  /// Append [event] to the events list, sorted oldest-first by
  /// (year, month). [sortOrder] is rewritten so the list always stays
  /// dense from 0..n-1.
  List<LifeEvent> addEvent(LifeEvent event) {
    final next = <LifeEvent>[...events, event];
    return _normalizeEventOrder(next);
  }

  /// Replace the event matching [event.id]. No-op when [event.id]
  /// isn't already present (defensive).
  List<LifeEvent> replaceEvent(LifeEvent event) {
    final next = <LifeEvent>[];
    var matched = false;
    for (final existing in events) {
      if (existing.id == event.id) {
        next.add(event);
        matched = true;
      } else {
        next.add(existing);
      }
    }
    if (!matched) return events;
    return _normalizeEventOrder(next);
  }

  List<LifeEvent> removeEventById(String id) {
    final next = events.where((event) => event.id != id).toList();
    return _normalizeEventOrder(next);
  }

  static List<LifeEvent> _normalizeEventOrder(List<LifeEvent> events) {
    final sorted = <LifeEvent>[...events]
      ..sort((a, b) {
        final yearCmp = a.year.compareTo(b.year);
        if (yearCmp != 0) return yearCmp;
        final aMonth = a.month ?? 0;
        final bMonth = b.month ?? 0;
        return aMonth.compareTo(bMonth);
      });
    return <LifeEvent>[
      for (var i = 0; i < sorted.length; i++)
        LifeEvent(
          id: sorted[i].id,
          category: sorted[i].category,
          year: sorted[i].year,
          month: sorted[i].month,
          description: sorted[i].description,
          sortOrder: i,
        ),
    ];
  }
}

/// Human-readable mapping for [EventCategory]. Kept here so screens
/// and tests resolve the same strings without depending on intl-
/// localized bundles (Phase 4 ships English copy only).
String eventCategoryLabel(EventCategory category) => switch (category) {
  EventCategory.marriage => 'Marriage / Partnership',
  EventCategory.divorce => 'Divorce / Separation',
  EventCategory.careerChange => 'Career change',
  EventCategory.jobLoss => 'Job loss',
  EventCategory.relocation => 'Relocation (major)',
  EventCategory.childBirth => 'Birth of child',
  EventCategory.familyDeath => 'Death of family member',
  EventCategory.illness => 'Major illness / surgery',
  EventCategory.accident => 'Accident or injury',
  EventCategory.education => 'Education milestone',
  EventCategory.financial => 'Financial turning point',
  EventCategory.other => 'Other',
};

const Object _sentinel = Object();
