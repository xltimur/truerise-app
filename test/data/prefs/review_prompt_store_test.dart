import 'package:flutter_test/flutter_test.dart';
import 'package:rectify/data/prefs/review_prompt_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  group('ReviewPromptStore', () {
    test('lastPromptAt is null when nothing has been written', () async {
      final prefs = await SharedPreferences.getInstance();
      final store = ReviewPromptStore(prefs);

      expect(store.lastPromptAt(), isNull);
    });

    test('setLastPromptAt round-trips the instant as UTC', () async {
      final prefs = await SharedPreferences.getInstance();
      final store = ReviewPromptStore(prefs);
      final when = DateTime.utc(2026, 6, 3, 12, 30, 15);

      await store.setLastPromptAt(when);

      expect(store.lastPromptAt(), when);
      expect(store.lastPromptAt()!.isUtc, isTrue);
    });

    test('clear removes the stored timestamp', () async {
      final prefs = await SharedPreferences.getInstance();
      final store = ReviewPromptStore(prefs);
      await store.setLastPromptAt(DateTime.utc(2026));

      await store.clear();

      expect(store.lastPromptAt(), isNull);
    });
  });
}
