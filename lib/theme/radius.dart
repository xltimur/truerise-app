import 'package:flutter/widgets.dart';

/// Radius scale from `docs/design-system.md` §5.
abstract final class AppRadius {
  static const Radius xs = Radius.circular(6);
  static const Radius sm = Radius.circular(10);
  static const Radius md = Radius.circular(14);
  static const Radius lg = Radius.circular(20);
  static const Radius xl = Radius.circular(28);
  static const Radius full = Radius.circular(999);

  static const BorderRadius brXs = BorderRadius.all(xs);
  static const BorderRadius brSm = BorderRadius.all(sm);
  static const BorderRadius brMd = BorderRadius.all(md);
  static const BorderRadius brLg = BorderRadius.all(lg);
  static const BorderRadius brXl = BorderRadius.all(xl);
  static const BorderRadius brFull = BorderRadius.all(full);
}
