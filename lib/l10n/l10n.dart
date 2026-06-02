import 'package:flutter/widgets.dart';

import 'package:rectify/l10n/app_localizations.dart';

export 'package:rectify/l10n/app_localizations.dart';

/// The product brand. A proper noun held constant across every locale and fed
/// into localized sentences as the `{brand}` placeholder so translators cannot
/// alter it. Deliberately kept out of the ARB as a translatable value
/// (see `docs/l10n-strategy.md` §4 rule 1).
const String appBrandName = 'TrueRise';

/// Terse accessor for the generated [AppLocalizations] bundle.
///
/// `context.l10n.someKey` reads more cleanly at call sites than
/// `AppLocalizations.of(context).someKey`.
extension L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
