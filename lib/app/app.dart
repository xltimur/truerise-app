import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rectify/app/router.dart';
import 'package:rectify/features/app_update/update_gate.dart';
import 'package:rectify/l10n/l10n.dart';
import 'package:rectify/l10n/locale_resolution.dart';
import 'package:rectify/theme/theme.dart';

class RectifyApp extends ConsumerWidget {
  const RectifyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: appBrandName,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      localeListResolutionCallback: resolveAppLocale,
      theme: buildLightTheme(),
      routerConfig: router,
      // App-level update surface: soft banner / forced-update gate from
      // the (default-disabled) owner-hosted version check. Sits above
      // the router so it is mounted exactly once for every route.
      builder: (context, child) =>
          UpdateGate(child: child ?? const SizedBox.shrink()),
    );
  }
}
