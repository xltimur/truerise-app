import 'package:flutter/material.dart';

import 'package:rectify/theme/colors.dart';
import 'package:rectify/theme/elevations.dart';
import 'package:rectify/theme/motion.dart';
import 'package:rectify/theme/radius.dart';

/// `ThemeExtension` for tokens that don't have a natural home on `ThemeData`.
///
/// Holds the confidence scale, brand accents, deep navy, and the elevation
/// shadow lists, so widgets can pull them via
/// `Theme.of(context).extension<RectifyTokens>()!`.
@immutable
class RectifyTokens extends ThemeExtension<RectifyTokens> {
  const RectifyTokens({
    required this.bgCanvas,
    required this.bgSurfaceSunken,
    required this.inkMuted,
    required this.inkSoft,
    required this.inkFaint,
    required this.inkLine,
    required this.inkLineSoft,
    required this.accentClayHover,
    required this.accentClayDeep,
    required this.accentClayTint,
    required this.accentClayLine,
    required this.deepMidnight,
    required this.deepMidnightSoft,
    required this.deepMidnightTint,
    required this.deepInkOnMidnight,
    required this.confidenceStrong,
    required this.confidenceModerate,
    required this.confidenceWeak,
    required this.confidenceNone,
    required this.confidenceBarHigh,
    required this.confidenceBarMid,
    required this.confidenceBarLow,
    required this.statusSuccess,
    required this.statusWarning,
    required this.statusDanger,
    required this.statusInfo,
    required this.elevation1,
    required this.elevation2,
    required this.radiusCard,
    required this.radiusHero,
    required this.motionReveal,
    required this.curveReveal,
  });

  factory RectifyTokens.standard() => const RectifyTokens(
    bgCanvas: AppColors.bgCanvas,
    bgSurfaceSunken: AppColors.bgSurfaceSunken,
    inkMuted: AppColors.inkMuted,
    inkSoft: AppColors.inkSoft,
    inkFaint: AppColors.inkFaint,
    inkLine: AppColors.inkLine,
    inkLineSoft: AppColors.inkLineSoft,
    accentClayHover: AppColors.accentClayHover,
    accentClayDeep: AppColors.accentClayDeep,
    accentClayTint: AppColors.accentClayTint,
    accentClayLine: AppColors.accentClayLine,
    deepMidnight: AppColors.deepMidnight,
    deepMidnightSoft: AppColors.deepMidnightSoft,
    deepMidnightTint: AppColors.deepMidnightTint,
    deepInkOnMidnight: AppColors.deepInkOnMidnight,
    confidenceStrong: AppColors.confidenceStrong,
    confidenceModerate: AppColors.confidenceModerate,
    confidenceWeak: AppColors.confidenceWeak,
    confidenceNone: AppColors.confidenceNone,
    confidenceBarHigh: AppColors.confidenceBarHigh,
    confidenceBarMid: AppColors.confidenceBarMid,
    confidenceBarLow: AppColors.confidenceBarLow,
    statusSuccess: AppColors.statusSuccess,
    statusWarning: AppColors.statusWarning,
    statusDanger: AppColors.statusDanger,
    statusInfo: AppColors.statusInfo,
    elevation1: AppElevations.level1,
    elevation2: AppElevations.level2,
    radiusCard: AppRadius.brMd,
    radiusHero: AppRadius.brXl,
    motionReveal: AppMotion.reveal,
    curveReveal: AppMotion.curveReveal,
  );

  final Color bgCanvas;
  final Color bgSurfaceSunken;
  final Color inkMuted;
  final Color inkSoft;
  final Color inkFaint;
  final Color inkLine;
  final Color inkLineSoft;
  final Color accentClayHover;
  final Color accentClayDeep;
  final Color accentClayTint;
  final Color accentClayLine;
  final Color deepMidnight;
  final Color deepMidnightSoft;
  final Color deepMidnightTint;
  final Color deepInkOnMidnight;
  final Color confidenceStrong;
  final Color confidenceModerate;
  final Color confidenceWeak;
  final Color confidenceNone;
  final Color confidenceBarHigh;
  final Color confidenceBarMid;
  final Color confidenceBarLow;
  final Color statusSuccess;
  final Color statusWarning;
  final Color statusDanger;
  final Color statusInfo;
  final List<BoxShadow> elevation1;
  final List<BoxShadow> elevation2;
  final BorderRadius radiusCard;
  final BorderRadius radiusHero;
  final Duration motionReveal;
  final Curve curveReveal;

