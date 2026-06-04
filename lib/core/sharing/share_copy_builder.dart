import 'package:rectify/core/app_links.dart';
import 'package:rectify/data/models/candidate_time.dart';
import 'package:rectify/data/models/saved_calculation.dart';
import 'package:rectify/l10n/l10n.dart';

/// Builds the privacy-safe, localized text shared when the user taps
/// "Share result".
///
/// Only the rectified time, ascendant, confidence, the (held-constant)
/// brand name, and a public landing/store link ([AppLinks.shareUrl]) are
/// included. Birth city, birth date, life events, labels, API IDs, and raw
/// response data are intentionally excluded so they can never leak through a
/// share. The prose is localized through [AppLocalizations]; the brand token
/// and link are passed in as placeholders so translators cannot alter them.
abstract final class ShareCopyBuilder {
  /// Returns a non-empty, localized share string derived from the top
  /// candidate in [saved]. Never throws; falls back to a brand + link string
  /// if candidates are empty (defensive — the result screen already guards
  /// this).
  ///
  /// [l10n] supplies the localized prose; pass the active
  /// `context.l10n` bundle so the shared copy follows the app locale.
  static String build(SavedCalculation saved, AppLocalizations l10n) {
    final candidates = saved.result.candidates;
    final lines = <String>[];

    if (candidates.isNotEmpty) {
      final top = candidates.first;
      final timeStr = _formatTime(top);
      final confidence = l10n.shareCardConfidence(
        (top.confidence * 100).round(),
      );

      lines.add(l10n.shareCopyHeadline(appBrandName));
      if (top.ascendant != null) {
        final rising = l10n.resultRisingSign(top.ascendant!);
        lines.add('$timeStr · $rising · $confidence');
      } else {
        lines.add('$timeStr · $confidence');
      }
      // Blank line separating the result block from the attribution block.
      lines.add('');
    }

    lines
      ..add(l10n.shareCopyTagline(appBrandName))
      ..add(l10n.shareCopyGetApp(AppLinks.shareUrl));
    return lines.join('\n');
  }

  static String _formatTime(CandidateTime candidate) {
    final t = candidate.time;
    final isPm = t.hour >= 12;
    final hour12 = ((t.hour + 11) % 12) + 1;
    final minute = t.minute.toString().padLeft(2, '0');
    return '$hour12:$minute ${isPm ? 'PM' : 'AM'}';
  }
}
