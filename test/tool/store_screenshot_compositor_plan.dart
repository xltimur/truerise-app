/// Manifest-driven planning seam for the (future) store screenshot
/// compositing harness.
///
/// This slice performs no image rendering and writes no files. It parses the
/// per-locale `manifest.json` declarations and turns each frame into a
/// [StoreScreenshotCompositeJob]: the validated raw source path, the
/// `composited/` output path it will later be written to, and the marketing
/// caption to overlay. A future rendering test can consume these jobs without
/// re-deriving any paths or re-validating any inputs, and without this layer
/// ever touching the renderer or the filesystem beyond reading manifests.
library;

import 'dart:convert';
import 'dart:io';

import 'screenshot_compositor.dart';

/// One planned compositing job: everything a later renderer needs to produce a
/// single composited store screenshot, with no path derivation or validation
/// left to do.
///
/// Immutable. Instances are only created by [buildLocaleCompositeJobs] (and
/// the on-disk [buildAllCompositeJobs]), which validate every field through
/// [resolveCompositedTarget] before constructing one. No instance is created
/// for an unsafe file name, an unsupported locale, or a missing caption.
class StoreScreenshotCompositeJob {
  const StoreScreenshotCompositeJob._({
    required this.locale,
    required this.fileName,
    required this.rawPath,
    required this.outputPath,
    required this.caption,
  });

  /// The locale folder this job belongs to, e.g. `en`.
  final String locale;

  /// The raw screenshot file name, e.g. `01-result-hero.png`.
  final String fileName;

  /// Repository-relative path of the raw source screenshot.
  final String rawPath;

  /// Repository-relative path the composited screenshot will be written to;
  /// always inside the `composited/` directory and never equal to [rawPath].
  final String outputPath;

  /// The marketing caption to overlay, taken verbatim from the manifest
  /// frame's `intendedCaption`; guaranteed non-empty.
  final String caption;
}

/// The manifest key holding the ordered list of frame objects.
const String _framesKey = 'frames';

/// The frame key holding the raw screenshot file name.
const String _fileKey = 'file';

/// The frame key holding the marketing caption overlay text.
const String _captionKey = 'intendedCaption';

/// Builds the ordered compositing jobs for a single [locale] from an already
/// decoded [manifest] map (typically `jsonDecode` of its `manifest.json`).
///
/// Validates that:
/// - [locale] is a supported store locale ([isSupportedStoreLocale]);
/// - `manifest['frames']` is a list of frame objects;
/// - every frame's `file` is a safe raw screenshot name accepted by
///   [resolveCompositedTarget] (which also guarantees the output path lives in
///   `composited/` and differs from the raw path);
/// - every frame's `intendedCaption` is a non-empty string.
///
/// Returns one [StoreScreenshotCompositeJob] per frame, in manifest frame
/// order. Performs no rendering, creates no directories, and writes nothing.
/// Throws [ArgumentError] (and, via [resolveCompositedTarget], [StateError])
/// on any invalid input.
List<StoreScreenshotCompositeJob> buildLocaleCompositeJobs(
  String locale,
  Map<String, dynamic> manifest,
) {
  if (!isSupportedStoreLocale(locale)) {
    throw ArgumentError.value(
      locale,
      'locale',
      'Unknown store locale; expected one of $supportedStoreLocales',
    );
  }

  final frames = manifest[_framesKey];
  if (frames is! List) {
    throw ArgumentError.value(
      frames,
      "manifest['$_framesKey']",
      'Expected a list of frame objects',
    );
  }

  final jobs = <StoreScreenshotCompositeJob>[];
  for (final frame in frames) {
    if (frame is! Map<String, dynamic>) {
      throw ArgumentError.value(frame, 'frame', 'Expected a frame object');
    }

    final file = frame[_fileKey];
    if (file is! String) {
      throw ArgumentError.value(
        file,
        "frame['$_fileKey']",
        'Expected a file name string',
      );
    }

    final caption = frame[_captionKey];
    if (caption is! String || caption.trim().isEmpty) {
      throw ArgumentError.value(
        caption,
        "frame['$_captionKey']",
        'Expected a non-empty caption string',
      );
    }

    // Validates the file name and derives the safe raw/output path pair; this
    // is what rejects unsafe names and guarantees the `composited/` invariant.
    final target = resolveCompositedTarget(locale, file);
    jobs.add(
      StoreScreenshotCompositeJob._(
        locale: target.locale,
        fileName: target.fileName,
        rawPath: target.rawPath,
        outputPath: target.outputPath,
        caption: caption,
      ),
    );
  }

  return jobs;
}

/// Repository-relative path of the on-disk manifest for [locale].
String storeManifestPath(String locale) =>
    '$kStoreScreenshotsRoot/$locale/manifest.json';

/// Reads and decodes the on-disk manifest for [locale] as a JSON object.
Map<String, dynamic> _readManifest(String locale) =>
    jsonDecode(File(storeManifestPath(locale)).readAsStringSync())
        as Map<String, dynamic>;

/// Reads every on-disk manifest under [kStoreScreenshotsRoot] and returns the
/// full, flattened list of compositing jobs in [supportedStoreLocales] order,
/// and within each locale in manifest frame order.
///
/// Reads only `manifest.json` files; performs no rendering, creates no
/// directories, and writes nothing.
List<StoreScreenshotCompositeJob> buildAllCompositeJobs() {
  final jobs = <StoreScreenshotCompositeJob>[];
  for (final locale in supportedStoreLocales) {
    jobs.addAll(buildLocaleCompositeJobs(locale, _readManifest(locale)));
  }
  return jobs;
}
