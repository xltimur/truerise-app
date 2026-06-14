import 'package:flutter_test/flutter_test.dart';
import 'package:rectify/data/prefs/live_quota_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  Future<LiveQuotaStore> makeStore() async {
    final prefs = await SharedPreferences.getInstance();
    return LiveQuotaStore(prefs);
  }

  group('LiveQuotaStore', () {
    test('fresh quota reports full allowance and no window', () async {
      final store = await makeStore();
      final now = DateTime.utc(2026, 6, 12, 10);

      final snapshot = await store.read(now);

      expect(snapshot.used, 0);
      expect(snapshot.remaining, 3);
      expect(snapshot.exhausted, isFalse);
      expect(snapshot.resetAt, isNull);
      expect(snapshot.retryAfter, isNull);
    });

    test('recordAttempt counts up and exhausts after three attempts', () async {
      final store = await makeStore();
      final first = DateTime.utc(2026, 6, 12, 10);
      final expectedReset = first.add(const Duration(hours: 24));

      final one = await store.recordAttempt(first);
      expect(one.used, 1);
      expect(one.remaining, 2);
      expect(one.exhausted, isFalse);
      expect(one.resetAt, expectedReset);
      expect(one.retryAfter, const Duration(hours: 24));

      final two = await store.recordAttempt(
        first.add(const Duration(hours: 1)),
      );
      expect(two.used, 2);
      expect(two.remaining, 1);
      expect(two.exhausted, isFalse);
      expect(two.resetAt, expectedReset);

      final three = await store.recordAttempt(
        first.add(const Duration(hours: 2)),
      );
      expect(three.used, 3);
      expect(three.remaining, 0);
      expect(three.exhausted, isTrue);
      expect(three.resetAt, expectedReset);
      expect(three.retryAfter, const Duration(hours: 22));
    });

    test('read after the 24h window reports a fresh quota', () async {
      final store = await makeStore();
      final first = DateTime.utc(2026, 6, 12, 10);
      await store.recordAttempt(first);
      await store.recordAttempt(first);
      await store.recordAttempt(first);

      final snapshot = await store.read(
        first.add(const Duration(hours: 24)),
      );

      expect(snapshot.used, 0);
      expect(snapshot.remaining, 3);
      expect(snapshot.exhausted, isFalse);
      expect(snapshot.resetAt, isNull);
      expect(snapshot.retryAfter, isNull);
    });

    test('recordAttempt after an expired window starts a new one', () async {
      final store = await makeStore();
      final first = DateTime.utc(2026, 6, 12, 10);
      await store.recordAttempt(first);
      await store.recordAttempt(first);
      await store.recordAttempt(first);

      final later = first.add(const Duration(hours: 25));
      final snapshot = await store.recordAttempt(later);

      expect(snapshot.used, 1);
      expect(snapshot.remaining, 2);
      expect(snapshot.exhausted, isFalse);
      expect(snapshot.resetAt, later.add(const Duration(hours: 24)));
      expect(snapshot.retryAfter, const Duration(hours: 24));
    });

    test('deleteAll clears the persisted quota', () async {
      final store = await makeStore();
      final first = DateTime.utc(2026, 6, 12, 10);
      await store.recordAttempt(first);
      await store.recordAttempt(first);

      await store.deleteAll();

      final snapshot = await store.read(first);
      expect(snapshot.used, 0);
      expect(snapshot.remaining, 3);
      expect(snapshot.exhausted, isFalse);
      expect(snapshot.resetAt, isNull);
      expect(snapshot.retryAfter, isNull);
    });
  });
}
