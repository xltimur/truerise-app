import 'package:flutter/material.dart';

import 'package:rectify/theme/colors.dart';
import 'package:rectify/theme/icons.dart';
import 'package:rectify/theme/motion.dart';
import 'package:rectify/theme/spacing.dart';
import 'package:rectify/theme/typography.dart';
import 'package:rectify/widgets/cards/app_card.dart';
import 'package:rectify/widgets/result/match_strength_dots.dart';

/// Evidence row card (`docs/design-system.md` §9.6 Variants — Evidence
/// Card; §10.3 Evidence breakdown).
///
/// Collapsed: icon + category + date + 4-dot strength + label.
/// Expanded: same row plus an explanation paragraph below in `body.md`.
/// Default expansion is controlled by [expanded]; the chevron toggles
/// internal state when [onToggleExpanded] is null, or delegates to it.
class EvidenceCard extends StatefulWidget {
  const EvidenceCard({
    required this.icon,
    required this.category,
    required this.date,
    required this.strength,
    this.explanation,
    this.expanded = false,
    this.onToggleExpanded,
    super.key,
  });

  final IconData icon;
  final String category;
  final String date;
  final MatchStrength strength;

  /// Body text shown when the card is expanded.
  /// Required when expansion is desired; absent → no toggle row.
  final String? explanation;

  /// Initial / forced expansion when [onToggleExpanded] is non-null.
  final bool expanded;

  final VoidCallback? onToggleExpanded;

  @override
  State<EvidenceCard> createState() => _EvidenceCardState();
}

class _EvidenceCardState extends State<EvidenceCard> {
  late bool _internalExpanded = widget.expanded;

  bool get _effectiveExpanded =>
      widget.onToggleExpanded == null ? _internalExpanded : widget.expanded;

  void _toggle() {
    if (widget.onToggleExpanded != null) {
      widget.onToggleExpanded!();
    } else {
      setState(() => _internalExpanded = !_internalExpanded);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasExplanation = widget.explanation != null;
    final useSunken = widget.strength == MatchStrength.none;

    return AppCard(
      backgroundColor: useSunken ? AppColors.bgSurfaceSunken : null,
      onTap: hasExplanation ? _toggle : null,
      semanticsLabel:
          '${widget.category}, ${widget.date}, '
          'match ${widget.strength.tag.replaceAll('_', ' ')}',
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
              Icon(widget.icon, size: 20, color: AppColors.inkMuted),
              const SizedBox(width: AppSpacing.s3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(widget.category, style: AppTypography.titleSm),
                    const SizedBox(height: 2),
                    Text(
                      widget.date,
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.inkSoft,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.s2),
              MatchStrengthDots(strength: widget.strength),
              if (hasExplanation) ...<Widget>[
                const SizedBox(width: AppSpacing.s2),
                AnimatedRotation(
                  duration: AppMotion.short,
                  turns: _effectiveExpanded ? 0.25 : 0,
                  child: const Icon(
                    AppIcons.forward,
                    size: 20,
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
            ],
          ),
          if (hasExplanation && _effectiveExpanded) ...<Widget>[
            const SizedBox(height: AppSpacing.s3),
            Text(widget.explanation!, style: AppTypography.bodyMd),
          ],
        ],
      ),
    );
  }
}
