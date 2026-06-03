import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:rectify/l10n/l10n.dart';
import 'package:rectify/theme/colors.dart';
import 'package:rectify/theme/spacing.dart';
import 'package:rectify/theme/typography.dart';
import 'package:rectify/widgets/nav/top_nav.dart';

/// In-app privacy copy (`docs/implementation-plan.md` §15.3 open
/// question: final policy URL deferred to Phase 8).
///
/// Renders a plain-language summary so the Settings row works the
/// moment Phase 7 ships, without depending on a Legal-team URL that
/// isn't ready yet. Phase 8 swaps this for the canonical hosted URL
/// via `url_launcher`.
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: AppColors.bgApp,
      appBar: TopNav(
        title: l10n.privacyTitle,
        onBack: context.canPop() ? () => context.pop() : null,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenEdge,
          AppSpacing.s5,
          AppSpacing.screenEdge,
          AppSpacing.s8,
        ),
        children: <Widget>[
          Text(
            l10n.privacyStoresTitle(appBrandName),
            style: AppTypography.titleLg,
          ),
          const SizedBox(height: AppSpacing.s4),
          _Body(l10n.privacyStoresBody(appBrandName)),
          const SizedBox(height: AppSpacing.sectionGap),
          Text(
            l10n.privacyDemoTitle,
            style: AppTypography.titleLg,
          ),
          const SizedBox(height: AppSpacing.s4),
          _Body(l10n.privacyDemoBody),
          const SizedBox(height: AppSpacing.sectionGap),
          Text(
            l10n.privacyLiveTitle,
            style: AppTypography.titleLg,
          ),
          const SizedBox(height: AppSpacing.s4),
          _Body(l10n.privacyLiveBody(appBrandName)),
          const SizedBox(height: AppSpacing.sectionGap),
          Text(
            l10n.privacyDeleteTitle,
            style: AppTypography.titleLg,
          ),
          const SizedBox(height: AppSpacing.s4),
          _Body(l10n.privacyDeleteBody),
          const SizedBox(height: AppSpacing.sectionGap),
          Text(
            l10n.privacyAnalyticsTitle,
            style: AppTypography.titleLg,
          ),
          const SizedBox(height: AppSpacing.s4),
          _Body(l10n.privacyAnalyticsBody(appBrandName)),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.bodyMd.copyWith(color: AppColors.inkBody),
    );
  }
}
