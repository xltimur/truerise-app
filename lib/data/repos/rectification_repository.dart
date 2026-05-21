import 'package:rectify/core/failures.dart';
import 'package:rectify/core/result.dart';
import 'package:rectify/data/api/mappers.dart';
import 'package:rectify/data/api/rectification_api.dart';
import 'package:rectify/data/demo/demo_response.dart';
import 'package:rectify/data/models/calculation_request.dart';
import 'package:rectify/data/models/calculation_result.dart';
import 'package:rectify/data/repos/history_repository.dart';

/// Repository contract for rectification submissions
/// (`docs/implementation-plan.md` §9.4).
///
/// Returns a typed [Result] so the controller can `.fold(...)` without
/// catching across layer boundaries.
abstract class RectificationRepository {
  Future<Result<CalculationResult, AppFailure>> submit(
    CalculationRequest request,
  );
}

/// Live implementation that branches on `request.isDemo`:
///
///   - **Demo path:** sleeps for [demoDelay] (3s in production, zero
///     in tests) and returns `buildDemoResult(request)` — no HTTP
///     client constructed, per §9.5 / §10.4.
///   - **Real path (no key):** returns [MissingApiKeyFailure] immediately,
///     so the UI can route the user to Settings instead of showing a
///     misleading connectivity error.
///   - **Real path (key present):** maps to a request DTO, calls
///     `RectificationApi.rectify`, maps the response back, persists
///     the aggregate via `HistoryRepository.save`, and returns the
///     domain result.
class LiveRectificationRepository implements RectificationRepository {
  LiveRectificationRepository({
    required this.api,
    required this.history,
    this.apiKeyIsConfigured = false,
    this.now = DateTime.now,
    this.demoDelay = const Duration(seconds: 3),
  });

  final RectificationApi api;
  final HistoryRepository history;

  /// Whether the user has entered a provider API key in Settings.
  ///
  /// Injected from proApiKeyProvider via rectificationRepositoryProvider.
  /// When false and `request.isDemo == false`, submit returns
  /// MissingApiKeyFailure before making any network call.
  final bool apiKeyIsConfigured;

  final DateTime Function() now;
  final Duration demoDelay;

  @override
  Future<Result<CalculationResult, AppFailure>> submit(
    CalculationRequest request,
  ) async {
    if (request.isDemo) {
      if (demoDelay > Duration.zero) {
        await Future<void>.delayed(demoDelay);
      }
      final result = buildDemoResult(request, now: now());
      await history.save(request, result);
      return Result.ok(result);
    }

    if (!apiKeyIsConfigured) {
      return const Result.err(MissingApiKeyFailure());
    }

    final dto = requestToDto(request);
    final apiResult = await api.rectify(dto);
    switch (apiResult) {
      case Ok(value: final response):
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
        return Result<CalculationResult, AppFailure>.err(failure);
    }
  }
}
