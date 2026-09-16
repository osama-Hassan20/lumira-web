import '../../domain/repositories/login_repository.dart';
import '../datasources/login_remote_data_source.dart';
import '../models/login_response_model.dart';
import '../request_model/login_request_model.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource dataSource;

  LoginRepositoryImpl(this.dataSource);

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    return await dataSource.login(request);
  }
}
