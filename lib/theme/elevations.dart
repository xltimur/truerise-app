import 'package:flutter/material.dart';

import 'package:rectify/theme/colors.dart';

/// Elevation tokens from `docs/design-system.md` §6.
///
/// The system is mostly flat; only three levels exist.
abstract final class AppElevations {
  /// elev.0 — flat. Distinguished by borders, not shadow.
  static const List<BoxShadow> level0 = <BoxShadow>[];

  /// elev.1 — floating card, modal.
  static const List<BoxShadow> level1 = <BoxShadow>[
    BoxShadow(
      color: Color(0x0A16181D), // rgba(22,24,29,0.04)
      offset: Offset(0, 1),
      blurRadius: 2,
    ),
    BoxShadow(
      color: Color(0x0D16181D), // rgba(22,24,29,0.05)
      offset: Offset(0, 2),
      blurRadius: 8,
    ),
  ];

  /// elev.2 — bottom sheet, active drag layer.
  static const List<BoxShadow> level2 = <BoxShadow>[
    BoxShadow(
      color: Color(0x0816181D), // rgba(22,24,29,0.03)
      offset: Offset(0, -2),
      blurRadius: 4,
    ),
    BoxShadow(
      color: Color(0x1416181D), // rgba(22,24,29,0.08)
      offset: Offset(0, -8),
      blurRadius: 24,
    ),
  ];

  /// 1pt hairline border used in place of shadow at elev.0.
  static const BorderSide hairline = BorderSide(color: AppColors.inkLine);
}
