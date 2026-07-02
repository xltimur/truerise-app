/// Pure path, opt-in, and frame-plan helpers for the committed raw store
/// screenshot capture harness.
///
/// This file performs no rendering and writes no files. It owns three things
/// the Flutter-test capture harness (`raw_screenshot_capture_test.dart`) needs,
/// kept pure so they are cheap to unit-test without a Flutter binding:
///
///  1. The safe draft destination directory plus a reviewed localized-capture
///     path builder. The default can only resolve inside that draft folder;
///     non-English canonical locale writes are limited to the two missing
///     current-plan frames after localization review.
///  2. The explicit environment opt-in that gates real on-disk writes, so a
///     normal `flutter test` run never touches the repository.
///  3. The declarative plan for the two current-five-frame story frames the
///     existing canonical packs are missing (problem hook + life events).
///
/// The draft folder deliberately lives under [kStoreScreenshotsRoot] for
/// discoverability next to the canonical `en` pack, but its directory name is
/// NOT a [supportedStoreLocales] entry. The compositor planning seam only ever
/// iterates that hardcoded locale list and validates locale segments through
/// [isSupportedStoreLocale], so draft frames can never be picked up by the
/// guarded compositor write path.
library;

import 'screenshot_compositor.dart';

/// Directory name of the draft scratch folder, a sibling of the canonical
/// locale packs under [kStoreScreenshotsRoot].
///
/// Intentionally NOT a [supportedStoreLocales] value: the compositor refuses
/// it as a path segment, so nothing here can be composited into a final asset.
const String kRawCaptureDraftDirName = 'en-current-draft';

/// Repository-relative root the raw draft captures are written to:
/// `screenshots/store/en-current-draft`.
const String kRawCaptureDraftRoot =
    '$kStoreScreenshotsRoot/$kRawCaptureDraftDirName';

/// Environment variable that must equal `1` to enable real on-disk writes into
/// [kRawCaptureDraftRoot]. Absent/any-other value keeps the harness in its safe
/// default (no repository writes).
const String kCaptureEnableEnv = 'RECTIFY_CAPTURE_RAW_SCREENSHOTS';

/// Environment variable selecting which single frame id to capture in a real
/// (opt-in) run. One frame per process; see the harness for why.
const String kCaptureFrameEnv = 'RECTIFY_CAPTURE_FRAME';

/// Environment variable selecting the target locale pack for a real capture.
///
/// Defaults to [kRawCaptureDraftDirName] for backwards-compatible English
/// draft captures. Non-English supported store locales are allowed only for
/// the current-plan frames listed in [kMissingCurrentPlanFrames].
const String kCaptureLocaleEnv = 'RECTIFY_CAPTURE_LOCALE';

/// Whether real on-disk writes into the repository are explicitly enabled.
///
/// True only when [kCaptureEnableEnv] is exactly `1`. Every other state
/// (missing, empty, `0`, `true`, ...) is treated as disabled so the default is
/// always "write nothing to the repo".
bool captureWritesEnabled(Map<String, String> environment) =>
    environment[kCaptureEnableEnv] == '1';

/// The trimmed frame id requested via [kCaptureFrameEnv], or null when unset or
/// blank.
String? requestedCaptureFrameId(Map<String, String> environment) {
  final raw = environment[kCaptureFrameEnv];
  if (raw == null) return null;
  final trimmed = raw.trim();
  return trimmed.isEmpty ? null : trimmed;
}

/// The requested capture target locale, defaulting to the safe English draft.
String requestedCaptureLocale(Map<String, String> environment) {
  final raw = environment[kCaptureLocaleEnv];
  if (raw == null) return kRawCaptureDraftDirName;
  final trimmed = raw.trim();
  return trimmed.isEmpty ? kRawCaptureDraftDirName : trimmed;
}

/// Matches a safe draft-scratch directory name: a lowercase alphanumeric slug
/// of `[a-z0-9]+` segments joined by single hyphens that ends in `-draft`.
///
/// The shape forbids path separators, parent-directory references, and
/// empty/leading/trailing/doubled hyphens, so a matching name is always safe to
/// use as a single path segment.
final RegExp _draftDirNamePattern = RegExp(
  r'^[a-z0-9]+(?:-[a-z0-9]+)*-draft$',
);

/// Whether [name] is a recognised draft scratch directory: it matches the
/// strict `-draft` slug shape AND is not a canonical store locale. The second
/// clause guarantees a draft folder can never shadow a shipped locale pack.
bool isDraftScreenshotDirName(String name) =>
    _draftDirNamePattern.hasMatch(name) && !isSupportedStoreLocale(name);

