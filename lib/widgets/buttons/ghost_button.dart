import 'package:flutter/material.dart';

import 'package:rectify/widgets/buttons/_button_shell.dart';

/// Tertiary, in-line ghost button (`docs/design-system.md` §9.1).
///
/// No background, no border, clay-deep label. Used for "Skip", "Cancel",
/// and other low-emphasis affordances. 44pt tall to keep the
/// hit-target at HIG minimum while looking inline.
class GhostButton extends StatelessWidget {
  const GhostButton({
    required this.label,
    this.onPressed,
    this.icon,
    this.expand = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    return RectifyButtonShell(
      label: label,
      variant: RectifyButtonVariant.ghost,
      onPressed: onPressed,
      icon: icon,
      expand: expand,
    );
  }
}
