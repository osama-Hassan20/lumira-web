import 'package:flutter/material.dart';
import '../utils/theme/app_colors.dart';
import '../utils/theme/app_font_styles.dart';

// ─── Shared private shell ────────────────────────────────────────────────────

/// الهيكل المرئي المشترك بين AppFilterDropdown وAppDialogFilterButton.
class _FilterButtonShell extends StatelessWidget {
  final String label;
  final bool isActive; // true = عنصر حقيقي محدد
  final VoidCallback? onClear; // null = لا تظهر ×
  final VoidCallback onTap;
  final bool isFullWidth;
  final Widget? prefixIcon;

  const _FilterButtonShell({
    required this.label,
    required this.isActive,
    required this.onTap,
    this.onClear,
    this.isFullWidth = false,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final bool showClear = isActive && onClear != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        height: 48,
        decoration: BoxDecoration(
          border: Border.all(
            color: isActive
                ? AppColors.primary.withValues(alpha: 0.4)
                : const Color(0xFFD9D9D9),
          ),
          borderRadius: BorderRadius.circular(12),
          color: isActive
              ? AppColors.primary.withValues(alpha: 0.05)
              : AppColors.transparent,
        ),
        child: Row(
          mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
          children: [
            if (prefixIcon != null) ...[prefixIcon!, const SizedBox(width: 8)],
            if (isFullWidth)
              Expanded(
                child: Text(
                  label,
                  style: AppFontStyle.regular14(context).copyWith(
                    color: isActive ? AppColors.primary : AppColors.grey6C,
                  ),
                ),
              )
            else
              Text(
                label,
                style: AppFontStyle.regular14(context).copyWith(
                  color: isActive ? AppColors.primary : AppColors.grey6C,
                ),
              ),
            const SizedBox(width: 4),
            if (showClear)
              GestureDetector(
                onTap: onClear,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Icon(
                    Icons.close_rounded,
                    color: AppColors.primary,
                    size: 16,
                  ),
                ),
              )
            else
              const Padding(
                padding: EdgeInsets.only(right: 6),
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.grey7C,
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── AppFilterDropdown ───────────────────────────────────────────────────────

/// بديل للـ DropdownButton يظهر القائمة **دائماً لأسفل** مهما كان موضع العنصر.
///
/// يُستخدم في أي filter bar داخل التطبيق.
class AppFilterDropdown<T> extends StatefulWidget {
  final T value;
  final String hint;
  final List<AppFilterDropdownItem<T>> items;
  final ValueChanged<T> onChanged;

  /// إذا كان مُعرّفاً، تظهر علامة × عند اختيار عنصر حقيقي
  final VoidCallback? onClear;
  final bool isFullWidth;
  final Widget? prefixIcon;

  const AppFilterDropdown({
    super.key,
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.onClear,
    this.isFullWidth = false,
    this.prefixIcon,
  });

  @override
  State<AppFilterDropdown<T>> createState() => _AppFilterDropdownState<T>();
}

class _AppFilterDropdownState<T> extends State<AppFilterDropdown<T>> {
  final _key = GlobalKey();

  void _openMenu() {
    final box = _key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;

    final offset = box.localToGlobal(Offset.zero);
    final size = box.size;

    showMenu<T>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + size.height + 4,
        offset.dx + size.width,
        0,
      ),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      items: widget.items
          .map(
            (item) => PopupMenuItem<T>(
              value: item.value,
              padding: EdgeInsets.zero,
              child: _MenuItemWidget<T>(
                item: item,
                isSelected: item.value == widget.value,
              ),
            ),
          )
          .toList(),
    ).then((selected) {
      if (selected != null) widget.onChanged(selected);
    });
  }

  @override
  Widget build(BuildContext context) {
    final selected = widget.items
        .where((e) => e.value == widget.value)
        .firstOrNull;
    final bool isHint = selected?.isHint ?? true;

    return KeyedSubtree(
      key: _key,
      child: _FilterButtonShell(
        label: selected?.label ?? widget.hint,
        isActive: !isHint,
        onTap: _openMenu,
        onClear: widget.onClear,
        isFullWidth: widget.isFullWidth,
        prefixIcon: widget.prefixIcon,
      ),
    );
  }
}

// ─── AppDialogFilterButton ───────────────────────────────────────────────────

/// زر فلتر يفتح **دايلوج** عند الضغط (مثل اختيار الباقة أو القسم).
class AppDialogFilterButton extends StatelessWidget {
  final String hint;
  final String? selectedLabel;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  const AppDialogFilterButton({
    super.key,
    required this.hint,
    required this.onTap,
    this.selectedLabel,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return _FilterButtonShell(
      label: selectedLabel ?? hint,
      isActive: selectedLabel != null,
      onTap: onTap,
      onClear: onClear,
    );
  }
}

// ─── AppFilterDropdownItem ───────────────────────────────────────────────────

/// عنصر واحد داخل الـ dropdown
class AppFilterDropdownItem<T> {
  final T value;
  final String label;

  /// إذا كان هذا العنصر هو الـ placeholder (مثلاً "الكل")
  final bool isHint;

  const AppFilterDropdownItem({
    required this.value,
    required this.label,
    this.isHint = false,
  });
}

// ─── Private menu item ────────────────────────────────────────────────────────

class _MenuItemWidget<T> extends StatelessWidget {
  final AppFilterDropdownItem<T> item;
  final bool isSelected;

  const _MenuItemWidget({required this.item, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: isSelected
          ? AppColors.primary.withValues(alpha: 0.07)
          : Colors.transparent,
      child: Text(
        item.label,
        style: AppFontStyle.regular14(context).copyWith(
          color: item.isHint || !isSelected
              ? AppColors.grey6C
              : AppColors.primary,
        ),
      ),
    );
  }
}