  @override
  RectifyTokens copyWith({
    Color? bgCanvas,
    Color? bgSurfaceSunken,
    Color? inkMuted,
    Color? inkSoft,
    Color? inkFaint,
    Color? inkLine,
    Color? inkLineSoft,
    Color? accentClayHover,
    Color? accentClayDeep,
    Color? accentClayTint,
    Color? accentClayLine,
    Color? deepMidnight,
    Color? deepMidnightSoft,
    Color? deepMidnightTint,
    Color? deepInkOnMidnight,
    Color? confidenceStrong,
    Color? confidenceModerate,
    Color? confidenceWeak,
    Color? confidenceNone,
    Color? confidenceBarHigh,
    Color? confidenceBarMid,
    Color? confidenceBarLow,
    Color? statusSuccess,
    Color? statusWarning,
    Color? statusDanger,
    Color? statusInfo,
    List<BoxShadow>? elevation1,
    List<BoxShadow>? elevation2,
    BorderRadius? radiusCard,
    BorderRadius? radiusHero,
    Duration? motionReveal,
    Curve? curveReveal,
  }) => RectifyTokens(
    bgCanvas: bgCanvas ?? this.bgCanvas,
    bgSurfaceSunken: bgSurfaceSunken ?? this.bgSurfaceSunken,
    inkMuted: inkMuted ?? this.inkMuted,
    inkSoft: inkSoft ?? this.inkSoft,
    inkFaint: inkFaint ?? this.inkFaint,
    inkLine: inkLine ?? this.inkLine,
    inkLineSoft: inkLineSoft ?? this.inkLineSoft,
    accentClayHover: accentClayHover ?? this.accentClayHover,
    accentClayDeep: accentClayDeep ?? this.accentClayDeep,
    accentClayTint: accentClayTint ?? this.accentClayTint,
    accentClayLine: accentClayLine ?? this.accentClayLine,
    deepMidnight: deepMidnight ?? this.deepMidnight,
    deepMidnightSoft: deepMidnightSoft ?? this.deepMidnightSoft,
    deepMidnightTint: deepMidnightTint ?? this.deepMidnightTint,
    deepInkOnMidnight: deepInkOnMidnight ?? this.deepInkOnMidnight,
    confidenceStrong: confidenceStrong ?? this.confidenceStrong,
    confidenceModerate: confidenceModerate ?? this.confidenceModerate,
    confidenceWeak: confidenceWeak ?? this.confidenceWeak,
    confidenceNone: confidenceNone ?? this.confidenceNone,
    confidenceBarHigh: confidenceBarHigh ?? this.confidenceBarHigh,
    confidenceBarMid: confidenceBarMid ?? this.confidenceBarMid,
    confidenceBarLow: confidenceBarLow ?? this.confidenceBarLow,
    statusSuccess: statusSuccess ?? this.statusSuccess,
    statusWarning: statusWarning ?? this.statusWarning,
    statusDanger: statusDanger ?? this.statusDanger,
    statusInfo: statusInfo ?? this.statusInfo,
    elevation1: elevation1 ?? this.elevation1,
    elevation2: elevation2 ?? this.elevation2,
    radiusCard: radiusCard ?? this.radiusCard,
    radiusHero: radiusHero ?? this.radiusHero,
    motionReveal: motionReveal ?? this.motionReveal,
    curveReveal: curveReveal ?? this.curveReveal,
  );

  @override
  RectifyTokens lerp(ThemeExtension<RectifyTokens>? other, double t) {
    if (other is! RectifyTokens) return this;
    return RectifyTokens(
      bgCanvas: Color.lerp(bgCanvas, other.bgCanvas, t)!,
      bgSurfaceSunken: Color.lerp(bgSurfaceSunken, other.bgSurfaceSunken, t)!,
      inkMuted: Color.lerp(inkMuted, other.inkMuted, t)!,
      inkSoft: Color.lerp(inkSoft, other.inkSoft, t)!,
      inkFaint: Color.lerp(inkFaint, other.inkFaint, t)!,
      inkLine: Color.lerp(inkLine, other.inkLine, t)!,
      inkLineSoft: Color.lerp(inkLineSoft, other.inkLineSoft, t)!,
      accentClayHover: Color.lerp(accentClayHover, other.accentClayHover, t)!,
      accentClayDeep: Color.lerp(accentClayDeep, other.accentClayDeep, t)!,
      accentClayTint: Color.lerp(accentClayTint, other.accentClayTint, t)!,
      accentClayLine: Color.lerp(accentClayLine, other.accentClayLine, t)!,
      deepMidnight: Color.lerp(deepMidnight, other.deepMidnight, t)!,
      deepMidnightSoft: Color.lerp(
        deepMidnightSoft,
        other.deepMidnightSoft,
        t,
      )!,
      deepMidnightTint: Color.lerp(
        deepMidnightTint,
        other.deepMidnightTint,
        t,
      )!,
      deepInkOnMidnight: Color.lerp(
        deepInkOnMidnight,
        other.deepInkOnMidnight,
        t,
      )!,
      confidenceStrong: Color.lerp(
        confidenceStrong,
        other.confidenceStrong,
        t,
      )!,
      confidenceModerate: Color.lerp(
        confidenceModerate,
        other.confidenceModerate,
        t,
      )!,
      confidenceWeak: Color.lerp(confidenceWeak, other.confidenceWeak, t)!,
      confidenceNone: Color.lerp(confidenceNone, other.confidenceNone, t)!,
      confidenceBarHigh: Color.lerp(
        confidenceBarHigh,
        other.confidenceBarHigh,
        t,
      )!,
      confidenceBarMid: Color.lerp(
        confidenceBarMid,
        other.confidenceBarMid,
        t,
      )!,
      confidenceBarLow: Color.lerp(
        confidenceBarLow,
        other.confidenceBarLow,
        t,
      )!,
      statusSuccess: Color.lerp(statusSuccess, other.statusSuccess, t)!,
      statusWarning: Color.lerp(statusWarning, other.statusWarning, t)!,
      statusDanger: Color.lerp(statusDanger, other.statusDanger, t)!,
      statusInfo: Color.lerp(statusInfo, other.statusInfo, t)!,
      elevation1: t < 0.5 ? elevation1 : other.elevation1,
      elevation2: t < 0.5 ? elevation2 : other.elevation2,
      radiusCard: BorderRadius.lerp(radiusCard, other.radiusCard, t)!,
      radiusHero: BorderRadius.lerp(radiusHero, other.radiusHero, t)!,
      motionReveal: t < 0.5 ? motionReveal : other.motionReveal,
      curveReveal: t < 0.5 ? curveReveal : other.curveReveal,
    );
  }
}
