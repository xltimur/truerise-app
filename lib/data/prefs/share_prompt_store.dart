import 'package:shared_preferences/shared_preferences.dart';

/// Persistence for the one-time, post-demo "share this sample" affordance
/// (mirrors `ReviewPromptStore`).
///
/// Stores only a single non-sensitive boolean — whether the gentle
/// post-demo share prompt has already been shown once — so it never
/// nags on later demo results or across launches. No birth data, result
/// content, or share text is ever persisted here. Kept in its own key
/// namespace so a "Delete all data" settings wipe (which clears the
/// `settings.*` keys) does not re-open the user to the prompt.
class SharePromptStore {
  SharePromptStore(this._prefs);

  final SharedPreferences _prefs;

  static const _kDemoSharePromptSeen = 'share.demo_prompt_seen';

  /// Whether the one-time post-demo share prompt has already been shown.
  bool demoSharePromptSeen() => _prefs.getBool(_kDemoSharePromptSeen) ?? false;

  /// Records that the post-demo share prompt was shown, so it never
  /// appears again.
  Future<void> markDemoSharePromptSeen() =>
      _prefs.setBool(_kDemoSharePromptSeen, true);

  /// Clears the flag. Not wired into the normal app flow today; kept for
  /// symmetry with the other stores and for tests.
  Future<void> clear() => _prefs.remove(_kDemoSharePromptSeen);
}
