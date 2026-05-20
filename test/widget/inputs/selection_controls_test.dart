import 'package:flutter/material.dart' hide RadioGroup;
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rectify/widgets/inputs/inputs.dart';

import '../../helpers/widget_test_harness.dart';

void main() {
  group('RadioGroup', () {
    testWidgets('renders all options and current value', (tester) async {
      await pumpRectifyWidget(
        tester,
        SizedBox(
          width: 320,
          child: RadioGroup<String>(
            value: 'narrow',
            options: const <RadioOption<String>>[
              RadioOption(value: 'narrow', label: 'Narrow (±15 min)'),
              RadioOption(value: 'wide', label: 'Wide (±3 hours)'),
            ],
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.text('Narrow (±15 min)'), findsOneWidget);
      expect(find.text('Wide (±3 hours)'), findsOneWidget);
    });

    testWidgets('tapping a row emits the new value', (tester) async {
      String? selected;
      await pumpRectifyWidget(
        tester,
        SizedBox(
          width: 320,
          child: RadioGroup<String>(
            value: 'narrow',
            options: const <RadioOption<String>>[
              RadioOption(value: 'narrow', label: 'Narrow'),
              RadioOption(value: 'wide', label: 'Wide'),
            ],
            onChanged: (v) => selected = v,
          ),
        ),
      );

      await tester.tap(find.text('Wide'));
      expect(selected, 'Wide'.toLowerCase());
    });

    testWidgets('selected row exposes inMutuallyExclusiveGroup + checked', (
      tester,
    ) async {
      await pumpRectifyWidget(
        tester,
        SizedBox(
          width: 320,
          child: RadioGroup<String>(
            value: 'narrow',
            options: const <RadioOption<String>>[
              RadioOption(value: 'narrow', label: 'Narrow'),
              RadioOption(value: 'wide', label: 'Wide'),
            ],
            onChanged: (_) {},
          ),
        ),
      );

      final semantics = tester.getSemantics(find.text('Narrow'));
      expect(
        semantics.hasFlag(SemanticsFlag.isInMutuallyExclusiveGroup),
        isTrue,
      );
      expect(semantics.hasFlag(SemanticsFlag.isChecked), isTrue);
    });

    testWidgets('each row meets 44pt tap-target minimum', (tester) async {
      await pumpRectifyWidget(
        tester,
        SizedBox(
          width: 320,
          child: RadioGroup<String>(
            value: 'narrow',
            options: const <RadioOption<String>>[
              RadioOption(value: 'narrow', label: 'Narrow'),
              RadioOption(value: 'wide', label: 'Wide'),
            ],
            onChanged: (_) {},
          ),
        ),
      );

      final tappable = find.byType(InkWell);
      for (var i = 0; i < tappable.evaluate().length; i++) {
        expect(tester.getSize(tappable.at(i)).height, greaterThanOrEqualTo(44));
      }
    });
  });

  group('LabeledToggle', () {
    testWidgets('renders label and emits new value when tapped', (
      tester,
    ) async {
      bool? captured;
      await pumpRectifyWidget(
        tester,
        SizedBox(
          width: 320,
          child: LabeledToggle(
            label: 'Demo mode',
            value: false,
            onChanged: (v) => captured = v,
          ),
        ),
      );

      expect(find.text('Demo mode'), findsOneWidget);
      await tester.tap(find.text('Demo mode'));
      expect(captured, isTrue);
    });

    testWidgets('semantics announces toggle state', (tester) async {
      await pumpRectifyWidget(
        tester,
        SizedBox(
          width: 320,
          child: LabeledToggle(
            label: 'Demo mode',
            value: true,
            onChanged: (_) {},
          ),
        ),
      );

      final semantics = tester.getSemantics(find.byType(LabeledToggle));
      expect(semantics.hasFlag(SemanticsFlag.hasToggledState), isTrue);
      expect(semantics.hasFlag(SemanticsFlag.isToggled), isTrue);
      expect(semantics.label, contains('Demo mode'));
    });
  });
}
