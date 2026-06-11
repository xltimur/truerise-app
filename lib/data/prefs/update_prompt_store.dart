import 'package:shared_preferences/shared_preferences.dart';

/// Persistence for the soft-update dismissal (mirrors
/// `ReviewPromptStore` / `SharePromptStore`).
///
/// Stores only the advertised version tag the user dismissed — no
/// timestamps, identifiers, or personal data — so a soft prompt for the
/// same advertised version is never repeated, while a newer advertised
/// version prompts again.
class UpdatePromptStore {
  UpdatePromptStore(this._prefs);

  final SharedPreferences _prefs;

  static const String _dismissedTagKey = 'update.dismissed_tag';

  /// The advertised version tag last dismissed, or `null` if none.
  String? dismissedTag() => _prefs.getString(_dismissedTagKey);

  Future<void> setDismissedTag(String tag) =>
      _prefs.setString(_dismissedTagKey, tag);

  /// Test/maintenance hook.
  Future<void> clear() async {
    await _prefs.remove(_dismissedTagKey);
  }
}
