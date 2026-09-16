import 'package:flutter/material.dart';
import '../utils/theme/app_colors.dart';
import '../utils/theme/app_size.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.color = AppColors.white,
    this.borderColor = AppColors.gray62,
    this.borderRadius = AppSize.borderRadiusSize12,
    this.width = double.infinity,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color color;
  final Color borderColor;
  final double borderRadius;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final effectiveWidth =
            width == double.infinity && !constraints.hasBoundedWidth
            ? null
            : width;

        return Container(
          width: effectiveWidth,
          padding: padding,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: borderColor, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          ),
          child: child,
        );
      },
    );
  }
}
