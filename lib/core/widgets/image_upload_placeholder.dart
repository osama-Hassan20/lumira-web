import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../utils/constants/app_assets.dart';
import '../utils/theme/app_colors.dart';
import '../utils/theme/app_font_styles.dart';
import 'app_image.dart';
import 'dashed_border_container.dart';

class ImageUploadPlaceholder extends StatelessWidget {
  const ImageUploadPlaceholder({
    super.key,
    required this.title,
    this.onTap,
    this.imageFile,
    this.imageUrl,
  });

  final String title;
  final VoidCallback? onTap;
  final String? imageFile;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: DashedBorderContainer(
        height: 120,
        radius: 12,
        color: AppColors.primary.withValues(alpha: 0.5),
        backgroundColor: AppColors.primary.withValues(alpha: 0.05),
        child: Center(
          child: imageFile != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: kIsWeb
                      ? Image.network(
                          imageFile!,
                          width: double.infinity,
                          height: 120,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          File(imageFile!),
                          width: double.infinity,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                )
              : imageUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AppImage.network(
                    path: imageUrl!,
                    width: double.infinity,
                    height: 120,
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFFBEB),
                        shape: BoxShape.circle,
                      ),
                      child: AppImage.svg(
                        path: AppAssets.icAddImage,
                        width: 28,
                        height: 28,
                        colorFilter: ColorFilter.mode(
                          AppColors.primary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      style: AppFontStyle.regular14(
                        context,
                      ).copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
