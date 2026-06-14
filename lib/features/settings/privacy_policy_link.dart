import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rectify/core/app_links.dart';
import 'package:rectify/core/privacy/privacy_policy_launcher.dart';

/// The configured hosted privacy-policy URL. Wraps the compile-time
/// [AppLinks.privacyPolicyUrl] (empty by default → the Settings row keeps
/// the bundled in-app screen) so tests can override it without mutating
/// the environment — same pattern as `versionCheckUrlProvider`.
final privacyPolicyUrlProvider = Provider<String>(
  (ref) => AppLinks.privacyPolicyUrl,
);

/// Opens the hosted privacy-policy page; overridden with a fake in widget
/// tests — same pattern as `storeLauncherProvider`.
final privacyPolicyLauncherProvider = Provider<PrivacyPolicyLauncher>(
  (ref) => const UrlLauncherPrivacyPolicyLauncher(),
);
