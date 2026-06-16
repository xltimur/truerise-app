// Tests for the no-write dry-run CLI over the store screenshot compositing
// plan (`tool/store_screenshot_compositor_dry_run.dart`).
//
// These exercise the tool's pure, injectable seams only: argument parsing,
// report building (with an injected `pathExists` so no real I/O decides the
// outcome), and report formatting. They never render, never import the
// renderer, and never create files or directories.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/store_screenshot_compositor_dry_run.dart';
import 'screenshot_compositor.dart';
import 'store_screenshot_compositor_plan.dart';

/// A `pathExists` stub modelling the healthy state the dry run expects:
/// every raw source is present, and no `composited/` output exists yet.
bool _rawsPresentOutputsAbsent(String path) => !path.contains('/composited/');

/// Fails if any `composited/` directory exists under a supported locale.
void _expectNoCompositedDirs() {
  for (final locale in supportedStoreLocales) {
    final dir = Directory('$kStoreScreenshotsRoot/$locale/$kCompositedDirName');
    expect(dir.existsSync(), isFalse, reason: dir.path);
  }
}

void main() {
  group('buildDryRunReport (real on-disk plan)', () {
    test('reports 25 jobs across 5 locales with nothing missing', () {
      _expectNoCompositedDirs();

      final jobs = buildAllCompositeJobs();
      final report = buildDryRunReport(
        jobs,
        pathExists: (path) => File(path).existsSync(),
      );

      expect(report.ok, isTrue, reason: report.errors.join('\n'));
      expect(report.errors, isEmpty);
      expect(report.totalJobs, 25);
      expect(report.locales.length, 5);
      expect(report.locales, orderedEquals(supportedStoreLocales));

      // Building the report must not have created any output directories.
      _expectNoCompositedDirs();
    });
  });

  group('formatReport', () {
    test('verbose output lists every job from first to last', () {
      final jobs = buildAllCompositeJobs();
      final report = buildDryRunReport(
        jobs,
        pathExists: _rawsPresentOutputsAbsent,
      );

      final text = formatReport(report, verbose: true).join('\n');

      final first = jobs.first;
      final last = jobs.last;
      expect(
        text,
        contains('${first.locale} ${first.fileName} -> ${first.outputPath}'),
      );
      expect(
        text,
        contains('${last.locale} ${last.fileName} -> ${last.outputPath}'),
      );
    });

    test('non-verbose summary states the dry run wrote no files', () {
      final jobs = buildAllCompositeJobs();
      final report = buildDryRunReport(
        jobs,
        pathExists: _rawsPresentOutputsAbsent,
      );

      final text = formatReport(report).join('\n').toLowerCase();

      expect(text, contains('dry run'));
      expect(text, contains('no files'));
      expect(text, contains('25'));
    });
  });

  group('buildDryRunReport validation failures', () {
    test('fails when a raw source is reported missing', () {
      final jobs = buildAllCompositeJobs();
      final missing = jobs.first.rawPath;

      final report = buildDryRunReport(
        jobs,
        pathExists: (path) =>
            path != missing && _rawsPresentOutputsAbsent(path),
      );

      expect(report.ok, isFalse);
      expect(report.errors.join('\n'), contains(missing));
    });

    test('fails when an output path already exists', () {
      final jobs = buildAllCompositeJobs();
      final existing = jobs.first.outputPath;

      final report = buildDryRunReport(
        jobs,
        pathExists: (path) =>
            path == existing || _rawsPresentOutputsAbsent(path),
      );

      expect(report.ok, isFalse);
      expect(report.errors.join('\n'), contains(existing));
    });
  });

  group('dry run surfaces caption-plan readiness', () {
    CaptionPlanReadiness blockedReadiness(String locale) =>
        readLocaleCaptionPlanReadiness(locale, <String, dynamic>{
          'captionPlanStatus': 'pre_appeeky_reference_raw_captures',
          'currentCaptionPlanRequiresNewFrames': true,
        });

    test('surfaces a final-not-ready status when a manifest is blocked', () {
      final jobs = buildAllCompositeJobs();
      final report = buildDryRunReport(
        jobs,
        pathExists: _rawsPresentOutputsAbsent,
        readiness: <CaptionPlanReadiness>[blockedReadiness('en')],
      );

      // The dry run is still allowed: path validation found no problems.
      expect(report.ok, isTrue);

      final text = formatReport(report).join('\n').toLowerCase();
      expect(text, contains('not ready'));
      expect(text, contains('captions'));
      expect(text, contains('en'));
    });

    test('omits the not-ready status when no manifest is blocked', () {
      final jobs = buildAllCompositeJobs();
      final report = buildDryRunReport(
        jobs,
        pathExists: _rawsPresentOutputsAbsent,
      );

      final text = formatReport(report).join('\n').toLowerCase();
      expect(text, isNot(contains('not ready')));
    });

    test(
      'the real on-disk plan currently reports final composites not ready',
      () {
        final report = buildDryRunReport(
          buildAllCompositeJobs(),
          pathExists: _rawsPresentOutputsAbsent,
          readiness: readAllCaptionPlanReadiness(),
        );

        final text = formatReport(report).join('\n').toLowerCase();
        expect(text, contains('not ready'));
      },
    );
  });

  group('parseDryRunArgs', () {
    test('defaults to a quiet, valid run with no flags', () {
      final args = parseDryRunArgs(const <String>[]);
      expect(args.verbose, isFalse);
      expect(args.help, isFalse);
      expect(args.usageError, isNull);
    });

    test('recognizes --verbose', () {
      final args = parseDryRunArgs(const <String>['--verbose']);
      expect(args.verbose, isTrue);
      expect(args.usageError, isNull);
    });

    test('recognizes --help', () {
      final args = parseDryRunArgs(const <String>['--help']);
      expect(args.help, isTrue);
      expect(args.usageError, isNull);
    });

    test('rejects an unknown flag with a usage error', () {
      final args = parseDryRunArgs(const <String>['--bogus']);
      expect(args.usageError, isNotNull);
      expect(args.usageError, contains('--bogus'));
    });

    test('usageText explains the dry run', () {
      expect(usageText().toLowerCase(), contains('dry run'));
    });
  });
}
