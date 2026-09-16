import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/error_mapper.dart';
import '../../../../core/services/login_service.dart';
import '../../../../core/utils/enum.dart';
import '../../data/request_model/login_request_model.dart';
import '../../domain/usecases/login_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;

  AuthCubit({required this.loginUseCase}) : super(const AuthState());

  static AuthCubit get(BuildContext context) => BlocProvider.of(context);

  void validateUsername(String value) {
    emit(state.copyWith(isUsernameValid: value.trim().length >= 3));
  }

  void validatePassword(String value) {
    emit(state.copyWith(isPasswordValid: value.trim().length >= 6));
  }

  Future<void> login(String username, String password) async {
    emit(state.copyWith(loginStatus: RequestStatus.loading));
    try {
      final response = await loginUseCase(
        LoginRequestModel(username: username, password: password),
      );
      await LoginService.setLoggedIn(true);
      await LoginService.saveAuthData(response);
      emit(
        state.copyWith(loginStatus: RequestStatus.success, loginUser: response),
      );
    } catch (e) {
      if (isClosed) return;
      final errorMessage = mapExceptionToMessage(e);
      emit(
        state.copyWith(loginStatus: RequestStatus.failure, error: errorMessage),
      );
    }
  }

  void clearError() {
    emit(state.copyWith(resetError: true));
  }

}
