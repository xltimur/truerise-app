import 'package:dio/dio.dart' show CancelToken;

import 'package:rectify/core/failures.dart';
import 'package:rectify/core/result.dart';
import 'package:rectify/data/api/mappers.dart';
import 'package:rectify/data/api/rectification_api.dart';
import 'package:rectify/data/demo/demo_response.dart';
import 'package:rectify/data/models/calculation_request.dart';
import 'package:rectify/data/models/calculation_result.dart';
import 'package:rectify/data/prefs/live_quota_store.dart';
import 'package:rectify/data/repos/history_repository.dart';

/// Repository contract for rectification submissions
/// (`docs/implementation-plan.md` §9.4).
///
/// Returns a typed [Result] so the controller can `.fold(...)` without
/// catching across layer boundaries.
abstract class RectificationRepository {
  /// Submit [request] for rectification.
  ///
  /// Demo submissions (`request.isDemo == true`) must supply [demoCopy]
  /// with locale-resolved evidence prose; the real path ignores it.
  ///
  /// [isCancelled] is polled after the slow part of the submission (demo
  /// delay / network round trip) and before any history write. When it
  /// reports `true`, the implementation must NOT persist a history row
  /// and must return an [Err] instead of the result — the user already
  /// walked away from this submission via Cancel.
  ///
  /// [cancelToken], when supplied, is threaded into the live HTTP call
  /// so Cancel aborts the in-flight request itself instead of letting
  /// it run to completion and discarding the answer. The demo path
  /// ignores it (the delay is short and [isCancelled] already guards
  /// the write).
  Future<Result<CalculationResult, AppFailure>> submit(
    CalculationRequest request, {
    DemoEvidenceCopy? demoCopy,
    bool Function()? isCancelled,
    CancelToken? cancelToken,
  });
}

/// Marker failure returned for a submission abandoned via Cancel. Never
/// routed to an error screen: the loading screen that awaited the submit
/// is unmounted by the time it surfaces.
const AppFailure submissionCancelledFailure = UnknownFailure(
  'Submission cancelled by the user.',
);

/// Live implementation that branches on `request.isDemo`:
///
///   - **Demo path:** sleeps for [demoDelay] (3s in production, zero
///     in tests) and returns `buildDemoResult(request)` — no HTTP
///     client constructed, per §9.5 / §10.4.
///   - **Real path:** gates on the local free-attempt quota (unless
///     [bypassLiveQuota]), maps to a request DTO, calls
///     `RectificationApi.rectify`, maps the response back, persists
///     the aggregate via `HistoryRepository.save`, and returns the
///     domain result. With no provider key configured the API layer is
///     wired for proxy mode (the proxy holds the credential
///     server-side), so submission proceeds the same way.
class LiveRectificationRepository implements RectificationRepository {
  LiveRectificationRepository({
    required this.api,
    required this.history,
    this.liveQuotaStore,
    this.bypassLiveQuota = false,
    this.now = DateTime.now,
    this.demoDelay = const Duration(seconds: 3),
  });

  final RectificationApi api;
  final HistoryRepository history;

  /// Local quota for proxy-backed live attempts. When non-null (and
  /// [bypassLiveQuota] is false), real submissions are gated on it
  /// before any network call: exhausted quota returns a local
  /// [RateLimitedFailure], otherwise the attempt is recorded first.
  final LiveQuotaStore? liveQuotaStore;

  /// Skip the local quota entirely (Settings-entered own-key users):
  /// neither read nor record attempts. Proxy mode and the bundled
  /// review key keep this false so the quota stays enforced.
  final bool bypassLiveQuota;

  final DateTime Function() now;
  final Duration demoDelay;

  @override
  Future<Result<CalculationResult, AppFailure>> submit(
    CalculationRequest request, {
    DemoEvidenceCopy? demoCopy,
    bool Function()? isCancelled,
    CancelToken? cancelToken,
  }) async {
    if (request.isDemo) {
      assert(
        demoCopy != null,
        'Demo submissions must supply demoCopy with localized prose.',
      );
      if (demoDelay > Duration.zero) {
        await Future<void>.delayed(demoDelay);
      }
      if (isCancelled?.call() ?? false) {
        return const Result.err(submissionCancelledFailure);
      }
      final result = buildDemoResult(request, now: now(), copy: demoCopy!);
      await history.save(request, result);
      return Result.ok(result);
    }

    final quota = liveQuotaStore;
    if (quota != null && !bypassLiveQuota) {
      final quotaNow = now();
      final snapshot = await quota.read(quotaNow);
      if (snapshot.exhausted) {
        return Result.err(
          RateLimitedFailure(
            source: RateLimitSource.local,
            resetAt: snapshot.resetAt,
            retryAfter: snapshot.retryAfter,
          ),
        );
      }
      await quota.recordAttempt(quotaNow);
    }

    final dto = requestToDto(request);
    final apiResult = await api.rectify(dto, cancelToken: cancelToken);
    switch (apiResult) {
      case Ok(value: final response):
        if (isCancelled?.call() ?? false) {
          return const Result.err(submissionCancelledFailure);
        }
        final result = responseToResult(
          requestId: request.id,
          dto: response.dto,
          completedAt: now(),
          rawResponseJson: response.rawJson,
          requestEvents: request.events,
        );
        final saved = await history.save(request, result);
        if (saved.isErr) {
          return Result<CalculationResult, AppFailure>.err(
            saved.failureOrNull!,
          );
        }
        return Result<CalculationResult, AppFailure>.ok(result);
      case Err(:final failure):
        // A user cancel aborts the Dio call mid-flight, which surfaces
        // here as a transport failure — return the cancellation marker
        // instead so the orphaned submit can never look like an Unknown
        // error to anything still listening.
        if (isCancelled?.call() ?? false) {
          return const Result.err(submissionCancelledFailure);
        }
        return Result<CalculationResult, AppFailure>.err(failure);
    }
  }
}
