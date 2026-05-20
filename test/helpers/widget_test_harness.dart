import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rectify/theme/theme.dart';

/// Wraps a widget under test in a `MaterialApp` configured with the
/// Rectify light theme, sized to a phone-shaped viewport, and given a
/// fresh `MediaQuery` so layout assertions don't pick up host defaults.
///
/// Goldens that need a deterministic surface should use this harness
/// so token-level changes flow through in a single update.
Widget wrapInRectifyApp(
  Widget child, {
  Size size = const Size(360, 760),
  TextDirection textDirection = TextDirection.ltr,
  bool reducedMotion = false,
}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: buildLightTheme(),
    home: Directionality(
      textDirection: textDirection,
      child: MediaQuery(
        data: MediaQueryData(
          size: size,
          disableAnimations: reducedMotion,
        ),
        child: Scaffold(
          backgroundColor: buildLightTheme().scaffoldBackgroundColor,
          body: Center(child: child),
        ),
      ),
    ),
  );
}

/// Pump the given [widget] inside [wrapInRectifyApp] and settle a single
/// frame. Convenience for the common case where the widget is a stateless
/// pre-built composition.
Future<void> pumpRectifyWidget(
  WidgetTester tester,
  Widget widget, {
  Size size = const Size(360, 760),
  bool reducedMotion = false,
}) async {
  await tester.pumpWidget(
    wrapInRectifyApp(widget, size: size, reducedMotion: reducedMotion),
  );
  await tester.pump();
}
