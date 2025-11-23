import 'package:json_annotation/json_annotation.dart';
part 'user_info_dto.g.dart';

@JsonSerializable()
class UserInfoDto {
  @JsonKey(name: 'user_id')
  final String userId;
  final String name;
  final String? avatar;

  UserInfoDto({
    required this.userId,
    required this.name,
    this.avatar,
  });

  factory UserInfoDto.fromJson(Map<String, dynamic> json) =>
      _$UserInfoDtoFromJson(json);
  Map<String, dynamic> toJson() => _$UserInfoDtoToJson(this);
}
