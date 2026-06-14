// In-memory integration test wiring the store screenshot *planning* seam
// (`buildAllCompositeJobs` in store_screenshot_compositor_plan.dart) to the
// *rendering* seam (`StoreScreenshotCompositorRenderer`).
//
// It proves the two halves connect end to end on the real on-disk plan: each
// planned job's raw source exists, and feeding the job's caption plus raw
// bytes through the renderer yields a fresh, same-size composited store PNG.
// Rendering stays purely in memory: no `composited/` output directory or file
// is ever created. To keep the render pass fast it composites only a small
// representative subset of the plan (the first and last jobs) rather than all
// 25 frames.

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';

import 'screenshot_compositor.dart';
import 'store_screenshot_compositor_plan.dart';
import 'store_screenshot_compositor_renderer.dart';

/// PNG file signature (first four bytes).
const List<int> _pngMagic = <int>[0x89, 0x50, 0x4E, 0x47];

/// Fails if any `composited/` directory exists under a supported locale.
void _expectNoCompositedDirs() {
  for (final locale in supportedStoreLocales) {
    final dir = Directory('$kStoreScreenshotsRoot/$locale/$kCompositedDirName');
    expect(dir.existsSync(), isFalse, reason: dir.path);
  }
}

Future<ui.Image> _decodePng(Uint8List bytes) async {
  final codec = await ui.instantiateImageCodec(bytes);
  try {
    final frame = await codec.getNextFrame();
    return frame.image;
  } finally {
    codec.dispose();
  }
}

/// Drives one planned [job] through the renderer seam and asserts the result
/// is a fresh, same-size composited PNG, with no output file created on disk.
Future<void> _expectJobComposites(StoreScreenshotCompositeJob job) async {
  // The plan promises a real raw source and an output inside `composited/`;
  // neither the output file nor its directory exists before rendering.
  expect(File(job.rawPath).existsSync(), isTrue, reason: job.rawPath);
  expect(File(job.outputPath).existsSync(), isFalse, reason: job.outputPath);

  final rawBytes = await File(job.rawPath).readAsBytes();
  final output = await StoreScreenshotCompositorRenderer.render(
    StoreScreenshotCompositeInput(
      rawScreenshotPng: rawBytes,
      caption: job.caption,
    ),
  );

  expect(output, isNotEmpty, reason: job.outputPath);
  expect(output.sublist(0, 4), _pngMagic, reason: job.outputPath);
  expect(output, isNot(equals(rawBytes)), reason: job.outputPath);

  final decoded = await _decodePng(output);
  try {
    expect(decoded.width, kRawScreenshotWidth, reason: job.outputPath);
    expect(decoded.height, kRawScreenshotHeight, reason: job.outputPath);
  } finally {
    decoded.dispose();
  }

  // Rendering is purely in memory: the output file must still not exist.
  expect(File(job.outputPath).existsSync(), isFalse, reason: job.outputPath);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'planned jobs composite end to end without touching the filesystem',
    () async {
      final jobs = buildAllCompositeJobs();
      expect(jobs, isNotEmpty);

      // A small representative subset keeps the render pass fast while still
      // spanning the plan from its first to its last locale/frame.
      final selected = <StoreScreenshotCompositeJob>[jobs.first, jobs.last];

      _expectNoCompositedDirs();
      for (final job in selected) {
        await _expectJobComposites(job);
      }
      _expectNoCompositedDirs();
    },
  );
}
