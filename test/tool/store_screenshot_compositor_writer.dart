/// File-IO write seam for the store screenshot compositing harness.
///
/// This slice owns the only step that actually touches disk: given the
/// already-validated [StoreScreenshotCompositeJob]s from the planning seam and
/// an injected renderer callback, it reads each raw source, asks the callback
/// for the composited PNG bytes, and writes them under an injected root
/// directory. The root is injected (rather than assumed to be the repository)
/// so tests can drive real IO entirely inside a temporary directory and never
/// create `composited/` output under `screenshots/store/` in the repo.
///
/// It stays free of `dart:ui` and Flutter: the pixel work lives behind the
/// [CompositeRenderCallback], so this file can be analyzed and unit-tested
/// without a Flutter engine. All retained paths are repository-relative and
/// safe to surface.
library;

import 'dart:io';
import 'dart:typed_data';

import 'screenshot_compositor.dart';
import 'store_screenshot_compositor_plan.dart';

/// Renders one planned [job] (with its already-read [rawScreenshotPng]) to the
/// composited PNG bytes to write. Injected so the writer never imports a
/// `dart:ui`/Flutter renderer directly.
typedef CompositeRenderCallback =
    Future<Uint8List> Function(
      StoreScreenshotCompositeJob job,
      Uint8List rawScreenshotPng,
    );

/// Raised when a job cannot be written safely: a missing raw source, an output
/// that already exists without overwrite permission, or an output path that
/// escaped the `composited/` directory. The [message] holds only
/// repository-relative path text.
class StoreScreenshotWriteException implements Exception {
  /// Creates an exception describing why a write was refused.
  const StoreScreenshotWriteException(this.message);

  /// Human-readable, repo-relative-path-only description of the refusal.
  final String message;

  @override
  String toString() => 'StoreScreenshotWriteException: $message';
}

/// The result of a successful [writeCompositedScreenshots] run.
///
/// Immutable. [writtenOutputPaths] lists the repository-relative output paths
/// that were written, in job order.
class StoreScreenshotWriteReport {
  /// Creates a report over the [writtenOutputPaths] that were written.
  const StoreScreenshotWriteReport({required this.writtenOutputPaths});

  /// Repository-relative output paths written, in plan order.
  final List<String> writtenOutputPaths;

  /// Number of composited screenshots written.
  int get count => writtenOutputPaths.length;
}

/// `/composited/` path segment that every output must live inside.
const String _compositedSegment = '/$kCompositedDirName/';

/// Writes the composited PNG for each of [jobs] under [root], rendering bytes
/// via [render].
///
/// [root] is the directory all repository-relative job paths are resolved
/// against (a temp directory in tests; the repo root in real use). The raw
/// source for a job is read from `<root>/<rawPath>` and its output written to
/// `<root>/<outputPath>`, creating only the `composited/` parent directories
/// the writes need.
///
/// Validation runs as a single pre-flight pass before any rendering or writing,
/// so a bad job aborts the whole batch before [render] is ever called. A job is
/// refused (via [StoreScreenshotWriteException]) when:
/// - its raw source does not exist under [root];
/// - its output already exists under [root] and [allowOverwrite] is false;
/// - its output path does not live inside the `composited/` directory.
///
/// With [allowOverwrite] true, an existing output is replaced in place.
/// Returns a [StoreScreenshotWriteReport] of the repo-relative paths written.
Future<StoreScreenshotWriteReport> writeCompositedScreenshots(
  List<StoreScreenshotCompositeJob> jobs, {
  required Directory root,
  required CompositeRenderCallback render,
  bool allowOverwrite = false,
}) async {
  // Pre-flight: validate every job before touching the renderer or disk, so a
  // missing raw source (or any other refusal) fails before any rendering.
  for (final job in jobs) {
    if (!_childFile(root, job.rawPath).existsSync()) {
      throw StoreScreenshotWriteException('Missing raw source: ${job.rawPath}');
    }
    if (!job.outputPath.contains(_compositedSegment)) {
      throw StoreScreenshotWriteException(
        'Output escaped the composited directory: ${job.outputPath}',
      );
    }
    if (!allowOverwrite && _childFile(root, job.outputPath).existsSync()) {
      throw StoreScreenshotWriteException(
        'Output already exists: ${job.outputPath}',
      );
    }
  }

  final written = <String>[];
  for (final job in jobs) {
    final rawBytes = await _childFile(root, job.rawPath).readAsBytes();
    final bytes = await render(job, rawBytes);

    final outputFile = _childFile(root, job.outputPath);
    // Create only the composited parent directory this output needs.
    outputFile.parent.createSync(recursive: true);
    await outputFile.writeAsBytes(bytes, flush: true);
    written.add(job.outputPath);
  }

  return StoreScreenshotWriteReport(writtenOutputPaths: written);
}

/// Resolves a repository-relative [repoRelativePath] against [root].
File _childFile(Directory root, String repoRelativePath) =>
    File('${root.path}/$repoRelativePath');
