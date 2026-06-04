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
/// surface at the real landing/store URL **without a code change**:
///
/// ```sh
/// flutter build ipa \
///   --dart-define=TRUERISE_SHARE_URL=https://truerise.app
/// ```
///
/// `TRUERISE_SHARE_URL` is a **public** value (it ends up in shared text), not
/// a secret - do not route secrets through it.
///
/// ## Owner-confirm-before-release - the default is a placeholder
///
/// When no `--dart-define` override is supplied, [shareUrl] falls back to
/// [defaultShareUrl] (`https://truerise.app`). That default is a **brand
/// placeholder**: at this stage the host is **not** proven to be registered,
/// owned, or DNS-resolvable (a `curl` against it currently does not resolve).
/// Shipping it as-is would hand recipients a broken link.
///
/// **Release gate:** before publication the owner must provide or confirm a
/// resolvable landing/store URL - either by registering/owning `truerise.app`
/// or by passing `--dart-define=TRUERISE_SHARE_URL=...` with the real URL. The
/// default present in source is **not** proof of ownership or resolution. See
/// `docs/publication-readiness-current-status.md` section 5a.
///
/// Replacement path when the listings go live:
///   1. Point the build define / [defaultShareUrl] at the live marketing page
///      (which should itself redirect to the correct store per platform), or
///   2. Add platform-specific `appStoreUrl` / `playStoreUrl` constants and
///      update [shareUrl] to pick the right one (e.g. via `Platform`).
///
/// Whatever is configured must stay a bare HTTPS URL with no tracking params
/// and no personal data - see [isPrivacySafeShareUrl].
abstract final class AppLinks {
  /// Compile-time default used when no `TRUERISE_SHARE_URL` override is
  /// supplied. **Placeholder** - owner must confirm it is owned/resolvable, or
  /// override it, before release (see the class doc's release gate).
  static const String defaultShareUrl = 'https://truerise.app';

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
}
