import 'package:rectify/core/app_links.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens the owner-hosted privacy-policy page from the Settings row.
///
/// Abstracted behind an interface (like `StoreLauncher` / `ShareService`)
/// so widget tests can record launches instead of leaving the app.
abstract interface class PrivacyPolicyLauncher {
  /// Opens [url] in an in-app browser view. Returns `false` when the URL
  /// is unsafe, malformed, or the platform could not launch it — the
  /// caller then falls back to the bundled in-app privacy screen.
  Future<bool> open(String url);
}

/// Production launcher backed by `url_launcher`, structured like
/// `UrlLauncherStoreLauncher` — opens the public HTTPS page in an in-app
/// browser view (SFSafariViewController / Chrome Custom Tab, per
/// `docs/implementation-plan.md`); no SDK, no tracking, no extra
/// permissions.
class UrlLauncherPrivacyPolicyLauncher implements PrivacyPolicyLauncher {
  const UrlLauncherPrivacyPolicyLauncher();

  @override
  Future<bool> open(String url) async {
    // Defence in depth: even an owner-supplied build define must stay
    // within the bare-HTTPS contract before the OS sees it.
    if (!AppLinks.isPrivacySafeShareUrl(url)) return false;
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    try {
      return await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
    } on Object {
      return false;
    }
  }
}
