import 'package:flutter_test/flutter_test.dart';
import 'package:rectify/data/prefs/update_prompt_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Pins the persistence contract for the soft-update dismissal: the tag of
/// the advertised version the user dismissed is remembered across runs so
/// the same version is never re-prompted (mirrors the review/share prompt
/// store pattern).
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<SharedPreferences> prefs() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    return SharedPreferences.getInstance();
  }

  test('starts with no dismissed tag', () async {
    final store = UpdatePromptStore(await prefs());
    expect(store.dismissedTag(), isNull);
  });

  test('remembers the dismissed tag', () async {
    final store = UpdatePromptStore(await prefs());
    await store.setDismissedTag('1.3.0+7');
    expect(store.dismissedTag(), '1.3.0+7');
  });

  test('clear() resets the dismissal', () async {
    final store = UpdatePromptStore(await prefs());
    await store.setDismissedTag('1.3.0');
    await store.clear();
    expect(store.dismissedTag(), isNull);
  });
}
