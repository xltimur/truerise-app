import 'package:flutter/material.dart';

import 'package:rectify/theme/colors.dart';
import 'package:rectify/theme/spacing.dart';
import 'package:rectify/theme/typography.dart';
import 'package:rectify/widgets/cards/app_card.dart';
import 'package:rectify/widgets/result/confidence_bar.dart';

/// Candidate row card shown beneath the hero result
/// (`docs/design-system.md` §9.6 Variants — Candidate Card).
///
/// Single row: time + meridiem (mono numerals + serif suffix),
/// rising sign caption, and a confidence bar at the trailing edge.
class CandidateCard extends StatelessWidget {
  const CandidateCard({
    required this.time,
    required this.meridiem,
    required this.risingSign,
    required this.confidence,
    this.onTap,
    super.key,
  }) : assert(
         confidence >= 0 && confidence <= 1,
         'CandidateCard.confidence must be in [0, 1]',
       );

  final String time;
  final String meridiem;
  final String risingSign;
  final double confidence;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      semanticsLabel:
          'Candidate $time${meridiem.isEmpty ? '' : ' $meridiem'}, '
          '$risingSign, confidence ${(confidence * 100).round()} percent',
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.s4,
        horizontal: AppSpacing.s5,
      ),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text.rich(
                TextSpan(
                  style: AppTypography.titleLg.copyWith(
                    fontFeatures: const <FontFeature>[
                      FontFeature.tabularFigures(),
                    ],
                  ),
                  children: <InlineSpan>[
                    TextSpan(text: time),
                    if (meridiem.isNotEmpty)
                      TextSpan(
                        text: ' $meridiem',
                        style: AppTypography.titleMd.copyWith(
                          color: AppColors.inkBody,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                risingSign,
                style: AppTypography.bodySm.copyWith(color: AppColors.inkSoft),
              ),
            ],
          ),
          const SizedBox(width: AppSpacing.s4),
          Expanded(child: ConfidenceBar(value: confidence)),
        ],
      ),
    );
  }
}
