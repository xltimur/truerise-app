import 'package:flutter/material.dart';

import 'package:rectify/widgets/buttons/_button_shell.dart';

/// Equally-weighted alternative to the primary CTA
/// (`docs/design-system.md` §9.1).
///
/// White surface with a hairline `ink.line` border.
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
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
      variant: RectifyButtonVariant.secondary,
      onPressed: onPressed,
      icon: icon,
      expand: expand,
    );
  }
}
