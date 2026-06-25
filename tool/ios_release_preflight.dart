// Local iOS / App Store release preflight for TrueRise.
//
// Checks the repository working tree for iOS-specific App Store readiness
// items that can be verified locally without touching Apple servers.
//
// Dependency-free: only dart:io, so it runs with a bare Dart SDK and all
// decision functions are testable as pure functions.
//
// Usage:
//   dart run tool/ios_release_preflight.dart            (blocking / final mode)
//   dart run tool/ios_release_preflight.dart \
//       --allow-missing-export-options              (audit / review mode)
//
// Flags:
//   --pbxproj=<path>
//       Override the pbxproj path. Default:
//       ios/Runner.xcodeproj/project.pbxproj
//       (Used by tests; pass a temp-file path.)
//   --export-options-plist=<path>
//       Override the ExportOptions.plist path check. Default:
//       ios/ExportOptions.plist
//       (Used by tests; pass a temp-file path.)
//   --privacy-html=<path>
//       Override the site/privacy.html path check. Default:
//       site/privacy.html
//   --support-html=<path>
//       Override the site/support.html path check. Default:
//       site/support.html
//   --allow-current-bundle-id --bundle-id-purpose=owner-confirmed-current
//       Deprecated compatibility flags. They are parsed so old shell snippets
//       do not fail with a usage error, but they no longer suppress bundle-ID
//       blockers now that the final ID is ua.com.truerise.app.
//   --allow-missing-export-options
//       Suppress the ExportOptions.plist blocker. For audit/review mode
//       before the owner has supplied signing material. The template
//       ios/ExportOptions.app-store.example.plist remains the reference.
//   --privacy-policy-url=<https-url>
//       Optional: validate a bare-HTTPS privacy-policy URL. No path
//       fragment or userinfo. Intended value once hosting is live:
//       https://truerise.com.ua/privacy.html
//   --share-url=<https-url>
//       Optional: validate the share/invite landing URL. Must be bare
//       HTTPS with no userinfo, query, or fragment. Example:
//       https://truerise.com.ua
//
// Exit codes: 0 = all checks passed, 1 = one or more blockers,
//             2 = usage error.
//
// All check runs accumulate output; blockers do not short-circuit
// other checks so the owner sees the full picture in one pass.

import 'dart:io';

const String _finalBundleId = 'ua.com.truerise.app';
const String _legacyBundleId = 'com.rectify.rectify';
const String _defaultPbxprojPath = 'ios/Runner.xcodeproj/project.pbxproj';
const String _defaultExportOptionsPlistPath = 'ios/ExportOptions.plist';
const String exportOptionsExamplePath =
    'ios/ExportOptions.app-store.example.plist';
const String _defaultPrivacyHtmlPath = 'site/privacy.html';
const String _defaultSupportHtmlPath = 'site/support.html';
const String _deprecatedBundleIdPurpose = 'owner-confirmed-current';

// ---------------------------------------------------------------------------
// Pure check functions (no I/O; testable directly)
// ---------------------------------------------------------------------------

/// Returns the set of Runner (non-test) PRODUCT_BUNDLE_IDENTIFIER values
/// found in [pbxprojContent].
///
/// Values whose lowercase form contains "test" are assumed to belong to
/// the RunnerTests target and are excluded.
Set<String> extractRunnerBundleIds(String pbxprojContent) {
  final re = RegExp(r'PRODUCT_BUNDLE_IDENTIFIER\s*=\s*([^;]+)\s*;');
  final ids = <String>{};
  for (final m in re.allMatches(pbxprojContent)) {
    var v = m.group(1)!.trim();
    if (v.startsWith('"') && v.endsWith('"')) {
      v = v.substring(1, v.length - 1).trim();
    }
    if (!v.toLowerCase().contains('test')) {
      ids.add(v);
    }
  }
  return ids;
}

