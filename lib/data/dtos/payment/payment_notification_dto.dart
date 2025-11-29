import 'package:json_annotation/json_annotation.dart';

part 'payment_notification_dto.g.dart';

@JsonSerializable()
class PaymentNotificationDto {
  @JsonKey(name: 'user_id')
  final String userId;
  final String type; // PAYMENT_SUCCESS, PAYMENT_FAILED
  final String? title;
  final String? message;
  final String? metadata;

  PaymentNotificationDto({
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    required this.metadata,
  });

  factory PaymentNotificationDto.fromJson(Map<String, dynamic> json) =>
      _$PaymentNotificationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentNotificationDtoToJson(this);
}
