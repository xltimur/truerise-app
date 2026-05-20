import 'package:flutter/animation.dart';

/// Motion tokens from `docs/design-system.md` §8.
abstract final class AppMotion {
  static const Duration instant = Duration.zero;
  static const Duration short = Duration(milliseconds: 150);
  static const Duration medium = Duration(milliseconds: 250);
  static const Duration long = Duration(milliseconds: 400);
  static const Duration reveal = Duration(milliseconds: 600);

  static const Curve curveShort = Curves.easeOut;
  static const Curve curveMedium = Curves.easeOutCubic;
  static const Curve curveLong = Curves.easeOutCubic;
  static const Curve curveReveal = Cubic(0.16, 1, 0.3, 1);
}
