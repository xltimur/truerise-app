import 'package:flutter/material.dart';

import 'package:rectify/data/models/event_category.dart';
import 'package:rectify/data/models/life_event.dart';
import 'package:rectify/features/calculation_flow/state/calculation_flow_state.dart';
import 'package:rectify/theme/colors.dart';
import 'package:rectify/theme/icons.dart';
import 'package:rectify/theme/radius.dart';
import 'package:rectify/theme/spacing.dart';
import 'package:rectify/theme/typography.dart';
import 'package:rectify/widgets/buttons/buttons.dart';
import 'package:rectify/widgets/inputs/inputs.dart';
import 'package:rectify/widgets/sheets/bottom_sheet_picker.dart';

const _maxDescriptionChars = 200;
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

/// Payload returned by [AddEventSheet.show] when the user submits the
/// form. Untyped strings stay out of the controller surface.
@immutable
class AddEventResult {
  const AddEventResult({
    required this.category,
    required this.year,
    this.month,
    this.description,
  });

  final EventCategory category;
  final int year;
  final int? month;
  final String? description;
}

/// Bottom-sheet form for adding or editing a [LifeEvent]
/// (`docs/ascii-wireframes.md` Screen 4 + 11.4).
///
/// The sheet returns an [AddEventResult] via the navigator pop on
/// "Add" / "Save"; cancel returns `null`. The caller owns the
/// controller side-effects so the sheet stays pure UI.
class AddEventSheet extends StatefulWidget {
  const AddEventSheet({
    this.existing,
    super.key,
  });

  /// Edit mode: hydrate from an existing event and switch the CTA to
  /// "Save changes".
  final LifeEvent? existing;

  static Future<AddEventResult?> show(
    BuildContext context, {
    LifeEvent? existing,
  }) {
    return showModalBottomSheet<AddEventResult>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        final inset = MediaQuery.viewInsetsOf(sheetContext).bottom;
        return Padding(
          padding: EdgeInsets.only(bottom: inset),
          child: AddEventSheet(existing: existing),
        );
      },
    );
  }

  @override
  State<AddEventSheet> createState() => _AddEventSheetState();
}

class _AddEventSheetState extends State<AddEventSheet> {
  late EventCategory? _category;
  late int? _month;
  late int? _year;
  late final TextEditingController _description;

  static const _minYear = 1900;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _category = existing?.category;
    _month = existing?.month;
    _year = existing?.year;
    _description = TextEditingController(text: existing?.description ?? '');
  }

  @override
  void dispose() {
    _description.dispose();
    super.dispose();
  }

  bool get _valid => _category != null && _year != null;

  Future<void> _pickCategory() async {
    final picked = await BottomSheetPicker.show<EventCategory>(
      context: context,
      title: 'Select category',
      value: _category ?? EventCategory.other,
      options: <BottomSheetOption<EventCategory>>[
        for (final category in EventCategory.values)
          BottomSheetOption<EventCategory>(
            value: category,
            label: eventCategoryLabel(category),
          ),
      ],
    );
    if (picked == null) return;
    setState(() => _category = picked);
  }

  Future<void> _pickMonth() async {
    final picked = await BottomSheetPicker.show<int>(
      context: context,
      title: 'Month',
      value: _month ?? 0,
      options: <BottomSheetOption<int>>[
        const BottomSheetOption<int>(value: 0, label: 'No month'),
        for (var i = 1; i <= 12; i++)
          BottomSheetOption<int>(value: i, label: _monthLabels[i]!),
      ],
    );
    if (picked == null) return;
    setState(() => _month = picked == 0 ? null : picked);
  }

  Future<void> _pickYear() async {
    final now = DateTime.now();
    final years = <int>[
      for (var y = now.year; y >= _minYear; y--) y,
    ];
    final picked = await BottomSheetPicker.show<int>(
      context: context,
      title: 'Year',
      value: _year ?? now.year,
      options: <BottomSheetOption<int>>[
        for (final y in years)
          BottomSheetOption<int>(value: y, label: y.toString()),
      ],
    );
    if (picked == null) return;
    setState(() => _year = picked);
  }

  void _submit() {
    if (!_valid) return;
    Navigator.of(context).pop(
      AddEventResult(
        category: _category!,
        year: _year!,
        month: _month,
        description: _description.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: AppRadius.lg),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.vertical(top: AppRadius.lg),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.s6,
              AppSpacing.s4,
              AppSpacing.s6,
              AppSpacing.s6,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.inkLine,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  Text(
                    isEdit ? 'Edit life event' : 'Add life event',
                    style: AppTypography.titleMd,
                  ),
                  const SizedBox(height: AppSpacing.s5),
                  _PickerRow(
                    label: 'Category',
                    value: _category == null
                        ? ''
                        : eventCategoryLabel(_category!),
                    placeholder: 'Choose category',
                    onTap: _pickCategory,
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: _PickerRow(
                          label: 'Month',
                          value: _month == null ? '' : _monthLabels[_month]!,
                          placeholder: 'Month',
                          onTap: _pickMonth,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s3),
                      Expanded(
                        child: _PickerRow(
                          label: 'Year',
                          value: _year == null ? '' : _year.toString(),
                          placeholder: 'Year',
                          onTap: _pickYear,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      'Month is optional.',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.inkSoft,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  InputField(
                    label: 'Description (optional)',
                    controller: _description,
                    hintText: 'Anything that helps narrow timing',
                    keyboardType: TextInputType.multiline,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: ValueListenableBuilder<TextEditingValue>(
                      valueListenable: _description,
                      builder: (context, value, _) {
                        final length = value.text.characters.length;
                        return Text(
                          '$length / $_maxDescriptionChars',
                          style: AppTypography.bodySm.copyWith(
                            color: length > _maxDescriptionChars
                                ? AppColors.statusDanger
                                : AppColors.inkSoft,
                          ),
                          textAlign: TextAlign.end,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s5),
                  PrimaryButton(
                    label: isEdit ? 'Save changes' : 'Add event',
                    icon: AppIcons.check,
                    onPressed: _valid ? _submit : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PickerRow extends StatelessWidget {
  const _PickerRow({
    required this.label,
    required this.value,
    required this.placeholder,
    required this.onTap,
  });

  final String label;
  final String value;
  final String placeholder;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DatePickerField(
      label: label,
      formattedValue: value,
      placeholder: placeholder,
      onTap: onTap,
    );
  }
}
