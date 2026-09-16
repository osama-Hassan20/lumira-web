import 'dart:developer';

import 'package:flutter/material.dart';

class PopupMenuTracker extends NavigatorObserver {
  static final PopupMenuTracker _instance = PopupMenuTracker._internal();
  static bool _isPopupOpen = false;
  static Route? _currentPopupRoute;

  factory PopupMenuTracker() => _instance;

  PopupMenuTracker._internal();

  static bool get isPopupOpen => _isPopupOpen;

  // Safely close popup if it's open
  static void safelyClosePopup(BuildContext? context) {
    if (_isPopupOpen && _currentPopupRoute != null && context != null) {
      // Use a post-frame callback to ensure we're not in the middle of a build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          if (_currentPopupRoute!.isActive) {
            Navigator.of(context, rootNavigator: true)
                .removeRoute(_currentPopupRoute!);
            _isPopupOpen = false;
            _currentPopupRoute = null;
          }
        } catch (e) {
          log('Error safely closing popup: $e');
        }
      });
    }
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    if (route.runtimeType.toString().contains('PopupMenuRoute')) {
      _isPopupOpen = true;
      _currentPopupRoute = route;
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    if (route.runtimeType.toString().contains('PopupMenuRoute')) {
      _isPopupOpen = false;
      _currentPopupRoute = null;
    }
  }
}
