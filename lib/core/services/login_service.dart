import '../../features/auth/data/models/login_response_model.dart';
import '../storage/shared_prefs.dart';
import '../utils/constants/app_strings.dart';

/// Centralized login service used across the app.
class LoginService {
  LoginService._();

  /// Sets the login state flag in shared preferences.
  static Future<void> setLoggedIn(bool value) async {
    await SharedPrefHelper.saveData(key: AppStrings.isLoggedIn, value: value);
  }

  /// Checks if the user is logged in.
  static bool isLoggedIn() {
    return SharedPrefHelper.getData(key: AppStrings.isLoggedIn) == true;
  }

  /// Handles saving user authentication data.
  static Future<void> saveAuthData(LoginResponseModel response) async {
    if (response.accessToken != null) {
      await SharedPrefHelper.saveData(
        key: AppStrings.accessToken,
        value: response.accessToken!,
      );
    }
    if (response.refreshToken != null) {
      await SharedPrefHelper.saveData(
        key: AppStrings.refreshToken,
        value: response.refreshToken!,
      );
    }
    await SharedPrefHelper.saveObject(
      key: AppStrings.userData,
      json: response
          .toJson(), // Assuming you have a toJson method in LoginResponseModel
    );
  }
}
