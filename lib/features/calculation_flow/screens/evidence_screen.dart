import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:rectify/app/route_names.dart';
import 'package:rectify/data/models/candidate_time.dart';
import 'package:rectify/data/models/event_category.dart';
import 'package:rectify/data/models/evidence_item.dart';
import 'package:rectify/data/models/life_event.dart';
import 'package:rectify/data/models/match_strength.dart';
import 'package:rectify/data/models/saved_calculation.dart';
import 'package:rectify/data/models/time_format.dart';
import 'package:rectify/features/calculation_flow/state/calculation_flow_state.dart';
import 'package:rectify/features/calculation_flow/state/result_providers.dart';
import 'package:rectify/providers/settings_controller.dart';
import 'package:rectify/theme/colors.dart';
import 'package:rectify/theme/icons.dart';
import 'package:rectify/theme/spacing.dart';
import 'package:rectify/theme/typography.dart';
import 'package:rectify/widgets/buttons/buttons.dart';
import 'package:rectify/widgets/cards/evidence_card.dart';
import 'package:rectify/widgets/chips/demo_pill.dart';
import 'package:rectify/widgets/feedback/empty_state.dart';
import 'package:rectify/widgets/nav/top_nav.dart';

// `ResultScreen` cross-references resolve through the router, not the
// import graph; suppress the dartdoc anchor lint.
// ignore_for_file: comment_references
/// Evidence breakdown screen (`docs/ascii-wireframes.md` Screen 7,
/// `docs/design-system.md` §10.3, `docs/implementation-plan.md` §14
/// Phase 5).
///
/// Child route of [ResultScreen] keyed by the same `resultId` — back
/// returns to the parent result, not the home tab. Reads through the
/// shared `savedCalculationByIdProvider` so demo and history-tap paths
/// resolve the same aggregate.
class EvidenceScreen extends ConsumerWidget {
  const EvidenceScreen({required this.resultId, super.key});

  final String resultId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(savedCalculationByIdProvider(resultId));

    return Scaffold(
      backgroundColor: AppColors.bgApp,
      appBar: TopNav(
        title: 'Evidence',
        onBack: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go(RoutePaths.calcResultFor(resultId));
          }
        },
      ),
      body: saved.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.accentClay),
        ),
        error: (_, _) => _EvidenceNotFound(resultId: resultId),
        data: (value) => value == null
            ? _EvidenceNotFound(resultId: resultId)
            : _EvidenceBody(saved: value),
      ),
    );
  }
}

class _EvidenceNotFound extends StatelessWidget {
  const _EvidenceNotFound({required this.resultId});

  final String resultId;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      child: EmptyState(
        title: "We couldn't find that evidence.",
        body:
            'The underlying result may have been deleted. '
            'Return to your history to pick another calculation.',
        cta: PrimaryButton(
          label: 'Back to history',
          expand: false,
          onPressed: () => context.go(RoutePaths.home),
        ),
      ),
    );
  }
}

@visibleForTesting
const Key evidenceSummaryKey = ValueKey<String>('evidence-summary');

class _EvidenceBody extends ConsumerWidget {
  const _EvidenceBody({required this.saved});

  final SavedCalculation saved;

  String _topTimeLabel(CandidateTime top, TimeFormat format) {
    final time = top.time;
    if (format == TimeFormat.h24) {
      return '${time.hour.toString().padLeft(2, '0')}:'
          '${time.minute.toString().padLeft(2, '0')}';
    }
    final isPm = time.hour >= 12;
    final hour12 = ((time.hour + 11) % 12) + 1;
    final suffix = isPm ? 'PM' : 'AM';
    return '$hour12:${time.minute.toString().padLeft(2, '0')} $suffix';
  }

  String _eventDateLabel(LifeEvent event) {
    if (event.month == null) return '${event.year}';
    final dt = DateTime(event.year, event.month!);
    return DateFormat('MMM y').format(dt);
  }

  IconData _iconFor(EventCategory category) => switch (category) {
    EventCategory.marriage => AppIcons.eventMarriage,
    EventCategory.divorce => AppIcons.eventDivorce,
    EventCategory.careerChange => AppIcons.eventCareer,
    EventCategory.jobLoss => AppIcons.eventJobLoss,
    EventCategory.relocation => AppIcons.eventRelocation,
    EventCategory.childBirth => AppIcons.eventBirth,
    EventCategory.familyDeath => AppIcons.eventDeath,
    EventCategory.illness => AppIcons.eventIllness,
    EventCategory.accident => AppIcons.eventAccident,
    EventCategory.education => AppIcons.eventEducation,
    EventCategory.financial => AppIcons.eventFinancial,
    EventCategory.other => AppIcons.eventOther,
  };

  bool _defaultExpandedFor(MatchStrength strength) =>
      strength == MatchStrength.strong || strength == MatchStrength.moderate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);
    final candidates = saved.result.candidates;
    final evidence = saved.result.evidence;
    final eventsById = <String, LifeEvent>{
      for (final event in saved.request.events) event.id: event,
    };

    if (candidates.isEmpty) {
      return _EvidenceNotFound(resultId: saved.request.id);
    }

    final top = candidates.first;
    final topTimeLabel = _topTimeLabel(top, settings.timeFormat);
    final strongCount = evidence
        .where(
          (item) =>
              item.matchStrength == MatchStrength.strong ||
              item.matchStrength == MatchStrength.moderate,
        )
        .length;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenEdge,
        AppSpacing.s4,
        AppSpacing.screenEdge,
        AppSpacing.s7,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Why $topTimeLabel?',
            style: AppTypography.titleLg,
            key: evidenceSummaryKey,
          ),
          const SizedBox(height: AppSpacing.s3),
          Text(
            evidence.isEmpty
                ? "We don't have event-level evidence for this result."
                : '$strongCount of ${evidence.length} events strongly '
                      'supported this time.',
            style: AppTypography.bodyMd.copyWith(color: AppColors.inkBody),
          ),
          if (saved.result.isDemo) ...<Widget>[
            const SizedBox(height: AppSpacing.s4),
            const Align(
              alignment: Alignment.centerLeft,
              child: DemoPill(),
            ),
          ],
          const SizedBox(height: AppSpacing.s5),
          for (final EvidenceItem item in evidence) ...<Widget>[
            Builder(
              builder: (context) {
                final event = eventsById[item.eventId];
                final category = event != null
                    ? eventCategoryLabel(event.category)
                    : 'Event';
                final icon = event != null
                    ? _iconFor(event.category)
                    : AppIcons.eventOther;
                final date = event != null ? _eventDateLabel(event) : '';
                return EvidenceCard(
                  icon: icon,
                  category: category,
                  date: date,
                  strength: item.matchStrength,
                  explanation: item.explanation,
                  expanded: _defaultExpandedFor(item.matchStrength),
                );
              },
            ),
            const SizedBox(height: AppSpacing.s3),
          ],
        ],
      ),
    );
  }
}
