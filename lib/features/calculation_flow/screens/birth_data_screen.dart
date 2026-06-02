import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rectify/app/route_names.dart';
import 'package:rectify/core/formatting/app_date_format.dart';
import 'package:rectify/data/models/geo_place.dart';
import 'package:rectify/features/calculation_flow/geocoding/geocoding_service.dart';
import 'package:rectify/features/calculation_flow/state/calculation_flow_controller.dart';
import 'package:rectify/features/calculation_flow/state/calculation_flow_state.dart';
import 'package:rectify/features/calculation_flow/widgets/calc_step_scaffold.dart';
import 'package:rectify/l10n/l10n.dart';
import 'package:rectify/theme/colors.dart';
import 'package:rectify/theme/icons.dart';
import 'package:rectify/theme/radius.dart';
import 'package:rectify/theme/spacing.dart';
import 'package:rectify/theme/typography.dart';
import 'package:rectify/widgets/buttons/primary_button.dart';
import 'package:rectify/widgets/inputs/inputs.dart';

/// Step 1 of the calc flow (`docs/ascii-wireframes.md` Screen 2).
class BirthDataScreen extends ConsumerStatefulWidget {
  const BirthDataScreen({super.key});

  @override
  ConsumerState<BirthDataScreen> createState() => _BirthDataScreenState();
}

class _BirthDataScreenState extends ConsumerState<BirthDataScreen> {
  late final TextEditingController _cityController;
  late final TextEditingController _labelController;
  List<GeoPlace> _suggestions = const <GeoPlace>[];
  bool _searching = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    final initial = ref.read(calculationFlowControllerProvider);
    _cityController = TextEditingController(text: initial.birthCity);
    _labelController = TextEditingController(text: initial.label);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _cityController.dispose();
    _labelController.dispose();
    super.dispose();
  }

  void _onCityChanged(String value) {
    ref
        .read(calculationFlowControllerProvider.notifier)
        .setBirthCityText(value);
    _debounce?.cancel();
    if (value.trim().isEmpty) {
      setState(() {
        _suggestions = const <GeoPlace>[];
        _searching = false;
      });
      return;
    }
    setState(() => _searching = true);
    _debounce = Timer(const Duration(milliseconds: 180), () async {
      final geocoder = ref.read(geocodingServiceProvider);
      final hits = await geocoder.search(value);
      if (!mounted) return;
      setState(() {
        _suggestions = hits;
        _searching = false;
      });
    });
  }

  void _selectPlace(GeoPlace place) {
    ref.read(calculationFlowControllerProvider.notifier).selectGeoPlace(place);
    _cityController.text = place.displayName;
    _cityController.selection = TextSelection.fromPosition(
      TextPosition(offset: place.displayName.length),
    );
    setState(() => _suggestions = const <GeoPlace>[]);
    FocusScope.of(context).unfocus();
  }

  Future<void> _pickDate() async {
    final state = ref.read(calculationFlowControllerProvider);
    final now = DateTime.now();
    final firstDate = DateTime(1920);
    // 18+ age gate: the picker cannot offer any date that would make the
    // user a minor.
    final lastAllowed = CalculationFlowState.latestAllowedBirthDate(now);
    // Default to a plausible adult age when nothing is set yet.
    final fallback = DateTime(now.year - 30, now.month, now.day);
    final stored = state.birthDate;
    final candidate = stored == null
        ? fallback
        : DateTime(stored.year, stored.month, stored.day);
    // Clamp into [firstDate, lastAllowed] so a persisted under-age or
    // out-of-range draft can't trip showDatePicker's internal asserts.
    final DateTime initial;
    if (candidate.isAfter(lastAllowed)) {
      initial = lastAllowed;
    } else if (candidate.isBefore(firstDate)) {
      initial = firstDate;
    } else {
      initial = candidate;
    }
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstDate,
      lastDate: lastAllowed,
      helpText: context.l10n.birthDataDateLabel,
    );
    if (picked == null) return;
    ref
        .read(calculationFlowControllerProvider.notifier)
        .setBirthDate(DateTime.utc(picked.year, picked.month, picked.day));
  }

  String _formattedDate(DateTime? date) {
    if (date == null) return '';
    return AppDateFormat.longDate(date);
  }

  @override
  Widget build(BuildContext context) {
    final flow = ref.watch(calculationFlowControllerProvider);
    final controller = ref.read(calculationFlowControllerProvider.notifier);

    // Keep external state edits (e.g. tests calling controller directly)
    // in sync with the local TextEditingController text.
    if (_cityController.text != flow.birthCity) {
      _cityController.value = TextEditingValue(
        text: flow.birthCity,
        selection: TextSelection.collapsed(offset: flow.birthCity.length),
      );
    }
    if (_labelController.text != flow.label) {
      _labelController.value = TextEditingValue(
        text: flow.label,
        selection: TextSelection.collapsed(offset: flow.label.length),
      );
    }

    return CalcStepScaffold(
      step: CalculationFlowStep.birth,
      title: context.l10n.birthDataTitle,
      onBack: () => context.go(RoutePaths.home),
      primaryAction: PrimaryButton(
        label: context.l10n.commonContinue,
        icon: AppIcons.forward,
        onPressed: flow.birthStepValid
            ? () {
                FocusScope.of(context).unfocus();
                controller.next();
                context.go(RoutePaths.calcWindow);
              }
            : null,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DatePickerField(
            label: context.l10n.birthDataDateLabel,
            placeholder: context.l10n.birthDataDatePlaceholder,
            formattedValue: _formattedDate(flow.birthDate),
            onTap: _pickDate,
          ),
          const SizedBox(height: AppSpacing.s4),
          InputField(
            key: const ValueKey<String>('calc-birth-city-field'),
            label: context.l10n.birthDataCityLabel,
            hintText: context.l10n.birthDataCityHint,
            controller: _cityController,
            leading: const Icon(
              AppIcons.search,
              size: 20,
              color: AppColors.inkMuted,
            ),
            onChanged: _onCityChanged,
          ),
          if (_searching || _suggestions.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.s2),
              child: _SuggestionsPanel(
                searching: _searching,
                suggestions: _suggestions,
                onSelect: _selectPlace,
              ),
            ),
          const SizedBox(height: AppSpacing.s4),
          InputField(
            label: context.l10n.birthDataLabelLabel,
            helperText: context.l10n.birthDataLabelHelper,
            controller: _labelController,
            hintText: context.l10n.birthDataLabelHint,
            onChanged: controller.setLabel,
          ),
        ],
      ),
    );
  }
}

