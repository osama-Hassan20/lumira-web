import 'package:flutter/material.dart';

import 'screen_width_breakpoints.dart';

class AdaptiveLayout extends StatelessWidget {
  const AdaptiveLayout({
    super.key,
    required this.mobileLayout,
    required this.tabletLayout,
    required this.desktopLayout,
    this.useFullScreenWidth = false,
  });

  final WidgetBuilder mobileLayout;
  final WidgetBuilder tabletLayout;
  final WidgetBuilder desktopLayout;

  /// true → uses full screen width (MediaQuery)
  /// false → uses available width only (LayoutBuilder constraints)
  final bool useFullScreenWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = useFullScreenWidth
            ? MediaQuery.sizeOf(context).width
            : constraints.maxWidth;

        if (width < ScreenWidthBreakpoints.tablet) {
          return mobileLayout(context);
        } else if (width < ScreenWidthBreakpoints.desktop) {
          return tabletLayout(context);
        } else {
          return desktopLayout(context);
        }
      },
    );
  }
}
