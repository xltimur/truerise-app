import 'dart:async';

import 'package:rectify/core/failures.dart';
import 'package:rectify/core/result.dart';
import 'package:rectify/data/demo/demo_response.dart';
import 'package:rectify/data/models/calculation_request.dart';
import 'package:rectify/data/models/calculation_result.dart';
import 'package:rectify/data/repos/history_repository.dart';
import 'package:rectify/data/repos/rectification_repository.dart';

/// Test double for [RectificationRepository] that completes
/// instantaneously (no demoDelay), wires the result through
/// [HistoryRepository.save], and records every submission so calc-flow
/// widget tests can assert what landed in the repository.
class FakeRectificationRepository implements RectificationRepository {
  FakeRectificationRepository({HistoryRepository? history})
    // Initializing-formal rewrite would expose `_history` as a public
    // named argument; we want to keep the parameter as plain `history`.
    // ignore: prefer_initializing_formals
    : _history = history;

  final HistoryRepository? _history;
  final List<CalculationRequest> submissions = <CalculationRequest>[];

  /// Set a non-null failure to make every `submit` return [Err]. Useful
  /// for the failure-path test on the loading screen.
  AppFailure? failureOverride;

  /// When set, every submission blocks on this completer before
  /// returning. Used by tests that want to assert the in-flight
  /// loading-screen rendering without racing the post-frame callback.
  Completer<void>? blocker;

  @override
  Future<Result<CalculationResult, AppFailure>> submit(
    CalculationRequest request,
  ) async {
    submissions.add(request);
    if (blocker != null) await blocker!.future;
    if (failureOverride != null) {
      return Result.err(failureOverride!);
    }
    final result = buildDemoResult(
      request,
      now: DateTime.utc(2026, 5, 20, 12),
    );
    await _history?.save(request, result);
    return Result.ok(result);
  }
}
