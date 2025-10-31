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
      paymentMethod: json['paymentMethod'] as String?,
      status: json['status'] as String?,
      checkoutUrl: json['checkoutUrl'] as String,
      paidAt: _$JsonConverterFromJson<int, DateTime>(
          json['paidAt'], const DateTimeTimestampConverter().fromJson),
      expiresAt: _$JsonConverterFromJson<int, DateTime>(
          json['expiresAt'], const DateTimeTimestampConverter().fromJson),
    );

Map<String, dynamic> _$PaymentSummaryResponseToJson(
        PaymentSummaryResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderCode': instance.orderCode,
      'paymentMethod': instance.paymentMethod,
      'status': instance.status,
      'checkoutUrl': instance.checkoutUrl,
      'paidAt': _$JsonConverterToJson<int, DateTime>(
          instance.paidAt, const DateTimeTimestampConverter().toJson),
      'expiresAt': _$JsonConverterToJson<int, DateTime>(
          instance.expiresAt, const DateTimeTimestampConverter().toJson),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
