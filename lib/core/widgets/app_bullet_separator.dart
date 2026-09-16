import 'package:flutter/material.dart';
import '../utils/theme/app_colors.dart';
import '../utils/theme/app_font_styles.dart';

class AppBulletSeparator extends StatelessWidget {
  const AppBulletSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        '•',
        style: AppFontStyle.regular16(
          context,
        ).copyWith(color: AppColors.grey7C),
      ),
    );
  }
}
