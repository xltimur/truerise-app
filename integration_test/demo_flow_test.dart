// Phase 8 end-to-end demo coverage. The harness drives the full launch
// → onboarding → demo calc → result → evidence → history → settings
// loop against in-memory fakes (no HTTP, no Drift, no platform plugins
// beyond what `SharedPreferences.setMockInitialValues` covers), so the
// test is deterministic and survives `flutter test integration_test`.
//
// We intentionally use the integration_test binding rather than
// flutter_test alone — Phase 8 §AC-Demo-8 calls for a green
// `integration_test/demo_flow_test.dart` on both iOS and Android
// simulators, and the binding is required for `flutter test
// integration_test/...` to surface results to xcrun / `adb`.
//
// Widget interactions interleave controller writes with finder
// assertions; cascading across the boundary obscures intent.
// ignore_for_file: cascade_invocations

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rectify/app/app.dart';
import 'package:rectify/app/route_names.dart';
import 'package:rectify/app/router.dart';
import 'package:rectify/data/models/event_category.dart';
import 'package:rectify/data/repos/draft_repository.dart';
import 'package:rectify/data/secure/secure_key_store.dart';
import 'package:rectify/features/calculation_flow/state/calculation_flow_controller.dart';
import 'package:rectify/providers/core_providers.dart';
import 'package:rectify/providers/repo_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../test/helpers/fake_history_repository.dart';
import '../test/helpers/fake_rectification_repository.dart';

Future<SharedPreferences> _prefs({bool onboardingDone = false}) async {
  SharedPreferences.setMockInitialValues(<String, Object>{
    if (onboardingDone) 'settings.onboarding_done': true,
    'settings.demo_mode_default': true,
  });
  return SharedPreferences.getInstance();
}

Widget _wrap({
  required SharedPreferences prefs,
  required FakeHistoryRepository history,
  required FakeRectificationRepository rectifier,
  required InMemoryDraftRepository drafts,
}) => ProviderScope(
  overrides: [
    sharedPreferencesProvider.overrideWithValue(prefs),
    secureKeyStoreProvider.overrideWithValue(InMemorySecureKeyStore()),
    historyRepositoryProvider.overrideWithValue(history),
    rectificationRepositoryProvider.overrideWithValue(rectifier),
    draftRepositoryProvider.overrideWithValue(drafts),
  ],
  child: const RectifyApp(),
);

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'launch → onboarding skip → demo calc submit → result → evidence → '
    'history → settings, all offline',
    (tester) async {
      final prefs = await _prefs();
      final history = FakeHistoryRepository();
      final rectifier = FakeRectificationRepository(history: history);
      final drafts = InMemoryDraftRepository();
      addTearDown(drafts.dispose);

      await tester.pumpWidget(
        _wrap(
          prefs: prefs,
          history: history,
          rectifier: rectifier,
          drafts: drafts,
        ),
      );
      await tester.pumpAndSettle();

      // ── 1. Onboarding — first launch lands on the carousel and the
      //       Skip affordance shortcuts to Home with onboardingDone=true.
      expect(
        find.textContaining('Your birth chart depends on your exact'),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('onboarding-skip')),
        findsOneWidget,
      );
      await tester.tap(find.byKey(const ValueKey<String>('onboarding-skip')));
      await tester.pumpAndSettle();

      // After Skip the router redirects to Home / History.
      expect(find.text('Rectify'), findsOneWidget);
      expect(find.text('No calculations yet.'), findsOneWidget);

      final container = ProviderScope.containerOf(
        tester.element(find.byType(MaterialApp)),
      );

      // ── 2. Drive the demo calculation directly through the flow
      //       controller — the in-tree widget pickers (date / city /
      //       events sheet) all defer to native modals that aren't
      //       reachable in this binding, but the controller is the
      //       single owner of draft state so the assertions still
      //       prove the demo loop end to end.
      final calcController = container.read(
        calculationFlowControllerProvider.notifier,
      );
      calcController
        ..setBirthDate(DateTime.utc(1990, 5, 14))
        ..setBirthCityText('Kyiv, Ukraine')
        ..addEvent(category: EventCategory.marriage, year: 2018, month: 6)
        ..addEvent(category: EventCategory.careerChange, year: 2015, month: 9)
        ..addEvent(category: EventCategory.relocation, year: 2012, month: 3);

      final draftId = container.read(calculationFlowControllerProvider).id;

      // ── 3. Submit by navigating onto the loading screen. The
      //       in-tree loader kicks off `controller.submit()` on the
      //       post-frame callback; FakeRectificationRepository
      //       resolves immediately so the loader redirects to
      //       /calc/result/:id under pumpAndSettle.
      container.read(routerProvider).go(RoutePaths.calcLoading);
      await tester.pumpAndSettle();

      // FakeRectificationRepository records every submission — assert
      // the demo branch fired exactly once for our draft.
      expect(rectifier.submissions, hasLength(1));
      expect(rectifier.submissions.first.id, draftId);
      expect(rectifier.submissions.first.isDemo, isTrue);

      // ── 4. Result screen renders the demo hero + DEMO pill +
      //       evidence CTA.
      expect(find.text('Gemini Rising'), findsOneWidget);
      expect(find.text('78%'), findsOneWidget);
      expect(find.text('DEMO'), findsOneWidget);

      // ── 5. Evidence breakdown — tap the primary CTA and confirm
      //       the screen renders per-event match strengths.
      await tester.ensureVisible(find.text('See how we got this'));
      await tester.tap(find.text('See how we got this'));
      await tester.pumpAndSettle();

      final evidenceLocation = container
          .read(routerProvider)
          .routerDelegate
          .currentConfiguration
          .uri
          .toString();
      expect(evidenceLocation, '/calc/result/$draftId/evidence');

      // The demo evidence response always includes at least one
      // strong-match row (labels render in uppercase per the design
      // system §9.9).
      expect(find.text('STRONG'), findsWidgets);

      // ── 6. Back to history — the saved demo row is visible.
      container.read(routerProvider).go(RoutePaths.home);
      await tester.pumpAndSettle();
      expect(find.text('No calculations yet.'), findsNothing);
      expect(find.text('Past calculations'), findsOneWidget);
      expect(find.text('My calculation'), findsOneWidget);

      // ── 7. Settings reachable and renders the wipe affordance.
      container.read(routerProvider).go(RoutePaths.settings);
      await tester.pumpAndSettle();
      expect(find.text('Settings'), findsWidgets);
      expect(find.text('Delete all data'), findsOneWidget);

      // ── 8. No HTTP calls happened — FakeRectificationRepository
      //       short-circuits everything and we never instantiated a
      //       real Dio. (Sanity: the demo branch must not have built
      //       a real API submission either.)
      expect(
        rectifier.submissions.every((req) => req.isDemo),
        isTrue,
        reason: 'Demo flow must never produce a real (non-demo) submit.',
      );
    },
  );
}
