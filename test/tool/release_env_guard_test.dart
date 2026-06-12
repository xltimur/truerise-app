import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/release_env_guard.dart';

/// Obviously-fake key used to prove redaction; never a real credential.
const String _fakeKey = 'fake-test-key-A1B2C3-not-real';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('release_env_guard_test');
  });

  tearDown(() async {
    await tempDir.delete(recursive: true);
  });

  Future<String> writeEnv(String content) async {
    final file = File('${tempDir.path}/.env');
    await file.writeAsString(content);
    return file.path;
  }

  group('default mode (no acknowledgement)', () {
    test('fails when ASTRO_API_KEY is present, with redacted output', () async {
      final path = await writeEnv('ASTRO_API_KEY=$_fakeKey\n');

      final result = runGuard(['--env-file=$path']);

      expect(result.exitCode, isNot(0));
      expect(result.message, contains('ASTRO_API_KEY'));
      expect(result.message, contains('redacted'));
      expect(
        result.message,
        isNot(contains(_fakeKey)),
        reason: 'the guard must never print the key value',
      );
    });

    test('fails for a quoted non-empty key too', () async {
      final path = await writeEnv('ASTRO_API_KEY="$_fakeKey"\n');

      final result = runGuard(['--env-file=$path']);

      expect(result.exitCode, isNot(0));
      expect(result.message, isNot(contains(_fakeKey)));
    });

    test('passes when the env file is missing', () {
      final result = runGuard(['--env-file=${tempDir.path}/does-not-exist']);

      expect(result.exitCode, 0);
    });

    test('passes when the key is absent', () async {
      final path = await writeEnv('OTHER_SETTING=1\n');

      expect(runGuard(['--env-file=$path']).exitCode, 0);
    });

    test('passes when the key is empty or commented out', () async {
      final empty = await writeEnv('ASTRO_API_KEY=\n');
      expect(runGuard(['--env-file=$empty']).exitCode, 0);

      final quotedEmpty = await writeEnv('ASTRO_API_KEY=""\n');
      expect(runGuard(['--env-file=$quotedEmpty']).exitCode, 0);

      final commented = await writeEnv('# ASTRO_API_KEY=$_fakeKey\n');
      expect(runGuard(['--env-file=$commented']).exitCode, 0);
    });
  });

  group('explicit allow mode', () {
    test('succeeds with --allow-bundled-key --purpose=review-capped and '
        'stays redacted', () async {
      final path = await writeEnv('ASTRO_API_KEY=$_fakeKey\n');

      final result = runGuard([
        '--env-file=$path',
        '--allow-bundled-key',
        '--purpose=review-capped',
      ]);

      expect(result.exitCode, 0);
      expect(result.message, contains('review-capped'));
      expect(result.message, contains('redacted'));
      expect(result.message, isNot(contains(_fakeKey)));
    });

    test('fails without a purpose', () async {
      final path = await writeEnv('ASTRO_API_KEY=$_fakeKey\n');

      final result = runGuard(['--env-file=$path', '--allow-bundled-key']);

      expect(result.exitCode, isNot(0));
      expect(result.message, contains('review-capped'));
      expect(result.message, isNot(contains(_fakeKey)));
    });

    test('fails with a wrong purpose', () async {
      final path = await writeEnv('ASTRO_API_KEY=$_fakeKey\n');

      final result = runGuard([
        '--env-file=$path',
        '--allow-bundled-key',
        '--purpose=production',
      ]);

      expect(result.exitCode, isNot(0));
      expect(result.message, isNot(contains(_fakeKey)));
    });
  });

  test('rejects unknown arguments with usage help', () {
    final result = runGuard(['--bogus']);

    expect(result.exitCode, 2);
    expect(result.message, contains('Usage'));
  });
}
