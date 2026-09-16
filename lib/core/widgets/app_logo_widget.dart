import 'package:flutter/material.dart';
import '../utils/constants/app_assets.dart';
import 'app_image.dart';

class AppLogoWidget extends StatelessWidget {
  final double width;
  final BoxFit fit;

  const AppLogoWidget({super.key, this.width = 140, this.fit = BoxFit.contain});

  @override
  Widget build(BuildContext context) {
    return AppImage(path: AppAssets.appLogo, width: width, fit: fit);
  }
}
