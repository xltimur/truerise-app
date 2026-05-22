import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rectify/app/app.dart';
import 'package:rectify/app/route_names.dart';
import 'package:rectify/app/router.dart';
import 'package:rectify/core/sharing/share_service.dart';
import 'package:rectify/data/demo/demo_response.dart';
import 'package:rectify/data/models/birth_data.dart';
import 'package:rectify/data/models/calculation_request.dart';
import 'package:rectify/data/models/event_category.dart';
import 'package:rectify/data/models/life_event.dart';
import 'package:rectify/data/models/saved_calculation.dart';
import 'package:rectify/data/models/time_window.dart';
import 'package:rectify/data/repos/draft_repository.dart';
import 'package:rectify/data/secure/secure_key_store.dart';
import 'package:rectify/features/calculation_flow/screens/result_screen.dart';
import 'package:rectify/providers/core_providers.dart';
import 'package:rectify/providers/repo_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/fake_history_repository.dart';
import '../../../helpers/fake_rectification_repository.dart';
import '../../../helpers/fake_share_service.dart';

Future<SharedPreferences> _prefs() async {
  SharedPreferences.setMockInitialValues(<String, Object>{
    'settings.onboarding_done': true,
    'settings.demo_mode_default': true,
  });
  return SharedPreferences.getInstance();
}

ProviderScope _harness({
  required SharedPreferences prefs,
  required FakeHistoryRepository history,
  required FakeRectificationRepository rectifier,
  required InMemoryDraftRepository drafts,
  required FakeShareService shareService,
}) => ProviderScope(
  overrides: [
    sharedPreferencesProvider.overrideWithValue(prefs),
    secureKeyStoreProvider.overrideWithValue(InMemorySecureKeyStore()),
    historyRepositoryProvider.overrideWithValue(history),
    rectificationRepositoryProvider.overrideWithValue(rectifier),
    draftRepositoryProvider.overrideWithValue(drafts),
    shareServiceProvider.overrideWithValue(shareService),
  ],
  child: const RectifyApp(),
);

SavedCalculation _seedDemoCalculation({String id = 'share-demo-1'}) {
  final request = CalculationRequest(
    id: id,
    isDemo: true,
    birthData: BirthData(
      birthDate: DateTime.utc(1990, 5, 14),
      birthCity: 'Kyiv, Ukraine',
      birthLatitude: 0,
      birthLongitude: 0,
    ),
    timeWindow: TimeWindow.approximate(
      time: const TimeOfDay(hour: 7, minute: 0),
      windowMinutes: 120,
    ),
    events: <LifeEvent>[
      const LifeEvent(
        id: 'evt-1',
        category: EventCategory.marriage,
        year: 2018,
        month: 6,
        sortOrder: 0,
      ),
    ],
    createdAt: DateTime.utc(2026, 5, 22, 10),
    label: 'Share test calc',
  );
  final result = buildDemoResult(request, now: DateTime.utc(2026, 5, 22, 10));
  return SavedCalculation(request: request, result: result);
}