/// Returns true when [pbxprojContent] contains at least one non-empty
/// DEVELOPMENT_TEAM value.
bool pbxprojHasDevelopmentTeam(String pbxprojContent) {
  final re = RegExp(r'DEVELOPMENT_TEAM\s*=\s*([^;]+)\s*;');
  for (final m in re.allMatches(pbxprojContent)) {
    var v = m.group(1)!.trim();
    if (v.startsWith('"') && v.endsWith('"')) {
      v = v.substring(1, v.length - 1).trim();
    }
    if (v.isNotEmpty) return true;
  }
  return false;
}

/// Returns true when [pbxprojContent] contains at least one
/// CODE_SIGN_STYLE = Automatic entry.
bool pbxprojHasAutomaticSigning(String pbxprojContent) {
  return RegExp(
    r'CODE_SIGN_STYLE\s*=\s*Automatic\s*;',
  ).hasMatch(pbxprojContent);
}

/// Returns true when [pbxprojContent] contains at least one App Store-capable
/// distribution signing identity entry.
bool pbxprojHasDistributionSigningIdentity(String pbxprojContent) {
  return pbxprojContent.contains(
        '"CODE_SIGN_IDENTITY[sdk=iphoneos*]" = "iPhone Distribution"',
      ) ||
      pbxprojContent.contains(
        '"CODE_SIGN_IDENTITY[sdk=iphoneos*]" = "Apple Distribution"',
      ) ||
      pbxprojContent.contains('CODE_SIGN_IDENTITY = "Apple Distribution"');
}

/// Returns true when [pbxprojContent] contains at least one
/// CODE_SIGN_IDENTITY[sdk=iphoneos*] = "iPhone Developer" entry.
bool pbxprojHasDeveloperSigningForIphoneos(String pbxprojContent) {
  return pbxprojContent.contains(
    '"CODE_SIGN_IDENTITY[sdk=iphoneos*]" = "iPhone Developer"',
  );
}

/// Returns true when [pbxprojContent] contains a concrete provisioning profile
/// specifier. This is required for manual signing without an Xcode account.
bool pbxprojHasProvisioningProfileSpecifier(String pbxprojContent) {
  final re = RegExp(r'PROVISIONING_PROFILE_SPECIFIER\s*=\s*([^;]+)\s*;');
  for (final m in re.allMatches(pbxprojContent)) {
    var v = m.group(1)!.trim();
    if (v.startsWith('"') && v.endsWith('"')) {
      v = v.substring(1, v.length - 1).trim();
    }
    if (v.isNotEmpty) return true;
  }
  return false;
}

/// Evaluates whether the Runner bundle ID is the final first-publish ID.
({int exitCode, String message}) evaluateBundleIdCheck({
  required Set<String> foundIds,
}) {
  if (foundIds.contains(_legacyBundleId)) {
    return (
      exitCode: 1,
      message:
          'BLOCKED: PRODUCT_BUNDLE_IDENTIFIER still contains legacy codename '
          '$_legacyBundleId. The final first-publish Bundle ID is '
          '$_finalBundleId; update the Runner target before creating or '
          'uploading the App Store Connect record.',
    );
  }
  if (foundIds.isEmpty) {
    return (
      exitCode: 1,
      message:
          'BLOCKED: no Runner PRODUCT_BUNDLE_IDENTIFIER values were found in '
          'the iOS project file.',
    );
  }
  if (!foundIds.contains(_finalBundleId)) {
    return (
      exitCode: 1,
      message:
          'BLOCKED: Runner PRODUCT_BUNDLE_IDENTIFIER is not the final '
          'first-publish Bundle ID $_finalBundleId. Found: '
          '${foundIds.join(", ")}.',
    );
  }
  if (foundIds.length == 1) {
    return (
      exitCode: 0,
      message:
          'OK: Runner PRODUCT_BUNDLE_IDENTIFIER is final first-publish ID '
          '$_finalBundleId.',
    );
  }
  return (
    exitCode: 1,
    message:
        'BLOCKED: multiple Runner PRODUCT_BUNDLE_IDENTIFIER values found. '
        'Expected only $_finalBundleId, found: ${foundIds.join(", ")}.',
  );
}

