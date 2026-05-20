/// Spacing scale from `docs/design-system.md` §4.1 (4pt base).
abstract final class AppSpacing {
  static const double s0 = 0;
  static const double s1 = 4;
  static const double s2 = 8;
  static const double s3 = 12;
  static const double s4 = 16;
  static const double s5 = 20;
  static const double s6 = 24;
  static const double s7 = 32;
  static const double s8 = 40;
  static const double s9 = 48;
  static const double s10 = 64;
  static const double s11 = 80;

  /// Default screen edge padding (24pt).
  static const double screenEdge = s6;

  /// Default in-card padding (20pt).
  static const double cardPadding = s5;

  /// Default gap between sibling sections (32pt).
  static const double sectionGap = s7;
}
