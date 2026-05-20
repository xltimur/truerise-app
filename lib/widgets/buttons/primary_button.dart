import 'package:flutter/material.dart';

import 'package:rectify/widgets/buttons/_button_shell.dart';

/// Primary call-to-action button (`docs/design-system.md` §9.1).
///
/// Clay-filled, 52pt tall, used once per screen as the main action.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    this.onPressed,
    this.icon,
    this.expand = true,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  /// Defaults to `true` because primary CTAs sit at the bottom of
  /// stepped flows (`§10.1`) and need to fill the screen edge gutter.
  /// Set to `false` for inline placements.
  final bool expand;

  @override
  Widget build(BuildContext context) {
    return RectifyButtonShell(
      label: label,
      variant: RectifyButtonVariant.primary,
      onPressed: onPressed,
      icon: icon,
      expand: expand,
    );
  }
}
