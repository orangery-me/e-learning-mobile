import 'package:json_annotation/json_annotation.dart';

part 'payment_summary_response.g.dart';

@JsonSerializable()
class PaymentSummaryResponse {
  final String id;
  final String orderCode;
  final String paymentMethod;
  final String status;
  final String checkoutUrl;
  final DateTime paidAt;
  final DateTime expiresAt;

  PaymentSummaryResponse({
    required this.id,
    required this.orderCode,
    required this.paymentMethod,
    required this.status,
    required this.checkoutUrl,
    required this.paidAt,
    required this.expiresAt,
  });

  factory PaymentSummaryResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentSummaryResponseFromJson(json);
}
