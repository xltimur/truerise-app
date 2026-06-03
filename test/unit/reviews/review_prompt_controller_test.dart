import 'package:flutter_test/flutter_test.dart';
import 'package:rectify/data/prefs/review_prompt_store.dart';
import 'package:rectify/features/reviews/review_prompt_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/fake_review_service.dart';

void main() {
  final now = DateTime.utc(2026, 6, 3, 12);

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  Future<ReviewPromptStore> freshStore() async =>
      ReviewPromptStore(await SharedPreferences.getInstance());

  group('ReviewPromptController.shouldRequest', () {
    test('true when never prompted and the service is available', () async {
      final controller = ReviewPromptController(
        store: await freshStore(),
        service: FakeReviewService(),
        now: () => now,
      );

      expect(await controller.shouldRequest(), isTrue);
    });

    test('false when still within the cooldown window', () async {
      final store = await freshStore();
      await store.setLastPromptAt(now.subtract(const Duration(days: 1)));
      final controller = ReviewPromptController(
        store: store,
        service: FakeReviewService(),
        now: () => now,
      );

      expect(await controller.shouldRequest(), isFalse);
    });

    test(
      'false when the cooldown elapsed but the device cannot show a review',
      () async {
        final controller = ReviewPromptController(
          store: await freshStore(),
          service: FakeReviewService(available: false),
          now: () => now,
        );

        expect(await controller.shouldRequest(), isFalse);
      },
    );
  });

  group('ReviewPromptController.requestReview', () {
    test('calls the native review flow when available', () async {
      final service = FakeReviewService();
      final controller = ReviewPromptController(
        store: await freshStore(),
        service: service,
        now: () => now,
      );

      await controller.requestReview();

      expect(service.requestReviewCount, 1);
    });

    test('does not call the native review flow when unavailable', () async {
      final service = FakeReviewService(available: false);
      final controller = ReviewPromptController(
        store: await freshStore(),
        service: service,
        now: () => now,
      );

      await controller.requestReview();

      expect(service.requestReviewCount, 0);
    });
  });

  test(
    'recordPrompted starts the cooldown so the next ask is throttled',
    () async {
      final store = await freshStore();
      final controller = ReviewPromptController(
        store: store,
        service: FakeReviewService(),
        now: () => now,
      );

      expect(await controller.shouldRequest(), isTrue);
      await controller.recordPrompted();

      expect(store.lastPromptAt(), now);
      expect(await controller.shouldRequest(), isFalse);
    },
  );
}
