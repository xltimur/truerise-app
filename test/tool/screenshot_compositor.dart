/// Pure path and geometry helpers for the (future) store screenshot
/// compositing harness.
///
/// This first slice performs no image rendering. It only derives and
/// validates the paths a later widget/golden test will write to, so that
/// compositing can never overwrite a raw captured screenshot. Keeping the
/// logic pure makes it cheap to unit-test and safe to import from a future
/// `composite_store_screenshots_test.dart`.
library;

/// Repository-relative root holding the raw captured store screenshots, one
/// sub-folder per locale: `screenshots/store/<locale>`.
const String kStoreScreenshotsRoot = 'screenshots/store';

/// Name of the per-locale sub-directory that will hold the composited
/// (caption + device frame) screenshots. It is what keeps outputs from ever
/// colliding with the raw source frames.
const String kCompositedDirName = 'composited';

/// Locale folders that currently exist under [kStoreScreenshotsRoot].
///
/// Mirrors the on-disk layout; a value not in this list is rejected rather
/// than trusted as a path segment.
const List<String> supportedStoreLocales = <String>[
  'en',
  'de',
  'fr',
  'es',
  'pt-BR',
];

/// Matches a raw screenshot file name such as `01-result-hero.png`: a
/// two-digit order prefix, a hyphen, then one or more lowercase alphanumeric
/// slug segments joined by single hyphens, and a `.png` extension, anchored
/// end to end.
///
/// The slug is built from `[a-z0-9]+` segments separated by single hyphens,
/// so empty, leading, trailing, or doubled hyphens (`01-.png`, `01--hero.png`,
/// `01-hero-.png`) are rejected. Because the pattern forbids path separators
/// and `.` runs, any name that would escape the locale directory (`..`, `a/b`,
/// absolute paths) fails to match too.
final RegExp _rawScreenshotNamePattern = RegExp(
  r'^[0-9]{2}-[a-z0-9]+(?:-[a-z0-9]+)*\.png$',
);

/// Whether [locale] is a known, safe locale folder name.
bool isSupportedStoreLocale(String locale) =>
    supportedStoreLocales.contains(locale);

/// Whether [fileName] looks like a raw store screenshot (`NN-slug.png`).
bool isRawScreenshotFileName(String fileName) =>
    _rawScreenshotNamePattern.hasMatch(fileName);

void _checkLocale(String locale) {
  if (!isSupportedStoreLocale(locale)) {
    throw ArgumentError.value(
      locale,
      'locale',
      'Unknown store locale; expected one of $supportedStoreLocales',
    );
  }
}

