import 'package:flutter/material.dart';

import 'package:rectify/theme/colors.dart';
import 'package:rectify/theme/spacing.dart';
import 'package:rectify/theme/typography.dart';
import 'package:rectify/widgets/cards/app_card.dart';
import 'package:rectify/widgets/chips/demo_pill.dart';
import 'package:rectify/widgets/result/confidence_bar.dart';

/// History row card (`docs/design-system.md` §9.6 Variants — History Card).
///
/// Label + date eyebrow, large time row, confidence bar, rising-sign
/// caption. If [isDemo] is `true`, a DEMO pill renders in the eyebrow.
class HistoryCard extends StatelessWidget {
  const HistoryCard({
    required this.label,
    required this.date,
    required this.time,
    required this.meridiem,
    required this.risingSign,
    required this.confidence,
    this.isDemo = false,
    this.onTap,
    super.key,
  }) : assert(
         confidence >= 0 && confidence <= 1,
         'HistoryCard.confidence must be in [0, 1]',
       );

  final String label;
  final String date;
  final String time;
  final String meridiem;
  final String risingSign;
  final double confidence;
  final bool isDemo;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      semanticsLabel:
          '$label, $date, $time${meridiem.isEmpty ? '' : ' $meridiem'} '
          '$risingSign, confidence ${(confidence * 100).round()} percent'
          '${isDemo ? ", demo" : ""}',
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.s4,
        horizontal: AppSpacing.s5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.titleSm,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isDemo) ...<Widget>[
                const SizedBox(width: AppSpacing.s2),
                const DemoPill(),
              ],
            ],
          ),
          const SizedBox(height: 2),
          Text(
            date,
            style: AppTypography.bodySm.copyWith(color: AppColors.inkSoft),
          ),
          const SizedBox(height: 12),
          Text.rich(
            TextSpan(
              style: AppTypography.displayMd.copyWith(
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
          const SizedBox(height: 8),
          ConfidenceBar(value: confidence),
          const SizedBox(height: 8),
          Text(
            risingSign,
            style: AppTypography.bodySm.copyWith(color: AppColors.inkSoft),
          ),
        ],
      ),
    );
  }
}
