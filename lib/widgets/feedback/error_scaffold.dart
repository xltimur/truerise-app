import 'package:flutter/material.dart';

import 'package:rectify/theme/colors.dart';
import 'package:rectify/theme/spacing.dart';
import 'package:rectify/theme/typography.dart';

/// Full-screen error modal (`docs/design-system.md` §9.13).
///
/// Same canvas as a regular screen. Renders a 64pt clay glyph, the
/// title, the description (max 320pt width), and a stacked button
/// pair (primary + optional secondary), all centered.
class ErrorScaffold extends StatelessWidget {
  const ErrorScaffold({
    required this.icon,
    required this.title,
    required this.description,
    required this.primaryAction,
    this.secondaryAction,
    super.key,
  });

  final IconData icon;
  final String title;
  final String description;

  /// Already-styled primary CTA (e.g. `PrimaryButton(label: 'Try again', …)`).
  final Widget primaryAction;

  /// Optional secondary CTA (e.g. `GhostButton(label: 'Cancel', …)`).
  final Widget? secondaryAction;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$title. $description',
      scopesRoute: true,
      explicitChildNodes: true,
      child: Scaffold(
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
                Icon(icon, size: 64, color: AppColors.accentClay),
                const SizedBox(height: AppSpacing.s7),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTypography.titleLg,
                ),
                const SizedBox(height: AppSpacing.s4),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 320),
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyLg.copyWith(
                        color: AppColors.inkBody,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.s7),
                primaryAction,
                if (secondaryAction != null) ...<Widget>[
                  const SizedBox(height: AppSpacing.s3),
                  secondaryAction!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
