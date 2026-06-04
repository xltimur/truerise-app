/// Public, non-secret outbound links for TrueRise.
///
/// These are **not** secrets. They are the same destinations that appear on
/// the public store listings and marketing site, so they are safe to ship in
/// source, logs, and shared text. (Contrast with API keys, proxy URLs, and
/// the demo/review `.env`, which stay in secure storage and are never printed
/// — see `README.md` and `docs/api-integration.md`.)
///
/// ## Placeholder status — final URLs not minted yet
///
/// The live App Store and Google Play listing URLs do not exist at this
/// stage, so [landing] is a single brand landing **placeholder**. Keeping one
/// indirection point here means shareable copy never has to embed a guessed
/// or platform-wrong store URL.
///
/// Replacement path when the listings go live:
///   1. Point [landing] at the live marketing page (which should itself
///      redirect to the correct store per platform), **or**
///   2. Add platform-specific `appStoreUrl` / `playStoreUrl` constants and
///      update [shareUrl] to pick the right one (e.g. via `Platform`).
///
/// The value carries no tracking parameters and no personal data — it is a
/// bare URL — so it is privacy-safe to include in shared text.
abstract final class AppLinks {
  /// Brand landing page. Placeholder until the marketing/store URLs are
  /// minted — see the class doc for the replacement path. Owner action:
  /// confirm this domain is registered/owned before release, or swap it for
  /// the real landing/store URL.
  static const String landing = 'https://truerise.app';

  /// The link embedded in shareable copy so a recipient can find the app.
  /// Currently the [landing] page; swap to a smart store link once live.
  static const String shareUrl = landing;
}
