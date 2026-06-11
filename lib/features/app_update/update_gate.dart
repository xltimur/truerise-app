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
const Key updateBannerKey = ValueKey<String>('update-banner');

@visibleForTesting
const Key updateBannerActionKey = ValueKey<String>('update-banner-action');

@visibleForTesting
const Key updateBannerDismissKey = ValueKey<String>('update-banner-dismiss');

@visibleForTesting
const Key updateForceGateKey = ValueKey<String>('update-force-gate');

@visibleForTesting
const Key updateForceActionKey = ValueKey<String>('update-force-action');

/// App-level update surface, mounted once around the router via
/// `MaterialApp.router(builder: ...)` (see `RectifyApp`).
///
/// Renders by [UpdateDecision] urgency:
///   * `none` (and any loading/failed check) → the app, untouched;
///   * `soft` → the app plus a dismissible top banner; dismissal is
///     remembered per advertised version, so the same version never
///     re-prompts;
///   * `force` → a full-screen gate replaces the app; the only action is
///     Update. The policy layer guarantees a force decision carries a
///     valid store URL (without one it degrades to a soft banner), so the
///     gate can never trap the user with a dead button.
class UpdateGate extends ConsumerStatefulWidget {
  const UpdateGate({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<UpdateGate> createState() => _UpdateGateState();
}

class _UpdateGateState extends ConsumerState<UpdateGate> {
  /// Session-local hide so the banner vanishes immediately on dismissal;
  /// persistence across runs lives in `UpdatePromptStore`.
  bool _dismissed = false;

  Future<void> _openStore(String url) async {
    final opened = await ref.read(storeLauncherProvider).open(url);
    if (opened || !mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.updateOpenStoreFailed)),
    );
  }

  void _dismiss(UpdateDecision decision) {
    setState(() => _dismissed = true);
    final tag = decision.promptTag;
    if (tag != null) {
      // Fire-and-forget: a lost write only means one extra prompt later.
      ref.read(updatePromptStoreProvider).setDismissedTag(tag).ignore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final decision = ref
        .watch(appUpdateDecisionProvider)
        .maybeWhen(
          data: (d) => d,
          orElse: UpdateDecision.none,
        );

    switch (decision.urgency) {
      case UpdateUrgency.none:
        return widget.child;
      case UpdateUrgency.force:
        return _ForceUpdateGate(
          decision: decision,
          onUpdate: _openStore,
        );
      case UpdateUrgency.soft:
        if (_dismissed) return widget.child;
        return Stack(
          children: <Widget>[
            widget.child,
            Align(
              alignment: Alignment.topCenter,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenEdge,
                    vertical: AppSpacing.s3,
                  ),
                  child: _SoftUpdateBanner(
                    decision: decision,
                    onUpdate: _openStore,
                    onDismiss: () => _dismiss(decision),
                  ),
                ),
              ),
            ),
          ],
        );
    }
  }
}

/// Dismissible "new version available" card overlaying the top of the
/// app. Uses the standard [AppCard] chrome so it reads as product UI,
/// not a system alert.
class _SoftUpdateBanner extends StatelessWidget {
  const _SoftUpdateBanner({
    required this.decision,
    required this.onUpdate,
    required this.onDismiss,
  });

  final UpdateDecision decision;
  final Future<void> Function(String url) onUpdate;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final storeUrl = decision.storeUrl;
    final body = decision.message ?? l10n.updateAvailableBody(appBrandName);

    return Material(
      color: Colors.transparent,
      child: AppCard(
        key: updateBannerKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              l10n.updateAvailableTitle,
              style: AppTypography.bodyMd.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.s2),
            Text(
              body,
              style: AppTypography.bodySm.copyWith(color: AppColors.inkBody),
            ),
            const SizedBox(height: AppSpacing.s2),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  key: updateBannerDismissKey,
                  onPressed: onDismiss,
                  child: Text(l10n.updateNotNow),
                ),
                if (storeUrl != null) ...<Widget>[
                  const SizedBox(width: AppSpacing.s2),
                  TextButton(
                    key: updateBannerActionKey,
                    onPressed: () => onUpdate(storeUrl),
                    child: Text(l10n.updateAction),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Blocking full-screen gate for below-minimum versions. Mirrors the
/// `ErrorScaffold` full-screen layout; the single CTA opens the store.
/// There is no dismiss affordance by design — the policy layer only
/// emits `force` when a valid store URL exists.
class _ForceUpdateGate extends StatelessWidget {
  const _ForceUpdateGate({required this.decision, required this.onUpdate});

  final UpdateDecision decision;
  final Future<void> Function(String url) onUpdate;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // Guaranteed by UpdatePolicy.decide; the fallback keeps the widget
    // total if a hand-built decision ever omits it.
    final storeUrl = decision.storeUrl;

    return Semantics(
      label: l10n.updateRequiredTitle,
      scopesRoute: true,
      explicitChildNodes: true,
      child: Scaffold(
        key: updateForceGateKey,
        backgroundColor: AppColors.bgApp,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenEdge,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Icon(
                  AppIcons.refresh,
                  size: 64,
                  color: AppColors.accentClay,
                ),
                const SizedBox(height: AppSpacing.s7),
                Text(
                  l10n.updateRequiredTitle,
                  textAlign: TextAlign.center,
                  style: AppTypography.titleLg,
                ),
                const SizedBox(height: AppSpacing.s4),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 320),
                    child: Text(
                      decision.message ?? l10n.updateRequiredBody(appBrandName),
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyLg.copyWith(
                        color: AppColors.inkBody,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.s7),
                if (storeUrl != null)
                  PrimaryButton(
                    key: updateForceActionKey,
                    label: l10n.updateAction,
                    onPressed: () => onUpdate(storeUrl),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
