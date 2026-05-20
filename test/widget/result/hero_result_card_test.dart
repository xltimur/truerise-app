import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rectify/theme/colors.dart';
import 'package:rectify/widgets/result/hero_result_card.dart';

import '../../helpers/widget_test_harness.dart';

void main() {
  group('HeroResultCard', () {
    testWidgets('renders eyebrow, time, meridiem and rising sign', (
      tester,
    ) async {
      await pumpRectifyWidget(
        tester,
        const SizedBox(
          width: 320,
          child: HeroResultCard(
            time: '7:14',
            meridiem: 'AM',
            risingSign: 'Gemini Rising',
          ),
        ),
      );

      expect(find.text('YOUR MOST PROBABLE BIRTH TIME'), findsOneWidget);
      expect(find.text('Gemini Rising'), findsOneWidget);

      // Time + meridiem render as a single Text.rich so we look up
      // the keyed widget and inspect its TextSpan.
      final timeText = tester.widget<Text>(find.byKey(heroTimeKey));
      expect(timeText.textSpan?.toPlainText(), contains('7:14'));
      expect(timeText.textSpan?.toPlainText(), contains('AM'));
    });

    testWidgets('decoration uses deep midnight + hero radius', (tester) async {
      await pumpRectifyWidget(
        tester,
        const SizedBox(
          width: 320,
          child: HeroResultCard(
            time: '7:14',
            meridiem: 'AM',
            risingSign: 'Gemini Rising',
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(HeroResultCard),
          matching: find.byType(Container),
        ),
      );
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.color, AppColors.deepMidnight);
      expect(decoration.borderRadius, isA<BorderRadius>());
    });

    testWidgets(
      'semantics announces eyebrow + time + rising sign as a header',
      (tester) async {
        await pumpRectifyWidget(
          tester,
          const SizedBox(
            width: 320,
            child: HeroResultCard(
              time: '7:14',
              meridiem: 'AM',
              risingSign: 'Gemini Rising',
            ),
          ),
        );

        final semantics = tester.getSemantics(find.byType(HeroResultCard));
        expect(semantics.label, contains('7:14 AM'));
        expect(semantics.label, contains('Gemini Rising'));
      },
    );
  });
}
