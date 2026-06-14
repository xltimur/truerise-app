// No-write dry-run CLI for the store screenshot compositing pipeline.
//
// This is a planning/preview tool only. It reads the existing manifest-driven
// compositing plan (`buildAllCompositeJobs` from the test/tool planning seam),
// validates the paths each future render will read from and write to, and
// prints what *would* be generated. It renders nothing, imports no renderer,
// creates no directories, and writes no files.
//
//   dart run tool/store_screenshot_compositor_dry_run.dart
//       Validate the plan and print a concise summary. Exit 0 on success.
//
//   dart run tool/store_screenshot_compositor_dry_run.dart --verbose
//       Also print one `<locale> <fileName> -> <outputPath>` line per job.
//
//   dart run tool/store_screenshot_compositor_dry_run.dart --help
//       Print usage and exit 0.
//
// Validation fails (exit 1) if any raw source is missing, any composited
// output already exists, or the defensive `composited/` output invariant is
// violated. Only repository-relative paths are ever printed.
//
// The only dependencies are `dart:io` and the local planning seam under
// `test/tool/`; no Flutter, no `dart:ui`, and no compositor renderer.

import 'dart:io';

import '../test/tool/store_screenshot_compositor_plan.dart';

/// Path segment that separates composited outputs from raw source frames.
const String _compositedSegment = '/composited/';

/// Parsed command-line flags for the dry-run CLI.
///
/// Exactly one of [help], [usageError], or "run normally" applies. A non-null
/// [usageError] means an unknown/invalid flag was supplied and the caller
/// should print usage and exit with a usage error code.
class DryRunArgs {
  const DryRunArgs({
    this.verbose = false,
    this.help = false,
    this.usageError,
  });

  /// Whether `--verbose` was supplied (print one line per job).
  final bool verbose;

  /// Whether `--help` was supplied (print usage and exit 0).
  final bool help;

  /// A human-readable message if an unknown/invalid flag was supplied, else
  /// `null`. Never contains anything but the offending repo-safe flag text.
  final String? usageError;
}

/// Parses [args] into [DryRunArgs].
///
/// Recognizes `--verbose` and `--help`. Any other token yields a non-null
/// [DryRunArgs.usageError]; parsing stops at the first unknown flag.
DryRunArgs parseDryRunArgs(List<String> args) {
  var verbose = false;
  var help = false;
  for (final arg in args) {
    switch (arg) {
      case '--verbose':
        verbose = true;
      case '--help':
      case '-h':
        help = true;
      default:
        return DryRunArgs(usageError: 'Unknown argument: $arg');
    }
  }
  return DryRunArgs(verbose: verbose, help: help);
}

/// The validated result of planning a dry run over a list of jobs.
///
/// [ok] is true only when [errors] is empty. All retained strings are
/// repository-relative paths that are safe to print.
class DryRunReport {
  const DryRunReport._({required this.jobs, required this.errors});

  /// The compositing jobs the plan produced, in plan order.
  final List<StoreScreenshotCompositeJob> jobs;

  /// Validation problems, each a redacted repo-relative-path message. Empty
  /// when the plan is safe to render.
  final List<String> errors;

  /// Whether every job passed validation.
  bool get ok => errors.isEmpty;

  /// Number of planned compositing jobs.
  int get totalJobs => jobs.length;

  /// Distinct locales covered, in first-seen plan order.
  List<String> get locales {
    final seen = <String>[];
    for (final job in jobs) {
      if (!seen.contains(job.locale)) {
        seen.add(job.locale);
      }
    }
    return seen;
  }
}

/// Builds a [DryRunReport] from planned [jobs], using [pathExists] to decide
/// whether each repo-relative path is present on disk.
///
/// `pathExists` is injected so tests can drive validation without real I/O;
/// `main` passes a `File(path).existsSync()` adapter. This function performs
/// no I/O of its own, creates nothing, and writes nothing.
///
/// A job fails validation when any of these hold:
/// - its [StoreScreenshotCompositeJob.rawPath] does not exist;
/// - its [StoreScreenshotCompositeJob.outputPath] already exists;
/// - its output path does not contain `/composited/`, or equals its raw path
///   (a defensive guard against future incompatible path derivation).
DryRunReport buildDryRunReport(
  List<StoreScreenshotCompositeJob> jobs, {
  required bool Function(String path) pathExists,
}) {
  final errors = <String>[];
  for (final job in jobs) {
    if (!pathExists(job.rawPath)) {
      errors.add('Missing raw source: ${job.rawPath}');
    }
    if (pathExists(job.outputPath)) {
      errors.add('Output already exists: ${job.outputPath}');
    }
    if (!job.outputPath.contains(_compositedSegment)) {
      errors.add(
        'Output escaped the composited directory: ${job.outputPath}',
      );
    }
    if (job.outputPath == job.rawPath) {
      errors.add('Output collides with raw source: ${job.rawPath}');
    }
  }
  return DryRunReport._(jobs: jobs, errors: errors);
}

/// Formats [report] into the lines to print, in order.
///
/// When [verbose] is true, one `<locale> <fileName> -> <outputPath>` line is
/// emitted per job before the summary. A passing report ends with a clear
/// "wrote no files" confirmation; a failing report lists each problem.
List<String> formatReport(DryRunReport report, {bool verbose = false}) {
  final lines = <String>['Store screenshot compositor - DRY RUN'];

  if (verbose) {
    for (final job in report.jobs) {
      lines.add('${job.locale} ${job.fileName} -> ${job.outputPath}');
    }
  }

  if (report.ok) {
    lines
      ..add(
        'Planned ${report.totalJobs} composited screenshots across '
        '${report.locales.length} locale(s): ${report.locales.join(', ')}.',
      )
      ..add('All raw sources present; no composited outputs exist yet.')
      ..add(
        'Dry run complete: wrote no files, created no directories, '
        'rendered nothing.',
      );
  } else {
    lines.add(
      'Validation failed; wrote nothing. ${report.errors.length} problem(s):',
    );
    for (final error in report.errors) {
      lines.add('  - $error');
    }
  }

  return lines;
}

/// Usage text shown for `--help` and on a usage error.
String usageText() => '''
Store screenshot compositor dry run (no-write planning tool).

Usage: dart run tool/store_screenshot_compositor_dry_run.dart [options]

Reads the manifest-driven compositing plan, validates every future input and
output path, and prints what would be generated. It is a dry run: it renders
nothing and writes no files or directories.

Options:
  --verbose   Print one "<locale> <fileName> -> <outputPath>" line per job.
  --help, -h  Show this message and exit.''';

/// Entry point: parse flags, plan the dry run, print it, and set [exitCode].
void main(List<String> args) {
  final parsed = parseDryRunArgs(args);

  if (parsed.usageError != null) {
    stderr
      ..writeln(parsed.usageError)
      ..writeln(usageText());
    exitCode = 64; // EX_USAGE
    return;
  }

  if (parsed.help) {
    stdout.writeln(usageText());
    exitCode = 0;
    return;
  }

  final report = buildDryRunReport(
    buildAllCompositeJobs(),
    pathExists: (path) => File(path).existsSync(),
  );

  final sink = report.ok ? stdout : stderr;
  formatReport(report, verbose: parsed.verbose).forEach(sink.writeln);

  exitCode = report.ok ? 0 : 1;
}