/// Evaluates whether DEVELOPMENT_TEAM is set.
({int exitCode, String message}) evaluateDevelopmentTeamCheck({
  required bool teamPresent,
}) {
  if (teamPresent) {
    return (
      exitCode: 0,
      message:
          'OK: DEVELOPMENT_TEAM is set in the project (value redacted). '
          'Confirm it is a valid Apple Team ID with an active distribution '
          'certificate before building the IPA.',
    );
  }
  return (
    exitCode: 1,
    message:
        'BLOCKED: DEVELOPMENT_TEAM is absent from $_defaultPbxprojPath.\n'
        'Owner action: open ios/Runner.xcodeproj in Xcode, select the '
        'Runner target -> Signing & Capabilities, choose the correct Team '
        '(requires an Apple Developer account), and commit the updated '
        'project.pbxproj.',
  );
}

/// Evaluates the code-signing identity for iphoneos device builds.
///
/// "iPhone Developer" is the development identity. For an App Store IPA,
/// the Release/Profile configurations must use an App Store-capable
/// distribution identity ("Apple Distribution" in current Xcode, historically
/// "iPhone Distribution") plus a provisioning profile, or automatic signing
/// with a distribution-capable Xcode account.
({int exitCode, String message}) evaluateSigningIdentityCheck({
  required bool hasDeveloperIdentity,
  required bool hasDistributionIdentity,
  required bool hasAutomaticSigning,
  required bool hasProvisioningProfileSpecifier,
}) {
  if (hasDistributionIdentity && hasProvisioningProfileSpecifier) {
    return (
      exitCode: 0,
      message:
          'OK: App Store distribution signing identity and provisioning '
          'profile specifier are present for manual IPA export.',
    );
  }
  if (hasDistributionIdentity && !hasProvisioningProfileSpecifier) {
    return (
      exitCode: 1,
      message:
          'BLOCKED: distribution signing identity is present, but '
          'PROVISIONING_PROFILE_SPECIFIER is absent. Manual App Store export '
          'requires the App Store provisioning profile name, or automatic '
          'signing with an Xcode account that can resolve it.',
    );
  }
  if (hasAutomaticSigning) {
    return (
      exitCode: 0,
      message:
          'OK: CODE_SIGN_STYLE = Automatic is enabled. Xcode can resolve the '
          'distribution signing identity and provisioning profile at '
          'archive/export time when the selected Apple Developer account has '
          'App Store distribution access.',
    );
  }
  if (hasDeveloperIdentity && !hasDistributionIdentity) {
    return (
      exitCode: 1,
      message:
          'BLOCKED: CODE_SIGN_IDENTITY[sdk=iphoneos*] is "iPhone Developer" '
          'in one or more build configurations with no App Store distribution '
          'counterpart. App Store IPA export requires "Apple Distribution" '
          'or "iPhone Distribution" (or automatic signing with a distribution '
          'certificate).\n'
          'Fix: Xcode -> Runner target -> Signing & Capabilities -> set the '
          'distribution certificate, or enable "Automatically manage signing" '
          'with a distribution-capable Apple Developer account.',
    );
  }
  return (
    exitCode: 0,
    message:
        'OK: no explicit "iPhone Developer" CODE_SIGN_IDENTITY[sdk=iphoneos*] '
        'found; signing identity is unset or using automatic signing '
        '(Xcode will resolve at build time).',
  );
}

/// Evaluates whether ios/ExportOptions.plist is present.
///
/// [exportOptionsPlistPath] is the actual path that was checked.
({int exitCode, String message}) evaluateExportOptionsCheck({
  required bool exportOptionsPlistExists,
  required bool allowMissingExportOptions,
  String exportOptionsPlistPath = _defaultExportOptionsPlistPath,
}) {
  if (exportOptionsPlistExists) {
    return (
      exitCode: 0,
      message: 'OK: $exportOptionsPlistPath exists.',
    );
  }
  if (allowMissingExportOptions) {
    return (
      exitCode: 0,
      message:
          'ACKNOWLEDGED: $exportOptionsPlistPath absent (audit mode). '
          'Copy $exportOptionsExamplePath to '
          '$exportOptionsPlistPath and fill in the real team ID, bundle ID, '
          'and provisioning profile name before the final IPA export.',
    );
  }
  return (
    exitCode: 1,
    message:
        'BLOCKED: $exportOptionsPlistPath is absent.\n'
        'flutter build ipa --release requires this file for App Store export.\n'
        'Copy the template and fill in real values:\n'
        '  cp $exportOptionsExamplePath $exportOptionsPlistPath\n'
        'Pass --allow-missing-export-options to skip this check in audit mode.',
  );
}

