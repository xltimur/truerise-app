import 'package:rectify/core/app_links.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens the public store page from the update prompt.
///
/// Abstracted behind an interface (like `ShareService` / `ReviewService`)
/// so widget tests can record launches instead of leaving the app.
abstract interface class StoreLauncher {
  /// Opens [url] externally. Returns `false` when the URL is unsafe,
  /// malformed, or the platform could not launch it — callers surface a
  /// SnackBar instead of failing.
  Future<bool> open(String url);
}

/// Production launcher backed by `url_launcher` — the smallest
/// flutter.dev-maintained plugin that can hand a public HTTPS store URL
/// to the OS browser/store app; no SDK, no tracking, no extra permissions.
class UrlLauncherStoreLauncher implements StoreLauncher {
  const UrlLauncherStoreLauncher();

  @override
  Future<bool> open(String url) async {
    // Defence in depth: even an owner-hosted JSON slot must stay within
    // the privacy-safe store-URL contract before the OS sees it.
    if (!AppLinks.isPrivacySafeStoreUrl(url)) return false;
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } on Object {
      return false;
    }
  }
}
