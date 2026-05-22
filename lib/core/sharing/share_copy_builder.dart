import 'package:rectify/data/models/candidate_time.dart';
import 'package:rectify/data/models/saved_calculation.dart';

/// Builds the privacy-safe text shared when the user taps "Share result".
///
/// Only the rectified time, ascendant, and confidence are included.
/// Birth city, birth date, life events, labels, API IDs, and raw
/// response data are intentionally excluded.
abstract final class ShareCopyBuilder {
  /// Returns a non-empty share string derived from the top candidate in
  /// [saved]. Never throws; falls back to a minimal string if candidates
  /// are empty (defensive — the result screen already guards this).
  static String build(SavedCalculation saved) {
    final candidates = saved.result.candidates;
    if (candidates.isEmpty) {
      return 'TrueRise — birth-time rectification';
    }

    final top = candidates.first;
    final timeStr = _formatTime(top);
    final ascendant = top.ascendant;
    final pct = (top.confidence * 100).round();

    final buffer = StringBuffer('My TrueRise rectification result:\n');
    if (ascendant != null) {
      buffer.write('$timeStr · $ascendant Rising · $pct% confidence');
    } else {
      buffer.write('$timeStr · $pct% confidence');
    }
    buffer.write('\n\nCalculated with TrueRise — birth-time rectification');
    return buffer.toString();
  }

  static String _formatTime(CandidateTime candidate) {
    final t = candidate.time;
    final isPm = t.hour >= 12;
    final hour12 = ((t.hour + 11) % 12) + 1;
    final minute = t.minute.toString().padLeft(2, '0');
    return '$hour12:$minute ${isPm ? 'PM' : 'AM'}';
  }
}
