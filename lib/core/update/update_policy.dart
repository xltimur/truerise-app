import 'package:meta/meta.dart';
import 'package:rectify/core/update/app_version.dart';
import 'package:rectify/core/update/update_info.dart';

/// How urgently the user should be invited to update.
enum UpdateUrgency {
  /// Up to date (or no usable information) — show nothing.
  none,

  /// A newer version exists — show a dismissible prompt, at most once per
  /// advertised version.
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
  /// none is configured (the prompt is then informational only).
  final String? storeUrl;

  /// Optional owner-supplied note from the hosted JSON; the UI falls back
  /// to its localized copy when absent.
  final String? message;

  /// Tag recorded on dismissal so the same advertised version is never
  /// re-prompted (soft prompts only).
  final String? promptTag;
}

/// Pure, deterministic update rule — no clock, no platform, no I/O, so it
/// is fully unit-testable (mirrors `ReviewPolicy`).
abstract final class UpdatePolicy {
  /// Maps the installed [current] version, the hosted [info], the
  /// remembered soft-dismissal [dismissedTag], and the platform-resolved
  /// [storeUrl] / [message] to a decision.
  ///
  /// `minimumVersion > current` forces the gate, but **only** when a valid
  /// store URL exists — a gate without an Update action would trap the
  /// user, so it degrades to a dismissible soft prompt instead. Soft
  /// prompts are muted once their [UpdateInfo.promptTag] has been
  /// dismissed; the force gate ignores dismissals.
  static UpdateDecision decide({
    required AppVersion current,
    required UpdateInfo info,
    required String? storeUrl,
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

    final tag = info.promptTag;
    if (tag != null && tag == dismissedTag) {
      return const UpdateDecision.none();
    }
    return UpdateDecision(
      urgency: UpdateUrgency.soft,
      storeUrl: storeUrl,
      message: message,
      promptTag: tag,
    );
  }
}
