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
import 'package:rectify/data/models/geo_place.dart';
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

Future<SharedPreferences> _prefs({bool demoModeDefault = true}) async {
  SharedPreferences.setMockInitialValues(<String, Object>{
    'settings.onboarding_done': true,
    'settings.demo_mode_default': demoModeDefault,
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
  bool demoModeDefault = true,
}) async {
  final prefs = await _prefs(demoModeDefault: demoModeDefault);
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
        errorScreenForFailure(const MissingApiKeyFailure()).path,
        RoutePaths.errorMissingApiKey,
      );
      expect(
        errorScreenForFailure(const ServerFailure(503)).path,
        RoutePaths.errorServer,
      );
      expect(
        errorScreenForFailure(const RateLimitedFailure()).path,
        RoutePaths.errorRateLimited,
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
        label: 'missing api key',
        failure: const MissingApiKeyFailure(),
        expectedPath: RoutePaths.errorMissingApiKey,
      ),
      (
        label: 'server 500',
        failure: const ServerFailure(500),
        expectedPath: RoutePaths.errorServer,
      ),
      (
        label: 'rate limited',
        failure: const RateLimitedFailure(),
        expectedPath: RoutePaths.errorRateLimited,
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

    testWidgets(
      'submit failure is preserved in lastCalculationFailureProvider '
      'for error UI details',
      (tester) async {
        final failure = RateLimitedFailure(
          source: RateLimitSource.local,
          resetAt: DateTime.utc(2026, 6, 13, 10),
          retryAfter: const Duration(hours: 12),
        );
        final history = FakeHistoryRepository();
        final rectifier = FakeRectificationRepository(history: history)
          ..failureOverride = failure;
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
        expect(location, RoutePaths.errorRateLimited);
        expect(
          container.read(lastCalculationFailureProvider),
          failure,
          reason:
              'loading screen must store the typed failure before '
              'navigating so the error screen can show details',
        );
      },
    );

    testWidgets(
      'server rate limit keeps generic copy but surfaces reset and '
      'retry timing with both fallback actions',
      (tester) async {
        final failure = RateLimitedFailure(
          resetAt: DateTime.utc(2026, 6, 13, 10),
          retryAfter: const Duration(hours: 1),
        );
        final history = FakeHistoryRepository();
        final rectifier = FakeRectificationRepository(history: history)
          ..failureOverride = failure;
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

        expect(
          find.textContaining("You've reached the calculation limit"),
          findsOneWidget,
          reason: 'server 429 must keep the generic rate-limit body',
        );
        expect(
          find.textContaining('Resets at 2026-06-13 10:00 UTC'),
          findsOneWidget,
          reason: 'server resetAt metadata must be shown to the user',
        );
        expect(
          find.textContaining('try again in about 1 hour'),
          findsOneWidget,
          reason: 'server retryAfter metadata must be shown to the user',
        );
        expect(find.text('Use Demo Mode'), findsOneWidget);
        expect(find.text('Enter My API Key'), findsOneWidget);
      },
    );

    testWidgets(
      'local rate limit renders quota copy, reset time, and both '
      'fallback actions',
      (tester) async {
        final failure = RateLimitedFailure(
          source: RateLimitSource.local,
          resetAt: DateTime.utc(2026, 6, 13, 10),
          retryAfter: const Duration(hours: 12),
        );
        final history = FakeHistoryRepository();
        final rectifier = FakeRectificationRepository(history: history)
          ..failureOverride = failure;
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

        expect(
          find.textContaining('Your free live quota is used up'),
          findsOneWidget,
        );
        expect(
          find.textContaining('Resets at 2026-06-13 10:00 UTC'),
          findsOneWidget,
        );
        expect(find.text('Use Demo Mode'), findsOneWidget);
        expect(find.text('Enter My API Key'), findsOneWidget);
      },
    );
  });

  group('Error screen actions (cancel/retry invariants)', () {
    String location(ProviderContainer container) => container
        .read(routerProvider)
        .routerDelegate
        .currentConfiguration
        .uri
        .toString();

    testWidgets(
      'retryable error: primary re-enters loading, resubmits, and lands '
      'on the result once the repository recovers',
      (tester) async {
        final history = FakeHistoryRepository();
        final rectifier = FakeRectificationRepository(history: history)
          ..failureOverride = const TimeoutFailure();
        final drafts = InMemoryDraftRepository();
        addTearDown(drafts.dispose);

        final container = await _bootFlow(
          tester,
          rectifier: rectifier,
          history: history,
          drafts: drafts,
        );
        final draftId = container.read(calculationFlowControllerProvider).id;

        container.read(routerProvider).go(RoutePaths.calcLoading);
        await tester.pumpAndSettle();
        expect(location(container), RoutePaths.errorTimeout);
        expect(rectifier.submissions, hasLength(1));

        // The transient failure clears; the user taps "Try again".
        rectifier.failureOverride = null;
        await tester.tap(find.byKey(errorPrimaryActionKey));
        await tester.pumpAndSettle();

        expect(
          rectifier.submissions,
          hasLength(2),
          reason: 'retry must fire a second submission',
        );
        expect(location(container), '/calc/result/$draftId');
      },
    );

    testWidgets(
      'rate limited: primary switches the draft to demo mode and '
      'resubmits to the result',
      (tester) async {
        final history = FakeHistoryRepository();
        final rectifier = FakeRectificationRepository(history: history)
          ..failureOverride = const RateLimitedFailure(
            source: RateLimitSource.local,
          );
        final drafts = InMemoryDraftRepository();
        addTearDown(drafts.dispose);

        final container = await _bootFlow(
          tester,
          rectifier: rectifier,
          history: history,
          drafts: drafts,
          demoModeDefault: false,
        );
        container
            .read(calculationFlowControllerProvider.notifier)
            .selectGeoPlace(
              const GeoPlace(
                displayName: 'Kyiv, Ukraine',
                country: 'Ukraine',
                latitude: 50.4501,
                longitude: 30.5234,
              ),
            );
        final draftId = container.read(calculationFlowControllerProvider).id;

        container.read(routerProvider).go(RoutePaths.calcLoading);
        await tester.pumpAndSettle();
        expect(location(container), RoutePaths.errorRateLimited);
        expect(rectifier.submissions, hasLength(1));
        expect(rectifier.submissions.first.isDemo, isFalse);

        rectifier.failureOverride = null;
        await tester.tap(find.byKey(errorPrimaryActionKey));
        await tester.pumpAndSettle();

        expect(
          rectifier.submissions,
          hasLength(2),
          reason: '"Use Demo Mode" must fire a second submission',
        );
        expect(
          rectifier.submissions[1].isDemo,
          isTrue,
          reason: 'the resubmitted draft must be switched to demo mode',
        );
        expect(location(container), '/calc/result/$draftId');
      },
    );

    testWidgets(
      'rate limited: secondary opens settings without clearing the draft '
      'or resubmitting',
      (tester) async {
        final history = FakeHistoryRepository();
        final rectifier = FakeRectificationRepository(history: history)
          ..failureOverride = const RateLimitedFailure(
            source: RateLimitSource.local,
          );
        final drafts = InMemoryDraftRepository();
        addTearDown(drafts.dispose);

        final container = await _bootFlow(
          tester,
          rectifier: rectifier,
          history: history,
          drafts: drafts,
          demoModeDefault: false,
        );
        container
            .read(calculationFlowControllerProvider.notifier)
            .selectGeoPlace(
              const GeoPlace(
                displayName: 'Kyiv, Ukraine',
                country: 'Ukraine',
                latitude: 50.4501,
                longitude: 30.5234,
              ),
            );

        container.read(routerProvider).go(RoutePaths.calcLoading);
        await tester.pumpAndSettle();
        expect(location(container), RoutePaths.errorRateLimited);
        expect(rectifier.submissions, hasLength(1));

        await tester.tap(find.byKey(errorSecondaryActionKey));
        await tester.pumpAndSettle();

        expect(location(container), RoutePaths.settings);
        expect(
          drafts.read(),
          isNotNull,
          reason: '"Enter My API Key" must keep the draft for resubmission',
        );
        expect(
          rectifier.submissions,
          hasLength(1),
          reason: 'opening settings must not fire another submission',
        );
      },
    );

    testWidgets(
      'bad request: primary returns to confirm instead of retrying',
      (tester) async {
        final history = FakeHistoryRepository();
        final rectifier = FakeRectificationRepository(history: history)
          ..failureOverride = const BadRequestFailure('Bad date');
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
        expect(location(container), RoutePaths.errorBadRequest);

        await tester.tap(find.byKey(errorPrimaryActionKey));
        await tester.pumpAndSettle();

        expect(location(container), RoutePaths.calcConfirm);
        expect(
          rectifier.submissions,
          hasLength(1),
          reason: 'bad request must not auto-retry the same payload',
        );
      },
    );

    testWidgets(
      'primary with no usable draft falls back to home without crashing',
      (tester) async {
        final history = FakeHistoryRepository();
        final rectifier = FakeRectificationRepository(history: history);
        final drafts = InMemoryDraftRepository();
        addTearDown(drafts.dispose);

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

        // Land on a retryable error screen with an empty draft (e.g. a
        // stale deep link after the flow was reset).
        container.read(routerProvider).go(RoutePaths.errorTimeout);
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(errorPrimaryActionKey));
        await tester.pumpAndSettle();

        expect(location(container), RoutePaths.home);
        expect(rectifier.submissions, isEmpty);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'secondary resets the draft and returns home',
      (tester) async {
        final history = FakeHistoryRepository();
        final rectifier = FakeRectificationRepository(history: history)
          ..failureOverride = const TimeoutFailure();
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
        expect(location(container), RoutePaths.errorTimeout);
        expect(drafts.read(), isNotNull);

        await tester.tap(find.byKey(errorSecondaryActionKey));
        await tester.pumpAndSettle();

        expect(location(container), RoutePaths.home);
        expect(drafts.read(), isNull, reason: 'secondary abandons the draft');
        expect(
          container.read(calculationFlowControllerProvider).readyToSubmit,
          isFalse,
          reason: 'controller state resets to a fresh draft',
        );
      },
    );
  });
}
