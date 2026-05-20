import 'package:flutter/material.dart';

import 'package:rectify/theme/colors.dart';
import 'package:rectify/theme/icons.dart';
import 'package:rectify/theme/spacing.dart';
import 'package:rectify/theme/typography.dart';
import 'package:rectify/widgets/cards/app_card.dart';

/// Life-event row card used in the Life Events Input screen
/// (`docs/design-system.md` §9.6, §11.4).
///
/// Left icon column (32pt), content column (category + date), right
/// delete affordance (32pt). Whole card is a single tappable target
/// when [onTap] is non-null; the delete icon is its own button when
/// [onDelete] is non-null.
class EventCard extends StatelessWidget {
  const EventCard({
    required this.icon,
    required this.category,
    required this.date,
    this.onTap,
    this.onDelete,
    super.key,
  });

  final IconData icon;
  final String category;
  final String date;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      semanticsLabel: 'Event: $category on $date',
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.s4,
        horizontal: AppSpacing.s5,
      ),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 32,
            child: Icon(icon, size: 24, color: AppColors.inkMuted),
          ),
          const SizedBox(width: AppSpacing.s2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  category,
                  style: AppTypography.titleSm,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  date,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.inkSoft,
                  ),
                ),
              ],
            ),
          ),
          if (onDelete != null)
            SizedBox(
              width: 32,
              height: 32,
              child: Semantics(
                button: true,
                label: 'Delete event $category',
                excludeSemantics: true,
                child: IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  iconSize: 20,
                  splashRadius: 18,
                  icon: const Icon(AppIcons.close, color: AppColors.inkMuted),
                  onPressed: onDelete,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
