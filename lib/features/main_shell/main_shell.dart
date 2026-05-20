import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:rectify/widgets/nav/bottom_tab_bar.dart';

/// Bottom-tab shell host (`docs/implementation-plan.md` §5.2,
/// `docs/design-system.md` §9.16).
///
/// Wraps a `StatefulShellRoute.indexedStack` child so each tab keeps
/// its own navigator stack. Branch order matches the wireframe:
/// **New** (`/new`), **History** (`/`, default), **Settings**
/// (`/settings`).
class MainShell extends StatelessWidget {
  const MainShell({required this.shell, super.key});

  final StatefulNavigationShell shell;

  static const _destinations = <BottomTabDestination>[
    BottomTabDestination.newCalculation,
    BottomTabDestination.history,
    BottomTabDestination.settings,
  ];

  @override
  Widget build(BuildContext context) {
    final current = _destinations[shell.currentIndex];

    return Scaffold(
      body: shell,
      bottomNavigationBar: BottomTabBar(
        current: current,
        onSelect: (destination) {
          final index = _destinations.indexOf(destination);
          shell.goBranch(index, initialLocation: index == shell.currentIndex);
        },
      ),
    );
  }
}
