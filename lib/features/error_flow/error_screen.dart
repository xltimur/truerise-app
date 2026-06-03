// `DraftRepository` is referenced in dartdoc for orientation but is
// not imported directly here; the analyzer can't resolve cross-library
// comment references without the import.
// ignore_for_file: comment_references
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rectify/app/route_names.dart';
import 'package:rectify/features/calculation_flow/state/calculation_flow_controller.dart';
import 'package:rectify/features/calculation_flow/state/calculation_flow_state.dart';
import 'package:rectify/features/error_flow/error_routing.dart';
import 'package:rectify/l10n/l10n.dart';
import 'package:rectify/theme/icons.dart';
import 'package:rectify/widgets/buttons/buttons.dart';
import 'package:rectify/widgets/feedback/error_scaffold.dart';

/// Phase 6 error landing screen
/// (`docs/implementation-plan.md` §11.3 / §14 Phase 6).
///
/// One file backs every error route; the [kind] picks copy + icon
/// and the buttons drive a retry into the calculation flow or a
/// cancel that drops the user back at history. Retrying preserves the
/// in-flight draft via [DraftRepository] (in-memory in the MVP — the
/// persisted-drafts table that would back a true "Save and retry
/// later" was deferred from Phase 6, so we hide that affordance).
class CalculationErrorScreen extends ConsumerWidget {
  const CalculationErrorScreen({required this.kind, super.key});

  final ErrorScreenKind kind;

  static _ErrorCopy _copyFor(AppLocalizations l10n, ErrorScreenKind kind) {
    return switch (kind) {
      ErrorScreenKind.timeout => _ErrorCopy(
        icon: AppIcons.errorTimeout,
        title: l10n.errorTimeoutTitle,
        description: l10n.errorTimeoutBody,
        primaryLabel: l10n.errorTryAgain,
      ),
      ErrorScreenKind.noInternet => _ErrorCopy(
        icon: AppIcons.errorNoInternet,
        title: l10n.errorNoInternetTitle,
        description: l10n.errorNoInternetBody,
        primaryLabel: l10n.errorTryAgain,
      ),
      ErrorScreenKind.badRequest => _ErrorCopy(
        icon: AppIcons.errorBadRequest,
        title: l10n.errorBadRequestTitle,
        description: l10n.errorBadRequestBody,
        primaryLabel: l10n.errorReviewDraft,
      ),
      ErrorScreenKind.unauthorized => _ErrorCopy(
        icon: AppIcons.errorUnauthorized,
        title: l10n.errorUnauthorizedTitle,
        description: l10n.errorUnauthorizedBody,
        primaryLabel: l10n.errorOpenSettings,
      ),
      ErrorScreenKind.missingApiKey => _ErrorCopy(
        icon: AppIcons.errorUnauthorized,
        title: l10n.errorMissingApiKeyTitle,
        description: l10n.errorMissingApiKeyBody,
        primaryLabel: l10n.errorOpenSettings,
      ),
      ErrorScreenKind.server => _ErrorCopy(
        icon: AppIcons.errorServer,
        title: l10n.errorServerTitle,
        description: l10n.errorServerBody,
        primaryLabel: l10n.errorTryAgain,
      ),
      ErrorScreenKind.rateLimited => _ErrorCopy(
        icon: AppIcons.errorRateLimited,
        title: l10n.errorRateLimitedTitle,
        description: l10n.errorRateLimitedBody,
        primaryLabel: l10n.errorTryAgain,
      ),
      ErrorScreenKind.malformed => _ErrorCopy(
        icon: AppIcons.errorMalformed,
        title: l10n.errorMalformedTitle,
        description: l10n.errorMalformedBody,
        primaryLabel: l10n.errorTryAgain,
      ),
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final copy = _copyFor(l10n, kind);
    final controller = ref.read(calculationFlowControllerProvider.notifier);
    final hasDraft = ref.watch(
      calculationFlowControllerProvider.select((s) => s.readyToSubmit),
    );

    return ErrorScaffold(
      icon: copy.icon,
      title: copy.title,
      description: copy.description,
      primaryAction: PrimaryButton(
        label: copy.primaryLabel,
        onPressed: () {
          if (kind == ErrorScreenKind.unauthorized ||
              kind == ErrorScreenKind.missingApiKey) {
            // Drop the draft and route into Settings so the user can
            // add or replace their API key — retrying the same 401 (or
            // submitting again with no key) would just bounce back here.
            controller.reset();
            context.go(RoutePaths.settings);
            return;
          }
          if (kind == ErrorScreenKind.badRequest) {
            // Steer the user back to confirm so they can correct the
            // payload; the in-memory draft is still intact.
            controller.goTo(CalculationFlowStep.confirm);
            context.go(RoutePaths.calcConfirm);
            return;
          }
          if (!hasDraft) {
            context.go(RoutePaths.home);
            return;
          }
          // Re-enter the loading screen so the controller fires submit
          // again against the same draft.
          context.go(RoutePaths.calcLoading);
        },
      ),
      secondaryAction: GhostButton(
        label: l10n.commonBackToHistory,
        onPressed: () {
          controller.reset();
          context.go(RoutePaths.home);
        },
      ),
    );
  }
}

class _ErrorCopy {
  const _ErrorCopy({
    required this.icon,
    required this.title,
    required this.description,
    required this.primaryLabel,
  });

  final IconData icon;
  final String title;
  final String description;
  final String primaryLabel;
}
