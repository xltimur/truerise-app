import 'package:flutter/material.dart';

import 'package:rectify/theme/colors.dart';
import 'package:rectify/theme/typography.dart';
import 'package:rectify/widgets/inputs/_input_shell.dart';

/// Single-line text input (`docs/design-system.md` §9.2).
///
/// Renders the Rectify input chrome (label above, helper below, clay
/// focus ring) around a Material [TextField] kept lightweight — no
/// `InputDecoration` borders, no floating label, no Material color
/// shifts. This is a controlled input: pass a [controller] or watch
/// [onChanged] for the value.
class InputField extends StatefulWidget {
  const InputField({
    required this.label,
    this.controller,
    this.initialValue,
    this.hintText,
    this.helperText,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.leading,
    this.trailing,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.autofocus = false,
    this.semanticsLabel,
    super.key,
  }) : assert(
         controller == null || initialValue == null,
         'Provide controller or initialValue, not both',
       );

  final TextEditingController? controller;
  final String? initialValue;
  final String label;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final Widget? leading;
  final Widget? trailing;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool enabled;
  final bool autofocus;
  final String? semanticsLabel;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  bool _ownsController = false;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = TextEditingController(text: widget.initialValue);
      _ownsController = true;
    }
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (mounted) setState(() => _focused = _focusNode.hasFocus);
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_handleFocusChange)
      ..dispose();
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  InputFieldState get _state {
    if (!widget.enabled) return InputFieldState.disabled;
    if (widget.errorText != null) return InputFieldState.error;
    if (_focused) return InputFieldState.focused;
    return InputFieldState.idle;
  }

  @override
  Widget build(BuildContext context) {
    final disabled = !widget.enabled;
    return InputShell(
      label: widget.label,
      state: _state,
      helperText: widget.helperText,
      errorText: widget.errorText,
      leading: widget.leading,
      trailing: widget.trailing,
      semanticsLabel: widget.semanticsLabel,
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        enabled: widget.enabled,
        autofocus: widget.autofocus,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        style: AppTypography.bodyLg.copyWith(
          color: disabled ? AppColors.inkFaint : AppColors.inkStrong,
        ),
        cursorColor: AppColors.accentClay,
        decoration: InputDecoration(
          isDense: true,
          isCollapsed: true,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          hintText: widget.hintText,
          hintStyle: AppTypography.bodyLg.copyWith(color: AppColors.inkFaint),
        ),
      ),
    );
  }
}
