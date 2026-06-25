import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rectify/core/update/update_policy.dart';
import 'package:rectify/features/app_update/update_controller.dart';
import 'package:rectify/features/app_update/update_gate.dart';
import 'package:rectify/l10n/app_localizations.dart';
import 'package:rectify/theme/theme.dart';

import '../../../helpers/fake_store_launcher.dart';

/// Pins the app-level update UX:
///   * `none` → the app renders untouched;
///   * `soft` / `force` → a blocking modal overlays the app with Update as
///     the only action;
///   * a failed store launch surfaces a SnackBar instead of trapping or
///     crashing.
void main() {
  const childKey = Key('app-under-gate');
  const store = 'https://apps.apple.com/app/id123456789';

  Future<FakeStoreLauncher> pumpGate(
    WidgetTester tester,
    UpdateDecision decision, {
    bool launcherSucceeds = true,
  }) async {
    final launcher = FakeStoreLauncher(returnsSuccess: launcherSucceeds);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appUpdateDecisionProvider.overrideWith((ref) async => decision),
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
    return launcher;
  }

  testWidgets('renders only the child when no update is advertised', (
    tester,
  ) async {
    await pumpGate(tester, const UpdateDecision.none());

    expect(find.byKey(childKey), findsOneWidget);
    expect(find.byKey(updateModalKey), findsNothing);
  });

  testWidgets(
    'soft decision overlays a blocking modal without hiding the app',
    (
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
      expect(find.byKey(updateModalKey), findsOneWidget);
      expect(find.text('Update required'), findsOneWidget);
      expect(find.text('Update'), findsOneWidget);
      expect(find.text('Not now'), findsNothing);
      expect(find.byIcon(Icons.close), findsNothing);
    },
  );

  testWidgets('modal Update action opens the store URL', (tester) async {
    final launcher = await pumpGate(
      tester,
      const UpdateDecision(
        urgency: UpdateUrgency.soft,
        storeUrl: store,
        promptTag: '2.0.0',
      ),
    );

    await tester.tap(find.byKey(updateModalActionKey));
    await tester.pumpAndSettle();

    expect(launcher.opened, <String>[store]);
  });

  testWidgets('soft modal has no dismiss action', (
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
    expect(find.byKey(updateModalKey), findsOneWidget);
    expect(find.text('Not now'), findsNothing);
    expect(find.byIcon(Icons.close), findsNothing);
  });

  testWidgets('soft decision without a store URL leaves the app untouched', (
    tester,
  ) async {
    await pumpGate(
      tester,
      const UpdateDecision(
        urgency: UpdateUrgency.soft,
        promptTag: '2.0.0',
      ),
    );

    expect(find.byKey(childKey), findsOneWidget);
    expect(find.byKey(updateModalKey), findsNothing);
  });

  testWidgets('modal body comes from app localization, not hard-coded copy', (
    tester,
  ) async {
    await pumpGate(
      tester,
      const UpdateDecision(
        urgency: UpdateUrgency.soft,
        storeUrl: store,
        message: 'Custom release note',
        promptTag: '2.0.0',
      ),
    );

    expect(find.text('Custom release note'), findsNothing);
    expect(find.textContaining('This version of TrueRise'), findsOneWidget);
  });

  testWidgets('force decision uses the same blocking modal', (
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

    expect(find.byKey(updateModalKey), findsOneWidget);
    expect(find.byKey(childKey), findsOneWidget);
    expect(find.text('Update required'), findsOneWidget);
    expect(find.text('Update'), findsOneWidget);
    expect(find.text('Not now'), findsNothing);
    expect(find.byIcon(Icons.close), findsNothing);
  });

  testWidgets('force modal Update action opens the store URL', (
    tester,
  ) async {
    final launcher = await pumpGate(
      tester,
      const UpdateDecision(
        urgency: UpdateUrgency.force,
        storeUrl: store,
        promptTag: '2.0.0',
      ),
    );

    await tester.tap(find.byKey(updateModalActionKey));
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

    await tester.tap(find.byKey(updateModalActionKey));
    await tester.pumpAndSettle();

    expect(find.text("Couldn't open the store page."), findsOneWidget);
  });

  testWidgets('a failed update check leaves the app untouched', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appUpdateDecisionProvider.overrideWith(
            (ref) async => throw StateError('network down'),
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
    expect(find.byKey(updateModalKey), findsNothing);
  });
}
