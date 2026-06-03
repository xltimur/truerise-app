import 'package:rectify/data/demo/demo_response.dart';
import 'package:rectify/l10n/app_localizations_en.dart';

/// English demo evidence copy for tests that drive `buildDemoResult` or
/// submit a demo request directly. Mirrors what the loading screen
/// resolves from `context.l10n` at runtime.
final DemoEvidenceCopy testDemoEvidenceCopy = DemoEvidenceCopy.fromL10n(
  AppLocalizationsEn(),
);
