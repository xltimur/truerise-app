import 'package:flutter/material.dart';

import 'package:rectify/theme/colors.dart';
import 'package:rectify/theme/icons.dart';
import 'package:rectify/theme/radius.dart';
import 'package:rectify/theme/spacing.dart';
import 'package:rectify/theme/typography.dart';

/// One row in a [BottomSheetPicker].
@immutable
class BottomSheetOption<T> {
  const BottomSheetOption({required this.value, required this.label});

  final T value;
  final String label;
}

/// Bottom-sheet single-select picker
/// (`docs/design-system.md` §9.12 + §10.5).
///
/// Provides the sheet chrome (rounded top, drag handle, padding,
/// title) and a vertical list of 56pt rows separated by
/// `ink.line.soft` dividers. A ✓ mark renders in clay against the
/// currently selected row.
///
/// Call [show] to present it via `showModalBottomSheet`. The widget
/// can also be embedded directly (useful for the widget gallery).
class BottomSheetPicker<T> extends StatelessWidget {
  const BottomSheetPicker({
    required this.title,
    required this.options,
    required this.value,
    required this.onSelected,
    this.showDragHandle = true,
    super.key,
  });

  final String title;
  final List<BottomSheetOption<T>> options;
  final T value;
  final ValueChanged<T> onSelected;
  final bool showDragHandle;

  /// Convenience to show this picker as a modal bottom sheet.
  /// Returns the selected value, or `null` if dismissed without a tap.
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required List<BottomSheetOption<T>> options,
    required T value,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => BottomSheetPicker<T>(
        title: title,
        options: options,
        value: value,
        onSelected: (selected) => Navigator.of(sheetContext).pop(selected),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: title,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: AppRadius.lg),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.bgSurface,
            borderRadius: BorderRadius.vertical(top: AppRadius.lg),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.s6,
                AppSpacing.s4,
                AppSpacing.s6,
                AppSpacing.s7,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  if (showDragHandle)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.s2),
                      child: Center(
                        child: Container(
                          width: 36,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.inkLine,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  Text(title, style: AppTypography.titleMd),
                  const SizedBox(height: AppSpacing.s2),
                  for (var i = 0; i < options.length; i++) ...<Widget>[
                    _Row<T>(
                      option: options[i],
                      selected: options[i].value == value,
                      onTap: () => onSelected(options[i].value),
                    ),
                    if (i < options.length - 1)
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.inkLineSoft,
                      ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Row<T> extends StatelessWidget {
  const _Row({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final BottomSheetOption<T> option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      button: true,
      label: option.label,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 56,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(option.label, style: AppTypography.bodyLg),
              ),
              if (selected)
                const Icon(
                  AppIcons.check,
                  size: 20,
                  color: AppColors.accentClay,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
