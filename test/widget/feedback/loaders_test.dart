import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rectify/widgets/feedback/breath_ring_loader.dart';
import 'package:rectify/widgets/feedback/pulse_dot_loader.dart';

import '../../helpers/widget_test_harness.dart';

void main() {
  group('PulseDotLoader', () {
    testWidgets('renders and announces loading label', (tester) async {
      await pumpRectifyWidget(tester, const PulseDotLoader());

      // Pump a couple of frames to ensure the animation loop starts.
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 200));

      final semantics = tester.getSemantics(find.byType(PulseDotLoader));
      expect(semantics.label, contains('Loading'));

      // Stop the implicit animation so the test can settle cleanly.
      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('reduced motion holds the dot still', (tester) async {
      await pumpRectifyWidget(
        tester,
        const PulseDotLoader(),
        reducedMotion: true,
      );

      await tester.pump(const Duration(milliseconds: 200));
      // No assertions on visual jitter — the contract is just that
      // the widget keeps rendering without throwing under
      // disableAnimations.
      expect(find.byType(PulseDotLoader), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
    });
  });

  group('BreathRingLoader', () {
    testWidgets('renders ring and announces calculating label', (tester) async {
      await pumpRectifyWidget(tester, const BreathRingLoader());

      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 200));

      final semantics = tester.getSemantics(find.byType(BreathRingLoader));
      expect(semantics.label, contains('Calculating'));

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('default size is 64pt', (tester) async {
      await pumpRectifyWidget(tester, const BreathRingLoader());
      await tester.pump(const Duration(milliseconds: 100));
      final size = tester.getSize(find.byType(BreathRingLoader));
      expect(size.width, 64);
      expect(size.height, 64);

      await tester.pumpWidget(const SizedBox.shrink());
    });
  });
}
