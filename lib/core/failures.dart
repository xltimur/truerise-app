import 'package:meta/meta.dart';

/// Typed failure hierarchy carried by `Result.err`
/// (`docs/implementation-plan.md` §11.1).
///
/// Concrete variants map 1:1 to the UI error screens listed in §11.3.
@immutable
sealed class AppFailure {
  const AppFailure();
}

/// Network connectivity missing (DNS / no route / airplane mode).
final class NoNetworkFailure extends AppFailure {
  const NoNetworkFailure();
  @override
  bool operator ==(Object other) => other is NoNetworkFailure;
  @override
  int get hashCode => (NoNetworkFailure).hashCode;
  @override
  String toString() => 'NoNetworkFailure';
}

/// Request exceeded the configured 30s timeout.
final class TimeoutFailure extends AppFailure {
  const TimeoutFailure();
  @override
  bool operator ==(Object other) => other is TimeoutFailure;
  @override
  int get hashCode => (TimeoutFailure).hashCode;
  @override
  String toString() => 'TimeoutFailure';
}

/// 400 Bad Request — birth data / event payload rejected by the API.
final class BadRequestFailure extends AppFailure {
  const BadRequestFailure(this.message);
  final String message;

  @override
  bool operator ==(Object other) =>
      other is BadRequestFailure && other.message == message;
  @override
  int get hashCode => Object.hash(BadRequestFailure, message);
  @override
  String toString() => 'BadRequestFailure($message)';
}

/// 401 / 403 — missing or rejected credentials.
final class UnauthorizedFailure extends AppFailure {
  const UnauthorizedFailure();
  @override
  bool operator ==(Object other) => other is UnauthorizedFailure;
  @override
  int get hashCode => (UnauthorizedFailure).hashCode;
  @override
  String toString() => 'UnauthorizedFailure';
}

/// 429 — proxy / provider quota throttled.
final class RateLimitedFailure extends AppFailure {
  const RateLimitedFailure();
  @override
  bool operator ==(Object other) => other is RateLimitedFailure;
  @override
  int get hashCode => (RateLimitedFailure).hashCode;
  @override
  String toString() => 'RateLimitedFailure';
}

/// 5xx — generic upstream error.
final class ServerFailure extends AppFailure {
  const ServerFailure(this.status);
  final int status;

  @override
  bool operator ==(Object other) =>
      other is ServerFailure && other.status == status;
  @override
  int get hashCode => Object.hash(ServerFailure, status);
  @override
  String toString() => 'ServerFailure($status)';
}

/// Response body was not parseable as the expected schema.
final class MalformedResponseFailure extends AppFailure {
  const MalformedResponseFailure();
  @override
  bool operator ==(Object other) => other is MalformedResponseFailure;
  @override
  int get hashCode => (MalformedResponseFailure).hashCode;
  @override
  String toString() => 'MalformedResponseFailure';
}

/// City lookup didn't match anything.
final class GeocodingFailure extends AppFailure {
  const GeocodingFailure(this.query);
  final String query;

  @override
  bool operator ==(Object other) =>
      other is GeocodingFailure && other.query == query;
  @override
  int get hashCode => Object.hash(GeocodingFailure, query);
  @override
  String toString() => 'GeocodingFailure($query)';
}

/// Local SQLite / Drift error.
final class StorageFailure extends AppFailure {
  const StorageFailure(this.cause);
  final Object cause;

  @override
  bool operator ==(Object other) =>
      other is StorageFailure && other.cause == cause;
  @override
  int get hashCode => Object.hash(StorageFailure, cause);
  @override
  String toString() => 'StorageFailure($cause)';
}

/// Real-mode submission attempted without a provider API key configured.
///
/// Returned by LiveRectificationRepository before any network call is made,
/// so the error screen can direct the user to Settings rather than showing a
/// misleading connectivity error.
final class MissingApiKeyFailure extends AppFailure {
  const MissingApiKeyFailure();
  @override
  bool operator ==(Object other) => other is MissingApiKeyFailure;
  @override
  int get hashCode => (MissingApiKeyFailure).hashCode;
  @override
  String toString() => 'MissingApiKeyFailure';
}

/// Anything we can't classify; the only place where raw [Object] leaks.
final class UnknownFailure extends AppFailure {
  const UnknownFailure(this.cause);
  final Object cause;

  @override
  bool operator ==(Object other) =>
      other is UnknownFailure && other.cause == cause;
  @override
  int get hashCode => Object.hash(UnknownFailure, cause);
  @override
  String toString() => 'UnknownFailure($cause)';
}
