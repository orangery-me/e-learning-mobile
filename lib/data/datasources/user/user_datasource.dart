import 'package:e_learning_mobile/data/datasources/user/local/user_datasource.dart';
import 'package:e_learning_mobile/data/datasources/user/remote/user_datasource.dart';
import 'package:e_learning_mobile/data/dtos/auth/login_by_email_request_dto.dart';
import 'package:e_learning_mobile/data/models/user_model.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class UserDataSource {
  UserDataSource({
    required UserRemoteDataSource remoteDataSource,
    required UserLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  final UserRemoteDataSource _remoteDataSource;
  final UserLocalDataSource _localDataSource;

  Future<UserModel> loginByEmail(LoginByEmailRequestDTO params) async {
    final loginResponse = await _remoteDataSource.loginByEmail(params);

    await _localDataSource.setUserAuth(loginResponse);

    final user = await _remoteDataSource.getUser();

    await _localDataSource.setUserInfo(user);

    return user;
  }

  UserModel? getUserInfo() {
    return _localDataSource.getUserInfo();
  }
}
