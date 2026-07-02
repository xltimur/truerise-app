import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'screenshot_compositor.dart';

/// Final five-frame story order used for App Store / Play screenshots.
const List<String> expectedFinalFrameFiles = <String>[
  '01-problem-hook.png',
  '02-life-events.png',
  '01-result-hero.png',
  '02-evidence-breakdown.png',
  '03-privacy-demo-settings.png',
];

/// Raw assets kept for optional future use but not part of the final
/// five-frame story.
const List<String> expectedOptionalRawFrameFiles = <String>[
  '04-share-result.png',
  '05-privacy-policy.png',
];

List<String> expectedManifestFrameFilesForLocale(String locale) =>
    expectedFinalFrameFiles;

List<String> expectedRawPngFilesForLocale(String locale) => <String>[
  ...expectedFinalFrameFiles,
  ...expectedOptionalRawFrameFiles,
];

List<String> expectedCompositedOutputPathsForLocale(String locale) => <String>[
  for (final fileName in expectedFinalFrameFiles)
    '$kStoreScreenshotsRoot/$locale/$kCompositedDirName/$fileName',
];

List<String> expectedEnglishCompositedOutputPaths() =>
    expectedCompositedOutputPathsForLocale('en');

List<String> expectedAllCompositedOutputPaths() => <String>[
  for (final locale in supportedStoreLocales)
    ...expectedCompositedOutputPathsForLocale(locale),
];

/// Verifies the repository's committed composited-output state after the final
/// five-frame store story is generated for every supported store locale.
void expectCommittedCompositedState() {
  for (final locale in supportedStoreLocales) {
    final dir = Directory('$kStoreScreenshotsRoot/$locale/$kCompositedDirName');
    expect(dir.existsSync(), isTrue, reason: dir.path);
    final files = dir
        .listSync()
        .whereType<File>()
        .map((file) => file.uri.pathSegments.last)
        .where((name) => name.endsWith('.png'))
        .toList();
    expect(files, unorderedEquals(expectedFinalFrameFiles));
  }
}
