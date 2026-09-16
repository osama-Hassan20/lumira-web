import 'dart:developer';
import 'package:dio/dio.dart';

import '../api/status_code.dart';

abstract class Failures {
  final String errMessage;

  Failures({required this.errMessage});
}

class ServerFailure extends Failures {
  ServerFailure({required super.errMessage});

  factory ServerFailure.fromDioException({required DioException dioException}) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure(errMessage: 'انتهت مهلة الاتصال');
      case DioExceptionType.sendTimeout:
        return ServerFailure(errMessage: 'انتهت مهلة الإرسال');
      case DioExceptionType.receiveTimeout:
        return ServerFailure(errMessage: 'انتهت مهلة الاستقبال');
      case DioExceptionType.badCertificate:
        return ServerFailure(errMessage: 'شهادة غير صالحة');
      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
          statusCode: dioException.response?.statusCode,
          response: dioException.response?.data,
        );

      case DioExceptionType.cancel:
        return ServerFailure(errMessage: 'تم إلغاء الطلب');
      case DioExceptionType.connectionError:
        return ServerFailure(errMessage: 'لا يوجد اتصال بالإنترنت');
      case DioExceptionType.unknown:
      default:
        return ServerFailure(errMessage: 'حدث خطأ غير متوقع');
    }
  }

  factory ServerFailure.fromResponse({int? statusCode, dynamic response}) {
    log("statusCode : $statusCode");
    log("response : $response");
    final responseMessage = response is Map ? response['message'] : response;
    final hasMessage = responseMessage is String && responseMessage.isNotEmpty;

    if (statusCode == StatusCode.badRequest ||
        statusCode == StatusCode.unprocessableEntity ||
        statusCode == StatusCode.conflict ||
        statusCode == StatusCode.notFound ||
        statusCode == StatusCode.tooManyRequests ||
        statusCode == StatusCode.hugeDataBody ||
        statusCode == StatusCode.unauthorized) {
      return ServerFailure(
        errMessage: hasMessage ? responseMessage : 'حدث خطأ غير متوقع',
      );
    } else if (statusCode == 422) {
      String? validationMessage;
      if (response is Map &&
          response['errors'] is List &&
          response['errors'].isNotEmpty &&
          response['errors'][0] is Map &&
          response['errors'][0]['message'] is String) {
        validationMessage = response['errors'][0]['message'] as String;
      }
      return ServerFailure(
        errMessage: validationMessage?.isNotEmpty == true
            ? validationMessage!
            : 'خطأ في التحقق من البيانات',
      );
    } else if (statusCode == 500) {
      return ServerFailure(errMessage: 'خطأ في الخادم');
    } else if (statusCode == 403) {
      return ServerFailure(
        errMessage: hasMessage ? responseMessage : 'انتهت صلاحية الجلسة',
      );
    } else {
      return ServerFailure(errMessage: 'حدث خطأ، يرجى المحاولة لاحقاً');
    }
  }
}
