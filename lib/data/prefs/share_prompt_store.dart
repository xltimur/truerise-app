import 'package:shared_preferences/shared_preferences.dart';

/// Persistence for the one-time, store-safe share affordances
/// (mirrors `ReviewPromptStore`).
///
/// Stores only non-sensitive booleans: whether the gentle post-demo sample
/// prompt and the first real-result friend-share prompt have already been
/// shown. No birth data, result content, invite status, or share text is ever
/// persisted here. Kept in its own key namespace so a "Delete all data"
/// settings wipe (which clears the `settings.*` keys) does not re-open the user
/// to prompts.
class SharePromptStore {
  SharePromptStore(this._prefs);

  final SharedPreferences _prefs;

  static const _kDemoSharePromptSeen = 'share.demo_prompt_seen';
  static const _kRealResultSharePromptSeen = 'share.real_result_prompt_seen';

  /// Whether the one-time post-demo share prompt has already been shown.
  bool demoSharePromptSeen() => _prefs.getBool(_kDemoSharePromptSeen) ?? false;

  /// Records that the post-demo share prompt was shown, so it never
  /// appears again.
  Future<void> markDemoSharePromptSeen() =>
      _prefs.setBool(_kDemoSharePromptSeen, true);

  /// Whether the one-time real-result friend-share prompt has been shown.
  bool realResultSharePromptSeen() =>
      _prefs.getBool(_kRealResultSharePromptSeen) ?? false;

  /// Records that the real-result friend-share prompt was shown, so it never
  /// appears again.
  Future<void> markRealResultSharePromptSeen() =>
      _prefs.setBool(_kRealResultSharePromptSeen, true);

  /// Clears the flag. Not wired into the normal app flow today; kept for
  /// symmetry with the other stores and for tests.
  Future<void> clear() async {
    await _prefs.remove(_kDemoSharePromptSeen);
    await _prefs.remove(_kRealResultSharePromptSeen);
  }
}
