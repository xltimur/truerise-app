import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rectify/theme/colors.dart';
import 'package:rectify/widgets/buttons/buttons.dart';

import '../../helpers/widget_test_harness.dart';

void main() {
  group('PrimaryButton', () {
    testWidgets('renders label and is tappable', (tester) async {
      var taps = 0;
      await pumpRectifyWidget(
        tester,
        PrimaryButton(label: 'Continue', onPressed: () => taps++),
      );

      expect(find.text('Continue'), findsOneWidget);
      await tester.tap(find.text('Continue'));
      expect(taps, 1);
    });

    testWidgets('exposes button semantics and is enabled', (tester) async {
      await pumpRectifyWidget(
        tester,
        PrimaryButton(label: 'Continue', onPressed: () {}),
      );

      final semantics = tester.getSemantics(find.text('Continue'));
      expect(semantics.label, contains('Continue'));
      expect(
        semantics.hasFlag(SemanticsFlag.isButton),
        isTrue,
        reason: 'PrimaryButton must announce as button to assistive tech',
      );
      expect(
        semantics.hasFlag(SemanticsFlag.isEnabled),
        isTrue,
        reason: 'Enabled button must announce enabled flag',
      );
    });

    testWidgets('disabled when onPressed is null and ignores taps', (
      tester,
    ) async {
      const taps = 0;
      await pumpRectifyWidget(
        tester,
        const PrimaryButton(label: 'Continue'),
      );

      await tester.tap(find.text('Continue'));
      expect(taps, 0);

      final semantics = tester.getSemantics(find.text('Continue'));
      expect(semantics.hasFlag(SemanticsFlag.isEnabled), isFalse);
    });

    testWidgets('meets 44pt minimum tap target', (tester) async {
      await pumpRectifyWidget(
        tester,
        PrimaryButton(label: 'Continue', onPressed: () {}),
      );

      final size = tester.getSize(find.byType(PrimaryButton));
      expect(size.height, greaterThanOrEqualTo(44));
    });
  });

  group('SecondaryButton', () {
    testWidgets('renders label and surface is bgSurface', (tester) async {
      await pumpRectifyWidget(
        tester,
        SecondaryButton(label: 'Save to history', onPressed: () {}),
      );

      expect(find.text('Save to history'), findsOneWidget);

      final container = tester.widget<AnimatedContainer>(
        find.descendant(
          of: find.byType(SecondaryButton),
          matching: find.byType(AnimatedContainer),
        ),
      );
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.color, AppColors.bgSurface);
      expect(decoration.border, isNotNull);
    });

    testWidgets('semantics announces button', (tester) async {
      await pumpRectifyWidget(
        tester,
        SecondaryButton(label: 'Save to history', onPressed: () {}),
      );

      final semantics = tester.getSemantics(find.text('Save to history'));
      expect(semantics.hasFlag(SemanticsFlag.isButton), isTrue);
    });
  });

  group('GhostButton', () {
    testWidgets('renders label and has 44pt minimum height', (tester) async {
      await pumpRectifyWidget(
        tester,
        GhostButton(label: 'Skip', onPressed: () {}),
      );

      expect(find.text('Skip'), findsOneWidget);
      final size = tester.getSize(find.byType(GhostButton));
      expect(size.height, greaterThanOrEqualTo(44));
    });

    testWidgets('label color is accentClayDeep when enabled', (tester) async {
      await pumpRectifyWidget(
        tester,
        GhostButton(label: 'Skip', onPressed: () {}),
      );

      final text = tester.widget<Text>(find.text('Skip'));
      expect(text.style?.color, AppColors.accentClayDeep);
    });
  });

  group('DestructiveButton', () {
    testWidgets('renders label and uses statusDanger ink', (tester) async {
      await pumpRectifyWidget(
        tester,
        DestructiveButton(label: 'Delete all data', onPressed: () {}),
      );

      expect(find.text('Delete all data'), findsOneWidget);
      final text = tester.widget<Text>(find.text('Delete all data'));
      expect(text.style?.color, AppColors.statusDanger);
    });

    testWidgets('semantics announces button + enabled', (tester) async {
      await pumpRectifyWidget(
        tester,
        DestructiveButton(label: 'Delete all data', onPressed: () {}),
      );

      final semantics = tester.getSemantics(find.text('Delete all data'));
      expect(semantics.hasFlag(SemanticsFlag.isButton), isTrue);
      expect(semantics.hasFlag(SemanticsFlag.isEnabled), isTrue);
    });
  });
}
