import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rectify/app/route_names.dart';
import 'package:rectify/core/app_links.dart';
import 'package:rectify/core/sharing/invite_copy_builder.dart';
import 'package:rectify/core/sharing/share_service.dart';
import 'package:rectify/data/models/language_preference.dart';
import 'package:rectify/data/models/time_format.dart';
import 'package:rectify/features/settings/delete_all_data_sheet.dart';
import 'package:rectify/features/settings/privacy_policy_link.dart';
import 'package:rectify/l10n/l10n.dart';
import 'package:rectify/providers/core_providers.dart';
import 'package:rectify/providers/settings_controller.dart';
import 'package:rectify/theme/colors.dart';
import 'package:rectify/theme/icons.dart';
import 'package:rectify/theme/radius.dart';
import 'package:rectify/theme/spacing.dart';
import 'package:rectify/theme/typography.dart';
import 'package:rectify/widgets/buttons/buttons.dart';
import 'package:rectify/widgets/cards/app_card.dart';
import 'package:rectify/widgets/inputs/input_field.dart';
import 'package:rectify/widgets/inputs/labeled_toggle.dart';
import 'package:rectify/widgets/inputs/radio_group.dart' as rectify;
import 'package:rectify/widgets/nav/top_nav.dart';
import 'package:url_launcher/url_launcher.dart';

@visibleForTesting
const Key settingsInviteButtonKey = ValueKey<String>('settings-invite-button');

@visibleForTesting
const Key settingsApiKeyCardKey = ValueKey<String>('settings-api-key-card');

@visibleForTesting
const Key settingsApiKeyWebsiteLinkKey = ValueKey<String>(
  'settings-api-key-website-link',
);

Future<void> _openAstrologyApiKeyWebsite() async {
  final uri = Uri.parse(AppLinks.astrologyApiKeyUrl);
  try {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } on Object {
    // Non-blocking helper link: if the platform cannot open the browser,
    // the visible URL remains on screen for manual copy.
  }
}

