import 'package:flutter/material.dart';

import 'package:rectify/data/models/match_strength.dart';
import 'package:rectify/theme/colors.dart';
import 'package:rectify/theme/typography.dart';

export 'package:rectify/data/models/match_strength.dart';

/// Visual descriptor for a [MatchStrength] level.
@immutable
class _MatchStrengthVisual {
  const _MatchStrengthVisual({
    required this.filled,
    required this.color,
    required this.label,
  });

  final int filled;
  final Color color;
  final String label;
}

const _visuals = <MatchStrength, _MatchStrengthVisual>{
  MatchStrength.strong: _MatchStrengthVisual(
    filled: 3,
    color: AppColors.confidenceStrong,
    label: 'STRONG',
  ),
  MatchStrength.moderate: _MatchStrengthVisual(
    filled: 2,
    color: AppColors.confidenceModerate,
    label: 'MODERATE',
  ),
  MatchStrength.weak: _MatchStrengthVisual(
    filled: 1,
    color: AppColors.confidenceWeak,
    label: 'WEAK',
  ),
  MatchStrength.none: _MatchStrengthVisual(
    filled: 0,
    color: AppColors.confidenceNone,
    label: 'NO MATCH',
  ),
};

/// Match-strength 4-dot indicator (`docs/design-system.md` §9.9).
///
/// 4 dots × 8pt with 4pt gaps, paired with the textual label to the
/// right at `type.label.sm`. The text pairing is non-negotiable per
/// the design-system accessibility rule: color carries ordering, the
/// label carries meaning.
class MatchStrengthDots extends StatelessWidget {
  const MatchStrengthDots({
    required this.strength,
    this.showLabel = true,
    this.dotSize = 8,
    this.gap = 4,
    super.key,
  });

  final MatchStrength strength;
  final bool showLabel;
  final double dotSize;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final visual = _visuals[strength]!;
    final dots = <Widget>[];
    for (var i = 0; i < 4; i++) {
      final filled = i < visual.filled;
      if (i > 0) dots.add(SizedBox(width: gap));
      dots.add(
        SizedBox(
          width: dotSize,
          height: dotSize,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: filled ? visual.color : Colors.transparent,
              border: filled ? null : Border.all(color: visual.color),
            ),
          ),
        ),
      );
    }

    return Semantics(
      label: 'Match strength ${visual.label.toLowerCase()}',
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ...dots,
          if (showLabel) ...<Widget>[
            const SizedBox(width: 10),
            Text(
              visual.label,
              style: AppTypography.labelSm.copyWith(color: visual.color),
            ),
          ],
        ],
      ),
    );
  }
}
