import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rectify/theme/icons.dart';
import 'package:rectify/widgets/sheets/bottom_sheet_picker.dart';

import '../../helpers/widget_test_harness.dart';

void main() {
  group('BottomSheetPicker (embedded)', () {
    testWidgets('renders title and option list with current selection', (
      tester,
    ) async {
      String? captured;
      await pumpRectifyWidget(
        tester,
        SizedBox(
          width: 360,
          child: BottomSheetPicker<String>(
            title: 'Time window',
            options: const <BottomSheetOption<String>>[
              BottomSheetOption(value: 'narrow', label: 'Narrow (±15 min)'),
              BottomSheetOption(value: 'wide', label: 'Wide (±3 hours)'),
            ],
            value: 'narrow',
            onSelected: (v) => captured = v,
          ),
        ),
      );

      expect(find.text('Time window'), findsOneWidget);
      expect(find.text('Narrow (±15 min)'), findsOneWidget);
      expect(find.text('Wide (±3 hours)'), findsOneWidget);
      // Check mark only renders on the currently selected row.
      expect(find.byIcon(AppIcons.check), findsOneWidget);

      await tester.tap(find.text('Wide (±3 hours)'));
      expect(captured, 'wide');
    });

    testWidgets('row exposes selected state in semantics', (tester) async {
      await pumpRectifyWidget(
        tester,
        SizedBox(
          width: 360,
          child: BottomSheetPicker<String>(
            title: 'Time window',
            options: const <BottomSheetOption<String>>[
              BottomSheetOption(value: 'narrow', label: 'Narrow'),
              BottomSheetOption(value: 'wide', label: 'Wide'),
            ],
            value: 'wide',
            onSelected: (_) {},
          ),
        ),
      );

      final selectedSemantics = tester.getSemantics(find.text('Wide'));
      expect(selectedSemantics.hasFlag(SemanticsFlag.isSelected), isTrue);
      final unselectedSemantics = tester.getSemantics(find.text('Narrow'));
      expect(unselectedSemantics.hasFlag(SemanticsFlag.isSelected), isFalse);
    });
  });

  group('BottomSheetPicker.show', () {
    testWidgets('opens modal and returns selected value', (tester) async {
      String? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    result = await BottomSheetPicker.show<String>(
                      context: context,
                      title: 'Pick',
                      options: const <BottomSheetOption<String>>[
                        BottomSheetOption(value: 'a', label: 'Option A'),
                        BottomSheetOption(value: 'b', label: 'Option B'),
                      ],
                      value: 'a',
                    );
                  },
                  child: const Text('Open sheet'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open sheet'));
      await tester.pumpAndSettle();

      expect(find.text('Pick'), findsOneWidget);
      expect(find.text('Option A'), findsOneWidget);
      expect(find.text('Option B'), findsOneWidget);

      await tester.tap(find.text('Option B'));
      await tester.pumpAndSettle();

      expect(result, 'b');
    });
  });
}
