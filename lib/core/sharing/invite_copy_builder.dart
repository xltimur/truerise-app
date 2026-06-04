import 'package:rectify/core/app_links.dart';
import 'package:rectify/l10n/l10n.dart';

/// Builds the privacy-safe, localized text for the opt-in "Invite a friend"
/// affordance in Settings (S4 — Invite Friend Lite).
///
/// This is a *soft* invitation, not a referral or reward program: it names
/// the product, says what it does, and links to the public landing/store
/// page ([AppLinks.shareUrl]). By design it takes **no** `SavedCalculation`
/// — there is structurally no path for a birth date, city, coordinates,
/// life event, label, API id, raw response, or any other personal data to
/// reach the invite. It also carries no referral code, reward, or tracking
/// parameter.
///
/// The prose is localized through [AppLocalizations]; the brand token and
/// the link are passed in as placeholders so translators cannot alter them.
abstract final class InviteCopyBuilder {
  /// Returns a non-empty, localized invite string. [l10n] supplies the
  /// localized prose; pass the active `context.l10n` bundle so the invite
  /// follows the app locale.
  static String build(AppLocalizations l10n) {
    return <String>[
      l10n.inviteCopyHeadline(appBrandName),
      l10n.inviteCopyBody,
      l10n.inviteCopyGetApp(AppLinks.shareUrl),
    ].join('\n');
  }
}
