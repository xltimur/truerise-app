import 'package:flutter/foundation.dart';
import 'package:rectify/core/app_links.dart';
import 'package:rectify/core/update/app_version.dart';

/// Parsed view of the owner-hosted version JSON behind
/// `TRUERISE_VERSION_CHECK_URL` (see `AppLinks.versionCheckUrl`).
///
/// Contract (all fields optional, unknown fields ignored):
///
/// ```json
/// {
///   "latestVersion": "1.2.0+7",
///   "minimumVersion": "1.1.0",
///   "storeUrl": "https://truerise.com.ua/get",
///   "appStoreUrl": "https://apps.apple.com/app/id123456789",
///   "playStoreUrl": "https://play.google.com/store/apps/details?id=app.truerise",
///   "message": "Optional note shown in the prompt.",
///   "ios": { "message": "Optional iOS-specific note." },
///   "android": { "message": "Optional Android-specific note." }
/// }
/// ```
///
/// The payload is public content with no secrets and no personal data.
/// Parsing is deliberately tolerant: malformed slots collapse to `null`
/// rather than failing the whole check, and a payload that carries no
/// parseable version at all yields `null` because it cannot drive any
/// decision.
@immutable
class UpdateInfo {
  const UpdateInfo._({
    required this.latestVersion,
    required this.minimumVersion,
    required this.latestRaw,
    required this.minimumRaw,
    required this.storeUrl,
    required this.appStoreUrl,
    required this.playStoreUrl,
    required this.message,
    required this.iosMessage,
    required this.androidMessage,
  });

  static UpdateInfo? tryParse(Object? json) {
    if (json is! Map) return null;

    final latestRaw = _string(json['latestVersion']);
    final minimumRaw = _string(json['minimumVersion']);
    final latest = latestRaw == null ? null : AppVersion.tryParse(latestRaw);
    final minimum = minimumRaw == null ? null : AppVersion.tryParse(minimumRaw);
    if (latest == null && minimum == null) return null;

    final ios = json['ios'];
    final android = json['android'];
    return UpdateInfo._(
      latestVersion: latest,
      minimumVersion: minimum,
      latestRaw: latest == null ? null : latestRaw,
      minimumRaw: minimum == null ? null : minimumRaw,
      storeUrl: _string(json['storeUrl']),
      appStoreUrl: _string(json['appStoreUrl']),
      playStoreUrl: _string(json['playStoreUrl']),
      message: _string(json['message']),
      iosMessage: ios is Map ? _string(ios['message']) : null,
      androidMessage: android is Map ? _string(android['message']) : null,
    );
  }

  static String? _string(Object? value) {
    if (value is! String) return null;
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  final AppVersion? latestVersion;
  final AppVersion? minimumVersion;
  final String? message;

  /// Raw advertised tags, kept verbatim for dismissal bookkeeping.
  final String? latestRaw;
  final String? minimumRaw;

  /// Unvalidated URL slots straight from the JSON; resolve through
  /// [storeUrlFor], which applies the privacy-safe check.
  final String? storeUrl;
  final String? appStoreUrl;
  final String? playStoreUrl;

  /// Per-platform note slots; resolve through [messageFor].
  final String? iosMessage;
  final String? androidMessage;

  /// Stable key for "the user already dismissed the prompt for this
  /// advertised version": the raw latest tag, or the raw minimum tag for
  /// minimum-only payloads.
  String? get promptTag => latestRaw ?? minimumRaw;

  /// The public store URL to open for [platform]: the platform-specific
  /// slot first, then the generic `storeUrl`. Every candidate must pass
  /// [AppLinks.isPrivacySafeStoreUrl]; an unsafe platform URL is skipped
  /// in favour of a safe generic one, and `null` means no safe URL exists.
  String? storeUrlFor(TargetPlatform platform) {
    final platformUrl = switch (platform) {
      TargetPlatform.iOS || TargetPlatform.macOS => appStoreUrl,
      TargetPlatform.android => playStoreUrl,
      _ => null,
    };
    for (final candidate in <String?>[platformUrl, storeUrl]) {
      if (candidate != null && AppLinks.isPrivacySafeStoreUrl(candidate)) {
        return candidate;
      }
    }
    return null;
  }

  /// The optional human-readable note for [platform]: the per-platform
  /// message first, then the shared one.
  String? messageFor(TargetPlatform platform) {
    final platformMessage = switch (platform) {
      TargetPlatform.iOS || TargetPlatform.macOS => iosMessage,
      TargetPlatform.android => androidMessage,
      _ => null,
    };
    return platformMessage ?? message;
  }
}
