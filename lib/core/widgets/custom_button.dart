import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/theme/app_colors.dart';
import '../utils/theme/app_size.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.onTap,
    required this.title,
    this.leading,
    this.backGroundColor,
    this.isFilled = true,
    this.borderColor,
    this.titleStyle,
    this.width,
    this.height,
    this.isLoading = false,
    this.elevation,
    this.borderRadius,
    this.loadingText,
    this.enabled = true,
  });

  final void Function()? onTap;
  final String title;
  final Widget? leading;
  final Color? backGroundColor, borderColor;
  final bool isFilled, isLoading, enabled;
  final double? width, height, elevation, borderRadius;
  final TextStyle? titleStyle;
  final String? loadingText;

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = !enabled || isLoading;
    final Color buttonColor = backGroundColor ?? AppColors.primary;

    return InkWell(
      onTap: isDisabled ? null : onTap,
      borderRadius: BorderRadius.circular(
        borderRadius ?? AppSize.borderRadiusSize12,
      ),
      child: Container(
        width: width ?? double.infinity,
        height: 44,
        decoration: BoxDecoration(
          color: isDisabled
              ? AppColors.greyShade300
              : isFilled
              ? buttonColor
              : backGroundColor ?? Colors.transparent,
          borderRadius: BorderRadius.circular(
            borderRadius ?? AppSize.borderRadiusSize12,
          ),
          border: isFilled && borderColor == null
              ? null
              : Border.all(
                  width: 1.5,
                  color: isDisabled
                      ? (borderColor ?? AppColors.greyShade300)
                      : borderColor ?? AppColors.primary,
                ),
        ),
        child: Center(
          child: isLoading
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (loadingText != null) ...[
                      FittedBox(
                        child: Text(
                          loadingText!,
                          style:
                              titleStyle ??
                              TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isFilled
                                    ? Colors.white
                                    : backGroundColor,
                              ),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                    const SizedBox(
                      height: 24,
                      width: 24,
                      child: CupertinoActivityIndicator(color: Colors.white),
                    ),
                  ],
                )
              : LayoutBuilder(
                  // إضافة LayoutBuilder هنا للتحكم في الأيقونة
                  builder: (context, constraints) {
                    // إذا كان عرض الزر أقل من 100 بكسل مثلاً، نخفي الأيقونة
                    final bool showLeading =
                        leading != null && constraints.maxWidth > 100;

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            textAlign: TextAlign.center,
                            style:
                                titleStyle ??
                                TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: isFilled
                                      ? Colors.white
                                      : (backGroundColor ?? AppColors.primary),
                                  letterSpacing: 1.2,
                                ),
                          ),
                        ),
                        // تظهر الأيقونة فقط إذا كانت المساحة كافية
                        if (showLeading) ...[
                          const SizedBox(width: 8),
                          leading!,
                        ],
                      ],
                    );
                  },
                ),
        ),
      ),
    );
  }
}
