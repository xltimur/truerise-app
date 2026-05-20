/// Time display preference held in user settings
/// (`docs/implementation-plan.md` §7.1 `SettingsModel`).
enum TimeFormat {
  h12('h12'),
  h24('h24');

  const TimeFormat(this.tag);

  final String tag;

  static TimeFormat fromTag(String tag) {
    for (final value in TimeFormat.values) {
      if (value.tag == tag) return value;
    }
    return TimeFormat.h12;
  }
}
