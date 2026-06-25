import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rectify/core/update/app_version.dart';
import 'package:rectify/core/update/update_info.dart';

/// Pins the tolerant-parse contract for the hosted version JSON and the
/// per-platform store URL / message resolution. The JSON is public,
/// owner-hosted content — unknown fields are ignored, missing fields are
/// `null`, and store URLs are only honoured when privacy-safe.
void main() {
  group('UpdateInfo.tryParse', () {
    test('parses the full documented contract', () {
      final info = UpdateInfo.tryParse(<String, Object?>{
        'latestVersion': '1.2.0+7',
        'minimumVersion': '1.1.0',
        'storeUrl': 'https://truerise.com.ua/get',
        'appStoreUrl': 'https://apps.apple.com/app/id123456789',
        'playStoreUrl':
            'https://play.google.com/store/apps/details?id=app.truerise',
        'message': 'Bug fixes and improvements.',
      });

      expect(info, isNotNull);
      expect(info!.latestVersion, AppVersion.tryParse('1.2.0+7'));
      expect(info.minimumVersion, AppVersion.tryParse('1.1.0'));
      expect(info.message, 'Bug fixes and improvements.');
    });

    test('tolerates missing optional fields and unknown extras', () {
      final info = UpdateInfo.tryParse(<String, Object?>{
        'latestVersion': '1.2.0',
        'someFutureField': true,
      });
      expect(info, isNotNull);
      expect(info!.minimumVersion, isNull);
      expect(info.message, isNull);
      expect(info.storeUrlFor(TargetPlatform.iOS), isNull);
    });

    test('returns null for non-map payloads', () {
      expect(UpdateInfo.tryParse(null), isNull);
      expect(UpdateInfo.tryParse('1.2.0'), isNull);
      expect(UpdateInfo.tryParse(<Object>[1, 2]), isNull);
    });

    test('returns null when neither latestVersion nor minimumVersion '
        'parses — the payload cannot drive any decision', () {
      expect(UpdateInfo.tryParse(<String, Object?>{}), isNull);
      expect(
        UpdateInfo.tryParse(<String, Object?>{'latestVersion': 'garbage'}),
        isNull,
      );
    });

    test('ignores non-string values in string slots', () {
      final info = UpdateInfo.tryParse(<String, Object?>{
        'latestVersion': '1.2.0',
        'storeUrl': 123,
        'message': <String, Object?>{},
      });
      expect(info, isNotNull);
      expect(info!.message, isNull);
      expect(info.storeUrlFor(TargetPlatform.android), isNull);
    });
  });

  group('UpdateInfo.storeUrlFor', () {
    UpdateInfo full() => UpdateInfo.tryParse(<String, Object?>{
      'latestVersion': '9.9.9',
      'storeUrl': 'https://truerise.com.ua/get',
      'appStoreUrl': 'https://apps.apple.com/app/id123456789',
      'playStoreUrl':
          'https://play.google.com/store/apps/details?id=app.truerise',
    })!;

    test('iOS prefers appStoreUrl', () {
      expect(
        full().storeUrlFor(TargetPlatform.iOS),
        'https://apps.apple.com/app/id123456789',
      );
    });

    test('Android prefers playStoreUrl', () {
      expect(
        full().storeUrlFor(TargetPlatform.android),
        'https://play.google.com/store/apps/details?id=app.truerise',
      );
    });

    test('falls back to the generic storeUrl when the platform slot '
        'is missing', () {
      final info = UpdateInfo.tryParse(<String, Object?>{
        'latestVersion': '9.9.9',
        'storeUrl': 'https://truerise.com.ua/get',
      })!;
      expect(info.storeUrlFor(TargetPlatform.iOS), 'https://truerise.com.ua/get');
      expect(
        info.storeUrlFor(TargetPlatform.android),
        'https://truerise.com.ua/get',
      );
    });

    test('skips a platform URL that fails the privacy-safe check and '
        'falls back to a safe generic one', () {
      final info = UpdateInfo.tryParse(<String, Object?>{
        'latestVersion': '9.9.9',
        'storeUrl': 'https://truerise.com.ua/get',
        'appStoreUrl': 'https://apps.apple.com/app/id1?utm_source=push',
      })!;
      expect(info.storeUrlFor(TargetPlatform.iOS), 'https://truerise.com.ua/get');
    });

    test('returns null when every candidate is unsafe', () {
      final info = UpdateInfo.tryParse(<String, Object?>{
        'latestVersion': '9.9.9',
        'storeUrl': 'http://insecure.example',
      })!;
      expect(info.storeUrlFor(TargetPlatform.iOS), isNull);
    });
  });

  group('UpdateInfo.messageFor', () {
    test('prefers the per-platform message over the shared one', () {
      final info = UpdateInfo.tryParse(<String, Object?>{
        'latestVersion': '9.9.9',
        'message': 'Shared note',
        'ios': <String, Object?>{'message': 'iOS note'},
        'android': <String, Object?>{'message': 'Android note'},
      })!;
      expect(info.messageFor(TargetPlatform.iOS), 'iOS note');
      expect(info.messageFor(TargetPlatform.android), 'Android note');
    });

    test('falls back to the shared message', () {
      final info = UpdateInfo.tryParse(<String, Object?>{
        'latestVersion': '9.9.9',
        'message': 'Shared note',
      })!;
      expect(info.messageFor(TargetPlatform.iOS), 'Shared note');
    });
  });

  group('UpdateInfo.promptTag', () {
    test('uses the raw latestVersion when present, else minimumVersion', () {
      final withLatest = UpdateInfo.tryParse(<String, Object?>{
        'latestVersion': '1.2.0+7',
        'minimumVersion': '1.1.0',
      })!;
      expect(withLatest.promptTag, '1.2.0+7');

      final minimumOnly = UpdateInfo.tryParse(<String, Object?>{
        'minimumVersion': '1.1.0',
      })!;
      expect(minimumOnly.promptTag, '1.1.0');
    });
  });
}
