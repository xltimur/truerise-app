import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Abstraction over the OS share mechanism so widgets and tests are
/// decoupled from platform-channel details.
///
/// Returns `true` when the native share sheet was shown, `false` when
/// the clipboard fallback was used instead (channel not available or
/// threw). The result screen shows a SnackBar on `false`.
abstract interface class ShareService {
  Future<bool> share(String text);
}

/// Riverpod provider — overrideable in tests with a fake implementation.
final shareServiceProvider = Provider<ShareService>((ref) {
  return PlatformShareService();
});

/// Delegates to the `rectify/share` MethodChannel. Falls back to
/// writing the text to the system clipboard when the channel is
/// unavailable (e.g. unit-test host, web runner, older engine).
class PlatformShareService implements ShareService {
  static const _channel = MethodChannel('rectify/share');

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

  Future<void> _clipboardFallback(String text) =>
      Clipboard.setData(ClipboardData(text: text));
}
