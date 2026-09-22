import 'package:flutter/widgets.dart';

import '../../l10n/app_localizations.dart';

export '../../l10n/app_localizations.dart';

/// Shorthand for the generated strings: `context.l10n.productsTitle`.
///
/// Every user-visible sentence in the app comes from here; the ARB files in
/// `lib/l10n/` are the only place copy is written.
extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
