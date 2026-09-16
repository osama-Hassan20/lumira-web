import 'package:flutter/material.dart';

import '../utils/theme/app_colors.dart';
import '../utils/theme/app_font_styles.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.titleColor,
    this.backgroundColor,
    this.width,
    this.height,
    this.fontSize,
    this.fontWeight,
    this.underline,
  });

  final VoidCallback? onPressed;
  final String title;
  final Color? titleColor;
  final Color? backgroundColor;
  final double? width;
  final double? height;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextDecoration? underline;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      splashColor: backgroundColor ?? Colors.transparent,
      highlightColor: backgroundColor ?? Colors.transparent,
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,

        child: Text(
          title,
          // style: AppFontStyle.regular14(context).copyWith(
          //             color: AppColors.primary,
          //             decoration: TextDecoration.underline,
          //           ),
          style: AppFontStyle.regular12(context).copyWith(
            color: titleColor ?? AppColors.primary,
            fontSize: fontSize,
            fontWeight: fontWeight,
            decoration: underline ?? TextDecoration.underline,
            decorationColor: titleColor ?? AppColors.primary,
          ),
        ),
      ),
    );
  }
}
