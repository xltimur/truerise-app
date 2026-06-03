import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';

/// Abstraction over the OS in-app review mechanism so widgets, the prompt
/// controller, and tests stay decoupled from plugin details (mirrors
/// `ShareService`).
///
/// The contract is intentionally tiny and *compliant by construction*:
/// there is no parameter to request a specific star count, and
/// [requestReview] returns nothing. The rating UI is owned entirely by
/// the OS — `SKStoreReviewController` on iOS, the Play In-App Review API
/// on Android — and the chosen rating is never reported back to the app,
/// so no caller can branch on it.
abstract interface class ReviewService {
  /// Whether the device can present the native review flow.
  Future<bool> isAvailable();

  /// Asks the OS to present its native review flow. The OS decides
  /// whether anything is actually shown (both platforms throttle this
  /// heavily) and never tells us the outcome.
  Future<void> requestReview();
}

/// Riverpod provider — overridden in tests with a fake implementation.
final reviewServiceProvider = Provider<ReviewService>((ref) {
  return InAppReviewService();
});

/// [ReviewService] backed by the `in_app_review` plugin.
///
/// Both calls are guarded: on a host without the platform channel (the
/// unit / widget test VM, or an unsupported OS) the plugin throws
/// [MissingPluginException]. We treat that as "unavailable" rather than
/// letting it bubble into a positive-moment UI flow.
class InAppReviewService implements ReviewService {
  final InAppReview _inAppReview = InAppReview.instance;

  @override
  Future<bool> isAvailable() async {
    try {
      return await _inAppReview.isAvailable();
    } on MissingPluginException {
      return false;
    } on PlatformException {
      return false;
    }
  }

  @override
  Future<void> requestReview() async {
    try {
      await _inAppReview.requestReview();
    } on MissingPluginException {
      // No native review flow on this host — nothing to show.
    } on PlatformException {
      // The OS declined or the channel failed; never surface this in the
      // positive-moment flow.
    }
  }
}
