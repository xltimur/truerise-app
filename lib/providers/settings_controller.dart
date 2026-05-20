// `SettingsRepository` is named in the doc-comments below as the
// canonical writer surface; the analyzer can't see the symbol without
// an import we don't otherwise need at this layer.
// ignore_for_file: comment_references

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rectify/core/failures.dart';
import 'package:rectify/core/result.dart';
import 'package:rectify/data/models/settings_model.dart';
import 'package:rectify/data/models/time_format.dart';
import 'package:rectify/providers/core_providers.dart';
import 'package:rectify/providers/repo_providers.dart';

/// Reactive cache of [SettingsModel] for screen-level consumers
/// (`docs/implementation-plan.md` §4.4).
///
/// The Riverpod state is the single source of truth at runtime; the
/// underlying `SettingsStore` still owns persistence. Writers
/// (`setOnboardingDone`, `setTimeFormat`, …) go through
/// `SettingsRepository` so secure storage and Drift stay in sync, then
/// mirror the change into [state] so the router and listening widgets
/// refresh without re-reading prefs.
class SettingsController extends Notifier<SettingsModel> {
  @override
  SettingsModel build() {
    return ref.watch(settingsStoreProvider).readSync();
  }

  Future<void> setOnboardingDone({required bool value}) async {
    await ref.read(settingsRepositoryProvider).setOnboardingDone(value: value);
    state = state.copyWith(onboardingDone: value);
  }

  Future<void> setDemoModeDefault({required bool value}) async {
    await ref.read(settingsRepositoryProvider).setDemoModeDefault(value: value);
    state = state.copyWith(demoModeDefault: value);
  }

  Future<void> setTimeFormat(TimeFormat value) async {
    await ref.read(settingsRepositoryProvider).setTimeFormat(value);
    state = state.copyWith(timeFormat: value);
  }

  /// Persist the user-supplied Pro / Developer API key via
  /// [SettingsRepository] (writes to secure storage only) and flip the
  /// visible "configured" flag (`docs/implementation-plan.md` §9.5).
  ///
  /// The raw key is **never** mirrored into [state] — only the boolean
  /// flag is. [proApiKeyProvider] is invalidated so [dioProvider]
  /// rebuilds onto the provider-direct path on the next read.
  Future<void> setProApiKey(String key) async {
    await ref.read(settingsRepositoryProvider).setProApiKey(key);
    state = state.copyWith(proApiKeyConfigured: true);
    ref.invalidate(proApiKeyProvider);
  }

  /// Drop the stored Pro / Developer key and reset the visible flag,
  /// returning the Dio stack to the proxy path on the next rebuild.
  Future<void> clearProApiKey() async {
    await ref.read(settingsRepositoryProvider).clearProApiKey();
    state = state.copyWith(proApiKeyConfigured: false);
    ref.invalidate(proApiKeyProvider);
  }

  /// Wipe Drift + shared_preferences + secure storage
  /// (`docs/implementation-plan.md` §8.5). On success the in-memory
  /// state collapses back to [SettingsModel.initial], which flips
  /// `onboardingDone` to `false` and re-triggers the router redirect
  /// to `/onboarding`. The in-flight draft is dropped too so the
  /// calculation flow restarts empty.
  Future<Result<void, AppFailure>> deleteAllData() async {
    final outcome = await ref.read(settingsRepositoryProvider).deleteAllData();
    if (outcome.isOk) {
      state = SettingsModel.initial();
      ref
        ..invalidate(proApiKeyProvider)
        ..invalidate(draftRepositoryProvider);
    }
    return outcome;
  }
}

final settingsControllerProvider =
    NotifierProvider<SettingsController, SettingsModel>(
      SettingsController.new,
    );
