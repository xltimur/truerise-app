import 'package:flutter/material.dart';

import 'package:rectify/theme/colors.dart';
import 'package:rectify/theme/radius.dart';
import 'package:rectify/theme/typography.dart';

/// Visual variant for [ChipPill] (`docs/design-system.md` §9.5).
enum ChipPillVariant { defaultStyle, selected, status }

/// Small label pill (`docs/design-system.md` §9.5).
///
/// 28pt tall, 12h/6v padding, `radius.xs`. Default sits on
/// `bg.surface.sunken`; selected uses the soft clay tint; status uses
/// the deep midnight surface (this is what the DEMO pill rides on).
class ChipPill extends StatelessWidget {
  const ChipPill({
    required this.label,
    this.variant = ChipPillVariant.defaultStyle,
    this.icon,
    this.onTap,
    this.semanticsLabel,
    super.key,
  });

  final String label;
  final ChipPillVariant variant;
  final IconData? icon;
  final VoidCallback? onTap;
  final String? semanticsLabel;

  Color get _backgroundColor {
    switch (variant) {
      case ChipPillVariant.defaultStyle:
        return AppColors.bgSurfaceSunken;
      case ChipPillVariant.selected:
        return AppColors.accentClayTint;
      case ChipPillVariant.status:
        return AppColors.deepMidnight;
    }
  }

  Color get _foregroundColor {
    switch (variant) {
      case ChipPillVariant.defaultStyle:
        return AppColors.inkMuted;
      case ChipPillVariant.selected:
        return AppColors.accentClayDeep;
      case ChipPillVariant.status:
        return AppColors.bgApp;
    }
  }

  BoxBorder? get _border {
    return variant == ChipPillVariant.defaultStyle
        ? Border.all(color: AppColors.inkLine)
        : null;
  }

  @override
  Widget build(BuildContext context) {
    final content = Container(
      constraints: const BoxConstraints(minHeight: 28),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: AppRadius.brXs,
        border: _border,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (icon != null) ...<Widget>[
            Icon(icon, size: 14, color: _foregroundColor),
            const SizedBox(width: 6),
          ],
          Text(
            label.toUpperCase(),
            style: AppTypography.labelSm.copyWith(color: _foregroundColor),
          ),
        ],
      ),
    );

    return Semantics(
      label: semanticsLabel ?? label,
      button: onTap != null,
      selected: variant == ChipPillVariant.selected,
      excludeSemantics: true,
      child: onTap == null
          ? content
          : Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: AppRadius.brXs,
                onTap: onTap,
                child: content,
              ),
            ),
    );
  }
}
