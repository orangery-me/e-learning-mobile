import 'package:e_learning_mobile/common/utils/datetime_converter.dart';
import 'package:e_learning_mobile/data/dtos/payment/payment_method.dart';
import 'package:e_learning_mobile/data/dtos/payment/payment_method_converter.dart';
import 'package:e_learning_mobile/data/dtos/payment/payment_order_summary.dart';
import 'package:e_learning_mobile/data/dtos/payment/payment_status.dart';
import 'package:e_learning_mobile/data/dtos/payment/payment_status_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment_response_dto.g.dart';

@JsonSerializable()
class PaymentResponseDto {
  final String id;
  @JsonKey(name: 'orderCode')
  final String orderCode;
  final double amount;
  final String? description;
  @PaymentMethodConverter()
  @JsonKey(name: 'paymentMethod')
  final PaymentMethod paymentMethod;
  @PaymentStatusConverter()
  final PaymentStatus status;
  @JsonKey(name: 'userId')
  final String userId;
  @JsonKey(name: 'payosPaymentLinkId')
  final String? payosPaymentLinkId;
  @JsonKey(name: 'payosTransactionId')
  final String? payosTransactionId;
  @JsonKey(name: 'checkoutUrl')
  final String? checkoutUrl;
  @JsonKey(name: 'qrCode')
  final String? qrCode;
  @JsonKey(name: 'bankCode')
  final String? bankCode;
  @JsonKey(name: 'bankName')
  final String? bankName;
  @JsonKey(name: 'accountNumber')
  final String? accountNumber;
  @JsonKey(name: 'accountName')
  final String? accountName;
  @DateTimeTimestampConverter()
  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;
  @DateTimeTimestampConverter()
  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAt;
  @DateTimeTimestampConverter()
  @JsonKey(name: 'paidAt')
  final DateTime? paidAt;
  @DateTimeTimestampConverter()
  @JsonKey(name: 'expiresAt')
  final DateTime? expiresAt;
  final PaymentOrderSummary? order;

  PaymentResponseDto({
    required this.id,
    required this.orderCode,
    required this.amount,
    this.description,
    required this.paymentMethod,
    required this.status,
    required this.userId,
    this.payosPaymentLinkId,
    this.payosTransactionId,
    this.checkoutUrl,
    this.qrCode,
    this.bankCode,
    this.bankName,
    this.accountNumber,
    this.accountName,
    this.createdAt,
    this.updatedAt,
    this.paidAt,
    this.expiresAt,
    this.order,
  });

  factory PaymentResponseDto.fromJson(Map<String, dynamic> json) =>
      _$PaymentResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentResponseDtoToJson(this);
}
