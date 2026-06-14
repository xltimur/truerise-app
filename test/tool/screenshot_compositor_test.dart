import 'package:flutter_test/flutter_test.dart';

import 'screenshot_compositor.dart';

/// Raw screenshot file names that exist under every locale folder in
/// `screenshots/store/<locale>` (see each folder's manifest.json).
const List<String> _rawScreenshotFileNames = <String>[
  '01-result-hero.png',
  '02-evidence-breakdown.png',
  '03-privacy-demo-settings.png',
  '04-share-result.png',
  '05-privacy-policy.png',
];

void main() {
  group('supported store locales', () {
    test('cover exactly the locale folders that exist on disk', () {
      expect(
        supportedStoreLocales,
        orderedEquals(<String>['en', 'de', 'fr', 'es', 'pt-BR']),
      );
    });

    test('every supported locale is recognized', () {
      for (final locale in supportedStoreLocales) {
        expect(isSupportedStoreLocale(locale), isTrue, reason: locale);
      }
    });

    test('unsupported or unsafe locales are rejected', () {
      const unsafe = <String>[
        '',
        '../en',
        'en/evil',
        '/en',
        'en ',
        'EN',
        'pt',
      ];
      for (final locale in unsafe) {
        expect(
          isSupportedStoreLocale(locale),
          isFalse,
          reason: 'locale: "$locale"',
        );
      }
    });
  });

  group('raw screenshot filename recognition', () {
    test('recognizes the NN-slug.png names from the store folders', () {
      for (final name in _rawScreenshotFileNames) {
        expect(isRawScreenshotFileName(name), isTrue, reason: name);
      }
    });

    test('rejects unsafe or malformed file names', () {
      const malformed = <String>[
        '',
        'result-hero.png', // no NN order prefix
        '01-result-hero.jpg', // not a png
        '1-result-hero.png', // single-digit prefix
        'sub/01-result-hero.png', // path separator
        r'..\01-result-hero.png', // backslash separator
        '../01-result-hero.png', // parent-directory escape
        '/01-result-hero.png', // absolute path
        '01-Result-Hero.png', // uppercase slug
      ];
      for (final name in malformed) {
        expect(
          isRawScreenshotFileName(name),
          isFalse,
          reason: 'name: "$name"',
        );
      }
    });

    test('accepts multi-segment lowercase alphanumeric slugs', () {
      const valid = <String>[
        '01-hero.png',
        '12-result-screen.png',
        '99-v2.png',
      ];
      for (final name in valid) {
        expect(isRawScreenshotFileName(name), isTrue, reason: name);
      }
    });

    test('rejects empty, leading, trailing, or doubled hyphen slugs', () {
      const malformed = <String>[
        '01-.png', // empty slug
        '01--hero.png', // doubled hyphen between segments
        '01-hero-.png', // trailing hyphen
        '01-hero--screen.png', // doubled hyphen between segments
        '01--.png', // empty segments around a hyphen
        '01-_hero.png', // underscore is not a slug character
        '01_Hero.png', // underscore separator and uppercase
      ];
      for (final name in malformed) {
        expect(
          isRawScreenshotFileName(name),
          isFalse,
          reason: 'name: "$name"',
        );
      }
    });
  });

  group('composited output path derivation', () {
    test('derives the example en/01-result-hero.png target', () {
      expect(
        compositedOutputPath('en', '01-result-hero.png'),
        'screenshots/store/en/composited/01-result-hero.png',
      );
    });

    test('derives a composited path for every supported locale', () {
      for (final locale in supportedStoreLocales) {
        expect(
          compositedOutputPath(locale, '01-result-hero.png'),
          'screenshots/store/$locale/composited/01-result-hero.png',
          reason: locale,
        );
      }
    });

    test('raw path mirrors the source layout without a composited segment', () {
      expect(
        rawScreenshotPath('en', '01-result-hero.png'),
        'screenshots/store/en/01-result-hero.png',
      );
    });

    test('throws ArgumentError for invalid locales', () {
      const badLocales = <String>['', '../en', 'en/evil', '/en'];
      for (final locale in badLocales) {
        expect(
          () => compositedOutputPath(locale, '01-result-hero.png'),
          throwsArgumentError,
          reason: 'locale: "$locale"',
        );
      }
    });

    test('throws ArgumentError for invalid file names', () {
      const badNames = <String>[
        '',
        '../01-result-hero.png',
        'sub/01-result-hero.png',
        '/01-result-hero.png',
        '01-result-hero.jpg',
        'result-hero.png',
      ];
      for (final name in badNames) {
        expect(
          () => compositedOutputPath('en', name),
          throwsArgumentError,
          reason: 'name: "$name"',
        );
      }
    });
  });

  group('collision guard', () {
    test('output differs from the raw source and lives under composited', () {
      for (final locale in supportedStoreLocales) {
        final target = resolveCompositedTarget(locale, '01-result-hero.png');
        expect(target.outputPath, isNot(target.rawPath));
        expect(target.outputPath, contains('/composited/'));
        expect(target.rawPath, isNot(contains('/composited/')));
        expect(
          target.outputPath,
          startsWith('$kStoreScreenshotsRoot/$locale/$kCompositedDirName/'),
        );
      }
    });

    test('every supported raw screenshot maps to a unique output', () {
      final outputs = <String>{};
      for (final locale in supportedStoreLocales) {
        for (final name in _rawScreenshotFileNames) {
          final target = resolveCompositedTarget(locale, name);
          expect(target.outputPath, isNot(target.rawPath));
          expect(
            outputs.add(target.outputPath),
            isTrue,
            reason: 'duplicate output: ${target.outputPath}',
          );
        }
      }
      expect(outputs, hasLength(supportedStoreLocales.length * 5));
    });
  });

  group('store screenshot layout', () {
    final layout = StoreScreenshotLayout.standard();

    test('uses the 1290x2796 raw canvas', () {
      expect(kRawScreenshotWidth, 1290);
      expect(kRawScreenshotHeight, 2796);
      expect(layout.canvasWidth, kRawScreenshotWidth.toDouble());
      expect(layout.canvasHeight, kRawScreenshotHeight.toDouble());
    });

    test('caption band is positive and fully inside the canvas', () {
      final band = layout.captionBand;
      expect(band.width, greaterThan(0));
      expect(band.height, greaterThan(0));
      expect(band.left, greaterThanOrEqualTo(0));
      expect(band.top, greaterThanOrEqualTo(0));
      expect(band.right, lessThanOrEqualTo(layout.canvasWidth));
      expect(band.bottom, lessThanOrEqualTo(layout.canvasHeight));
    });

    test('device frame is positive and inside the canvas', () {
      final frame = layout.deviceFrame;
      expect(frame.width, greaterThan(0));
      expect(frame.height, greaterThan(0));
      expect(frame.left, greaterThanOrEqualTo(0));
      expect(frame.top, greaterThanOrEqualTo(0));
      expect(frame.right, lessThanOrEqualTo(layout.canvasWidth));
      expect(frame.bottom, lessThanOrEqualTo(layout.canvasHeight));
    });

    test('device frame sits below the caption band without overlap', () {
      expect(
        layout.deviceFrame.top,
        greaterThanOrEqualTo(layout.captionBand.bottom),
      );
    });
  });

  group('store screenshot output profiles', () {
    test('expose the expected ids and dimensions', () {
      final byId = <String, StoreScreenshotOutputProfile>{
        for (final p in storeScreenshotOutputProfiles) p.id: p,
      };
      expect(
        byId.keys,
        containsAll(<String>['iphone-6-7', 'iphone-6-5', 'google-play-phone']),
      );
      expect(byId['iphone-6-7']!.width, 1290);
      expect(byId['iphone-6-7']!.height, 2796);
      expect(byId['iphone-6-5']!.width, 1242);
      expect(byId['iphone-6-5']!.height, 2688);
      expect(byId['google-play-phone']!.width, 1080);
      expect(byId['google-play-phone']!.height, 1920);
    });

    test('have unique, safe ids and positive dimensions', () {
      final ids = storeScreenshotOutputProfiles.map((p) => p.id).toList();
      expect(ids.toSet(), hasLength(ids.length), reason: 'duplicate id: $ids');
      for (final p in storeScreenshotOutputProfiles) {
        expect(isSafeOutputProfileId(p.id), isTrue, reason: p.id);
        expect(p.label, isNotEmpty, reason: p.id);
        expect(p.width, greaterThan(0), reason: p.id);
        expect(p.height, greaterThan(0), reason: p.id);
        expect(p.widthPx, p.width.toDouble(), reason: p.id);
        expect(p.heightPx, p.height.toDouble(), reason: p.id);
      }
    });

    test('rejects unsafe profile ids', () {
      const unsafe = <String>[
        '',
        'iPhone-6-7',
        'iphone_6_7',
        '../iphone',
        'iphone/6/7',
        'iphone-',
        '-iphone',
        'iphone--6',
      ];
      for (final id in unsafe) {
        expect(isSafeOutputProfileId(id), isFalse, reason: 'id: "$id"');
      }
    });

    test('default iphone-6-7 profile matches the raw canvas constants', () {
      final profile = storeScreenshotOutputProfiles.firstWhere(
        (p) => p.id == 'iphone-6-7',
      );
      expect(profile.width, kRawScreenshotWidth);
      expect(profile.height, kRawScreenshotHeight);
    });
  });

  group('store screenshot layout per profile', () {
    test('forProfile canvas matches the profile and stays well-formed', () {
      for (final profile in storeScreenshotOutputProfiles) {
        final layout = StoreScreenshotLayout.forProfile(profile);
        final band = layout.captionBand;
        final frame = layout.deviceFrame;

        // Canvas exactly matches the requested output profile.
        expect(layout.canvasWidth, profile.widthPx, reason: profile.id);
        expect(layout.canvasHeight, profile.heightPx, reason: profile.id);

        // Caption band positive and fully inside the canvas.
        expect(band.width, greaterThan(0), reason: profile.id);
        expect(band.height, greaterThan(0), reason: profile.id);
        expect(band.left, greaterThanOrEqualTo(0), reason: profile.id);
        expect(band.top, greaterThanOrEqualTo(0), reason: profile.id);
        expect(
          band.right,
          lessThanOrEqualTo(layout.canvasWidth),
          reason: profile.id,
        );
        expect(
          band.bottom,
          lessThanOrEqualTo(layout.canvasHeight),
          reason: profile.id,
        );

        // Device frame positive and fully inside the canvas.
        expect(frame.width, greaterThan(0), reason: profile.id);
        expect(frame.height, greaterThan(0), reason: profile.id);
        expect(frame.left, greaterThanOrEqualTo(0), reason: profile.id);
        expect(frame.top, greaterThanOrEqualTo(0), reason: profile.id);
        expect(
          frame.right,
          lessThanOrEqualTo(layout.canvasWidth),
          reason: profile.id,
        );
        expect(
          frame.bottom,
          lessThanOrEqualTo(layout.canvasHeight),
          reason: profile.id,
        );

        // No overlap: the device frame sits below the caption band.
        expect(
          frame.top,
          greaterThanOrEqualTo(band.bottom),
          reason: profile.id,
        );

        // Google Play tagline guidance: caption band <= 20% of canvas height.
        expect(
          band.height,
          lessThanOrEqualTo(0.2 * layout.canvasHeight),
          reason: profile.id,
        );
      }
    });

    test('forProfile for iphone-6-7 equals the standard layout exactly', () {
      final profile = storeScreenshotOutputProfiles.firstWhere(
        (p) => p.id == 'iphone-6-7',
      );
      final viaProfile = StoreScreenshotLayout.forProfile(profile);
      final standard = StoreScreenshotLayout.standard();

      expect(viaProfile.canvasWidth, standard.canvasWidth);
      expect(viaProfile.canvasHeight, standard.canvasHeight);
      expect(viaProfile.captionBand.left, standard.captionBand.left);
      expect(viaProfile.captionBand.top, standard.captionBand.top);
      expect(viaProfile.captionBand.width, standard.captionBand.width);
      expect(viaProfile.captionBand.height, standard.captionBand.height);
      expect(viaProfile.deviceFrame.left, standard.deviceFrame.left);
      expect(viaProfile.deviceFrame.top, standard.deviceFrame.top);
      expect(viaProfile.deviceFrame.width, standard.deviceFrame.width);
      expect(viaProfile.deviceFrame.height, standard.deviceFrame.height);
    });
  });
}
