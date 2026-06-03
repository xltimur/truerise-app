import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rectify/features/reviews/review_prompt_controller.dart';
import 'package:rectify/l10n/l10n.dart';

@visibleForTesting
const Key reviewInvitationDialogKey = ValueKey<String>(
  'review-invitation-dialog',
);

@visibleForTesting
const Key reviewInvitationConfirmKey = ValueKey<String>(
  'review-invitation-confirm',
);

@visibleForTesting
const Key reviewInvitationDismissKey = ValueKey<String>(
  'review-invitation-dismiss',
);

/// Shows the compliant, neutral review invitation at a positive moment —
/// but only when [ReviewPromptController.shouldRequest] allows it.
///
/// Honest by construction: it never asks for a specific star count, never
/// offers a reward, never blocks anything, and never asks "are you happy?"
/// to decide who reaches the store (no sentiment gating). Both choices are
/// neutral; declining simply dismisses — there is no consolation feedback
/// form, so the rating is never used to branch behaviour. Tapping "leave a
/// review" hands off to the OS-owned review flow, which alone decides what
/// (if anything) to show.
///
/// Call this from a genuine positive moment (e.g. after a successful
/// native share), never from a persistent "rate us" button.
Future<void> maybeInviteReview(BuildContext context, WidgetRef ref) async {
  final controller = ref.read(reviewPromptControllerProvider);
  if (!await controller.shouldRequest()) return;
  // Start the cooldown the moment we decide to ask, so even a declined
  // invitation is not repeated until the cooldown elapses.
  await controller.recordPrompted();
  if (!context.mounted) return;
  final accepted = await _showReviewInvitationDialog(context);
  if (accepted ?? false) {
    await controller.requestReview();
  }
}

Future<bool?> _showReviewInvitationDialog(BuildContext context) {
  final l10n = context.l10n;
  return showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        key: reviewInvitationDialogKey,
        title: Text(l10n.reviewPromptTitle(appBrandName)),
        content: Text(l10n.reviewPromptBody(appBrandName)),
        actions: <Widget>[
          TextButton(
            key: reviewInvitationDismissKey,
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.reviewPromptDismiss),
          ),
          TextButton(
            key: reviewInvitationConfirmKey,
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.reviewPromptConfirm),
          ),
        ],
      );
    },
  );
}
