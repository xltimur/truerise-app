import 'package:flutter_test/flutter_test.dart';
import 'package:rectify/core/update/app_version.dart';

/// Pins the parsing + ordering contract for [AppVersion], the value type
/// behind the update check. The format mirrors pubspec / store versioning:
/// `major.minor.patch+build` where patch and build are optional.
void main() {
  group('AppVersion.tryParse', () {
    test('parses a full semantic version with build number', () {
      final v = AppVersion.tryParse('1.2.3+45');
      expect(v, isNotNull);
      expect(v!.major, 1);
      expect(v.minor, 2);
      expect(v.patch, 3);
      expect(v.build, 45);
    });

    test('parses a version without a build number (build defaults to 0)', () {
      final v = AppVersion.tryParse('1.2.3');
      expect(v, isNotNull);
      expect(v!.build, 0);
    });

    test('parses short versions, missing segments default to 0', () {
      expect(AppVersion.tryParse('1.2'), const AppVersion(1, 2, 0));
      expect(AppVersion.tryParse('2'), const AppVersion(2, 0, 0));
    });

    test('tolerates surrounding whitespace and a leading v', () {
      expect(AppVersion.tryParse(' 1.2.3+45 '), const AppVersion(1, 2, 3, 45));
      expect(AppVersion.tryParse('v1.2.3'), const AppVersion(1, 2, 3));
    });

    test('rejects garbage, non-numeric, and malformed input', () {
      expect(AppVersion.tryParse(''), isNull);
      expect(AppVersion.tryParse('abc'), isNull);
      expect(AppVersion.tryParse('1.2.x'), isNull);
      expect(AppVersion.tryParse('1.2.3+x'), isNull);
      expect(AppVersion.tryParse('1.2.3+4+5'), isNull);
      expect(AppVersion.tryParse('1..3'), isNull);
      expect(AppVersion.tryParse('1.2.3.4'), isNull);
      expect(AppVersion.tryParse('1.-2.3'), isNull);
      expect(AppVersion.tryParse('+4'), isNull);
    });
  });

  group('AppVersion ordering', () {
    test('compares by major, then minor, then patch', () {
      expect(
        const AppVersion(2, 0, 0) > const AppVersion(1, 9, 9),
        isTrue,
      );
      expect(
        const AppVersion(1, 10, 0) > const AppVersion(1, 9, 9),
        isTrue,
      );
      expect(
        const AppVersion(1, 2, 4) > const AppVersion(1, 2, 3),
        isTrue,
      );
    });

    test('equal version triples compare by build number', () {
      expect(
        const AppVersion(1, 2, 3, 46) > const AppVersion(1, 2, 3, 45),
        isTrue,
      );
      expect(
        const AppVersion(1, 2, 3) < const AppVersion(1, 2, 3, 1),
        isTrue,
      );
    });

    test('a published latest without build is not newer than the same '
        'version already installed with a build number', () {
      final latest = AppVersion.tryParse('1.0.0')!;
      final current = AppVersion.tryParse('1.0.0+1')!;
      expect(latest > current, isFalse);
    });

    test('identical versions are equal and neither greater', () {
      const a = AppVersion(1, 2, 3, 45);
      const b = AppVersion(1, 2, 3, 45);
      expect(a == b, isTrue);
      expect(a > b, isFalse);
      expect(a < b, isFalse);
      expect(a.compareTo(b), 0);
      expect(a.hashCode, b.hashCode);
    });
  });
}
