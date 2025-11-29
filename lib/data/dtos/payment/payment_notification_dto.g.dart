// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_notification_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentNotificationDto _$PaymentNotificationDtoFromJson(
        Map<String, dynamic> json) =>
    PaymentNotificationDto(
      userId: json['user_id'] as String,
      type: json['type'] as String,
      title: json['title'] as String?,
      message: json['message'] as String?,
      metadata: json['metadata'] as String?,
    );

Map<String, dynamic> _$PaymentNotificationDtoToJson(
        PaymentNotificationDto instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'type': instance.type,
      'title': instance.title,
      'message': instance.message,
      'metadata': instance.metadata,
    };
