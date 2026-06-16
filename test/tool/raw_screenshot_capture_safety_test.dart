// Pure safety tests for the raw store screenshot capture harness.
//
// These never render and never write a file. They prove the harness can only
// ever resolve a path inside the draft scratch folder, that real writes are
// off unless explicitly opted in, that the draft folder can never be consumed
// by the guarded compositor, and that the frame plan is internally consistent.

import 'package:flutter_test/flutter_test.dart';

import 'raw_screenshot_capture.dart';
import 'screenshot_compositor.dart';

void main() {
  group('write opt-in gate (default is no repository writes)', () {
    test('disabled when the enable env var is absent', () {
      expect(captureWritesEnabled(const <String, String>{}), isFalse);
    });

    test('disabled for any value other than exactly "1"', () {
      for (final value in <String>['', '0', 'true', 'yes', '11', ' 1']) {
        expect(
          captureWritesEnabled(<String, String>{kCaptureEnableEnv: value}),
          isFalse,
          reason: 'value: "$value"',
        );
      }
    });

    test('enabled only when the enable env var is exactly "1"', () {
      expect(
        captureWritesEnabled(<String, String>{kCaptureEnableEnv: '1'}),
        isTrue,
      );
    });

    test('requested frame id is null when unset or blank', () {
      expect(requestedCaptureFrameId(const <String, String>{}), isNull);
      expect(
        requestedCaptureFrameId(<String, String>{kCaptureFrameEnv: '   '}),
        isNull,
      );
      expect(
        requestedCaptureFrameId(<String, String>{kCaptureFrameEnv: ' x '}),
        'x',
      );
    });
  });

  group('draft path is always inside the draft folder, never canonical', () {
    test('draft root is under the store root but is not a shipped locale', () {
      expect(kRawCaptureDraftRoot, startsWith('$kStoreScreenshotsRoot/'));
      expect(isSupportedStoreLocale(kRawCaptureDraftDirName), isFalse);
    });

    test('resolves a valid frame name inside the draft folder', () {
      final path = draftRawScreenshotPath('01-problem-hook.png');
      expect(path, '$kRawCaptureDraftRoot/01-problem-hook.png');
      expect(path, startsWith('$kRawCaptureDraftRoot/'));
    });

    test('never resolves inside any canonical locale pack', () {
      final path = draftRawScreenshotPath('02-life-events.png');
      for (final locale in supportedStoreLocales) {
        expect(
          path.startsWith('$kStoreScreenshotsRoot/$locale/'),
          isFalse,
          reason: locale,
        );
      }
    });

    test('rejects unsafe / non-raw file names', () {
      for (final bad in <String>[
        '',
        '..',
        '../01-x.png',
        'en/01-x.png',
        r'en\01-x.png',
        '01-x..png',
        'problem-hook.png', // missing NN- order prefix
        '01-Problem-Hook.png', // uppercase not allowed by the raw slug
        '01-.png',
      ]) {
        expect(
          () => draftRawScreenshotPath(bad),
          throwsArgumentError,
          reason: 'name: "$bad"',
        );
      }
    });
  });

  group('draft folder is invisible to the canonical compositor', () {
    test('draft dir name is a recognised draft, not a store locale', () {
      expect(isDraftScreenshotDirName(kRawCaptureDraftDirName), isTrue);
      for (final locale in supportedStoreLocales) {
        expect(isDraftScreenshotDirName(locale), isFalse, reason: locale);
      }
      expect(isDraftScreenshotDirName('composited'), isFalse);
      expect(isDraftScreenshotDirName('en'), isFalse);
    });

    test('compositor refuses the draft folder as a locale segment', () {
      expect(
        () => rawScreenshotPath(kRawCaptureDraftDirName, '01-problem-hook.png'),
        throwsArgumentError,
      );
      expect(
        () => resolveCompositedTarget(
          kRawCaptureDraftDirName,
          '01-problem-hook.png',
        ),
        throwsArgumentError,
      );
    });
  });

  group('missing-current-plan frame plan is consistent', () {
    test('covers exactly the two missing story frames in order', () {
      expect(
        kMissingCurrentPlanFrames.map((f) => f.id).toList(),
        <String>['problem-hook', 'life-events'],
      );
      expect(
        kMissingCurrentPlanFrames.map((f) => f.currentPlanOrder).toList(),
        <int>[1, 2],
      );
    });

    test('every frame has a valid raw file name and distinct order prefix', () {
      final prefixes = <String>{};
      for (final frame in kMissingCurrentPlanFrames) {
        expect(
          isRawScreenshotFileName(frame.fileName),
          isTrue,
          reason: frame.fileName,
        );
        expect(frame.caption.trim(), isNotEmpty, reason: frame.id);
        expect(
          prefixes.add(frame.fileName.substring(0, 2)),
          isTrue,
          reason: 'duplicate order prefix in ${frame.fileName}',
        );
      }
    });

    test('captureFrameById round-trips known ids and rejects unknown', () {
      for (final frame in kMissingCurrentPlanFrames) {
        expect(captureFrameById(frame.id)?.fileName, frame.fileName);
      }
      expect(captureFrameById('does-not-exist'), isNull);
    });
  });
}
