// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfoDto _$UserInfoDtoFromJson(Map<String, dynamic> json) => UserInfoDto(
      userId: json['user_id'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String,
    );

Map<String, dynamic> _$UserInfoDtoToJson(UserInfoDto instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'name': instance.name,
      'avatar': instance.avatar,
    };
