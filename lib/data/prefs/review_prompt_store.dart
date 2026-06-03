import 'package:shared_preferences/shared_preferences.dart';

/// Persistence for the in-app review throttle (mirrors `SettingsStore`).
///
/// Stores only a single non-sensitive timestamp — when the app last
/// invited the user to review — so the prompt can be rate-limited across
/// launches. No rating value or review text is ever persisted: the OS
/// never reports one (see `ReviewService`). Kept in its own key namespace
/// so a "Delete all data" settings wipe does not reset the cooldown and
/// re-open the user to nagging.
class ReviewPromptStore {
  ReviewPromptStore(this._prefs);

  final SharedPreferences _prefs;

  static const _kLastPromptAtMs = 'review.last_prompt_at_ms';

  /// When the app last invited a review, or `null` if it never has.
  DateTime? lastPromptAt() {
    final ms = _prefs.getInt(_kLastPromptAtMs);
    if (ms == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true);
  }

  /// Records that an invitation was shown at [when].
  Future<void> setLastPromptAt(DateTime when) =>
      _prefs.setInt(_kLastPromptAtMs, when.toUtc().millisecondsSinceEpoch);

  /// Clears the throttle. Not wired into the normal app flow today; kept
  /// for symmetry with the other stores and for tests.
  Future<void> clear() => _prefs.remove(_kLastPromptAtMs);
}
