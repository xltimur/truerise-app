import 'package:flutter_test/flutter_test.dart';
import 'package:rectify/data/prefs/share_prompt_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  group('SharePromptStore', () {
    test('demoSharePromptSeen defaults to false', () async {
      final prefs = await SharedPreferences.getInstance();
      final store = SharePromptStore(prefs);

      expect(store.demoSharePromptSeen(), isFalse);
    });

    test('markDemoSharePromptSeen flips the flag to true', () async {
      final prefs = await SharedPreferences.getInstance();
      final store = SharePromptStore(prefs);

      await store.markDemoSharePromptSeen();

      expect(store.demoSharePromptSeen(), isTrue);
    });

    test('clear resets the flag', () async {
      final prefs = await SharedPreferences.getInstance();
      final store = SharePromptStore(prefs);
      await store.markDemoSharePromptSeen();

      await store.clear();

      expect(store.demoSharePromptSeen(), isFalse);
    });

    test('uses its own key namespace', () async {
      final prefs = await SharedPreferences.getInstance();
      final store = SharePromptStore(prefs);

      await store.markDemoSharePromptSeen();

      // The review throttle key must be untouched by the share-prompt store.
      expect(prefs.getInt('review.last_prompt_at_ms'), isNull);
      expect(prefs.getBool('share.demo_prompt_seen'), isTrue);
    });
  });
}
