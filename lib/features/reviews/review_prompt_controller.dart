import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rectify/core/reviews/review_service.dart';
import 'package:rectify/data/prefs/review_prompt_store.dart';
import 'package:rectify/providers/core_providers.dart';

/// Pure, deterministic eligibility rule for the review prompt.
///
/// A prompt is eligible only when the app has never asked before, or the
/// cooldown has fully elapsed since the last ask. This guarantees "at most
/// once per cooldown window" regardless of how many positive moments the
/// user hits, and keeps the decision unit-testable with an injected clock
/// — there is no hidden randomness or platform dependency here.
abstract final class ReviewPolicy {
  /// A deliberately long default so the user is never nagged. Apple caps
  /// the native prompt at three per 365 days; ~once per 120 days sits
  /// well inside that and matches the "long cooldown" guidance.
  static const Duration defaultCooldown = Duration(days: 120);

  static bool isEligible({
    required DateTime now,
    required DateTime? lastPromptAt,
    Duration cooldown = defaultCooldown,
  }) {
    if (lastPromptAt == null) return true;
    return now.difference(lastPromptAt) >= cooldown;
  }
}

/// Drives the compliant in-app review ask.
///
/// Compliance is structural, not a matter of copy review:
///   * it only ever calls [ReviewService.requestReview] — there is no way
///     to request a specific star count, offer a reward, or gate any
///     feature behind a rating;
///   * the OS owns the rating UI and never returns the rating, so no code
///     path here can branch on it;
///   * [shouldRequest] throttles asks to at most once per cooldown.
///
/// The controller is intentionally UI-free so it can be unit-tested; the
/// platform-owned review surface is requested from `review_invitation.dart`.
class ReviewPromptController {
  ReviewPromptController({
    required this.store,
    required this.service,
    this.now = DateTime.now,
    this.cooldown = ReviewPolicy.defaultCooldown,
  });

  final ReviewPromptStore store;
  final ReviewService service;
  final DateTime Function() now;
  final Duration cooldown;

  /// Whether the app may invite a review right now: the throttle has
  /// elapsed (or we have never asked) AND the device can actually present
  /// the native flow.
  Future<bool> shouldRequest() async {
    final eligible = ReviewPolicy.isEligible(
      now: now(),
      lastPromptAt: store.lastPromptAt(),
      cooldown: cooldown,
    );
    if (!eligible) return false;
    return service.isAvailable();
  }

  /// Records that we invited a review now, starting the cooldown. Called
  /// when the invitation is shown, so even a *declined* invitation is not
  /// repeated until the cooldown elapses.
  Future<void> recordPrompted() => store.setLastPromptAt(now());

  /// Hands off to the OS review flow. Safe to call after [shouldRequest];
  /// it re-checks availability defensively.
  Future<void> requestReview() async {
    if (await service.isAvailable()) {
      await service.requestReview();
    }
  }
}

/// Wraps the resolved shared preferences in the review throttle store.
final reviewPromptStoreProvider = Provider<ReviewPromptStore>(
  (ref) => ReviewPromptStore(ref.watch(sharedPreferencesProvider)),
);

/// The controller used by the result-screen share flow.
final reviewPromptControllerProvider = Provider<ReviewPromptController>((ref) {
  return ReviewPromptController(
    store: ref.watch(reviewPromptStoreProvider),
    service: ref.watch(reviewServiceProvider),
  );
});
