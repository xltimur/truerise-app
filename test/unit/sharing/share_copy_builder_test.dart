import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_test/flutter_test.dart';
import 'package:rectify/core/sharing/share_copy_builder.dart';
import 'package:rectify/data/models/saved_calculation.dart';

import '../../data/fixtures/sample_calculation.dart';

SavedCalculation _savedSample() => SavedCalculation(
  request: sampleRequest(),
  result: sampleResult(),
);

void main() {
  group('ShareCopyBuilder.build privacy guarantees', () {
    late String copy;

    setUp(() {
      copy = ShareCopyBuilder.build(_savedSample());
    });

    test('does not include birth city', () {
      expect(copy, isNot(contains('Kyiv')));
      expect(copy, isNot(contains('Ukraine')));
    });

    test('does not include birth date', () {
      expect(copy, isNot(contains('1990')));
      // Month name is not included (the month number "5" and day "14"
      // appear in the time string "7:14" so bare digit checks are not
      // meaningful here — year uniquely identifies the birth date).
      expect(copy, isNot(contains('May')));
    });

    test('does not include life event categories or descriptions', () {
      expect(copy, isNot(contains('marriage')));
      expect(copy, isNot(contains('careerChange')));
      expect(copy, isNot(contains('relocation')));
      expect(copy, isNot(contains('University')));
    });

    test('does not include request label', () {
      expect(copy, isNot(contains('Sample calculation')));
    });

    test('does not include request or result IDs', () {
      expect(copy, isNot(contains('req-001')));
    });

    test('does not include rawResponseJson', () {
      // rawResponseJson is null in the fixture; ensure key string not leaked.
      expect(copy, isNot(contains('rawResponseJson')));
      expect(copy, isNot(contains('apiCalculationId')));
    });
  });

  group('ShareCopyBuilder.build content', () {
    test('includes rectified hour and minute', () {
      final copy = ShareCopyBuilder.build(_savedSample());
      // Top candidate: 7:14 AM
      expect(copy, contains('7:14'));
    });

    test('includes AM/PM meridiem', () {
      final copy = ShareCopyBuilder.build(_savedSample());
      expect(copy, contains('AM'));
    });

    test('includes ascending sign', () {
      final copy = ShareCopyBuilder.build(_savedSample());
      expect(copy, contains('Gemini Rising'));
    });

    test('includes confidence percentage', () {
      final copy = ShareCopyBuilder.build(_savedSample());
      // 0.78 → 78%
      expect(copy, contains('78%'));
    });

    test('includes app name', () {
      final copy = ShareCopyBuilder.build(_savedSample());
      expect(copy, contains('TrueRise'));
    });

    test('returns non-empty fallback when candidates list is empty', () {
      final saved = SavedCalculation(
        request: sampleRequest(),
        result: sampleResult().copyWith(candidates: const []),
      );
      final copy = ShareCopyBuilder.build(saved);
      expect(copy, isNotEmpty);
      expect(copy, contains('TrueRise'));
      // Still must not leak request data
      expect(copy, isNot(contains('Kyiv')));
    });

    test('omits "Rising" line when ascendant is null', () {
      final saved = SavedCalculation(
        request: sampleRequest(),
        result: sampleResult().copyWith(
          candidates: [
            sampleResult().candidates.first.copyWith(ascendant: null),
          ],
        ),
      );
      final copy = ShareCopyBuilder.build(saved);
      expect(copy, isNot(contains('Rising')));
      expect(copy, contains('78%'));
    });

    test('uses 12-hour format even for PM times', () {
      // 14:05 → 2:05 PM
      final saved = SavedCalculation(
        request: sampleRequest(),
        result: sampleResult().copyWith(
          candidates: [
            sampleResult().candidates.first.copyWith(
              time: const TimeOfDay(hour: 14, minute: 5),
            ),
          ],
        ),
      );
      final copy = ShareCopyBuilder.build(saved);
      expect(copy, contains('2:05'));
      expect(copy, contains('PM'));
      expect(copy, isNot(contains('14:')));
    });
  });
}
