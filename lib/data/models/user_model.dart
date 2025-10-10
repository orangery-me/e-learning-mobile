import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable(createToJson: true)
class UserModel {
  UserModel({
    required this.email,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.activeStatus,
    required this.provider,
    required this.active,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  final String email;
  final String id;
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;
  final String role;
  @JsonKey(name: 'active_status')
  final String activeStatus;
  final String provider;
  final bool active;
}