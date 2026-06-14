/// In-memory renderer seam for the store screenshot compositing harness.
///
/// This file owns the actual pixel work that the pure path/geometry core in
/// `screenshot_compositor.dart` deliberately avoids: it decodes a raw captured
/// screenshot, paints a light store-listing background, overlays the marketing
/// caption, and draws the screenshot inside a simple rounded frame, returning
/// the composited PNG bytes. It performs no file IO and never creates the
/// `composited/` output directory; callers decide if/where bytes are written.
///
/// Geometry is reused from [StoreScreenshotLayout] / [LayoutBox] so the
/// caption band and device frame stay consistent with the (still pure) core.
/// The rendering technique mirrors `lib/core/sharing/story_card_renderer.dart`
/// (a `ui.PictureRecorder` + `Canvas`, then `ui.ImageByteFormat.png`).
library;

import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

import 'screenshot_compositor.dart';

/// Input for a single composited store screenshot.
///
/// Carries the raw captured screenshot [rawScreenshotPng], the marketing
/// [caption] to overlay, and an optional [layout]. When [layout] is null the
/// renderer falls back to [StoreScreenshotLayout.standard].
class StoreScreenshotCompositeInput {
  const StoreScreenshotCompositeInput({
    required this.rawScreenshotPng,
    required this.caption,
    this.layout,
  });

  /// Raw captured screenshot PNG bytes (e.g. an `NN-slug.png` source frame).
  final Uint8List rawScreenshotPng;

  /// Marketing caption painted inside [StoreScreenshotLayout.captionBand].
  final String caption;

  /// Optional layout override; [StoreScreenshotLayout.standard] when null.
  final StoreScreenshotLayout? layout;
}

/// Renders a [StoreScreenshotCompositeInput] to composited PNG bytes purely in
/// memory. No file system access happens here.
abstract final class StoreScreenshotCompositorRenderer {
  /// Light store-listing background gradient (top to bottom).
  static const Color _backgroundTop = Color(0xFFF7F8FA);
  static const Color _backgroundBottom = Color(0xFFE9ECF1);

  /// Caption ink: dark enough to read on the light background.
  static const Color _captionColor = Color(0xFF161A21);

  /// Device card surface and its thin border.
  static const Color _cardColor = Color(0xFFFFFFFF);
  static const Color _cardBorderColor = Color(0xFFD6DAE2);

  /// Composites [input] and returns the encoded PNG bytes.
  ///
  /// The output canvas is exactly [StoreScreenshotLayout.canvasWidth] x
  /// [StoreScreenshotLayout.canvasHeight] pixels.
  static Future<Uint8List> render(StoreScreenshotCompositeInput input) async {
    final layout = input.layout ?? StoreScreenshotLayout.standard();
    final rawImage = await _decodePng(input.rawScreenshotPng);
    try {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(
        recorder,
        Rect.fromLTWH(0, 0, layout.canvasWidth, layout.canvasHeight),
      );

      _paintBackground(canvas, layout);
      _paintCaption(canvas, input.caption, layout.captionBand);
      _paintFramedDevice(canvas, rawImage, layout.deviceFrame);

      final picture = recorder.endRecording();
      final image = await picture.toImage(
        layout.canvasWidth.round(),
        layout.canvasHeight.round(),
      );
      try {
        final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
        if (bytes == null) {
          throw StateError('Composited screenshot encoding returned no bytes.');
        }
        return bytes.buffer.asUint8List();
      } finally {
        image.dispose();
        picture.dispose();
      }
    } finally {
      rawImage.dispose();
    }
  }

  static Future<ui.Image> _decodePng(Uint8List bytes) async {
    final codec = await ui.instantiateImageCodec(bytes);
    try {
      final frame = await codec.getNextFrame();
      return frame.image;
    } finally {
      codec.dispose();
    }
  }

  static void _paintBackground(Canvas canvas, StoreScreenshotLayout layout) {
    final rect = Rect.fromLTWH(0, 0, layout.canvasWidth, layout.canvasHeight);
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[_backgroundTop, _backgroundBottom],
      ).createShader(rect);
    canvas.drawRect(rect, paint);
  }

  /// Paints [caption] centered (horizontally and vertically) inside [band].
  ///
  /// Capped at four lines and uses a non-negative letter spacing so the
  /// marketing copy never collapses or clips characters together.
  static void _paintCaption(Canvas canvas, String caption, LayoutBox band) {
    final tp = TextPainter(
      text: TextSpan(
        text: caption,
        style: const TextStyle(
          color: _captionColor,
          fontSize: 76,
          fontWeight: FontWeight.w700,
          height: 1.18,
          letterSpacing: 0,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
      maxLines: 4,
      ellipsis: '...',
    )..layout(maxWidth: band.width);

    final dx = band.left + (band.width - tp.width) / 2;
    final dy = band.top + (band.height - tp.height) / 2;
    tp.paint(canvas, Offset(dx, dy));
  }

  /// Draws [image] scaled (contain-fit, undistorted) inside a rounded white
  /// card occupying [frame].
  static void _paintFramedDevice(
    Canvas canvas,
    ui.Image image,
    LayoutBox frame,
  ) {
    final frameRect = Rect.fromLTWH(
      frame.left,
      frame.top,
      frame.width,
      frame.height,
    );
    final frameRRect = RRect.fromRectAndRadius(
      frameRect,
      const Radius.circular(56),
    );

    // White card behind the screenshot, then a thin border so it reads as a
    // frame on the light background.
    canvas
      ..drawRRect(frameRRect, Paint()..color = _cardColor)
      ..drawRRect(
        frameRRect,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4
          ..color = _cardBorderColor,
      );

    const innerPadding = 28.0;
    final innerRect = Rect.fromLTRB(
      frameRect.left + innerPadding,
      frameRect.top + innerPadding,
      frameRect.right - innerPadding,
      frameRect.bottom - innerPadding,
    );
    if (innerRect.width <= 0 || innerRect.height <= 0) {
      return;
    }

    final imageWidth = image.width.toDouble();
    final imageHeight = image.height.toDouble();
    // Contain-fit: preserve aspect ratio, fit fully inside the inner rect.
    final scale = math.min(
      innerRect.width / imageWidth,
      innerRect.height / imageHeight,
    );
    final drawWidth = imageWidth * scale;
    final drawHeight = imageHeight * scale;
    final dst = Rect.fromLTWH(
      innerRect.left + (innerRect.width - drawWidth) / 2,
      innerRect.top + (innerRect.height - drawHeight) / 2,
      drawWidth,
      drawHeight,
    );

    canvas
      ..save()
      ..clipRRect(RRect.fromRectAndRadius(dst, const Radius.circular(36)))
      ..drawImageRect(
        image,
        Rect.fromLTWH(0, 0, imageWidth, imageHeight),
        dst,
        Paint()..filterQuality = FilterQuality.high,
      )
      ..restore();
  }
}
