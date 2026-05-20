import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rectify/widgets/result/hero_reveal.dart';

import '../../helpers/widget_test_harness.dart';

void main() {
  Finder revealOpacity() => find.descendant(
    of: find.byType(HeroReveal),
    matching: find.byType(Opacity),
  );

  Finder revealTransform() => find.descendant(
    of: find.byType(HeroReveal),
    matching: find.byType(Transform),
  );

  testWidgets(
    'animates from 0 → 1 opacity over heroRevealDuration when motion '
    'is enabled',
    (tester) async {
      await pumpRectifyWidget(
        tester,
        const HeroReveal(
          child: SizedBox(width: 100, height: 100, child: Placeholder()),
        ),
      );

      // First frame: opacity is at the controller's starting value (0).
      final initial = tester.widget<Opacity>(revealOpacity());
      expect(initial.opacity, lessThan(0.1));

      // Halfway through, the curve is past 0.5 but well below 1.
      await tester.pump(heroRevealDuration ~/ 2);
      final mid = tester.widget<Opacity>(revealOpacity());
      expect(mid.opacity, greaterThan(0.4));
      expect(mid.opacity, lessThan(1));

      // After the duration, the animation has fully settled.
      await tester.pump(heroRevealDuration);
      final settled = tester.widget<Opacity>(revealOpacity());
      expect(settled.opacity, 1.0);
    },
  );

  testWidgets(
    'snaps to fully revealed on first frame when '
    'MediaQuery.disableAnimations is true',
    (tester) async {
      await pumpRectifyWidget(
        tester,
        const HeroReveal(
          child: SizedBox(width: 100, height: 100, child: Placeholder()),
        ),
        reducedMotion: true,
      );

      // No pump required — the reveal must be done before the next frame.
      final opacity = tester.widget<Opacity>(revealOpacity());
      expect(opacity.opacity, 1.0);
      final translate = tester.widget<Transform>(revealTransform());
      final offset = translate.transform.getTranslation();
      expect(offset.y, 0.0);
    },
  );
}
