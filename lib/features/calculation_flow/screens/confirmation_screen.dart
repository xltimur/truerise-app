import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:rectify/app/route_names.dart';
import 'package:rectify/data/models/life_event.dart';
import 'package:rectify/data/models/time_format.dart';
import 'package:rectify/data/models/time_window_mode.dart';
import 'package:rectify/features/calculation_flow/state/calculation_flow_controller.dart';
import 'package:rectify/features/calculation_flow/state/calculation_flow_state.dart';
import 'package:rectify/features/calculation_flow/widgets/calc_step_scaffold.dart';
import 'package:rectify/providers/settings_controller.dart';
import 'package:rectify/theme/colors.dart';
import 'package:rectify/theme/icons.dart';
import 'package:rectify/theme/spacing.dart';
import 'package:rectify/theme/typography.dart';
import 'package:rectify/widgets/buttons/buttons.dart';
import 'package:rectify/widgets/cards/app_card.dart';

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

/// Step 4 of the calc flow — summary before the (demo) submit.
///
/// Per `docs/design-system.md` §10.1 the stepper bar is hidden here;
/// the screen reads as a single review surface and the bottom CTA
/// kicks off `CalculationFlowController.submit()`.
class ConfirmationScreen extends ConsumerWidget {
  const ConfirmationScreen({super.key});

  String _formatDate(DateTime date) =>
      DateFormat('MMMM d, y').format(date.toLocal());

  String _formatTime(TimeOfDay time, TimeFormat format) {
    if (format == TimeFormat.h24) {
      return '${time.hour.toString().padLeft(2, '0')}:'
          '${time.minute.toString().padLeft(2, '0')}';
    }
    final isPm = time.hour >= 12;
    final hour12 = ((time.hour + 11) % 12) + 1;
    return '$hour12:${time.minute.toString().padLeft(2, '0')} '
        '${isPm ? 'PM' : 'AM'}';
  }

  String _formatWindow(int minutes) {
    if (minutes < 60) return '± $minutes min';
    final hours = minutes ~/ 60;
    return hours == 1 ? '± 1 hour' : '± $hours hours';
  }

  String _formatEvent(LifeEvent event) {
    if (event.month == null) return event.year.toString();
    return '${_monthLabels[event.month]} ${event.year}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flow = ref.watch(calculationFlowControllerProvider);
    final controller = ref.read(calculationFlowControllerProvider.notifier);
    final timeFormat = ref.watch(
      settingsControllerProvider.select((s) => s.timeFormat),
    );

    final birthDate = flow.birthDate;
    final birthLine = birthDate == null
        ? 'Date pending'
        : _formatDate(birthDate);
    final cityLine = flow.birthCity.trim().isEmpty
        ? '—'
        : flow.birthCity.trim();
    final labelLine = flow.label.trim().isEmpty ? null : flow.label.trim();

    final windowLine = switch (flow.timeWindowMode) {
      TimeWindowMode.unknown => 'Full 24-hour window',
      TimeWindowMode.approximate =>
        '${_formatTime(flow.approximateTime, timeFormat)} '
            '(${_formatWindow(flow.windowMinutes)})',
    };

    final canSubmit = flow.readyToSubmit && !flow.submitting;

    return CalcStepScaffold(
      step: CalculationFlowStep.confirm,
      title: 'Confirm your calculation',
      onBack: () {
        controller.back();
        context.go(RoutePaths.calcEvents);
      },
      secondaryAction: SecondaryButton(
        label: 'Back to edit',
        icon: AppIcons.back,
        onPressed: () {
          controller.back();
          context.go(RoutePaths.calcEvents);
        },
      ),
      primaryAction: PrimaryButton(
        label: flow.isDemo ? 'Calculate (demo)' : 'Calculate',
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
                Text('Birth details', style: AppTypography.titleSm),
                const SizedBox(height: AppSpacing.s2),
                _ReviewRow(label: 'Date', value: birthLine),
                _ReviewRow(label: 'City', value: cityLine),
                if (labelLine != null)
                  _ReviewRow(label: 'Label', value: labelLine),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s4),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Time window', style: AppTypography.titleSm),
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
                  'Life events (${flow.events.length})',
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
                            eventCategoryLabel(event.category),
                            style: AppTypography.bodyMd,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.s3),
                        Text(
                          _formatEvent(event),
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
              "Demo mode — we'll show a sample result with no network "
              'request.',
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
