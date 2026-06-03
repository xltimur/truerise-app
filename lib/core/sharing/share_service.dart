import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Abstraction over the OS share mechanism so widgets and tests are
/// decoupled from platform-channel details.
///
/// [share] sends privacy-safe text. [shareImagePng] sends a rendered
/// PNG story card (see `StoryCardRenderer`) optionally accompanied by
/// the same privacy-safe caption.
///
/// Both return `true` when the native share sheet was shown, `false`
/// when a fallback was used or the sheet could not be presented. The
/// result screen surfaces a SnackBar on `false`.
abstract interface class ShareService {
  Future<bool> share(String text);

  /// Shares [bytes] as a `image/png` attachment with an optional [text]
  /// caption. Returns `false` when the native share sheet could not be
  /// presented (e.g. plugin missing on a unit-test host).
  Future<bool> shareImagePng(Uint8List bytes, {String? text});
}

/// Riverpod provider — overrideable in tests with a fake implementation.
final shareServiceProvider = Provider<ShareService>((ref) {
  return PlatformShareService();
});

/// Delegates text shares to the `rectify/share` MethodChannel (falling
/// back to the system clipboard when unavailable) and image shares to
/// `share_plus`.
class PlatformShareService implements ShareService {
  static const _channel = MethodChannel('rectify/share');
  static const _imageFileName = 'truerise-result.png';

  @override
  Future<bool> share(String text) async {
    try {
      await _channel.invokeMethod<void>('share', text);
      return true;
    } on MissingPluginException {
      await _clipboardFallback(text);
      return false;
    } on PlatformException {
      await _clipboardFallback(text);
      return false;
    }
  }

  @override
  Future<bool> shareImagePng(Uint8List bytes, {String? text}) async {
    try {
      final dir = await getTemporaryDirectory();
      final file = await File(
        '${dir.path}/$_imageFileName',
      ).writeAsBytes(bytes, flush: true);
      final result = await SharePlus.instance.share(
        ShareParams(
          files: <XFile>[XFile(file.path, mimeType: 'image/png')],
          text: text,
        ),
      );
      return result.status != ShareResultStatus.unavailable;
    } on MissingPluginException {
      return false;
    } on PlatformException {
      return false;
    }
  }

  Future<void> _clipboardFallback(String text) =>
      Clipboard.setData(ClipboardData(text: text));
}
