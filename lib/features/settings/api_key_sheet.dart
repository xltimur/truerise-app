import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rectify/providers/settings_controller.dart';
import 'package:rectify/theme/colors.dart';
import 'package:rectify/theme/radius.dart';
import 'package:rectify/theme/spacing.dart';
import 'package:rectify/theme/typography.dart';
import 'package:rectify/widgets/buttons/buttons.dart';
import 'package:rectify/widgets/inputs/inputs.dart';

// `SecureKeyStore` is referenced in the class dartdoc below for
// orientation but isn't imported here (the sheet only talks to it via
// `SettingsController`).
// ignore_for_file: comment_references

/// Bottom-sheet editor for the user-supplied Pro / Developer key
/// (`docs/ascii-wireframes.md` Screen 9 notes; `docs/mvp-scope.md` M11
/// + AC4; `docs/implementation-plan.md` §9.5).
///
/// Save writes through [SettingsController.setProApiKey] which routes
/// the value to [SecureKeyStore] only — never SQLite, SharedPreferences,
/// logs, or any model field. The sheet never displays the stored value;
/// when a key already exists the field opens empty with a "Currently
/// set" hint, and tapping "Remove key" clears secure storage and the
/// configured flag in a single action.
class ApiKeySheet extends ConsumerStatefulWidget {
  const ApiKeySheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        final inset = MediaQuery.viewInsetsOf(sheetContext).bottom;
        return Padding(
          padding: EdgeInsets.only(bottom: inset),
          child: const ApiKeySheet(),
        );
      },
    );
  }

  @override
  ConsumerState<ApiKeySheet> createState() => _ApiKeySheetState();
}

class _ApiKeySheetState extends ConsumerState<ApiKeySheet> {
  late final TextEditingController _controller;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    // The field deliberately opens empty even when a key is already
    // saved — the stored value is never read back into the UI per
    // §9.5 ("never displayed after save").
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final value = _controller.text.trim();
    if (value.isEmpty || _busy) return;
    setState(() => _busy = true);
    final notifier = ref.read(settingsControllerProvider.notifier);
    final messenger = ScaffoldMessenger.of(context);
    await notifier.setProApiKey(value);
    // Wipe the controller before popping so the secret cannot linger
    // in widget state across rebuilds.
    _controller.clear();
    if (!mounted) return;
    Navigator.of(context).pop();
    messenger.showSnackBar(const SnackBar(content: Text('API key saved.')));
  }

  Future<void> _remove() async {
    if (_busy) return;
    setState(() => _busy = true);
    final notifier = ref.read(settingsControllerProvider.notifier);
    final messenger = ScaffoldMessenger.of(context);
    await notifier.clearProApiKey();
    _controller.clear();
    if (!mounted) return;
    Navigator.of(context).pop();
    messenger.showSnackBar(const SnackBar(content: Text('API key removed.')));
  }

  @override
  Widget build(BuildContext context) {
    final configured = ref.watch(
      settingsControllerProvider.select((s) => s.proApiKeyConfigured),
    );

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
                  'API Key (Pro / Developer)',
                  style: AppTypography.titleMd,
                ),
                const SizedBox(height: AppSpacing.s2),
                Text(
                  'Paste your provider key to switch off the standard '
                  'proxied path. The key is stored on this device only.',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.inkSoft,
                  ),
                ),
                const SizedBox(height: AppSpacing.s5),
                InputField(
                  label: 'API key',
                  controller: _controller,
                  hintText: configured
                      ? 'Currently set — enter a new key to replace it'
                      : 'sk-…',
                  obscureText: true,
                  autofocus: true,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _save(),
                ),
                const SizedBox(height: AppSpacing.s5),
                PrimaryButton(
                  label: 'Save key',
                  onPressed: _busy ? null : _save,
                ),
                const SizedBox(height: AppSpacing.s3),
                if (configured)
                  DestructiveButton(
                    label: 'Remove key',
                    onPressed: _busy ? null : _remove,
                  )
                else
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
}
