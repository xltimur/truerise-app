// Dartdoc anchors reference `BreathRingLoader` from another library,
// which the analyzer can't resolve from doc context alone.
// ignore_for_file: comment_references
import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rectify/core/failures.dart';
import 'package:rectify/core/result.dart';
import 'package:rectify/data/models/calculation_result.dart';
import 'package:rectify/data/models/event_category.dart';
import 'package:rectify/data/models/geo_place.dart';
import 'package:rectify/data/models/life_event.dart';
import 'package:rectify/data/models/time_window_mode.dart';
import 'package:rectify/data/repos/draft_repository.dart';
import 'package:rectify/data/repos/rectification_repository.dart';
import 'package:rectify/features/calculation_flow/state/calculation_flow_state.dart';
import 'package:rectify/providers/repo_providers.dart';
import 'package:rectify/providers/settings_controller.dart';
import 'package:uuid/uuid.dart';

/// Holds the in-progress calculation draft for the Phase 4 flow.
///
/// Single owner of the draft: the controller mirrors edits into
/// [DraftRepository] so other surfaces (a future "Save and retry
/// later" path) can see the same snapshot the user is editing.
/// `submit()` short-circuits the demo branch via
/// [RectificationRepository] without an HTTP round trip.
class CalculationFlowController extends Notifier<CalculationFlowState> {
  CalculationFlowController({
    Uuid? uuid,
    DateTime Function()? now,
  }) : _uuid = uuid ?? const Uuid(),
       _now = now ?? DateTime.now;

  final Uuid _uuid;
  final DateTime Function() _now;

  DraftRepository get _drafts => ref.read(draftRepositoryProvider);
  RectificationRepository get _rectifier =>
      ref.read(rectificationRepositoryProvider);

  @override
  CalculationFlowState build() {
    final demoDefault = ref.read(
      settingsControllerProvider.select((s) => s.demoModeDefault),
    );

    final existing = _drafts.read();
    if (existing != null) {
      return CalculationFlowState.fromRequest(existing);
    }
    return CalculationFlowState.initial(
      id: _uuid.v4(),
      createdAt: _now(),
      isDemo: demoDefault,
    );
  }

  void _set(CalculationFlowState next, {bool syncDraft = true}) {
    state = next;
    if (syncDraft && next.readyToSubmit) {
      _drafts.write(next.toRequest());
    }
  }

  // ── Step navigation ────────────────────────────────────────────────

  void goTo(CalculationFlowStep step) => _set(state.copyWith(step: step));

  void next() {
    switch (state.step) {
      case CalculationFlowStep.birth:
        if (state.birthStepValid) goTo(CalculationFlowStep.window);
      case CalculationFlowStep.window:
        if (state.windowStepValid) goTo(CalculationFlowStep.events);
      case CalculationFlowStep.events:
        if (state.eventsStepValid) goTo(CalculationFlowStep.confirm);
      case CalculationFlowStep.confirm:
      case CalculationFlowStep.loading:
        // submit() is the forward action from confirm; loading exits
        // via router redirect once the result lands.
        break;
    }
  }

  void back() {
    switch (state.step) {
      case CalculationFlowStep.birth:
        break;
      case CalculationFlowStep.window:
        goTo(CalculationFlowStep.birth);
      case CalculationFlowStep.events:
        goTo(CalculationFlowStep.window);
      case CalculationFlowStep.confirm:
        goTo(CalculationFlowStep.events);
      case CalculationFlowStep.loading:
        goTo(CalculationFlowStep.confirm);
    }
  }

  // ── Birth step ────────────────────────────────────────────────────

  void setBirthDate(DateTime? date) => _set(state.copyWith(birthDate: date));

  void setBirthCityText(String text) => _set(
    state.copyWith(
      birthCity: text,
      birthLatitude: null,
      birthLongitude: null,
    ),
  );

