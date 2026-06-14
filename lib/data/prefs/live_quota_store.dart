import 'package:shared_preferences/shared_preferences.dart';

/// Immutable view of the proxy-backed live quota at a given moment.
///
/// Derived by [LiveQuotaStore.read] from the persisted attempt count and
/// window start; never stored directly.
class LiveQuotaSnapshot {
  const LiveQuotaSnapshot({
    required this.used,
    required this.remaining,
    required this.exhausted,
    this.resetAt,
    this.retryAfter,
  });

  /// Attempts recorded in the current 24h window.
  final int used;

  /// Attempts left in the current window.
  final int remaining;

  /// True when [remaining] is zero.
  final bool exhausted;

  /// When the current window ends and the quota resets.
  /// Null when no attempt has been recorded yet (fresh window).
  final DateTime? resetAt;

  /// Time until [resetAt], relative to the `now` passed to `read`.
  /// Null when no attempt has been recorded yet.
  final Duration? retryAfter;
}

/// Persistence for the proxy-backed live attempt quota: at most
/// [maxAttempts] attempts per fixed 24h window, counted from the
/// first recorded attempt. Stores no secrets.
///
/// All methods take an explicit `now` so behaviour is deterministic
/// and unit-testable — no internal `DateTime.now()` calls.
class LiveQuotaStore {
  LiveQuotaStore(this._prefs);

  final SharedPreferences _prefs;

  static const maxAttempts = 3;
  static const window = Duration(hours: 24);

  static const _kCount = 'live_quota.count';
  static const _kWindowStartMs = 'live_quota.window_start_ms';

  /// Current quota state as of [now]. If the persisted window has
  /// already elapsed, reports a fresh (unused) quota; the stale keys
  /// are reset lazily on the next [recordAttempt].
  Future<LiveQuotaSnapshot> read(DateTime now) async {
    final startMs = _prefs.getInt(_kWindowStartMs);
    final count = _prefs.getInt(_kCount) ?? 0;

    if (startMs == null || count <= 0) {
      return _fresh();
    }

    final resetAt = DateTime.fromMillisecondsSinceEpoch(
      startMs,
      isUtc: true,
    ).add(window);
    if (!now.toUtc().isBefore(resetAt)) {
      return _fresh();
    }

    final used = count > maxAttempts ? maxAttempts : count;
    return LiveQuotaSnapshot(
      used: used,
      remaining: maxAttempts - used,
      exhausted: used >= maxAttempts,
      resetAt: resetAt,
      retryAfter: resetAt.difference(now.toUtc()),
    );
  }

  /// Record one proxy-backed live attempt at [now] and return the
  /// resulting snapshot. Starts a fresh 24h window when none is active
  /// or when the previous one has elapsed.
  Future<LiveQuotaSnapshot> recordAttempt(DateTime now) async {
    final nowUtc = now.toUtc();
    final startMs = _prefs.getInt(_kWindowStartMs);
    final count = _prefs.getInt(_kCount) ?? 0;

    final windowElapsed =
        startMs == null ||
        count <= 0 ||
        !nowUtc.isBefore(
          DateTime.fromMillisecondsSinceEpoch(startMs, isUtc: true).add(window),
        );

    if (windowElapsed) {
      await _prefs.setInt(_kWindowStartMs, nowUtc.millisecondsSinceEpoch);
      await _prefs.setInt(_kCount, 1);
    } else {
      await _prefs.setInt(_kCount, count + 1);
    }

    return read(now);
  }

  /// Wipe every quota key. Used by "Delete all data" and tests.
  Future<void> deleteAll() async {
    await _prefs.remove(_kCount);
    await _prefs.remove(_kWindowStartMs);
  }

  LiveQuotaSnapshot _fresh() => const LiveQuotaSnapshot(
    used: 0,
    remaining: maxAttempts,
    exhausted: false,
  );
}
