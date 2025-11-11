import 'package:json_annotation/json_annotation.dart';

part 'create_payment_request.g.dart';

@JsonSerializable()
class CreatePaymentRequest {
  final String orderId;
  final String? description;
  @JsonKey(name: 'paymentMethod')
  final String? paymentMethod; // e.g., "PAYOS", null for default

  CreatePaymentRequest({
    required this.orderId,
    this.description,
    this.paymentMethod,
  });

  factory CreatePaymentRequest.fromJson(Map<String, dynamic> json) =>
      _$CreatePaymentRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreatePaymentRequestToJson(this);
}
