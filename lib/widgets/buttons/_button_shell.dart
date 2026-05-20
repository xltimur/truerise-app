import 'package:flutter/material.dart';

import 'package:rectify/theme/colors.dart';
import 'package:rectify/theme/motion.dart';
import 'package:rectify/theme/radius.dart';
import 'package:rectify/theme/spacing.dart';
import 'package:rectify/theme/typography.dart';

/// Visual variant for the shared button shell.
enum RectifyButtonVariant { primary, secondary, ghost, destructive }

/// Internal pressable surface shared by all Rectify buttons
/// (`docs/design-system.md` §9.1).
///
/// Each public button wrapper (`PrimaryButton`, `SecondaryButton`,
/// `GhostButton`, `DestructiveButton`) chooses a variant; the shell
/// resolves background / border / text colors and pressed/disabled
/// states from theme tokens.
class RectifyButtonShell extends StatefulWidget {
  const RectifyButtonShell({
    required this.label,
    required this.variant,
    this.onPressed,
    this.icon,
    this.expand = false,
    super.key,
  });

  final String label;
  final RectifyButtonVariant variant;
  final VoidCallback? onPressed;
  final IconData? icon;

  /// When `true`, the button expands to fill its parent width.
  /// Bottom-fixed CTAs (`§10.1`) use this; inline ghost buttons do not.
  final bool expand;

  @override
  State<RectifyButtonShell> createState() => _RectifyButtonShellState();
}

class _RectifyButtonShellState extends State<RectifyButtonShell> {
  bool _pressed = false;

  bool get _enabled => widget.onPressed != null;

  double get _height => switch (widget.variant) {
    RectifyButtonVariant.ghost => 44,
    _ => 52,
  };

  Color _resolveBackground(BuildContext context) {
    if (!_enabled) {
      switch (widget.variant) {
        case RectifyButtonVariant.primary:
          return AppColors.accentClay.withValues(alpha: 0.4);
        case RectifyButtonVariant.secondary:
          return AppColors.bgSurface;
        case RectifyButtonVariant.destructive:
          return AppColors.bgSurface;
        case RectifyButtonVariant.ghost:
          return Colors.transparent;
      }
    }
    switch (widget.variant) {
      case RectifyButtonVariant.primary:
        return _pressed ? AppColors.accentClayHover : AppColors.accentClay;
      case RectifyButtonVariant.secondary:
        return _pressed ? AppColors.bgSurfaceSunken : AppColors.bgSurface;
      case RectifyButtonVariant.destructive:
        return _pressed
            ? AppColors.statusDanger.withValues(alpha: 0.08)
            : AppColors.bgSurface;
      case RectifyButtonVariant.ghost:
        return Colors.transparent;
    }
  }

  Color _resolveForeground() {
    switch (widget.variant) {
      case RectifyButtonVariant.primary:
        return _enabled
            ? AppColors.bgApp
            : AppColors.bgApp.withValues(alpha: 0.6);
      case RectifyButtonVariant.secondary:
        return _enabled ? AppColors.inkStrong : AppColors.inkFaint;
      case RectifyButtonVariant.ghost:
        return _enabled ? AppColors.accentClayDeep : AppColors.inkFaint;
      case RectifyButtonVariant.destructive:
        return _enabled
            ? AppColors.statusDanger
            : AppColors.statusDanger.withValues(alpha: 0.4);
    }
  }

  BorderSide? _resolveBorder() {
    switch (widget.variant) {
      case RectifyButtonVariant.primary:
      case RectifyButtonVariant.ghost:
        return null;
      case RectifyButtonVariant.secondary:
        return const BorderSide(color: AppColors.inkLine);
      case RectifyButtonVariant.destructive:
        return BorderSide(
          color: AppColors.statusDanger.withValues(alpha: 0.4),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final foreground = _resolveForeground();
    final labelStyle = AppTypography.labelMd.copyWith(
      color: foreground,
      fontWeight: FontWeight.w600,
    );

    final border = _resolveBorder();
    final decoration = BoxDecoration(
      color: _resolveBackground(context),
      borderRadius: AppRadius.brSm,
      border: border == null ? null : Border.fromBorderSide(border),
    );

    final content = Row(
      mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (widget.icon != null) ...<Widget>[
          Icon(widget.icon, size: 20, color: foreground),
          const SizedBox(width: AppSpacing.s2),
        ],
        Flexible(
          child: Text(
            widget.label,
            style: labelStyle,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );

    final padding = EdgeInsets.symmetric(
      vertical: AppSpacing.s4,
      horizontal: widget.variant == RectifyButtonVariant.ghost
          ? AppSpacing.s4
          : AppSpacing.s6,
    );

    final button = Semantics(
      button: true,
      enabled: _enabled,
      label: widget.label,
      child: AnimatedContainer(
        duration: AppMotion.short,
        curve: AppMotion.curveShort,
        constraints: BoxConstraints(minHeight: _height),
        decoration: decoration,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: AppRadius.brSm,
            onTap: widget.onPressed,
            onHighlightChanged: (value) {
              if (mounted) setState(() => _pressed = value);
            },
            child: Padding(
              padding: padding,
              child: Center(child: content),
            ),
          ),
        ),
      ),
    );

    if (widget.expand) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }
}
