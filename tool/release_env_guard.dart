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
// The guard also gates the release share/invite URL:
//
//   --share-url=<url>
//       The share URL the release will ship. When omitted, the default
//       placeholder https://truerise.app is assumed. A custom URL must be
//       bare HTTPS - host only, no userinfo, no query, no fragment - so it
//       cannot smuggle tracking/personal identifiers into share copy.
//
//   --allow-default-share-url --share-url-purpose=owner-confirmed
//       Required together to release the default placeholder URL.
//
// The guard also gates the release proxy base URL:
//
//   --proxy-base-url=<url>
//       The RECTIFY_PROXY_BASE_URL the release will ship. When omitted, the
//       default placeholder https://proxy.invalid.example is assumed and
//       blocks the release: a public build must route through a real
//       owner-controlled proxy. A custom URL must be a host-only HTTPS
//       origin - host required, no path beyond an optional trailing '/',
//       no userinfo, no query, no fragment - because RECTIFY_PROXY_PATH
//       carries the endpoint path separately, and so the URL cannot
//       smuggle credentials or tracking identifiers into the shipped
//       config.
//
//   --allow-default-proxy-url --proxy-url-purpose=local-test-only
//       Required together to accept the placeholder, and ONLY for
//       local/test builds that never reach users.
//
// The key VALUE is never read into the output: all messages are redacted.
// Rejected custom share URLs are likewise never echoed, since their query,
// fragment, or userinfo parts may carry identifiers. Rejected custom proxy
// URLs are never echoed either: their parts may carry credentials.
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

/// Default share/invite URL placeholder assumed when --share-url is omitted.
const String defaultShareUrl = 'https://truerise.app';

/// The only acknowledgement purpose accepted for the default share URL.
const String requiredShareUrlPurpose = 'owner-confirmed';

/// Default RECTIFY_PROXY_BASE_URL placeholder assumed when --proxy-base-url
/// is omitted.
const String defaultProxyBaseUrl = 'https://proxy.invalid.example';

/// The only acknowledgement purpose accepted for the default proxy URL.
const String requiredProxyUrlPurpose = 'local-test-only';

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

/// Decides whether [shareUrl] may ship in a public release.
///
/// The default placeholder [defaultShareUrl] needs the explicit owner
/// confirmation pair. A custom URL passes only when it is bare HTTPS with a
/// host and carries no userinfo, query, or fragment. Rejected custom URLs
/// are never echoed: their parts may hold tracking/personal identifiers.
({int exitCode, String message}) evaluateShareUrlGate({
  required String shareUrl,
  required bool allowDefaultShareUrl,
  required String? shareUrlPurpose,
}) {
  if (shareUrl == defaultShareUrl) {
    if (allowDefaultShareUrl && shareUrlPurpose == requiredShareUrlPurpose) {
      return (
        exitCode: 0,
        message:
            'ACKNOWLEDGED: default placeholder share URL $defaultShareUrl '
            'accepted for purpose "$requiredShareUrlPurpose".',
      );
    }
    return (
      exitCode: 1,
      message:
          'BLOCKED: the release would ship the default placeholder share '
          'URL $defaultShareUrl. Pass --share-url=<https-url> with the real '
          'owner-controlled URL, or - ONLY if the owner confirms shipping '
          'the placeholder - acknowledge it explicitly with '
          '--allow-default-share-url '
          '--share-url-purpose=$requiredShareUrlPurpose. No other purpose '
          'is accepted.',
    );
  }
  final uri = Uri.tryParse(shareUrl);
  final isBareHttps =
      uri != null &&
      uri.scheme == 'https' &&
      uri.host.isNotEmpty &&
      uri.userInfo.isEmpty &&
      !uri.hasQuery &&
      !uri.hasFragment;
  if (!isBareHttps) {
    return (
      exitCode: 1,
      message:
          'BLOCKED: the custom TRUERISE_SHARE_URL value (redacted) is not a '
          'bare HTTPS URL. It must use https://, name a host, and carry no '
          'userinfo, no query, and no fragment, so the shipped share copy '
          'cannot leak tracking/personal identifiers.',
    );
  }
  return (
    exitCode: 0,
    message:
        'OK: custom share URL accepted (bare HTTPS, no userinfo, no '
        'query, no fragment).',
  );
}

