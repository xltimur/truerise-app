import 'package:meta/meta.dart';

/// An installed/advertised app version in the pubspec / store format
/// `major.minor.patch+build` (patch and build optional, e.g. `1.2.3+45`).
///
/// Ordering compares the semantic triple first and the build number only
/// as a tie-breaker, so `1.2.3+46 > 1.2.3+45` and `1.10.0 > 1.9.9`. A
/// missing patch or build is treated as `0`, which means an advertised
/// `1.0.0` is **not** newer than an installed `1.0.0+1` — owners must
/// advertise the build number to target same-version build bumps.
@immutable
class AppVersion implements Comparable<AppVersion> {
  const AppVersion(this.major, this.minor, this.patch, [this.build = 0]);

  /// Parses `1.2.3+45`-style input, tolerating surrounding whitespace and
  /// a leading `v`. Returns `null` for anything malformed — the update
  /// check treats unparseable versions as "no information", never as an
  /// update signal.
  static AppVersion? tryParse(String raw) {
    var s = raw.trim();
    if (s.startsWith('v') || s.startsWith('V')) {
      s = s.substring(1);
    }
    if (s.isEmpty) return null;

    final plusParts = s.split('+');
    if (plusParts.length > 2) return null;
    final versionPart = plusParts[0];

    var build = 0;
    if (plusParts.length == 2) {
      final parsed = _parseSegment(plusParts[1]);
      if (parsed == null) return null;
      build = parsed;
    }

    final segments = versionPart.split('.');
    if (segments.isEmpty || segments.length > 3) return null;
    final numbers = <int>[];
    for (final segment in segments) {
      final parsed = _parseSegment(segment);
      if (parsed == null) return null;
      numbers.add(parsed);
    }
    while (numbers.length < 3) {
      numbers.add(0);
    }
    return AppVersion(numbers[0], numbers[1], numbers[2], build);
  }

  /// Digits-only segment parse: rejects signs, whitespace, and empties so
  /// `-2`, `+4`, and `1..3` all fail instead of being silently coerced.
  static int? _parseSegment(String segment) {
    if (segment.isEmpty) return null;
    for (final unit in segment.codeUnits) {
      if (unit < 0x30 || unit > 0x39) return null;
    }
    return int.tryParse(segment);
  }

  final int major;
  final int minor;
  final int patch;
  final int build;

  @override
  int compareTo(AppVersion other) {
    if (major != other.major) return major.compareTo(other.major);
    if (minor != other.minor) return minor.compareTo(other.minor);
    if (patch != other.patch) return patch.compareTo(other.patch);
    return build.compareTo(other.build);
  }

  bool operator >(AppVersion other) => compareTo(other) > 0;
  bool operator >=(AppVersion other) => compareTo(other) >= 0;
  bool operator <(AppVersion other) => compareTo(other) < 0;
  bool operator <=(AppVersion other) => compareTo(other) <= 0;

  @override
  bool operator ==(Object other) =>
      other is AppVersion &&
      other.major == major &&
      other.minor == minor &&
      other.patch == patch &&
      other.build == build;

  @override
  int get hashCode => Object.hash(major, minor, patch, build);

  @override
  String toString() => '$major.$minor.$patch+$build';
}
