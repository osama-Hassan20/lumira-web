import 'package:flutter/cupertino.dart';

class GridViewPagination extends StatefulWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final void Function() addEvent;
  final Future<void> Function()? onRefresh;
  final bool shrinkWrap;
  final SliverGridDelegate gridDelegate;
  final bool showFooter;
  final Widget? footer;
  final double paginationOffset;
  final EdgeInsets padding;

  const GridViewPagination({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.addEvent,
    this.onRefresh,
    this.shrinkWrap = false,
    required this.gridDelegate,
    this.showFooter = false,
    this.footer,
    this.paginationOffset = 200,
    this.padding = const EdgeInsets.all(8.0),
  });

  @override
  State<GridViewPagination> createState() => _GridViewPaginationState();
}

class _GridViewPaginationState extends State<GridViewPagination> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget footerToShow = widget.footer ?? const SizedBox.shrink();

    return CustomScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        if (widget.onRefresh != null)
          CupertinoSliverRefreshControl(onRefresh: widget.onRefresh!),

        SliverPadding(
          padding: widget.padding,
          sliver: SliverGrid(
            gridDelegate: widget.gridDelegate,
            delegate: SliverChildBuilderDelegate(
              (context, index) => widget.itemBuilder(context, index),
              childCount: widget.itemCount,
            ),
          ),
        ),

        // التعديل هنا: يظهر الـ SliverToBoxAdapter فقط لو showFooter بـ true
        if (widget.showFooter) SliverToBoxAdapter(child: footerToShow),
      ],
    );
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter <= widget.paginationOffset) {
      widget.addEvent();
    }
  }
}
