import 'package:rectify/core/sharing/share_service.dart';

/// In-memory [ShareService] for widget and unit tests.
///
/// Records every [share] call in [shared] so tests can assert on
/// the text that would have been sent to the OS share sheet.
/// Set [returnsNative] to `false` to simulate the clipboard fallback
/// path and verify the SnackBar appears.
class FakeShareService implements ShareService {
  FakeShareService({this.returnsNative = true});

  /// Controls the return value of [share].
  bool returnsNative;

  /// Texts passed to [share], in call order.
  final List<String> shared = [];

  @override
  Future<bool> share(String text) async {
    shared.add(text);
    return returnsNative;
  }
}
