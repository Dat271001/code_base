import 'package:flutter/material.dart';
import 'package:test_project/utils/palette.dart';
import 'package:test_project/utils/app_size.dart';
import 'package:test_project/generated/assets.gen.dart';
import 'package:test_project/utils/extension.dart';
import 'package:flutter/services.dart';

enum WTextFormFieldType { text, email, phoneNumber, password }

class WTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final SvgGenImage? prefixIcon;
  final Color? selectedColor;
  final Color? errorColor;
  final String? hint;
  final TextInputType textInputType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final FocusNode? focusNode;
  final String? error;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  const WTextFormField({
    super.key,
    this.controller,
    this.prefixIcon,
    this.hint,
    this.textInputType = TextInputType.text,
    this.textInputAction,
    this.obscureText = false,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.error,
    this.selectedColor = Palette.primaryColor,
    this.errorColor = Palette.statusColorError,
  });

  factory WTextFormField.fromType({
    Key? key,
    required WTextFormFieldType type,
    TextEditingController? controller,
    SvgGenImage? prefixIcon,
    String? hint,
    VoidCallback? onTap,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    FocusNode? focusNode,
    String? error,
    Color selectedColor = Palette.primaryColor,
    Color errorColor = Palette.statusColorError,
  }) {
    return WTextFormField(
      key: key,
      controller: controller,
      prefixIcon: prefixIcon,
      hint: hint,
      textInputType: _getInputType(type),
      textInputAction: _getInputAction(type),
      obscureText: type == WTextFormFieldType.password,
      onTap: onTap,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      focusNode: focusNode,
      error: error,
      selectedColor: selectedColor,
      errorColor: errorColor,
    );
  }

  static TextInputType _getInputType(WTextFormFieldType type) {
    switch (type) {
      case WTextFormFieldType.email:
        return TextInputType.emailAddress;
      case WTextFormFieldType.phoneNumber:
        return const TextInputType.numberWithOptions(decimal: false);
      case WTextFormFieldType.password:
        return TextInputType.visiblePassword;
      case WTextFormFieldType.text:
      default:
        return TextInputType.text;
    }
  }

  static TextInputAction? _getInputAction(WTextFormFieldType type) {
    switch (type) {
      case WTextFormFieldType.email:
        return TextInputAction.next;
      case WTextFormFieldType.password:
        return TextInputAction.done;
      default:
        return null;
    }
  }

  @override
  State<WTextFormField> createState() => _WTextFormFieldState();
}

class _WTextFormFieldState extends State<WTextFormField> {
  late ColorFilter? _colorPrefixIcon;
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    widget.focusNode?.addListener(_onFocusChange);
    _colorPrefixIcon = widget.prefixIcon?.svg().colorFilter;
    _obscureText = widget.obscureText;
  }

  @override
  void dispose() {
    widget.focusNode?.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() {
    if (widget.focusNode == null) return;
    setState(() {
      _updateColorPrefix();
    });
  }

  void _updateColorPrefix() {
    if (widget.focusNode == null) return;
    if (widget.error == null) {
      _colorPrefixIcon = widget.focusNode!.hasFocus
          ? widget.selectedColor?.colorFilter()
          : widget.prefixIcon?.svg().colorFilter;
    } else {
      _colorPrefixIcon = widget.errorColor?.colorFilter();
    }
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    _updateColorPrefix();
    return TextField(
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),
      textAlign: TextAlign.left,
      controller: widget.controller,
      autocorrect: false,
      enableSuggestions: false,
      obscureText: _obscureText,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      textInputAction: widget.textInputAction,
      onTap: widget.onTap,
      focusNode: widget.focusNode,
      keyboardType: widget.textInputType, // Giữ nguyên kiểu nhập từ factory
      inputFormatters: widget.textInputType == TextInputType.number ||
          widget.textInputType == const TextInputType.numberWithOptions(decimal: false)
          ? [FilteringTextInputFormatter.digitsOnly] // Chặn mọi ký tự ngoài số
          : null,
      decoration: InputDecoration(
        isDense: false,
        hintText: widget.hint,
        hintStyle: Theme.of(context).textTheme.bodyMedium,
        contentPadding: const EdgeInsets.all(AppSize.size16),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.size12),
          borderSide: BorderSide(width: AppSize.minisize, color: Palette.borderSideGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.size12),
          borderSide: BorderSide(width: AppSize.minisize, color: Palette.primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.size12),
          borderSide: const BorderSide(width: AppSize.minisize, color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.size12),
          borderSide: const BorderSide(width: AppSize.size8, color: Colors.red),
        ),
        errorMaxLines: 1,
        errorText: widget.error,
        errorStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.red),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(AppSize.size16),
          child: widget.prefixIcon?.svg(colorFilter: _colorPrefixIcon),
        ),
        suffixIcon: widget.textInputType == TextInputType.visiblePassword
            ? IconButton(
          padding: const EdgeInsets.all(AppSize.size8),
          onPressed: _toggleObscureText,
          icon: Icon(
            _obscureText ? Icons.visibility_rounded : Icons.visibility_off_rounded,
            color: Palette.blackColor,
          ),
        )
            : null,
      ),
    );
  }
}
