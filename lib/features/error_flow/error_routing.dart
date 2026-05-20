import 'package:rectify/app/route_names.dart';
import 'package:rectify/core/failures.dart';

/// Identifies which of the six Phase-6 error screens to render.
///
/// Kept as a dedicated enum (rather than reading `runtimeType` at the
/// route level) so the mapping is exhaustive and the route doesn't
/// need to depend on `dart:io` types.
enum ErrorScreenKind {
  timeout,
  noInternet,
  badRequest,
  unauthorized,
  server,
  malformed;

  String get path => switch (this) {
    ErrorScreenKind.timeout => RoutePaths.errorTimeout,
    ErrorScreenKind.noInternet => RoutePaths.errorNoInternet,
    ErrorScreenKind.badRequest => RoutePaths.errorBadRequest,
    ErrorScreenKind.unauthorized => RoutePaths.errorUnauthorized,
    ErrorScreenKind.server => RoutePaths.errorServer,
    ErrorScreenKind.malformed => RoutePaths.errorMalformed,
  };
}

/// Map an [AppFailure] to the matching error screen
/// (`docs/implementation-plan.md` §11.3 / §14 Phase 6).
///
/// Unknown / storage / rate-limited / geocoding failures collapse onto
/// the generic server screen — those paths aren't reachable from the
/// rectification submission flow in the MVP, but the fall-through
/// keeps the function total so a future addition can't compile against
/// a stale switch.
ErrorScreenKind errorScreenForFailure(AppFailure failure) {
  return switch (failure) {
    TimeoutFailure() => ErrorScreenKind.timeout,
    NoNetworkFailure() => ErrorScreenKind.noInternet,
    BadRequestFailure() => ErrorScreenKind.badRequest,
    UnauthorizedFailure() => ErrorScreenKind.unauthorized,
    ServerFailure() => ErrorScreenKind.server,
    RateLimitedFailure() => ErrorScreenKind.server,
    MalformedResponseFailure() => ErrorScreenKind.malformed,
    StorageFailure() => ErrorScreenKind.server,
    GeocodingFailure() => ErrorScreenKind.server,
    UnknownFailure() => ErrorScreenKind.server,
  };
}
