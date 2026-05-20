import 'package:flutter/material.dart';

import 'package:rectify/theme/colors.dart';
import 'package:rectify/theme/icons.dart';
import 'package:rectify/theme/spacing.dart';
import 'package:rectify/theme/typography.dart';

/// Top navigation bar (`docs/design-system.md` §9.17).
///
/// 44pt + safe area, `bg.app` background, no AppBar shadow.
/// Title at `type.title.md`, left-aligned after a 24pt gutter.
/// Optional left-side back chevron and right-side icon button.
/// Per §9.17 the 1pt `ink.line.soft` rule beneath the title row
/// belongs to the page body, not the nav itself, so this widget
/// renders only the 44pt title row.
class TopNav extends StatelessWidget implements PreferredSizeWidget {
  const TopNav({
    required this.title,
    this.onBack,
    this.trailingIcon,
    this.trailingSemanticsLabel,
    this.onTrailingTap,
    super.key,
  });

  final String title;
  final VoidCallback? onBack;
  final IconData? trailingIcon;
  final String? trailingSemanticsLabel;
  final VoidCallback? onTrailingTap;

  @override
  Size get preferredSize => const Size.fromHeight(44);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: ColoredBox(
        color: AppColors.bgApp,
        child: SafeArea(
          bottom: false,
          child: SizedBox(
            height: 44,
            child: Row(
              children: <Widget>[
                if (onBack != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: IconButton(
                      icon: const Icon(
                        AppIcons.back,
                        color: AppColors.inkStrong,
                      ),
                      tooltip: 'Back',
                      iconSize: 24,
                      splashRadius: 22,
                      onPressed: onBack,
                    ),
                  )
                else
                  const SizedBox(width: AppSpacing.screenEdge),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.titleMd,
                  ),
                ),
                if (trailingIcon != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: IconButton(
                      icon: Icon(
                        trailingIcon,
                        color: AppColors.inkStrong,
                      ),
                      tooltip: trailingSemanticsLabel,
                      iconSize: 24,
                      splashRadius: 22,
                      onPressed: onTrailingTap,
                    ),
                  )
                else
                  const SizedBox(width: AppSpacing.screenEdge),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
