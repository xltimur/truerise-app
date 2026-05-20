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

  /// Persist `onboardingDone = true`. Idempotent — calling more than
  /// once is safe (no-op once the flag is already set).
  Future<void> complete() async {
    final settings = ref.read(settingsControllerProvider);
    if (settings.onboardingDone) {
      return;
    }
    await ref
        .read(settingsControllerProvider.notifier)
        .setOnboardingDone(value: true);
  }
}

final onboardingControllerProvider =
    NotifierProvider<OnboardingController, void>(OnboardingController.new);
