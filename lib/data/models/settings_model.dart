import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:rectify/data/models/time_format.dart';

part 'settings_model.freezed.dart';

/// Application-wide settings persisted in shared_preferences
/// (`docs/implementation-plan.md` §7.1).
///
/// Important: the Pro/Developer API key is **never** in this model.
/// It lives only in `flutter_secure_storage`; this flag reflects only
/// whether the user has configured a key (so the UI can show a "Set"
/// indicator without ever surfacing the key value).
@freezed
abstract class SettingsModel with _$SettingsModel {
  const factory SettingsModel({
    required bool demoModeDefault,
    required TimeFormat timeFormat,
    required bool onboardingDone,
    required bool proApiKeyConfigured,
  }) = _SettingsModel;

  factory SettingsModel.initial() => const SettingsModel(
    demoModeDefault: false,
    timeFormat: TimeFormat.h12,
    onboardingDone: false,
    proApiKeyConfigured: false,
  );
}
