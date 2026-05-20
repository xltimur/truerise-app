import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rectify/widgets/result/confidence_bar.dart';
import 'package:rectify/widgets/result/hero_result_card.dart';
import 'package:rectify/widgets/result/match_strength_dots.dart';

import '../helpers/widget_test_harness.dart';

/// Goldens capture the pixel-level appearance of hero/visual widgets so
/// later token changes (color, radius, type scale) surface as diffs
/// instead of silently shifting the brand surface. Update with:
///
///   flutter test --update-goldens test/golden/hero_widgets_golden_test.dart
void main() {
  group('Hero widget goldens', () {
    testWidgets('HeroResultCard renders the deep-midnight surface', (
      tester,
    ) async {
      await pumpRectifyWidget(
        tester,
        const Padding(
          padding: EdgeInsets.all(16),
          child: SizedBox(
            width: 328,
            child: HeroResultCard(
              time: '7:14',
              meridiem: 'AM',
              risingSign: 'Gemini Rising',
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(HeroResultCard),
        matchesGoldenFile('goldens/hero_result_card.png'),
      );
    });

    testWidgets('ConfidenceBar — 78% (high band)', (tester) async {
      await pumpRectifyWidget(
        tester,
        const SizedBox(width: 280, child: ConfidenceBar(value: 0.78)),
      );

      await expectLater(
        find.byType(ConfidenceBar),
        matchesGoldenFile('goldens/confidence_bar_78.png'),
      );
    });

    testWidgets('ConfidenceBar — 42% (mid band)', (tester) async {
      await pumpRectifyWidget(
        tester,
        const SizedBox(width: 280, child: ConfidenceBar(value: 0.42)),
      );

      await expectLater(
        find.byType(ConfidenceBar),
        matchesGoldenFile('goldens/confidence_bar_42.png'),
      );
    });

    testWidgets('ConfidenceBar — 18% (low band)', (tester) async {
      await pumpRectifyWidget(
        tester,
        const SizedBox(width: 280, child: ConfidenceBar(value: 0.18)),
      );

      await expectLater(
        find.byType(ConfidenceBar),
        matchesGoldenFile('goldens/confidence_bar_18.png'),
      );
    });

    testWidgets('MatchStrengthDots — every level', (tester) async {
      await pumpRectifyWidget(
        tester,
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: 260,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                for (final strength in MatchStrength.values)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: MatchStrengthDots(strength: strength),
                  ),
              ],
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(Column),
        matchesGoldenFile('goldens/match_strength_dots_all.png'),
      );
    });
  });
}