void main() {
  testWidgets(
    'Share result button is visible on the result screen',
    (tester) async {
      final seeded = _seedDemoCalculation();
      final prefs = await _prefs();
      final history = FakeHistoryRepository([seeded]);
      final rectifier = FakeRectificationRepository(history: history);
      final drafts = InMemoryDraftRepository();
      final shareService = FakeShareService();
      addTearDown(drafts.dispose);

      await tester.pumpWidget(
        _harness(
          prefs: prefs,
          history: history,
          rectifier: rectifier,
          drafts: drafts,
          shareService: shareService,
        ),
      );
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(MaterialApp)),
      );
      container
          .read(routerProvider)
          .go(RoutePaths.calcResultFor(seeded.request.id));
      await tester.pumpAndSettle();

      expect(find.byType(ResultScreen), findsOneWidget);
      expect(find.byKey(resultShareButtonKey), findsOneWidget);
      expect(find.text('Share result'), findsOneWidget);
    },
  );

  testWidgets(
    'tapping Share result calls the share service with non-empty text',
    (tester) async {
      final seeded = _seedDemoCalculation();
      final prefs = await _prefs();
      final history = FakeHistoryRepository([seeded]);
      final rectifier = FakeRectificationRepository(history: history);
      final drafts = InMemoryDraftRepository();
      final shareService = FakeShareService();
      addTearDown(drafts.dispose);

      await tester.pumpWidget(
        _harness(
          prefs: prefs,
          history: history,
          rectifier: rectifier,
          drafts: drafts,
          shareService: shareService,
        ),
      );
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(MaterialApp)),
      );
      container
          .read(routerProvider)
          .go(RoutePaths.calcResultFor(seeded.request.id));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byKey(resultShareButtonKey));
      await tester.tap(find.byKey(resultShareButtonKey));
      await tester.pumpAndSettle();

      expect(shareService.shared, hasLength(1));
      expect(shareService.shared.first, isNotEmpty);
    },
  );

  testWidgets(
    'share text does not contain birth city or birth date',
    (tester) async {
      final seeded = _seedDemoCalculation();
      final prefs = await _prefs();
      final history = FakeHistoryRepository([seeded]);
      final rectifier = FakeRectificationRepository(history: history);
      final drafts = InMemoryDraftRepository();
      final shareService = FakeShareService();
      addTearDown(drafts.dispose);

      await tester.pumpWidget(
        _harness(
          prefs: prefs,
          history: history,
          rectifier: rectifier,
          drafts: drafts,
          shareService: shareService,
        ),
      );
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(MaterialApp)),
      );
      container
          .read(routerProvider)
          .go(RoutePaths.calcResultFor(seeded.request.id));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byKey(resultShareButtonKey));
      await tester.tap(find.byKey(resultShareButtonKey));
      await tester.pumpAndSettle();

      final sharedText = shareService.shared.first;
      expect(sharedText, isNot(contains('Kyiv')));
      expect(sharedText, isNot(contains('Ukraine')));
      expect(sharedText, isNot(contains('1990')));
      expect(sharedText, isNot(contains('marriage')));
    },
  );

  testWidgets(
    'shows clipboard SnackBar when share service returns false (fallback)',
    (tester) async {
      final seeded = _seedDemoCalculation();
      final prefs = await _prefs();
      final history = FakeHistoryRepository([seeded]);
      final rectifier = FakeRectificationRepository(history: history);
      final drafts = InMemoryDraftRepository();
      // returnsNative: false → simulates clipboard fallback
      final shareService = FakeShareService(returnsNative: false);
      addTearDown(drafts.dispose);

      await tester.pumpWidget(
        _harness(
          prefs: prefs,
          history: history,
          rectifier: rectifier,
          drafts: drafts,
          shareService: shareService,
        ),
      );
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(MaterialApp)),
      );
      container
          .read(routerProvider)
          .go(RoutePaths.calcResultFor(seeded.request.id));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byKey(resultShareButtonKey));
      await tester.tap(find.byKey(resultShareButtonKey));
      await tester.pumpAndSettle();

      expect(find.text('Copied to clipboard'), findsOneWidget);
    },
  );

  testWidgets(
    'no SnackBar when share service returns true (native sheet used)',
    (tester) async {
      final seeded = _seedDemoCalculation();
      final prefs = await _prefs();
      final history = FakeHistoryRepository([seeded]);
      final rectifier = FakeRectificationRepository(history: history);
      final drafts = InMemoryDraftRepository();
      final shareService = FakeShareService(); // returnsNative: true by default
      addTearDown(drafts.dispose);

      await tester.pumpWidget(
        _harness(
          prefs: prefs,
          history: history,
          rectifier: rectifier,
          drafts: drafts,
          shareService: shareService,
        ),
      );
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(MaterialApp)),
      );
      container
          .read(routerProvider)
          .go(RoutePaths.calcResultFor(seeded.request.id));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byKey(resultShareButtonKey));
      await tester.tap(find.byKey(resultShareButtonKey));
      await tester.pumpAndSettle();

      expect(find.text('Copied to clipboard'), findsNothing);
    },
  );
}