/// Decides whether [proxyBaseUrl] may ship in a public release.
///
/// The default placeholder [defaultProxyBaseUrl] blocks the release - a
/// public build must route through a real owner-controlled proxy - unless
/// the explicit local/test-only acknowledgement pair is given. A custom URL
/// passes only when it is a host-only HTTPS origin: a host, no path beyond
/// an optional trailing '/', and no userinfo, query, or fragment.
/// RECTIFY_PROXY_PATH carries the endpoint path separately, so a path here
/// is always a misconfiguration. Rejected custom URLs are never echoed:
/// their parts may hold credentials or tracking identifiers.
({int exitCode, String message}) evaluateProxyUrlGate({
  required String proxyBaseUrl,
  required bool allowDefaultProxyUrl,
  required String? proxyUrlPurpose,
}) {
  if (proxyBaseUrl == defaultProxyBaseUrl) {
    if (allowDefaultProxyUrl && proxyUrlPurpose == requiredProxyUrlPurpose) {
      return (
        exitCode: 0,
        message:
            'ACKNOWLEDGED: default placeholder proxy URL $defaultProxyBaseUrl '
            'accepted for purpose "$requiredProxyUrlPurpose". This build must '
            'never ship to users.',
      );
    }
    return (
      exitCode: 1,
      message:
          'BLOCKED: the release would ship the default placeholder '
          'RECTIFY_PROXY_BASE_URL $defaultProxyBaseUrl. Pass '
          '--proxy-base-url=<https-url> with the real owner-controlled proxy '
          'URL, or - ONLY for a local/test build that never reaches users - '
          'acknowledge the placeholder explicitly with '
          '--allow-default-proxy-url '
          '--proxy-url-purpose=$requiredProxyUrlPurpose. No other purpose '
          'is accepted.',
    );
  }
  final uri = Uri.tryParse(proxyBaseUrl);
  final isBareHttpsOrigin =
      uri != null &&
      uri.scheme == 'https' &&
      uri.host.isNotEmpty &&
      uri.userInfo.isEmpty &&
      (uri.path.isEmpty || uri.path == '/') &&
      !uri.hasQuery &&
      !uri.hasFragment;
  if (!isBareHttpsOrigin) {
    return (
      exitCode: 1,
      message:
          'BLOCKED: the custom RECTIFY_PROXY_BASE_URL value (redacted) is '
          'not a host-only HTTPS origin. It must use https://, name a host, '
          'and carry no path (a single trailing "/" is allowed), no '
          'userinfo, no query, and no fragment - RECTIFY_PROXY_PATH carries '
          'the endpoint path separately - so the shipped config cannot leak '
          'credentials or tracking identifiers.',
    );
  }
  return (
    exitCode: 0,
    message:
        'OK: custom proxy base URL accepted (host-only HTTPS origin, no '
        'path, no userinfo, no query, no fragment).',
  );
}

/// Parses [args], reads the env file, and returns the guard outcome.
/// A missing env file counts as "no key" (nothing can be bundled).
/// The share-url gate runs first, then the proxy-url gate; the bundled-key
/// gate is unchanged.
({int exitCode, String message}) runGuard(List<String> args) {
  var envFilePath = '.env';
  var allowBundledKey = false;
  String? purpose;
  var shareUrl = defaultShareUrl;
  var allowDefaultShareUrl = false;
  String? shareUrlPurpose;
  var proxyBaseUrl = defaultProxyBaseUrl;
  var allowDefaultProxyUrl = false;
  String? proxyUrlPurpose;

  for (final arg in args) {
    if (arg.startsWith('--env-file=')) {
      envFilePath = arg.substring('--env-file='.length);
    } else if (arg == '--allow-bundled-key') {
      allowBundledKey = true;
    } else if (arg.startsWith('--purpose=')) {
      purpose = arg.substring('--purpose='.length);
    } else if (arg.startsWith('--share-url=')) {
      shareUrl = arg.substring('--share-url='.length);
    } else if (arg == '--allow-default-share-url') {
      allowDefaultShareUrl = true;
    } else if (arg.startsWith('--share-url-purpose=')) {
      shareUrlPurpose = arg.substring('--share-url-purpose='.length);
    } else if (arg.startsWith('--proxy-base-url=')) {
      proxyBaseUrl = arg.substring('--proxy-base-url='.length);
    } else if (arg == '--allow-default-proxy-url') {
      allowDefaultProxyUrl = true;
    } else if (arg.startsWith('--proxy-url-purpose=')) {
      proxyUrlPurpose = arg.substring('--proxy-url-purpose='.length);
    } else {
      return (
        exitCode: 2,
        message:
            'Unknown argument "$arg". Usage: dart run '
            'tool/release_env_guard.dart [--env-file=<path>] '
            '[--allow-bundled-key --purpose=$requiredPurpose] '
            '[--share-url=<https-url>] '
            '[--allow-default-share-url '
            '--share-url-purpose=$requiredShareUrlPurpose] '
            '[--proxy-base-url=<https-url>] '
            '[--allow-default-proxy-url '
            '--proxy-url-purpose=$requiredProxyUrlPurpose]',
      );
    }
  }

  final shareUrlResult = evaluateShareUrlGate(
    shareUrl: shareUrl,
    allowDefaultShareUrl: allowDefaultShareUrl,
    shareUrlPurpose: shareUrlPurpose,
  );
  if (shareUrlResult.exitCode != 0) return shareUrlResult;

  final proxyUrlResult = evaluateProxyUrlGate(
    proxyBaseUrl: proxyBaseUrl,
    allowDefaultProxyUrl: allowDefaultProxyUrl,
    proxyUrlPurpose: proxyUrlPurpose,
  );
  if (proxyUrlResult.exitCode != 0) return proxyUrlResult;

  final envFile = File(envFilePath);
  final keyPresent =
      envFile.existsSync() && envContainsBundledKey(envFile.readAsStringSync());

  final keyResult = evaluateGuard(
    keyPresent: keyPresent,
    allowBundledKey: allowBundledKey,
    purpose: purpose,
  );
  if (keyResult.exitCode != 0) return keyResult;

  return (
    exitCode: 0,
    message:
        '${keyResult.message}\n${shareUrlResult.message}\n'
        '${proxyUrlResult.message}',
  );
}

void main(List<String> args) {
  final result = runGuard(args);
  (result.exitCode == 0 ? stdout : stderr).writeln(result.message);
  exitCode = result.exitCode;
}
