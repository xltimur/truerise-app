import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:rectify/theme/colors.dart';
import 'package:rectify/theme/radius.dart';
import 'package:rectify/theme/rectify_tokens.dart';
import 'package:rectify/theme/typography.dart';

/// Light theme — the only theme shipped in MVP.
///
/// Dark mode is out of MVP scope (`docs/implementation-plan.md` §2).
ThemeData buildLightTheme() {
  const colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.accentClay,
    onPrimary: AppColors.bgApp,
    secondary: AppColors.deepMidnight,
    onSecondary: AppColors.deepInkOnMidnight,
    error: AppColors.statusDanger,
    onError: AppColors.bgApp,
    surface: AppColors.bgSurface,
    onSurface: AppColors.inkStrong,
    surfaceContainerLowest: AppColors.bgApp,
    surfaceContainerLow: AppColors.bgApp,
    surfaceContainer: AppColors.bgSurface,
    surfaceContainerHigh: AppColors.bgSurface,
    surfaceContainerHighest: AppColors.bgSurfaceSunken,
    outline: AppColors.inkLine,
    outlineVariant: AppColors.inkLineSoft,
  );

  final textTheme = TextTheme(
    displayLarge: AppTypography.displayXl,
    displayMedium: AppTypography.displayLg,
    displaySmall: AppTypography.displayMd,
    headlineMedium: AppTypography.titleLg,
    titleLarge: AppTypography.titleLg,
    titleMedium: AppTypography.titleMd,
    titleSmall: AppTypography.titleSm,
    bodyLarge: AppTypography.bodyLg,
    bodyMedium: AppTypography.bodyMd,
    bodySmall: AppTypography.bodySm,
    labelLarge: AppTypography.labelMd,
    labelMedium: AppTypography.labelMd,
    labelSmall: AppTypography.labelSm,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: AppColors.bgApp,
    canvasColor: AppColors.bgApp,
    textTheme: textTheme,
    splashFactory: InkSparkle.splashFactory,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.bgApp,
      surfaceTintColor: Colors.transparent,
      foregroundColor: AppColors.inkStrong,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: AppTypography.titleLg,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.inkLine,
      thickness: 1,
      space: 1,
    ),
    cardTheme: const CardThemeData(
      color: AppColors.bgSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.brMd,
        side: BorderSide(color: AppColors.inkLine),
      ),
    ),
    extensions: <ThemeExtension<dynamic>>[
      RectifyTokens.standard(),
    ],
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
      },
    ),
    visualDensity: VisualDensity.standard,
    materialTapTargetSize: MaterialTapTargetSize.padded,
  );
}
