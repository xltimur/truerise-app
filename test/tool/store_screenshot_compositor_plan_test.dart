import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'screenshot_compositor.dart';
import 'store_screenshot_compositor_plan.dart';
import 'store_screenshot_compositor_repo_state.dart';

/// Reads and decodes the on-disk manifest for [locale] as a JSON object.
Map<String, dynamic> _readManifest(String locale) =>
    jsonDecode(File(storeManifestPath(locale)).readAsStringSync())
        as Map<String, dynamic>;

/// A single-frame manifest map shaped like a decoded `manifest.json`.
Map<String, dynamic> _manifestWithFrame({
  required Object? file,
  required Object? caption,
}) => <String, dynamic>{
  'frames': <dynamic>[
    <String, dynamic>{'file': file, 'intendedCaption': caption},
  ],
};

void main() {
  group('buildAllCompositeJobs (on-disk plan)', () {
    test('produces one job per manifest frame, grouped by locale', () {
      expectCommittedCompositedState();

      final jobs = buildAllCompositeJobs();

      expect(jobs.length, supportedStoreLocales.length * 5);
      expect(jobs.length, 25);

      // Locales appear as contiguous blocks, in supportedStoreLocales order.
      final localeBlocks = <String>[];
      for (final job in jobs) {
        if (localeBlocks.isEmpty || localeBlocks.last != job.locale) {
          localeBlocks.add(job.locale);
        }
      }
      expect(localeBlocks, orderedEquals(supportedStoreLocales));

      for (final job in jobs) {
        expect(isSupportedStoreLocale(job.locale), isTrue, reason: job.locale);
        expect(job.caption.trim(), isNotEmpty, reason: job.fileName);
        expect(File(job.rawPath).existsSync(), isTrue, reason: job.rawPath);
        expect(job.outputPath, contains('/composited/'));
        expect(job.outputPath, isNot(job.rawPath));
      }

      // Reading the plan must never have created any output directories.
      expectCommittedCompositedState();
    });
  });

  group('buildLocaleCompositeJobs (decoded manifest map)', () {
    test('builds en jobs in manifest frame order', () {
      final jobs = buildLocaleCompositeJobs('en', _readManifest('en'));

      expect(
        jobs.map((job) => job.fileName).toList(),
        orderedEquals(expectedEnglishFinalFrameFiles),
      );
      expect(jobs.first.fileName, '01-problem-hook.png');
      expect(jobs.last.fileName, '03-privacy-demo-settings.png');
      expect(jobs.every((job) => job.locale == 'en'), isTrue);
      expect(jobs.every((job) => job.caption.trim().isNotEmpty), isTrue);
    });

    test('rejects unsafe or malformed frame file names', () {
      const badNames = <String>[
        '01-bad name.png',
        '1-result.png',
        '01-result.jpg',
        '01-result-hero',
        '../01-result-hero.png',
        'sub/01-result-hero.png',
        '01--double.png',
      ];
      for (final bad in badNames) {
        expect(
          () => buildLocaleCompositeJobs(
            'en',
            _manifestWithFrame(file: bad, caption: 'A valid caption'),
          ),
          throwsArgumentError,
          reason: bad,
        );
      }
    });

    test('rejects empty, blank, missing, or non-string captions', () {
      final badCaptions = <Object?>['', '   ', null, 42];
      for (final caption in badCaptions) {
        expect(
          () => buildLocaleCompositeJobs(
            'en',
            _manifestWithFrame(file: '01-result-hero.png', caption: caption),
          ),
          throwsArgumentError,
          reason: '$caption',
        );
      }
    });

    test('rejects an unknown locale', () {
      expect(
        () => buildLocaleCompositeJobs(
          'zz',
          _manifestWithFrame(
            file: '01-result-hero.png',
            caption: 'A valid caption',
          ),
        ),
        throwsArgumentError,
      );
    });
  });

  group('caption-plan readiness', () {
    test('flags a pre-Appeeky manifest that needs new frames as blocked', () {
      final readiness = readLocaleCaptionPlanReadiness('en', <String, dynamic>{
        'captionPlanStatus': 'pre_appeeky_reference_raw_captures',
        'currentCaptionPlanRequiresNewFrames': true,
      });

      expect(readiness.locale, 'en');
      expect(readiness.requiresNewFrames, isTrue);
      expect(readiness.isPreAppeekyReference, isTrue);
      expect(readiness.blocksFinalComposite, isTrue);
    });

    test('treats a final, frames-ready manifest as not blocked', () {
      final readiness = readLocaleCaptionPlanReadiness('en', <String, dynamic>{
        'captionPlanStatus': 'final_appeeky_captions',
        'currentCaptionPlanRequiresNewFrames': false,
      });

      expect(readiness.requiresNewFrames, isFalse);
      expect(readiness.isPreAppeekyReference, isFalse);
      expect(readiness.blocksFinalComposite, isFalse);
    });

    test('blocks when only new frames are required', () {
      final readiness = readLocaleCaptionPlanReadiness('en', <String, dynamic>{
        'captionPlanStatus': 'final_appeeky_captions',
        'currentCaptionPlanRequiresNewFrames': true,
      });

      expect(readiness.blocksFinalComposite, isTrue);
    });

    test('blocks when only the pre-Appeeky reference status is set', () {
      final readiness = readLocaleCaptionPlanReadiness('en', <String, dynamic>{
        'captionPlanStatus': 'pre_appeeky_reference_raw_captures',
        'currentCaptionPlanRequiresNewFrames': false,
      });

      expect(readiness.blocksFinalComposite, isTrue);
    });

    test('defaults to not blocked when the markers are absent', () {
      final readiness = readLocaleCaptionPlanReadiness(
        'en',
        <String, dynamic>{},
      );

      expect(readiness.captionPlanStatus, isEmpty);
      expect(readiness.requiresNewFrames, isFalse);
      expect(readiness.blocksFinalComposite, isFalse);
    });

    test('only English is ready for final composites on disk', () {
      final all = readAllCaptionPlanReadiness();

      expect(
        all.map((r) => r.locale),
        orderedEquals(supportedStoreLocales),
      );
      expect(
        {
          for (final readiness in all)
            readiness.locale: readiness.blocksFinalComposite,
        },
        <String, bool>{
          'en': false,
          'de': true,
          'fr': true,
          'es': true,
          'pt-BR': true,
        },
        reason: all.map((r) => '${r.locale}:${r.captionPlanStatus}').join(', '),
      );
    });
  });
}
