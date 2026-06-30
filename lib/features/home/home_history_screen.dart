import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rectify/app/route_names.dart';
import 'package:rectify/core/analytics/app_analytics.dart';
import 'package:rectify/core/formatting/app_date_format.dart';
import 'package:rectify/core/sharing/invite_copy_builder.dart';
import 'package:rectify/core/sharing/share_copy_builder.dart';
import 'package:rectify/core/sharing/share_service.dart';
import 'package:rectify/data/models/saved_calculation.dart';
import 'package:rectify/features/home/history_providers.dart';
import 'package:rectify/l10n/l10n.dart';
import 'package:rectify/providers/core_providers.dart';
import 'package:rectify/providers/repo_providers.dart';
import 'package:rectify/providers/settings_controller.dart';
import 'package:rectify/theme/colors.dart';
import 'package:rectify/theme/icons.dart';
import 'package:rectify/theme/spacing.dart';
import 'package:rectify/theme/typography.dart';
import 'package:rectify/widgets/buttons/buttons.dart';
import 'package:rectify/widgets/cards/app_card.dart';
import 'package:rectify/widgets/cards/history_card.dart';
import 'package:rectify/widgets/feedback/empty_state.dart';
import 'package:rectify/widgets/nav/top_nav.dart';

@visibleForTesting
const Key homeInviteCardKey = ValueKey<String>('home-invite-card');

@visibleForTesting
const Key homeInviteButtonKey = ValueKey<String>('home-invite-button');

/// Home / History screen (`docs/ascii-wireframes.md` Screen 8,
/// `docs/implementation-plan.md` §14 Phase 3).
///
/// Streams saved calculations from Drift via [historyStreamProvider].
/// Renders an [EmptyState] when no rows exist, or a scrollable list of
/// [HistoryCard]s wrapped in [Dismissible] for swipe-to-delete with a
/// confirmation dialog and a "Deleted" snackbar (§9.15).
class HomeHistoryScreen extends ConsumerWidget {
  const HomeHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(historyStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.bgApp,
      appBar: const TopNav(title: appBrandName),
      body: history.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.accentClay),
        ),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.screenEdge),
            child: Text(
              context.l10n.homeHistoryLoadError(error.toString()),
              textAlign: TextAlign.center,
              style: AppTypography.bodyMd,
            ),
          ),
        ),
        data: (items) => items.isEmpty
            ? _EmptyHistory(
                onStart: () => context.go(RoutePaths.newCalculation),
              )
            : _PopulatedHistory(items: items),
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SingleChildScrollView(
      child: EmptyState(
        icon: AppIcons.history,
        title: l10n.homeEmptyTitle,
        body: l10n.homeEmptyBody,
        cta: PrimaryButton(
          label: l10n.homeNewCalculation,
          expand: false,
          onPressed: onStart,
        ),
      ),
    );
  }
}

class _PopulatedHistory extends ConsumerWidget {
  const _PopulatedHistory({required this.items});

  final List<SavedCalculation> items;

