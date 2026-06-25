import 'package:flutter/material.dart' hide RadioGroup;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rectify/app/route_names.dart';
import 'package:rectify/core/formatting/app_date_format.dart';
import 'package:rectify/data/models/time_format.dart';
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
import 'package:rectify/widgets/buttons/primary_button.dart';
import 'package:rectify/widgets/inputs/inputs.dart';
import 'package:rectify/widgets/sheets/bottom_sheet_picker.dart';

/// Step 2 of the calc flow (`docs/ascii-wireframes.md` Screen 3).
class TimeWindowScreen extends ConsumerWidget {
  const TimeWindowScreen({super.key});

  String _windowLabel(AppLocalizations l10n, int minutes) {
    if (minutes < 60) return l10n.timeWindowDeltaMinutes(minutes);
    return l10n.timeWindowDeltaHours(minutes ~/ 60);
  }

  Future<void> _pickTime(
    BuildContext context,
    WidgetRef ref,
    TimeOfDay current,
  ) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: current,
      helpText: context.l10n.timeWindowTimePickerHelp,
    );
    if (picked == null) return;
    ref
        .read(calculationFlowControllerProvider.notifier)
        .setApproximateTime(
          picked,
        );
  }

  Future<void> _pickWindow(
    BuildContext context,
    WidgetRef ref,
    int current,
  ) async {
    final picked = await BottomSheetPicker.show<int>(
      context: context,
      title: context.l10n.timeWindowSearchWindow,
      value: current,
      options: <BottomSheetOption<int>>[
        for (final minutes in kWindowMinuteOptions)
          BottomSheetOption<int>(
            value: minutes,
            label: _windowLabel(context.l10n, minutes),
          ),
      ],
    );
    if (picked == null) return;
    ref
        .read(calculationFlowControllerProvider.notifier)
        .setWindowMinutes(
          picked,
        );
  }

  String _rangeCopy(
    AppLocalizations l10n,
    TimeOfDay start,
    int minutes,
    TimeFormat format,
  ) {
    final base = start.hour * 60 + start.minute;
    final lo = (base - minutes).clamp(0, 24 * 60 - 1);
    final hi = (base + minutes).clamp(0, 24 * 60 - 1);
    final loTime = TimeOfDay(hour: lo ~/ 60, minute: lo % 60);
    final hiTime = TimeOfDay(hour: hi ~/ 60, minute: hi % 60);
    return l10n.timeWindowRangeCopy(
      AppDateFormat.clockTime(loTime, format, localeName: l10n.localeName),
      AppDateFormat.clockTime(hiTime, format, localeName: l10n.localeName),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flow = ref.watch(calculationFlowControllerProvider);
    final controller = ref.read(calculationFlowControllerProvider.notifier);
    final timeFormat = ref.watch(
      settingsControllerProvider.select((s) => s.timeFormat),
    );

    final isApprox = flow.timeWindowMode == TimeWindowMode.approximate;

    return CalcStepScaffold(
      step: CalculationFlowStep.window,
      title: context.l10n.timeWindowTitle,
      isDemo: flow.isDemo,
      onBack: () {
        controller.back();
        context.go(RoutePaths.calcBirth);
      },
      primaryAction: PrimaryButton(
        label: context.l10n.commonContinue,
        icon: AppIcons.forward,
        onPressed: flow.windowStepValid
            ? () {
                controller.next();
                context.go(RoutePaths.calcEvents);
              }
            : null,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          RadioGroup<TimeWindowMode>(
            value: flow.timeWindowMode,
            options: <RadioOption<TimeWindowMode>>[
              RadioOption<TimeWindowMode>(
                value: TimeWindowMode.approximate,
                label: context.l10n.timeWindowModeApprox,
              ),
              RadioOption<TimeWindowMode>(
                value: TimeWindowMode.unknown,
                label: context.l10n.timeWindowModeUnknown,
              ),
            ],
            onChanged: controller.setWindowMode,
          ),
          const SizedBox(height: AppSpacing.s5),
          if (isApprox) ...<Widget>[
            TimePickerField(
              label: context.l10n.timeWindowApproxTimeLabel,
              placeholder: context.l10n.timeWindowChooseTime,
              formattedValue: AppDateFormat.clockTime(
                flow.approximateTime,
                timeFormat,
                localeName: context.l10n.localeName,
              ),
              onTap: () => _pickTime(context, ref, flow.approximateTime),
            ),
            const SizedBox(height: AppSpacing.s4),
            _PickerRow(
              label: context.l10n.timeWindowSearchWindow,
              value: _windowLabel(context.l10n, flow.windowMinutes),
              onTap: () => _pickWindow(context, ref, flow.windowMinutes),
            ),
            const SizedBox(height: AppSpacing.s4),
            Text(
              _rangeCopy(
                context.l10n,
                flow.approximateTime,
                flow.windowMinutes,
                timeFormat,
              ),
              style: AppTypography.bodyMd,
            ),
            const SizedBox(height: AppSpacing.s3),
            Text(
              context.l10n.timeWindowApproxHint,
              style: AppTypography.bodySm.copyWith(color: AppColors.inkSoft),
            ),
          ] else ...<Widget>[
            Text(
              context.l10n.timeWindowUnknownBody,
              style: AppTypography.bodyMd,
            ),
            const SizedBox(height: AppSpacing.s3),
            Text(
              context.l10n.timeWindowUnknownHint,
              style: AppTypography.bodySm.copyWith(color: AppColors.inkSoft),
            ),
          ],
        ],
      ),
    );
  }
}

class _PickerRow extends StatelessWidget {
  const _PickerRow({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Reuse the time-picker chrome for a generic "tap to choose" row
    // so the visual contract stays consistent with the rest of step 2.
    return TimePickerField(
      label: label,
      formattedValue: value,
      onTap: onTap,
    );
  }
}