/// Settings screen (`docs/ascii-wireframes.md` Screen 9,
/// `docs/design-system.md` §10.7, `docs/mvp-scope.md` M11).
///
/// Grouped list of `bg.surface` cards. Each section ends with a 24pt
/// gap; the destructive "Delete all data" action sits in its own card
/// with a clear danger affordance.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key, this.initialFocusApiKey = false});

  final bool initialFocusApiKey;

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final GlobalKey _apiKeySectionAnchorKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.initialFocusApiKey) {
      _scheduleApiKeyScroll();
    }
  }

  @override
  void didUpdateWidget(covariant SettingsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialFocusApiKey && !oldWidget.initialFocusApiKey) {
      _scheduleApiKeyScroll();
    }
  }

  void _scheduleApiKeyScroll() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final context = _apiKeySectionAnchorKey.currentContext;
      if (context == null) return;
      unawaited(
        Scrollable.ensureVisible(
          context,
          alignment: 0.08,
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
        ),
      );
    });
  }

  Future<void> _openDeleteAllSheet(BuildContext context, WidgetRef ref) =>
      DeleteAllDataSheet.show(context);

  /// Opens the privacy policy. When the owner configured a hosted page at
  /// build time (`TRUERISE_PRIVACY_POLICY_URL`) and it passes the
  /// bare-HTTPS validator, it opens in an in-app browser view; when the
  /// define is empty,
  /// unsafe, or the launch fails, the bundled in-app screen is pushed
  /// exactly as before — the row never dead-ends.
  Future<void> _openPrivacy(BuildContext context, WidgetRef ref) async {
    final url = ref.read(privacyPolicyUrlProvider);
    if (AppLinks.isPrivacySafeShareUrl(url)) {
      final opened = await ref.read(privacyPolicyLauncherProvider).open(url);
      if (opened) return;
    }
    if (!context.mounted) return;
    await context.push(RoutePaths.settingsPrivacy);
  }

  /// Collects a user-entered Astrology API key and stores the trimmed
  /// value via the controller, which routes it into secure storage
  /// (`docs/design-system.md` §9.5 — the raw key is never echoed back
  /// into the UI, so the dialog closes before any configured state
  /// renders). Store-build safe: no purchase or signup copy here.
  Future<void> _openAddKeyDialog(BuildContext context, WidgetRef ref) async {
    final key = await showDialog<String>(
      context: context,
      builder: (_) => const _ApiKeyDialog(),
    );
    if (key == null) return;
    await ref.read(settingsControllerProvider.notifier).setProApiKey(key);
  }

  /// Opt-in "Invite a friend" share (S4 — Invite Friend Lite). Sends a
  /// privacy-safe, localized, branded invite via [ShareService]. The text
  /// comes from [InviteCopyBuilder], which reads no `SavedCalculation`, so
  /// no birth date, city, coordinates, life event, label, or API id can
  /// leak. Deliberately does NOT chain the review invitation — an invite is
  /// not the celebratory moment that flow is reserved for, and stacking a
  /// rating ask on top would read as a dark pattern. A clipboard fallback
  /// surfaces a SnackBar and is never treated as a positive moment.
  Future<void> _invite(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final svc = ref.read(shareServiceProvider);
    final usedNative = await svc.share(InviteCopyBuilder.build(l10n));
    if (!context.mounted) return;
    if (!usedNative) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.resultCopiedToClipboard)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: AppColors.bgApp,
      appBar: TopNav(title: l10n.settingsTitle),
      body: ListView(
        cacheExtent: 1600,
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenEdge,
          AppSpacing.s5,
          AppSpacing.screenEdge,
          AppSpacing.s8,
        ),
        children: <Widget>[
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
          _SectionLabel(l10n.settingsSectionLanguage),
          AppCard(
            child: rectify.RadioGroup<LanguagePreference>(
              value: settings.languagePreference,
              options: <rectify.RadioOption<LanguagePreference>>[
                rectify.RadioOption<LanguagePreference>(
                  value: LanguagePreference.auto,
                  label: l10n.settingsLanguageAuto,
                ),
                rectify.RadioOption<LanguagePreference>(
                  value: LanguagePreference.english,
                  label: l10n.settingsLanguageEnglish,
                ),
                rectify.RadioOption<LanguagePreference>(
                  value: LanguagePreference.german,
                  label: l10n.settingsLanguageGerman,
                ),
                rectify.RadioOption<LanguagePreference>(
                  value: LanguagePreference.spanish,
                  label: l10n.settingsLanguageSpanish,
                ),
                rectify.RadioOption<LanguagePreference>(
                  value: LanguagePreference.french,
                  label: l10n.settingsLanguageFrench,
                ),
                rectify.RadioOption<LanguagePreference>(
                  value: LanguagePreference.portuguese,
                  label: l10n.settingsLanguagePortuguese,
                ),
                rectify.RadioOption<LanguagePreference>(
                  value: LanguagePreference.ukrainian,
                  label: l10n.settingsLanguageUkrainian,
                ),
              ],
              onChanged: controller.setLanguagePreference,
            ),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          KeyedSubtree(
            key: _apiKeySectionAnchorKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _SectionLabel(l10n.settingsSectionApiKey),
                AppCard(
                  key: settingsApiKeyCardKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        l10n.settingsApiKeyHelper,
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.inkSoft,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s3),
                      _ApiKeyWebsiteLink(
                        label: l10n.settingsApiKeyGetLink,
                        onTap: _openAstrologyApiKeyWebsite,
                      ),
                      const SizedBox(height: AppSpacing.s4),
                      if (settings.proApiKeyConfigured) ...<Widget>[
                        Text(
                          l10n.settingsApiKeyConfigured,
                          style: AppTypography.bodyMd,
                        ),
                        const SizedBox(height: AppSpacing.s3),
                        SecondaryButton(
                          label: l10n.settingsApiKeyRemove,
                          onPressed: controller.clearProApiKey,
                        ),
                      ] else
                        SecondaryButton(
                          label: l10n.settingsApiKeyAdd,
                          onPressed: () => _openAddKeyDialog(context, ref),
                        ),
                    ],
                  ),
                ),
              ],
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _ChevronRow(
                  key: settingsInviteButtonKey,
                  label: l10n.settingsInviteFriend,
                  onTap: () => _invite(context, ref, l10n),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s5,
                    vertical: AppSpacing.s4,
                  ),
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors.inkLine,
                ),
                _ChevronRow(
                  label: l10n.settingsPrivacyPolicy,
                  onTap: () => _openPrivacy(context, ref),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s5,
                    vertical: AppSpacing.s4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s5),
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.s2),
            child: Text(
              // Installed version + build from the platform package info
              // (mvp-scope M11 "App version"); brand-only while loading.
              ref
                  .watch(packageInfoProvider)
                  .maybeWhen(
                    data: (info) =>
                        '$appBrandName  v${info.version} (${info.buildNumber})',
                    orElse: () => appBrandName,
                  ),
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

class _ApiKeyWebsiteLink extends StatelessWidget {
  const _ApiKeyWebsiteLink({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '$label ${AppLinks.astrologyApiKeyUrl}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          key: settingsApiKeyWebsiteLinkKey,
          onTap: onTap,
          borderRadius: AppRadius.brSm,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Icon(
                    AppIcons.externalLink,
                    size: 16,
                    color: AppColors.accentClay,
                  ),
                ),
                const SizedBox(width: AppSpacing.s2),
                Expanded(
                  child: Text(
                    '$label ${AppLinks.astrologyApiKeyUrl}',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.accentClay,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Modal that collects an Astrology API key. Pops with the trimmed key;
/// an all-whitespace entry keeps the dialog open. The field is obscured
/// and the dialog never re-renders a stored key (§9.5).
class _ApiKeyDialog extends StatefulWidget {
  const _ApiKeyDialog();

  @override
  State<_ApiKeyDialog> createState() => _ApiKeyDialogState();
}

class _ApiKeyDialogState extends State<_ApiKeyDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final key = _controller.text.trim();
    if (key.isEmpty) return;
    Navigator.of(context).pop(key);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.all(AppSpacing.screenEdge),
      child: AppCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            InputField(
              label: l10n.settingsApiKeyFieldLabel,
              controller: _controller,
              obscureText: true,
              autofocus: true,
              onSubmitted: (_) => _save(),
            ),
            const SizedBox(height: AppSpacing.s3),
            _ApiKeyWebsiteLink(
              label: l10n.settingsApiKeyGetLink,
              onTap: _openAstrologyApiKeyWebsite,
            ),
            const SizedBox(height: AppSpacing.s4),
            PrimaryButton(label: l10n.settingsApiKeySave, onPressed: _save),
          ],
        ),
      ),
    );
  }
}

/// Tappable row with a chevron on the right; used by the Privacy-Policy
/// card. Kept as its own widget so the row chrome stays consistent.
class _ChevronRow extends StatelessWidget {
  const _ChevronRow({
    required this.label,
    required this.onTap,
    super.key,
    this.padding = EdgeInsets.zero,
  });

  final String label;
  final VoidCallback onTap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
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
