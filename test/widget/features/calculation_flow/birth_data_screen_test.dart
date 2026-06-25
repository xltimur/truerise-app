// Widget tests interleave controller writes with widget assertions;
// cascading across the boundary obscures intent.
// ignore_for_file: cascade_invocations
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rectify/app/app.dart';
import 'package:rectify/data/models/geo_place.dart';
import 'package:rectify/data/repos/draft_repository.dart';
import 'package:rectify/data/secure/secure_key_store.dart';
import 'package:rectify/features/calculation_flow/geocoding/geocoding_service.dart';
import 'package:rectify/features/calculation_flow/screens/birth_data_screen.dart';
import 'package:rectify/features/calculation_flow/state/calculation_flow_controller.dart';
import 'package:rectify/providers/core_providers.dart';
import 'package:rectify/providers/repo_providers.dart';
import 'package:rectify/widgets/chips/demo_pill.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/fake_history_repository.dart';
import '../../../helpers/fake_rectification_repository.dart';

Future<SharedPreferences> _prefs({bool demo = true}) async {
  SharedPreferences.setMockInitialValues(<String, Object>{
    'settings.onboarding_done': true,
    'settings.demo_mode_default': demo,
  });
  return SharedPreferences.getInstance();
}

ProviderScope _harness({
  required SharedPreferences prefs,
  required FakeHistoryRepository history,
  required FakeRectificationRepository rectifier,
  required InMemoryDraftRepository drafts,
  GeocodingService? geocoder,
}) => ProviderScope(
  overrides: [
    sharedPreferencesProvider.overrideWithValue(prefs),
    secureKeyStoreProvider.overrideWithValue(InMemorySecureKeyStore()),
    historyRepositoryProvider.overrideWithValue(history),
    rectificationRepositoryProvider.overrideWithValue(rectifier),
    draftRepositoryProvider.overrideWithValue(drafts),
    if (geocoder != null) geocodingServiceProvider.overrideWithValue(geocoder),
  ],
  child: const RectifyApp(),
);

class _FakeGeocodingService implements GeocodingService {
  _FakeGeocodingService(this.results);

  final List<GeoPlace> results;
  final List<String> queries = <String>[];

  @override
  Future<List<GeoPlace>> search(String query) async {
    queries.add(query);
    return results;
  }
}

