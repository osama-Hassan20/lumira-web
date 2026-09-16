import 'package:flutter/material.dart';
import '../utils/theme/app_colors.dart';
import '../utils/theme/app_font_styles.dart';
import 'app_card.dart';

class AppCustomTable<T> extends StatelessWidget {
  final Widget header;
  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final int total;
  final int page;
  final int limit;
  final ValueChanged<int>? onPageChanged;
  final bool scrollable;
  final double minWidth;
  final bool showPagination;

  const AppCustomTable({
    super.key,
    required this.header,
    required this.items,
    required this.itemBuilder,
    this.total = 0,
    this.page = 1,
    this.limit = 20,
    this.onPageChanged,
    this.scrollable = false,
    this.minWidth = 1000,
    this.showPagination = true,
  });

  @override
  Widget build(BuildContext context) {
    final int totalPages = (total / limit).ceil();

    return AppCard(
      borderColor: const Color(0xFFE2E8F0),
      padding: EdgeInsets.zero,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double tableWidth = constraints.maxWidth > minWidth
              ? constraints.maxWidth
              : minWidth;

          final tableBody = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: scrollable ? MainAxisSize.max : MainAxisSize.min,
            children: [
              header,
              if (items.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Center(
                    child: Text(
                      'لا توجد بيانات',
                      style: AppFontStyle.regular16(
                        context,
                      ).copyWith(color: AppColors.grey7C),
                    ),
                  ),
                )
              else if (scrollable)
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return itemBuilder(context, items[index], index);
                    },
                  ),
                )
              else
                ...items.asMap().entries.map((e) {
                  return itemBuilder(context, e.value, e.key);
                }),
            ],
          );

          final scrollView = SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: tableWidth,
              height: scrollable ? double.infinity : null,
              child: tableBody,
            ),
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: scrollable ? MainAxisSize.max : MainAxisSize.min,
            children: [
              if (scrollable) Expanded(child: scrollView) else scrollView,
              if (totalPages > 1 && showPagination)
                AppTablePagination(
                  page: page,
                  totalPages: totalPages,
                  onPageChanged: onPageChanged,
                ),
            ],
          );
        },
      ),
    );
  }
}

class AppTablePagination extends StatelessWidget {
  final int page;
  final int totalPages;
  final ValueChanged<int>? onPageChanged;
  final BorderRadius? borderRadius;
  final Color backgroundColor;

  const AppTablePagination({
    super.key,
    required this.page,
    required this.totalPages,
    this.onPageChanged,
    this.borderRadius,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    List<int> visiblePages = [];
    if (totalPages <= 5) {
      visiblePages = List.generate(totalPages, (index) => index + 1);
    } else {
      if (page <= 3) {
        visiblePages = [1, 2, 3, 4, -1, totalPages];
      } else if (page >= totalPages - 2) {
        visiblePages = [
          1,
          -1,
          totalPages - 3,
          totalPages - 2,
          totalPages - 1,
          totalPages,
        ];
      } else {
        visiblePages = [1, -1, page - 1, page, page + 1, -1, totalPages];
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius:
            borderRadius ??
            const BorderRadius.vertical(bottom: Radius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildIconPageButton(
            context,
            isNext: false,
            onTap: page > 1 ? () => onPageChanged?.call(page - 1) : null,
          ),
          const SizedBox(width: 8),
          ...visiblePages.map((pageNum) {
            if (pageNum == -1) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  '...',
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 16),
                ),
              );
            }
            return _buildPageNumber(context, pageNum);
          }),
          const SizedBox(width: 8),
          _buildIconPageButton(
            context,
            isNext: true,
            onTap: page < totalPages
                ? () => onPageChanged?.call(page + 1)
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildPageNumber(BuildContext context, int pageNum) {
    final isActive = pageNum == page;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: InkWell(
        onTap: () => onPageChanged?.call(pageNum),
        borderRadius: BorderRadius.circular(50),
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppColors.primary : Colors.white,
            border: isActive
                ? null
                : Border.all(color: const Color(0xFF94A3B8)),
          ),
          child: Text(
            '$pageNum',
            style: AppFontStyle.regular16(context).copyWith(
              color: isActive ? AppColors.white : AppColors.textPrimary,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconPageButton(
    BuildContext context, {
    required bool isNext,
    required VoidCallback? onTap,
  }) {
    final IconData iconData = Directionality.of(context) == TextDirection.rtl
        ? (isNext ? Icons.chevron_left : Icons.chevron_right)
        : (isNext ? Icons.chevron_right : Icons.chevron_left);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: const Color(0xFF94A3B8)),
        ),
        child: Icon(
          iconData,
          color: onTap == null ? const Color(0xFF94A3B8) : AppColors.primary,
          size: 24,
        ),
      ),
    );
  }
}
