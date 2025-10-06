import 'package:e_learning_mobile/common/constants/endpoints.dart';
import 'package:e_learning_mobile/common/helpers/dio_helper.dart';
import 'package:e_learning_mobile/data/dtos/auth/login_by_email_request_dto.dart';
import 'package:e_learning_mobile/data/dtos/auth/login_response_dto.dart';
import 'package:e_learning_mobile/data/models/user_model.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class UserRemoteDataSource {
  UserRemoteDataSource({required DioHelper dioHelper}) : _dioHelper = dioHelper;

  final DioHelper _dioHelper;

  Future<LoginResponseDTO> loginByEmail(LoginByEmailRequestDTO params) async {
    final response = await _dioHelper.post(
      Endpoints.login,
      data: params.toJson(),
    );

    return LoginResponseDTO(
      user: UserModel.fromJson(
        response.data['data']['user'] as Map<String, dynamic>,
      ),
      refreshToken: response.data['data']['refresh_token'] as String,
      accessToken: response.data['data']['access_token'] as String,
      expiresIn: response.data['data']['expires_in'] as int,
    );
  }

  Future<UserModel> getUser() async {
    final response = await _dioHelper.get(
      Endpoints.getUser,
    );

    return UserModel.fromJson(response.data['data']);
  }
}
