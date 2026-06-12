import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Test-suite bootstrap auto-discovered by `flutter test`.
///
/// Pre-loads the bundled product fonts via [FontLoader] so widget
/// tests and golden comparisons render type with the real
/// Inter / Source Serif 4 / JetBrains Mono shapes instead of the
/// Ahem fallback flutter_test uses by default. (Fonts ship as local
/// assets and the app does no runtime font fetching — the former
/// `google_fonts` dependency and its fetch-disabling safety net were
/// removed once nothing referenced the package.)
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
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
