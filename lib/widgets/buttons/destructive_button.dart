import 'package:flutter/material.dart';

import 'package:rectify/widgets/buttons/_button_shell.dart';

/// Destructive action button (`docs/design-system.md` §9.1).
///
/// Reserved for "Delete all data" and swipe-delete confirmation —
/// never for cancel-like actions. Renders in deep terracotta
/// (`status.danger`), not stop-sign red.
class DestructiveButton extends StatelessWidget {
  const DestructiveButton({
    required this.label,
    this.onPressed,
    this.icon,
    this.expand = true,
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
      variant: RectifyButtonVariant.destructive,
      onPressed: onPressed,
      icon: icon,
      expand: expand,
    );
  }
}
