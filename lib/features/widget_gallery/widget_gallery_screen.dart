import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide RadioGroup;

import 'package:rectify/theme/colors.dart';
import 'package:rectify/theme/icons.dart';
import 'package:rectify/theme/spacing.dart';
import 'package:rectify/theme/typography.dart';
import 'package:rectify/widgets/buttons/buttons.dart';
import 'package:rectify/widgets/cards/cards.dart';
import 'package:rectify/widgets/chips/chips.dart';
import 'package:rectify/widgets/feedback/feedback.dart';
import 'package:rectify/widgets/inputs/inputs.dart';
import 'package:rectify/widgets/nav/nav.dart';
import 'package:rectify/widgets/result/result.dart';
import 'package:rectify/widgets/sheets/sheets.dart';

/// Debug-only widget catalogue (`docs/implementation-plan.md` §14
/// Phase 1 DoD: "/widget_gallery debug-only screen renders one of
/// each widget — gated behind kDebugMode, not shipped").
///
/// Renders one instance of every Phase 1 widget so a designer or
/// contractor can eyeball the whole component surface in a single
/// scroll. Not registered in release builds.
class WidgetGalleryScreen extends StatefulWidget {
  const WidgetGalleryScreen({super.key});

  @override
  State<WidgetGalleryScreen> createState() => _WidgetGalleryScreenState();
}

class _WidgetGalleryScreenState extends State<WidgetGalleryScreen> {
  String _radioValue = 'narrow';
  bool _toggleValue = true;
  bool _evidenceExpanded = false;
  BottomTabDestination _tab = BottomTabDestination.history;

  @override
  Widget build(BuildContext context) {
    assert(
      kDebugMode,
      'WidgetGalleryScreen is debug-only and must not appear in '
      'release builds (see docs/implementation-plan.md §14 Phase 1 DoD).',
    );

    return Scaffold(
      backgroundColor: AppColors.bgApp,
      appBar: TopNav(
        title: 'Widget gallery',
        onBack: () => Navigator.of(context).maybePop(),
      ),
      bottomNavigationBar: BottomTabBar(
        current: _tab,
        onSelect: (v) => setState(() => _tab = v),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenEdge,
            vertical: AppSpacing.s6,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _section('Buttons (§9.1)'),
              PrimaryButton(label: 'Continue', onPressed: () {}),
              const SizedBox(height: AppSpacing.s3),
              SecondaryButton(label: 'Save to history', onPressed: () {}),
              const SizedBox(height: AppSpacing.s3),
              const GhostButton(label: 'Skip', onPressed: _noop, expand: true),
              const SizedBox(height: AppSpacing.s3),
              DestructiveButton(label: 'Delete all data', onPressed: () {}),
              const SizedBox(height: AppSpacing.s7),

              _section('Inputs (§9.2)'),
              const InputField(
                label: 'Place of birth',
                hintText: 'City',
                leading: Icon(
                  AppIcons.search,
                  size: 20,
                  color: AppColors.inkMuted,
                ),
              ),
              const SizedBox(height: AppSpacing.s3),
              DatePickerField(
                label: 'Date of birth',
                placeholder: 'Select date',
                onTap: () {},
              ),
              const SizedBox(height: AppSpacing.s3),
              TimePickerField(
                label: 'Time of birth',
                formattedValue: '07:14 AM',
                onTap: () {},
              ),
              const SizedBox(height: AppSpacing.s7),

              _section('Selection controls (§9.3 / §9.4)'),
              RadioGroup<String>(
                value: _radioValue,
                options: const <RadioOption<String>>[
                  RadioOption(value: 'narrow', label: 'Narrow (±15 min)'),
                  RadioOption(value: 'wide', label: 'Wide (±3 hours)'),
                ],
                onChanged: (v) => setState(() => _radioValue = v),
              ),
              const SizedBox(height: AppSpacing.s3),
              LabeledToggle(
                label: 'Demo mode',
                helperText:
                    'Use a canned result instead of contacting the '
                    'rectification provider.',
                value: _toggleValue,
                onChanged: (v) => setState(() => _toggleValue = v),
              ),
              const SizedBox(height: AppSpacing.s7),

              _section('Chips (§9.5)'),
              const Wrap(
                spacing: AppSpacing.s2,
                runSpacing: AppSpacing.s2,
                children: <Widget>[
                  ChipPill(label: 'Career'),
                  ChipPill(
                    label: 'Selected',
                    variant: ChipPillVariant.selected,
                  ),
                  DemoPill(),
                ],
              ),
              const SizedBox(height: AppSpacing.s7),

              _section('Cards (§9.6)'),
              const AppCard(child: Text('Base AppCard surface')),
              const SizedBox(height: AppSpacing.s3),
              EventCard(
                icon: AppIcons.eventMarriage,
                category: 'Marriage',
                date: 'June 2014',
                onDelete: () {},
              ),
              const SizedBox(height: AppSpacing.s3),
              const CandidateCard(
                time: '6:48',
                meridiem: 'AM',
                risingSign: 'Taurus Rising',
                confidence: 0.62,
              ),
              const SizedBox(height: AppSpacing.s3),
              const HistoryCard(
                label: 'Untitled calculation',
                date: '20 May 2026',
                time: '7:14',
                meridiem: 'AM',
                risingSign: 'Gemini Rising',
                confidence: 0.78,
                isDemo: true,
              ),
              const SizedBox(height: AppSpacing.s3),
              EvidenceCard(
                icon: AppIcons.eventCareer,
                category: 'Career change',
                date: 'Sept 2019',
                strength: MatchStrength.strong,
                explanation:
                    'Saturn crossed the 10th house cusp within the '
                    'candidate window, strongly supporting the time.',
                expanded: _evidenceExpanded,
                onToggleExpanded: () =>
                    setState(() => _evidenceExpanded = !_evidenceExpanded),
              ),
              const SizedBox(height: AppSpacing.s7),

              _section('Confidence (§9.8 / §9.9)'),
              const ConfidenceBar(value: 0.78),
              const SizedBox(height: AppSpacing.s3),
              const ConfidenceBar(value: 0.42),
              const SizedBox(height: AppSpacing.s3),
              const ConfidenceBar(value: 0.18),
              const SizedBox(height: AppSpacing.s4),
              for (final strength in MatchStrength.values)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: MatchStrengthDots(strength: strength),
                ),
              const SizedBox(height: AppSpacing.s7),

              _section('Hero result (§9.7)'),
              const HeroResultCard(
                time: '7:14',
                meridiem: 'AM',
                risingSign: 'Gemini Rising',
              ),
              const SizedBox(height: AppSpacing.s7),

              _section('Loaders (§9.11)'),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  PulseDotLoader(),
                  BreathRingLoader(),
                ],
              ),
              const SizedBox(height: AppSpacing.s7),

