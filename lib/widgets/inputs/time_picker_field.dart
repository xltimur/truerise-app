import 'package:flutter/material.dart';

import 'package:rectify/theme/colors.dart';
import 'package:rectify/theme/icons.dart';
import 'package:rectify/theme/typography.dart';
import 'package:rectify/widgets/inputs/_input_shell.dart';

/// Read-only input that triggers a time picker
/// (`docs/design-system.md` §9.2 / §11.2).
///
/// Mirrors `DatePickerField` in structure; the value contract is the
/// already-formatted time string in [formattedValue]. Formatting
/// (12h/24h, locale) is the caller's responsibility.
class TimePickerField extends StatelessWidget {
  const TimePickerField({
    required this.label,
    this.formattedValue,
    this.placeholder,
    this.helperText,
    this.errorText,
    this.onTap,
    this.enabled = true,
    this.semanticsLabel,
    super.key,
  });

  final String label;
  final String? formattedValue;
  final String? placeholder;
  final String? helperText;
  final String? errorText;
  final VoidCallback? onTap;
  final bool enabled;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final disabled = !enabled || onTap == null;
    final hasValue = formattedValue != null && formattedValue!.isNotEmpty;

    var state = InputFieldState.idle;
    if (disabled) {
      state = InputFieldState.disabled;
    } else if (errorText != null) {
      state = InputFieldState.error;
    }

    final textStyle = AppTypography.bodyLg.copyWith(
      color: hasValue
          ? (disabled ? AppColors.inkFaint : AppColors.inkStrong)
          : AppColors.inkFaint,
    );

    return Semantics(
      button: true,
      enabled: !disabled,
      label:
          semanticsLabel ?? '$label, ${hasValue ? formattedValue! : 'not set'}',
      excludeSemantics: true,
      child: InkWell(
        onTap: disabled ? null : onTap,
        borderRadius: BorderRadius.zero,
        child: InputShell(
          label: label,
          state: state,
          helperText: helperText,
          errorText: errorText,
          trailing: Icon(
            AppIcons.forward,
            size: 20,
            color: disabled ? AppColors.inkFaint : AppColors.inkMuted,
          ),
          child: Text(
            hasValue ? formattedValue! : (placeholder ?? ''),
            style: textStyle,
          ),
        ),
      ),
    );
  }
}
