import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/ios_release_preflight.dart';

// ---------------------------------------------------------------------------
// Minimal pbxproj snippets used across tests
// ---------------------------------------------------------------------------

/// A pbxproj snippet that looks like a well-configured Runner target:
/// - bundle ID = ua.com.truerise.app (the final first-publish ID)
/// - DEVELOPMENT_TEAM set
/// - CODE_SIGN_IDENTITY[sdk=iphoneos*] = "Apple Distribution"
/// - PROVISIONING_PROFILE_SPECIFIER set for manual signing
const String _passingPbxproj = '''
\t\t\t\tDEVELOPMENT_TEAM = ABCDE12345;
\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = ua.com.truerise.app;
\t\t\t\t"CODE_SIGN_IDENTITY[sdk=iphoneos*]" = "Apple Distribution";
\t\t\t\tPROVISIONING_PROFILE_SPECIFIER = "TrueRise App Store 2026";
''';

/// A pbxproj snippet with the current codename bundle ID and no team/distribution.
const String _currentBundleIdOnlyPbxproj = '''
\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.rectify.rectify;
\t\t\t\t"CODE_SIGN_IDENTITY[sdk=iphoneos*]" = "iPhone Developer";
''';

/// A pbxproj snippet with DEVELOPMENT_TEAM and distribution signing,
/// but still using the legacy bundle ID.
const String _currentBundleIdWithTeamPbxproj = '''
\t\t\t\tDEVELOPMENT_TEAM = ABCDE12345;
\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.rectify.rectify;
\t\t\t\t"CODE_SIGN_IDENTITY[sdk=iphoneos*]" = "Apple Distribution";
\t\t\t\tPROVISIONING_PROFILE_SPECIFIER = "TrueRise App Store 2026";
''';

/// A pbxproj snippet with DEVELOPMENT_TEAM set but still "iPhone Developer".
const String _developerSigningPbxproj = '''
\t\t\t\tDEVELOPMENT_TEAM = ABCDE12345;
\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = ua.com.truerise.app;
\t\t\t\t"CODE_SIGN_IDENTITY[sdk=iphoneos*]" = "iPhone Developer";
''';

/// A pbxproj snippet with automatic signing enabled. Xcode resolves the
/// distribution signing identity at archive/export time.
const String _automaticSigningPbxproj = '''
\t\t\t\tCODE_SIGN_STYLE = Automatic;
\t\t\t\tDEVELOPMENT_TEAM = ABCDE12345;
\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = ua.com.truerise.app;
\t\t\t\t"CODE_SIGN_IDENTITY[sdk=iphoneos*]" = "iPhone Developer";
''';

/// A pbxproj snippet with no DEVELOPMENT_TEAM.
const String _noTeamPbxproj = '''
\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = ua.com.truerise.app;
\t\t\t\t"CODE_SIGN_IDENTITY[sdk=iphoneos*]" = "Apple Distribution";
\t\t\t\tPROVISIONING_PROFILE_SPECIFIER = "TrueRise App Store 2026";
''';

/// A pbxproj snippet with RunnerTests entries (should be excluded from
/// the Runner bundle ID set).
const String _withTestTargetPbxproj = '''
\t\t\t\tDEVELOPMENT_TEAM = ABCDE12345;
\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = ua.com.truerise.app;
\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = ua.com.truerise.app.RunnerTests;
\t\t\t\t"CODE_SIGN_IDENTITY[sdk=iphoneos*]" = "Apple Distribution";
\t\t\t\tPROVISIONING_PROFILE_SPECIFIER = "TrueRise App Store 2026";
''';

/// A pbxproj snippet with a different non-legacy ID.
const String _wrongBundleIdPbxproj = '''
\t\t\t\tDEVELOPMENT_TEAM = ABCDE12345;
\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.example.other;
\t\t\t\t"CODE_SIGN_IDENTITY[sdk=iphoneos*]" = "Apple Distribution";
\t\t\t\tPROVISIONING_PROFILE_SPECIFIER = "TrueRise App Store 2026";
''';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Future<File> _writeTempPbxproj(Directory dir, String content) async {
  final f = File('${dir.path}/project.pbxproj');
  await f.writeAsString(content);
  return f;
}

