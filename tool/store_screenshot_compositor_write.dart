// Guarded write CLI for the store screenshot compositing pipeline.
//
// This is the explicit entrypoint that can later turn the manifest-driven plan
// into composited store screenshots by wiring three existing seams together:
//
//   plan     test/tool/store_screenshot_compositor_plan.dart   (jobs)
//   renderer test/tool/store_screenshot_compositor_renderer.dart (PNG bytes)
//   writer   test/tool/store_screenshot_compositor_writer.dart (disk writes)
//
// Writing is deliberately hard to do by accident:
//
//   dart run tool/store_screenshot_compositor_write.dart
//       Safe no-write preview. Prints what *would* be written and exits 0
//       having created nothing.
//
//   dart run tool/store_screenshot_compositor_write.dart --write
//       Refuses: a real write also requires the explicit confirmation flag.
//
//   dart run tool/store_screenshot_compositor_write.dart --write --yes
//       Requests a real write. Plain `dart run` cannot satisfy this because the
//       renderer needs the Flutter engine (`dart:ui`); the CLI declines and
//       points at the Flutter-compatible execution path. See the
//       `runWriteCli` doc and store_screenshot_compositor_write_harness_test.
//
//   --allow-overwrite  Replace existing composited outputs (default: refuse).
//   --verbose          List one planned line per job in the preview.
//   --help, -h         Print usage and exit 0.
//
// The orchestration core, [runWriteCli], takes an injected renderer callback
// and an injected `root` directory, so it can be driven end to end from a
// Flutter test binding into a temporary directory without ever touching the
// repository's `screenshots/store/`. This tool itself imports neither
// `dart:ui` nor Flutter, so plain `dart run` and the dry-run tool keep working.

import 'dart:io';
import 'dart:typed_data';

import '../test/tool/store_screenshot_compositor_plan.dart';
import '../test/tool/store_screenshot_compositor_writer.dart';

/// Parsed command-line flags for the write CLI.
///
/// A non-null [usageError] means an unknown/invalid flag was supplied and the
/// caller should print usage and exit with a usage error code. The write gate
/// is two flags: [write] arms a real write and [confirm] (`--yes`) confirms it;
/// both are required before any byte is written.
class WriteCliArgs {
  const WriteCliArgs({
    this.write = false,
    this.confirm = false,
    this.allowOverwrite = false,
    this.verbose = false,
    this.help = false,
    this.usageError,
  });

  /// Whether `--write` was supplied (arm a real write).
  final bool write;

  /// Whether `--yes` was supplied (confirm a real write).
  final bool confirm;

  /// Whether `--allow-overwrite` was supplied (replace existing outputs).
  final bool allowOverwrite;

  /// Whether `--verbose` was supplied (list one line per job in the preview).
  final bool verbose;

  /// Whether `--help`/`-h` was supplied (print usage and exit 0).
  final bool help;

  /// A human-readable message if an unknown/invalid flag was supplied, else
  /// `null`. Contains only the offending repo-safe flag text.
  final String? usageError;
}

/// Parses [args] into [WriteCliArgs].
///
/// Recognizes `--write`, `--yes`, `--allow-overwrite`, `--verbose`, and
/// `--help`/`-h`. Any other token yields a non-null [WriteCliArgs.usageError];
/// parsing stops at the first unknown flag.
WriteCliArgs parseWriteCliArgs(List<String> args) {
  var write = false;
  var confirm = false;
  var allowOverwrite = false;
  var verbose = false;
  var help = false;
  for (final arg in args) {
    switch (arg) {
      case '--write':
        write = true;
      case '--yes':
        confirm = true;
      case '--allow-overwrite':
        allowOverwrite = true;
      case '--verbose':
        verbose = true;
      case '--help':
      case '-h':
        help = true;
      default:
        return WriteCliArgs(usageError: 'Unknown argument: $arg');
    }
  }
  return WriteCliArgs(
    write: write,
    confirm: confirm,
    allowOverwrite: allowOverwrite,
    verbose: verbose,
    help: help,
  );
}

/// The outcome of a [runWriteCli] invocation.
///
/// [lines] are ready to print in order; all retained strings are repository-
/// relative and safe to surface. [writtenOutputPaths] lists the repo-relative
/// outputs actually written (empty on any no-write or refusal path).
class WriteCliResult {
  const WriteCliResult({
    required this.lines,
    required this.exitCode,
    required this.writtenOutputPaths,
  });

  /// Lines to print, in order.
  final List<String> lines;

  /// Process exit code: 0 on success/clean preview, non-zero on refusal/error.
  final int exitCode;

  /// Repository-relative output paths written, in plan order; empty when
  /// nothing was written.
  final List<String> writtenOutputPaths;

  /// Whether any file was written.
  bool get wroteFiles => writtenOutputPaths.isNotEmpty;
}

/// Distinct locales covered by [jobs], in first-seen plan order.
List<String> _locales(List<StoreScreenshotCompositeJob> jobs) {
  final seen = <String>[];
  for (final job in jobs) {
    if (!seen.contains(job.locale)) {
      seen.add(job.locale);
    }
  }
  return seen;
}

