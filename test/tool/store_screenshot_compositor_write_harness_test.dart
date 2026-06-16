// Flutter-engine (dart:ui) execution test for the guarded write CLI seam.
//
// Plain `dart run tool/store_screenshot_compositor_write.dart --write --yes`
// cannot render, because the compositor renderer needs `dart:ui`. This test
// documents and verifies the Flutter-compatible execution path: wiring the
// *real* [StoreScreenshotCompositorRenderer] into [runWriteCli] under a Flutter
// test binding. The `_renderJob` adapter below is exactly the wiring a future
// real-write harness would use.
//
// It runs entirely inside a fresh temporary directory and never writes under
// the repository's `screenshots/store/`.

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';

import '../../tool/store_screenshot_compositor_write.dart';
import 'screenshot_compositor.dart';
import 'store_screenshot_compositor_plan.dart';
import 'store_screenshot_compositor_renderer.dart';

/// PNG file signature (first four bytes).
const List<int> _pngMagic = <int>[0x89, 0x50, 0x4E, 0x47];

/// A single-frame manifest map shaped like a decoded `manifest.json`.
Map<String, dynamic> _manifestWithFrame({
  required String file,
  required String caption,
}) => <String, dynamic>{
  'frames': <dynamic>[
    <String, dynamic>{'file': file, 'intendedCaption': caption},
  ],
};

/// Adapts a planned job to the `dart:ui` renderer. This is the production
/// wiring a real Flutter harness would inject into [runWriteCli].
Future<Uint8List> _renderJob(
  StoreScreenshotCompositeJob job,
  Uint8List rawScreenshotPng,
) => StoreScreenshotCompositorRenderer.render(
  StoreScreenshotCompositeInput(
    rawScreenshotPng: rawScreenshotPng,
    caption: job.caption,
  ),
);

/// Encodes a tiny solid-color PNG to seed a decodable raw source.
Future<Uint8List> _tinyPng() async {
  final recorder = ui.PictureRecorder();
  ui.Canvas(
    recorder,
    const ui.Rect.fromLTWH(0, 0, 8, 8),
  ).drawPaint(ui.Paint()..color = const ui.Color(0xFF112233));
  final picture = recorder.endRecording();
  try {
    final image = await picture.toImage(8, 8);
    try {
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      if (data == null) {
        throw StateError('Failed to encode the seed PNG.');
      }
      return data.buffer.asUint8List();
    } finally {
      image.dispose();
    }
  } finally {
    picture.dispose();
  }
}

/// Fails if any `composited/` directory exists under the real repository.
void _expectNoRepoCompositedDirs() {
  for (final locale in supportedStoreLocales) {
    final dir = Directory('$kStoreScreenshotsRoot/$locale/$kCompositedDirName');
    expect(dir.existsSync(), isFalse, reason: dir.path);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory root;
  setUp(() {
    root = Directory.systemTemp.createTempSync('store_write_harness_test');
  });
  tearDown(() {
    if (root.existsSync()) {
      root.deleteSync(recursive: true);
    }
  });

  test(
    'real renderer composites and writes through runWriteCli into a temp root',
    () async {
      final job = buildLocaleCompositeJobs(
        'en',
        _manifestWithFrame(
          file: '01-result-hero.png',
          caption: 'Find your real birth time',
        ),
      ).single;

      final rawFile = File('${root.path}/${job.rawPath}')
        ..parent.createSync(recursive: true);
      await rawFile.writeAsBytes(await _tinyPng());

      // This temp-root harness composites a synthetic, unmarked manifest, so it
      // passes empty readiness and is not blocked. A real harness that writes
      // the repo's `screenshots/store/` must instead pass
      // `readAllCaptionPlanReadiness()`, which currently refuses (the shipped
      // manifests are pre-Appeeky reference captures awaiting new frames).
      final result = await runWriteCli(
        parseWriteCliArgs(const <String>['--write', '--yes']),
        jobs: <StoreScreenshotCompositeJob>[job],
        root: root,
        render: _renderJob,
        readiness: const <CaptionPlanReadiness>[],
      );

      expect(result.wroteFiles, isTrue);
      expect(result.exitCode, 0);
      expect(result.writtenOutputPaths, <String>[job.outputPath]);

      final out = File('${root.path}/${job.outputPath}');
      expect(out.existsSync(), isTrue);
      final bytes = await out.readAsBytes();
      expect(bytes.sublist(0, 4), _pngMagic);
      expect(bytes, isNot(equals(await rawFile.readAsBytes())));

      _expectNoRepoCompositedDirs();
    },
  );
}
