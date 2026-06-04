import 'package:flutter/widgets.dart';

/// Resolves the app locale from [deviceLocales] against [supportedLocales].
///
/// Matches on language code only so region-tagged device locales (e.g. de-AT)
/// resolve to the canonical supported entry (de). Falls back to English when
/// no device language matches any supported language — Flutter's default
/// behaviour without an explicit callback would pick the first supported locale
/// (de), which is wrong for Japanese-only or other unsupported devices.
Locale resolveAppLocale(
  List<Locale>? deviceLocales,
  Iterable<Locale> supportedLocales,
) {
  if (deviceLocales == null || deviceLocales.isEmpty) {
    return const Locale('en');
  }

  final supportedCodes = {
    for (final l in supportedLocales) l.languageCode: l,
  };

  for (final device in deviceLocales) {
    final match = supportedCodes[device.languageCode];
    if (match != null) return match;
  }

  return const Locale('en');
}
