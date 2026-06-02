import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rectify/app/route_names.dart';
import 'package:rectify/core/formatting/app_date_format.dart';
import 'package:rectify/data/models/time_window_mode.dart';
import 'package:rectify/features/calculation_flow/state/calculation_flow_controller.dart';
import 'package:rectify/features/calculation_flow/state/calculation_flow_state.dart';
import 'package:rectify/features/calculation_flow/widgets/calc_step_scaffold.dart';
import 'package:rectify/l10n/l10n.dart';
import 'package:rectify/providers/settings_controller.dart';
import 'package:rectify/theme/colors.dart';
import 'package:rectify/theme/icons.dart';
import 'package:rectify/theme/spacing.dart';
import 'package:rectify/theme/typography.dart';
import 'package:rectify/widgets/buttons/buttons.dart';
import 'package:rectify/widgets/cards/app_card.dart';

/// Step 4 of the calc flow — summary before the (demo) submit.
///
/// Per `docs/design-system.md` §10.1 the stepper bar is hidden here;
/// the screen reads as a single review surface and the bottom CTA
/// kicks off `CalculationFlowController.submit()`.
class ConfirmationScreen extends ConsumerWidget {
  const ConfirmationScreen({super.key});

  String _formatWindow(AppLocalizations l10n, int minutes) {
    if (minutes < 60) return l10n.timeWindowDeltaMinutes(minutes);
    return l10n.timeWindowDeltaHours(minutes ~/ 60);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final flow = ref.watch(calculationFlowControllerProvider);
    final controller = ref.read(calculationFlowControllerProvider.notifier);
    final timeFormat = ref.watch(
      settingsControllerProvider.select((s) => s.timeFormat),
    );

    final birthDate = flow.birthDate;
    final birthLine = birthDate == null
        ? l10n.confirmationDatePending
        : AppDateFormat.longDate(birthDate);
    final cityLine = flow.birthCity.trim().isEmpty
        ? '—'
        : flow.birthCity.trim();
    final labelLine = flow.label.trim().isEmpty ? null : flow.label.trim();

    final windowLine = switch (flow.timeWindowMode) {
      TimeWindowMode.unknown => l10n.confirmationFullDayWindow,
      TimeWindowMode.approximate => l10n.confirmationWindowApprox(
        AppDateFormat.clockTime(flow.approximateTime, timeFormat),
        _formatWindow(l10n, flow.windowMinutes),
      ),
    };

    final canSubmit = flow.readyToSubmit && !flow.submitting;

    return CalcStepScaffold(
      step: CalculationFlowStep.confirm,
      title: l10n.confirmationTitle,
      onBack: () {
        controller.back();
        context.go(RoutePaths.calcEvents);
      },
      secondaryAction: SecondaryButton(
        label: l10n.confirmationBackToEdit,
        icon: AppIcons.back,
        onPressed: () {
          controller.back();
          context.go(RoutePaths.calcEvents);
        },
      ),
      primaryAction: PrimaryButton(
        label: flow.isDemo
            ? l10n.confirmationCalculateDemo
            : l10n.confirmationCalculate,
        icon: AppIcons.check,
        onPressed: canSubmit
            ? () {
                context.go(RoutePaths.calcLoading);
              }
            : null,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(l10n.birthDataTitle, style: AppTypography.titleSm),
                const SizedBox(height: AppSpacing.s2),
                _ReviewRow(label: l10n.confirmationRowDate, value: birthLine),
                _ReviewRow(label: l10n.confirmationRowCity, value: cityLine),
                if (labelLine != null)
                  _ReviewRow(
                    label: l10n.confirmationRowLabel,
                    value: labelLine,
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s4),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  l10n.confirmationTimeWindow,
                  style: AppTypography.titleSm,
                ),
                const SizedBox(height: AppSpacing.s2),
                Text(windowLine, style: AppTypography.bodyMd),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s4),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  l10n.confirmationLifeEventsCount(flow.events.length),
                  style: AppTypography.titleSm,
                ),
                const SizedBox(height: AppSpacing.s2),
                for (final event in flow.events)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            eventCategoryLabel(l10n, event.category),
                            style: AppTypography.bodyMd,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.s3),
                        Text(
                          AppDateFormat.optionalMonthYear(
                            event.month,
                            event.year,
                          ),
                          style: AppTypography.bodySm.copyWith(
                            color: AppColors.inkSoft,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          if (flow.isDemo) ...<Widget>[
            const SizedBox(height: AppSpacing.s4),
            Text(
              l10n.confirmationDemoNote,
              style: AppTypography.bodySm.copyWith(color: AppColors.inkSoft),
            ),
          ],
        ],
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 72,
            child: Text(
              label,
              style: AppTypography.bodySm.copyWith(color: AppColors.inkSoft),
            ),
          ),
          Expanded(child: Text(value, style: AppTypography.bodyMd)),
        ],
      ),
    );
  }
}
