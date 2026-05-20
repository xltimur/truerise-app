import 'package:flutter/material.dart';

import 'package:rectify/theme/colors.dart';
import 'package:rectify/theme/typography.dart';

/// Labelled on/off switch (`docs/design-system.md` §9.4).
///
/// Renders `label` (with optional `helperText` underneath) on the left
/// and an adaptive [Switch] on the right. Track turns clay when on,
/// stays `bg.surface.sunken` when off; thumb is `bg.surface` in both.
/// Whole row is tappable to satisfy the 44pt target.
class LabeledToggle extends StatelessWidget {
  const LabeledToggle({
    required this.label,
    required this.value,
    required this.onChanged,
    this.helperText,
    super.key,
  });

  final String label;
  final String? helperText;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final disabled = onChanged == null;
    return Semantics(
      toggled: value,
      enabled: !disabled,
      label: label,
      excludeSemantics: true,
      child: InkWell(
        onTap: disabled ? null : () => onChanged!(!value),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 56),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(label, style: AppTypography.bodyMd),
                      if (helperText != null) ...<Widget>[
                        const SizedBox(height: 2),
                        Text(
                          helperText!,
                          style: AppTypography.bodySm.copyWith(
                            color: AppColors.inkSoft,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Switch.adaptive(
                  value: value,
                  onChanged: onChanged,
                  activeThumbColor: AppColors.bgSurface,
                  activeTrackColor: AppColors.accentClay,
                  inactiveThumbColor: AppColors.bgSurface,
                  inactiveTrackColor: AppColors.bgSurfaceSunken,
                  trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((
                    states,
                  ) {
                    if (states.contains(WidgetState.selected)) {
                      return AppColors.accentClay;
                    }
                    return AppColors.inkLine;
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
