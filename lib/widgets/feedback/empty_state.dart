import 'package:flutter/material.dart';

import 'package:rectify/theme/colors.dart';
import 'package:rectify/theme/spacing.dart';
import 'package:rectify/theme/typography.dart';

/// Empty-state surface (`docs/design-system.md` §9.14).
///
/// 96pt vertical padding from available top, 48pt monochrome glyph
/// in `ink.soft`, title (`type.title.md`), body (`type.body.md`,
/// max 280pt width, centered), and an optional centered CTA.
class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.title,
    required this.body,
    this.icon,
    this.cta,
    super.key,
  });

  /// Optional centered glyph. 48pt at `ink.soft`. If null, the heading
  /// floats without a glyph above it (still respects the 96pt top pad).
  final IconData? icon;

  final String title;
  final String body;

  /// Centered call-to-action; pass a Rectify button widget.
  final Widget? cta;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$title. $body',
      container: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 96),
            if (icon != null) ...<Widget>[
              Icon(icon, size: 48, color: AppColors.inkSoft),
              const SizedBox(height: AppSpacing.s6),
            ],
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTypography.titleMd,
            ),
            const SizedBox(height: AppSpacing.s2),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 280),
              child: Text(
                body,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMd.copyWith(color: AppColors.inkBody),
              ),
            ),
            if (cta != null) ...<Widget>[
              const SizedBox(height: AppSpacing.s6),
              cta!,
            ],
          ],
        ),
      ),
    );
  }
}
