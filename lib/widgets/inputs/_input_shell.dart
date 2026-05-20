import 'package:flutter/material.dart';

import 'package:rectify/theme/colors.dart';
import 'package:rectify/theme/motion.dart';
import 'package:rectify/theme/radius.dart';
import 'package:rectify/theme/spacing.dart';
import 'package:rectify/theme/typography.dart';

/// Visual states the input chrome can render
/// (`docs/design-system.md` §9.2).
enum InputFieldState { idle, focused, error, disabled }

/// Renders a labelled field with the Rectify input chrome
/// (52pt min height, 14h/16v inner padding, hairline ink border,
/// clay focus ring, danger error ring).
///
/// Used by `InputField`, `DatePickerField`, and `TimePickerField`
/// so the visual contract for "the box the user sees" is defined in
/// one place.
class InputShell extends StatelessWidget {
  const InputShell({
    required this.label,
    required this.state,
    required this.child,
    this.helperText,
    this.errorText,
    this.trailing,
    this.leading,
    this.semanticsLabel,
    super.key,
  });

  final String label;
  final InputFieldState state;
  final Widget child;
  final Widget? trailing;
  final Widget? leading;
  final String? helperText;
  final String? errorText;

  /// Overrides the announced label. Defaults to [label] when null.
  final String? semanticsLabel;

  Color get _borderColor {
    switch (state) {
      case InputFieldState.idle:
      case InputFieldState.disabled:
        return AppColors.inkLine;
      case InputFieldState.focused:
        return AppColors.accentClayLine;
      case InputFieldState.error:
        return AppColors.statusDanger;
    }
  }

  double get _borderWidth {
    switch (state) {
      case InputFieldState.idle:
      case InputFieldState.disabled:
        return 1;
      case InputFieldState.focused:
      case InputFieldState.error:
        return 1.5;
    }
  }

  Color get _backgroundColor {
    return state == InputFieldState.disabled
        ? AppColors.bgSurfaceSunken
        : AppColors.bgSurface;
  }

  Color get _helperColor {
    switch (state) {
      case InputFieldState.focused:
        return AppColors.accentClayDeep;
      case InputFieldState.error:
        return AppColors.statusDanger;
      case InputFieldState.idle:
      case InputFieldState.disabled:
        return AppColors.inkSoft;
    }
  }

  @override
  Widget build(BuildContext context) {
    final helper = errorText ?? helperText;

    return Semantics(
      label: semanticsLabel ?? label,
      textField: true,
      enabled: state != InputFieldState.disabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.s2),
            child: Text(
              label,
              style: AppTypography.labelMd.copyWith(color: AppColors.inkMuted),
            ),
          ),
          AnimatedContainer(
            duration: AppMotion.short,
            curve: AppMotion.curveShort,
            constraints: const BoxConstraints(minHeight: 52),
            decoration: BoxDecoration(
              color: _backgroundColor,
              borderRadius: AppRadius.brSm,
              border: Border.all(color: _borderColor, width: _borderWidth),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s4,
              vertical: 14,
            ),
            child: Row(
              children: <Widget>[
                if (leading != null) ...<Widget>[
                  leading!,
                  const SizedBox(width: AppSpacing.s2),
                ],
                Expanded(child: child),
                if (trailing != null) ...<Widget>[
                  const SizedBox(width: AppSpacing.s2),
                  trailing!,
                ],
              ],
            ),
          ),
          if (helper != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                helper,
                style: AppTypography.bodySm.copyWith(color: _helperColor),
              ),
            ),
        ],
      ),
    );
  }
}
