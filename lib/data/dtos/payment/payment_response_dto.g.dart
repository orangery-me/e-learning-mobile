// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentResponseDto _$PaymentResponseDtoFromJson(Map<String, dynamic> json) =>
    PaymentResponseDto(
      id: json['id'] as String,
      orderCode: json['orderCode'] as String,
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String?,
      paymentMethod: const PaymentMethodConverter()
          .fromJson(json['paymentMethod'] as String),
      status: const PaymentStatusConverter().fromJson(json['status'] as String),
      userId: json['userId'] as String,
      payosPaymentLinkId: json['payosPaymentLinkId'] as String?,
      payosTransactionId: json['payosTransactionId'] as String?,
      checkoutUrl: json['checkoutUrl'] as String?,
      qrCode: json['qrCode'] as String?,
      bankCode: json['bankCode'] as String?,
      bankName: json['bankName'] as String?,
      accountNumber: json['accountNumber'] as String?,
      accountName: json['accountName'] as String?,
      createdAt: _$JsonConverterFromJson<int, DateTime>(
          json['createdAt'], const DateTimeTimestampConverter().fromJson),
      updatedAt: _$JsonConverterFromJson<int, DateTime>(
          json['updatedAt'], const DateTimeTimestampConverter().fromJson),
      paidAt: _$JsonConverterFromJson<int, DateTime>(
          json['paidAt'], const DateTimeTimestampConverter().fromJson),
      expiresAt: _$JsonConverterFromJson<int, DateTime>(
          json['expiresAt'], const DateTimeTimestampConverter().fromJson),
      order: json['order'] == null
          ? null
          : PaymentOrderSummary.fromJson(json['order'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PaymentResponseDtoToJson(PaymentResponseDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderCode': instance.orderCode,
      'amount': instance.amount,
      'description': instance.description,
      'paymentMethod':
          const PaymentMethodConverter().toJson(instance.paymentMethod),
      'status': const PaymentStatusConverter().toJson(instance.status),
      'userId': instance.userId,
      'payosPaymentLinkId': instance.payosPaymentLinkId,
      'payosTransactionId': instance.payosTransactionId,
      'checkoutUrl': instance.checkoutUrl,
      'qrCode': instance.qrCode,
      'bankCode': instance.bankCode,
      'bankName': instance.bankName,
      'accountNumber': instance.accountNumber,
      'accountName': instance.accountName,
      'createdAt': _$JsonConverterToJson<int, DateTime>(
          instance.createdAt, const DateTimeTimestampConverter().toJson),
      'updatedAt': _$JsonConverterToJson<int, DateTime>(
          instance.updatedAt, const DateTimeTimestampConverter().toJson),
      'paidAt': _$JsonConverterToJson<int, DateTime>(
          instance.paidAt, const DateTimeTimestampConverter().toJson),
      'expiresAt': _$JsonConverterToJson<int, DateTime>(
          instance.expiresAt, const DateTimeTimestampConverter().toJson),
      'order': instance.order,
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