  /// Shares the privacy-safe summary of a saved result, reusing the same
  /// [ShareCopyBuilder] payload as the result screen (no birth city/date,
  /// life events, label, coordinates, or API ids). Deliberately does NOT
  /// invite a review here — a history share is a quiet utility action, not
  /// the celebratory positive moment the S2 review flow is reserved for.
  Future<void> _shareRow(
    BuildContext context,
    WidgetRef ref,
    SavedCalculation item,
  ) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final svc = ref.read(shareServiceProvider);
    final usedNative = await svc.share(
      ShareCopyBuilder.build(
        item,
        l10n,
        timeFormat: ref.read(settingsControllerProvider).timeFormat,
      ),
    );
    await ref
        .read(appAnalyticsProvider)
        .recordShare(
          surface: ShareAnalyticsSurface.historyRow,
          content: ShareAnalyticsContent.resultText,
          outcome: usedNative
              ? ShareAnalyticsOutcome.nativeSheet
              : ShareAnalyticsOutcome.fallback,
        );
    if (!context.mounted) return;
    if (!usedNative) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.resultCopiedToClipboard)),
      );
    }
  }

  /// Soft organic-share entry point on Home. Uses [InviteCopyBuilder],
  /// not [ShareCopyBuilder], so the invite is about trying TrueRise and
  /// cannot include this user's calculation data. No review prompt is
  /// chained from this path.
  Future<void> _invite(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final svc = ref.read(shareServiceProvider);
    final usedNative = await svc.share(InviteCopyBuilder.build(l10n));
    await ref
        .read(appAnalyticsProvider)
        .recordShare(
          surface: ShareAnalyticsSurface.homeInvite,
          content: ShareAnalyticsContent.inviteText,
          outcome: usedNative
              ? ShareAnalyticsOutcome.nativeSheet
              : ShareAnalyticsOutcome.fallback,
        );
    if (!context.mounted) return;
    if (!usedNative) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.resultCopiedToClipboard)),
      );
    }
  }

  Future<bool> _confirmDelete(BuildContext context, String label) async {
    final l10n = context.l10n;
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.bgSurface,
        title: Text(l10n.historyDeleteTitle),
        content: Text(
          l10n.historyDeleteBody(label),
          style: AppTypography.bodyMd,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.statusDanger,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.commonDelete),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);
    final l10n = context.l10n;

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenEdge,
        AppSpacing.s5,
        AppSpacing.screenEdge,
        AppSpacing.s7,
      ),
      itemCount: items.length + 2,
      separatorBuilder: (_, index) => SizedBox(
        height: index == 0 ? AppSpacing.s4 : AppSpacing.s3,
      ),
      itemBuilder: (context, listIndex) {
        if (listIndex == 0) {
          return _HomeInviteCard(onInvite: () => _invite(context, ref));
        }
        if (listIndex == 1) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.s4),
            child: Text(
              l10n.homePastCalculations,
              style: AppTypography.titleSm,
            ),
          );
        }

        final item = items[listIndex - 2];
        final result = item.result;
        final topCandidate = result.candidates.isEmpty
            ? null
            : result.candidates.first;
        final label = item.request.label?.isNotEmpty ?? false
            ? item.request.label!
            : l10n.homeDefaultLabel;

        final formatted = topCandidate == null
            ? (time: '—', meridiem: '')
            : AppDateFormat.clockParts(
                topCandidate.time,
                settings.timeFormat,
                localeName: l10n.localeName,
              );

        final risingSign = topCandidate?.ascendant != null
            ? l10n.resultRisingSign(topCandidate!.ascendant!)
            : (result.isDemo ? l10n.resultSampleData : '');

        return Dismissible(
          key: ValueKey<String>('history-${item.request.id}'),
          direction: DismissDirection.endToStart,
          background: _DismissBackground(),
          confirmDismiss: (_) => _confirmDelete(context, label),
          onDismissed: (_) async {
            final messenger = ScaffoldMessenger.of(context);
            final repo = ref.read(historyRepositoryProvider);
            final deletion = await repo.deleteById(item.request.id);
            if (!context.mounted) return;
            if (deletion.isOk) {
              messenger.showSnackBar(
                SnackBar(content: Text(l10n.historyDeletedSnack(label))),
              );
            } else {
              messenger.showSnackBar(
                SnackBar(content: Text(l10n.historyDeleteFailedSnack)),
              );
            }
          },
          child: HistoryCard(
            label: label,
            date: AppDateFormat.longDate(
              result.completedAt,
              localeName: l10n.localeName,
            ),
            time: formatted.time,
            meridiem: formatted.meridiem,
            risingSign: risingSign,
            confidence: topCandidate?.confidence ?? 0,
            isDemo: result.isDemo,
            onTap: () => context.go(RoutePaths.calcResultFor(item.request.id)),
            onShare: () => _shareRow(context, ref, item),
          ),
        );
      },
    );
  }
}

class _HomeInviteCard extends StatelessWidget {
  const _HomeInviteCard({required this.onInvite});

  final VoidCallback onInvite;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppCard(
      key: homeInviteCardKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(l10n.homeInviteTitle, style: AppTypography.titleSm),
          const SizedBox(height: AppSpacing.s2),
          Text(
            l10n.homeInviteBody,
            style: AppTypography.bodySm.copyWith(color: AppColors.inkSoft),
          ),
          const SizedBox(height: AppSpacing.s3),
          GhostButton(
            key: homeInviteButtonKey,
            label: l10n.homeInviteButton,
            icon: AppIcons.share,
            onPressed: onInvite,
          ),
        ],
      ),
    );
  }
}

class _DismissBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s5),
      decoration: BoxDecoration(
        color: AppColors.statusDanger,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(AppIcons.trash, color: AppColors.bgSurface),
          const SizedBox(width: AppSpacing.s2),
          Text(
            l10n.commonDelete,
            style: AppTypography.labelMd.copyWith(color: AppColors.bgSurface),
          ),
        ],
      ),
    );
  }
}
