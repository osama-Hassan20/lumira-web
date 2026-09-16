import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../utils/theme/app_colors.dart';
class ShimmerBox extends StatelessWidget {
  const ShimmerBox({super.key, 
    required this.height,
    required this.width,
    required this.radius,
    this.margin,
  });

  final double height;
  final double width;
  final double radius;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.gray2F,
      highlightColor: AppColors.grayF1,
      child: Container(
        height: height,
        width: width,
        margin: margin,
        decoration: BoxDecoration(
          color: AppColors.gray2F,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
