import 'package:flutter/material.dart';
import 'app_image.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double size;

  const CustomCachedNetworkImage({
    super.key,
    required this.imageUrl,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return AppImage.network(
      path: imageUrl,
      width: size,
      height: size,
      borderRadius: BorderRadius.circular(size / 2),
    );
  }
}
