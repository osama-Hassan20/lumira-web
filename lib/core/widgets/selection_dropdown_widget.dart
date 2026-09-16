import 'package:flutter/material.dart';
import '../utils/theme/app_colors.dart';
import '../utils/theme/app_font_styles.dart';
import 'app_image.dart';

class SelectionDropdownWidget extends StatelessWidget {
  const SelectionDropdownWidget({
    super.key,
    required this.hintText,
    this.selectedText,
    required this.onTap,
    required this.iconPath,
    this.enabled = true,
    this.title,
    this.topPadding,
    this.bottomPadding,
    this.fillColor,
    this.filled = false,
  });

  final String hintText;
  final String? selectedText;
  final VoidCallback onTap;
  final String iconPath;
  final bool enabled;
  final String? title;
  final double? topPadding;
  final double? bottomPadding;
  final Color? fillColor;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final bool hasValue = selectedText != null && selectedText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text(
            title!,
            style: AppFontStyle.medium16(
              context,
            ).copyWith(color: AppColors.textSecondary569),
          ),
        title != null
            ? SizedBox(height: topPadding ?? 8)
            : SizedBox.shrink(),
        GestureDetector(
          onTap: enabled ? onTap : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: filled
                  ? (fillColor ?? const Color(0xFFF5F5F5))
                  : (enabled ? AppColors.white : AppColors.gray2F),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.gray2F, width: 1),
            ),
            child: Row(
              children: [
                // Location/Item Icon
                AppImage.svg(path: iconPath, width: 20, height: 20),
                const SizedBox(width: 12),
                // Selected value or hint
                Expanded(
                  child: Text(
                    hasValue ? selectedText! : hintText,
                    style: hasValue
                        ? AppFontStyle.medium14(
                            context,
                          ).copyWith(color: AppColors.textPrimaryA1A)
                        : AppFontStyle.regular14(
                            context,
                          ).copyWith(color: AppColors.textSecondary569),
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(width: 8),
                // Dropdown arrow
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: enabled
                      ? AppColors.textSecondary569
                      : AppColors.textSecondary569.withAlpha(100),
                  size: 24,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: bottomPadding ?? 8),
      ],
    );
  }
}
