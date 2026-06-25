import 'package:flutter/widgets.dart';

import 'package:rectify/l10n/l10n.dart';
import 'package:rectify/widgets/chips/chip_pill.dart';

/// "DEMO" status pill (`docs/design-system.md` §9.5, §11.6).
///
/// Appears on demo calculation input/review/loading screens, the result
/// hero card, the evidence screen, and demo-result history cards. Never
/// on settings or onboarding.
class DemoPill extends StatelessWidget {
  const DemoPill({this.label, super.key});

  final String? label;

  @override
  Widget build(BuildContext context) {
    final labelText = label ?? context.l10n.demoPillLabel;
    return ChipPill(
      label: labelText,
      variant: ChipPillVariant.status,
      semanticsLabel: context.l10n.demoPillSemantic(labelText),
    );
  }
}
