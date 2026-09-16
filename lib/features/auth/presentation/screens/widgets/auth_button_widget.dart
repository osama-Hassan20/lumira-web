import 'package:flutter/material.dart';
import '../../../../../config/app_constants.dart';
import '../../../../../core/animations/slide_transition_animation.dart';
import '../../../../../core/widgets/custom_button.dart';

class AuthButtonWidget extends StatelessWidget {
  const AuthButtonWidget({
    super.key,
    required this.isLoading,
    required this.isEnabled,
    required this.onTap,
    required this.title,
  });

  final bool isLoading;
  final bool isEnabled;
  final VoidCallback onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SlideTransitionAnimation(
      duration: const Duration(
        milliseconds:
            AppConstants.animationDuration +
            3 * AppConstants.animationIncrement,
      ),
      begin: const Offset(0, 0.5),
      end: Offset.zero,
      curve: Curves.easeOutCubic,
      child: CustomButton(
        height: 48,
        title: title,
        enabled: isEnabled,
        isLoading: isLoading,
        onTap: onTap,
      ),
    );
  }
}
