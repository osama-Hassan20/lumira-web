import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/theme/app_colors.dart';
import '../utils/theme/app_size.dart';

class ShimmerCircleAvatarEffect extends StatelessWidget {
  const ShimmerCircleAvatarEffect({super.key, this.radius});

  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.gray2F,
      highlightColor: AppColors.grayF1,
      child: CircleAvatar(
        backgroundColor: AppColors.gray2F,
        radius: radius ?? AppSize.size8,
      ),
    );
  }
}