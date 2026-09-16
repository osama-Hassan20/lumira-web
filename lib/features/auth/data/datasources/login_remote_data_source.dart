import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../models/login_response_model.dart';
import '../request_model/login_request_model.dart';

abstract class LoginRemoteDataSource {
  Future<LoginResponseModel> login(LoginRequestModel request);
}

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final ApiConsumer apiConsumer;

  LoginRemoteDataSourceImpl(this.apiConsumer);

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    final response = await apiConsumer.post(
      path: EndPoints.login,
      body: request.toJson(),
    );
    return LoginResponseModel.fromJson(response);
  }
}
