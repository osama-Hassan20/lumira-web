import 'screen_width_breakpoints.dart';
import 'package:flutter/cupertino.dart';

extension ResponsiveAppExtensions on BuildContext {
  double get width => MediaQuery.sizeOf(this).width;
  double get height => MediaQuery.sizeOf(this).height;

  bool get isMobile => width < ScreenWidthBreakpoints.tablet;
  bool get isTablet =>
      width >= ScreenWidthBreakpoints.tablet &&
      width < ScreenWidthBreakpoints.desktop;
  bool get isDesktop => width >= ScreenWidthBreakpoints.desktop;

  /// Returns a value based on current screen size breakpoint.
  T withFormFactor<T>({
    required T onMobile,
    required T onTablet,
    required T onDesktop,
  }) {
    if (isDesktop) return onDesktop;
    if (isTablet) return onTablet;
    return onMobile;
  }
}
