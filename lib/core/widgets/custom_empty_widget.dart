import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../utils/constants/app_assets.dart';
import 'app_image.dart';

class CustomEmptyWidget extends StatelessWidget {
  final String message;
  final String imagePath;

  const CustomEmptyWidget({
    super.key,
    this.message = 'لا يوجد بيانات متاحة',
    this.imagePath = AppAssets.empty,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 120,
            height: 120,
            child: FittedBox(
              child: imagePath.endsWith('.json')
                  ? Lottie.asset(imagePath)
                  : AppImage(path: imagePath),
            ),
          ),
          Text(
            message,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