void _checkDraftFileName(String fileName) {
  if (fileName.isEmpty) {
    throw ArgumentError.value(fileName, 'fileName', 'File name is empty');
  }
  if (fileName.contains('/') || fileName.contains(r'\')) {
    throw ArgumentError.value(
      fileName,
      'fileName',
      'File name must not contain a path separator',
    );
  }
  if (fileName.contains('..')) {
    throw ArgumentError.value(
      fileName,
      'fileName',
      'File name must not contain a parent-directory reference',
    );
  }
  if (!isRawScreenshotFileName(fileName)) {
    throw ArgumentError.value(
      fileName,
      'fileName',
      'Not a raw screenshot name; expected NN-slug.png',
    );
  }
}

/// Repository-relative path a raw draft capture for [fileName] is written to:
/// `screenshots/store/en-current-draft/<fileName>`.
///
/// Throws [ArgumentError] for an unsafe/invalid file name, and [StateError] if
/// the derived path would ever fall inside a canonical
/// `screenshots/store/<locale>` pack (a defensive guard against future
/// incompatible changes - the draft directory must never be a shipped locale).
String draftRawScreenshotPath(String fileName) {
  _checkDraftFileName(fileName);
  final path = '$kRawCaptureDraftRoot/$fileName';
  for (final locale in supportedStoreLocales) {
    if (path.startsWith('$kStoreScreenshotsRoot/$locale/')) {
      throw StateError(
        'Draft path escaped into the canonical "$locale" locale pack: $path',
      );
    }
  }
  return path;
}

bool _isMissingCurrentPlanFile(String fileName) =>
    kMissingCurrentPlanFrames.any((frame) => frame.fileName == fileName);

/// Repository-relative path for an opt-in raw capture.
///
/// The default target is the English draft scratch folder. After localization
/// review, non-English canonical packs may receive only the missing
/// current-plan frames. English canonical writes are refused so the finalized
/// EN pack cannot be overwritten by the opt-in harness.
String captureRawScreenshotPath({
  required String locale,
  required String fileName,
}) {
  _checkDraftFileName(fileName);
  if (locale == kRawCaptureDraftDirName) {
    return draftRawScreenshotPath(fileName);
  }
  if (!isSupportedStoreLocale(locale)) {
    throw ArgumentError.value(
      locale,
      'locale',
      'Expected the draft folder or a supported store locale',
    );
  }
  if (locale == 'en') {
    throw ArgumentError.value(
      locale,
      'locale',
      'English canonical current-plan frames are already finalized',
    );
  }
  if (!_isMissingCurrentPlanFile(fileName)) {
    throw ArgumentError.value(
      fileName,
      'fileName',
      'Localized canonical captures are limited to missing current-plan frames',
    );
  }
  return rawScreenshotPath(locale, fileName);
}

/// One frame the current post-Appeeky five-frame story plan needs but the
/// existing canonical raw packs do not yet contain.
///
/// Pure data describing what shipped UI state to render and where to write it;
/// it performs no rendering and touches no file system.
class RawCaptureFrame {
  const RawCaptureFrame({
    required this.id,
    required this.fileName,
    required this.targetScreen,
    required this.route,
    required this.caption,
    required this.currentPlanOrder,
  });

  /// Stable id selected via [kCaptureFrameEnv], e.g. `problem-hook`.
  final String id;

  /// Raw output file name, e.g. `01-problem-hook.png` (an `NN-slug.png` name).
  final String fileName;

  /// The shipped screen widget this frame renders, e.g. `TimeWindowScreen`.
  final String targetScreen;

  /// The go_router route the frame is captured on, e.g. `/calc/window`.
  final String route;

  /// The current-plan overlay caption from `docs/store-listing-en.md` Sec. 5.
  /// Owner-composited later; never baked into the raw frame.
  final String caption;

  /// 1-based position in the current five-frame story order.
  final int currentPlanOrder;
}

/// The two current-plan frames missing from the canonical packs, in story
/// order: problem hook then life-events input.
const List<RawCaptureFrame> kMissingCurrentPlanFrames = <RawCaptureFrame>[
  RawCaptureFrame(
    id: 'problem-hook',
    fileName: '01-problem-hook.png',
    targetScreen: 'TimeWindowScreen',
    route: '/calc/window',
    caption: "Don't know your exact birth time?",
    currentPlanOrder: 1,
  ),
  RawCaptureFrame(
    id: 'life-events',
    fileName: '02-life-events.png',
    targetScreen: 'LifeEventsScreen',
    route: '/calc/events',
    caption: 'Add the life events you remember.',
    currentPlanOrder: 2,
  ),
];

/// The frame with the given [id], or null when no plan frame matches.
RawCaptureFrame? captureFrameById(String id) {
  for (final frame in kMissingCurrentPlanFrames) {
    if (frame.id == id) return frame;
  }
  return null;
}
