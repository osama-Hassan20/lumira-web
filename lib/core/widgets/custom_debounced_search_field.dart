import 'dart:async';
import 'package:flutter/material.dart';
import 'custom_text_field.dart';

class CustomDebouncedSearchField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final Duration debounceDuration;
  final VoidCallback? onTap;
  final bool readOnly;
  final bool useDebounce;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  final Color? fillColor;
  final bool filled;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? textColor;
  final double? borderRadius;
  final TextStyle? hintStyle;

  const CustomDebouncedSearchField({
    super.key,
    this.controller,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onSubmitted,
    this.debounceDuration = const Duration(milliseconds: 800),
    this.onTap,
    this.readOnly = false,
    this.useDebounce = true,
    this.keyboardType,
    this.textInputAction,
    this.fillColor,
    this.filled = false,
    this.borderColor,
    this.focusedBorderColor,
    this.textColor,
    this.borderRadius,
    this.hintStyle,
  });

  @override
  State<CustomDebouncedSearchField> createState() =>
      _CustomDebouncedSearchFieldState();
}

class _CustomDebouncedSearchFieldState
    extends State<CustomDebouncedSearchField> {
  Timer? _debounce;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value) {
    if (!widget.useDebounce) {
      widget.onChanged?.call(value);
      return;
    }
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(widget.debounceDuration, () {
      if (widget.onChanged != null) {
        widget.onChanged!(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: _controller,
      hintText: widget.hintText ?? 'ابحث هنا .....',
      prefixIcon: widget.prefixIcon,
      suffixIcon:
          widget.suffixIcon ??
          (widget.controller != null && widget.controller!.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () {
                    _controller.clear();
                    widget.onChanged?.call('');
                  },
                )
              : null),
      onChanged: _onChanged,
      onFieldSubmitted: widget.onSubmitted,
      textInputAction: widget.onSubmitted != null
          ? (widget.textInputAction ?? TextInputAction.search)
          : widget.textInputAction,
      textInputType: widget.keyboardType,
      onTap: widget.onTap,
      readOnly: widget.readOnly,
      topPadding: 0,
      bottomPadding: 0,
      fillColor: widget.fillColor,
      filled: widget.filled,
      borderColor: widget.borderColor,
      focusedBorderColor: widget.focusedBorderColor,
      textColor: widget.textColor,
      borderRadius: widget.borderRadius,
      hintStyle: widget.hintStyle,
    );
  }
}