/// Evaluates whether site/privacy.html and site/support.html are present.
({int exitCode, String message}) evaluateSiteHtmlCheck({
  required bool privacyHtmlExists,
  required bool supportHtmlExists,
}) {
  if (privacyHtmlExists && supportHtmlExists) {
    return (
      exitCode: 0,
      message:
          'OK: site/privacy.html and site/support.html both present locally. '
          'Ensure they are deployed to https://truerise.com.ua once DNS and '
          'hosting are live.',
    );
  }
  final missing = <String>[
    if (!privacyHtmlExists) 'site/privacy.html',
    if (!supportHtmlExists) 'site/support.html',
  ];
  return (
    exitCode: 1,
    message:
        'BLOCKED: missing site file(s): ${missing.join(", ")}. '
        'These must be present locally and uploaded to '
        'https://truerise.com.ua (https://truerise.com.ua/privacy.html and '
        'https://truerise.com.ua/support.html) before App Store submission.',
  );
}

/// Validates an optional bare-HTTPS URL supplied via a CLI flag.
///
/// Returns null when [url] is null (check was not requested).
/// Rejected URL values are never echoed; only "redacted" appears in output.
({int exitCode, String message})? evaluateOptionalHttpsUrl({
  required String? url,
  required String flagName,
}) {
  if (url == null) return null;
  final uri = Uri.tryParse(url);
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
          'BLOCKED: value of --$flagName (redacted) is not a valid bare '
          'HTTPS URL. It must use https://, name a host, and carry no '
          'userinfo, query, or fragment. Example: '
          'https://truerise.com.ua/privacy.html',
    );
  }
  return (
    exitCode: 0,
    message: 'OK: --$flagName accepted (bare HTTPS, value redacted).',
  );
}

// ---------------------------------------------------------------------------
// I/O + arg-parsing layer
// ---------------------------------------------------------------------------

