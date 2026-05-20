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
import 'package:rectify/theme/icons.dart';
import 'package:rectify/widgets/buttons/buttons.dart';
import 'package:rectify/widgets/feedback/error_scaffold.dart';

/// Phase 6 error landing screen
/// (`docs/implementation-plan.md` §11.3 / §14 Phase 6).
///
/// One file backs all six error routes; the [kind] picks copy + icon
/// and the buttons drive a retry into the calculation flow or a
/// cancel that drops the user back at history. Retrying preserves the
/// in-flight draft via [DraftRepository] (in-memory in the MVP — the
/// persisted-drafts table that would back a true "Save and retry
/// later" was deferred from Phase 6, so we hide that affordance).
class CalculationErrorScreen extends ConsumerWidget {
  const CalculationErrorScreen({required this.kind, super.key});

  final ErrorScreenKind kind;

  static const _copyByKind = <ErrorScreenKind, _ErrorCopy>{
    ErrorScreenKind.timeout: _ErrorCopy(
      icon: AppIcons.errorTimeout,
      title: 'Calculation timed out',
      description:
          "The provider didn't respond in time. Network can be slow on "
          'public Wi-Fi — give it another try in a moment.',
      primaryLabel: 'Try again',
    ),
    ErrorScreenKind.noInternet: _ErrorCopy(
      icon: AppIcons.errorNoInternet,
      title: "Can't reach the network",
      description:
          "You're offline, or your network is blocking the request. "
          'Reconnect and try again.',
      primaryLabel: 'Try again',
    ),
    ErrorScreenKind.badRequest: _ErrorCopy(
      icon: AppIcons.errorBadRequest,
      title: 'Something looked off in the data',
      description:
          'The calculation provider rejected the request. Double-check '
          'your birth date, time window, and events, then try again.',
      primaryLabel: 'Review my draft',
    ),
    ErrorScreenKind.unauthorized: _ErrorCopy(
      icon: AppIcons.errorUnauthorized,
      title: 'Authorization required',
      description:
          "The provider didn't accept the credentials this build is "
          'using. Switch to demo mode, or reconfigure your API key in '
          'Settings once that screen ships.',
      primaryLabel: 'Back to history',
    ),
    ErrorScreenKind.server: _ErrorCopy(
      icon: AppIcons.errorServer,
      title: 'Provider trouble on their end',
      description:
          'The provider returned an error. Their service may be having '
          "a rough moment — it's worth another try shortly.",
      primaryLabel: 'Try again',
    ),
    ErrorScreenKind.malformed: _ErrorCopy(
      icon: AppIcons.errorMalformed,
      title: "Couldn't read the response",
      description:
          "The provider's response didn't match what this build "
          'expects. Try again, or run a demo calculation while we look '
          'into it.',
      primaryLabel: 'Try again',
    ),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final copy = _copyByKind[kind]!;
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
          if (kind == ErrorScreenKind.unauthorized) {
            // No retry path for an unauthorized build — drop the draft
            // and return the user home so they don't get stuck in a
            // loop bouncing into the same 401.
            controller.reset();
            context.go(RoutePaths.home);
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
        label: 'Back to history',
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
