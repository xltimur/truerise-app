import 'dart:async';

import 'package:rectify/core/failures.dart';
import 'package:rectify/core/result.dart';
import 'package:rectify/data/models/calculation_request.dart';
import 'package:rectify/data/models/calculation_result.dart';
import 'package:rectify/data/models/saved_calculation.dart';
import 'package:rectify/data/repos/history_repository.dart';

/// In-memory [HistoryRepository] for widget tests.
///
/// Drift's [Stream] cancellation leaves a pending zero-duration cleanup
/// timer that trips `flutter_test`'s `!timersPending` invariant when
/// `ProviderScope` disposes mid-widget-tree. Using a plain
/// [StreamController]-backed fake sidesteps the Drift teardown without
/// changing the production code path. Each repository instance
/// dispatches its initial state synchronously on subscription.
class FakeHistoryRepository implements HistoryRepository {
  FakeHistoryRepository([List<SavedCalculation> seed = const []])
    : _rows = [...seed];

  final List<SavedCalculation> _rows;
  final List<StreamController<List<SavedCalculation>>> _listeners = [];

  void _emit() {
    final snapshot = List<SavedCalculation>.unmodifiable(_rows);
    for (final controller in _listeners) {
      if (!controller.isClosed) controller.add(snapshot);
    }
  }

  @override
  Future<Result<void, AppFailure>> save(
    CalculationRequest request,
    CalculationResult result,
  ) async {
    _rows
      ..removeWhere((row) => row.request.id == request.id)
      ..add(SavedCalculation(request: request, result: result));
    _emit();
    return const Result<void, AppFailure>.ok(null);
  }

  @override
  Future<Result<SavedCalculation, AppFailure>> findById(
    String calculationId,
  ) async {
    for (final row in _rows) {
      if (row.request.id == calculationId) return Result.ok(row);
    }
    return Result.err(StorageFailure(StateError('not found: $calculationId')));
  }

  @override
  Stream<List<SavedCalculation>> watchAll() {
    late final StreamController<List<SavedCalculation>> controller;
    controller = StreamController<List<SavedCalculation>>(
      onListen: () =>
          controller.add(List<SavedCalculation>.unmodifiable(_rows)),
      onCancel: () {
        _listeners.remove(controller);
      },
    );
    _listeners.add(controller);
    return controller.stream;
  }

  @override
  Future<Result<void, AppFailure>> deleteById(String calculationId) async {
    _rows.removeWhere((row) => row.request.id == calculationId);
    _emit();
    return const Result<void, AppFailure>.ok(null);
  }

  @override
  Future<Result<void, AppFailure>> deleteAll() async {
    _rows.clear();
    _emit();
    return const Result<void, AppFailure>.ok(null);
  }
}
