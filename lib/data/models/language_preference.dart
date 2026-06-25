import 'package:flutter/widgets.dart' show Locale;

/// Interface-language preference held in user settings.
///
/// [auto] defers to the device locale via the existing `resolveAppLocale`
/// callback (deterministic English fallback); every other value pins
/// `MaterialApp`'s locale to that language. Modeled on `TimeFormat`: the
/// stable [tag] is the persisted identifier.
enum LanguagePreference {
  auto('auto'),
  english('en'),
  german('de'),
  spanish('es'),
  french('fr'),
  portuguese('pt'),
  ukrainian('uk');

  const LanguagePreference(this.tag);

  /// Stable storage identifier persisted in shared_preferences. For the
  /// five explicit languages this is also the locale's language code.
  final String tag;

  /// Explicit [Locale] to hand `MaterialApp`, or `null` for [auto]
  /// (device-driven resolution through `resolveAppLocale`).
  Locale? get locale => this == LanguagePreference.auto ? null : Locale(tag);

  static LanguagePreference fromTag(String tag) {
    for (final value in LanguagePreference.values) {
      if (value.tag == tag) return value;
    }
    return LanguagePreference.auto;
  }
}
