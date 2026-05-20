import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rectify/theme/icons.dart';
import 'package:rectify/widgets/nav/nav.dart';

import '../../helpers/widget_test_harness.dart';

void main() {
  group('StepperHeader', () {
    testWidgets('renders eyebrow text "STEP 2 OF 3"', (tester) async {
      await pumpRectifyWidget(
        tester,
        const SizedBox(
          width: 320,
          child: StepperHeader(currentStep: 2, totalSteps: 3),
        ),
      );

      expect(find.text('STEP 2 OF 3'), findsOneWidget);
    });

    testWidgets('semantics announces step + progress value', (tester) async {
      await pumpRectifyWidget(
        tester,
        const SizedBox(
          width: 320,
          child: StepperHeader(currentStep: 2, totalSteps: 3),
        ),
      );

      final semantics = tester.getSemantics(find.byType(StepperHeader));
      expect(semantics.label, contains('STEP 2 OF 3'));
      expect(semantics.value, contains('67'));
    });
  });

  group('TopNav', () {
    testWidgets('renders title and triggers onBack', (tester) async {
      var backs = 0;
      await pumpRectifyWidget(
        tester,
        Scaffold(
          appBar: TopNav(title: 'Result', onBack: () => backs++),
        ),
      );

      expect(find.text('Result'), findsOneWidget);
      await tester.tap(find.byIcon(AppIcons.back));
      expect(backs, 1);
    });

    testWidgets('renders trailing icon when provided', (tester) async {
      var taps = 0;
      await pumpRectifyWidget(
        tester,
        Scaffold(
          appBar: TopNav(
            title: 'History',
            trailingIcon: AppIcons.settings,
            trailingSemanticsLabel: 'Settings',
            onTrailingTap: () => taps++,
          ),
        ),
      );

      await tester.tap(find.byIcon(AppIcons.settings));
      expect(taps, 1);
    });

    testWidgets('preferredSize is 44pt', (tester) async {
      const nav = TopNav(title: 'X');
      expect(nav.preferredSize.height, 44);
    });
  });

  group('BottomTabBar', () {
    testWidgets('renders all three destinations and selection state', (
      tester,
    ) async {
      BottomTabDestination? selected;
      await pumpRectifyWidget(
        tester,
        BottomTabBar(
          current: BottomTabDestination.history,
          onSelect: (v) => selected = v,
        ),
      );

      expect(find.text('NEW'), findsOneWidget);
      expect(find.text('HISTORY'), findsOneWidget);
      expect(find.text('SETTINGS'), findsOneWidget);

      await tester.tap(find.text('SETTINGS'));
      expect(selected, BottomTabDestination.settings);
    });

    testWidgets('current tab announces selected via semantics', (tester) async {
      await pumpRectifyWidget(
        tester,
        BottomTabBar(
          current: BottomTabDestination.history,
          onSelect: (_) {},
        ),
      );

      final semantics = tester.getSemantics(find.text('HISTORY'));
      expect(semantics.hasFlag(SemanticsFlag.isSelected), isTrue);
      final newSemantics = tester.getSemantics(find.text('NEW'));
      expect(newSemantics.hasFlag(SemanticsFlag.isSelected), isFalse);
    });
  });
}
