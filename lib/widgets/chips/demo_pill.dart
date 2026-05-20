import 'package:flutter/widgets.dart';

import 'package:rectify/widgets/chips/chip_pill.dart';

/// "DEMO" status pill (`docs/design-system.md` §9.5, §11.6).
///
/// Appears on the calculation loading screen, the result hero card,
/// the evidence screen, and demo-result history cards. Never on
/// settings, onboarding, or input screens.
class DemoPill extends StatelessWidget {
  const DemoPill({this.label = 'DEMO', super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return ChipPill(
      label: label,
      variant: ChipPillVariant.status,
      semanticsLabel: '$label calculation badge',
    );
  }
}
