import 'package:flutter_test/flutter_test.dart';
import 'package:rectify/core/update/app_version.dart';
import 'package:rectify/core/update/update_info.dart';
import 'package:rectify/core/update/update_policy.dart';

/// Pins the pure decision rule that maps (installed version, hosted
/// version info, dismissal state, resolved store URL) to one of three
/// outcomes: no prompt, a dismissible soft prompt, or the force gate.
///
/// Invariants:
///   * `minimumVersion > current` forces the gate — but only when a valid
///     store URL exists; without one the gate would trap the user, so it
///     degrades to a dismissible soft prompt.
///   * `latestVersion > current` yields a soft prompt, shown at most once
///     per advertised version (dismissal is remembered by tag).
///   * Anything else — including equal versions — yields no prompt.
void main() {
  UpdateInfo info({String? latest, String? minimum}) {
    return UpdateInfo.tryParse(<String, Object?>{
      'latestVersion': ?latest,
      'minimumVersion': ?minimum,
    })!;
  }

  final current = AppVersion.tryParse('1.2.0+10')!;
  const store = 'https://apps.apple.com/app/id123456789';

  group('UpdatePolicy.decide — none', () {
    test('up to date: latest equals current', () {
      final d = UpdatePolicy.decide(
        current: current,
        info: info(latest: '1.2.0+10'),
        storeUrl: store,
      );
      expect(d.urgency, UpdateUrgency.none);
    });

    test('installed build is ahead of the advertised latest', () {
      final d = UpdatePolicy.decide(
        current: current,
        info: info(latest: '1.2.0'),
        storeUrl: store,
      );
      expect(d.urgency, UpdateUrgency.none);
    });

    test('soft prompt already dismissed for this advertised version', () {
      final d = UpdatePolicy.decide(
        current: current,
        info: info(latest: '1.3.0'),
        dismissedTag: '1.3.0',
        storeUrl: store,
      );
      expect(d.urgency, UpdateUrgency.none);
    });
  });

  group('UpdatePolicy.decide — soft', () {
    test('latest is newer than current', () {
      final d = UpdatePolicy.decide(
        current: current,
        info: info(latest: '1.3.0'),
        storeUrl: store,
      );
      expect(d.urgency, UpdateUrgency.soft);
      expect(d.storeUrl, store);
      expect(d.promptTag, '1.3.0');
    });

    test('a newer build of the same version counts as newer', () {
      final d = UpdatePolicy.decide(
        current: current,
        info: info(latest: '1.2.0+11'),
        storeUrl: store,
      );
      expect(d.urgency, UpdateUrgency.soft);
    });

    test('a previously dismissed older version does not mute a '
        'newer advertised one', () {
      final d = UpdatePolicy.decide(
        current: current,
        info: info(latest: '1.4.0'),
        dismissedTag: '1.3.0',
        storeUrl: store,
      );
      expect(d.urgency, UpdateUrgency.soft);
    });

    test('soft prompt survives a missing store URL (informational, '
        'no update action)', () {
      final d = UpdatePolicy.decide(
        current: current,
        info: info(latest: '1.3.0'),
        storeUrl: null,
      );
      expect(d.urgency, UpdateUrgency.soft);
      expect(d.storeUrl, isNull);
    });
  });

  group('UpdatePolicy.decide — force', () {
    test('minimum above current forces the gate when a store URL exists', () {
      final d = UpdatePolicy.decide(
        current: current,
        info: info(latest: '1.4.0', minimum: '1.3.0'),
        storeUrl: store,
      );
      expect(d.urgency, UpdateUrgency.force);
      expect(d.storeUrl, store);
    });

    test('force ignores any prior soft dismissal', () {
      final d = UpdatePolicy.decide(
        current: current,
        info: info(latest: '1.4.0', minimum: '1.3.0'),
        dismissedTag: '1.4.0',
        storeUrl: store,
      );
      expect(d.urgency, UpdateUrgency.force);
    });

    test('minimum equal to current does NOT force', () {
      final d = UpdatePolicy.decide(
        current: current,
        info: info(latest: '1.2.0+10', minimum: '1.2.0+10'),
        storeUrl: store,
      );
      expect(d.urgency, UpdateUrgency.none);
    });

    test('degrades to a dismissible soft prompt when no valid store URL '
        'is configured — never trap the user', () {
      final d = UpdatePolicy.decide(
        current: current,
        info: info(minimum: '1.3.0'),
        storeUrl: null,
      );
      expect(d.urgency, UpdateUrgency.soft);
      expect(d.storeUrl, isNull);
      expect(d.promptTag, '1.3.0');
    });

    test('degraded force respects a prior dismissal of the same tag', () {
      final d = UpdatePolicy.decide(
        current: current,
        info: info(minimum: '1.3.0'),
        dismissedTag: '1.3.0',
        storeUrl: null,
      );
      expect(d.urgency, UpdateUrgency.none);
    });

    test('minimum-only payload forces without a latestVersion', () {
      final d = UpdatePolicy.decide(
        current: current,
        info: info(minimum: '2.0.0'),
        storeUrl: store,
      );
      expect(d.urgency, UpdateUrgency.force);
    });
  });
}
