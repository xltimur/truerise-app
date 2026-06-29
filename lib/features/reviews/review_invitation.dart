import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rectify/features/reviews/review_prompt_controller.dart';

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

/// Requests the platform-owned review flow at a positive moment — but only
/// when [ReviewPromptController.shouldRequest] allows it.
///
/// Compliance is structural: there is no custom pre-prompt, no sentiment
/// gate, no star-count request, and no reward. The OS-owned review surface
/// decides whether anything is shown and never returns the rating to us.
///
/// Call this from a genuine positive moment (e.g. after a successful
/// native share), never from a persistent "rate us" button.
Future<void> maybeInviteReview(BuildContext context, WidgetRef ref) async {
  final controller = ref.read(reviewPromptControllerProvider);
  if (!await controller.shouldRequest()) return;
  // Start the cooldown the moment we decide to ask, so even a declined
  // OS prompt (or a platform no-op) is not repeated until the cooldown elapses.
  await controller.recordPrompted();
  if (!context.mounted) return;
  await controller.requestReview();
}
