import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rectify/core/update/update_policy.dart';
import 'package:rectify/data/prefs/update_prompt_store.dart';
import 'package:rectify/features/app_update/update_controller.dart';
import 'package:rectify/features/app_update/update_gate.dart';
import 'package:rectify/l10n/app_localizations.dart';
import 'package:rectify/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/fake_store_launcher.dart';

/// Pins the app-level update UX:
///   * `none` → the app renders untouched;
///   * `soft` → a dismissible banner overlays the app; dismissal is
///     remembered per advertised version;
///   * `force` → a full-screen gate replaces the app with Update as the
///     only action;
///   * a failed store launch surfaces a SnackBar instead of trapping or
///     crashing.
void main() {
  const childKey = Key('app-under-gate');
  const store = 'https://apps.apple.com/app/id123456789';

  Future<(SharedPreferences, FakeStoreLauncher)> pumpGate(
    WidgetTester tester,
    UpdateDecision decision, {
    bool launcherSucceeds = true,
  }) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final prefs = await SharedPreferences.getInstance();
    final launcher = FakeStoreLauncher(returnsSuccess: launcherSucceeds);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appUpdateDecisionProvider.overrideWith((ref) async => decision),
          updatePromptStoreProvider.overrideWithValue(
            UpdatePromptStore(prefs),
          ),
          storeLauncherProvider.overrideWithValue(launcher),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: buildLightTheme(),
          home: const UpdateGate(
            child: Scaffold(
              key: childKey,
              body: Text('app content'),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return (prefs, launcher);
  }

  testWidgets('renders only the child when no update is advertised', (
    tester,
  ) async {
    await pumpGate(tester, const UpdateDecision.none());

    expect(find.byKey(childKey), findsOneWidget);
    expect(find.byKey(updateBannerKey), findsNothing);
    expect(find.byKey(updateForceGateKey), findsNothing);
  });

  testWidgets('soft decision overlays a banner without hiding the app', (
    tester,
  ) async {
    await pumpGate(
      tester,
      const UpdateDecision(
        urgency: UpdateUrgency.soft,
        storeUrl: store,
        promptTag: '2.0.0',
      ),
    );

    expect(find.byKey(childKey), findsOneWidget);
    expect(find.byKey(updateBannerKey), findsOneWidget);
    expect(find.text('Update available'), findsOneWidget);
    expect(find.text('Update'), findsOneWidget);
    expect(find.text('Not now'), findsOneWidget);
  });

  testWidgets('banner Update action opens the store URL', (tester) async {
    final (_, launcher) = await pumpGate(
      tester,
      const UpdateDecision(
        urgency: UpdateUrgency.soft,
        storeUrl: store,
        promptTag: '2.0.0',
      ),
    );

    await tester.tap(find.byKey(updateBannerActionKey));
    await tester.pumpAndSettle();

    expect(launcher.opened, <String>[store]);
  });

  testWidgets('banner dismissal hides it and records the prompt tag', (
    tester,
  ) async {
    final (prefs, _) = await pumpGate(
      tester,
      const UpdateDecision(
        urgency: UpdateUrgency.soft,
        storeUrl: store,
        promptTag: '2.0.0',
      ),
    );

    await tester.tap(find.byKey(updateBannerDismissKey));
    await tester.pumpAndSettle();

    expect(find.byKey(updateBannerKey), findsNothing);
    expect(find.byKey(childKey), findsOneWidget);
    expect(prefs.getString('update.dismissed_tag'), '2.0.0');
  });

  testWidgets('soft banner without a store URL is informational: '
      'no Update action, still dismissible', (tester) async {
    await pumpGate(
      tester,
      const UpdateDecision(
        urgency: UpdateUrgency.soft,
        promptTag: '2.0.0',
      ),
    );

    expect(find.byKey(updateBannerKey), findsOneWidget);
    expect(find.byKey(updateBannerActionKey), findsNothing);
    expect(find.byKey(updateBannerDismissKey), findsOneWidget);
  });

  testWidgets('banner shows the owner-supplied message over the default '
      'body', (tester) async {
    await pumpGate(
      tester,
      const UpdateDecision(
        urgency: UpdateUrgency.soft,
        storeUrl: store,
        message: 'Custom release note',
        promptTag: '2.0.0',
      ),
    );

    expect(find.text('Custom release note'), findsOneWidget);
    expect(
      find.textContaining('A new version of TrueRise'),
      findsNothing,
    );
  });

  testWidgets('force decision replaces the app with the gate', (
    tester,
  ) async {
    await pumpGate(
      tester,
      const UpdateDecision(
        urgency: UpdateUrgency.force,
        storeUrl: store,
        promptTag: '2.0.0',
      ),
    );

    expect(find.byKey(updateForceGateKey), findsOneWidget);
    expect(find.byKey(childKey), findsNothing);
    expect(find.text('Update required'), findsOneWidget);
    expect(find.text('Update'), findsOneWidget);
    // Not dismissible: no banner dismiss affordance anywhere.
    expect(find.text('Not now'), findsNothing);
    expect(find.byKey(updateBannerDismissKey), findsNothing);
  });

  testWidgets('force gate Update action opens the store URL', (
    tester,
  ) async {
    final (_, launcher) = await pumpGate(
      tester,
      const UpdateDecision(
        urgency: UpdateUrgency.force,
        storeUrl: store,
        promptTag: '2.0.0',
      ),
    );

    await tester.tap(find.byKey(updateForceActionKey));
    await tester.pumpAndSettle();

    expect(launcher.opened, <String>[store]);
  });

  testWidgets('a failed store launch surfaces the failure SnackBar', (
    tester,
  ) async {
    await pumpGate(
      tester,
      const UpdateDecision(
        urgency: UpdateUrgency.force,
        storeUrl: store,
        promptTag: '2.0.0',
      ),
      launcherSucceeds: false,
    );

    await tester.tap(find.byKey(updateForceActionKey));
    await tester.pumpAndSettle();

    expect(find.text("Couldn't open the store page."), findsOneWidget);
  });

  testWidgets('a failed update check leaves the app untouched', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appUpdateDecisionProvider.overrideWith(
            (ref) async => throw StateError('network down'),
          ),
          updatePromptStoreProvider.overrideWithValue(
            UpdatePromptStore(prefs),
          ),
          storeLauncherProvider.overrideWithValue(FakeStoreLauncher()),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: buildLightTheme(),
          home: const UpdateGate(
            child: Scaffold(key: childKey, body: Text('app content')),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(childKey), findsOneWidget);
    expect(find.byKey(updateBannerKey), findsNothing);
    expect(find.byKey(updateForceGateKey), findsNothing);
  });
}
