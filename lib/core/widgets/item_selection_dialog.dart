import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/enum.dart';
import '../utils/theme/app_colors.dart';
import '../utils/theme/app_font_styles.dart';
import '../utils/theme/app_size.dart';
import 'animated_dialog.dart';
import 'custom_empty_widget.dart';
import 'custom_error_widget.dart';

class ItemSelectionDialog<T> extends StatelessWidget {
  const ItemSelectionDialog({
    super.key,
    required this.title,
    required this.items,
    required this.displayName,
    required this.onSelect,
    this.status = RequestStatus.success,
    this.error,
    this.onRetry,
  });

  final String title;
  final List<T> items;
  final String Function(T) displayName;
  final Function(T) onSelect;
  final RequestStatus status;
  final String? error;
  final VoidCallback? onRetry;

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required List<T> items,
    required String Function(T) displayName,
    RequestStatus status = RequestStatus.success,
    String? error,
    VoidCallback? onRetry,
  }) {
    return showAnimatedDialog<T>(
      context: context,
      child: ItemSelectionDialog<T>(
        title: title,
        items: items,
        displayName: displayName,
        status: status,
        error: error,
        onRetry: onRetry,
        onSelect: (item) => Navigator.of(context).pop(item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(AppSize.size16),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: AppFontStyle.bold18(
                    context,
                  ).copyWith(color: AppColors.white),
                ),
              ],
            ),
          ),
          // Content
          Flexible(child: _buildContent(context)),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (status == RequestStatus.loading) {
      return Padding(
        padding: EdgeInsets.all(AppSize.size32),
        child: Center(
          child: CupertinoActivityIndicator(
            radius: 24,
            color: AppColors.primary,
          ),
        ),
      );
    }

    if (status == RequestStatus.failure) {
      return Padding(
        padding: const EdgeInsets.all(AppSize.size32),
        child: CustomErrorWidget(
          message: error ?? 'حدث خطأ في التحميل',
          onRetry: onRetry,
        ),
      );
    }

    if (items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(AppSize.size32),
        child: CustomEmptyWidget(message: 'لا توجد بيانات'),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: AppSize.size8),
      itemCount: items.length,
      separatorBuilder: (_, _) => const Divider(
        height: 1,
        indent: AppSize.size16,
        endIndent: AppSize.size16,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          onTap: () => onSelect(item),
          title: Text(
            displayName(item),
            style: AppFontStyle.medium16(context),
            textAlign: TextAlign.center,
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: AppColors.textSecondary569,
          ),
        );
      },
    );
  }
}
