import 'package:flutter/material.dart';
import '../utils/theme/app_colors.dart';

class CustomTabButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final Color? activeBgColor;
  final Color? inactiveBgColor;
  final Color? activeTextColor;
  final Color? inactiveTextColor;
  final double borderRadius;
  final BoxBorder? border;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;

  const CustomTabButton({
    super.key,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.activeBgColor,
    this.inactiveBgColor,
    this.activeTextColor,
    this.inactiveTextColor,
    this.borderRadius = 12.0,
    this.border,
    this.padding,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isActive
        ? (activeBgColor ?? AppColors.yellow)
        : (inactiveBgColor ?? AppColors.yellow.withValues(alpha: 0.12));
    
    final textColor = isActive
        ? (activeTextColor ?? AppColors.dark3B)
        : (inactiveTextColor ?? AppColors.grey6C);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          border: border,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: (textStyle ?? const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          )).copyWith(color: textColor),
        ),
      ),
    );
  }
}
