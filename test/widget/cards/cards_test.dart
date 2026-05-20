import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rectify/theme/colors.dart';
import 'package:rectify/theme/icons.dart';
import 'package:rectify/widgets/cards/cards.dart';
import 'package:rectify/widgets/result/match_strength_dots.dart';

import '../../helpers/widget_test_harness.dart';

void main() {
  group('AppCard', () {
    testWidgets('renders child and decorates with ink border', (tester) async {
      await pumpRectifyWidget(
        tester,
        const SizedBox(
          width: 320,
          child: AppCard(child: Text('Body')),
        ),
      );

      expect(find.text('Body'), findsOneWidget);
      final decorated = tester.widget<DecoratedBox>(
        find.descendant(
          of: find.byType(AppCard),
          matching: find.byType(DecoratedBox),
        ),
      );
      final decoration = decorated.decoration as BoxDecoration;
      expect(decoration.color, AppColors.bgSurface);
      expect(decoration.border, isNotNull);
    });

    testWidgets('onTap makes the card a button', (tester) async {
      var taps = 0;
      await pumpRectifyWidget(
        tester,
        SizedBox(
          width: 320,
          child: AppCard(
            onTap: () => taps++,
            child: const Text('Tap card'),
          ),
        ),
      );

      await tester.tap(find.byType(AppCard));
      expect(taps, 1);
    });
  });

  group('EventCard', () {
    testWidgets('renders category, date and announces label', (tester) async {
      await pumpRectifyWidget(
        tester,
        SizedBox(
          width: 320,
          child: EventCard(
            icon: AppIcons.eventMarriage,
            category: 'Marriage',
            date: 'June 2014',
            onDelete: () {},
          ),
        ),
      );

      expect(find.text('Marriage'), findsOneWidget);
      expect(find.text('June 2014'), findsOneWidget);
      final semantics = tester.getSemantics(find.byType(EventCard));
      expect(semantics.label, contains('Marriage'));
      expect(semantics.label, contains('June 2014'));
    });

    testWidgets('delete icon is a separate button', (tester) async {
      var deletes = 0;
      await pumpRectifyWidget(
        tester,
        SizedBox(
          width: 320,
          child: EventCard(
            icon: AppIcons.eventMarriage,
            category: 'Marriage',
            date: 'June 2014',
            onDelete: () => deletes++,
          ),
        ),
      );

      await tester.tap(find.byIcon(AppIcons.close));
      expect(deletes, 1);
    });
  });

  group('CandidateCard', () {
    testWidgets('renders rising sign + confidence percentage', (tester) async {
      await pumpRectifyWidget(
        tester,
        const SizedBox(
          width: 360,
          child: CandidateCard(
            time: '6:48',
            meridiem: 'AM',
            risingSign: 'Taurus Rising',
            confidence: 0.62,
          ),
        ),
      );

      expect(find.text('Taurus Rising'), findsOneWidget);
      expect(find.text('62%'), findsOneWidget);
    });
  });

  group('HistoryCard', () {
    testWidgets('renders label, time, demo pill when isDemo', (tester) async {
      await pumpRectifyWidget(
        tester,
        const SizedBox(
          width: 320,
          child: HistoryCard(
            label: 'Untitled calculation',
            date: '20 May 2026',
            time: '7:14',
            meridiem: 'AM',
            risingSign: 'Gemini Rising',
            confidence: 0.78,
            isDemo: true,
          ),
        ),
      );

      expect(find.text('Untitled calculation'), findsOneWidget);
      expect(find.text('20 May 2026'), findsOneWidget);
      expect(find.text('DEMO'), findsOneWidget);
      expect(find.text('78%'), findsOneWidget);
    });
  });

  group('EvidenceCard', () {
    testWidgets('tapping toggles explanation visibility', (tester) async {
      await pumpRectifyWidget(
        tester,
        const SizedBox(
          width: 360,
          child: EvidenceCard(
            icon: AppIcons.eventCareer,
            category: 'Career change',
            date: 'Sept 2019',
            strength: MatchStrength.strong,
            explanation:
                'Saturn crossed the 10th house cusp within the candidate '
                'window, supporting the time.',
          ),
        ),
      );

      expect(
        find.textContaining('Saturn crossed'),
        findsNothing,
        reason: 'Explanation hidden until expanded',
      );

      await tester.tap(find.byType(EvidenceCard));
      await tester.pump();
      expect(find.textContaining('Saturn crossed'), findsOneWidget);
    });

    testWidgets('exposes its match strength to the semantics tree', (
      tester,
    ) async {
      await pumpRectifyWidget(
        tester,
        const SizedBox(
          width: 360,
          child: EvidenceCard(
            icon: AppIcons.eventCareer,
            category: 'Career change',
            date: 'Sept 2019',
            strength: MatchStrength.moderate,
          ),
        ),
      );

      final semantics = tester.getSemantics(find.byType(EvidenceCard));
      expect(semantics.label, contains('moderate'));
      expect(semantics.hasFlag(SemanticsFlag.scopesRoute), isFalse);
    });
  });
}
