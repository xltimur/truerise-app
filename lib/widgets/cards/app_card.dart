import 'package:flutter/material.dart';

import 'package:rectify/theme/colors.dart';
import 'package:rectify/theme/radius.dart';
import 'package:rectify/theme/spacing.dart';

/// Base card surface (`docs/design-system.md` §9.6).
///
/// `bg.surface` with a 1pt `ink.line` border, `radius.md`, default
/// inner padding 20pt (`space.5`). The product favours border-led
/// containers over shadow elevation, so no drop shadow renders by
/// default.
class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.s5),
    this.onTap,
    this.semanticsLabel,
    this.borderColor,
    this.backgroundColor,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final String? semanticsLabel;
  final Color? borderColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final surface = backgroundColor ?? AppColors.bgSurface;
    final border = borderColor ?? AppColors.inkLine;

    final decoration = BoxDecoration(
      color: surface,
      borderRadius: AppRadius.brMd,
      border: Border.all(color: border),
    );

    Widget content = Padding(padding: padding, child: child);

    if (onTap != null) {
      content = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.brMd,
          child: content,
        ),
      );
    }

    final card = DecoratedBox(decoration: decoration, child: content);
    return semanticsLabel == null
        ? card
        : Semantics(label: semanticsLabel, container: true, child: card);
  }
}
