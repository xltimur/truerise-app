import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rectify/theme/icons.dart';
import 'package:rectify/widgets/buttons/buttons.dart';
import 'package:rectify/widgets/feedback/error_scaffold.dart';

import '../../helpers/widget_test_harness.dart';

void main() {
  group('ErrorScaffold', () {
    testWidgets('renders icon, title, description and both actions', (
      tester,
    ) async {
      var retries = 0;
      var cancels = 0;
      await pumpRectifyWidget(
        tester,
        ErrorScaffold(
          icon: AppIcons.refresh,
          title: 'No internet',
          description:
              'We could not reach the server. Check your connection and '
              'try again.',
          primaryAction: PrimaryButton(
            label: 'Try again',
            onPressed: () => retries++,
          ),
          secondaryAction: GhostButton(
            label: 'Cancel',
            onPressed: () => cancels++,
            expand: true,
          ),
        ),
      );

      expect(find.text('No internet'), findsOneWidget);
      expect(find.byIcon(AppIcons.refresh), findsOneWidget);

      await tester.tap(find.text('Try again'));
      expect(retries, 1);
      await tester.tap(find.text('Cancel'));
      expect(cancels, 1);
    });

    testWidgets('semantics scopes a route', (tester) async {
      await pumpRectifyWidget(
        tester,
        ErrorScaffold(
          icon: AppIcons.refresh,
          title: 'No internet',
          description: 'Check your connection.',
          primaryAction: PrimaryButton(label: 'Try again', onPressed: () {}),
        ),
      );

      final semantics = tester.getSemantics(find.byType(ErrorScaffold));
      expect(semantics.hasFlag(SemanticsFlag.scopesRoute), isTrue);
      expect(semantics.label, contains('No internet'));
      expect(semantics.label, contains('Check your connection.'));
    });
  });
}
