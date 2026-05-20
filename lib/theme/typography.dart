import 'package:flutter/material.dart';

import 'package:rectify/theme/colors.dart';

/// Font family names declared under `flutter.fonts` in `pubspec.yaml`.
/// Bundling the TTFs locally (vs. fetching via `google_fonts` at
/// runtime) keeps tests / goldens hermetic and removes the network
/// dependency on the first launch.
abstract final class AppFontFamily {
  static const String sans = 'Inter';
  static const String serif = 'SourceSerif4';
  static const String mono = 'JetBrainsMono';
}

/// Type scale from `docs/design-system.md` §3.
///
/// Three families: Inter (sans), Source Serif 4 (serif), JetBrains Mono
/// (mono). Bundled as `assets/fonts/*.ttf`. Sizes are pt; line-heights
/// are converted to Flutter's unitless `height` multiplier so values
/// match the design-system table exactly.
abstract final class AppTypography {
  static TextStyle _sans({
    required double size,
    required double lineHeight,
    required FontWeight weight,
    double tracking = 0,
    Color color = AppColors.inkBody,
  }) => TextStyle(
    fontFamily: AppFontFamily.sans,
    fontSize: size,
    height: lineHeight / size,
    fontWeight: weight,
    letterSpacing: tracking * size,
    color: color,
  );

  static TextStyle _serif({
    required double size,
    required double lineHeight,
    required FontWeight weight,
    double tracking = 0,
    Color color = AppColors.inkStrong,
  }) => TextStyle(
    fontFamily: AppFontFamily.serif,
    fontSize: size,
    height: lineHeight / size,
    fontWeight: weight,
    letterSpacing: tracking * size,
    color: color,
  );

  static TextStyle _mono({
    required double size,
    required double lineHeight,
    required FontWeight weight,
    double tracking = 0,
    Color color = AppColors.inkStrong,
  }) => TextStyle(
    fontFamily: AppFontFamily.mono,
    fontSize: size,
    height: lineHeight / size,
    fontWeight: weight,
    letterSpacing: tracking * size,
    color: color,
    fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
  );

  // Display (serif)
  static TextStyle get displayXl => _serif(
    size: 56,
    lineHeight: 60,
    weight: FontWeight.w400,
    tracking: -0.02,
  );
  static TextStyle get displayLg => _serif(
    size: 36,
    lineHeight: 42,
    weight: FontWeight.w400,
    tracking: -0.015,
  );
  static TextStyle get displayMd => _serif(
    size: 28,
    lineHeight: 34,
    weight: FontWeight.w400,
    tracking: -0.01,
  );

  // Title (sans)
  static TextStyle get titleLg => _sans(
    size: 22,
    lineHeight: 28,
    weight: FontWeight.w600,
    tracking: -0.01,
    color: AppColors.inkStrong,
  );
  static TextStyle get titleMd => _sans(
    size: 18,
    lineHeight: 24,
    weight: FontWeight.w600,
    tracking: -0.005,
    color: AppColors.inkStrong,
  );
  static TextStyle get titleSm => _sans(
    size: 15,
    lineHeight: 20,
    weight: FontWeight.w600,
    color: AppColors.inkStrong,
  );

  // Body (sans)
  static TextStyle get bodyLg =>
      _sans(size: 17, lineHeight: 26, weight: FontWeight.w400);
  static TextStyle get bodyMd =>
      _sans(size: 15, lineHeight: 22, weight: FontWeight.w400);
  static TextStyle get bodySm => _sans(
    size: 13,
    lineHeight: 18,
    weight: FontWeight.w400,
    tracking: 0.01,
    color: AppColors.inkMuted,
  );

  // Label (sans)
  static TextStyle get labelMd => _sans(
    size: 14,
    lineHeight: 18,
    weight: FontWeight.w500,
    tracking: 0.01,
    color: AppColors.inkStrong,
  );
  static TextStyle get labelSm => _sans(
    size: 12,
    lineHeight: 16,
    weight: FontWeight.w500,
    tracking: 0.04,
    color: AppColors.inkMuted,
  );

  // Mono — used inside displayXl for the result time numerals only.
  static TextStyle get monoXl => _mono(
    size: 56,
    lineHeight: 60,
    weight: FontWeight.w500,
    tracking: -0.02,
  );
}
