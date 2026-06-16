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

/// The manifest key holding the caption-plan status marker.
const String _captionPlanStatusKey = 'captionPlanStatus';

/// The manifest key flagging that the current caption plan needs new frames.
const String _requiresNewFramesKey = 'currentCaptionPlanRequiresNewFrames';

/// Caption-plan readiness parsed from one locale's `manifest.json`: whether
/// final compositing is currently blocked for that locale, and why.
///
/// Pure data, immutable. Final store composites must never be produced from
/// raw frames whose caption plan is still a pre-Appeeky reference plan, or
/// whose manifest explicitly requires newly captured frames. The compositor
/// write path consults this before any real write so stale manifests cannot
/// accidentally produce final composited screenshots.
class CaptionPlanReadiness {
  const CaptionPlanReadiness({
    required this.locale,
    required this.captionPlanStatus,
    required this.requiresNewFrames,
  });

  /// The locale folder this readiness was parsed from, e.g. `en`.
  final String locale;

  /// The raw `captionPlanStatus` marker, e.g.
  /// `pre_appeeky_reference_raw_captures`; empty when the manifest omits it.
  final String captionPlanStatus;

  /// Whether `currentCaptionPlanRequiresNewFrames` is set on the manifest.
  final bool requiresNewFrames;

  /// Whether the caption plan is a pre-Appeeky / reference plan: its status
  /// names `pre_appeeky` or `reference`.
  bool get isPreAppeekyReference =>
      captionPlanStatus.contains('pre_appeeky') ||
      captionPlanStatus.contains('reference');

  /// Whether final composites are blocked for this locale: the manifest needs
  /// new frames, or its captions are still the pre-Appeeky reference plan.
  bool get blocksFinalComposite => requiresNewFrames || isPreAppeekyReference;
}

/// Parses the [CaptionPlanReadiness] for [locale] from an already-decoded
/// [manifest] map (typically `jsonDecode` of its `manifest.json`).
///
/// Reads only the two readiness markers; a missing or non-string status is
/// treated as empty and a missing/non-true flag as `false`, so an unmarked
/// manifest is reported as not blocked. Performs no I/O and writes nothing.
CaptionPlanReadiness readLocaleCaptionPlanReadiness(
  String locale,
  Map<String, dynamic> manifest,
) {
  final status = manifest[_captionPlanStatusKey];
  return CaptionPlanReadiness(
    locale: locale,
    captionPlanStatus: status is String ? status : '',
    requiresNewFrames: manifest[_requiresNewFramesKey] == true,
  );
}

/// Reads every on-disk manifest under [kStoreScreenshotsRoot] and returns its
/// [CaptionPlanReadiness], in [supportedStoreLocales] order.
///
/// Reads only `manifest.json` files; performs no rendering, creates no
/// directories, and writes nothing.
List<CaptionPlanReadiness> readAllCaptionPlanReadiness() =>
    <CaptionPlanReadiness>[
      for (final locale in supportedStoreLocales)
        readLocaleCaptionPlanReadiness(locale, _readManifest(locale)),
    ];

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
