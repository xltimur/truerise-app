import 'package:rectify/core/reviews/review_service.dart';

/// In-memory [ReviewService] for unit and widget tests.
///
/// Records how many times [requestReview] was invoked so a test can
/// assert the native review flow was (or was not) reached. [available]
/// controls the [isAvailable] result.
class FakeReviewService implements ReviewService {
  FakeReviewService({this.available = true});

  /// Controls the value returned by [isAvailable].
  bool available;

  /// Number of times [requestReview] has been invoked.
  int requestReviewCount = 0;

  @override
  Future<bool> isAvailable() async => available;

  @override
  Future<void> requestReview() async {
    requestReviewCount += 1;
  }
}
