// Tests for the store screenshot compositing *write* seam
// (store_screenshot_compositor_writer.dart).
//
// Every test drives real file IO inside a fresh temporary directory and uses a
// stub renderer, so nothing here renders pixels, imports `dart:ui`, or writes
// under the repository's `screenshots/store/`. The stub also records its calls
// so a refusal can be proven to fail *before* rendering.

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'screenshot_compositor.dart';
import 'store_screenshot_compositor_plan.dart';
import 'store_screenshot_compositor_writer.dart';

/// A single-frame manifest map shaped like a decoded `manifest.json`.
Map<String, dynamic> _manifestWithFrame({
  required String file,
  required String caption,
}) => <String, dynamic>{
  'frames': <dynamic>[
    <String, dynamic>{'file': file, 'intendedCaption': caption},
  ],
};

/// Builds a single validated `en` job for [file] via the planning seam (the
/// job constructor is private, so jobs must come from the planner).
StoreScreenshotCompositeJob _job(String file) => buildLocaleCompositeJobs(
  'en',
  _manifestWithFrame(file: file, caption: 'A valid caption'),
).single;

/// Seeds a fake raw source for [job] under [root] and returns its file.
File _seedRaw(Directory root, StoreScreenshotCompositeJob job, String body) {
  final file = File('${root.path}/${job.rawPath}');
  file.parent.createSync(recursive: true);
  file.writeAsStringSync(body);
  return file;
}

/// A renderer stub that records each call and returns deterministic bytes.
class _RecordingRenderer {
  final List<String> renderedFiles = <String>[];

  Future<Uint8List> render(
    StoreScreenshotCompositeJob job,
    Uint8List rawBytes,
  ) async {
    renderedFiles.add(job.fileName);
    return Uint8List.fromList(utf8.encode('composited:${job.fileName}'));
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
  late Directory root;

  setUp(() {
    root = Directory.systemTemp.createTempSync('store_writer_test');
  });

  tearDown(() {
    if (root.existsSync()) {
      root.deleteSync(recursive: true);
    }
  });

  test('writes rendered bytes and creates the composited dir', () async {
    final job = _job('01-result-hero.png');
    _seedRaw(root, job, 'raw-bytes');
    final renderer = _RecordingRenderer();

    final compositedDir = Directory(
      '${root.path}/$kStoreScreenshotsRoot/en/$kCompositedDirName',
    );
    expect(compositedDir.existsSync(), isFalse);

    final report = await writeCompositedScreenshots(
      <StoreScreenshotCompositeJob>[job],
      root: root,
      render: renderer.render,
    );

    expect(renderer.renderedFiles, <String>['01-result-hero.png']);
    expect(report.writtenOutputPaths, <String>[job.outputPath]);
    expect(report.count, 1);
    expect(compositedDir.existsSync(), isTrue);

    final outputFile = File('${root.path}/${job.outputPath}');
    expect(outputFile.existsSync(), isTrue);
    expect(outputFile.readAsStringSync(), 'composited:01-result-hero.png');

    _expectNoRepoCompositedDirs();
  });

  test('missing raw source fails before rendering', () async {
    final job = _job('01-result-hero.png');
    // Intentionally do not seed the raw source under root.
    final renderer = _RecordingRenderer();

    await expectLater(
      writeCompositedScreenshots(
        <StoreScreenshotCompositeJob>[job],
        root: root,
        render: renderer.render,
      ),
      throwsA(isA<StoreScreenshotWriteException>()),
    );

    // The renderer must never have run, and no output may exist.
    expect(renderer.renderedFiles, isEmpty);
    expect(File('${root.path}/${job.outputPath}').existsSync(), isFalse);

    _expectNoRepoCompositedDirs();
  });

  test('existing output fails without overwrite', () async {
    final job = _job('01-result-hero.png');
    _seedRaw(root, job, 'raw-bytes');
    final outputFile = File('${root.path}/${job.outputPath}')
      ..parent.createSync(recursive: true)
      ..writeAsStringSync('original-output');
    final renderer = _RecordingRenderer();

    await expectLater(
      writeCompositedScreenshots(
        <StoreScreenshotCompositeJob>[job],
        root: root,
        render: renderer.render,
      ),
      throwsA(isA<StoreScreenshotWriteException>()),
    );

    // The existing output is left untouched and nothing was rendered.
    expect(renderer.renderedFiles, isEmpty);
    expect(outputFile.readAsStringSync(), 'original-output');

    _expectNoRepoCompositedDirs();
  });

  test('allowOverwrite replaces the existing output bytes', () async {
    final job = _job('01-result-hero.png');
    _seedRaw(root, job, 'raw-bytes');
    final outputFile = File('${root.path}/${job.outputPath}')
      ..parent.createSync(recursive: true)
      ..writeAsStringSync('original-output');
    final renderer = _RecordingRenderer();

    final report = await writeCompositedScreenshots(
      <StoreScreenshotCompositeJob>[job],
      root: root,
      render: renderer.render,
      allowOverwrite: true,
    );

    expect(renderer.renderedFiles, <String>['01-result-hero.png']);
    expect(report.writtenOutputPaths, <String>[job.outputPath]);
    expect(outputFile.readAsStringSync(), 'composited:01-result-hero.png');

    _expectNoRepoCompositedDirs();
  });

  test('writing never creates a composited dir in the repo', () async {
    _expectNoRepoCompositedDirs();

    final job = _job('02-evidence-breakdown.png');
    _seedRaw(root, job, 'raw-bytes');

    await writeCompositedScreenshots(
      <StoreScreenshotCompositeJob>[job],
      root: root,
      render: _RecordingRenderer().render,
    );

    // Output landed under the temp root, not the repository tree.
    expect(File('${root.path}/${job.outputPath}').existsSync(), isTrue);
    _expectNoRepoCompositedDirs();
  });
}
