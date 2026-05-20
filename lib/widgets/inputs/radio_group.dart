import 'package:flutter/material.dart';

import 'package:rectify/theme/colors.dart';
import 'package:rectify/theme/typography.dart';

/// One row in a [RadioGroup].
@immutable
class RadioOption<T> {
  const RadioOption({required this.value, required this.label});

  final T value;
  final String label;
}

/// Vertical radio list (`docs/design-system.md` §9.3).
///
/// 24×24 ring in `ink.line` by default, clay ring + 12pt inner dot when
/// selected. Each row is a 44pt-tall tap target with `ink.line.soft`
/// dividers between rows.
class RadioGroup<T> extends StatelessWidget {
  const RadioGroup({
    required this.value,
    required this.options,
    required this.onChanged,
    super.key,
  });

  final T value;
  final List<RadioOption<T>> options;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (var i = 0; i < options.length; i++) ...<Widget>[
            _RadioRow<T>(
              option: options[i],
              selected: options[i].value == value,
              onSelect: () => onChanged(options[i].value),
            ),
            if (i < options.length - 1)
              const Divider(
                height: 1,
                thickness: 1,
                color: AppColors.inkLineSoft,
              ),
          ],
        ],
      ),
    );
  }
}

class _RadioRow<T> extends StatelessWidget {
  const _RadioRow({
    required this.option,
    required this.selected,
    required this.onSelect,
  });

  final RadioOption<T> option;
  final bool selected;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      label: option.label,
      button: true,
      excludeSemantics: true,
      child: InkWell(
        onTap: onSelect,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44),
          child: Row(
            children: <Widget>[
              _RadioIndicator(selected: selected),
              const SizedBox(width: 12),
              Expanded(
                child: Text(option.label, style: AppTypography.bodyMd),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RadioIndicator extends StatelessWidget {
  const _RadioIndicator({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: CustomPaint(painter: _RadioPainter(selected: selected)),
    );
  }
}

class _RadioPainter extends CustomPainter {
  _RadioPainter({required this.selected});

  final bool selected;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = selected ? AppColors.accentClay : AppColors.inkLine
      ..strokeWidth = selected ? 1.5 : 1;
    canvas.drawCircle(center, (size.shortestSide / 2) - 1, ringPaint);
    if (selected) {
      final dotPaint = Paint()..color = AppColors.accentClay;
      canvas.drawCircle(center, 6, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RadioPainter oldDelegate) =>
      oldDelegate.selected != selected;
}
