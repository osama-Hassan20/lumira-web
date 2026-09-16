import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../../config/app_constants.dart';
import '../../../../../../core/animations/slide_transition_animation.dart';
import '../../../../../../core/utils/validators.dart';
import '../../../../../../core/widgets/custom_text_field.dart';

class EmailInputWidget extends StatelessWidget {
  const EmailInputWidget({
    super.key,
    required this.controller,
    this.hintText,
    this.title,
  });

  final TextEditingController controller;
  final String? hintText;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return SlideTransitionAnimation(
      duration: const Duration(
        milliseconds:
            AppConstants.animationDuration + AppConstants.animationIncrement,
      ),
      begin: const Offset(0, 1),
      end: Offset.zero,
      curve: Curves.easeOutCubic,
      child: CustomTextField(
        controller: controller,
        title: title ?? 'البريد الإلكتروني',
        hintText: hintText ?? 'أدخل بريدك الإلكتروني',
        textInputType: TextInputType.emailAddress,
        inputFormatters: [
          // Prevent Arabic characters in email input
          FilteringTextInputFormatter.deny(RegExp(r'[\u0600-\u06FF]')),
        ],
        validator: (value) => Validators.validateEmail(context, value),
      ),
    );
  }
}
