/// Mode flag on `TimeWindow` (`docs/implementation-plan.md` §7.1).
enum TimeWindowMode {
  /// User remembers an approximate time and a ± window in minutes.
  approximate('approximate'),

  /// User does not know the time at all; rectification will search
  /// the full 24-hour day.
  unknown('unknown');

  const TimeWindowMode(this.tag);

  final String tag;

  static TimeWindowMode fromTag(String tag) {
    for (final value in TimeWindowMode.values) {
      if (value.tag == tag) return value;
    }
    return TimeWindowMode.unknown;
  }
}
