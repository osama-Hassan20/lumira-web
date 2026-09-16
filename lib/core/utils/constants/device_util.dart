import 'package:flutter/material.dart';

import '../../responsive_helper/screen_width_breakpoints.dart';

class DeviceUtils {
  DeviceUtils._();

  static bool isMobile(BuildContext context) {
    return MediaQuery.sizeOf(context).width < ScreenWidthBreakpoints.tablet;
  }

  static bool isTablet(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return w >= ScreenWidthBreakpoints.tablet &&
        w < ScreenWidthBreakpoints.desktop;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= ScreenWidthBreakpoints.desktop;
  }

  /// Returns a value based on current screen size breakpoint.
  static T valueDecider<T>(
    BuildContext context, {
    required T onMobile,
    required T onTablet,
    required T onDesktop,
  }) {
    if (isDesktop(context)) return onDesktop;
    if (isTablet(context)) return onTablet;
    return onMobile;
  }
}
