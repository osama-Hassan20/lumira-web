import '../../data/models/login_response_model.dart';
import '../../data/request_model/login_request_model.dart';
import '../repositories/login_repository.dart';

class LoginUseCase {
  final LoginRepository repository;

  LoginUseCase(this.repository);

  Future<LoginResponseModel> call(LoginRequestModel request) async {
    return await repository.login(request);
  }
}
