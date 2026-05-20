/// Ordinal strength of a single evidence match
/// (`docs/implementation-plan.md` §7.1).
///
/// Domain-layer enum — the widget layer adds visual data via an
/// extension in `lib/widgets/result/match_strength_dots.dart`.
enum MatchStrength {
  strong('strong'),
  moderate('moderate'),
  weak('weak'),
  none('none');

  const MatchStrength(this.tag);

  final String tag;

  static MatchStrength fromTag(String tag) {
    for (final value in MatchStrength.values) {
      if (value.tag == tag) return value;
    }
    return MatchStrength.none;
  }
}
