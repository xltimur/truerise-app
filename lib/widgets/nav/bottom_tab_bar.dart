import 'package:flutter/material.dart';

import 'package:rectify/l10n/l10n.dart';
import 'package:rectify/theme/colors.dart';
import 'package:rectify/theme/icons.dart';
import 'package:rectify/theme/typography.dart';

/// Bottom tab destination (`docs/design-system.md` §9.16).
enum BottomTabDestination {
  newCalculation(AppIcons.add),
  history(AppIcons.history),
  settings(AppIcons.settings);

  const BottomTabDestination(this.icon);

  final IconData icon;
}

/// Bottom tab bar (`docs/design-system.md` §9.16).
///
/// 56pt above the safe area, `bg.surface`, 1pt `ink.line` top border.
/// Three tabs: New / History / Settings. Active in clay; inactive
/// in `ink.muted`. Label uses tighter `labelSm` (11pt).
class BottomTabBar extends StatelessWidget {
  const BottomTabBar({
    required this.current,
    required this.onSelect,
    super.key,
  });

  final BottomTabDestination current;
  final ValueChanged<BottomTabDestination> onSelect;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.bgSurface,
          border: Border(
            top: BorderSide(color: AppColors.inkLine),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 56,
            child: Row(
              children: <Widget>[
                for (final destination in BottomTabDestination.values)
                  Expanded(
                    child: _TabSlot(
                      destination: destination,
                      selected: destination == current,
                      onTap: () => onSelect(destination),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TabSlot extends StatelessWidget {
  const _TabSlot({
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final BottomTabDestination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.accentClay : AppColors.inkMuted;
    final l10n = context.l10n;
    final label = switch (destination) {
      BottomTabDestination.newCalculation => l10n.navNew,
      BottomTabDestination.history => l10n.navHistory,
      BottomTabDestination.settings => l10n.navSettings,
    };

    return Semantics(
      selected: selected,
      button: true,
      label: label,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(destination.icon, size: 22, color: color),
            const SizedBox(height: 2),
            // Long localized labels (e.g. German "EINSTELLUNGEN") wrap to a
            // second line under Dynamic Type and overflow the fixed 56pt
            // slot. Keep one line and shrink-to-fit so the whole word stays
            // readable instead of ellipsizing.
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                maxLines: 1,
                softWrap: false,
                style: AppTypography.labelSm
                    .copyWith(color: color, fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
