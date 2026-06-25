import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rectify/core/update/update_policy.dart';
import 'package:rectify/features/app_update/update_controller.dart';
import 'package:rectify/l10n/l10n.dart';
import 'package:rectify/theme/colors.dart';
import 'package:rectify/theme/icons.dart';
import 'package:rectify/theme/spacing.dart';
import 'package:rectify/theme/typography.dart';
import 'package:rectify/widgets/buttons/buttons.dart';
import 'package:rectify/widgets/cards/app_card.dart';

@visibleForTesting
const Key updateModalKey = ValueKey<String>('update-modal');

@visibleForTesting
const Key updateModalActionKey = ValueKey<String>('update-modal-action');

/// App-level update surface, mounted once around the router via
/// `MaterialApp.router(builder: ...)` (see `RectifyApp`).
///
/// Renders by [UpdateDecision] urgency:
///   * `none` (and any loading/failed check) -> the app, untouched;
///   * `soft` / `force` -> the app plus a blocking update modal whose
///     only action opens the platform store page.
class UpdateGate extends ConsumerStatefulWidget {
  const UpdateGate({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<UpdateGate> createState() => _UpdateGateState();
}

class _UpdateGateState extends ConsumerState<UpdateGate> {
  Future<void> _openStore(String url) async {
    final opened = await ref.read(storeLauncherProvider).open(url);
    if (opened || !mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.updateOpenStoreFailed)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final decision = ref
        .watch(appUpdateDecisionProvider)
        .maybeWhen(
          data: (d) => d,
          orElse: UpdateDecision.none,
        );
    final storeUrl = decision.storeUrl;

    if (decision.urgency == UpdateUrgency.none || storeUrl == null) {
      return widget.child;
    }

    return Stack(
      children: <Widget>[
        widget.child,
        const ModalBarrier(color: Colors.black54, dismissible: false),
        _UpdateModal(onUpdate: () => _openStore(storeUrl)),
      ],
    );
  }
}

/// Non-dismissible update prompt. Copy always comes from app localization
/// so the modal follows the selected app language.
class _UpdateModal extends StatelessWidget {
  const _UpdateModal({required this.onUpdate});

  final VoidCallback onUpdate;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Semantics(
      label: l10n.updateRequiredTitle,
      scopesRoute: true,
      explicitChildNodes: true,
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenEdge,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Material(
                color: Colors.transparent,
                child: AppCard(
                  key: updateModalKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const Icon(
                        AppIcons.refresh,
                        size: 48,
                        color: AppColors.accentClay,
                      ),
                      const SizedBox(height: AppSpacing.s5),
                      Text(
                        l10n.updateRequiredTitle,
                        textAlign: TextAlign.center,
                        style: AppTypography.titleLg,
                      ),
                      const SizedBox(height: AppSpacing.s3),
                      Text(
                        l10n.updateRequiredBody(appBrandName),
                        textAlign: TextAlign.center,
                        style: AppTypography.bodyLg.copyWith(
                          color: AppColors.inkBody,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s6),
                      PrimaryButton(
                        key: updateModalActionKey,
                        label: l10n.updateAction,
                        onPressed: onUpdate,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
