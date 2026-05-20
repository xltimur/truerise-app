import 'package:flutter/material.dart';

/// Color tokens from `docs/design-system.md` §2.
///
/// Names mirror design-system token paths
/// (e.g. `bg.app` → `AppColors.bgApp`).
abstract final class AppColors {
  // 2.1 Background scale (warm bone family)
  static const Color bgCanvas = Color(0xFFF1ECE1);
  static const Color bgApp = Color(0xFFFBF8F2);
  static const Color bgSurface = Color(0xFFFFFFFF);
  static const Color bgSurfaceSunken = Color(0xFFF4EFE5);
  static const Color bgSurfaceInverted = Color(0xFF15171C);

  // 2.2 Ink scale
  static const Color inkStrong = Color(0xFF16181D);
  static const Color inkBody = Color(0xFF2E3138);
  static const Color inkMuted = Color(0xFF5C5A54);
  static const Color inkSoft = Color(0xFF85827A);
  static const Color inkFaint = Color(0xFFB1AC9F);
  static const Color inkLine = Color(0xFFE4DFD2);
  static const Color inkLineSoft = Color(0xFFEFEAE0);

  // 2.3 Accent (Rectify Clay)
  static const Color accentClay = Color(0xFFB66A3F);
  static const Color accentClayHover = Color(0xFFA55B33);
  static const Color accentClayDeep = Color(0xFF7A4124);
  static const Color accentClayTint = Color(0xFFF2E3D3);
  static const Color accentClayLine = Color(0xFFE0BFA1);

  // 2.4 Deep contrast (Observatory Navy)
  static const Color deepMidnight = Color(0xFF1B2735);
  static const Color deepMidnightSoft = Color(0xFF2A3A4A);
  static const Color deepMidnightTint = Color(0xFFE3E7EB);
  static const Color deepInkOnMidnight = Color(0xFFFBF8F2);

  // 2.5 Confidence scale
  static const Color confidenceStrong = Color(0xFF5C7355);
  static const Color confidenceModerate = Color(0xFFB07F44);
  static const Color confidenceWeak = Color(0xFF8E867B);
  static const Color confidenceNone = Color(0xFF808892);

  static const Color confidenceBarHigh = Color(0xFF5C7355);
  static const Color confidenceBarMid = Color(0xFFB07F44);
  static const Color confidenceBarLow = Color(0xFF8E867B);

  // 2.6 Semantic
  static const Color statusSuccess = Color(0xFF5C7355);
  static const Color statusWarning = Color(0xFFB07F44);
  static const Color statusDanger = Color(0xFF8E3D2F);
  static const Color statusInfo = Color(0xFF1B2735);
}
