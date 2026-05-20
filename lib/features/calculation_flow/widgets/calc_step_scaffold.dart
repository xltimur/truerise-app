import 'package:flutter/material.dart';

import 'package:rectify/features/calculation_flow/state/calculation_flow_state.dart';
import 'package:rectify/theme/colors.dart';
import 'package:rectify/theme/spacing.dart';
import 'package:rectify/theme/typography.dart';
import 'package:rectify/widgets/nav/stepper_header.dart';
import 'package:rectify/widgets/nav/top_nav.dart';

/// Shared scaffold for the stepped calc flow
/// (`docs/design-system.md` §10.1 + Screens 2–4).
///
/// Renders the TopNav (with back arrow), the stepper bar (steps 1–3),
/// a screen title, the body content, and a bottom-fixed primary CTA.
/// Body content scrolls; the CTA stays pinned above the safe-area
/// inset.
class CalcStepScaffold extends StatelessWidget {
  const CalcStepScaffold({
    required this.step,
    required this.title,
    required this.body,
    required this.primaryAction,
    this.onBack,
    this.secondaryAction,
    super.key,
  });

  /// Logical step. The numbered stepper renders only for steps 1–3;
  /// confirm / loading render without the bar.
  final CalculationFlowStep step;
  final String title;
  final Widget body;
  final Widget primaryAction;
  final Widget? secondaryAction;
  final VoidCallback? onBack;

  bool get _showStepper =>
      step.indicatorPosition <= CalculationFlowStep.totalNumberedSteps;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgApp,
      appBar: TopNav(
        title: 'New Calculation',
        onBack: onBack,
      ),
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenEdge,
                  AppSpacing.s5,
                  AppSpacing.screenEdge,
                  AppSpacing.s5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    if (_showStepper) ...<Widget>[
                      StepperHeader(
                        currentStep: step.indicatorPosition,
                        totalSteps: CalculationFlowStep.totalNumberedSteps,
                      ),
                      const SizedBox(height: AppSpacing.s6),
                    ],
                    Text(title, style: AppTypography.titleLg),
                    const SizedBox(height: AppSpacing.s5),
                    body,
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenEdge,
                AppSpacing.s6,
                AppSpacing.screenEdge,
                AppSpacing.s4,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (secondaryAction != null) ...<Widget>[
                    secondaryAction!,
                    const SizedBox(height: AppSpacing.s3),
                  ],
                  primaryAction,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
