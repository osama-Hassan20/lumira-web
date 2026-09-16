import 'package:flutter/material.dart';
import '../../../../../../config/app_constants.dart';
import '../../../../../../core/animations/slide_transition_animation.dart';
import '../../../../../../core/widgets/custom_text_field.dart';
import '../../extensions/localization_extension.dart';

class PasswordInputWidget extends StatelessWidget {
  const PasswordInputWidget({
    super.key,
    required this.controller,
    required this.isPasswordVisible,
    required this.onPasswordVisibilityToggle,
    required this.onChanged,
    required this.validator,
    this.hintText,
    this.title,
    this.prefixIcon,
    this.filled = false,
    this.fillColor,
  });

  final TextEditingController controller;
  final bool isPasswordVisible;
  final VoidCallback onPasswordVisibilityToggle;
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String> validator;
  final String? hintText;
  final String? title;
  final Widget? prefixIcon;
  final bool filled;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    return SlideTransitionAnimation(
      duration: const Duration(
        milliseconds:
            AppConstants.animationDuration +
            5 * AppConstants.animationIncrement,
      ),
      begin: const Offset(0, 1),
      end: Offset.zero,
      curve: Curves.easeOutCubic,
      child: CustomTextField(
        controller: controller,
        textInputType: TextInputType.visiblePassword,
        prefixIcon: prefixIcon,
        title: title ?? context.l10n.tr('auth_password'),
        hintText: hintText ?? '****************',
        isPassword: true,
        isPasswordVisible: isPasswordVisible,
        onPasswordVisibilityToggle: onPasswordVisibilityToggle,
        onChanged: onChanged,
        validator: validator,
        filled: filled,
        fillColor: fillColor,
      ),
    );
  }
}
