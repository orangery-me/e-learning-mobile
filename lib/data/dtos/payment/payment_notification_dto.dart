import 'package:json_annotation/json_annotation.dart';

part 'payment_notification_dto.g.dart';

@JsonSerializable()
class PaymentNotificationDto {
  final String userId;
  final String type; // PAYMENT_SUCCESS, PAYMENT_FAILED
  final String title;
  final String message;
  final String orderCode;
  final String paymentStatus;
  final Map<String, String> metadata;

  PaymentNotificationDto({
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    required this.orderCode,
    required this.paymentStatus,
    required this.metadata,
  });

  factory PaymentNotificationDto.fromJson(Map<String, dynamic> json) =>
      _$PaymentNotificationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentNotificationDtoToJson(this);
}
