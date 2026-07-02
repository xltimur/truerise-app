// Tests for the guarded write CLI seam over the store screenshot compositing
// pipeline (`tool/store_screenshot_compositor_write.dart`).
//
// These exercise the CLI's pure, injectable seams only: flag parsing and the
// `runWriteCli` orchestrator. Every disk-touching case runs inside a fresh
// temporary directory with a stub renderer, so nothing here renders pixels,
// imports `dart:ui`, or writes under the repository's `screenshots/store/`.
// The real Flutter-engine (dart:ui) render path is covered separately by
// `store_screenshot_compositor_write_harness_test.dart`.

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/store_screenshot_compositor_write.dart';
import 'store_screenshot_compositor_plan.dart';
import 'store_screenshot_compositor_repo_state.dart';

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

/// Readiness for [locale] that blocks final composites (pre-Appeeky reference
/// captures that still require newly captured frames).
CaptionPlanReadiness _blockedReadiness(String locale) =>
    readLocaleCaptionPlanReadiness(locale, <String, dynamic>{
      'captionPlanStatus': 'pre_appeeky_reference_raw_captures',
      'currentCaptionPlanRequiresNewFrames': true,
    });

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

void main() {
  group('parseWriteCliArgs', () {
    test('defaults to a safe no-write run', () {
      final args = parseWriteCliArgs(const <String>[]);
      expect(args.write, isFalse);
      expect(args.confirm, isFalse);
      expect(args.allowOverwrite, isFalse);
      expect(args.verbose, isFalse);
      expect(args.help, isFalse);
      expect(args.usageError, isNull);
    });

    test('recognizes --write, --yes, and --allow-overwrite together', () {
      final args = parseWriteCliArgs(
        const <String>['--write', '--yes', '--allow-overwrite'],
      );
      expect(args.write, isTrue);
      expect(args.confirm, isTrue);
      expect(args.allowOverwrite, isTrue);
      expect(args.usageError, isNull);
    });

    test('recognizes --help and -h', () {
      expect(parseWriteCliArgs(const <String>['--help']).help, isTrue);
      expect(parseWriteCliArgs(const <String>['-h']).help, isTrue);
    });

    test('rejects an unknown flag with a usage error', () {
      final args = parseWriteCliArgs(const <String>['--bogus']);
      expect(args.usageError, isNotNull);
      expect(args.usageError, contains('--bogus'));
    });

    test('usageText documents the write/confirm gating', () {
      final text = usageText().toLowerCase();
      expect(text, contains('--write'));
      expect(text, contains('--yes'));
    });
  });

  group('runWriteCli gating', () {
    late Directory root;

    setUp(() {
      root = Directory.systemTemp.createTempSync('store_write_cli_test');
    });
    tearDown(() {
      if (root.existsSync()) {
        root.deleteSync(recursive: true);
      }
    });

    test('default run writes nothing and says so', () async {
      final renderer = _RecordingRenderer();
      final jobs = <StoreScreenshotCompositeJob>[_job('01-result-hero.png')];

      final result = await runWriteCli(
        parseWriteCliArgs(const <String>[]),
        jobs: jobs,
        root: root,
        render: renderer.render,
        readiness: const <CaptionPlanReadiness>[],
      );

      expect(result.wroteFiles, isFalse);
      expect(result.writtenOutputPaths, isEmpty);
      expect(result.exitCode, 0);
      expect(renderer.renderedFiles, isEmpty);
      expect(
        result.lines.join('\n').toLowerCase(),
        contains('no files written'),
      );
      expect(
        File('${root.path}/${jobs.single.outputPath}').existsSync(),
        isFalse,
      );
      expectCommittedCompositedState();
    });

    test('--write without --yes refuses and renders nothing', () async {
      final renderer = _RecordingRenderer();
      final job = _job('01-result-hero.png');
      _seedRaw(root, job, 'raw-bytes');

      final result = await runWriteCli(
        parseWriteCliArgs(const <String>['--write']),
        jobs: <StoreScreenshotCompositeJob>[job],
        root: root,
        render: renderer.render,
        readiness: const <CaptionPlanReadiness>[],
      );

      expect(result.wroteFiles, isFalse);
      expect(result.exitCode, isNot(0));
      expect(renderer.renderedFiles, isEmpty);
      expect(result.lines.join('\n').toLowerCase(), contains('--yes'));
      expect(File('${root.path}/${job.outputPath}').existsSync(), isFalse);
      expectCommittedCompositedState();
    });
  });

  group('runWriteCli --write --yes (temp dir, stub renderer)', () {
    late Directory root;

    setUp(() {
      root = Directory.systemTemp.createTempSync('store_write_cli_test');
    });
    tearDown(() {
      if (root.existsSync()) {
        root.deleteSync(recursive: true);
      }
    });

    test('writes composited bytes and reports count and repo paths', () async {
      final renderer = _RecordingRenderer();
      final job = _job('01-result-hero.png');
      _seedRaw(root, job, 'raw-bytes');

      final result = await runWriteCli(
        parseWriteCliArgs(const <String>['--write', '--yes']),
        jobs: <StoreScreenshotCompositeJob>[job],
        root: root,
        render: renderer.render,
        readiness: const <CaptionPlanReadiness>[],
      );

      expect(result.wroteFiles, isTrue);
      expect(result.exitCode, 0);
      expect(result.writtenOutputPaths, <String>[job.outputPath]);
      expect(renderer.renderedFiles, <String>['01-result-hero.png']);

      final text = result.lines.join('\n');
      expect(text, contains('1'));
      expect(text, contains(job.outputPath));

      final out = File('${root.path}/${job.outputPath}');
      expect(out.existsSync(), isTrue);
      expect(out.readAsStringSync(), 'composited:01-result-hero.png');
      expectCommittedCompositedState();
    });

    test('refuses an existing output unless --allow-overwrite', () async {
      final renderer = _RecordingRenderer();
      final job = _job('01-result-hero.png');
      _seedRaw(root, job, 'raw-bytes');
      final out = File('${root.path}/${job.outputPath}')
        ..parent.createSync(recursive: true)
        ..writeAsStringSync('original');

      final result = await runWriteCli(
        parseWriteCliArgs(const <String>['--write', '--yes']),
        jobs: <StoreScreenshotCompositeJob>[job],
        root: root,
        render: renderer.render,
        readiness: const <CaptionPlanReadiness>[],
      );

      expect(result.wroteFiles, isFalse);
      expect(result.exitCode, isNot(0));
      expect(renderer.renderedFiles, isEmpty);
      expect(out.readAsStringSync(), 'original');
      expectCommittedCompositedState();
    });

    test('--allow-overwrite replaces the existing output', () async {
      final renderer = _RecordingRenderer();
      final job = _job('01-result-hero.png');
      _seedRaw(root, job, 'raw-bytes');
      final out = File('${root.path}/${job.outputPath}')
        ..parent.createSync(recursive: true)
        ..writeAsStringSync('original');

      final result = await runWriteCli(
        parseWriteCliArgs(
          const <String>['--write', '--yes', '--allow-overwrite'],
        ),
        jobs: <StoreScreenshotCompositeJob>[job],
        root: root,
        render: renderer.render,
        readiness: const <CaptionPlanReadiness>[],
      );

      expect(result.wroteFiles, isTrue);
      expect(result.writtenOutputPaths, <String>[job.outputPath]);
      expect(out.readAsStringSync(), 'composited:01-result-hero.png');
      expectCommittedCompositedState();
    });

    test(
      'reports a refusal without writing when a raw source is missing',
      () async {
        final renderer = _RecordingRenderer();
        final job = _job('01-result-hero.png');
        // Intentionally do not seed the raw source under root.

        final result = await runWriteCli(
          parseWriteCliArgs(const <String>['--write', '--yes']),
          jobs: <StoreScreenshotCompositeJob>[job],
          root: root,
          render: renderer.render,
          readiness: const <CaptionPlanReadiness>[],
        );

        expect(result.wroteFiles, isFalse);
        expect(result.exitCode, isNot(0));
        expect(renderer.renderedFiles, isEmpty);
        expect(result.lines.join('\n'), contains(job.rawPath));
        expectCommittedCompositedState();
      },
    );

    test(
      'refuses --write --yes when a manifest blocks final composites',
      () async {
        final renderer = _RecordingRenderer();
        final job = _job('01-result-hero.png');
        _seedRaw(root, job, 'raw-bytes');

        final result = await runWriteCli(
          parseWriteCliArgs(const <String>['--write', '--yes']),
          jobs: <StoreScreenshotCompositeJob>[job],
          root: root,
          render: renderer.render,
          readiness: <CaptionPlanReadiness>[_blockedReadiness('en')],
        );

        expect(result.wroteFiles, isFalse);
        expect(result.exitCode, isNot(0));
        expect(renderer.renderedFiles, isEmpty);

        final text = result.lines.join('\n').toLowerCase();
        expect(text, contains('blocked'));
        expect(text, contains('5-frame'));
        expect(text, contains('captions'));
        expect(text, contains('en'));

        expect(File('${root.path}/${job.outputPath}').existsSync(), isFalse);
        expectCommittedCompositedState();
      },
    );

    test(
      'still writes when readiness reports no blocking manifests',
      () async {
        final renderer = _RecordingRenderer();
        final job = _job('01-result-hero.png');
        _seedRaw(root, job, 'raw-bytes');

        final ready = readLocaleCaptionPlanReadiness('en', <String, dynamic>{
          'captionPlanStatus': 'final_appeeky_captions',
          'currentCaptionPlanRequiresNewFrames': false,
        });

        final result = await runWriteCli(
          parseWriteCliArgs(const <String>['--write', '--yes']),
          jobs: <StoreScreenshotCompositeJob>[job],
          root: root,
          render: renderer.render,
          readiness: <CaptionPlanReadiness>[ready],
        );

        expect(result.wroteFiles, isTrue);
        expect(result.exitCode, 0);
        expect(result.writtenOutputPaths, <String>[job.outputPath]);
        expectCommittedCompositedState();
      },
    );
  });

  group('runWriteCli preview surfaces blocked readiness', () {
    test('preview reports the blocked status but writes nothing', () async {
      final renderer = _RecordingRenderer();
      final jobs = <StoreScreenshotCompositeJob>[_job('01-result-hero.png')];

      final result = await runWriteCli(
        parseWriteCliArgs(const <String>[]),
        jobs: jobs,
        root: Directory.systemTemp,
        render: renderer.render,
        readiness: <CaptionPlanReadiness>[_blockedReadiness('en')],
      );

      expect(result.wroteFiles, isFalse);
      expect(result.exitCode, 0);
      expect(renderer.renderedFiles, isEmpty);

      final text = result.lines.join('\n').toLowerCase();
      expect(text, contains('blocked'));
      expect(text, contains('--write --yes'));
      expectCommittedCompositedState();
    });
  });

  group('runWriteCli preview over the real on-disk plan', () {
    test('previews 25 planned jobs and writes nothing to the repo', () async {
      expectCommittedCompositedState();
      final renderer = _RecordingRenderer();

      // Pointed at the repo root on purpose: the no-write default must still
      // write nothing even when `root` is the real repository.
      final result = await runWriteCli(
        parseWriteCliArgs(const <String>[]),
        jobs: buildAllCompositeJobs(),
        root: Directory.current,
        render: renderer.render,
        readiness: readAllCaptionPlanReadiness(),
      );

      expect(result.wroteFiles, isFalse);
      expect(renderer.renderedFiles, isEmpty);
      expect(result.lines.join('\n'), contains('25'));
      expectCommittedCompositedState();
    });
  });
}
