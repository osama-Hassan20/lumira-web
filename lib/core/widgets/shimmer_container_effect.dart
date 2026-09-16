import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/theme/app_colors.dart';
import '../utils/theme/app_size.dart';

/// A simple rectangular shimmer placeholder.
/// Shorthand alias — same as [ShimmerContainerEffect] but with mandatory [width]/[height].
class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
  });

  final double width;
  final double height;
  final double? borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    return ShimmerContainerEffect(
      width: width,
      height: height,
      borderRadiusNumber: borderRadius,
      baseColor: baseColor,
      highlightColor: highlightColor,
    );
  }
}

/// A circular shimmer placeholder for avatars.
class ShimmerCircleAvatarEffect extends StatelessWidget {
  const ShimmerCircleAvatarEffect({
    super.key,
    required this.radius,
    this.baseColor,
    this.highlightColor,
  });

  final double radius;
  final Color? baseColor;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    return ShimmerContainerEffect(
      width: radius * 2,
      height: radius * 2,
      borderRadius: BorderRadius.circular(radius),
      baseColor: baseColor,
      highlightColor: highlightColor,
    );
  }
}

class ShimmerContainerEffect extends StatelessWidget {
  const ShimmerContainerEffect({
    super.key,
    this.width,
    this.height,
    this.borderRadiusNumber,
    this.baseColor,
    this.highlightColor,
    this.margin,
    this.borderRadius,
  });

  final double? width;
  final double? height;
  final double? borderRadiusNumber;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? margin;
  final Color? baseColor;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? AppColors.gray2F,
      highlightColor: highlightColor ?? AppColors.grayF1,
      child: Container(
        margin: margin,
        width: width,
        height: height ?? AppSize.size10,
        decoration: BoxDecoration(
          color: baseColor ?? AppColors.gray2F,
          borderRadius:
              borderRadius ??
              BorderRadius.circular(borderRadiusNumber ?? AppSize.size8),
        ),
      ),
    );
  }
}
