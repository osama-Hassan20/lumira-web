import 'package:flutter/material.dart';
import '../responsive_helper/responsive_app_extensions.dart';
import '../utils/theme/app_colors.dart';
import '../utils/theme/app_font_styles.dart';
import '../utils/theme/app_size.dart';

/// A responsive period/tab selector.
///
/// - Desktop/Tablet: horizontal row of chips (scrollable on tablet).
/// - Mobile: dropdown button.
///
/// Supports a special "custom" item (e.g. date range picker) via
/// [customLabel], [customIcon], [isCustomSelected], [onCustomTap],
/// and [customDisplayLabel] (shown when custom is active).
class PeriodSelector extends StatelessWidget {
  final List<String> periods;
  final String? selected;
  final ValueChanged<String> onChanged;
  final String? customLabel;
  final Widget? customIcon;
  final bool isCustomSelected;
  final VoidCallback? onCustomTap;
  final String? customDisplayLabel;
  final VoidCallback? onClearSelection;

  const PeriodSelector({
    super.key,
    required this.periods,
    required this.selected,
    required this.onChanged,
    this.customLabel,
    this.customIcon,
    this.isCustomSelected = false,
    this.onCustomTap,
    this.customDisplayLabel,
    this.onClearSelection,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint(
      'PeriodSelector: selected="$selected", isCustomSelected=$isCustomSelected, periods=${periods.map((p) => p.trim()).toList()}',
    );
    if (context.isMobile) {
      // حالة تحديد تاريخ مخصص
      if (isCustomSelected && customDisplayLabel != null) {
        return _PeriodChip(
          label: customDisplayLabel!,
          isSelected: true,
          icon: customIcon,
          onTap: onCustomTap,
          onClear: onClearSelection,
        );
      }
      // حالة تحديد فترة عادية — نعرض chip زرقاء بنفس شكل الديسكتوب
      if (selected != null && selected!.trim().isNotEmpty) {
        return _PeriodChip(
          label: selected!.trim(),
          isSelected: true,
          onTap: () => onChanged(selected!.trim()),
          onClear: onClearSelection,
        );
      }
      // مفيش حاجه متحدده — نعرض dropdown
      return _buildDropdown(context);
    }
    return _buildChips(context);
  }

  Widget _buildChips(BuildContext context) {
    debugPrint('PeriodSelector._buildChips: selected="$selected"');
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...periods.map((period) {
          final isSelected =
              period.trim() == (selected?.trim() ?? '') && !isCustomSelected;
          debugPrint(
            ' - comparing period="${period.trim()}" -> isSelected=$isSelected',
          );
          return Padding(
            padding: const EdgeInsetsDirectional.only(end: AppSize.size8),
            child: _PeriodChip(
              label: period,
              isSelected: isSelected,
              onTap: () => onChanged(period),
              onClear: isSelected ? onClearSelection : null,
            ),
          );
        }),
        if (customLabel != null)
          _PeriodChip(
            label: isCustomSelected && customDisplayLabel != null
                ? customDisplayLabel!
                : customLabel!,
            isSelected: isCustomSelected,
            icon: customIcon,
            onTap: onCustomTap,
            onClear: isCustomSelected ? onClearSelection : null,
          ),
      ],
    );
  }

  Widget _buildDropdown(BuildContext context) {
    final allItems = [
      ...periods.map((p) => p.trim()),
      if (customLabel != null) customLabel!.trim(),
    ];

    final effectiveValue = isCustomSelected
        ? customLabel!.trim()
        : (selected != null && allItems.contains(selected!.trim())
              ? selected!.trim()
              : null);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSize.size12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSize.size8),
        border: Border.all(color: AppColors.gray2F),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: effectiveValue,
          hint: Text(
            'اختر الفترة',
            style: AppFontStyle.medium13(
              context,
            ).copyWith(color: AppColors.gray2F),
          ),
          isDense: true,
          icon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (customIcon != null) ...[
                const SizedBox(width: AppSize.size8),
                customIcon!,
              ],
              const SizedBox(width: AppSize.size4),
              const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.gray2F,
                size: 20,
              ),
            ],
          ),
          style: AppFontStyle.medium13(
            context,
          ).copyWith(color: AppColors.textPrimary),
          items: allItems
              .map((p) => DropdownMenuItem(value: p, child: Text(p)))
              .toList(),
          onChanged: (v) {
            if (v == null) return;
            if (v == customLabel) {
              onCustomTap?.call();
            } else {
              onChanged(v);
            }
          },
        ),
      ),
    );
  }
}

class _PeriodChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Widget? icon;
  final VoidCallback? onTap;
  final VoidCallback? onClear;

  const _PeriodChip({
    required this.label,
    required this.isSelected,
    this.icon,
    this.onTap,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSize.size8),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSize.size16,
          vertical: AppSize.size8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(AppSize.size8),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.gray2F,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[icon!, const SizedBox(width: AppSize.size8)],
            Text(
              label,
              style: AppFontStyle.medium13(context).copyWith(
                color: isSelected ? AppColors.white : AppColors.textSecondary,
              ),
            ),
            if (onClear != null) ...[
              const SizedBox(width: AppSize.size8),
              GestureDetector(
                onTap: onClear,
                child: Icon(
                  Icons.close,
                  size: 14,
                  color: isSelected ? AppColors.white : AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
