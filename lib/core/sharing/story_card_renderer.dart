import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

import 'package:rectify/theme/colors.dart';
import 'package:rectify/theme/typography.dart';

/// Privacy-safe content for the shareable story card.
///
/// Only the fields below ever reach the rendered PNG. Birth date, birth
/// city, coordinates, life events, request labels, API ids, and raw
/// response data are intentionally absent from this type so they cannot
/// leak into a shared image (mirrors `ShareCopyBuilder`).
class StoryCardData {
  const StoryCardData({
    required this.brand,
    required this.time,
    required this.confidenceLabel,
    required this.tagline,
    this.ascendant,
  });

  /// Product brand, e.g. `TrueRise`.
  final String brand;

  /// Pre-formatted top rectified time, e.g. `7:14 AM`.
  final String time;

  /// Pre-formatted, localized ascendant line, e.g. `Gemini Rising`, or
  /// `null` when the candidate has no ascendant.
  final String? ascendant;

  /// Pre-formatted confidence line, e.g. `78% confidence`.
  final String confidenceLabel;

  /// Short birth-time rectification tagline.
  final String tagline;
}

/// Renders [StoryCardData] to a fixed 1080×1920 PNG suitable for a
/// vertical "story" share. Uses a [ui.PictureRecorder] + [Canvas] so no
/// widget tree or off-screen render is required.
abstract final class StoryCardRenderer {
  /// Story-format canvas size (portrait 9:16).
  static const int width = 1080;
  static const int height = 1920;

  static const double _pad = 120;
  static double get _contentWidth => width - (_pad * 2);

  /// Produces the PNG bytes for [data]. Never includes any field absent
  /// from [StoryCardData].
  static Future<Uint8List> render(StoryCardData data) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
    );

    _paintBackground(canvas);
    _paintBrand(canvas, data.brand);
    _paintHeroBlock(canvas, data);
    _paintTagline(canvas, data.tagline);

    final picture = recorder.endRecording();
    final image = await picture.toImage(width, height);
    try {
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      if (bytes == null) {
        throw StateError('Story card encoding returned no bytes.');
      }
      return bytes.buffer.asUint8List();
    } finally {
      image.dispose();
      picture.dispose();
    }
  }

  static void _paintBackground(Canvas canvas) {
    const rect = Rect.fromLTWH(0, 0, width * 1.0, height * 1.0);
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[
          AppColors.deepMidnight,
          Color(0xFF12161D),
        ],
      ).createShader(rect);
    canvas.drawRect(rect, paint);
  }

  static void _paintBrand(Canvas canvas, String brand) {
    final tp = _painter(
      brand,
      AppTypography.displayMd.copyWith(
        color: AppColors.deepInkOnMidnight,
        fontSize: 52,
        letterSpacing: 1,
      ),
    );
    _paintCentered(canvas, tp, 232);

    // Clay accent rule under the brand.
    const ruleWidth = 132.0;
    const ruleY = 332.0;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH((width - ruleWidth) / 2, ruleY, ruleWidth, 4),
        const Radius.circular(2),
      ),
      Paint()..color = AppColors.accentClay,
    );
  }

  /// Vertically-centered group: time → (ascendant) → confidence.
  static void _paintHeroBlock(Canvas canvas, StoryCardData data) {
    const ascendantGap = 40.0;
    const confidenceGap = 28.0;

    final timeTp = _painter(
      data.time,
      AppTypography.displayXl.copyWith(
        color: AppColors.deepInkOnMidnight,
        fontSize: 156,
        letterSpacing: 0,
      ),
    );
    final ascendantTp = data.ascendant == null
        ? null
        : _painter(
            data.ascendant!,
            AppTypography.titleLg.copyWith(
              color: AppColors.accentClayTint,
              fontSize: 50,
            ),
          );
    final confidenceTp = _painter(
      data.confidenceLabel,
      AppTypography.titleMd.copyWith(
        color: AppColors.deepMidnightTint,
        fontSize: 42,
      ),
    );

    var groupHeight = timeTp.height + confidenceGap + confidenceTp.height;
    if (ascendantTp != null) {
      groupHeight += ascendantGap + ascendantTp.height;
    }

    var y = (height - groupHeight) / 2;
    _paintCentered(canvas, timeTp, y);
    y += timeTp.height;
    if (ascendantTp != null) {
      y += ascendantGap;
      _paintCentered(canvas, ascendantTp, y);
      y += ascendantTp.height;
    }
    y += confidenceGap;
    _paintCentered(canvas, confidenceTp, y);
  }

  static void _paintTagline(Canvas canvas, String tagline) {
    final tp = _painter(
      tagline,
      AppTypography.bodyLg.copyWith(
        color: AppColors.deepMidnightTint,
        fontSize: 36,
        height: 1.3,
      ),
    );
    _paintCentered(canvas, tp, height - 200 - tp.height);
  }

  static TextPainter _painter(
    String text,
    TextStyle style, {
    TextAlign align = TextAlign.center,
  }) {
    return TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      textAlign: align,
      maxLines: 3,
    )..layout(maxWidth: _contentWidth);
  }

  static void _paintCentered(Canvas canvas, TextPainter tp, double topY) {
    tp.paint(canvas, Offset((width - tp.width) / 2, topY));
  }
}
