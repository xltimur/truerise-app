import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';

import 'screenshot_compositor.dart';
import 'store_screenshot_compositor_renderer.dart';

/// PNG file signature (first four bytes).
const List<int> _pngMagic = <int>[0x89, 0x50, 0x4E, 0x47];

/// The `composited/` output directory the harness must never create.
const String _enCompositedDir = '$kStoreScreenshotsRoot/en/$kCompositedDirName';

const String _resultHeroFile = '01-result-hero.png';

File _rawHeroFile() => File(rawScreenshotPath('en', _resultHeroFile));

/// Reads the `intendedCaption` for [file] from the en manifest.
String _intendedCaption(String file) {
  final manifest =
      jsonDecode(
            File('$kStoreScreenshotsRoot/en/manifest.json').readAsStringSync(),
          )
          as Map<String, dynamic>;
  final frames = (manifest['frames'] as List).cast<Map<String, dynamic>>();
  final frame = frames.firstWhere((f) => f['file'] == file);
  return frame['intendedCaption'] as String;
}

Future<ui.Image> _decodePng(Uint8List bytes) async {
  final codec = await ui.instantiateImageCodec(bytes);
  try {
    final frame = await codec.getNextFrame();
    return frame.image;
  } finally {
    codec.dispose();
  }
}

/// Builds a synthetic solid-colour PNG of [width] x [height] entirely in
/// memory, so the renderer can be exercised without reading or writing any
/// repository screenshot asset.
Future<Uint8List> _syntheticPng(int width, int height) async {
  final recorder = ui.PictureRecorder();
  final rect = ui.Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble());
  ui.Canvas(recorder, rect).drawRect(
    rect,
    ui.Paint()..color = const ui.Color(0xFF3355AA),
  );
  final picture = recorder.endRecording();
  final image = await picture.toImage(width, height);
  try {
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    if (data == null) {
      throw StateError('Synthetic PNG encoding returned no bytes.');
    }
    return data.buffer.asUint8List();
  } finally {
    image.dispose();
    picture.dispose();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('composites the result-hero frame into a same-size store PNG', () async {
    final rawBytes = await _rawHeroFile().readAsBytes();
    final caption = _intendedCaption(_resultHeroFile);

    // The composited output directory must not exist before rendering.
    expect(Directory(_enCompositedDir).existsSync(), isFalse);

    final output = await StoreScreenshotCompositorRenderer.render(
      StoreScreenshotCompositeInput(
        rawScreenshotPng: rawBytes,
        caption: caption,
      ),
    );

    expect(output, isNotEmpty);
    expect(output.sublist(0, 4), _pngMagic);
    expect(output, isNot(equals(rawBytes)));

    final decoded = await _decodePng(output);
    try {
      expect(decoded.width, kRawScreenshotWidth);
      expect(decoded.height, kRawScreenshotHeight);
    } finally {
      decoded.dispose();
    }

    // Rendering is purely in memory: still no composited directory after.
    expect(Directory(_enCompositedDir).existsSync(), isFalse);
  });

  test('renders a valid same-size PNG for a very long caption', () async {
    final rawBytes = await _rawHeroFile().readAsBytes();
    final longCaption = List<String>.filled(
      80,
      'Find your real birth time with an honest confidence score',
    ).join(' ');

    final output = await StoreScreenshotCompositorRenderer.render(
      StoreScreenshotCompositeInput(
        rawScreenshotPng: rawBytes,
        caption: longCaption,
      ),
    );

    expect(output, isNotEmpty);
    expect(output.sublist(0, 4), _pngMagic);

    final decoded = await _decodePng(output);
    try {
      expect(decoded.width, kRawScreenshotWidth);
      expect(decoded.height, kRawScreenshotHeight);
    } finally {
      decoded.dispose();
    }

    // A long caption must not have triggered any file/directory creation.
    expect(Directory(_enCompositedDir).existsSync(), isFalse);
  });

  test('renders a non-default Google Play profile at its exact size', () async {
    final profile = storeScreenshotOutputProfiles.firstWhere(
      (p) => p.id == 'google-play-phone',
    );
    final layout = StoreScreenshotLayout.forProfile(profile);
    // A synthetic source frame, intentionally a different size than any output
    // profile, to prove the output size follows the layout, not the input.
    final rawBytes = await _syntheticPng(900, 1600);

    final output = await StoreScreenshotCompositorRenderer.render(
      StoreScreenshotCompositeInput(
        rawScreenshotPng: rawBytes,
        caption: 'Find your real birth time',
        layout: layout,
      ),
    );

    expect(output, isNotEmpty);
    expect(output.sublist(0, 4), _pngMagic);

    final decoded = await _decodePng(output);
    try {
      expect(decoded.width, profile.width);
      expect(decoded.height, profile.height);
      expect(decoded.width, 1080);
      expect(decoded.height, 1920);
    } finally {
      decoded.dispose();
    }

    // Rendering a non-default profile is still purely in memory.
    expect(Directory(_enCompositedDir).existsSync(), isFalse);
  });

  test('no composited output directory exists under any store locale', () {
    for (final locale in supportedStoreLocales) {
      final dir = Directory(
        '$kStoreScreenshotsRoot/$locale/$kCompositedDirName',
      );
      expect(dir.existsSync(), isFalse, reason: locale);
    }

    // Defensive sweep: no directory literally named `composited` exists
    // anywhere beneath the store screenshots root.
    final root = Directory(kStoreScreenshotsRoot);
    if (root.existsSync()) {
      final composited = root
          .listSync(recursive: true)
          .whereType<Directory>()
          .where(
            (d) =>
                d.path.split(Platform.pathSeparator).last == kCompositedDirName,
          )
          .map((d) => d.path)
          .toList();
      expect(composited, isEmpty, reason: composited.join(', '));
    }
  });
}
