import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rectify/app/route_names.dart';
import 'package:rectify/features/calculation_flow/screens/birth_data_screen.dart';
import 'package:rectify/features/calculation_flow/screens/confirmation_screen.dart';
import 'package:rectify/features/calculation_flow/screens/evidence_screen.dart';
import 'package:rectify/features/calculation_flow/screens/life_events_screen.dart';
import 'package:rectify/features/calculation_flow/screens/loading_screen.dart';
import 'package:rectify/features/calculation_flow/screens/result_screen.dart';
import 'package:rectify/features/calculation_flow/screens/time_window_screen.dart';
import 'package:rectify/features/error_flow/error_routing.dart';
import 'package:rectify/features/error_flow/error_screen.dart';
import 'package:rectify/features/home/home_history_screen.dart';
import 'package:rectify/features/main_shell/main_shell.dart';
import 'package:rectify/features/onboarding/onboarding_screen.dart';
import 'package:rectify/features/settings/privacy_policy_screen.dart';
import 'package:rectify/features/settings/settings_screen.dart';
import 'package:rectify/features/widget_gallery/widget_gallery_screen.dart';
import 'package:rectify/providers/settings_controller.dart';

/// App-wide router (`docs/implementation-plan.md` §5).
///
/// Routes:
/// - `/onboarding` (full-screen, no tab bar).
/// - Bottom-tab shell with three branches:
///   - `/`         → Home / History (default).
///   - `/new`      → calc-flow entry; redirects to `/calc/birth`.
///   - `/settings` → settings placeholder (Phase 7).
/// - `/calc/{birth,window,events,confirm,loading}` (Phase 4):
///   full-screen calculation input flow, outside the tab shell so
///   the stepper reads edge-to-edge (`docs/ascii-wireframes.md`
///   Screens 2–5).
/// - First-launch gate: `settingsControllerProvider.onboardingDone`.
///   Unfinished onboarding → forced to `/onboarding`; completing it
///   pops back to `/` via the same redirect on the next refresh tick.
final routerProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = ValueNotifier<int>(0);
  ref
    ..listen<bool>(
      settingsControllerProvider.select((s) => s.onboardingDone),
      (_, _) => refreshNotifier.value++,
    )
    ..onDispose(refreshNotifier.dispose);

  return GoRouter(
    initialLocation: RoutePaths.home,
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final settings = ref.read(settingsControllerProvider);
      final loc = state.matchedLocation;

      // The debug-only widget gallery is exempt from the gate.
      if (loc == RoutePaths.widgetGallery) {
        return null;
      }

      final atOnboarding = loc == RoutePaths.onboarding;
      if (!settings.onboardingDone && !atOnboarding) {
        return RoutePaths.onboarding;
      }
      if (settings.onboardingDone && atOnboarding) {
        return RoutePaths.home;
      }
      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: RoutePaths.onboarding,
        name: RouteNames.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => MainShell(shell: shell),
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: RoutePaths.newCalculation,
                name: RouteNames.newCalculation,
                redirect: (context, state) => RoutePaths.calcBirth,
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: RoutePaths.home,
                name: RouteNames.home,
                builder: (context, state) => const HomeHistoryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: RoutePaths.settings,
                name: RouteNames.settings,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: RoutePaths.settingsPrivacy,
        name: RouteNames.settingsPrivacy,
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: RoutePaths.calcBirth,
        name: RouteNames.calcBirth,
        builder: (context, state) => const BirthDataScreen(),
      ),
      GoRoute(
        path: RoutePaths.calcWindow,
        name: RouteNames.calcWindow,
        builder: (context, state) => const TimeWindowScreen(),
      ),
      GoRoute(
        path: RoutePaths.calcEvents,
        name: RouteNames.calcEvents,
        builder: (context, state) => const LifeEventsScreen(),
      ),
      GoRoute(
        path: RoutePaths.calcConfirm,
        name: RouteNames.calcConfirm,
        builder: (context, state) => const ConfirmationScreen(),
      ),
      GoRoute(
        path: RoutePaths.calcLoading,
        name: RouteNames.calcLoading,
        builder: (context, state) => const CalculationLoadingScreen(),
      ),
      GoRoute(
        path: RoutePaths.calcResult,
        name: RouteNames.calcResult,
        builder: (context, state) => ResultScreen(
          resultId: state.pathParameters['resultId']!,
        ),
        routes: <RouteBase>[
          GoRoute(
            path: 'evidence',
            name: RouteNames.calcEvidence,
            builder: (context, state) => EvidenceScreen(
              resultId: state.pathParameters['resultId']!,
            ),
          ),
        ],
      ),
      GoRoute(
        path: RoutePaths.errorTimeout,
        name: RouteNames.errorTimeout,
        builder: (context, state) =>
            const CalculationErrorScreen(kind: ErrorScreenKind.timeout),
      ),
      GoRoute(
        path: RoutePaths.errorNoInternet,
        name: RouteNames.errorNoInternet,
        builder: (context, state) =>
            const CalculationErrorScreen(kind: ErrorScreenKind.noInternet),
      ),
      GoRoute(
        path: RoutePaths.errorBadRequest,
        name: RouteNames.errorBadRequest,
        builder: (context, state) =>
            const CalculationErrorScreen(kind: ErrorScreenKind.badRequest),
      ),
      GoRoute(
        path: RoutePaths.errorUnauthorized,
        name: RouteNames.errorUnauthorized,
        builder: (context, state) =>
            const CalculationErrorScreen(kind: ErrorScreenKind.unauthorized),
      ),
      GoRoute(
        path: RoutePaths.errorMissingApiKey,
        name: RouteNames.errorMissingApiKey,
        builder: (context, state) =>
            const CalculationErrorScreen(kind: ErrorScreenKind.missingApiKey),
      ),
      GoRoute(
        path: RoutePaths.errorServer,
        name: RouteNames.errorServer,
        builder: (context, state) =>
            const CalculationErrorScreen(kind: ErrorScreenKind.server),
      ),
      GoRoute(
        path: RoutePaths.errorMalformed,
        name: RouteNames.errorMalformed,
        builder: (context, state) =>
            const CalculationErrorScreen(kind: ErrorScreenKind.malformed),
      ),
      if (kDebugMode)
        GoRoute(
          path: RoutePaths.widgetGallery,
          name: RouteNames.widgetGallery,
          builder: (context, state) => const WidgetGalleryScreen(),
        ),
    ],
  );
});