Future<File> _writeTempFile(Directory dir, String name) async {
  final f = File('${dir.path}/$name');
  await f.writeAsString('<html></html>');
  return f;
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('ios_preflight_test_');
  });

  tearDown(() async {
    await tempDir.delete(recursive: true);
  });

  // -------------------------------------------------------------------------
  // extractRunnerBundleIds
  // -------------------------------------------------------------------------
  group('extractRunnerBundleIds', () {
    test('returns Runner bundle ID', () {
      final ids = extractRunnerBundleIds(
        'PRODUCT_BUNDLE_IDENTIFIER = com.example.app;',
      );
      expect(ids, contains('com.example.app'));
    });

    test('excludes RunnerTests bundle ID', () {
      final ids = extractRunnerBundleIds(_withTestTargetPbxproj);
      expect(ids, contains('ua.com.truerise.app'));
      expect(ids, isNot(contains('ua.com.truerise.app.RunnerTests')));
    });

    test('returns the current codename when present', () {
      final ids = extractRunnerBundleIds(_currentBundleIdOnlyPbxproj);
      expect(ids, contains('com.rectify.rectify'));
    });

    test('returns empty set for empty content', () {
      expect(extractRunnerBundleIds(''), isEmpty);
    });
  });

  // -------------------------------------------------------------------------
  // pbxprojHasDevelopmentTeam
  // -------------------------------------------------------------------------
  group('pbxprojHasDevelopmentTeam', () {
    test('true when DEVELOPMENT_TEAM is set', () {
      expect(
        pbxprojHasDevelopmentTeam('DEVELOPMENT_TEAM = ABCDE12345;'),
        isTrue,
      );
    });

    test('false when DEVELOPMENT_TEAM is absent', () {
      expect(
        pbxprojHasDevelopmentTeam('PRODUCT_BUNDLE_IDENTIFIER = x;'),
        isFalse,
      );
    });

    test('false when DEVELOPMENT_TEAM is empty string', () {
      expect(pbxprojHasDevelopmentTeam('DEVELOPMENT_TEAM = "";'), isFalse);
    });

    test('false when DEVELOPMENT_TEAM is empty bare value', () {
      expect(pbxprojHasDevelopmentTeam('DEVELOPMENT_TEAM = ;'), isFalse);
    });
  });

  // -------------------------------------------------------------------------
  // pbxprojHasDeveloperSigningForIphoneos / pbxprojHasDistributionSigningIdentity
  // -------------------------------------------------------------------------
  group('signing identity detection', () {
    test('detects automatic signing', () {
      expect(pbxprojHasAutomaticSigning(_automaticSigningPbxproj), isTrue);
    });

    test('does not detect automatic signing when absent', () {
      expect(pbxprojHasAutomaticSigning(_developerSigningPbxproj), isFalse);
    });

    test('detects iPhone Developer for iphoneos', () {
      expect(
        pbxprojHasDeveloperSigningForIphoneos(_currentBundleIdOnlyPbxproj),
        isTrue,
      );
    });

    test('does not detect Developer when only Distribution present', () {
      expect(
        pbxprojHasDeveloperSigningForIphoneos(_passingPbxproj),
        isFalse,
      );
    });

    test('detects iPhone Distribution for iphoneos', () {
      expect(
        pbxprojHasDistributionSigningIdentity(_passingPbxproj),
        isTrue,
      );
    });

    test('detects provisioning profile specifier', () {
      expect(
        pbxprojHasProvisioningProfileSpecifier(_passingPbxproj),
        isTrue,
      );
    });

    test('does not detect provisioning profile specifier when absent', () {
      expect(
        pbxprojHasProvisioningProfileSpecifier(_developerSigningPbxproj),
        isFalse,
      );
    });

    test('does not detect Distribution when only Developer present', () {
      expect(
        pbxprojHasDistributionSigningIdentity(_currentBundleIdOnlyPbxproj),
        isFalse,
      );
    });
  });

  // -------------------------------------------------------------------------
  // evaluateBundleIdCheck
  // -------------------------------------------------------------------------
  group('evaluateBundleIdCheck', () {
    test('blocks when legacy bundle ID is present', () {
      final r = evaluateBundleIdCheck(
        foundIds: {'com.rectify.rectify'},
      );
      expect(r.exitCode, equals(1));
      expect(r.message, contains('BLOCKED'));
      expect(r.message, contains('com.rectify.rectify'));
      expect(r.message, contains('ua.com.truerise.app'));
    });

    test('blocks when final bundle ID is missing', () {
      final r = evaluateBundleIdCheck(
        foundIds: {'com.example.other'},
      );
      expect(r.exitCode, equals(1));
      expect(r.message, contains('BLOCKED'));
      expect(r.message, contains('ua.com.truerise.app'));
    });

    test('blocks when final and other Runner IDs are both present', () {
      final r = evaluateBundleIdCheck(
        foundIds: {'ua.com.truerise.app', 'com.example.other'},
      );
      expect(r.exitCode, equals(1));
      expect(r.message, contains('multiple'));
    });

    test('passes when final bundle ID is the only Runner ID', () {
      final r = evaluateBundleIdCheck(
        foundIds: {'ua.com.truerise.app'},
      );
      expect(r.exitCode, equals(0));
      expect(r.message, contains('OK'));
    });

    test('blocks for empty set', () {
      final r = evaluateBundleIdCheck(
        foundIds: {},
      );
      expect(r.exitCode, equals(1));
      expect(r.message, contains('no Runner'));
    });
  });

  // -------------------------------------------------------------------------
  // evaluateDevelopmentTeamCheck
  // -------------------------------------------------------------------------
  group('evaluateDevelopmentTeamCheck', () {
    test('blocks when team is absent', () {
      final r = evaluateDevelopmentTeamCheck(teamPresent: false);
      expect(r.exitCode, equals(1));
      expect(r.message, contains('BLOCKED'));
      expect(r.message, contains('DEVELOPMENT_TEAM'));
    });

    test('passes when team is present', () {
      final r = evaluateDevelopmentTeamCheck(teamPresent: true);
      expect(r.exitCode, equals(0));
      expect(r.message, contains('OK'));
    });
  });

  // -------------------------------------------------------------------------
  // evaluateSigningIdentityCheck
  // -------------------------------------------------------------------------
  group('evaluateSigningIdentityCheck', () {
    test('blocks when Developer only (no Distribution)', () {
      final r = evaluateSigningIdentityCheck(
        hasAutomaticSigning: false,
        hasDeveloperIdentity: true,
        hasDistributionIdentity: false,
        hasProvisioningProfileSpecifier: false,
      );
      expect(r.exitCode, equals(1));
      expect(r.message, contains('BLOCKED'));
      expect(r.message, contains('iPhone Developer'));
    });

    test(
      'passes when Distribution is present (even if Developer also present)',
      () {
        final r = evaluateSigningIdentityCheck(
          hasAutomaticSigning: false,
          hasDeveloperIdentity: true,
          hasDistributionIdentity: true,
          hasProvisioningProfileSpecifier: true,
        );
        expect(r.exitCode, equals(0));
      },
    );

    test('passes when Distribution is present and Developer absent', () {
      final r = evaluateSigningIdentityCheck(
        hasAutomaticSigning: false,
        hasDeveloperIdentity: false,
        hasDistributionIdentity: true,
        hasProvisioningProfileSpecifier: true,
      );
      expect(r.exitCode, equals(0));
      expect(r.message, contains('distribution signing identity'));
    });

    test('blocks when Distribution is present without profile specifier', () {
      final r = evaluateSigningIdentityCheck(
        hasAutomaticSigning: false,
        hasDeveloperIdentity: false,
        hasDistributionIdentity: true,
        hasProvisioningProfileSpecifier: false,
      );
      expect(r.exitCode, equals(1));
      expect(r.message, contains('PROVISIONING_PROFILE_SPECIFIER'));
    });

    test('passes when neither identity is set (automatic signing)', () {
      final r = evaluateSigningIdentityCheck(
        hasAutomaticSigning: false,
        hasDeveloperIdentity: false,
        hasDistributionIdentity: false,
        hasProvisioningProfileSpecifier: false,
      );
      expect(r.exitCode, equals(0));
      expect(r.message, contains('automatic'));
    });

    test(
      'passes when automatic signing is enabled with Developer identity',
      () {
        final r = evaluateSigningIdentityCheck(
          hasAutomaticSigning: true,
          hasDeveloperIdentity: true,
          hasDistributionIdentity: false,
          hasProvisioningProfileSpecifier: false,
        );
        expect(r.exitCode, equals(0));
        expect(r.message, contains('Automatic'));
      },
    );
  });

  // -------------------------------------------------------------------------
  // evaluateExportOptionsCheck
  // -------------------------------------------------------------------------
  group('evaluateExportOptionsCheck', () {
    test('blocks when plist absent and no allow flag', () {
      final r = evaluateExportOptionsCheck(
        exportOptionsPlistExists: false,
        allowMissingExportOptions: false,
      );
      expect(r.exitCode, equals(1));
      expect(r.message, contains('BLOCKED'));
    });

    test('passes (audit mode) when plist absent but allow flag set', () {
      final r = evaluateExportOptionsCheck(
        exportOptionsPlistExists: false,
        allowMissingExportOptions: true,
      );
      expect(r.exitCode, equals(0));
      expect(r.message, contains('ACKNOWLEDGED'));
      expect(r.message, contains(exportOptionsExamplePath));
    });

    test('passes when plist exists', () {
      final r = evaluateExportOptionsCheck(
        exportOptionsPlistExists: true,
        allowMissingExportOptions: false,
      );
      expect(r.exitCode, equals(0));
      expect(r.message, contains('OK'));
    });
  });

  // -------------------------------------------------------------------------
  // evaluateSiteHtmlCheck
  // -------------------------------------------------------------------------
  group('evaluateSiteHtmlCheck', () {
    test('passes when both files present', () {
      final r = evaluateSiteHtmlCheck(
        privacyHtmlExists: true,
        supportHtmlExists: true,
      );
      expect(r.exitCode, equals(0));
      expect(r.message, contains('OK'));
    });

    test('blocks when privacy.html missing', () {
      final r = evaluateSiteHtmlCheck(
        privacyHtmlExists: false,
        supportHtmlExists: true,
      );
      expect(r.exitCode, equals(1));
      expect(r.message, contains('privacy.html'));
    });

    test('blocks when support.html missing', () {
      final r = evaluateSiteHtmlCheck(
        privacyHtmlExists: true,
        supportHtmlExists: false,
      );
      expect(r.exitCode, equals(1));
      expect(r.message, contains('support.html'));
    });

    test('blocks when both missing', () {
      final r = evaluateSiteHtmlCheck(
        privacyHtmlExists: false,
        supportHtmlExists: false,
      );
      expect(r.exitCode, equals(1));
      expect(r.message, contains('privacy.html'));
      expect(r.message, contains('support.html'));
    });
  });

  // -------------------------------------------------------------------------
  // evaluateOptionalHttpsUrl
  // -------------------------------------------------------------------------
  group('evaluateOptionalHttpsUrl', () {
    test('returns null when url is null (check skipped)', () {
      expect(evaluateOptionalHttpsUrl(url: null, flagName: 'x'), isNull);
    });

    test('passes for bare HTTPS URL with path', () {
      final r = evaluateOptionalHttpsUrl(
        url: 'https://truerise.com.ua/privacy.html',
        flagName: 'privacy-policy-url',
      );
      expect(r!.exitCode, equals(0));
    });

    test('passes for bare HTTPS URL without path', () {
      final r = evaluateOptionalHttpsUrl(
        url: 'https://truerise.com.ua',
        flagName: 'share-url',
      );
      expect(r!.exitCode, equals(0));
    });

    test('blocks for http URL', () {
      final r = evaluateOptionalHttpsUrl(
        url: 'http://truerise.com.ua/privacy.html',
        flagName: 'privacy-policy-url',
      );
      expect(r!.exitCode, equals(1));
      expect(r.message, contains('redacted'));
      expect(r.message, isNot(contains('http://truerise.com.ua')));
    });

    test('blocks for URL with fragment', () {
      final r = evaluateOptionalHttpsUrl(
        url: 'https://truerise.com.ua/privacy.html#section',
        flagName: 'privacy-policy-url',
      );
      expect(r!.exitCode, equals(1));
      expect(r.message, contains('redacted'));
    });

    test('blocks for URL with query parameters', () {
      final r = evaluateOptionalHttpsUrl(
        url: 'https://truerise.com.ua/privacy.html?utm_source=test',
        flagName: 'privacy-policy-url',
      );
      expect(r!.exitCode, equals(1));
      expect(r.message, contains('redacted'));
      expect(r.message, isNot(contains('utm_source')));
    });

    test('blocks for URL with userinfo', () {
      final r = evaluateOptionalHttpsUrl(
        url: 'https://user@truerise.com.ua/privacy.html',
        flagName: 'privacy-policy-url',
      );
      expect(r!.exitCode, equals(1));
      expect(r.message, contains('redacted'));
    });

    test('blocks for non-URL string', () {
      final r = evaluateOptionalHttpsUrl(
        url: 'not-a-url',
        flagName: 'privacy-policy-url',
      );
      expect(r!.exitCode, equals(1));
    });
  });

  // -------------------------------------------------------------------------
  // runPreflight integration (uses temp files)
  // -------------------------------------------------------------------------
  group('runPreflight integration', () {
    test('usage error for unknown flag', () {
      final r = runPreflight(['--unknown-flag=x']);
      expect(r.exitCode, equals(2));
      expect(r.message, contains('Unknown argument'));
    });

    test('blocks when pbxproj is missing', () {
      final r = runPreflight(['--pbxproj=${tempDir.path}/missing.pbxproj']);
      expect(r.exitCode, equals(1));
      expect(r.message, contains('BLOCKED'));
      expect(r.message, contains('not found'));
    });

    test('all checks pass for a well-configured project', () async {
      final pbxprojFile = await _writeTempPbxproj(tempDir, _passingPbxproj);
      final exportFile = await _writeTempFile(tempDir, 'ExportOptions.plist');
      final privacyFile = await _writeTempFile(tempDir, 'privacy.html');
      final supportFile = await _writeTempFile(tempDir, 'support.html');

      final r = runPreflight([
        '--pbxproj=${pbxprojFile.path}',
        '--export-options-plist=${exportFile.path}',
        '--privacy-html=${privacyFile.path}',
        '--support-html=${supportFile.path}',
      ]);
      expect(r.exitCode, equals(0), reason: r.message);
    });

    test('blocks on legacy bundle ID by default', () async {
      final pbxprojFile = await _writeTempPbxproj(
        tempDir,
        _currentBundleIdWithTeamPbxproj,
      );
      final exportFile = await _writeTempFile(tempDir, 'ExportOptions.plist');
      final privacyFile = await _writeTempFile(tempDir, 'privacy.html');
      final supportFile = await _writeTempFile(tempDir, 'support.html');

      final r = runPreflight([
        '--pbxproj=${pbxprojFile.path}',
        '--export-options-plist=${exportFile.path}',
        '--privacy-html=${privacyFile.path}',
        '--support-html=${supportFile.path}',
      ]);
      expect(r.exitCode, equals(1));
      expect(r.message, contains('com.rectify.rectify'));
    });

    test('deprecated allow flags do not permit legacy bundle ID', () async {
      final pbxprojFile = await _writeTempPbxproj(
        tempDir,
        _currentBundleIdWithTeamPbxproj,
      );
      final exportFile = await _writeTempFile(tempDir, 'ExportOptions.plist');
      final privacyFile = await _writeTempFile(tempDir, 'privacy.html');
      final supportFile = await _writeTempFile(tempDir, 'support.html');

      final r = runPreflight([
        '--pbxproj=${pbxprojFile.path}',
        '--export-options-plist=${exportFile.path}',
        '--privacy-html=${privacyFile.path}',
        '--support-html=${supportFile.path}',
        '--allow-current-bundle-id',
        '--bundle-id-purpose=owner-confirmed-current',
      ]);
      expect(r.exitCode, equals(1));
      expect(r.message, contains('com.rectify.rectify'));
      expect(r.message, contains('ua.com.truerise.app'));
    });

    test('blocks on non-final bundle ID', () async {
      final pbxprojFile = await _writeTempPbxproj(
        tempDir,
        _wrongBundleIdPbxproj,
      );
      final exportFile = await _writeTempFile(tempDir, 'ExportOptions.plist');
      final privacyFile = await _writeTempFile(tempDir, 'privacy.html');
      final supportFile = await _writeTempFile(tempDir, 'support.html');

      final r = runPreflight([
        '--pbxproj=${pbxprojFile.path}',
        '--export-options-plist=${exportFile.path}',
        '--privacy-html=${privacyFile.path}',
        '--support-html=${supportFile.path}',
      ]);
      expect(r.exitCode, equals(1));
      expect(r.message, contains('ua.com.truerise.app'));
    });

    test('blocks when DEVELOPMENT_TEAM absent', () async {
      final pbxprojFile = await _writeTempPbxproj(tempDir, _noTeamPbxproj);
      final exportFile = await _writeTempFile(tempDir, 'ExportOptions.plist');
      final privacyFile = await _writeTempFile(tempDir, 'privacy.html');
      final supportFile = await _writeTempFile(tempDir, 'support.html');

      final r = runPreflight([
        '--pbxproj=${pbxprojFile.path}',
        '--export-options-plist=${exportFile.path}',
        '--privacy-html=${privacyFile.path}',
        '--support-html=${supportFile.path}',
      ]);
      expect(r.exitCode, equals(1));
      expect(r.message, contains('DEVELOPMENT_TEAM'));
    });

    test(
      'blocks when Developer signing identity without Distribution',
      () async {
        final pbxprojFile = await _writeTempPbxproj(
          tempDir,
          _developerSigningPbxproj,
        );
        final exportFile = await _writeTempFile(tempDir, 'ExportOptions.plist');
        final privacyFile = await _writeTempFile(tempDir, 'privacy.html');
        final supportFile = await _writeTempFile(tempDir, 'support.html');

        final r = runPreflight([
          '--pbxproj=${pbxprojFile.path}',
          '--export-options-plist=${exportFile.path}',
          '--privacy-html=${privacyFile.path}',
          '--support-html=${supportFile.path}',
        ]);
        expect(r.exitCode, equals(1));
        expect(r.message, contains('iPhone Developer'));
      },
    );

    test('blocks when ExportOptions.plist absent (final mode)', () async {
      final pbxprojFile = await _writeTempPbxproj(tempDir, _passingPbxproj);
      final privacyFile = await _writeTempFile(tempDir, 'privacy.html');
      final supportFile = await _writeTempFile(tempDir, 'support.html');
      final missingExport = '${tempDir.path}/ExportOptions.plist';

      final r = runPreflight([
        '--pbxproj=${pbxprojFile.path}',
        '--export-options-plist=$missingExport',
        '--privacy-html=${privacyFile.path}',
        '--support-html=${supportFile.path}',
      ]);
      expect(r.exitCode, equals(1));
      expect(r.message, contains('BLOCKED'));
    });

    test('passes when ExportOptions absent but audit flag set', () async {
      final pbxprojFile = await _writeTempPbxproj(tempDir, _passingPbxproj);
      final privacyFile = await _writeTempFile(tempDir, 'privacy.html');
      final supportFile = await _writeTempFile(tempDir, 'support.html');
      final missingExport = '${tempDir.path}/ExportOptions.plist';

      final r = runPreflight([
        '--pbxproj=${pbxprojFile.path}',
        '--export-options-plist=$missingExport',
        '--privacy-html=${privacyFile.path}',
        '--support-html=${supportFile.path}',
        '--allow-missing-export-options',
      ]);
      expect(r.exitCode, equals(0), reason: r.message);
      expect(r.message, contains('ACKNOWLEDGED'));
    });

    test('blocks when privacy.html absent', () async {
      final pbxprojFile = await _writeTempPbxproj(tempDir, _passingPbxproj);
      final exportFile = await _writeTempFile(tempDir, 'ExportOptions.plist');
      final supportFile = await _writeTempFile(tempDir, 'support.html');
      final missingPrivacy = '${tempDir.path}/privacy.html';

      final r = runPreflight([
        '--pbxproj=${pbxprojFile.path}',
        '--export-options-plist=${exportFile.path}',
        '--privacy-html=$missingPrivacy',
        '--support-html=${supportFile.path}',
      ]);
      expect(r.exitCode, equals(1));
      expect(r.message, contains('privacy.html'));
    });

    test('blocks when support.html absent', () async {
      final pbxprojFile = await _writeTempPbxproj(tempDir, _passingPbxproj);
      final exportFile = await _writeTempFile(tempDir, 'ExportOptions.plist');
      final privacyFile = await _writeTempFile(tempDir, 'privacy.html');
      final missingSupport = '${tempDir.path}/support.html';

      final r = runPreflight([
        '--pbxproj=${pbxprojFile.path}',
        '--export-options-plist=${exportFile.path}',
        '--privacy-html=${privacyFile.path}',
        '--support-html=$missingSupport',
      ]);
      expect(r.exitCode, equals(1));
      expect(r.message, contains('support.html'));
    });

    test('optional privacy-policy-url is validated as bare HTTPS', () async {
      final pbxprojFile = await _writeTempPbxproj(tempDir, _passingPbxproj);
      final exportFile = await _writeTempFile(tempDir, 'ExportOptions.plist');
      final privacyFile = await _writeTempFile(tempDir, 'privacy.html');
      final supportFile = await _writeTempFile(tempDir, 'support.html');

      final rGood = runPreflight([
        '--pbxproj=${pbxprojFile.path}',
        '--export-options-plist=${exportFile.path}',
        '--privacy-html=${privacyFile.path}',
        '--support-html=${supportFile.path}',
        '--privacy-policy-url=https://truerise.com.ua/privacy.html',
      ]);
      expect(rGood.exitCode, equals(0), reason: rGood.message);

      final rBad = runPreflight([
        '--pbxproj=${pbxprojFile.path}',
        '--export-options-plist=${exportFile.path}',
        '--privacy-html=${privacyFile.path}',
        '--support-html=${supportFile.path}',
        '--privacy-policy-url=http://insecure.example.com',
      ]);
      expect(rBad.exitCode, equals(1));
      expect(rBad.message, contains('redacted'));
    });

    test('output does not echo a rejected URL value', () async {
      final pbxprojFile = await _writeTempPbxproj(tempDir, _passingPbxproj);
      final exportFile = await _writeTempFile(tempDir, 'ExportOptions.plist');
      final privacyFile = await _writeTempFile(tempDir, 'privacy.html');
      final supportFile = await _writeTempFile(tempDir, 'support.html');

      const badUrl = 'http://should-not-appear.example.com/path?q=1';
      final r = runPreflight([
        '--pbxproj=${pbxprojFile.path}',
        '--export-options-plist=${exportFile.path}',
        '--privacy-html=${privacyFile.path}',
        '--support-html=${supportFile.path}',
        '--share-url=$badUrl',
      ]);
      expect(r.exitCode, equals(1));
      expect(r.message, isNot(contains(badUrl)));
      expect(r.message, isNot(contains('should-not-appear')));
    });

    test('all checks run even when earlier ones block', () async {
      // Use a pbxproj that triggers multiple blockers:
      // - legacy bundle ID
      // - no DEVELOPMENT_TEAM
      // - iPhone Developer only signing
      // - no ExportOptions.plist
      final pbxprojFile = await _writeTempPbxproj(
        tempDir,
        _currentBundleIdOnlyPbxproj,
      );
      final privacyFile = await _writeTempFile(tempDir, 'privacy.html');
      final supportFile = await _writeTempFile(tempDir, 'support.html');
      final missingExport = '${tempDir.path}/ExportOptions.plist';

      final r = runPreflight([
        '--pbxproj=${pbxprojFile.path}',
        '--export-options-plist=$missingExport',
        '--privacy-html=${privacyFile.path}',
        '--support-html=${supportFile.path}',
      ]);
      expect(r.exitCode, equals(1));
      // All four blockers should appear in the combined output
      expect(r.message, contains('com.rectify.rectify'));
      expect(r.message, contains('DEVELOPMENT_TEAM'));
      expect(r.message, contains('iPhone Developer'));
      expect(r.message, contains('ExportOptions.plist'));
    });
  });
}
