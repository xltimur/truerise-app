import 'package:rectify/core/update/store_launcher.dart';

/// In-memory [StoreLauncher] that records opened URLs instead of leaving
/// the app (mirrors `FakeShareService` / `FakeReviewService`).
class FakeStoreLauncher implements StoreLauncher {
  FakeStoreLauncher({this.returnsSuccess = true});

  /// Whether [open] reports success.
  bool returnsSuccess;

  /// Every URL passed to [open], in order.
  final List<String> opened = <String>[];

  @override
  Future<bool> open(String url) async {
    opened.add(url);
    return returnsSuccess;
  }
}
