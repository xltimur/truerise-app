import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Central icon mapping (`docs/design-system.md` §7).
///
/// All product icons resolve through `AppIcons` so swapping families (Lucide
/// ↔ Phosphor) is a one-file change. Final family pick deferred — see
/// `docs/implementation-plan.md` §15.3.
abstract final class AppIcons {
  // Navigation / structural
  static const IconData home = LucideIcons.house;
  static const IconData history = LucideIcons.clock;
  static const IconData settings = LucideIcons.settings;
  static const IconData back = LucideIcons.chevronLeft;
  static const IconData forward = LucideIcons.chevronRight;
  static const IconData close = LucideIcons.x;
  static const IconData add = LucideIcons.plus;
  static const IconData check = LucideIcons.check;
  static const IconData search = LucideIcons.search;
  static const IconData bookmark = LucideIcons.bookmark;
  static const IconData refresh = LucideIcons.rotateCw;
  static const IconData trash = LucideIcons.trash2;

  // Error screens (§9.13 / implementation-plan §11.3)
  static const IconData errorTimeout = LucideIcons.clockAlert;
  static const IconData errorNoInternet = LucideIcons.wifiOff;
  static const IconData errorBadRequest = LucideIcons.circleAlert;
  static const IconData errorUnauthorized = LucideIcons.lock;
  static const IconData errorServer = LucideIcons.serverCrash;
  static const IconData errorMalformed = LucideIcons.fileWarning;

  // Life-event categories (§7.3)
  static const IconData eventMarriage = LucideIcons.heart;
  static const IconData eventDivorce = LucideIcons.heartCrack;
  static const IconData eventCareer = LucideIcons.briefcase;
  static const IconData eventJobLoss = LucideIcons.trendingDown;
  static const IconData eventRelocation = LucideIcons.house;
  static const IconData eventBirth = LucideIcons.baby;
  static const IconData eventDeath = LucideIcons.flame;
  static const IconData eventIllness = LucideIcons.cross;
  static const IconData eventAccident = LucideIcons.triangleAlert;
  static const IconData eventEducation = LucideIcons.graduationCap;
  static const IconData eventFinancial = LucideIcons.coins;
  static const IconData eventOther = LucideIcons.bookmark;
}
