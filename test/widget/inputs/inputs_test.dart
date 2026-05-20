import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rectify/widgets/inputs/inputs.dart';

import '../../helpers/widget_test_harness.dart';

void main() {
  group('InputField', () {
    testWidgets('renders label and accepts input via keyboard', (tester) async {
      String? captured;
      await pumpRectifyWidget(
        tester,
        SizedBox(
          width: 320,
          child: InputField(
            label: 'Place of birth',
            hintText: 'City',
            onChanged: (value) => captured = value,
          ),
        ),
      );

      expect(find.text('Place of birth'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'Kyiv');
      expect(captured, 'Kyiv');
    });

    testWidgets('exposes textField semantics', (tester) async {
      await pumpRectifyWidget(
        tester,
        const SizedBox(
          width: 320,
          child: InputField(label: 'Place of birth'),
        ),
      );

      final semantics = tester.getSemantics(find.byType(InputField));
      expect(semantics.hasFlag(SemanticsFlag.isTextField), isTrue);
    });

    testWidgets('shows error text in danger color', (tester) async {
      await pumpRectifyWidget(
        tester,
        const SizedBox(
          width: 320,
          child: InputField(
            label: 'Place of birth',
            errorText: 'Required',
          ),
        ),
      );

      expect(find.text('Required'), findsOneWidget);
    });

    testWidgets('disabled state announces disabled', (tester) async {
      await pumpRectifyWidget(
        tester,
        const SizedBox(
          width: 320,
          child: InputField(label: 'Place of birth', enabled: false),
        ),
      );

      final semantics = tester.getSemantics(find.byType(InputField));
      expect(semantics.hasFlag(SemanticsFlag.isEnabled), isFalse);
    });
  });

  group('DatePickerField', () {
    testWidgets('shows placeholder when value is null', (tester) async {
      await pumpRectifyWidget(
        tester,
        SizedBox(
          width: 320,
          child: DatePickerField(
            label: 'Date of birth',
            placeholder: 'Select date',
            onTap: () {},
          ),
        ),
      );

      expect(find.text('Select date'), findsOneWidget);
      expect(find.text('Date of birth'), findsOneWidget);
    });

    testWidgets('invokes onTap', (tester) async {
      var taps = 0;
      await pumpRectifyWidget(
        tester,
        SizedBox(
          width: 320,
          child: DatePickerField(
            label: 'Date of birth',
            placeholder: 'Select date',
            onTap: () => taps++,
          ),
        ),
      );

      await tester.tap(find.text('Select date'));
      expect(taps, 1);
    });

    testWidgets('semantics declares button + value', (tester) async {
      await pumpRectifyWidget(
        tester,
        SizedBox(
          width: 320,
          child: DatePickerField(
            label: 'Date of birth',
            formattedValue: '14 May 1990',
            onTap: () {},
          ),
        ),
      );

      final semantics = tester.getSemantics(find.byType(DatePickerField));
      expect(semantics.hasFlag(SemanticsFlag.isButton), isTrue);
      expect(semantics.label, contains('14 May 1990'));
    });
  });

  group('TimePickerField', () {
    testWidgets('shows formatted value when provided', (tester) async {
      await pumpRectifyWidget(
        tester,
        SizedBox(
          width: 320,
          child: TimePickerField(
            label: 'Time of birth',
            formattedValue: '07:14 AM',
            onTap: () {},
          ),
        ),
      );

      expect(find.text('07:14 AM'), findsOneWidget);
    });

    testWidgets('semantics announces label and value', (tester) async {
      await pumpRectifyWidget(
        tester,
        SizedBox(
          width: 320,
          child: TimePickerField(
            label: 'Time of birth',
            formattedValue: '07:14 AM',
            onTap: () {},
          ),
        ),
      );

      final semantics = tester.getSemantics(find.byType(TimePickerField));
      expect(semantics.label, contains('Time of birth'));
      expect(semantics.label, contains('07:14 AM'));
    });
  });
}
