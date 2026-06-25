/// Public, non-secret outbound links for TrueRise.
///
/// These are **not** secrets. They are the same destinations that appear on
/// the public store listings and marketing site, so they are safe to ship in
/// source, logs, and shared text. (Contrast with API keys, proxy URLs, and
/// the demo/review `.env`, which stay in secure storage and are never printed
/// — see `README.md` and `docs/api-integration.md`.)
///
/// ## Owner-configurable at build time - no secret involved
///
/// [shareUrl] follows the same `String.fromEnvironment` build-config pattern
/// used for the (public, non-secret) proxy/provider URLs in
/// `lib/providers/core_providers.dart`. The owner can point every share/invite
/// surface at a different landing/store URL **without a code change**:
///
/// ```sh
/// flutter build ipa \
///   --dart-define=TRUERISE_SHARE_URL=https://truerise.com.ua
/// ```
///
/// `TRUERISE_SHARE_URL` is a **public** value (it ends up in shared text), not
/// a secret - do not route secrets through it.
///
/// ## Default - owner-confirmed primary domain
///
/// When no `--dart-define` override is supplied, [shareUrl] falls back to
/// [defaultShareUrl] (`https://truerise.com.ua`). This is the owner-purchased
/// primary domain for TrueRise. DNS and hosting setup are still pending as
/// external owner actions; the local release blocker is closed.
///
/// Whatever is configured must stay a bare HTTPS URL with no tracking params
/// and no personal data - see [isPrivacySafeShareUrl].
abstract final class AppLinks {
  /// Compile-time default used when no `TRUERISE_SHARE_URL` override is
  /// supplied. Owner-confirmed primary domain for TrueRise.
  static const String defaultShareUrl = 'https://truerise.com.ua';

  /// The single source of truth for the public, privacy-safe link embedded in
  /// shareable result copy (`ShareCopyBuilder`) and invite copy
  /// (`InviteCopyBuilder`).
  ///
  /// Owner-configurable at build time via the public, non-secret
  /// `--dart-define=TRUERISE_SHARE_URL=...`; falls back to [defaultShareUrl].
  /// Must always be a bare HTTPS URL with no query string / tracking params -
  /// validate any candidate with [isPrivacySafeShareUrl].
  static const String shareUrl = String.fromEnvironment(
    'TRUERISE_SHARE_URL',
    defaultValue: defaultShareUrl,
  );

  /// Brand landing page. Retained for callers/docs that reference the landing
  /// destination directly; it is the **same value** as [shareUrl] so there is
  /// exactly one source of truth.
  static const String landing = shareUrl;

  /// Public provider site where users can create or copy their own Astrology
  /// API key. This is not a secret and is safe to display in Settings.
  static const String astrologyApiKeyUrl = 'https://astrology-api.io/';

  /// Pure, side-effect-free check that a candidate share/invite URL is
  /// privacy-safe to embed in shared text.
  ///
  /// Returns `true` only for a bare **HTTPS** URL that has a host and carries
  /// **no** userinfo, query string, or fragment. Disallowing the query string
  /// structurally rules out tracking params (`utm_*`, `ref=`, `fbclid`,
  /// `gclid`, ...) because those can only live in the query.
  ///
  /// This is the testable expression of the share-link invariant: the default
  /// [shareUrl] and any owner-supplied `--dart-define` value can both be
  /// checked against it without mutating the compile-time environment at
  /// runtime.
  static bool isPrivacySafeShareUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    if (uri.scheme != 'https') return false;
    if (uri.host.isEmpty) return false;
    if (uri.userInfo.isNotEmpty) return false;
    if (uri.hasQuery) return false;
    if (uri.hasFragment) return false;
    return true;
  }

  /// Public, owner-hosted JSON endpoint for the app-update check
  /// (`UpdateInfo` documents the contract). **Disabled by default**: the
  /// empty default means no fake or unowned endpoint is ever called — the
  /// owner opts in at build time with
  /// `--dart-define=TRUERISE_VERSION_CHECK_URL=https://.../version.json`.
  ///
  /// Like [shareUrl], this is a public, non-secret value. The fetch sends
  /// no identifiers, headers, or personal data beyond the bare GET, and a
  /// configured value must pass [isPrivacySafeShareUrl] (bare HTTPS, no
  /// query/fragment/userinfo) or the check stays off.
  static const String versionCheckUrl = String.fromEnvironment(
    'TRUERISE_VERSION_CHECK_URL',
  );

  /// Public, owner-hosted privacy-policy page opened from the Settings
  /// privacy row. **Disabled by default**: the empty default means the row
  /// keeps pushing the bundled in-app `PrivacyPolicyScreen`; the owner opts
  /// in at build time with
  /// `--dart-define=TRUERISE_PRIVACY_POLICY_URL=https://.../privacy`.
  ///
  /// Like [shareUrl], this is a public, non-secret value. A configured
  /// value must pass [isPrivacySafeShareUrl] (bare HTTPS, host present, no
  /// userinfo, no query, no fragment) or the row falls back to the in-app
  /// screen — no unsafe URL is ever handed to the OS.
  static const String privacyPolicyUrl = String.fromEnvironment(
    'TRUERISE_PRIVACY_POLICY_URL',
  );

  /// Variant of [isPrivacySafeShareUrl] for **store** URLs opened by the
  /// update prompt. Identical rules — bare HTTPS, host present, no
  /// userinfo, no fragment — with one structural exception: a query
  /// string is allowed only on the canonical Play Store web URL
  /// (`https://play.google.com/store/apps/details?id=<app id>`), whose
  /// application id can only live in the query. The exception is exact:
  /// the host must be `play.google.com`, the path must be
  /// `/store/apps/details`, and the query must be a single non-empty
  /// `id`. Any other host/path with a query, an empty or repeated `id`,
  /// or any extra parameter (referrer, utm_*, ...) is rejected outright —
  /// that is where tracking lives.
  static bool isPrivacySafeStoreUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    if (uri.scheme != 'https') return false;
    if (uri.host.isEmpty) return false;
    if (uri.userInfo.isNotEmpty) return false;
    if (uri.hasFragment) return false;
    if (!uri.hasQuery) return true;
    if (uri.host != 'play.google.com') return false;
    if (uri.path != '/store/apps/details') return false;
    final params = uri.queryParametersAll;
    final ids = params['id'];
    return params.length == 1 &&
        ids != null &&
        ids.length == 1 &&
        ids.single.isNotEmpty;
  }
}
