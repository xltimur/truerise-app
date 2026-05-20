// Test setup interleaves controller mutation with widget assertions;
// chained cascades obscure intent.
// ignore_for_file: cascade_invocations
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rectify/app/app.dart';
import 'package:rectify/app/route_names.dart';
import 'package:rectify/app/router.dart';
import 'package:rectify/core/failures.dart';
import 'package:rectify/data/models/event_category.dart';
import 'package:rectify/data/repos/draft_repository.dart';
import 'package:rectify/data/secure/secure_key_store.dart';
import 'package:rectify/features/calculation_flow/state/calculation_flow_controller.dart';
import 'package:rectify/features/error_flow/error_routing.dart';
import 'package:rectify/features/error_flow/error_screen.dart';
import 'package:rectify/providers/core_providers.dart';
import 'package:rectify/providers/repo_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/fake_history_repository.dart';
import '../../../helpers/fake_rectification_repository.dart';

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

Future<ProviderContainer> _bootFlow(
  WidgetTester tester, {
  required FakeRectificationRepository rectifier,
  required FakeHistoryRepository history,
  required InMemoryDraftRepository drafts,
}) async {
  final prefs = await _prefs();
  await tester.pumpWidget(
    _harness(
      prefs: prefs,
      history: history,
      rectifier: rectifier,
      drafts: drafts,
    ),
  );
  await tester.pumpAndSettle();
  final container = ProviderScope.containerOf(
    tester.element(find.byType(MaterialApp)),
  );
  final controller = container.read(
    calculationFlowControllerProvider.notifier,
  );
  controller.setBirthDate(DateTime.utc(1990, 5, 14));
  controller.setBirthCityText('Kyiv, Ukraine');
  controller.addEvent(category: EventCategory.marriage, year: 2018);
  controller.addEvent(category: EventCategory.careerChange, year: 2015);
  controller.addEvent(category: EventCategory.relocation, year: 2012);
  return container;
}

void main() {
  group('errorScreenForFailure → route mapping (§11.3 / Phase 6)', () {
    test('exhaustively maps every failure to its screen', () {
      expect(
        errorScreenForFailure(const TimeoutFailure()).path,
        RoutePaths.errorTimeout,
      );
      expect(
        errorScreenForFailure(const NoNetworkFailure()).path,
        RoutePaths.errorNoInternet,
      );
      expect(
        errorScreenForFailure(const BadRequestFailure('x')).path,
        RoutePaths.errorBadRequest,
      );
      expect(
        errorScreenForFailure(const UnauthorizedFailure()).path,
        RoutePaths.errorUnauthorized,
      );
      expect(
        errorScreenForFailure(const ServerFailure(503)).path,
        RoutePaths.errorServer,
      );
      expect(
        errorScreenForFailure(const RateLimitedFailure()).path,
        RoutePaths.errorServer,
      );
      expect(
        errorScreenForFailure(const MalformedResponseFailure()).path,
        RoutePaths.errorMalformed,
      );
      expect(
        errorScreenForFailure(UnknownFailure(Exception('x'))).path,
        RoutePaths.errorServer,
      );
    });
  });

  group('Loading screen → error route navigation', () {
    final cases = <({String label, AppFailure failure, String expectedPath})>[
      (
        label: 'timeout',
        failure: const TimeoutFailure(),
        expectedPath: RoutePaths.errorTimeout,
      ),
      (
        label: 'no internet',
        failure: const NoNetworkFailure(),
        expectedPath: RoutePaths.errorNoInternet,
      ),
      (
        label: 'bad request',
        failure: const BadRequestFailure('Bad date'),
        expectedPath: RoutePaths.errorBadRequest,
      ),
      (
        label: 'unauthorized',
        failure: const UnauthorizedFailure(),
        expectedPath: RoutePaths.errorUnauthorized,
      ),
      (
        label: 'server 500',
        failure: const ServerFailure(500),
        expectedPath: RoutePaths.errorServer,
      ),
      (
        label: 'malformed',
        failure: const MalformedResponseFailure(),
        expectedPath: RoutePaths.errorMalformed,
      ),
    ];

    for (final scenario in cases) {
      testWidgets(
        '${scenario.label} → ${scenario.expectedPath}',
        (tester) async {
          final history = FakeHistoryRepository();
          final rectifier = FakeRectificationRepository(history: history)
            ..failureOverride = scenario.failure;
          final drafts = InMemoryDraftRepository();
          addTearDown(drafts.dispose);

          final container = await _bootFlow(
            tester,
            rectifier: rectifier,
            history: history,
            drafts: drafts,
          );

          container.read(routerProvider).go(RoutePaths.calcLoading);
          await tester.pumpAndSettle();

          final location = container
              .read(routerProvider)
              .routerDelegate
              .currentConfiguration
              .uri
              .toString();
          expect(location, scenario.expectedPath);
          // Confirm the mounted screen is the error scaffold variant
          // for this failure kind.
          final screen = tester.widget<CalculationErrorScreen>(
            find.byType(CalculationErrorScreen),
          );
          expect(
            screen.kind.path,
            scenario.expectedPath,
            reason: 'Mounted screen kind mismatch',
          );
        },
      );
    }
  });
}
