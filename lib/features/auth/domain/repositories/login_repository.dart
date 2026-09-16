import '../../data/models/login_response_model.dart';
import '../../data/request_model/login_request_model.dart';

abstract class LoginRepository {
  Future<LoginResponseModel> login(LoginRequestModel request);
}
