// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_notification_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentNotificationDto _$PaymentNotificationDtoFromJson(
        Map<String, dynamic> json) =>
    PaymentNotificationDto(
      userId: json['userId'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      orderCode: json['orderCode'] as String,
      paymentStatus: json['paymentStatus'] as String,
      metadata: Map<String, String>.from(json['metadata'] as Map),
    );

Map<String, dynamic> _$PaymentNotificationDtoToJson(
        PaymentNotificationDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'type': instance.type,
      'title': instance.title,
      'message': instance.message,
      'orderCode': instance.orderCode,
      'paymentStatus': instance.paymentStatus,
      'metadata': instance.metadata,
    };
