// Cross-library types (e.g. `AppFailure`) are referenced in dartdoc
// purely for orientation; the analyzer can't see them without an
// import we don't otherwise need here.
// ignore_for_file: comment_references

/// Centralised route name constants
/// (`docs/implementation-plan.md` §5.3).
///
/// Phase 3 added `/onboarding` plus the tab-shell siblings `/new` and
/// `/settings`. Phase 4 adds the calculation flow under `/calc/*` as
/// top-level routes (outside the bottom-tab shell so the stepper
/// reads full-screen per `docs/ascii-wireframes.md` Screens 2–5);
/// `/new` is preserved as a redirect target for the New tab. Phase 5
/// appends `/calc/result/:resultId` and a child
/// `/calc/result/:resultId/evidence` route (Screens 6 + 7); both reach
/// `HistoryRepository.findById` so a deep link or a history-tap resolves
/// the same persisted aggregate.
abstract final class RouteNames {
  static const String onboarding = 'onboarding';
  static const String home = 'home';
  static const String newCalculation = 'new_calculation';
  static const String settings = 'settings';
  static const String settingsPrivacy = 'settings_privacy';
  static const String widgetGallery = 'widget_gallery';

  // Calculation flow (`docs/implementation-plan.md` §14 Phase 4 + 5).
  static const String calcBirth = 'calc_birth';
  static const String calcWindow = 'calc_window';
  static const String calcEvents = 'calc_events';
  static const String calcConfirm = 'calc_confirm';
  static const String calcLoading = 'calc_loading';
  static const String calcResult = 'calc_result';
  static const String calcEvidence = 'calc_evidence';

  // Error screens (`docs/implementation-plan.md` §11.3 / §14 Phase 6).
  static const String errorTimeout = 'error_timeout';
  static const String errorNoInternet = 'error_no_internet';
  static const String errorBadRequest = 'error_bad_request';
  static const String errorUnauthorized = 'error_unauthorized';
  static const String errorMissingApiKey = 'error_missing_api_key';
  static const String errorServer = 'error_server';
  static const String errorMalformed = 'error_malformed';
}

abstract final class RoutePaths {
  static const String onboarding = '/onboarding';
  static const String home = '/';
  static const String newCalculation = '/new';
  static const String settings = '/settings';
  static const String settingsPrivacy = '/settings/privacy';
  static const String widgetGallery = '/widget_gallery';

  static const String calcBirth = '/calc/birth';
  static const String calcWindow = '/calc/window';
  static const String calcEvents = '/calc/events';
  static const String calcConfirm = '/calc/confirm';
  static const String calcLoading = '/calc/loading';

  /// Pattern: `/calc/result/:resultId`. Use [calcResultFor] to build a
  /// concrete path for a given calculation id.
  static const String calcResult = '/calc/result/:resultId';

  /// Pattern: `/calc/result/:resultId/evidence`. Child of [calcResult]
  /// so the back-button returns to the result, not the home tab.
  static const String calcEvidence = '/calc/result/:resultId/evidence';

  /// Build a concrete `/calc/result/<id>` path.
  static String calcResultFor(String resultId) => '/calc/result/$resultId';

  /// Build a concrete `/calc/result/<id>/evidence` path.
  static String calcEvidenceFor(String resultId) =>
      '/calc/result/$resultId/evidence';

  /// Error screens — one per [AppFailure] variant that the
  /// rectification flow can land on (`docs/implementation-plan.md`
  /// §11.3 / §14 Phase 6).
  static const String errorTimeout = '/error/timeout';
  static const String errorNoInternet = '/error/no-internet';
  static const String errorBadRequest = '/error/bad-request';
  static const String errorUnauthorized = '/error/unauthorized';
  static const String errorMissingApiKey = '/error/missing-api-key';
  static const String errorServer = '/error/server';
  static const String errorMalformed = '/error/malformed';
}