/// Parses [args], reads the relevant project files, runs all checks, and
/// returns an aggregated result. All checks run even if earlier checks
/// block, so the owner sees the full picture.
///
/// A missing pbxproj is a terminal blocker; all pbxproj-dependent checks
/// are skipped.
({int exitCode, String message}) runPreflight(List<String> args) {
  var pbxprojPath = _defaultPbxprojPath;
  var exportOptionsPlistPath = _defaultExportOptionsPlistPath;
  var privacyHtmlPath = _defaultPrivacyHtmlPath;
  var supportHtmlPath = _defaultSupportHtmlPath;
  var allowMissingExportOptions = false;
  String? privacyPolicyUrl;
  String? shareUrl;

  for (final arg in args) {
    if (arg.startsWith('--pbxproj=')) {
      pbxprojPath = arg.substring('--pbxproj='.length);
    } else if (arg.startsWith('--export-options-plist=')) {
      exportOptionsPlistPath = arg.substring('--export-options-plist='.length);
    } else if (arg.startsWith('--privacy-html=')) {
      privacyHtmlPath = arg.substring('--privacy-html='.length);
    } else if (arg.startsWith('--support-html=')) {
      supportHtmlPath = arg.substring('--support-html='.length);
    } else if (arg == '--allow-current-bundle-id') {
      // Deprecated compatibility flag; intentionally ignored.
    } else if (arg.startsWith('--bundle-id-purpose=')) {
      // Deprecated compatibility flag; intentionally ignored.
    } else if (arg == '--allow-missing-export-options') {
      allowMissingExportOptions = true;
    } else if (arg.startsWith('--privacy-policy-url=')) {
      privacyPolicyUrl = arg.substring('--privacy-policy-url='.length);
    } else if (arg.startsWith('--share-url=')) {
      shareUrl = arg.substring('--share-url='.length);
    } else {
      return (
        exitCode: 2,
        message:
            'Unknown argument "$arg". Usage:\n'
            '  dart run tool/ios_release_preflight.dart\n'
            '    [--pbxproj=<path>]\n'
            '    [--export-options-plist=<path>]\n'
            '    [--privacy-html=<path>]\n'
            '    [--support-html=<path>]\n'
            '    [--allow-current-bundle-id '
            '--bundle-id-purpose=$_deprecatedBundleIdPurpose] '
            '(deprecated, ignored)\n'
            '    [--allow-missing-export-options]\n'
            '    [--privacy-policy-url=<https-url>]\n'
            '    [--share-url=<https-url>]\n'
            'Exit codes: 0 = pass, 1 = blocked, 2 = usage error.',
      );
    }
  }

  final results = <({int exitCode, String message})>[];

  // --- Check: pbxproj exists -------------------------------------------------
  final pbxprojFile = File(pbxprojPath);
  if (!pbxprojFile.existsSync()) {
    return (
      exitCode: 1,
      message:
          'BLOCKED: iOS project file not found at "$pbxprojPath". '
          'Run from the repository root, or pass --pbxproj=<path>.',
    );
  }
  results.add((
    exitCode: 0,
    message: 'OK: iOS project file found at $pbxprojPath.',
  ));

  final pbxprojContent = pbxprojFile.readAsStringSync();

  // --- Check: bundle ID ------------------------------------------------------
  results
    ..add(
      evaluateBundleIdCheck(
        foundIds: extractRunnerBundleIds(pbxprojContent),
      ),
    )
    // --- Check: DEVELOPMENT_TEAM ---------------------------------------------
    ..add(
      evaluateDevelopmentTeamCheck(
        teamPresent: pbxprojHasDevelopmentTeam(pbxprojContent),
      ),
    )
    // --- Check: code-signing identity ----------------------------------------
    ..add(
      evaluateSigningIdentityCheck(
        hasAutomaticSigning: pbxprojHasAutomaticSigning(pbxprojContent),
        hasDeveloperIdentity: pbxprojHasDeveloperSigningForIphoneos(
          pbxprojContent,
        ),
        hasDistributionIdentity: pbxprojHasDistributionSigningIdentity(
          pbxprojContent,
        ),
        hasProvisioningProfileSpecifier: pbxprojHasProvisioningProfileSpecifier(
          pbxprojContent,
        ),
      ),
    )
    // --- Check: ExportOptions.plist ------------------------------------------
    ..add(
      evaluateExportOptionsCheck(
        exportOptionsPlistExists: File(exportOptionsPlistPath).existsSync(),
        allowMissingExportOptions: allowMissingExportOptions,
        exportOptionsPlistPath: exportOptionsPlistPath,
      ),
    )
    // --- Check: site HTML files ----------------------------------------------
    ..add(
      evaluateSiteHtmlCheck(
        privacyHtmlExists: File(privacyHtmlPath).existsSync(),
        supportHtmlExists: File(supportHtmlPath).existsSync(),
      ),
    );

  // --- Optional: URL validation ----------------------------------------------
  final privacyUrlResult = evaluateOptionalHttpsUrl(
    url: privacyPolicyUrl,
    flagName: 'privacy-policy-url',
  );
  if (privacyUrlResult != null) results.add(privacyUrlResult);

  final shareUrlResult = evaluateOptionalHttpsUrl(
    url: shareUrl,
    flagName: 'share-url',
  );
  if (shareUrlResult != null) results.add(shareUrlResult);

  // --- Aggregate -------------------------------------------------------------
  final anyBlocked = results.any((r) => r.exitCode != 0);
  final message = results.map((r) => r.message).join('\n');
  return (exitCode: anyBlocked ? 1 : 0, message: message);
}

void main(List<String> args) {
  final result = runPreflight(args);
  (result.exitCode == 0 ? stdout : stderr).writeln(result.message);
  exitCode = result.exitCode;
}
