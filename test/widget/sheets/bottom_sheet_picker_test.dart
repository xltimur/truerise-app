import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rectify/theme/icons.dart';
import 'package:rectify/widgets/sheets/bottom_sheet_picker.dart';

import '../../helpers/widget_test_harness.dart';

// 14 month options used by the overflow / scroll tests.
const _monthOptions = <BottomSheetOption<String>>[
  BottomSheetOption(value: 'none', label: 'No month'),
  BottomSheetOption(value: '1', label: 'January'),
  BottomSheetOption(value: '2', label: 'February'),
  BottomSheetOption(value: '3', label: 'March'),
  BottomSheetOption(value: '4', label: 'April'),
  BottomSheetOption(value: '5', label: 'May'),
  BottomSheetOption(value: '6', label: 'June'),
  BottomSheetOption(value: '7', label: 'July'),
  BottomSheetOption(value: '8', label: 'August'),
  BottomSheetOption(value: '9', label: 'September'),
  BottomSheetOption(value: '10', label: 'October'),
  BottomSheetOption(value: '11', label: 'November'),
  BottomSheetOption(value: '12', label: 'December'),
];

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

    testWidgets(
      'long list (13 items) inside a small viewport does not overflow',
      (tester) async {
        // Simulate a constrained bottom-sheet height on a small iPhone.
        await pumpRectifyWidget(
          tester,
          SizedBox(
            width: 375,
            height: 400,
            child: BottomSheetPicker<String>(
              title: 'Month',
              options: _monthOptions,
              value: 'none',
              onSelected: (_) {},
            ),
          ),
          size: const Size(375, 667),
        );

        // A render overflow would have thrown a FlutterError by now.
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'long list bottom items are accessible via scroll',
      (tester) async {
        await pumpRectifyWidget(
          tester,
          SizedBox(
            width: 375,
            height: 400,
            child: BottomSheetPicker<String>(
              title: 'Month',
              options: _monthOptions,
              value: 'none',
              onSelected: (_) {},
            ),
          ),
          size: const Size(375, 667),
        );

        // 'December' is the last item and is off-screen at initial render.
        await tester.scrollUntilVisible(
          find.text('December'),
          56,
          scrollable: find.byType(Scrollable).last,
        );

        expect(find.text('December'), findsOneWidget);
      },
    );

    testWidgets(
      'selected item in long list shows checkmark',
      (tester) async {
        await pumpRectifyWidget(
          tester,
          SizedBox(
            width: 375,
            height: 400,
            child: BottomSheetPicker<String>(
              title: 'Month',
              options: _monthOptions,
              value: '12', // December
              onSelected: (_) {},
            ),
          ),
          size: const Size(375, 667),
        );

        // Scroll to the selected item.
        await tester.scrollUntilVisible(
          find.byIcon(AppIcons.check),
          56,
          scrollable: find.byType(Scrollable).last,
        );

        expect(find.byIcon(AppIcons.check), findsOneWidget);
      },
    );

    testWidgets(
      'a year-length list (126 items) does not overflow on an '
      'iPhone 17 viewport',
      (tester) async {
        // Mirrors the Add-event year picker (2025 → 1900) — the list
        // that produced the ~6800 px RenderFlex overflow before the
        // options were moved into a scrollable Flexible(ListView).
        final years = <BottomSheetOption<int>>[
          for (var year = 2025; year >= 1900; year--)
            BottomSheetOption<int>(value: year, label: '$year'),
        ];
        await pumpRectifyWidget(
          tester,
          SizedBox(
            width: 402,
            height: 420,
            child: BottomSheetPicker<int>(
              title: 'Year',
              options: years,
              value: 1990,
              onSelected: (_) {},
            ),
          ),
          size: const Size(402, 874),
        );

        // A render overflow would have thrown a FlutterError by now.
        expect(tester.takeException(), isNull);

        // The list scrolls: dragging past the top de-renders 2025 and
        // brings earlier years into view — still with no overflow.
        await tester.drag(
          find.byType(Scrollable).last,
          const Offset(0, -2000),
        );
        await tester.pump();
        expect(tester.takeException(), isNull);
        expect(find.text('2025'), findsNothing);
      },
    );
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
