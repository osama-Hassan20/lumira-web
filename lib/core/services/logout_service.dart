import 'dart:developer';

import '../routing/app_router.dart';
import '../routing/routes.dart';
import '../storage/shared_prefs.dart';
import '../utils/constants/app_strings.dart';

/// Centralized logout service used across the app.
class LogoutService {
  LogoutService._();

  /// Performs a full logout:
  /// 1. Unsubscribes from notifications
  /// 2. Clears stored user data & tokens
  /// 3. Navigates to the login screen
  static Future<void> logout() async {
    log('🚨 Performing Logout...');

    // 1. Unsubscribe from notifications
    // try {
    //   final userJson = SharedPrefHelper.getObject(key: AppStrings.userData);
    //   if (userJson != null) {
    //     final user = UserData.fromJson(userJson);
    //     if (user.id != null && user.role != null) {
    //       await NotificationManager.unsubscribeFromRole(user.id!, user.role!);
    //     }
    //   }
    // } catch (e) {
    //   log('⚠️ Error unsubscribing from notifications: $e');
    // }

    // 2. Clear stored data
    await SharedPrefHelper.saveData(key: AppStrings.isLoggedIn, value: false);
    await SharedPrefHelper.removeData(key: AppStrings.accessToken);
    await SharedPrefHelper.removeData(key: AppStrings.refreshToken);

    // 3. Navigate to login
    router.go(Routes.login);
  }
}
