import 'package:e_learning_mobile/common/constants/hive_keys.dart';
import 'package:json_annotation/json_annotation.dart';

part 'refresh_token_dto.g.dart';

@JsonSerializable()
class RefreshTokenDTO {
  RefreshTokenDTO({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  factory RefreshTokenDTO.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenDTOFromJson(json);

  @JsonKey(name: 'access_token')
  final String accessToken;
  @JsonKey(name: 'refresh_token')
  final String refreshToken;
  @JsonKey(name: 'expires_in')
  final int expiresIn;

  Map<String, dynamic> toJson() => _$RefreshTokenDTOToJson(this);

  Map<String, dynamic> toLocalJson() {
    return {
      HiveKeys.accessToken: accessToken,
      HiveKeys.refreshToken: refreshToken,
      HiveKeys.expiresIn: expiresIn,
    };
  }
}
