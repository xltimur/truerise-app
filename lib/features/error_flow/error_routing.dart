import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rectify/app/route_names.dart';
import 'package:rectify/core/failures.dart';

/// In-memory handoff of the last typed [AppFailure] from
/// `CalculationLoadingScreen` to `CalculationErrorScreen`, for failure
/// details that can't be serialized into the route (e.g.
/// `RateLimitedFailure.resetAt` / `retryAfter`).
final NotifierProvider<LastCalculationFailureNotifier, AppFailure?>
lastCalculationFailureProvider =
    NotifierProvider<LastCalculationFailureNotifier, AppFailure?>(
      LastCalculationFailureNotifier.new,
    );

class LastCalculationFailureNotifier extends Notifier<AppFailure?> {
  @override
  AppFailure? build() => null;

  AppFailure? get rememberedFailure => state;

  set rememberedFailure(AppFailure? failure) => state = failure;
}

/// Identifies which of the error screens to render.
///
/// Kept as a dedicated enum (rather than reading `runtimeType` at the
/// route level) so the mapping is exhaustive and the route doesn't
/// need to depend on `dart:io` types.
enum ErrorScreenKind {
  timeout,
  noInternet,
  badRequest,
  unauthorized,
  missingApiKey,
  server,
  rateLimited,
  malformed;

  String get path => switch (this) {
    ErrorScreenKind.timeout => RoutePaths.errorTimeout,
    ErrorScreenKind.noInternet => RoutePaths.errorNoInternet,
    ErrorScreenKind.badRequest => RoutePaths.errorBadRequest,
    ErrorScreenKind.unauthorized => RoutePaths.errorUnauthorized,
    ErrorScreenKind.missingApiKey => RoutePaths.errorMissingApiKey,
    ErrorScreenKind.server => RoutePaths.errorServer,
    ErrorScreenKind.rateLimited => RoutePaths.errorRateLimited,
    ErrorScreenKind.malformed => RoutePaths.errorMalformed,
  };
}

/// Map an [AppFailure] to the matching error screen
/// (`docs/implementation-plan.md` §11.3 / §14 Phase 6).
///
/// Unknown / storage / geocoding failures collapse onto the generic
/// server screen — those paths aren't reachable from the rectification
/// submission flow in the MVP, but the fall-through keeps the function
/// total so a future addition can't compile against a stale switch.
ErrorScreenKind errorScreenForFailure(AppFailure failure) {
  return switch (failure) {
    TimeoutFailure() => ErrorScreenKind.timeout,
    NoNetworkFailure() => ErrorScreenKind.noInternet,
    BadRequestFailure() => ErrorScreenKind.badRequest,
    UnauthorizedFailure() => ErrorScreenKind.unauthorized,
    // Live calculation couldn't be started — distinct screen with
    // neutral retry / Demo-mode copy, so the user isn't stuck on the
    // generic "credentials rejected" message.
    MissingApiKeyFailure() => ErrorScreenKind.missingApiKey,
    ServerFailure() => ErrorScreenKind.server,
    // 429 rate-limit response — distinct screen so the user gets honest
    // "you've hit the limit" copy with the Demo-mode alternative, rather
    // than the generic "their service is down" one.
    RateLimitedFailure() => ErrorScreenKind.rateLimited,
    MalformedResponseFailure() => ErrorScreenKind.malformed,
    StorageFailure() => ErrorScreenKind.server,
    GeocodingFailure() => ErrorScreenKind.server,
    UnknownFailure() => ErrorScreenKind.server,
  };
}
