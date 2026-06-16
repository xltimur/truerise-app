import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'raw_screenshot_capture.dart';
import 'screenshot_compositor.dart';

/// Raw screenshot file names every locale folder under
/// `screenshots/store/<locale>` is expected to ship, in manifest order.
const List<String> _expectedFrameFiles = <String>[
  '01-result-hero.png',
  '02-evidence-breakdown.png',
  '03-privacy-demo-settings.png',
  '04-share-result.png',
  '05-privacy-policy.png',
];

/// Repository-relative manifest path for [locale].
File _manifestFile(String locale) =>
    File('$kStoreScreenshotsRoot/$locale/manifest.json');

/// Reads and decodes the manifest for [locale] as a JSON object.
Map<String, dynamic> _readManifest(String locale) =>
    jsonDecode(_manifestFile(locale).readAsStringSync())
        as Map<String, dynamic>;

/// The `file` value of every manifest frame for [locale], in manifest order.
List<String> _frameFiles(String locale) =>
    (_readManifest(locale)['frames'] as List<dynamic>)
        .map((frame) => (frame as Map<String, dynamic>)['file'] as String)
        .toList();

/// Last path segment of [path], tolerant of either separator and a trailing
/// slash, so directory and file listings yield bare names.
String _baseName(String path) {
  final normalized = path.replaceAll(r'\', '/');
  final segments = normalized.split('/').where((s) => s.isNotEmpty).toList();
  return segments.isEmpty ? normalized : segments.last;
}

void main() {
  group('store screenshot inventory', () {
    test('top-level store dirs are exactly the locales plus only clearly '
        'labeled draft scratch folders', () {
      final dirNames = Directory(kStoreScreenshotsRoot)
          .listSync()
          .whereType<Directory>()
          .map((dir) => _baseName(dir.path))
          .toList();

      // Every shipped locale pack is present exactly once, with no stray
      // canonical-locale directory.
      final localeDirs = dirNames.where(isSupportedStoreLocale).toList();
      expect(localeDirs, unorderedEquals(supportedStoreLocales));

      // The only other thing allowed beside the locale packs is a draft
      // scratch folder, which can never be a supported locale and so can never
      // be consumed by the compositor (it rejects the segment).
      final nonLocaleDirs = dirNames
          .where((name) => !isSupportedStoreLocale(name))
          .toList();
      for (final name in nonLocaleDirs) {
        expect(isDraftScreenshotDirName(name), isTrue, reason: name);
      }
    });
  });

  for (final locale in supportedStoreLocales) {
    group('store screenshots for locale "$locale"', () {
      test('manifest.json exists and parses as a JSON object', () {
        expect(_manifestFile(locale).existsSync(), isTrue);
        expect(_readManifest(locale), isA<Map<String, dynamic>>());
      });

      test('manifest locale (locale ?? storeLocale) matches the folder', () {
        final manifest = _readManifest(locale);
        expect(manifest['locale'] ?? manifest['storeLocale'], locale);
      });

      test('manifest device geometry matches the raw screenshot core', () {
        final device = _readManifest(locale)['device'] as Map<String, dynamic>;
        expect(device['pixelWidth'], kRawScreenshotWidth);
        expect(device['pixelHeight'], kRawScreenshotHeight);
      });

      test('manifest frame files equal the expected ordered set', () {
        expect(_frameFiles(locale), orderedEquals(_expectedFrameFiles));
      });

      test('every manifest frame file is a valid raw screenshot name', () {
        for (final name in _frameFiles(locale)) {
          expect(isRawScreenshotFileName(name), isTrue, reason: name);
        }
      });

      test('every manifest frame exists as a raw file on disk', () {
        for (final name in _frameFiles(locale)) {
          final rawPath = rawScreenshotPath(locale, name);
          expect(File(rawPath).existsSync(), isTrue, reason: rawPath);
        }
      });

      test('every composited target is distinct from its raw source', () {
        for (final name in _frameFiles(locale)) {
          final target = resolveCompositedTarget(locale, name);
          expect(target.outputPath, isNot(target.rawPath));
          expect(target.outputPath, contains('/composited/'));
        }
      });

      test('folder holds exactly the five expected png files', () {
        final pngNames = Directory('$kStoreScreenshotsRoot/$locale')
            .listSync()
            .whereType<File>()
            .map((file) => _baseName(file.path))
            .where((name) => name.endsWith('.png'))
            .toList();
        expect(pngNames, unorderedEquals(_expectedFrameFiles));
      });

      test('folder has no composited directory', () {
        final composited = Directory(
          '$kStoreScreenshotsRoot/$locale/$kCompositedDirName',
        );
        expect(composited.existsSync(), isFalse);
      });
    });
  }
}
