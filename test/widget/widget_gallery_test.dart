import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rectify/features/widget_gallery/widget_gallery_screen.dart';
import 'package:rectify/theme/theme.dart';
import 'package:rectify/widgets/buttons/buttons.dart';
import 'package:rectify/widgets/cards/cards.dart';
import 'package:rectify/widgets/chips/chips.dart';
import 'package:rectify/widgets/feedback/feedback.dart';
import 'package:rectify/widgets/inputs/inputs.dart' as inputs;
import 'package:rectify/widgets/nav/nav.dart';
import 'package:rectify/widgets/result/result.dart';

void main() {
  testWidgets('WidgetGalleryScreen renders one of each Phase 1 widget', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 4000));

    await tester.pumpWidget(
      MaterialApp(
        theme: buildLightTheme(),
        home: const WidgetGalleryScreen(),
      ),
    );
    await tester.pump();

    // Buttons
    expect(find.byType(PrimaryButton), findsWidgets);
    expect(find.byType(SecondaryButton), findsWidgets);
    expect(find.byType(GhostButton), findsWidgets);
    expect(find.byType(DestructiveButton), findsOneWidget);

    // Inputs
    expect(find.byType(inputs.InputField), findsOneWidget);
    expect(find.byType(inputs.DatePickerField), findsOneWidget);
    expect(find.byType(inputs.TimePickerField), findsOneWidget);
    expect(find.byType(inputs.RadioGroup<String>), findsOneWidget);
    expect(find.byType(inputs.LabeledToggle), findsOneWidget);

    // Chips
    expect(find.byType(ChipPill), findsWidgets);
    // One DemoPill in the Chips section, one inside the demo HistoryCard.
    expect(find.byType(DemoPill), findsWidgets);

    // Cards
    expect(find.byType(EventCard), findsOneWidget);
    expect(find.byType(CandidateCard), findsOneWidget);
    expect(find.byType(HistoryCard), findsOneWidget);
    expect(find.byType(EvidenceCard), findsOneWidget);

    // Confidence + hero
    expect(find.byType(ConfidenceBar), findsWidgets);
    expect(find.byType(MatchStrengthDots), findsWidgets);
    expect(find.byType(HeroResultCard), findsOneWidget);

    // Loaders + empty + nav + error
    expect(find.byType(PulseDotLoader), findsOneWidget);
    expect(find.byType(BreathRingLoader), findsOneWidget);
    expect(find.byType(EmptyState), findsOneWidget);
    expect(find.byType(StepperHeader), findsOneWidget);
    expect(find.byType(TopNav), findsOneWidget);
    expect(find.byType(BottomTabBar), findsOneWidget);
    expect(find.byType(ErrorScaffold), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.binding.setSurfaceSize(null);
  });
}
