import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'screenshot_compositor.dart';

/// Final English five-frame story order used for App Store / Play screenshots.
const List<String> expectedEnglishFinalFrameFiles = <String>[
  '01-problem-hook.png',
  '02-life-events.png',
  '01-result-hero.png',
  '02-evidence-breakdown.png',
  '03-privacy-demo-settings.png',
];

/// Historical five-frame order still used by localized packs until native
/// review and localized final story updates are complete.
const List<String> expectedLegacyLocaleFrameFiles = <String>[
  '01-result-hero.png',
  '02-evidence-breakdown.png',
  '03-privacy-demo-settings.png',
  '04-share-result.png',
  '05-privacy-policy.png',
];

/// Raw English assets kept for optional future use but not part of the final
/// five-frame story.
const List<String> expectedEnglishOptionalRawFrameFiles = <String>[
  '04-share-result.png',
  '05-privacy-policy.png',
];

List<String> expectedManifestFrameFilesForLocale(String locale) =>
    locale == 'en'
    ? expectedEnglishFinalFrameFiles
    : expectedLegacyLocaleFrameFiles;

List<String> expectedRawPngFilesForLocale(String locale) => locale == 'en'
    ? <String>[
        ...expectedEnglishFinalFrameFiles,
        ...expectedEnglishOptionalRawFrameFiles,
      ]
    : expectedLegacyLocaleFrameFiles;

List<String> expectedEnglishCompositedOutputPaths() => <String>[
  for (final fileName in expectedEnglishFinalFrameFiles)
    '$kStoreScreenshotsRoot/en/$kCompositedDirName/$fileName',
];

/// Verifies the repository's committed composited-output state after the
/// English final store story is generated: EN has exactly the final five
/// composites, while every other locale is still blocked pending review.
void expectCommittedCompositedState() {
  for (final locale in supportedStoreLocales) {
    final dir = Directory('$kStoreScreenshotsRoot/$locale/$kCompositedDirName');
    if (locale != 'en') {
      expect(dir.existsSync(), isFalse, reason: dir.path);
      continue;
    }

    expect(dir.existsSync(), isTrue, reason: dir.path);
    final files = dir
        .listSync()
        .whereType<File>()
        .map((file) => file.uri.pathSegments.last)
        .where((name) => name.endsWith('.png'))
        .toList();
    expect(files, unorderedEquals(expectedEnglishFinalFrameFiles));
  }
}
