import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rectify/core/app_links.dart';
import 'package:rectify/core/update/app_version.dart';
import 'package:rectify/core/update/store_launcher.dart';
import 'package:rectify/core/update/update_info_fetcher.dart';
import 'package:rectify/core/update/update_policy.dart';
import 'package:rectify/data/prefs/update_prompt_store.dart';
import 'package:rectify/providers/core_providers.dart';
import 'package:rectify/providers/settings_controller.dart';

/// The configured version-check endpoint. Wraps the compile-time
/// [AppLinks.versionCheckUrl] (empty by default → check disabled) so
/// tests can override it without mutating the environment.
final versionCheckUrlProvider = Provider<String>(
  (ref) => AppLinks.versionCheckUrl,
);

/// Bare HTTP client for the public version JSON — intentionally not the
/// authenticated rectification Dio stack.
final updateInfoFetcherProvider = Provider<UpdateInfoFetcher>((ref) {
  final fetcher = UpdateInfoFetcher();
  ref.onDispose(fetcher.close);
  return fetcher;
});

/// Persists the per-version soft-prompt dismissal.
final updatePromptStoreProvider = Provider<UpdatePromptStore>(
  (ref) => UpdatePromptStore(ref.watch(sharedPreferencesProvider)),
);

/// Opens the public store page; overridden with a fake in widget tests.
final storeLauncherProvider = Provider<StoreLauncher>(
  (ref) => const UrlLauncherStoreLauncher(),
);

/// The installed version, read once from the platform package info
/// (`1.0.0+1`-style). `null` if the platform reports something
/// unparseable — the update check then stays silent.
final currentAppVersionProvider = FutureProvider<AppVersion?>((ref) async {
  final info = await ref.watch(packageInfoProvider.future);
  return AppVersion.tryParse('${info.version}+${info.buildNumber}');
});

/// Resolves one update check into an [UpdateDecision] for the
/// `UpdateGate` widget (`lib/features/app_update/update_gate.dart`).
///
/// The check is structurally privacy-safe and fail-silent:
///   * **Disabled by default** — it runs only when the owner supplies
///     `--dart-define=TRUERISE_VERSION_CHECK_URL=...` and the value passes
///     the bare-HTTPS validator; no fake or unowned endpoint is ever hit.
///   * **Demo boundary** — per-run demo mode (`isDemo` on a calculation)
///     lives inside the calculation flow and is not global app state at
///     startup; the globally readable signal is the Settings "Demo mode"
///     default. When that default is ON the check is skipped entirely, so
///     a demo-defaulted (e.g. reviewer) build performs no update-check
///     network call. Demo calculations themselves never touch this path.
///   * **Fail-silent** — network/parse failures collapse to
///     [UpdateDecision.none]; the app never blocks on the probe.
final appUpdateDecisionProvider = FutureProvider<UpdateDecision>((ref) async {
  final url = ref.watch(versionCheckUrlProvider);
  if (!AppLinks.isPrivacySafeShareUrl(url)) {
    return const UpdateDecision.none();
  }

  final demoDefault = ref.watch(
    settingsControllerProvider.select((s) => s.demoModeDefault),
  );
  if (demoDefault) return const UpdateDecision.none();

  final promptStore = ref.watch(updatePromptStoreProvider);
  final fetcher = ref.watch(updateInfoFetcherProvider);

  final current = await ref.watch(currentAppVersionProvider.future);
  if (current == null) return const UpdateDecision.none();

  final info = await fetcher.fetch(url);
  if (info == null) return const UpdateDecision.none();

  final platform = defaultTargetPlatform;
  return UpdatePolicy.decide(
    current: current,
    info: info,
    storeUrl: info.storeUrlFor(platform),
    dismissedTag: promptStore.dismissedTag(),
    message: info.messageFor(platform),
  );
});
