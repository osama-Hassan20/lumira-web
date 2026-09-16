import 'package:flutter/material.dart';

import '../../../../../core/animations/slide_transition_animation.dart';
import '../../../../../core/extensions/localization_extension.dart';
import '../../../../../core/utils/theme/app_colors.dart';
import '../../../../../core/utils/theme/app_font_styles.dart';

class AnimatedHeader extends StatelessWidget {
  const AnimatedHeader({super.key, required this.context});
  final BuildContext context;

  @override
  Widget build(BuildContext _) {
    return SlideTransitionAnimation(
      duration: const Duration(milliseconds: 400),
      begin: const Offset(0, -0.5),
      end: Offset.zero,
      curve: Curves.easeOutCubic,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.tr('welcome_title'),
            style: AppFontStyle.regular32(
              context,
            ).copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.tr('welcome_description'),
            style: AppFontStyle.regular18(
              context,
            ).copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
