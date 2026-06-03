import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rectify/app/route_names.dart';
import 'package:rectify/data/models/time_format.dart';
import 'package:rectify/features/settings/api_key_sheet.dart';
import 'package:rectify/features/settings/delete_all_data_sheet.dart';
import 'package:rectify/l10n/l10n.dart';
import 'package:rectify/providers/settings_controller.dart';
import 'package:rectify/theme/colors.dart';
import 'package:rectify/theme/icons.dart';
import 'package:rectify/theme/radius.dart';
import 'package:rectify/theme/spacing.dart';
import 'package:rectify/theme/typography.dart';
import 'package:rectify/widgets/buttons/buttons.dart';
import 'package:rectify/widgets/cards/app_card.dart';
import 'package:rectify/widgets/inputs/labeled_toggle.dart';
import 'package:rectify/widgets/inputs/radio_group.dart' as rectify;
import 'package:rectify/widgets/nav/top_nav.dart';

/// Settings screen (`docs/ascii-wireframes.md` Screen 9,
/// `docs/design-system.md` §10.7, `docs/mvp-scope.md` M11).
///
/// Grouped list of `bg.surface` cards. Each section ends with a 24pt
/// gap; the destructive "Delete all data" action sits in its own card
/// with a clear danger affordance. The API-key row triggers
/// [ApiKeySheet] and never displays the saved value — only a "Set"
/// indicator.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _openApiKeySheet(BuildContext context) =>
      ApiKeySheet.show(context);

  Future<void> _openDeleteAllSheet(BuildContext context, WidgetRef ref) =>
      DeleteAllDataSheet.show(context);

  void _openPrivacy(BuildContext context) =>
      context.push(RoutePaths.settingsPrivacy);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: AppColors.bgApp,
      appBar: TopNav(title: l10n.settingsTitle),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenEdge,
          AppSpacing.s5,
          AppSpacing.screenEdge,
          AppSpacing.s8,
        ),
        children: <Widget>[
          _SectionLabel(l10n.settingsSectionApiKey),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _ChevronRow(
                  label: l10n.settingsApiKeyRowLabel,
                  value: settings.proApiKeyConfigured
                      ? l10n.settingsApiKeySet
                      : l10n.settingsApiKeyNotSet,
                  valueColor: settings.proApiKeyConfigured
                      ? AppColors.accentClayDeep
                      : AppColors.inkSoft,
                  onTap: () => _openApiKeySheet(context),
                ),
                const SizedBox(height: AppSpacing.s2),
                Text(
                  l10n.settingsApiKeyHelper,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.inkSoft,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          _SectionLabel(l10n.settingsSectionDefaults),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                LabeledToggle(
                  label: l10n.settingsDemoModeLabel,
                  helperText: l10n.settingsDemoModeHelper,
                  value: settings.demoModeDefault,
                  onChanged: (value) =>
                      controller.setDemoModeDefault(value: value),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          _SectionLabel(l10n.settingsSectionTimeFormat),
          AppCard(
            child: rectify.RadioGroup<TimeFormat>(
              value: settings.timeFormat,
              options: <rectify.RadioOption<TimeFormat>>[
                rectify.RadioOption<TimeFormat>(
                  value: TimeFormat.h12,
                  label: l10n.settingsTimeFormat12,
                ),
                rectify.RadioOption<TimeFormat>(
                  value: TimeFormat.h24,
                  label: l10n.settingsTimeFormat24,
                ),
              ],
              onChanged: controller.setTimeFormat,
            ),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          _SectionLabel(l10n.settingsSectionData),
          AppCard(
            borderColor: AppColors.statusDanger.withValues(alpha: 0.4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                DestructiveButton(
                  label: l10n.settingsDeleteAllData,
                  icon: AppIcons.trash,
                  onPressed: () => _openDeleteAllSheet(context, ref),
                ),
                const SizedBox(height: AppSpacing.s3),
                Text(
                  l10n.settingsDeleteAllHelper,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.inkSoft,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          _SectionLabel(l10n.settingsSectionAbout),
          AppCard(
            padding: EdgeInsets.zero,
            child: _ChevronRow(
              label: l10n.settingsPrivacyPolicy,
              onTap: () => _openPrivacy(context),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s5,
                vertical: AppSpacing.s4,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s5),
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.s2),
            child: Text(
              '$appBrandName  v1.0.0',
              style: AppTypography.bodySm.copyWith(color: AppColors.inkSoft),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: AppSpacing.s3,
        left: AppSpacing.s2,
      ),
      child: Text(
        text.toUpperCase(),
        style: AppTypography.labelSm.copyWith(color: AppColors.inkSoft),
      ),
    );
  }
}

/// Tappable row with a chevron on the right; used by the API-key card
/// and the Privacy-Policy card. Pulled out instead of inlined so both
/// rows render identical chrome.
class _ChevronRow extends StatelessWidget {
  const _ChevronRow({
    required this.label,
    required this.onTap,
    this.value,
    this.valueColor,
    this.padding = EdgeInsets.zero,
  });

  final String label;
  final VoidCallback onTap;
  final String? value;
  final Color? valueColor;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: value == null
          ? label
          : context.l10n.fieldValueSemantic(label, value!),
      excludeSemantics: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.brSm,
          child: Padding(
            padding: padding,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 44),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(label, style: AppTypography.bodyMd),
                  ),
                  if (value != null) ...<Widget>[
                    Text(
                      value!,
                      style: AppTypography.bodyMd.copyWith(
                        color: valueColor ?? AppColors.inkSoft,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s2),
                  ],
                  const Icon(
                    AppIcons.forward,
                    size: 18,
                    color: AppColors.inkFaint,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
