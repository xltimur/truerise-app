import 'package:shared_preferences/shared_preferences.dart';

/// User's answer to the post-result "Does this time feel plausible?"
/// prompt (`docs/mvp-scope.md` S1 / feature-gap G18).
///
/// [tag] is the stable on-disk value; never rename a tag once shipped.
enum ResultFeedbackAnswer {
  yes('yes'),
  notSure('not_sure'),
  no('no');

  const ResultFeedbackAnswer(this.tag);

  /// Stable persisted representation of this answer.
  final String tag;

  /// Resolves a persisted [tag] back to its answer, or null when the
  /// value is missing or unrecognised (e.g. written by a future build).
  static ResultFeedbackAnswer? fromTag(String? tag) {
    for (final answer in values) {
      if (answer.tag == tag) return answer;
    }
    return null;
  }
}

/// Persistence for the local-only post-result plausibility feedback.
///
/// Stores only `result id -> answer tag` -- no birth data, locations,
/// events, result content, or remote identifiers ever land here. Keys
/// live in their own `result_feedback.answer.*` namespace so wiping
/// feedback (or other stores' keys) never touches unrelated prefs.
class ResultFeedbackStore {
  ResultFeedbackStore(this._prefs);

  final SharedPreferences _prefs;

  static const _keyPrefix = 'result_feedback.answer.';

  static String _key(String resultId) => '$_keyPrefix$resultId';

  /// Recorded answer for [resultId], or null when the user has not
  /// answered (or the stored tag is unrecognised).
  ResultFeedbackAnswer? read(String resultId) =>
      ResultFeedbackAnswer.fromTag(_prefs.getString(_key(resultId)));

  /// Records (or replaces) the answer for [resultId].
  Future<void> write(String resultId, ResultFeedbackAnswer answer) =>
      _prefs.setString(_key(resultId), answer.tag);

  /// Removes the answer for [resultId] only.
  Future<void> clear(String resultId) => _prefs.remove(_key(resultId));

  /// Removes every feedback key, leaving all other preferences intact.
  /// Used by "Delete all data" and tests.
  Future<void> deleteAll() async {
    final keys = _prefs
        .getKeys()
        .where((key) => key.startsWith(_keyPrefix))
        .toList();
    for (final key in keys) {
      await _prefs.remove(key);
    }
  }
}
