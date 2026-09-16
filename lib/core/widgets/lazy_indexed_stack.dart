import 'package:flutter/material.dart';

/// IndexedStack كسول — يبني الصفحة أول مرة بس تزورها
/// وبعد كده يفضل محتفظ بيها في الذاكرة بدون إعادة بناء.
class LazyIndexedStack extends StatefulWidget {
  final int index;
  final List<Widget> children;

  const LazyIndexedStack({
    super.key,
    required this.index,
    required this.children,
  });

  @override
  State<LazyIndexedStack> createState() => _LazyIndexedStackState();
}

class _LazyIndexedStackState extends State<LazyIndexedStack> {
  late final List<bool> _loaded;

  @override
  void initState() {
    super.initState();
    _loaded = List.filled(widget.children.length, false);
    _loaded[widget.index] = true;
  }

  @override
  void didUpdateWidget(covariant LazyIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_loaded[widget.index]) {
      _loaded[widget.index] = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: widget.index,
      children: List.generate(widget.children.length, (i) {
        if (_loaded[i]) {
          return widget.children[i];
        }
        return const SizedBox.shrink();
      }),
    );
  }
}