void _checkFileName(String fileName) {
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

/// Repository-relative path of the raw screenshot for [locale]/[fileName].
///
/// Throws [ArgumentError] if [locale] or [fileName] is unknown or unsafe.
String rawScreenshotPath(String locale, String fileName) {
  _checkLocale(locale);
  _checkFileName(fileName);
  return '$kStoreScreenshotsRoot/$locale/$fileName';
}

/// Repository-relative path the composited screenshot for [locale]/[fileName]
/// will be written to: `screenshots/store/<locale>/composited/<fileName>`.
///
/// Throws [ArgumentError] if [locale] or [fileName] is unknown or unsafe.
String compositedOutputPath(String locale, String fileName) {
  _checkLocale(locale);
  _checkFileName(fileName);
  return '$kStoreScreenshotsRoot/$locale/$kCompositedDirName/$fileName';
}

/// Resolved raw/output path pair for a single composited screenshot.
///
/// Build instances via [resolveCompositedTarget], which validates the inputs
/// and guarantees [outputPath] lives inside the `composited` directory and
/// can never equal [rawPath].
class CompositedTarget {
  CompositedTarget._({
    required this.locale,
    required this.fileName,
    required this.rawPath,
    required this.outputPath,
  });

  /// The `composited/` path segment that separates outputs from raw sources.
  static const String compositedSegment = '/$kCompositedDirName/';

  /// The locale folder, e.g. `en`.
  final String locale;

  /// The raw screenshot file name, e.g. `01-result-hero.png`.
  final String fileName;

  /// Repository-relative path of the raw source screenshot.
  final String rawPath;

  /// Repository-relative path the composited screenshot will be written to.
  final String outputPath;
}

/// Resolves the validated raw and composited-output paths for
/// [locale]/[fileName].
///
/// Throws [ArgumentError] for unknown/unsafe inputs, and [StateError] if the
/// derived output would ever collide with the raw source or escape the
/// `composited` directory (a guard against future incompatible changes).
CompositedTarget resolveCompositedTarget(String locale, String fileName) {
  final rawPath = rawScreenshotPath(locale, fileName);
  final outputPath = compositedOutputPath(locale, fileName);
  if (outputPath == rawPath) {
    throw StateError('Composited output collides with raw source: $rawPath');
  }
  if (!outputPath.contains(CompositedTarget.compositedSegment)) {
    throw StateError(
      'Composited output escaped the composited directory: $outputPath',
    );
  }
  return CompositedTarget._(
    locale: locale,
    fileName: fileName,
    rawPath: rawPath,
    outputPath: outputPath,
  );
}

/// Raw store screenshot canvas width in pixels (iPhone 6.7" portrait).
const int kRawScreenshotWidth = 1290;

/// Raw store screenshot canvas height in pixels (iPhone 6.7" portrait).
const int kRawScreenshotHeight = 2796;

/// Matches a safe output-profile id: lowercase alphanumeric `[a-z0-9]+`
/// segments joined by single hyphens, anchored end to end. The same shape as a
/// raw screenshot slug, so an id can never introduce a path separator, a
/// parent-directory reference, or empty/leading/trailing/doubled hyphens.
final RegExp _outputProfileIdPattern = RegExp(
  r'^[a-z0-9]+(?:-[a-z0-9]+)*$',
);

/// Whether [id] is a safe output-profile id usable as a path/file segment.
bool isSafeOutputProfileId(String id) => _outputProfileIdPattern.hasMatch(id);

/// A named store-screenshot output size profile (e.g. a particular device
/// display class an app store expects screenshots for).
///
/// Pure data: it carries only the target pixel dimensions and human-facing
/// metadata; it performs no rendering and touches no file system. The [id] is
/// validated by [isSafeOutputProfileId] (see the profile-id test) so it is
/// safe to embed in a path or file name later.
class StoreScreenshotOutputProfile {
  const StoreScreenshotOutputProfile({
    required this.id,
    required this.label,
    required this.width,
    required this.height,
  }) : assert(width > 0, 'width must be positive'),
       assert(height > 0, 'height must be positive');

  /// Stable, path-safe identifier, e.g. `iphone-6-7`.
  final String id;

  /// Human-readable label, e.g. `iPhone 6.7" portrait`.
  final String label;

  /// Target canvas width in pixels.
  final int width;

  /// Target canvas height in pixels.
  final int height;

  /// Target canvas width as a double, for layout math.
  double get widthPx => width.toDouble();

  /// Target canvas height as a double, for layout math.
  double get heightPx => height.toDouble();

  /// Width-to-height ratio of the target canvas.
  double get aspectRatio => width / height;
}

/// Default profile: the current iPhone 6.7" large-display portrait canvas
/// (`1290x2796`), accepted by Apple for the large iPhone display.
const StoreScreenshotOutputProfile kIphone67OutputProfile =
    StoreScreenshotOutputProfile(
      id: 'iphone-6-7',
      label: 'iPhone 6.7" portrait',
      width: kRawScreenshotWidth,
      height: kRawScreenshotHeight,
    );

/// Apple iPhone 6.5" portrait canvas (`1242x2688`) from Apple's screenshot
/// specifications.
const StoreScreenshotOutputProfile kIphone65OutputProfile =
    StoreScreenshotOutputProfile(
      id: 'iphone-6-5',
      label: 'iPhone 6.5" portrait',
      width: 1242,
      height: 2688,
    );

/// Google Play phone portrait recommendation: 9:16 at the minimum recommended
/// `1080x1920`.
const StoreScreenshotOutputProfile kGooglePlayPhoneOutputProfile =
    StoreScreenshotOutputProfile(
      id: 'google-play-phone',
      label: 'Google Play phone portrait',
      width: 1080,
      height: 1920,
    );

/// All supported named output size profiles. The first entry is the default
/// (current) profile and is dimensionally identical to the raw canvas.
const List<StoreScreenshotOutputProfile> storeScreenshotOutputProfiles =
    <StoreScreenshotOutputProfile>[
      kIphone67OutputProfile,
      kIphone65OutputProfile,
      kGooglePlayPhoneOutputProfile,
    ];

/// An axis-aligned rectangle in canvas pixels.
///
/// Kept dependency-free (no `dart:ui`) so this slice stays pure logic; a
/// later rendering widget can map it onto a `Rect`.
class LayoutBox {
  const LayoutBox({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
  });

  /// Distance from the canvas left edge to the box left edge.
  final double left;

  /// Distance from the canvas top edge to the box top edge.
  final double top;

  /// Box width in pixels.
  final double width;

  /// Box height in pixels.
  final double height;

  /// Right edge (`left + width`).
  double get right => left + width;

  /// Bottom edge (`top + height`).
  double get bottom => top + height;
}

/// Geometry for one composited store screenshot: a caption band above a
/// framed device mock, both inset from the canvas edges.
///
/// This documents the intended layout for a later rendering widget; it
/// performs no rendering.
class StoreScreenshotLayout {
  const StoreScreenshotLayout({
    required this.canvasWidth,
    required this.canvasHeight,
    required this.captionBand,
    required this.deviceFrame,
  });

  /// Layout for the standard [kRawScreenshotWidth] x [kRawScreenshotHeight]
  /// raw canvas.
  factory StoreScreenshotLayout.standard() => StoreScreenshotLayout.forCanvas(
    width: kRawScreenshotWidth.toDouble(),
    height: kRawScreenshotHeight.toDouble(),
  );

  /// Layout for a named output size [profile].
  ///
  /// Margin, caption band, and gap are scaled by the height ratio against the
  /// baseline [kRawScreenshotHeight] canvas, so the layout stays geometrically
  /// proportional. Because that scale applies equally to the caption band and
  /// the canvas height, the caption band keeps the baseline's
  /// `480 / 2796 ~= 17%` share of canvas height for every profile, staying
  /// under the 20% Google Play tagline guidance; the device frame likewise
  /// stays positive and inside the canvas. For the default
  /// [kIphone67OutputProfile] the scale is exactly `1.0`, so this is identical
  /// to [StoreScreenshotLayout.standard].
  factory StoreScreenshotLayout.forProfile(
    StoreScreenshotOutputProfile profile,
  ) {
    final scale = profile.heightPx / kRawScreenshotHeight;
    return StoreScreenshotLayout.forCanvas(
      width: profile.widthPx,
      height: profile.heightPx,
      margin: 80 * scale,
      captionBandHeight: 480 * scale,
      gap: 80 * scale,
    );
  }

  /// Derives a layout for an arbitrary canvas using a fixed edge [margin], a
  /// caption band of [captionBandHeight], and a [gap] between the band and
  /// the device frame. The device frame fills the remaining height.
  factory StoreScreenshotLayout.forCanvas({
    required double width,
    required double height,
    double margin = 80,
    double captionBandHeight = 480,
    double gap = 80,
  }) {
    final contentWidth = width - margin * 2;
    final captionBand = LayoutBox(
      left: margin,
      top: margin,
      width: contentWidth,
      height: captionBandHeight,
    );
    final deviceFrameTop = captionBand.bottom + gap;
    final deviceFrame = LayoutBox(
      left: margin,
      top: deviceFrameTop,
      width: contentWidth,
      height: height - margin - deviceFrameTop,
    );
    return StoreScreenshotLayout(
      canvasWidth: width,
      canvasHeight: height,
      captionBand: captionBand,
      deviceFrame: deviceFrame,
    );
  }

  /// Canvas width in pixels.
  final double canvasWidth;

  /// Canvas height in pixels.
  final double canvasHeight;

  /// Top band reserved for the marketing caption text.
  final LayoutBox captionBand;

  /// Region the framed device mock occupies below the caption band.
  final LayoutBox deviceFrame;
}
