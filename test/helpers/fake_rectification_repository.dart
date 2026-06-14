import 'dart:async';

import 'package:dio/dio.dart' show CancelToken;
import 'package:rectify/core/failures.dart';
import 'package:rectify/core/result.dart';
import 'package:rectify/data/demo/demo_response.dart';
import 'package:rectify/data/models/calculation_request.dart';
import 'package:rectify/data/models/calculation_result.dart';
import 'package:rectify/data/repos/history_repository.dart';
import 'package:rectify/data/repos/rectification_repository.dart';
import 'package:rectify/l10n/app_localizations_en.dart';

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

  /// Token the controller handed to the most recent submission, so
  /// tests can assert Cancel actually cancelled the live HTTP token
  /// rather than only ignoring the late completion.
  CancelToken? lastCancelToken;

  @override
  Future<Result<CalculationResult, AppFailure>> submit(
    CalculationRequest request, {
    DemoEvidenceCopy? demoCopy,
    bool Function()? isCancelled,
    CancelToken? cancelToken,
  }) async {
    submissions.add(request);
    lastCancelToken = cancelToken;
    if (blocker != null) await blocker!.future;
    // Mirror the live repository's contract: a cancellation observed
    // after the slow part (or an aborted HTTP token) skips the history
    // write and returns Err.
    if ((isCancelled?.call() ?? false) || (cancelToken?.isCancelled ?? false)) {
      return const Result.err(submissionCancelledFailure);
    }
    if (failureOverride != null) {
      return Result.err(failureOverride!);
    }
    final result = buildDemoResult(
      request,
      now: DateTime.utc(2026, 5, 20, 12),
      copy: demoCopy ?? DemoEvidenceCopy.fromL10n(AppLocalizationsEn()),
    );
    await _history?.save(request, result);
    return Result.ok(result);
  }
}
