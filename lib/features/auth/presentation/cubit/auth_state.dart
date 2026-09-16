import '../../../../core/utils/enum.dart';
import '../../data/models/login_response_model.dart';

class AuthState {
  final RequestStatus loginStatus;
  final LoginResponseModel? loginUser;
  final bool isUsernameValid;
  final bool isPasswordValid;
  final String? error;

  const AuthState({
    this.loginStatus = RequestStatus.initial,
    this.loginUser,
    this.isUsernameValid = false,
    this.isPasswordValid = false,
    this.error,
  });

  bool get isLoading => loginStatus == RequestStatus.loading;
  bool get isLoginValid => isUsernameValid && isPasswordValid;

  AuthState copyWith({
    RequestStatus? loginStatus,
    LoginResponseModel? loginUser,
    bool? isUsernameValid,
    bool? isPasswordValid,
    String? error,
    bool resetError = false,
  }) {
    return AuthState(
      loginStatus: loginStatus ?? this.loginStatus,
      loginUser: loginUser ?? this.loginUser,
      isUsernameValid: isUsernameValid ?? this.isUsernameValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      error: resetError ? null : (error ?? this.error),
    );
  }
}