  void selectGeoPlace(GeoPlace place) => _set(state.withCity(place));

  void clearGeoPlace() => _set(
    state.copyWith(
      birthCity: '',
      birthLatitude: null,
      birthLongitude: null,
    ),
  );

  void setLabel(String text) => _set(state.copyWith(label: text));

  void setIsDemo({required bool value}) => _set(state.copyWith(isDemo: value));

  // ── Window step ───────────────────────────────────────────────────

  void setWindowMode(TimeWindowMode mode) =>
      _set(state.copyWith(timeWindowMode: mode));

  void setApproximateTime(TimeOfDay time) =>
      _set(state.copyWith(approximateTime: time));

  void setWindowMinutes(int minutes) =>
      _set(state.copyWith(windowMinutes: minutes));

  // ── Events step ───────────────────────────────────────────────────

  /// Create a new event and append it to the draft. Returns the
  /// generated id so the calling sheet can highlight the new row.
  String addEvent({
    required EventCategory category,
    required int year,
    int? month,
    String? description,
  }) {
    final id = 'evt-${_uuid.v4()}';
    final event = LifeEvent(
      id: id,
      category: category,
      year: year,
      month: month,
      description: (description ?? '').trim().isEmpty
          ? null
          : description!.trim(),
      sortOrder: state.events.length,
    );
    _set(state.copyWith(events: state.addEvent(event)));
    return id;
  }

  void updateEvent({
    required String id,
    required EventCategory category,
    required int year,
    int? month,
    String? description,
  }) {
    final existing = state.events.cast<LifeEvent?>().firstWhere(
      (event) => event?.id == id,
      orElse: () => null,
    );
    if (existing == null) return;
    final updated = LifeEvent(
      id: id,
      category: category,
      year: year,
      month: month,
      description: (description ?? '').trim().isEmpty
          ? null
          : description!.trim(),
      sortOrder: existing.sortOrder,
    );
    _set(state.copyWith(events: state.replaceEvent(updated)));
  }

  void removeEvent(String id) =>
      _set(state.copyWith(events: state.removeEventById(id)));

  // ── Lifecycle ─────────────────────────────────────────────────────

  /// Drop the in-flight draft and reset to a fresh state. Used by the
  /// "x" affordance on the calc flow top-nav and by `submit()` after
  /// a successful demo write.
  void reset() {
    _drafts.clear();
    state = CalculationFlowState.initial(
      id: _uuid.v4(),
      createdAt: _now(),
      isDemo: state.isDemo,
    );
  }

  /// Submit the current draft through the rectification repository.
  ///
  /// Demo branch only in Phase 4: the live repository short-circuits
  /// when `request.isDemo == true` and writes a deterministic
  /// `CalculationResult` straight into history. The loading screen
  /// watches `state.submitting` to render the [BreathRingLoader]; once
  /// this future completes, the screen routes back to history (Phase
  /// 5 will replace the redirect with `/calc/result/:id`).
  Future<Result<CalculationResult, AppFailure>> submit() async {
    if (!state.readyToSubmit) {
      return const Result.err(
        BadRequestFailure('Calculation draft is incomplete.'),
      );
    }
    _set(
      state.copyWith(
        step: CalculationFlowStep.loading,
        submitting: true,
        submitError: null,
      ),
      syncDraft: false,
    );

    final request = state.toRequest();
    final result = await _rectifier.submit(request);

    return result.fold<Result<CalculationResult, AppFailure>>(
      ok: (value) {
        _drafts.clear();
        state = state.copyWith(submitting: false, submitError: null);
        return Result.ok(value);
      },
      err: (failure) {
        state = state.copyWith(
          submitting: false,
          submitError: failure.toString(),
        );
        return Result.err(failure);
      },
    );
  }
}

final calculationFlowControllerProvider =
    NotifierProvider<CalculationFlowController, CalculationFlowState>(
      CalculationFlowController.new,
    );
