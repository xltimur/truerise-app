import 'package:flutter/material.dart';

import 'package:rectify/theme/colors.dart';
import 'package:rectify/widgets/feedback/empty_state.dart';
import 'package:rectify/widgets/nav/top_nav.dart';

/// Placeholder for tab destinations that ship in later phases
/// (`docs/implementation-plan.md` §14 Phase 3 DoD: "tapping 'Try demo
/// first' navigates somewhere placeholder").
///
/// Used for the New Calculation tab (calc flow → Phase 4) and the
/// Settings tab (→ Phase 7). Renders an inert [EmptyState] so the
/// shell-level navigation still feels alive.
class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({
    required this.title,
    required this.message,
    super.key,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgApp,
      appBar: TopNav(title: title),
      body: SingleChildScrollView(
        child: EmptyState(
          title: title,
          body: message,
        ),
      ),
    );
  }
}
