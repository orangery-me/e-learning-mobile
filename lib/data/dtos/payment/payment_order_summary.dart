import 'package:e_learning_mobile/data/dtos/order/order_status.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment_order_summary.g.dart';

@JsonSerializable()
class PaymentOrderSummary {
  final String id;
  @JsonKey(name: 'orderNumber')
  final String orderNumber;
  @JsonKey(name: 'totalAmount')
  final double totalAmount;
  @JsonKey(name: 'finalAmount')
  final double finalAmount;
  @JsonKey(name: 'totalItems')
  final int totalItems;
  final OrderStatus status;

  PaymentOrderSummary({
    required this.id,
    required this.orderNumber,
    required this.totalAmount,
    required this.finalAmount,
    required this.totalItems,
    required this.status,
  });

  factory PaymentOrderSummary.fromJson(Map<String, dynamic> json) =>
      _$PaymentOrderSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentOrderSummaryToJson(this);
}
