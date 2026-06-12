// Release-safety guard for the tracked, asset-bundled `.env`.
//
// The repo intentionally ships `.env` as a Flutter asset so review/demo
// builds boot with a live key (see README "Security boundary" and
// `docs/api-integration.md`). Assets are extractable from any public
// APK/AAB/IPA, so a public release must bundle either NO provider key or
// an explicitly acknowledged low-budget, capped, rotatable review key.
//
// This script enforces that locally and from CI/Gradle:
//
//   dart run tool/release_env_guard.dart
//       Exits non-zero when `.env` carries a non-empty ASTRO_API_KEY.
//
//   dart run tool/release_env_guard.dart --allow-bundled-key \
//       --purpose=review-capped
//       Exits 0, acknowledging the bundled key as a capped review key.
//
//   --env-file=<path> overrides the checked file (used by tests).
//
// The key VALUE is never read into the output: all messages are redacted.
// Android release builds run the same check via the
// `validateReleaseBundledEnv` Gradle task; for iOS (no Gradle) run this
// script manually before `flutter build ipa`.
//
// Dependency-free by design: only dart:io, so it runs with a bare Dart
// SDK and is trivially testable.

import 'dart:io';

/// The provider-key entry the guard looks for.
const String guardedKeyName = 'ASTRO_API_KEY';

/// The only acknowledgement purpose the guard accepts.
const String requiredPurpose = 'review-capped';

/// `true` when [envContent] defines a non-empty [guardedKeyName] value.
///
/// Comment lines are ignored. Surrounding single/double quotes around the
/// value are stripped before the emptiness check, so `KEY=""` counts as
/// empty. The value itself is never returned anywhere.
bool envContainsBundledKey(String envContent) {
  for (final rawLine in envContent.split('\n')) {
    final line = rawLine.trim();
    if (line.isEmpty || line.startsWith('#')) continue;
    final match = RegExp('^$guardedKeyName\\s*=(.*)\$').firstMatch(line);
    if (match == null) continue;
    var value = match.group(1)!.trim();
    if (value.length >= 2 &&
        ((value.startsWith('"') && value.endsWith('"')) ||
            (value.startsWith("'") && value.endsWith("'")))) {
      value = value.substring(1, value.length - 1).trim();
    }
    if (value.isNotEmpty) return true;
  }
  return false;
}

/// Pure decision core. Returns the process exit code plus the (always
/// redacted) message to print. Separated from I/O so tests can cover
/// every branch without spawning processes.
({int exitCode, String message}) evaluateGuard({
  required bool keyPresent,
  required bool allowBundledKey,
  required String? purpose,
}) {
  if (!keyPresent) {
    return (
      exitCode: 0,
      message:
          'OK: no bundled $guardedKeyName found - safe to build a public '
          'release without a provider key.',
    );
  }
  if (allowBundledKey) {
    if (purpose == requiredPurpose) {
      return (
        exitCode: 0,
        message:
            'ACKNOWLEDGED: bundled $guardedKeyName (value redacted) accepted '
            'for purpose "$requiredPurpose". The shipped key must be a '
            'low-budget, capped, rotatable review/demo key - never a '
            'production key.',
      );
    }
    return (
      exitCode: 1,
      message:
          'BLOCKED: --allow-bundled-key requires --purpose=$requiredPurpose '
          'to confirm the bundled $guardedKeyName (value redacted) is a '
          'low-budget capped review key. No other purpose is accepted.',
    );
  }
  return (
    exitCode: 1,
    message:
        'BLOCKED: the tracked .env bundles a non-empty $guardedKeyName '
        '(value redacted) as a Flutter asset. Assets are extractable from '
        'a public APK/AAB/IPA, so a public release must not ship an '
        'unacknowledged provider key.\n'
        'Either remove $guardedKeyName from the bundled env file, or - '
        'ONLY if the key is a low-budget, capped, rotatable review key - '
        'acknowledge it explicitly:\n'
        '  dart run tool/release_env_guard.dart --allow-bundled-key '
        '--purpose=$requiredPurpose\n'
        'Android release builds accept the same acknowledgement via\n'
        '  -Ptruerise.allowBundledApiKey=true '
        '-Ptruerise.bundledApiKeyPurpose=$requiredPurpose\n'
        'See README "Security boundary" and docs/api-integration.md.',
  );
}

/// Parses [args], reads the env file, and returns the guard outcome.
/// A missing env file counts as "no key" (nothing can be bundled).
({int exitCode, String message}) runGuard(List<String> args) {
  var envFilePath = '.env';
  var allowBundledKey = false;
  String? purpose;

  for (final arg in args) {
    if (arg.startsWith('--env-file=')) {
      envFilePath = arg.substring('--env-file='.length);
    } else if (arg == '--allow-bundled-key') {
      allowBundledKey = true;
    } else if (arg.startsWith('--purpose=')) {
      purpose = arg.substring('--purpose='.length);
    } else {
      return (
        exitCode: 2,
        message:
            'Unknown argument "$arg". Usage: dart run '
            'tool/release_env_guard.dart [--env-file=<path>] '
            '[--allow-bundled-key --purpose=$requiredPurpose]',
      );
    }
  }

  final envFile = File(envFilePath);
  final keyPresent =
      envFile.existsSync() && envContainsBundledKey(envFile.readAsStringSync());

  return evaluateGuard(
    keyPresent: keyPresent,
    allowBundledKey: allowBundledKey,
    purpose: purpose,
  );
}

void main(List<String> args) {
  final result = runGuard(args);
  (result.exitCode == 0 ? stdout : stderr).writeln(result.message);
  exitCode = result.exitCode;
}
