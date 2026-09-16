import 'package:flutter/material.dart';
import '../utils/constants/app_assets.dart';
import '../utils/theme/app_colors.dart';
import '../utils/theme/app_font_styles.dart';
import 'app_image.dart';

class CustomActionsMenu extends StatelessWidget {
  final bool isActive;
  final String activeToggleText;
  final String inactiveToggleText;
  final String deleteText;
  final String viewDetailsText;
  final String editText;
  final VoidCallback onToggleStatus;
  final VoidCallback? onViewDetails;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onResetPassword;
  final String? resetPasswordText;

  const CustomActionsMenu({
    super.key,
    required this.isActive,
    required this.activeToggleText,
    required this.inactiveToggleText,
    required this.deleteText,
    this.viewDetailsText = 'عرض تفاصيل',
    this.editText = 'تعديل البيانات',
    required this.onToggleStatus,
    this.onViewDetails,
    required this.onEdit,
    required this.onDelete,
    this.onResetPassword,
    this.resetPasswordText,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: AppColors.white,
      icon: AppImage.asset(path: AppAssets.more, width: 20, height: 20),
      onSelected: (value) {
        if (value == 'toggle') {
          onToggleStatus();
        } else if (value == 'view') {
          onViewDetails?.call();
        } else if (value == 'edit') {
          onEdit();
        } else if (value == 'reset_password') {
          onResetPassword?.call();
        } else if (value == 'delete') {
          onDelete();
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: 'toggle',
          child: Row(
            children: [
              AppImage.svg(
                path: isActive ? AppAssets.toggleOn : AppAssets.toggleOff,
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 8),
              Text(
                isActive ? activeToggleText : inactiveToggleText,
                style: AppFontStyle.regular14(context),
              ),
            ],
          ),
        ),
        if (onViewDetails != null)
          PopupMenuItem<String>(
            value: 'view',
            child: Row(
              children: [
                AppImage.svg(path: AppAssets.icEye, width: 24, height: 24),
                const SizedBox(width: 8),
                Text(viewDetailsText, style: AppFontStyle.regular14(context)),
              ],
            ),
          ),
        PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            children: [
              AppImage.svg(path: AppAssets.icEdit, width: 24, height: 24),
              const SizedBox(width: 8),
              Text(editText, style: AppFontStyle.regular14(context)),
            ],
          ),
        ),
        if (onResetPassword != null)
          PopupMenuItem<String>(
            value: 'reset_password',
            child: Row(
              children: [
                AppImage.svg(
                  path: AppAssets.lockPassword,
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    AppColors.black,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  resetPasswordText ?? 'إعادة تعيين كلمة المرور',
                  style: AppFontStyle.regular14(context),
                ),
              ],
            ),
          ),
        PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              AppImage.svg(path: AppAssets.icDelete, width: 24, height: 24),
              const SizedBox(width: 8),
              Text(
                deleteText,
                style: AppFontStyle.regular14(
                  context,
                ).copyWith(color: AppColors.red202),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
