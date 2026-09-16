import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../../config/app_constants.dart';
import '../../../../../../core/animations/slide_transition_animation.dart';
import '../../../../../../core/utils/validators.dart';
import '../../../../../../core/widgets/custom_text_field.dart';

class FullNameInputWidget extends StatelessWidget {
  const FullNameInputWidget({
    super.key,
    required this.controller,
    this.onChanged,
    this.readOnly = false,
    this.suffixIcon,
    this.hintText,
    this.title,
    this.animate = true,
    this.validator,
    this.textAlign,
    this.textDirection,
    this.textInputType,
    this.inputFormatters,
    this.maxLines = 1,
    this.onTap,
  });

  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final Widget? suffixIcon;
  final String? hintText;
  final String? title;
  final bool animate;
  final String? Function(String?)? validator;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textField = CustomTextField(
      controller: controller,
      hintText: hintText,
      title: title,
      textInputType: textInputType ?? TextInputType.name,
      readOnly: readOnly,
      onChanged: onChanged,
      onTap: onTap,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      textAlign: textAlign ?? TextAlign.start,
      textDirection: textDirection,
      // prefixIcon: Padding(
      //   padding: const EdgeInsets.all(12.0),
      //   child: AppImage.svg(path: AppAssets.nameIcon, width: 20, height: 20),
      // ),
      suffixIcon: suffixIcon,
      validator:
          validator ??
          (value) => Validators.validateFullName(context, value, title),
    );

    if (!animate) return textField;

    return SlideTransitionAnimation(
      duration: const Duration(
        milliseconds:
            AppConstants.animationDuration + AppConstants.animationIncrement,
      ),
      begin: const Offset(0, 1),
      end: Offset.zero,
      curve: Curves.easeOutCubic,
      child: textField,
    );
  }
}
