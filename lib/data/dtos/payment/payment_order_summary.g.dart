// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_order_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentOrderSummary _$PaymentOrderSummaryFromJson(Map<String, dynamic> json) =>
    PaymentOrderSummary(
      id: json['id'] as String,
      orderNumber: json['orderNumber'] as String,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      finalAmount: (json['finalAmount'] as num).toDouble(),
      totalItems: (json['totalItems'] as num).toInt(),
      status: OrderStatus.fromJson(json['status'] as String?),
    );

Map<String, dynamic> _$PaymentOrderSummaryToJson(
        PaymentOrderSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderNumber': instance.orderNumber,
      'totalAmount': instance.totalAmount,
      'finalAmount': instance.finalAmount,
      'totalItems': instance.totalItems,
      'status': _$OrderStatusEnumMap[instance.status]!,
    };

const _$OrderStatusEnumMap = {
  OrderStatus.pending: 'pending',
  OrderStatus.paid: 'paid',
  OrderStatus.failed: 'failed',
  OrderStatus.cancelled: 'cancelled',
  OrderStatus.refunded: 'refunded',
  OrderStatus.delivered: 'delivered',
};
