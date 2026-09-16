import 'package:dio/dio.dart';
import 'failures.dart';

/// Maps any exception to a user-friendly error message.
/// Handles [DioException] types including connection errors and API response messages.
String mapExceptionToMessage(Object e) {
  if (e is DioException) {
    // Connection errors: no internet, network layer failures
    if (e.type == DioExceptionType.connectionError) {
      return 'No internet connection';
    }
    // Try to extract message from API response body first
    if (e.response?.data != null) {
      final data = e.response!.data;
      if (data is Map && data.containsKey('message')) {
        final msg = data['message'];
        if (msg is String && msg.isNotEmpty) return msg;
      }
    }
    // Fall back to ServerFailure for all other DioException types
    return ServerFailure.fromDioException(dioException: e).errMessage;
  } else if (e is ServerFailure) {
    return e.errMessage;
  }
  return e.toString();
}
