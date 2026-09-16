import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../utils/theme/app_colors.dart'; // تأكد من استيراد المكتبة

class ListViewPagination extends StatefulWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final Widget Function(BuildContext context, int index)? separatorBuilder;

  /// callback invoked when the scroll reaches the pagination offset.
  ///
  /// The function is awaited so the widget can avoid re-triggering while a
  /// previous request is ongoing.
  final Future<void> Function() addEvent;
  final Future<void> Function()? onRefresh;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final Axis scrollDirection;
  final ScrollController? externalScrollController;
  final bool showFooter;
  final Widget? footer; // optional custom footer widget
  final double paginationOffset;

  const ListViewPagination({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.addEvent,
    this.onRefresh,
    this.shrinkWrap = false,
    this.physics,
    this.scrollDirection = Axis.vertical,
    this.externalScrollController,
    this.separatorBuilder,
    this.showFooter = false,
    this.footer,
    this.paginationOffset = 200,
  });

  @override
  State<ListViewPagination> createState() => _ListViewPaginationState();
}

class _ListViewPaginationState extends State<ListViewPagination> {
  final ScrollController _scrollController = ScrollController();
  ScrollController? _externalScrollController;

  ScrollController get _activeScrollController =>
      widget.externalScrollController ?? _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _externalScrollController = widget.externalScrollController;
    _externalScrollController?.addListener(_onScroll);
    _checkAutoLoad();
  }

  @override
  void didUpdateWidget(covariant ListViewPagination oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.externalScrollController != widget.externalScrollController) {
      oldWidget.externalScrollController?.removeListener(_onScroll);
      _externalScrollController = widget.externalScrollController;
      _externalScrollController?.addListener(_onScroll);
    }
    if (widget.itemCount != oldWidget.itemCount ||
        widget.showFooter != oldWidget.showFooter) {
      _checkAutoLoad();
    }
  }

  /// تحميل تلقائي لو المحتوى مش مالي الشاشة وفيه صفحات تانية
  void _checkAutoLoad() {
    if (!widget.showFooter) return;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final controller = _activeScrollController;
      if (!controller.hasClients) return;
      final position = controller.position;
      if (position.maxScrollExtent <= 0 ||
          position.extentAfter <= widget.paginationOffset) {
        if (!_isLoading) {
          _isLoading = true;
          widget.addEvent().whenComplete(() {
            if (mounted) _isLoading = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    widget.externalScrollController?.removeListener(_onScroll);
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  // ميثود مساعدة لإنشاء الـ Footer الافتراضي
  Widget _buildDefaultFooter() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: CupertinoActivityIndicator(
          color: AppColors.primary,
        ), // مؤشر تحميل بسيط من Cupertino
        // child: Lottie.asset(
        //   'assets/lottie/loading.json', // استبدله بـ AppAssets.loading بتاعك
        //   width: 120,
        //   height: 120,
        // ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // determine footer display and widget
    final bool displayFooter = widget.showFooter;
    final Widget footerWidget = widget.footer ?? _buildDefaultFooter();

    final int totalCount = widget.itemCount + (displayFooter ? 1 : 0);

    Widget listView;
    if (widget.separatorBuilder != null) {
      // use separated list; separators only between actual items
      listView = ListView.separated(
        controller: _scrollController,
        scrollDirection: widget.scrollDirection,
        physics:
            widget.physics ??
            const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
        shrinkWrap: widget.shrinkWrap,
        itemCount: totalCount,
        separatorBuilder: (ctx, idx) {
          // don't show separator after footer
          if (displayFooter && idx == widget.itemCount - 1) {
            return const SizedBox();
          }
          return widget.separatorBuilder!(ctx, idx);
        },
        itemBuilder: (ctx, idx) {
          if (displayFooter && idx == widget.itemCount) {
            return footerWidget;
          }
          return widget.itemBuilder(ctx, idx);
        },
      );
    } else {
      listView = ListView.builder(
        controller: _scrollController,
        scrollDirection: widget.scrollDirection,
        physics:
            widget.physics ??
            const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
        shrinkWrap: widget.shrinkWrap,
        itemCount: totalCount,
        itemBuilder: (ctx, idx) {
          if (displayFooter && idx == widget.itemCount) {
            return footerWidget;
          }
          return widget.itemBuilder(ctx, idx);
        },
      );
    }

    if (widget.onRefresh != null) {
      // wrap with RefreshIndicator
      return RefreshIndicator(
        onRefresh: widget.onRefresh!,
        color: AppColors.primary,
        child: listView,
      );
    }

    return listView;
  }

  bool _isLoading = false;

  void _onScroll() {
    if (_isLoading) return;
    final controller = _activeScrollController;
    if (!controller.hasClients) return;
    if (controller.position.extentAfter <= widget.paginationOffset) {
      _isLoading = true;
      widget.addEvent().whenComplete(() {
        _isLoading = false;
      });
    }
  }
}
