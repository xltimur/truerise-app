import 'dart:typed_data';
import 'dart:ui';

import 'package:rectify/core/sharing/share_service.dart';

/// In-memory [ShareService] for widget and unit tests.
///
/// Records every [share] call in [shared] and every [shareImagePng]
/// call in [sharedImages] so tests can assert on the text and bytes
/// that would have been sent to the OS share sheet. Set [returnsNative]
/// to `false` to simulate the fallback path and verify the SnackBar
/// appears.
class FakeShareService implements ShareService {
  FakeShareService({this.returnsNative = true});

  /// Controls the return value of [share] and [shareImagePng].
  bool returnsNative;

  /// Texts passed to [share], in call order.
  final List<String> shared = [];

  /// Image shares passed to [shareImagePng], in call order.
  final List<({Uint8List bytes, String? text, Rect? sharePositionOrigin})>
  sharedImages = [];

  @override
  Future<bool> share(String text) async {
    shared.add(text);
    return returnsNative;
  }

  @override
  Future<bool> shareImagePng(
    Uint8List bytes, {
    String? text,
    Rect? sharePositionOrigin,
  }) async {
    sharedImages.add((
      bytes: bytes,
      text: text,
      sharePositionOrigin: sharePositionOrigin,
    ));
    return returnsNative;
  }
}
