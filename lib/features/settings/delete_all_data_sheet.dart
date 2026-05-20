import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rectify/features/home/history_providers.dart';
import 'package:rectify/providers/settings_controller.dart';
import 'package:rectify/theme/colors.dart';
import 'package:rectify/theme/radius.dart';
import 'package:rectify/theme/spacing.dart';
import 'package:rectify/theme/typography.dart';
import 'package:rectify/widgets/buttons/buttons.dart';

/// "Delete all data" confirmation sheet (`docs/ascii-wireframes.md`
/// Screen 9 notes, `docs/mvp-scope.md` AC8, `docs/implementation-plan.md`
/// §8.5).
///
/// Reads the current saved-calculation count off [historyStreamProvider]
/// so the copy is exact ("X calculations") when the stream has emitted,
/// and falls back to the safe generic message when it hasn't. The
/// destructive action goes through [SettingsController.deleteAllData],
/// which wipes Drift, prefs, and secure storage in one call.
class DeleteAllDataSheet extends ConsumerStatefulWidget {
  const DeleteAllDataSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => const DeleteAllDataSheet(),
    );
  }

  @override
  ConsumerState<DeleteAllDataSheet> createState() => _DeleteAllDataSheetState();
}

class _DeleteAllDataSheetState extends ConsumerState<DeleteAllDataSheet> {
  bool _busy = false;

  Future<void> _confirm() async {
    if (_busy) return;
    setState(() => _busy = true);
    final notifier = ref.read(settingsControllerProvider.notifier);
    final messenger = ScaffoldMessenger.of(context);
    final outcome = await notifier.deleteAllData();
    if (!mounted) return;
    Navigator.of(context).pop();
    if (outcome.isErr) {
      messenger.showSnackBar(
        const SnackBar(content: Text("Couldn't delete data. Try again.")),
      );
    }
    // Success: router will redirect to /onboarding once onboardingDone
    // flips back to false, so no toast is needed.
  }

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(historyStreamProvider);
    final count = historyAsync.maybeWhen(
      data: (items) => items.length,
      orElse: () => null,
    );

    final copy = count == null
        ? 'This will permanently delete every calculation, event, and '
              'setting on this device. Cannot be undone.'
        : 'This will permanently delete ${_pluralize(count)} and every '
              'saved event and setting on this device. Cannot be undone.';

    return ClipRRect(
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
              AppSpacing.s6,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.inkLine,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.s4),
                Text(
                  'Delete all data?',
                  style: AppTypography.titleMd,
                ),
                const SizedBox(height: AppSpacing.s2),
                Text(
                  copy,
                  style: AppTypography.bodyMd.copyWith(
                    color: AppColors.inkBody,
                  ),
                ),
                const SizedBox(height: AppSpacing.s5),
                DestructiveButton(
                  label: 'Delete',
                  onPressed: _busy ? null : _confirm,
                ),
                const SizedBox(height: AppSpacing.s3),
                SecondaryButton(
                  label: 'Cancel',
                  onPressed: _busy ? null : () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _pluralize(int count) =>
      count == 1 ? '1 calculation' : '$count calculations';
}
