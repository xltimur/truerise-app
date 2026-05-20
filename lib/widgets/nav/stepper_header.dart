import 'package:flutter/material.dart';

import 'package:rectify/theme/colors.dart';
import 'package:rectify/theme/motion.dart';
import 'package:rectify/theme/spacing.dart';
import 'package:rectify/theme/typography.dart';

/// Stepper header used on the calculation flow
/// (`docs/design-system.md` §9.10).
///
/// Eyebrow `STEP X OF N` above a 4pt animated bar in clay-on-sunken.
class StepperHeader extends StatelessWidget {
  const StepperHeader({
    required this.currentStep,
    required this.totalSteps,
    this.barHeight = 4,
    this.semanticsLabelOverride,
    super.key,
  }) : assert(currentStep >= 1, 'currentStep is 1-indexed'),
       assert(
         currentStep <= totalSteps,
         'currentStep cannot exceed totalSteps',
       );

  final int currentStep;
  final int totalSteps;
  final double barHeight;
  final String? semanticsLabelOverride;

  @override
  Widget build(BuildContext context) {
    final progress = currentStep / totalSteps;
    final label = 'STEP $currentStep OF $totalSteps';

    return Semantics(
      label: semanticsLabelOverride ?? label,
      value: '${(progress * 100).round()} percent',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            label,
            style: AppTypography.labelSm.copyWith(color: AppColors.inkSoft),
          ),
          const SizedBox(height: AppSpacing.s2),
          ClipRRect(
            borderRadius: BorderRadius.circular(barHeight / 2),
            child: SizedBox(
              height: barHeight,
              child: ColoredBox(
                color: AppColors.bgSurfaceSunken,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TweenAnimationBuilder<double>(
                    duration: AppMotion.medium,
                    curve: AppMotion.curveMedium,
                    tween: Tween<double>(begin: 0, end: progress),
                    builder: (context, value, _) => FractionallySizedBox(
                      widthFactor: value.clamp(0, 1),
                      child: const ColoredBox(color: AppColors.accentClay),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
