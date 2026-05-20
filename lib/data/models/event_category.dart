/// Life-event categories matching PRD §F4.2.
///
/// String tags are stable wire / storage identifiers — do not rename
/// without a Drift migration.
enum EventCategory {
  marriage('marriage'),
  divorce('divorce'),
  careerChange('career_change'),
  jobLoss('job_loss'),
  relocation('relocation'),
  childBirth('child_birth'),
  familyDeath('family_death'),
  illness('illness'),
  accident('accident'),
  education('education'),
  financial('financial'),
  other('other');

  const EventCategory(this.tag);

  /// Stable storage tag.
  final String tag;

  /// Parses a [tag] back into the enum, or returns [other] when the
  /// value is unknown (forward-compat for older stored rows).
  static EventCategory fromTag(String tag) {
    for (final value in EventCategory.values) {
      if (value.tag == tag) return value;
    }
    return EventCategory.other;
  }
}
