// `DraftRepository` is referenced in dartdoc for orientation but is
// not imported directly here; the analyzer can't resolve cross-library
// comment references without the import.
// ignore_for_file: comment_references
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:rectify/app/route_names.dart';
import 'package:rectify/core/failures.dart';
import 'package:rectify/features/calculation_flow/state/calculation_flow_controller.dart';
import 'package:rectify/features/calculation_flow/state/calculation_flow_state.dart';
import 'package:rectify/features/error_flow/error_routing.dart';
import 'package:rectify/l10n/l10n.dart';
import 'package:rectify/providers/settings_controller.dart';
import 'package:rectify/theme/icons.dart';
import 'package:rectify/widgets/buttons/buttons.dart';
import 'package:rectify/widgets/feedback/error_scaffold.dart';

@visibleForTesting
const Key errorPrimaryActionKey = ValueKey<String>('error-primary-action');

@visibleForTesting
const Key errorSecondaryActionKey = ValueKey<String>('error-secondary-action');

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

  static _ErrorCopy _copyFor(
    AppLocalizations l10n,
    ErrorScreenKind kind,
    AppFailure? rememberedFailure,
  ) {
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
        primaryLabel: l10n.errorTryAgain,
      ),
      ErrorScreenKind.missingApiKey => _ErrorCopy(
        icon: AppIcons.errorUnauthorized,
        title: l10n.errorMissingApiKeyTitle,
        description: l10n.errorMissingApiKeyBody,
        primaryLabel: l10n.errorTryAgain,
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
        description: _rateLimitDescription(l10n, rememberedFailure),
        primaryLabel: l10n.errorRateLimitedUseDemo,
      ),
      ErrorScreenKind.malformed => _ErrorCopy(
        icon: AppIcons.errorMalformed,
        title: l10n.errorMalformedTitle,
        description: l10n.errorMalformedBody,
        primaryLabel: l10n.errorTryAgain,
      ),
    };
  }

  /// Stable UTC stamp (`yyyy-MM-dd HH:mm UTC`) for the local-quota
  /// reset time, independent of device timezone and locale settings.
  static final DateFormat _resetAtUtcFormat = DateFormat('yyyy-MM-dd HH:mm');

  /// Local-quota exhaustion gets honest "your free quota" copy with the
  /// reset time when known; a server/proxy 429 keeps the generic body
  /// but appends any reset / retry-after timing the response carried.
  /// No remembered failure (or a non-rate-limit one) keeps the generic
  /// body alone.
  static String _rateLimitDescription(
    AppLocalizations l10n,
    AppFailure? rememberedFailure,
  ) {
    if (rememberedFailure is! RateLimitedFailure) {
      return l10n.errorRateLimitedBody;
    }
    if (rememberedFailure.source != RateLimitSource.local) {
      return '${l10n.errorRateLimitedBody}'
          '${_timingDetail(l10n, rememberedFailure)}';
    }
    final resetAt = rememberedFailure.resetAt;
    final resetDetail = resetAt == null
        ? ''
        : ' ${_resetAtSentence(l10n, resetAt)}';
    return l10n.errorRateLimitedLocalQuotaBody(resetDetail);
  }

  /// Localized "Resets at 2026-06-13 10:00 UTC."-style sentence for a
  /// known reset time.
  static String _resetAtSentence(AppLocalizations l10n, DateTime resetAt) =>
      l10n.errorRateLimitedResetAt(_resetAtUtcFormat.format(resetAt.toUtc()));

  /// Sentences appended to the generic 429 body for whichever of
  /// `resetAt` / `retryAfter` the server reported (empty when neither
  /// is known).
  static String _timingDetail(
    AppLocalizations l10n,
    RateLimitedFailure failure,
  ) {
    final buffer = StringBuffer();
    final resetAt = failure.resetAt;
    if (resetAt != null) {
      buffer.write(' ${_resetAtSentence(l10n, resetAt)}');
    }
    final retryAfter = failure.retryAfter;
    if (retryAfter != null) {
      final wait = _retryAfterText(l10n, retryAfter);
      buffer.write(' ${l10n.errorRateLimitedRetryAfter(wait)}');
    }
    return buffer.toString();
  }

  /// Coarse human wait estimate ("1 minute", "45 minutes", "2 hours");
  /// sub-minute waits round up so the copy never says "0 minutes".
  static String _retryAfterText(AppLocalizations l10n, Duration retryAfter) {
    final minutes = retryAfter.inMinutes < 1 ? 1 : retryAfter.inMinutes;
    if (minutes < 60) {
      return l10n.errorRateLimitedRetryMinutes(minutes);
    }
    return l10n.errorRateLimitedRetryHours((minutes / 60).ceil());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final rememberedFailure = ref.watch(lastCalculationFailureProvider);
    final copy = _copyFor(l10n, kind, rememberedFailure);
    final controller = ref.read(calculationFlowControllerProvider.notifier);
    final hasDraft = ref.watch(
      calculationFlowControllerProvider.select((s) => s.readyToSubmit),
    );
    final isRateLimited = kind == ErrorScreenKind.rateLimited;

    return ErrorScaffold(
      icon: copy.icon,
      title: copy.title,
      description: copy.description,
      primaryAction: PrimaryButton(
        key: errorPrimaryActionKey,
        label: copy.primaryLabel,
        onPressed: () {
          if (isRateLimited) {
            // The quota blocks live submits, so the retry path is demo:
            // flip the draft and the persisted default before
            // re-entering the flow.
            controller.setIsDemo(value: true);
            unawaited(
              ref
                  .read(settingsControllerProvider.notifier)
                  .setDemoModeDefault(value: true),
            );
            context.go(hasDraft ? RoutePaths.calcLoading : RoutePaths.home);
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
        key: errorSecondaryActionKey,
        label: isRateLimited
            ? l10n.errorRateLimitedEnterKey
            : l10n.commonBackToHistory,
        onPressed: () {
          if (isRateLimited) {
            // Keep the draft alive: after adding a key in Settings the
            // user can resubmit the same calculation.
            context.go(RoutePaths.settingsApiKeyFocus);
            return;
          }
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
