// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_payment_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreatePaymentRequest _$CreatePaymentRequestFromJson(
        Map<String, dynamic> json) =>
    CreatePaymentRequest(
      orderId: json['orderId'] as String,
      description: json['description'] as String?,
      paymentMethod: json['paymentMethod'] as String?,
    );

Map<String, dynamic> _$CreatePaymentRequestToJson(
        CreatePaymentRequest instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'description': instance.description,
      'paymentMethod': instance.paymentMethod,
    };
