import 'package:flutter_test/flutter_test.dart';
import 'package:rectify/features/reviews/review_prompt_controller.dart';

void main() {
  final now = DateTime.utc(2026, 6, 3, 12);

  group('ReviewPolicy.isEligible', () {
    test('eligible when the app has never prompted', () {
      expect(
        ReviewPolicy.isEligible(now: now, lastPromptAt: null),
        isTrue,
      );
    });

    test('not eligible immediately after a prompt', () {
      expect(
        ReviewPolicy.isEligible(now: now, lastPromptAt: now),
        isFalse,
      );
    });

    test('not eligible within the cooldown window', () {
      final last = now.subtract(const Duration(days: 119, hours: 23));
      expect(
        ReviewPolicy.isEligible(now: now, lastPromptAt: last),
        isFalse,
      );
    });

    test('eligible exactly at the cooldown boundary', () {
      final last = now.subtract(ReviewPolicy.defaultCooldown);
      expect(
        ReviewPolicy.isEligible(now: now, lastPromptAt: last),
        isTrue,
      );
    });

    test('eligible after the cooldown window', () {
      final last = now.subtract(const Duration(days: 200));
      expect(
        ReviewPolicy.isEligible(now: now, lastPromptAt: last),
        isTrue,
      );
    });

    test('honours a custom cooldown', () {
      final last = now.subtract(const Duration(days: 10));
      expect(
        ReviewPolicy.isEligible(
          now: now,
          lastPromptAt: last,
          cooldown: const Duration(days: 7),
        ),
        isTrue,
      );
      expect(
        ReviewPolicy.isEligible(
          now: now,
          lastPromptAt: last,
          cooldown: const Duration(days: 30),
        ),
        isFalse,
      );
    });
  });
}
