import 'package:json_annotation/json_annotation.dart';

part 'order_item_response.g.dart';

@JsonSerializable()
class OrderItemResponse {
  final String id;
  final String courseId;
  final String? courseTitle;
  final String? courseImage;
  final double? unitPrice;
  final double discountAmount;

  OrderItemResponse({
    required this.id,
    required this.courseId,
    required this.courseTitle,
    required this.courseImage,
    required this.unitPrice,
    required this.discountAmount,
  });

  factory OrderItemResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderItemResponseFromJson(json);
}
