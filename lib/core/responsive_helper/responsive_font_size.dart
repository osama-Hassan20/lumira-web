import 'package:flutter/material.dart';

class ResponsiveFontSize {
  // scaleFactor
  // responsive font size
  // (min , max) font size
  static double getResponsiveFontSize(BuildContext context, double fontSize) {
   // double scaleFactor = getScaleFactor(context);
    // double responsiveFontSize = fontSize * scaleFactor;
    //
    // double lowerLimit = fontSize * 0.8;
    // double upperLimit = fontSize * 1.08;

    return fontSize;
  }

  static double getScaleFactor( BuildContext context) {
    // var dispatcher = PlatformDispatcher.instance;
    // var physicalWidth = dispatcher.views.first.physicalSize.width;
    // var devicePixelRatio = dispatcher.views.first.devicePixelRatio;
    // double width = physicalWidth / devicePixelRatio;

    double width = MediaQuery.sizeOf(context).width;

    if (width < 700) {
      return width / 400;
    } else if (width < 1200) {
      return width / 750;
    } else {
      return width / 1200;
    }
  }
}
