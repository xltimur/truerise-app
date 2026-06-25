import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

const String finalAppId = 'ua.com.truerise.app';
const String legacyAppId = 'com.rectify.rectify';
const String appleTeamId = 'T29RJZB64F';

String _read(String path) => File(path).readAsStringSync();

void main() {
  test('Android package identity is final TrueRise ID', () {
    final gradle = _read('android/app/build.gradle.kts');
    expect(gradle, contains('namespace = "$finalAppId"'));
    expect(gradle, contains('applicationId = "$finalAppId"'));
    expect(gradle, isNot(contains('namespace = "$legacyAppId"')));
    expect(gradle, isNot(contains('applicationId = "$legacyAppId"')));

    final activity = File(
      'android/app/src/main/kotlin/ua/com/truerise/app/MainActivity.kt',
    );
    expect(activity.existsSync(), isTrue);
    expect(
      activity.readAsStringSync(),
      contains('package ua.com.truerise.app'),
    );

    expect(
      File(
        'android/app/src/main/kotlin/com/rectify/rectify/MainActivity.kt',
      ).existsSync(),
      isFalse,
    );
  });

  test('iOS bundle identity is final TrueRise ID', () {
    final pbxproj = _read('ios/Runner.xcodeproj/project.pbxproj');
    expect(
      RegExp(
        r'PRODUCT_BUNDLE_IDENTIFIER\s*=\s*ua\.com\.truerise\.app\s*;',
      ).allMatches(pbxproj),
      hasLength(3),
    );
    expect(
      RegExp(
        r'PRODUCT_BUNDLE_IDENTIFIER\s*=\s*ua\.com\.truerise\.app\.RunnerTests\s*;',
      ).allMatches(pbxproj),
      hasLength(3),
    );
    expect(pbxproj, contains('DEVELOPMENT_TEAM = $appleTeamId;'));
    expect(pbxproj, contains('CODE_SIGN_STYLE = Automatic;'));
    expect(pbxproj, isNot(contains(legacyAppId)));
  });
}
