import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rectify/app/app.dart';
import 'package:rectify/data/secure/secure_key_store.dart';
import 'package:rectify/providers/core_providers.dart';
import 'package:rectify/providers/repo_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/fake_history_repository.dart';

/// Phase 8 polish gate (`docs/implementation-plan.md` §14 Phase 8,
/// `docs/design-system.md` §15) — the onboarding Skip affordance is the
/// first interactive control a brand-new user sees, so it must:
///
///   1. Stay below the dynamic-island / status-bar inset on every iPhone
///      (no top-edge overlap with the SafeArea top edge).
///   2. Survive Dynamic Type ×1.3 without overflowing.

Future<SharedPreferences> _prefs() async {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  return SharedPreferences.getInstance();
}

Widget _appWithMedia({
  required SharedPreferences prefs,
  required MediaQueryData mediaQuery,
}) {
  return ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      secureKeyStoreProvider.overrideWithValue(InMemorySecureKeyStore()),
      historyRepositoryProvider.overrideWithValue(FakeHistoryRepository()),
    ],
    child: MediaQuery(data: mediaQuery, child: const RectifyApp()),
  );
}

void main() {
  testWidgets(
    'Skip sits below the dynamic island inset on iPhone 15 Pro',
    (tester) async {
      tester.view.physicalSize = const Size(1179, 2556);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final prefs = await _prefs();

      await tester.pumpWidget(
        _appWithMedia(
          prefs: prefs,
          mediaQuery: const MediaQueryData(
            size: Size(393, 852),
            padding: EdgeInsets.only(top: 59),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final skip = find.byKey(const ValueKey<String>('onboarding-skip'));
      expect(skip, findsOneWidget);

      final skipTopLeft = tester.getTopLeft(skip);
      // SafeArea top inset (59) is the floor — anything less means Skip
      // is colliding with the dynamic-island area.
      expect(
        skipTopLeft.dy,
        greaterThanOrEqualTo(59),
        reason: 'Skip must sit below the SafeArea top inset.',
      );
    },
  );

  testWidgets(
    'Skip and slide copy do not overflow with Dynamic Type ×1.3',
    (tester) async {
      tester.view.physicalSize = const Size(1179, 2556);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final prefs = await _prefs();

      await tester.pumpWidget(
        _appWithMedia(
          prefs: prefs,
          mediaQuery: const MediaQueryData(
            size: Size(393, 852),
            padding: EdgeInsets.only(top: 59),
            textScaler: TextScaler.linear(1.3),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // RenderFlex / RenderConstrainedBox overflows are thrown by the
      // framework in test mode; `tester.takeException()` surfaces them.
      expect(
        tester.takeException(),
        isNull,
        reason: 'Dynamic Type ×1.3 must not trip an overflow on onboarding.',
      );

      // Skip remains visible and tappable.
      final skip = find.byKey(const ValueKey<String>('onboarding-skip'));
      expect(skip, findsOneWidget);
    },
  );
}