/// Plans or performs the composite write described by [args].
///
/// This is the gate every caller must go through, and it enforces the safety
/// contract:
/// - without [WriteCliArgs.write] it is a no-write preview: it reports what
///   would be written and returns with [WriteCliResult.wroteFiles] false;
/// - with `--write` but without [WriteCliArgs.confirm] (`--yes`) it refuses,
///   writing nothing;
/// - only with both flags does it call [writeCompositedScreenshots], rendering
///   each job via the injected [render] callback and writing under [root].
///
/// [root] is the directory all repository-relative job paths resolve against (a
/// temp directory in tests; the repo root in real use), and [render] is the
/// injected renderer. Real use wires [render] to the `dart:ui`
/// `StoreScreenshotCompositorRenderer` from a Flutter test binding (see
/// `store_screenshot_compositor_write_harness_test.dart`); this function never
/// imports `dart:ui` itself. A [StoreScreenshotWriteException] from the writer
/// is caught and reported as a clean refusal that wrote nothing.
Future<WriteCliResult> runWriteCli(
  WriteCliArgs args, {
  required List<StoreScreenshotCompositeJob> jobs,
  required Directory root,
  required CompositeRenderCallback render,
}) async {
  if (!args.write) {
    return WriteCliResult(
      lines: _previewLines(jobs, verbose: args.verbose),
      exitCode: 0,
      writtenOutputPaths: const <String>[],
    );
  }

  if (!args.confirm) {
    const guidance =
        'Re-run with --write --yes to write '
        '(--allow-overwrite to replace existing). No files written.';
    return const WriteCliResult(
      lines: <String>['Refusing to write without confirmation.', guidance],
      exitCode: 64, // EX_USAGE
      writtenOutputPaths: <String>[],
    );
  }

  try {
    final report = await writeCompositedScreenshots(
      jobs,
      root: root,
      render: render,
      allowOverwrite: args.allowOverwrite,
    );
    return WriteCliResult(
      lines: <String>[
        'Wrote ${report.count} composited screenshot(s):',
        for (final path in report.writtenOutputPaths) '  $path',
      ],
      exitCode: 0,
      writtenOutputPaths: report.writtenOutputPaths,
    );
  } on StoreScreenshotWriteException catch (error) {
    return WriteCliResult(
      lines: <String>[
        'Write failed; wrote nothing. ${error.message}',
        'No files written.',
      ],
      exitCode: 1,
      writtenOutputPaths: const <String>[],
    );
  }
}

/// Builds the no-write preview lines for [jobs].
List<String> _previewLines(
  List<StoreScreenshotCompositeJob> jobs, {
  required bool verbose,
}) {
  final lines = <String>['Store screenshot compositor - WRITE (preview)'];
  if (verbose) {
    for (final job in jobs) {
      lines.add('${job.locale} ${job.fileName} -> ${job.outputPath}');
    }
  }
  final locales = _locales(jobs);
  return lines
    ..add(
      'Planned ${jobs.length} composited screenshots across '
      '${locales.length} locale(s): ${locales.join(', ')}.',
    )
    ..add(
      'No files written. Re-run with --write --yes to write '
      '(--allow-overwrite to replace existing).',
    );
}

/// Usage text shown for `--help` and on a usage error.
String usageText() => '''
Store screenshot compositor write CLI (guarded).

Usage: dart run tool/store_screenshot_compositor_write.dart [options]

Plans composited store screenshots from the manifest-driven plan. Writing is
guarded: the default is a no-write preview, and a real write requires BOTH
--write and --yes. Because the renderer needs the Flutter engine (dart:ui), a
real write runs from a Flutter test binding, not plain `dart run`.

Options:
  --write            Arm a real write (still requires --yes).
  --yes              Confirm a real write (required with --write).
  --allow-overwrite  Replace existing composited outputs (default: refuse).
  --verbose          List one "<locale> <fileName> -> <outputPath>" per job.
  --help, -h         Show this message and exit.''';

/// Entry point: parse flags, run the (no-write) plan, and print the result.
///
/// Plain `dart run` cannot render (`dart:ui` is unavailable here), so the one
/// path that would render, `--write --yes`, is declined with guidance toward
/// the Flutter-compatible execution path. Every other path (preview,
/// confirmation refusal, usage, help) is safe to run here and never renders.
Future<void> main(List<String> args) async {
  final parsed = parseWriteCliArgs(args);

  if (parsed.usageError != null) {
    stderr
      ..writeln(parsed.usageError)
      ..writeln(usageText());
    exitCode = 64; // EX_USAGE
    return;
  }

  if (parsed.help) {
    stdout.writeln(usageText());
    return;
  }

  if (parsed.write && parsed.confirm) {
    stderr
      ..writeln(
        'Real compositing needs the Flutter engine (dart:ui), which a plain '
        '`dart run` cannot provide.',
      )
      ..writeln(
        'Wire runWriteCli to StoreScreenshotCompositorRenderer under a Flutter '
        'test binding instead; see:',
      )
      ..writeln(
        '  test/tool/store_screenshot_compositor_write_harness_test.dart',
      )
      ..writeln('No files written.');
    exitCode = 70; // EX_SOFTWARE
    return;
  }

  // Safe paths only (preview / confirmation refusal): never reaches the
  // renderer, so the unavailable-renderer callback is never invoked.
  final result = await runWriteCli(
    parsed,
    jobs: buildAllCompositeJobs(),
    root: Directory.current,
    render: _rendererUnavailable,
  );
  final sink = result.exitCode == 0 ? stdout : stderr;
  result.lines.forEach(sink.writeln);
  exitCode = result.exitCode;
}

/// A renderer callback that always throws: plain `dart run` has no `dart:ui`
/// renderer, and the safe CLI paths never invoke it.
Future<Uint8List> _rendererUnavailable(
  StoreScreenshotCompositeJob job,
  Uint8List rawScreenshotPng,
) async => throw StateError(
  'No dart:ui renderer is available under plain `dart run`.',
);
