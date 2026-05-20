import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rectify/app/route_names.dart';
import 'package:rectify/data/models/event_category.dart';
import 'package:rectify/data/models/life_event.dart';
import 'package:rectify/features/calculation_flow/state/calculation_flow_controller.dart';
import 'package:rectify/features/calculation_flow/state/calculation_flow_state.dart';
import 'package:rectify/features/calculation_flow/widgets/add_event_sheet.dart';
import 'package:rectify/features/calculation_flow/widgets/calc_step_scaffold.dart';
import 'package:rectify/theme/colors.dart';
import 'package:rectify/theme/icons.dart';
import 'package:rectify/theme/radius.dart';
import 'package:rectify/theme/spacing.dart';
import 'package:rectify/theme/typography.dart';
import 'package:rectify/widgets/buttons/buttons.dart';
import 'package:rectify/widgets/cards/event_card.dart';

const _monthLabels = <int, String>{
  1: 'Jan',
  2: 'Feb',
  3: 'Mar',
  4: 'Apr',
  5: 'May',
  6: 'Jun',
  7: 'Jul',
  8: 'Aug',
  9: 'Sep',
  10: 'Oct',
  11: 'Nov',
  12: 'Dec',
};

/// Step 3 of the calc flow (`docs/ascii-wireframes.md` Screen 4).
class LifeEventsScreen extends ConsumerWidget {
  const LifeEventsScreen({super.key});

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

  String _formatDate(LifeEvent event) {
    if (event.month == null) return event.year.toString();
    return '${_monthLabels[event.month]} ${event.year}';
  }

  Future<void> _addEvent(BuildContext context, WidgetRef ref) async {
    final result = await AddEventSheet.show(context);
    if (result == null) return;
    ref
        .read(calculationFlowControllerProvider.notifier)
        .addEvent(
          category: result.category,
          year: result.year,
          month: result.month,
          description: result.description,
        );
  }

  Future<void> _editEvent(
    BuildContext context,
    WidgetRef ref,
    LifeEvent event,
  ) async {
    final result = await AddEventSheet.show(context, existing: event);
    if (result == null) return;
    ref
        .read(calculationFlowControllerProvider.notifier)
        .updateEvent(
          id: event.id,
          category: result.category,
          year: result.year,
          month: result.month,
          description: result.description,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flow = ref.watch(calculationFlowControllerProvider);
    final controller = ref.read(calculationFlowControllerProvider.notifier);
    final events = flow.events;
    final hasEvents = events.isNotEmpty;

    final canContinue = flow.eventsStepValid;
    final showSoftWarning = flow.eventsBelowRecommended;

    return CalcStepScaffold(
      step: CalculationFlowStep.events,
      title: hasEvents
          ? 'Life events  (${events.length} added)'
          : 'Life events',
      onBack: () {
        controller.back();
        context.go(RoutePaths.calcWindow);
      },
      secondaryAction: SecondaryButton(
        label: hasEvents ? 'Add event' : 'Add first event',
        icon: AppIcons.add,
        onPressed: () => _addEvent(context, ref),
      ),
      primaryAction: PrimaryButton(
        label: flow.isDemo ? 'Continue (demo)' : 'Continue',
        icon: AppIcons.forward,
        onPressed: canContinue
            ? () {
                controller.next();
                context.go(RoutePaths.calcConfirm);
              }
            : null,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (!hasEvents) ...<Widget>[
            Text(
              'Add memorable events from your life. '
              'The more you add, the better.',
              style: AppTypography.bodyMd,
            ),
            const SizedBox(height: AppSpacing.s4),
            const _GuidanceBanner(
              text:
                  'Add at least 5 events for a real calculation. '
                  '3 for a demo.',
            ),
            const SizedBox(height: AppSpacing.s7),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.s7),
              child: Text(
                'No events yet.',
                textAlign: TextAlign.center,
                style: AppTypography.bodyMd.copyWith(color: AppColors.inkSoft),
              ),
            ),
          ] else ...<Widget>[
            if (showSoftWarning)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.s4),
                child: _GuidanceBanner(
                  text:
                      '${events.length} events. '
                      'Add 5+ for a stronger real calculation.',
                ),
              ),
            for (var i = 0; i < events.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.s3),
                child: EventCard(
                  icon: _iconFor(events[i].category),
                  category: eventCategoryLabel(events[i].category),
                  date: _formatDate(events[i]),
                  onTap: () => _editEvent(context, ref, events[i]),
                  onDelete: () => controller.removeEvent(events[i].id),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _GuidanceBanner extends StatelessWidget {
  const _GuidanceBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s4,
        vertical: AppSpacing.s3,
      ),
      decoration: BoxDecoration(
        color: AppColors.accentClayTint,
        borderRadius: AppRadius.brSm,
        border: Border.all(color: AppColors.accentClayLine),
      ),
      child: Text(
        text,
        style: AppTypography.bodySm.copyWith(color: AppColors.accentClayDeep),
      ),
    );
  }
}
