import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';
import 'package:rectify/core/sharing/story_card_renderer.dart';

StoryCardData _sampleCard({String? ascendant = 'Gemini Rising'}) =>
    StoryCardData(
      brand: 'TrueRise',
      time: '7:14 AM',
      ascendant: ascendant,
      confidenceLabel: '78% confidence',
      tagline: 'Birth-time rectification',
    );

Future<({int width, int height})> _decodeSize(Uint8List bytes) async {
  final codec = await ui.instantiateImageCodec(bytes);
  final frame = await codec.getNextFrame();
  final image = frame.image;
  final size = (width: image.width, height: image.height);
  image.dispose();
  return size;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('StoryCardRenderer.render', () {
    test('produces non-empty PNG bytes', () async {
      final bytes = await StoryCardRenderer.render(_sampleCard());
      expect(bytes, isNotEmpty);
      // PNG magic number.
      expect(bytes.sublist(0, 4), <int>[0x89, 0x50, 0x4E, 0x47]);
    });

    test('renders at exactly 1080x1920', () async {
      final bytes = await StoryCardRenderer.render(_sampleCard());
      final size = await _decodeSize(bytes);
      expect(size.width, StoryCardRenderer.width);
      expect(size.height, StoryCardRenderer.height);
      expect(size.width, 1080);
      expect(size.height, 1920);
    });

    test('renders without an ascendant line', () async {
      final bytes = await StoryCardRenderer.render(
        _sampleCard(ascendant: null),
      );
      final size = await _decodeSize(bytes);
      expect(bytes, isNotEmpty);
      expect(size.width, 1080);
      expect(size.height, 1920);
    });
  });
}
