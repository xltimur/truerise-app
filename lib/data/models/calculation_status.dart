/// Lifecycle state of a `Calculations` row
/// (`docs/implementation-plan.md` §8.2 `status` column).
enum CalculationStatus {
  draft('draft'),
  submitted('submitted'),
  complete('complete'),
  error('error');

  const CalculationStatus(this.tag);

  final String tag;

  static CalculationStatus fromTag(String tag) {
    for (final value in CalculationStatus.values) {
      if (value.tag == tag) return value;
    }
    return CalculationStatus.draft;
  }
}
