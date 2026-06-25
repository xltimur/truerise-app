import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:rectify/features/calculation_flow/widgets/add_event_sheet.dart';
import 'package:rectify/widgets/inputs/inputs.dart';

import '../../../helpers/widget_test_harness.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('uk');
  });

  testWidgets('month picker follows the selected Ukrainian locale', (
    tester,
  ) async {
    await pumpRectifyWidget(
      tester,
      const SizedBox(
        width: 360,
        child: AddEventSheet(),
      ),
      locale: const Locale('uk'),
    );

    await tester.tap(find.byType(DatePickerField).at(1));
    await tester.pumpAndSettle();

    expect(find.text('Місяць'), findsWidgets);
    expect(find.text('Jan'), findsNothing);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Text &&
            widget.data != null &&
            widget.data!.toLowerCase().startsWith('січ'),
      ),
      findsOneWidget,
    );
  });
}
