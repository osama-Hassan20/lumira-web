import 'package:flutter/material.dart';

class PopOnResize extends StatefulWidget {
  final Widget child;
  final Set<PopOnResizeTarget> targets;

  const PopOnResize({
    super.key,
    required this.child,
    this.targets = const {PopOnResizeTarget.popupMenu},
  });

  @override
  State<PopOnResize> createState() => _PopOnResizeState();
}

class _PopOnResizeState extends State<PopOnResize> {
  double? _lastWidth;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final width = MediaQuery.of(context).size.width;

    if (_lastWidth != null && width != _lastWidth) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        final navigator = Navigator.of(context, rootNavigator: true);
        if (!navigator.canPop()) return;

        final route = ModalRoute.of(context);

        if (_shouldPop(route)) {
          navigator.pop();
        }
      });
    }

    _lastWidth = width;
  }

  bool _shouldPop(Route<dynamic>? route) {
    if (route == null) return false;

    if (widget.targets.contains(PopOnResizeTarget.all)) {
      return true;
    }

    if (widget.targets.contains(PopOnResizeTarget.popupMenu) &&
        route is PopupRoute &&
        route is! DialogRoute) {
      return true;
    }

    if (widget.targets.contains(PopOnResizeTarget.dialog) &&
        route is DialogRoute) {
      return true;
    }

    if (widget.targets.contains(PopOnResizeTarget.navigation) &&
        route is PageRoute) {
      return true;
    }

    return false;
  }


  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}


enum PopOnResizeTarget {
  popupMenu,      // PopupMenu + SubMenu
  dialog,         // showDialog / AlertDialog
  navigation,     // Pages
  all,            // All
}
