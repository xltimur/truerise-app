import 'package:shared_preferences/shared_preferences.dart';

/// Share/invite surfaces we measure locally.
///
/// These tags are deliberately generic: no result id, birth data, city,
/// life-event text, contact, destination app, or share message is recorded.
enum ShareAnalyticsSurface {
  resultText('result_text'),
  resultImage('result_image'),
  resultPrompt('result_prompt'),
  evidenceText('evidence_text'),
  historyRow('history_row'),
  homeInvite('home_invite'),
  settingsInvite('settings_invite');

  const ShareAnalyticsSurface(this.tag);

  final String tag;
}

/// The kind of payload the user attempted to share.
enum ShareAnalyticsContent {
  resultText('result_text'),
  resultImage('result_image'),
  inviteText('invite_text');

  const ShareAnalyticsContent(this.tag);

  final String tag;
}

/// Whether the native share sheet opened or the app used its fallback.
enum ShareAnalyticsOutcome {
  nativeSheet('native_sheet'),
  fallback('fallback');

  const ShareAnalyticsOutcome(this.tag);

  final String tag;
}

/// Privacy-safe analytics boundary for growth-loop instrumentation.
abstract interface class AppAnalytics {
  Future<void> recordShare({
    required ShareAnalyticsSurface surface,
    required ShareAnalyticsContent content,
    required ShareAnalyticsOutcome outcome,
  });

  Future<void> deleteAll();
}

/// Local-only aggregate counters for share/invite instrumentation.
///
/// This is intentionally not an analytics SDK. It persists only integer
/// counters under stable namespaced keys, enough for in-app QA and a future
/// export/SDK bridge without creating a new PII surface.
class LocalAppAnalytics implements AppAnalytics {
  LocalAppAnalytics(this._prefs);

  final SharedPreferences _prefs;

  static const _prefix = 'analytics.share.';
  static const _kTotal = '${_prefix}total';

  @override
  Future<void> recordShare({
    required ShareAnalyticsSurface surface,
    required ShareAnalyticsContent content,
    required ShareAnalyticsOutcome outcome,
  }) async {
    await _increment(_kTotal);
    await _increment(_surfaceKey(surface));
    await _increment(_contentKey(content));
    await _increment(_outcomeKey(outcome));
    await _increment(_surfaceOutcomeKey(surface, outcome));
  }

  /// Reads aggregate share counts. When no filter is passed, returns the total.
  /// Combined filters are only currently written for surface + outcome.
  int shareCount({
    ShareAnalyticsSurface? surface,
    ShareAnalyticsContent? content,
    ShareAnalyticsOutcome? outcome,
  }) {
    if (surface == null && content == null && outcome == null) {
      return _prefs.getInt(_kTotal) ?? 0;
    }
    if (surface != null && content == null && outcome == null) {
      return _prefs.getInt(_surfaceKey(surface)) ?? 0;
    }
    if (surface == null && content != null && outcome == null) {
      return _prefs.getInt(_contentKey(content)) ?? 0;
    }
    if (surface == null && content == null && outcome != null) {
      return _prefs.getInt(_outcomeKey(outcome)) ?? 0;
    }
    if (surface != null && content == null && outcome != null) {
      return _prefs.getInt(_surfaceOutcomeKey(surface, outcome)) ?? 0;
    }
    return 0;
  }

  /// Removes only analytics counters, leaving settings and other prefs intact.
  @override
  Future<void> deleteAll() async {
    final keys = _prefs
        .getKeys()
        .where((key) => key.startsWith(_prefix))
        .toList();
    for (final key in keys) {
      await _prefs.remove(key);
    }
  }

  Future<void> _increment(String key) async {
    await _prefs.setInt(key, (_prefs.getInt(key) ?? 0) + 1);
  }

  static String _surfaceKey(ShareAnalyticsSurface surface) =>
      '${_prefix}surface.${surface.tag}';

  static String _contentKey(ShareAnalyticsContent content) =>
      '${_prefix}content.${content.tag}';

  static String _outcomeKey(ShareAnalyticsOutcome outcome) =>
      '${_prefix}outcome.${outcome.tag}';

  static String _surfaceOutcomeKey(
    ShareAnalyticsSurface surface,
    ShareAnalyticsOutcome outcome,
  ) => '${_prefix}surface.${surface.tag}.outcome.${outcome.tag}';
}
