import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rectify/theme/colors.dart';
import 'package:rectify/widgets/chips/chips.dart';

import '../../helpers/widget_test_harness.dart';

void main() {
  group('ChipPill', () {
    testWidgets('renders label uppercased and is not interactive by default', (
      tester,
    ) async {
      await pumpRectifyWidget(tester, const ChipPill(label: 'event'));

      expect(find.text('EVENT'), findsOneWidget);
      final semantics = tester.getSemantics(find.byType(ChipPill));
      expect(semantics.hasFlag(SemanticsFlag.isButton), isFalse);
    });

    testWidgets('selected variant uses clay tint background', (tester) async {
      await pumpRectifyWidget(
        tester,
        const ChipPill(label: 'Strong', variant: ChipPillVariant.selected),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(ChipPill),
          matching: find.byType(Container),
        ),
      );
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.color, AppColors.accentClayTint);
    });

    testWidgets('status variant uses deep midnight + warm bone ink', (
      tester,
    ) async {
      await pumpRectifyWidget(
        tester,
        const ChipPill(label: 'DEMO', variant: ChipPillVariant.status),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(ChipPill),
          matching: find.byType(Container),
        ),
      );
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.color, AppColors.deepMidnight);
      final text = tester.widget<Text>(find.text('DEMO'));
      expect(text.style?.color, AppColors.bgApp);
    });

    testWidgets('becomes a button when onTap is provided', (tester) async {
      var taps = 0;
      await pumpRectifyWidget(
        tester,
        ChipPill(label: 'Tap', onTap: () => taps++),
      );

      final semantics = tester.getSemantics(find.byType(ChipPill));
      expect(semantics.hasFlag(SemanticsFlag.isButton), isTrue);

      await tester.tap(find.byType(ChipPill));
      expect(taps, 1);
    });
  });

  group('DemoPill', () {
    testWidgets('renders DEMO and announces demo badge', (tester) async {
      await pumpRectifyWidget(tester, const DemoPill());

      expect(find.text('DEMO'), findsOneWidget);
      final semantics = tester.getSemantics(find.byType(DemoPill));
      expect(semantics.label, contains('DEMO'));
    });
  });
}
