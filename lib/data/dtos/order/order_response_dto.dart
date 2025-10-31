import 'package:e_learning_mobile/data/dtos/order/order_item_response.dart';
import 'package:e_learning_mobile/data/dtos/order/order_status.dart';
import 'package:e_learning_mobile/data/dtos/order/payment_summary_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_response_dto.g.dart';

@JsonSerializable()
class OrderResponse {
  final String id;
  final String orderNumber;
  final String userId;
  final double totalAmount;
  final double discountAmount;
  final double finalAmount;
  final OrderStatus status;
  final String notes;

  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime deliveredAt;

  final List<OrderItemResponse> items;
  final PaymentSummaryResponse payment;

  OrderResponse({
    required this.id,
    required this.orderNumber,
    required this.userId,
    required this.totalAmount,
    required this.discountAmount,
    required this.finalAmount,
    required this.status,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.deliveredAt,
    required this.items,
    required this.payment,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) => _$OrderResponseFromJson(json);
}