class _SuggestionsPanel extends StatelessWidget {
  const _SuggestionsPanel({
    required this.searching,
    required this.suggestions,
    required this.onSelect,
  });

  final bool searching;
  final List<GeoPlace> suggestions;
  final ValueChanged<GeoPlace> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: AppRadius.brSm,
        border: Border.all(color: AppColors.inkLine),
      ),
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s2),
      child: searching
          ? Padding(
              padding: const EdgeInsets.all(AppSpacing.s4),
              child: Text(
                context.l10n.birthDataSearching,
                style: AppTypography.bodyMd.copyWith(color: AppColors.inkSoft),
              ),
            )
          : suggestions.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(AppSpacing.s4),
              child: Text(
                context.l10n.birthDataNoMatches,
                style: AppTypography.bodyMd.copyWith(color: AppColors.inkSoft),
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                for (var i = 0; i < suggestions.length; i++) ...<Widget>[
                  InkWell(
                    onTap: () => onSelect(suggestions[i]),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.s4,
                        vertical: AppSpacing.s3,
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  suggestions[i].displayName,
                                  style: AppTypography.bodyMd,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (suggestions[i].region != null)
                                  Text(
                                    suggestions[i].region!,
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
                  ),
                  if (i < suggestions.length - 1)
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.inkLineSoft,
                    ),
                ],
              ],
            ),
    );
  }
}
