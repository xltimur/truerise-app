import 'package:flutter/material.dart';

import 'package:rectify/theme/colors.dart';
import 'package:rectify/theme/typography.dart';

/// Confidence percentage bar (`docs/design-system.md` §9.8).
///
/// Horizontal 8pt track filled left-to-right. Fill color picks from
/// `confidence.bar.high/mid/low` by [value] band. A tabular-figure
/// percentage sits to the right; semantics announces
/// "Confidence — NN percent" so screen readers don't read the bar
/// pictographically.
class ConfidenceBar extends StatelessWidget {
  const ConfidenceBar({
    required this.value,
    this.height = 8,
    this.label = 'Confidence',
    super.key,
  }) : assert(
         value >= 0 && value <= 1,
         'ConfidenceBar.value must be in [0, 1]',
       );

  /// 0..1 — the bar fill ratio.
  final double value;

  /// Track height in logical points. Default 8pt.
  final double height;

  /// Optional override for the accessibility label prefix.
  final String label;

  Color _fillColor() {
    final percent = value * 100;
    if (percent >= 70) return AppColors.confidenceBarHigh;
    if (percent >= 40) return AppColors.confidenceBarMid;
    return AppColors.confidenceBarLow;
  }

  @override
  Widget build(BuildContext context) {
    final percent = (value * 100).round();
    final percentText = '$percent%';

    return Semantics(
      label: '$label — $percent percent',
      excludeSemantics: true,
      child: Row(
        children: <Widget>[
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(height / 2),
              child: SizedBox(
                height: height,
                child: ColoredBox(
                  color: AppColors.bgSurfaceSunken,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: value.clamp(0, 1),
                      child: ColoredBox(color: _fillColor()),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            percentText,
            style: AppTypography.titleSm.copyWith(
              fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
