import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:rectify/app/route_names.dart';
import 'package:rectify/data/models/candidate_time.dart';
import 'package:rectify/data/models/saved_calculation.dart';
import 'package:rectify/data/models/time_format.dart';
import 'package:rectify/features/home/history_providers.dart';
import 'package:rectify/providers/repo_providers.dart';
import 'package:rectify/providers/settings_controller.dart';
import 'package:rectify/theme/colors.dart';
import 'package:rectify/theme/icons.dart';
import 'package:rectify/theme/spacing.dart';
import 'package:rectify/theme/typography.dart';
import 'package:rectify/widgets/buttons/buttons.dart';
import 'package:rectify/widgets/cards/history_card.dart';
import 'package:rectify/widgets/feedback/empty_state.dart';
import 'package:rectify/widgets/nav/top_nav.dart';

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
      appBar: TopNav(
        title: 'Rectify',
        trailingIcon: AppIcons.settings,
        trailingSemanticsLabel: 'Settings',
        onTrailingTap: () => context.go(RoutePaths.settings),
      ),
      body: history.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.accentClay),
        ),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.screenEdge),
            child: Text(
              "We couldn't load your history.\n$error",
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
    return SingleChildScrollView(
      child: EmptyState(
        icon: AppIcons.history,
        title: 'No calculations yet.',
        body: 'Run your first one to see results here.',
        cta: PrimaryButton(
          label: 'New Calculation',
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

  String _formatDate(DateTime when) =>
      DateFormat('MMMM d, y').format(when.toLocal());

  ({String time, String meridiem}) _formatCandidate(
    CandidateTime candidate,
    TimeFormat format,
  ) {
    final time = candidate.time;
    if (format == TimeFormat.h24) {
      return (
        time:
            '${time.hour.toString().padLeft(2, '0')}:'
            '${time.minute.toString().padLeft(2, '0')}',
        meridiem: '',
      );
    }
    final isPm = time.hour >= 12;
    final hour12 = ((time.hour + 11) % 12) + 1;
    return (
      time: '$hour12:${time.minute.toString().padLeft(2, '0')}',
      meridiem: isPm ? 'PM' : 'AM',
    );
  }

  Future<bool> _confirmDelete(BuildContext context, String label) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.bgSurface,
        title: const Text('Delete this calculation?'),
        content: Text(
          'This removes "$label" from your history. The original '
          "data isn't kept anywhere else.",
          style: AppTypography.bodyMd,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.statusDanger,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenEdge,
        AppSpacing.s5,
        AppSpacing.screenEdge,
        AppSpacing.s7,
      ),
      itemCount: items.length + 1,
      separatorBuilder: (_, index) => index == 0
          ? const SizedBox.shrink()
          : const SizedBox(height: AppSpacing.s3),
      itemBuilder: (context, listIndex) {
        if (listIndex == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.s4),
            child: Text('Past calculations', style: AppTypography.titleSm),
          );
        }

        final item = items[listIndex - 1];
        final result = item.result;
        final topCandidate = result.candidates.isEmpty
            ? null
            : result.candidates.first;
        final label = item.request.label?.isNotEmpty ?? false
            ? item.request.label!
            : 'My calculation';

        final formatted = topCandidate == null
            ? (time: '—', meridiem: '')
            : _formatCandidate(topCandidate, settings.timeFormat);

        final risingSign = topCandidate?.ascendant != null
            ? '${topCandidate!.ascendant} Rising'
            : (result.isDemo ? '(sample data)' : '');

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
                SnackBar(content: Text('"$label" deleted.')),
              );
            } else {
              messenger.showSnackBar(
                const SnackBar(content: Text("Couldn't delete this entry.")),
              );
            }
          },
          child: HistoryCard(
            label: label,
            date: _formatDate(result.completedAt),
            time: formatted.time,
            meridiem: formatted.meridiem,
            risingSign: risingSign,
            confidence: topCandidate?.confidence ?? 0,
            isDemo: result.isDemo,
            onTap: () => context.go(RoutePaths.calcResultFor(item.request.id)),
          ),
        );
      },
    );
  }
}

class _DismissBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            'Delete',
            style: AppTypography.labelMd.copyWith(color: AppColors.bgSurface),
          ),
        ],
      ),
    );
  }
}
