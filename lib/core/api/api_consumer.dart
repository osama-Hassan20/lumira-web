import 'package:dio/dio.dart';

abstract class ApiConsumer {
  Future<dynamic> get({
    required String path,
    Options? options,
    Object? body,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  });

  Future<dynamic> post({
    required String path,
    Object? body,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  });

  Future<dynamic> put({
    required String path,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  });

  Future<dynamic> delete({
    required String path,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  });

  Future<dynamic> patch({
    required String path,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  });
}