void main() {
  testWidgets('shows DemoPill on the birth step when demo mode is on', (
    tester,
  ) async {
    final prefs = await _prefs();
    final history = FakeHistoryRepository();
    final rectifier = FakeRectificationRepository(history: history);
    final drafts = InMemoryDraftRepository();
    addTearDown(drafts.dispose);

    await tester.pumpWidget(
      _harness(
        prefs: prefs,
        history: history,
        rectifier: rectifier,
        drafts: drafts,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('New Calculation'));
    await tester.pumpAndSettle();

    expect(find.byType(BirthDataScreen), findsOneWidget);
    expect(find.byType(DemoPill), findsOneWidget);
    expect(find.text('DEMO'), findsOneWidget);
  });

  testWidgets('hides DemoPill on the birth step when demo mode is off', (
    tester,
  ) async {
    final prefs = await _prefs(demo: false);
    final history = FakeHistoryRepository();
    final rectifier = FakeRectificationRepository(history: history);
    final drafts = InMemoryDraftRepository();
    addTearDown(drafts.dispose);

    await tester.pumpWidget(
      _harness(
        prefs: prefs,
        history: history,
        rectifier: rectifier,
        drafts: drafts,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('New Calculation'));
    await tester.pumpAndSettle();

    expect(find.byType(BirthDataScreen), findsOneWidget);
    expect(find.byType(DemoPill), findsNothing);
    expect(find.text('DEMO'), findsNothing);
  });

  testWidgets(
    'Continue is disabled until a date and city are entered',
    (tester) async {
      final prefs = await _prefs();
      final history = FakeHistoryRepository();
      final rectifier = FakeRectificationRepository(history: history);
      final drafts = InMemoryDraftRepository();
      addTearDown(drafts.dispose);

      await tester.pumpWidget(
        _harness(
          prefs: prefs,
          history: history,
          rectifier: rectifier,
          drafts: drafts,
        ),
      );
      await tester.pumpAndSettle();
      // Navigate from home into the calc flow.
      await tester.tap(find.text('New Calculation'));
      await tester.pumpAndSettle();

      expect(find.byType(BirthDataScreen), findsOneWidget);
      expect(find.text('STEP 1 OF 3'), findsOneWidget);
      expect(find.text('Birth details'), findsOneWidget);

      // Without a date and city the Continue CTA is disabled.
      final container = ProviderScope.containerOf(
        tester.element(find.byType(BirthDataScreen)),
      );
      expect(
        container.read(calculationFlowControllerProvider).birthStepValid,
        isFalse,
      );

      // Fill the city and the date through the controller (the date
      // picker shows a native sheet, which is hard to drive in a
      // widget test). The visible CTA enables once both are set.
      final controller = container.read(
        calculationFlowControllerProvider.notifier,
      );
      controller
        ..setBirthCityText('Kyiv, Ukraine')
        ..setBirthDate(DateTime.utc(1990, 5, 14));
      await tester.pumpAndSettle();

      expect(
        container.read(calculationFlowControllerProvider).birthStepValid,
        isTrue,
      );
      expect(find.text('March 15, 1990'), findsNothing);
      expect(find.text('Kyiv, Ukraine'), findsWidgets);
    },
  );

  testWidgets('does not overflow on a 360x760 viewport', (tester) async {
    tester.view.physicalSize = const Size(360, 760);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final prefs = await _prefs();
    final history = FakeHistoryRepository();
    final rectifier = FakeRectificationRepository(history: history);
    final drafts = InMemoryDraftRepository();
    addTearDown(drafts.dispose);

    await tester.pumpWidget(
      _harness(
        prefs: prefs,
        history: history,
        rectifier: rectifier,
        drafts: drafts,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('New Calculation'));
    await tester.pumpAndSettle();

    expect(find.byType(BirthDataScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'no-match message stays visible after a completed empty search '
    'in live mode',
    (tester) async {
      final prefs = await _prefs(demo: false);
      final history = FakeHistoryRepository();
      final rectifier = FakeRectificationRepository(history: history);
      final drafts = InMemoryDraftRepository();
      // Geocoder that always returns zero results — simulates any city not
      // in the stub list.
      final geocoder = _FakeGeocodingService(const <GeoPlace>[]);
      addTearDown(drafts.dispose);

      await tester.pumpWidget(
        _harness(
          prefs: prefs,
          history: history,
          rectifier: rectifier,
          drafts: drafts,
          geocoder: geocoder,
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('New Calculation'));
      await tester.pumpAndSettle();

      expect(find.byType(BirthDataScreen), findsOneWidget);

      final cityField = find.descendant(
        of: find.byKey(const ValueKey<String>('calc-birth-city-field')),
        matching: find.byType(TextField),
      );
      await tester.enterText(cityField, 'Vilnius');
      // Wait past debounce so the search completes.
      await tester.pump(const Duration(milliseconds: 220));
      await tester.pumpAndSettle();

      // Regression: no-match panel must stay visible after the search
      // completes with zero results, not disappear silently.
      expect(
        find.text('No city found. Try a different spelling.'),
        findsOneWidget,
        reason:
            'no-match message must remain visible after a completed empty '
            'search — previously it disappeared when _searching went false '
            'and _suggestions became []',
      );

      final container = ProviderScope.containerOf(
        tester.element(find.byType(BirthDataScreen)),
      );
      expect(
        container.read(calculationFlowControllerProvider).birthStepValid,
        isFalse,
        reason: 'live Continue must stay disabled without resolved coordinates',
      );
    },
  );

  testWidgets(
    'localized city suggestions can be selected to unblock live mode',
    (tester) async {
      final prefs = await _prefs(demo: false);
      final history = FakeHistoryRepository();
      final rectifier = FakeRectificationRepository(history: history);
      final drafts = InMemoryDraftRepository();
      final geocoder = _FakeGeocodingService(
        const <GeoPlace>[
          GeoPlace(
            displayName: 'Харків, Україна',
            country: 'Україна',
            latitude: 49.9935,
            longitude: 36.2304,
            region: 'Харківська область',
          ),
        ],
      );
      addTearDown(drafts.dispose);

      await tester.pumpWidget(
        _harness(
          prefs: prefs,
          history: history,
          rectifier: rectifier,
          drafts: drafts,
          geocoder: geocoder,
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('New Calculation'));
      await tester.pumpAndSettle();

      final cityField = find.descendant(
        of: find.byKey(const ValueKey<String>('calc-birth-city-field')),
        matching: find.byType(TextField),
      );
      await tester.enterText(cityField, 'Хар');
      await tester.pump(const Duration(milliseconds: 220));
      await tester.pumpAndSettle();

      expect(geocoder.queries, <String>['Хар']);
      expect(find.text('Харків, Україна'), findsOneWidget);
      expect(find.text('Харківська область'), findsOneWidget);

      final container = ProviderScope.containerOf(
        tester.element(find.byType(BirthDataScreen)),
      );
      final controller = container.read(
        calculationFlowControllerProvider.notifier,
      );
      controller.setBirthDate(DateTime.utc(1990, 5, 14));
      await tester.pumpAndSettle();
      expect(
        container.read(calculationFlowControllerProvider).birthStepValid,
        isFalse,
        reason: 'live mode still requires selecting a geocoded place',
      );

      await tester.tap(find.text('Харків, Україна'));
      await tester.pumpAndSettle();

      final state = container.read(calculationFlowControllerProvider);
      expect(state.birthCity, 'Харків, Україна');
      expect(state.birthLatitude, 49.9935);
      expect(state.birthLongitude, 36.2304);
      expect(state.birthStepValid, isTrue);
    },
  );

  testWidgets(
    'Mateszalka Hungary Cyrillic suggestion can be selected in live mode',
    (tester) async {
      final prefs = await _prefs(demo: false);
      final history = FakeHistoryRepository();
      final rectifier = FakeRectificationRepository(history: history);
      final drafts = InMemoryDraftRepository();
      final geocoder = _FakeGeocodingService(
        const <GeoPlace>[
          GeoPlace(
            displayName: 'Матесалька, Венгрия',
            country: 'Hungary',
            latitude: 47.955,
            longitude: 22.323,
            region: 'Szabolcs-Szatmár-Bereg',
          ),
        ],
      );
      addTearDown(drafts.dispose);

      await tester.pumpWidget(
        _harness(
          prefs: prefs,
          history: history,
          rectifier: rectifier,
          drafts: drafts,
          geocoder: geocoder,
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('New Calculation'));
      await tester.pumpAndSettle();

      final cityField = find.descendant(
        of: find.byKey(const ValueKey<String>('calc-birth-city-field')),
        matching: find.byType(TextField),
      );
      await tester.enterText(cityField, 'Матесалька, Венгрия');
      await tester.pump(const Duration(milliseconds: 220));
      await tester.pumpAndSettle();

      expect(geocoder.queries, <String>['Матесалька, Венгрия']);
      expect(find.text('Матесалька, Венгрия'), findsWidgets);
      expect(find.text('Szabolcs-Szatmár-Bereg'), findsOneWidget);

      final container = ProviderScope.containerOf(
        tester.element(find.byType(BirthDataScreen)),
      );
      final controller = container.read(
        calculationFlowControllerProvider.notifier,
      );
      controller.setBirthDate(DateTime.utc(1990, 5, 14));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Матесалька, Венгрия').last);
      await tester.pumpAndSettle();

      final state = container.read(calculationFlowControllerProvider);
      expect(state.birthCity, 'Матесалька, Венгрия');
      expect(state.birthLatitude, 47.955);
      expect(state.birthLongitude, 22.323);
      expect(state.birthStepValid, isTrue);
    },
  );
}
