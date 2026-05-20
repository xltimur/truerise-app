import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rectify/theme/colors.dart';
import 'package:rectify/widgets/result/confidence_bar.dart';
import 'package:rectify/widgets/result/match_strength_dots.dart';

import '../../helpers/widget_test_harness.dart';

void main() {
  group('ConfidenceBar', () {
    testWidgets('renders rounded percentage and announces label', (
      tester,
    ) async {
      await pumpRectifyWidget(
        tester,
        const SizedBox(width: 320, child: ConfidenceBar(value: 0.78)),
      );

      expect(find.text('78%'), findsOneWidget);
      final semantics = tester.getSemantics(find.byType(ConfidenceBar));
      expect(semantics.label, contains('78 percent'));
    });

    testWidgets('picks high band color for ≥70%', (tester) async {
      await pumpRectifyWidget(
        tester,
        const SizedBox(width: 320, child: ConfidenceBar(value: 0.85)),
      );

      final fills = tester.widgetList<ColoredBox>(find.byType(ColoredBox));
      expect(
        fills.any((b) => b.color == AppColors.confidenceBarHigh),
        isTrue,
      );
    });

    testWidgets('picks mid band color for 40–69%', (tester) async {
      await pumpRectifyWidget(
        tester,
        const SizedBox(width: 320, child: ConfidenceBar(value: 0.55)),
      );

      final fills = tester.widgetList<ColoredBox>(find.byType(ColoredBox));
      expect(
        fills.any((b) => b.color == AppColors.confidenceBarMid),
        isTrue,
      );
    });

    testWidgets('picks low band color for <40%', (tester) async {
      await pumpRectifyWidget(
        tester,
        const SizedBox(width: 320, child: ConfidenceBar(value: 0.20)),
      );

      final fills = tester.widgetList<ColoredBox>(find.byType(ColoredBox));
      expect(
        fills.any((b) => b.color == AppColors.confidenceBarLow),
        isTrue,
      );
    });
  });

  group('MatchStrengthDots', () {
    testWidgets('renders 4 dots and the textual label', (tester) async {
      await pumpRectifyWidget(
        tester,
        const MatchStrengthDots(strength: MatchStrength.strong),
      );

      expect(find.text('STRONG'), findsOneWidget);
      final dots = find.descendant(
        of: find.byType(MatchStrengthDots),
        matching: find.byType(DecoratedBox),
      );
      expect(dots.evaluate().length, greaterThanOrEqualTo(4));
    });

    testWidgets('NO MATCH variant renders no-match label', (tester) async {
      await pumpRectifyWidget(
        tester,
        const MatchStrengthDots(strength: MatchStrength.none),
      );

      expect(find.text('NO MATCH'), findsOneWidget);
    });

    testWidgets('announces strength via semantics', (tester) async {
      await pumpRectifyWidget(
        tester,
        const MatchStrengthDots(strength: MatchStrength.moderate),
      );

      final semantics = tester.getSemantics(find.byType(MatchStrengthDots));
      expect(semantics.label, contains('moderate'));
    });
  });
}