              _section('Empty state (§9.14)'),
              EmptyState(
                icon: AppIcons.history,
                title: 'No calculations yet',
                body: 'Run your first calculation to see results here.',
                cta: PrimaryButton(
                  label: 'Try demo first',
                  onPressed: () {},
                ),
              ),
              const SizedBox(height: AppSpacing.s7),

              _section('Stepper (§9.10)'),
              const StepperHeader(currentStep: 2, totalSteps: 3),
              const SizedBox(height: AppSpacing.s7),

              _section('Bottom-sheet picker (§9.12 / §10.5)'),
              SecondaryButton(
                label: 'Open picker',
                onPressed: () => BottomSheetPicker.show<String>(
                  context: context,
                  title: 'Time window',
                  options: const <BottomSheetOption<String>>[
                    BottomSheetOption(
                      value: 'narrow',
                      label: 'Narrow (±15 min)',
                    ),
                    BottomSheetOption(
                      value: 'wide',
                      label: 'Wide (±3 hours)',
                    ),
                  ],
                  value: _radioValue,
                ),
              ),
              const SizedBox(height: AppSpacing.s7),

              _section('Error scaffold (§9.13)'),
              SizedBox(
                height: 480,
                child: ErrorScaffold(
                  icon: AppIcons.refresh,
                  title: 'No internet',
                  description:
                      'We could not reach the server. Check your '
                      'connection and try again.',
                  primaryAction: PrimaryButton(
                    label: 'Try again',
                    onPressed: () {},
                  ),
                  secondaryAction: const GhostButton(
                    label: 'Cancel',
                    onPressed: _noop,
                    expand: true,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s11),
            ],
          ),
        ),
      ),
    );
  }

  Widget _section(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s4),
      child: Text(
        label,
        style: AppTypography.titleSm.copyWith(color: AppColors.inkSoft),
      ),
    );
  }
}

void _noop() {}
