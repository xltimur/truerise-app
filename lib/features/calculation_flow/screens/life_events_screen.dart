import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rectify/app/route_names.dart';
import 'package:rectify/core/formatting/app_date_format.dart';
import 'package:rectify/data/models/event_category.dart';
import 'package:rectify/data/models/life_event.dart';
import 'package:rectify/features/calculation_flow/state/calculation_flow_controller.dart';
import 'package:rectify/features/calculation_flow/state/calculation_flow_state.dart';
import 'package:rectify/features/calculation_flow/widgets/add_event_sheet.dart';
import 'package:rectify/features/calculation_flow/widgets/calc_step_scaffold.dart';
import 'package:rectify/l10n/l10n.dart';
import 'package:rectify/theme/colors.dart';
import 'package:rectify/theme/icons.dart';
import 'package:rectify/theme/radius.dart';
import 'package:rectify/theme/spacing.dart';
import 'package:rectify/theme/typography.dart';
import 'package:rectify/widgets/buttons/buttons.dart';
import 'package:rectify/widgets/cards/event_card.dart';

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

  String _formatDate(LifeEvent event) =>
      AppDateFormat.optionalMonthYear(event.month, event.year);

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
          ? context.l10n.lifeEventsTitleWithCount(events.length)
          : context.l10n.lifeEventsTitle,
      onBack: () {
        controller.back();
        context.go(RoutePaths.calcWindow);
      },
      secondaryAction: SecondaryButton(
        label: hasEvents
            ? context.l10n.lifeEventsAddEvent
            : context.l10n.lifeEventsAddFirstEvent,
        icon: AppIcons.add,
        onPressed: () => _addEvent(context, ref),
      ),
      primaryAction: PrimaryButton(
        label: flow.isDemo
            ? context.l10n.lifeEventsContinueDemo
            : context.l10n.commonContinue,
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
              context.l10n.lifeEventsEmptyBody,
              style: AppTypography.bodyMd,
            ),
            const SizedBox(height: AppSpacing.s4),
            _GuidanceBanner(
              text: context.l10n.lifeEventsGuidanceEmpty,
            ),
            const SizedBox(height: AppSpacing.s7),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.s7),
              child: Text(
                context.l10n.lifeEventsNoEvents,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMd.copyWith(color: AppColors.inkSoft),
              ),
            ),
          ] else ...<Widget>[
            if (showSoftWarning)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.s4),
                child: _GuidanceBanner(
                  text: context.l10n.lifeEventsGuidanceCount(events.length),
                ),
              ),
            for (var i = 0; i < events.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.s3),
                child: EventCard(
                  icon: _iconFor(events[i].category),
                  category: eventCategoryLabel(
                    context.l10n,
                    events[i].category,
                  ),
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
