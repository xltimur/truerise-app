import 'package:meta/meta.dart';

/// Two-channel result type used at every repository / API boundary
/// (`docs/implementation-plan.md` §11.2).
///
/// Repositories return `Result<T, AppFailure>` rather than throwing
/// across layer boundaries so callers `.when(...)` over a typed
/// outcome instead of guessing which exception they need to catch.
@immutable
sealed class Result<T, F extends Object> {
  const Result();

  /// Convenience constructor for a success.
  const factory Result.ok(T value) = Ok<T, F>;

  /// Convenience constructor for a failure.
  const factory Result.err(F failure) = Err<T, F>;

  /// `true` when this is the `Ok` variant.
  bool get isOk => this is Ok<T, F>;

  /// `true` when this is the `Err` variant.
  bool get isErr => this is Err<T, F>;

  /// Pattern-match into a `B`.
  ///
  /// The compiler enforces exhaustiveness via Dart 3 sealed classes,
  /// but this helper keeps call sites tight at usage sites that don't
  /// already have a `switch` statement.
  B fold<B>({
    required B Function(T value) ok,
    required B Function(F failure) err,
  }) {
    final self = this;
    return switch (self) {
      Ok<T, F>(:final value) => ok(value),
      Err<T, F>(:final failure) => err(failure),
    };
  }

  /// Returns the contained value, or `null` if this is `Err`.
  T? get valueOrNull => switch (this) {
    Ok<T, F>(:final value) => value,
    Err<T, F>() => null,
  };

  /// Returns the contained failure, or `null` if this is `Ok`.
  F? get failureOrNull => switch (this) {
    Ok<T, F>() => null,
    Err<T, F>(:final failure) => failure,
  };
}

/// Success variant.
@immutable
final class Ok<T, F extends Object> extends Result<T, F> {
  const Ok(this.value);
  final T value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Ok<T, F> && other.value == value);

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @override
  String toString() => 'Ok($value)';
}

/// Failure variant.
@immutable
final class Err<T, F extends Object> extends Result<T, F> {
  const Err(this.failure);
  final F failure;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Err<T, F> && other.failure == failure);

  @override
  int get hashCode => Object.hash(runtimeType, failure);

  @override
  String toString() => 'Err($failure)';
}
