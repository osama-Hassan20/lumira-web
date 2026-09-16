import 'package:flutter/material.dart';
import '../utils/theme/app_colors.dart';
import '../utils/theme/app_font_styles.dart';
import 'animated_dialog.dart';
import 'app_image.dart';
import 'custom_button.dart';

class ConfirmationDialog {
  ConfirmationDialog._();

  /// Shows a confirmation dialog.
  ///
  /// If [onConfirmAsync] is provided, the confirm button will show a loading
  /// indicator while the future runs, and the dialog will be non-dismissible
  /// during that time. The dialog closes automatically when [onConfirmAsync]
  /// completes.
  ///
  /// If [onConfirmAsync] is NOT provided, the dialog pops with `true`
  /// immediately on confirm tap (original behaviour).
  static Future<bool?> show({
    required BuildContext context,
    required String iconPath,
    Color iconColor = AppColors.red,
    required String title,
    required String message,
    String cancelText = 'إلغاء',
    String confirmText = 'تأكيد',
    Color? confirmColor,
    VoidCallback? onCancel,
    VoidCallback? onConfirm,
    Future<void> Function()? onConfirmAsync,
  }) {
    final effectiveConfirmColor = confirmColor ?? AppColors.red;

    return showAnimatedDialog<bool>(
      context: context,
      barrierDismissible: onConfirmAsync == null,
      child: _ConfirmationDialogBody(
        iconPath: iconPath,
        iconColor: effectiveConfirmColor,
        title: title,
        message: message,
        cancelText: cancelText,
        confirmText: confirmText,
        confirmColor: effectiveConfirmColor,
        onCancel: onCancel,
        onConfirm: onConfirm,
        onConfirmAsync: onConfirmAsync,
      ),
    );
  }
}

class _ConfirmationDialogBody extends StatefulWidget {
  const _ConfirmationDialogBody({
    required this.iconPath,
    required this.iconColor,
    required this.title,
    required this.message,
    required this.cancelText,
    required this.confirmText,
    required this.confirmColor,
    this.onCancel,
    this.onConfirm,
    this.onConfirmAsync,
  });

  final String iconPath;
  final Color iconColor;
  final String title;
  final String message;
  final String cancelText;
  final String confirmText;
  final Color confirmColor;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;
  final Future<void> Function()? onConfirmAsync;

  @override
  State<_ConfirmationDialogBody> createState() =>
      _ConfirmationDialogBodyState();
}

class _ConfirmationDialogBodyState extends State<_ConfirmationDialogBody> {
  bool _isLoading = false;

  Future<void> _handleConfirm() async {
    if (widget.onConfirmAsync != null) {
      setState(() => _isLoading = true);
      try {
        await widget.onConfirmAsync!();
        if (mounted) {
          Navigator.of(context).pop(true);
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    } else {
      Navigator.of(context).pop(true);
      widget.onConfirm?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isLoading,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: widget.confirmColor.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: AppImage(
                path: widget.iconPath,
                width: 32,
                height: 32,
                color: widget.confirmColor,
              ),
            ),
            const SizedBox(height: 20),
            // Title
            Text(
              widget.title,
              style: AppFontStyle.regular16(
                context,
              ).copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            // Message
            Text(
              widget.message,
              style: AppFontStyle.regular14(
                context,
              ).copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // Buttons
            Row(
              children: [
                // Cancel
                Expanded(
                  child: CustomButton(
                    title: widget.cancelText,
                    isFilled: false,
                    borderColor: AppColors.primary,
                    enabled: !_isLoading,
                    onTap: () {
                      Navigator.of(context).pop(false);
                      widget.onCancel?.call();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                // Confirm
                Expanded(
                  child: CustomButton(
                    title: widget.confirmText,
                    backGroundColor: widget.confirmColor,
                    isLoading: _isLoading,
                    onTap: _handleConfirm,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
