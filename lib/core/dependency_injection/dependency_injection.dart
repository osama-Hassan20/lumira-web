import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_consumer.dart';
import '../api/app_interceptor.dart';
import '../api/dio_consumer.dart';
import '../api/end_points.dart';
import '../cubit/shared_cubit.dart';
import '../../features/splash/presentation/cubit/splash_cubit/splash_cubit.dart';
import '../../features/auth/data/datasources/login_remote_data_source.dart';
import '../../features/auth/data/repositories/login_repository_impl.dart';
import '../../features/auth/domain/repositories/login_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/splash/presentation/cubit/splash_cubit/splash_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â• Core â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

  getIt.registerSingleton<Dio>(
    Dio(
      BaseOptions(
          baseUrl: EndPoints.baseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        )
        ..followRedirects = false
        ..receiveDataWhenStatusError = true,
    ),
  );

  getIt.registerSingleton<DioConsumer>(
    DioConsumer(
      dio: getIt.get<Dio>()
        ..interceptors.add(AppInterceptors(dio: getIt.get<Dio>()))
        ..interceptors.addAll([
          if (kDebugMode)
            PrettyDioLogger(
              request: true,
              requestBody: true,
              responseHeader: true,
              responseBody: true,
              error: true,
              compact: true,
            ),
        ]),
    ),
  );
  getIt.registerSingleton<ApiConsumer>(getIt.get<DioConsumer>());

  getIt.registerSingleton<CancelToken>(CancelToken());

  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â• App Cubits â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

  getIt.registerFactory<SharedCubit>(
    () => SharedCubit(
      sharedPreferences: getIt.get<SharedPreferences>(),
      apiConsumer: getIt.get<ApiConsumer>(),
    ),
  );
  getIt.registerFactory<SplashCubit>(
    () => SplashCubit(sharedPreferences: getIt.get<SharedPreferences>()),
  );

  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â• Auth â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

  getIt.registerLazySingleton<LoginRemoteDataSource>(
    () => LoginRemoteDataSourceImpl(getIt.get<ApiConsumer>()),
  );
  getIt.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(getIt.get<LoginRemoteDataSource>()),
  );
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(getIt.get<LoginRepository>()),
  );
  getIt.registerLazySingleton<AuthCubit>(
    () => AuthCubit(loginUseCase: getIt.get<LoginUseCase>()),
  );
}
