// In-memory integration test wiring the store screenshot *planning* seam
// (`buildAllCompositeJobs` in store_screenshot_compositor_plan.dart) to the
// *rendering* seam (`StoreScreenshotCompositorRenderer`).
//
// It proves the two halves connect end to end on the real on-disk plan: each
// planned job's raw source exists, and feeding the job's caption plus raw
// bytes through the renderer yields a fresh, same-size composited store PNG.
// Rendering stays purely in memory: no output file is created or changed. To
// keep the render pass fast it composites only a small
// representative subset of the plan rather than all 25 frames.

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';

import 'screenshot_compositor.dart';
import 'store_screenshot_compositor_plan.dart';
import 'store_screenshot_compositor_renderer.dart';
import 'store_screenshot_compositor_repo_state.dart';

/// PNG file signature (first four bytes).
const List<int> _pngMagic = <int>[0x89, 0x50, 0x4E, 0x47];

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
/// is a fresh, same-size composited PNG, with no output file mutated on disk.
Future<void> _expectJobComposites(StoreScreenshotCompositeJob job) async {
  // The plan promises a real raw source and an output inside `composited/`;
  // the in-memory renderer must not create or change that output path.
  expect(File(job.rawPath).existsSync(), isTrue, reason: job.rawPath);
  final outputFile = File(job.outputPath);
  final outputExistedBefore = outputFile.existsSync();
  final bytesBefore = outputExistedBefore
      ? await outputFile.readAsBytes()
      : null;

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

  // Rendering is purely in memory: the output file must remain in its exact
  // pre-render state, whether it was absent or already committed.
  expect(outputFile.existsSync(), outputExistedBefore, reason: job.outputPath);
  if (bytesBefore != null) {
    expect(await outputFile.readAsBytes(), equals(bytesBefore));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'planned jobs composite end to end without touching the filesystem',
    () async {
      final jobs = buildAllCompositeJobs();
      expect(jobs, isNotEmpty);

      // A small representative subset keeps the render pass fast while still
      // spanning non-English locales with committed outputs.
      final selected = <StoreScreenshotCompositeJob>[
        jobs.firstWhere((job) => job.locale == 'de'),
        jobs.last,
      ];

      expectCommittedCompositedState();
      for (final job in selected) {
        await _expectJobComposites(job);
      }
      expectCommittedCompositedState();
    },
  );
}
