import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rectify/theme/icons.dart';
import 'package:rectify/widgets/buttons/primary_button.dart';
import 'package:rectify/widgets/feedback/empty_state.dart';

import '../../helpers/widget_test_harness.dart';

void main() {
  group('EmptyState', () {
    testWidgets('renders title, body, icon and CTA', (tester) async {
      var taps = 0;
      await pumpRectifyWidget(
        tester,
        SizedBox(
          width: 360,
          child: EmptyState(
            icon: AppIcons.history,
            title: 'No calculations yet',
            body: 'Run a calculation to see results here.',
            cta: PrimaryButton(
              label: 'Try demo first',
              onPressed: () => taps++,
            ),
          ),
        ),
      );

      expect(find.text('No calculations yet'), findsOneWidget);
      expect(
        find.text('Run a calculation to see results here.'),
        findsOneWidget,
      );
      expect(find.byIcon(AppIcons.history), findsOneWidget);

      await tester.tap(find.text('Try demo first'));
      expect(taps, 1);
    });

    testWidgets('renders without icon or CTA when not provided', (
      tester,
    ) async {
      await pumpRectifyWidget(
        tester,
        const SizedBox(
          width: 360,
          child: EmptyState(
            title: 'Nothing here',
            body: 'Body text',
          ),
        ),
      );

      expect(find.text('Nothing here'), findsOneWidget);
      expect(find.byType(Icon), findsNothing);
    });

    testWidgets('semantics announces title + body as one unit', (tester) async {
      await pumpRectifyWidget(
        tester,
        const SizedBox(
          width: 360,
          child: EmptyState(
            title: 'Empty',
            body: 'Try again later',
          ),
        ),
      );

      final semantics = tester.getSemantics(find.byType(EmptyState));
      expect(semantics.label, contains('Empty'));
      expect(semantics.label, contains('Try again later'));
    });
  });
}
