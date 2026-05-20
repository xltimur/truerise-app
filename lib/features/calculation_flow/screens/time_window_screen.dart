import 'package:flutter/material.dart' hide RadioGroup;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rectify/app/route_names.dart';
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
import 'package:rectify/widgets/buttons/primary_button.dart';
import 'package:rectify/widgets/inputs/inputs.dart';
import 'package:rectify/widgets/sheets/bottom_sheet_picker.dart';

/// Step 2 of the calc flow (`docs/ascii-wireframes.md` Screen 3).
class TimeWindowScreen extends ConsumerWidget {
  const TimeWindowScreen({super.key});

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

  String _windowLabel(int minutes) {
    if (minutes < 60) return '± $minutes min';
    final hours = minutes ~/ 60;
    return hours == 1 ? '± 1 hour' : '± $hours hours';
  }

  Future<void> _pickTime(
    BuildContext context,
    WidgetRef ref,
    TimeOfDay current,
  ) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: current,
      helpText: 'Approximate birth time',
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
      title: 'Search window',
      value: current,
      options: <BottomSheetOption<int>>[
        for (final minutes in kWindowMinuteOptions)
          BottomSheetOption<int>(value: minutes, label: _windowLabel(minutes)),
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
    TimeOfDay start,
    int minutes,
    TimeFormat format,
  ) {
    final base = start.hour * 60 + start.minute;
    final lo = (base - minutes).clamp(0, 24 * 60 - 1);
    final hi = (base + minutes).clamp(0, 24 * 60 - 1);
    final loTime = TimeOfDay(hour: lo ~/ 60, minute: lo % 60);
    final hiTime = TimeOfDay(hour: hi ~/ 60, minute: hi % 60);
    return "We'll search between ${_formatTime(loTime, format)} and "
        '${_formatTime(hiTime, format)}.';
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
      title: 'Do you know an approximate birth time?',
      onBack: () {
        controller.back();
        context.go(RoutePaths.calcBirth);
      },
      primaryAction: PrimaryButton(
        label: 'Continue',
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
            options: const <RadioOption<TimeWindowMode>>[
              RadioOption<TimeWindowMode>(
                value: TimeWindowMode.approximate,
                label: 'I have an approximate time',
              ),
              RadioOption<TimeWindowMode>(
                value: TimeWindowMode.unknown,
                label: 'I have no idea',
              ),
            ],
            onChanged: controller.setWindowMode,
          ),
          const SizedBox(height: AppSpacing.s5),
          if (isApprox) ...<Widget>[
            TimePickerField(
              label: 'Approximate time',
              placeholder: 'Choose time',
              formattedValue: _formatTime(flow.approximateTime, timeFormat),
              onTap: () => _pickTime(context, ref, flow.approximateTime),
            ),
            const SizedBox(height: AppSpacing.s4),
            _PickerRow(
              label: 'Search window',
              value: _windowLabel(flow.windowMinutes),
              onTap: () => _pickWindow(context, ref, flow.windowMinutes),
            ),
            const SizedBox(height: AppSpacing.s4),
            Text(
              _rangeCopy(flow.approximateTime, flow.windowMinutes, timeFormat),
              style: AppTypography.bodyMd,
            ),
            const SizedBox(height: AppSpacing.s3),
            Text(
              'A wider window gives more candidates but may reduce '
              'precision.',
              style: AppTypography.bodySm.copyWith(color: AppColors.inkSoft),
            ),
          ] else ...<Widget>[
            Text(
              "We'll search the entire 24-hour range. This may produce "
              'more candidates with lower confidence.',
              style: AppTypography.bodyMd,
            ),
            const SizedBox(height: AppSpacing.s3),
            Text(
              'Adding more life events will help narrow it down.',
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
