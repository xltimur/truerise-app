import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

/// Test-suite bootstrap auto-discovered by `flutter test`.
///
/// Two responsibilities:
///   1. Disable `google_fonts` runtime fetching so any leftover
///      reference to the package does not hit the network in the
///      sandbox. (`AppTypography` no longer uses google_fonts at all
///      — fonts are bundled — but the safety net stays in place in
///      case downstream features regress.)
///   2. Pre-load the bundled product fonts via [FontLoader] so widget
///      tests and golden comparisons render type with the real
///      Inter / Source Serif 4 / JetBrains Mono shapes instead of the
///      Ahem fallback flutter_test uses by default.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;
  await _loadAppFonts();
  await testMain();
}

Future<void> _loadAppFonts() async {
  Future<void> loadFamily(
    String family,
    List<String> assetPaths,
  ) async {
    final loader = FontLoader(family);
    for (final assetPath in assetPaths) {
      loader.addFont(rootBundle.load(assetPath));
    }
    await loader.load();
  }

  await loadFamily('Inter', <String>[
    'assets/fonts/Inter-Regular.ttf',
    'assets/fonts/Inter-Medium.ttf',
    'assets/fonts/Inter-SemiBold.ttf',
  ]);
  await loadFamily('SourceSerif4', <String>[
    'assets/fonts/SourceSerif4-Regular.ttf',
  ]);
  await loadFamily('JetBrainsMono', <String>[
    'assets/fonts/JetBrainsMono-Medium.ttf',
  ]);
}
