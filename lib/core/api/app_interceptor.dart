import 'dart:developer';
import 'package:dio/dio.dart';

import '../storage/shared_prefs.dart';
import '../../config/app_constants.dart';
import '../services/logout_service.dart';
import '../utils/constants/app_strings.dart';
import 'end_points.dart';
import 'status_code.dart';

class AppInterceptors extends Interceptor {
  final Dio dio;

  // لإدارة تحديث التوكن ومنع التكرار
  bool _isRefreshing = false;
  final List<Function()> _requestQueue = [];

  AppInterceptors({required this.dio});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    bool pathMatches(String path, String endpoint) {
      final normalized = path.split('?').first;
      return normalized.endsWith(endpoint) || normalized.endsWith('$endpoint/');
    }

    // 1. استثناء صفحة تسجيل الدخول من إضافة الـ Token
    final authPaths = [EndPoints.login];
    final bool isAuthPath = authPaths.any((p) => pathMatches(options.path, p));

    final accessToken = await SharedPrefHelper.getData(
      key: AppStrings.accessToken,
    );

    if (!isAuthPath && accessToken != null && accessToken.isNotEmpty) {
      options.headers[AppConstants.authorization] = 'Bearer $accessToken';
    }

    // إضافة اللغة بشكل دائم
    options.headers[AppConstants.xLocale] =
        SharedPrefHelper.getData(key: AppStrings.currentLanguage) ??
        AppStrings.english;

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log(
      "✅ Response [${response.statusCode}] => PATH: ${response.requestOptions.path}",
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    final errorMessage = err.message ?? 'Unknown error';
    final responseBody = err.response?.data;

    log(
      "🔥 onError intercepted: $statusCode | PATH: ${err.requestOptions.path}\n"
      "📝 Message: $errorMessage\n"
      "📦 Response: $responseBody",
    );

    // مسارات المصادقة — لا يتم تطبيق أي منطق للـ Token أو الـ Logout عليها
    final authPaths = [EndPoints.login];

    final isAuthRequest = authPaths.any(
      (p) =>
          err.requestOptions.path.endsWith(p) ||
          err.requestOptions.path.endsWith('$p/'),
    );
    if (isAuthRequest) {
      return handler.next(err);
    }

    // معالجة خطأ Unauthorized (401)
    if (statusCode == StatusCode.unauthorized) {
      final originalRequest = err.requestOptions;

      // إذا كان الخطأ جاي من ريكويست الـ Refresh نفسه، اخرج فوراً
      if (originalRequest.path.contains(EndPoints.refreshToken)) {
        _performLogout();
        return handler.next(err);
      }

      // إذا كان هناك عملية تحديث توكن جارية بالفعل، ضع الريكويست في الطابور
      if (_isRefreshing) {
        log("⏳ Queuing request...");
        _requestQueue.add(() async {
          final oldToken = await SharedPrefHelper.getData(
            key: AppStrings.accessToken,
          );
          originalRequest.headers[AppConstants.authorization] =
              'Bearer $oldToken';
          handler.resolve(await dio.fetch(originalRequest));
        });
        return;
      }

      _isRefreshing = true;

      try {
        final newToken = await _refreshToken();
        _isRefreshing = false;

        if (newToken != null) {
          // تحديث الهيدر للريكويست الحالي وإعادة محاولته
          originalRequest.headers[AppConstants.authorization] =
              'Bearer $newToken';

          // تنفيذ كل الطلبات اللي كانت مستنية في الطابور
          for (var callback in _requestQueue) {
            await callback();
          }
          _requestQueue.clear();

          log("🔁 Retrying original request...");
          return handler.resolve(await dio.fetch(originalRequest));
        } else {
          _performLogout();
          return handler.next(err);
        }
      } catch (e) {
        _isRefreshing = false;
        _performLogout();
        return handler.next(err);
      }
    }
    // معالجة الـ Forbidden أو حالات أخرى تستوجب تسجيل الخروج
    else if (statusCode == StatusCode.forbidden ||
        statusCode == StatusCode.found) {
      _performLogout();
    }

    return handler.next(err);
  }

  // دالة تحديث التوكن المنفصلة
  Future<String?> _refreshToken() async {
    log("🔄 Attempting to refresh token...");
    final refreshToken = await SharedPrefHelper.getData(
      key: AppStrings.refreshToken,
    );

    if (refreshToken == null) return null;

    try {
      // نستخدم baseUrl الصافي لضمان الوصول للـ endpoint صح
      final response = await dio.post(
        EndPoints.refreshToken,
        data: {"token": refreshToken},
        options: Options(
          headers: {AppConstants.contentType: AppConstants.applicationJson},
        ),
      );

      final newAccessToken = response.data['token'];

      if (newAccessToken != null) {
        await SharedPrefHelper.saveData(
          key: AppStrings.accessToken,
          value: newAccessToken,
        );
      }

      return newAccessToken;
    } catch (e) {
      log("❌ Refresh Token Error: $e");
      return null;
    }
  }

  // دالة تسجيل الخروج ومسح البيانات
  void _performLogout() {
    log("🚨 Performing Auto Logout...");
    LogoutService.logout();
  }
}
