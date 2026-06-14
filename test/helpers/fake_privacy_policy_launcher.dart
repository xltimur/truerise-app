import 'package:rectify/core/privacy/privacy_policy_launcher.dart';

/// In-memory [PrivacyPolicyLauncher] for widget tests.
///
/// Records every [open] call in [opened] so tests can assert on the URL
/// that would have been handed to the in-app browser view. Set
/// [returnsLaunched]
/// to `false` to simulate a launch failure and verify the in-app
/// fallback screen is pushed.
class FakePrivacyPolicyLauncher implements PrivacyPolicyLauncher {
  FakePrivacyPolicyLauncher({this.returnsLaunched = true});

  /// Controls the return value of [open].
  bool returnsLaunched;

  /// URLs passed to [open], in call order.
  final List<String> opened = [];

  @override
  Future<bool> open(String url) async {
    opened.add(url);
    return returnsLaunched;
  }
}
