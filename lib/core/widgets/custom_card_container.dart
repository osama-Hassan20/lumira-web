import 'package:flutter/material.dart';
import '../utils/theme/app_colors.dart';

class CustomCardContainer extends StatelessWidget {
  const CustomCardContainer({
    super.key,
    required this.child,
    this.padding,
    this.radius,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.grayF2,
        borderRadius: BorderRadius.circular(radius ?? 12),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: child,
    );
  }
}
