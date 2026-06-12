import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rectify/providers/settings_controller.dart';

/// Thin facade that turns "the user finished or skipped onboarding"
/// into the `onboardingDone = true` persistence write.
///
/// Lives on top of [SettingsController] so the router gate sees the
/// change through the same provider it already listens to
/// (`docs/implementation-plan.md` §5.4).
class OnboardingController extends Notifier<void> {
  @override
  void build() {}

  /// Persist the chosen mode (`demoModeDefault = demoMode`), then
  /// `onboardingDone = true`. Every onboarding exit makes the mode
  /// explicit: "Try demo first" and Skip pass `true` (safe default
  /// while geocoding is stubbed), "Start real calculation" passes
  /// `false`. Idempotent — repeat calls just rewrite the same values.
  Future<void> complete({required bool demoMode}) async {
    final notifier = ref.read(settingsControllerProvider.notifier);
    await notifier.setDemoModeDefault(value: demoMode);
    if (!ref.read(settingsControllerProvider).onboardingDone) {
      await notifier.setOnboardingDone(value: true);
    }
  }
}

final onboardingControllerProvider =
    NotifierProvider<OnboardingController, void>(OnboardingController.new);
