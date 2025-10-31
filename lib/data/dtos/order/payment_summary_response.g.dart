// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_summary_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentSummaryResponse _$PaymentSummaryResponseFromJson(
        Map<String, dynamic> json) =>
    PaymentSummaryResponse(
      id: json['id'] as String,
      orderCode: json['orderCode'] as String,
      paymentMethod: json['paymentMethod'] as String,
      status: json['status'] as String,
      checkoutUrl: json['checkoutUrl'] as String,
      paidAt: DateTime.parse(json['paidAt'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$PaymentSummaryResponseToJson(
        PaymentSummaryResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderCode': instance.orderCode,
      'paymentMethod': instance.paymentMethod,
      'status': instance.status,
      'checkoutUrl': instance.checkoutUrl,
      'paidAt': instance.paidAt.toIso8601String(),
      'expiresAt': instance.expiresAt.toIso8601String(),
    };
