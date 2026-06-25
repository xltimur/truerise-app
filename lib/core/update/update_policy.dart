import 'package:meta/meta.dart';
import 'package:rectify/core/update/app_version.dart';
import 'package:rectify/core/update/update_info.dart';

/// How urgently the user should be invited to update.
enum UpdateUrgency {
  /// Up to date (or no usable information) — show nothing.
  none,

  /// A newer version exists — show a blocking update prompt.
  soft,

  /// The installed version is below the owner-declared minimum — show the
  /// blocking gate whose only exit is the Update action.
  force,
}

/// The resolved outcome of one update check, ready for the UI layer.
@immutable
class UpdateDecision {
  const UpdateDecision({
    required this.urgency,
    this.storeUrl,
    this.message,
    this.promptTag,
  });

  const UpdateDecision.none() : this(urgency: UpdateUrgency.none);

  final UpdateUrgency urgency;

  /// Privacy-safe public store URL for the Update action, or `null` when
  /// none is configured.
  final String? storeUrl;

  /// Optional owner-supplied note from the hosted JSON. The blocking
  /// update modal intentionally uses app-localized copy instead.
  final String? message;

  /// Raw advertised version tag for diagnostics and tests.
  final String? promptTag;
}

/// Pure, deterministic update rule — no clock, no platform, no I/O, so it
/// is fully unit-testable (mirrors `ReviewPolicy`).
abstract final class UpdatePolicy {
  /// Maps the installed [current] version, the hosted [info], and the
  /// platform-resolved [storeUrl] / [message] to a decision.
  ///
  /// `minimumVersion > current` forces the gate, but **only** when a valid
  /// store URL exists — a gate without an Update action would trap the
  /// user, so it stays silent instead. A newer [UpdateInfo.latestVersion]
  /// also needs a valid store URL because the prompt is no longer
  /// dismissible.
  static UpdateDecision decide({
    required AppVersion current,
    required UpdateInfo info,
    required String? storeUrl,
    // Retained for older call sites/tests; dismissals no longer mute prompts.
    String? dismissedTag,
    String? message,
  }) {
    final minimum = info.minimumVersion;
    final latest = info.latestVersion;

    final belowMinimum = minimum != null && minimum > current;
    if (belowMinimum && storeUrl != null) {
      return UpdateDecision(
        urgency: UpdateUrgency.force,
        storeUrl: storeUrl,
        message: message,
        promptTag: info.promptTag,
      );
    }

    final hasNewer = belowMinimum || (latest != null && latest > current);
    if (!hasNewer) return const UpdateDecision.none();
    if (storeUrl == null) return const UpdateDecision.none();

    final tag = info.promptTag;
    return UpdateDecision(
      urgency: UpdateUrgency.soft,
      storeUrl: storeUrl,
      message: message,
      promptTag: tag,
    );
  }
}
