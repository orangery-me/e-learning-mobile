import 'package:json_annotation/json_annotation.dart';
part 'cart_item_dto.g.dart';

@JsonSerializable()
class CartItemDto {
  final String id;
  final String courseId;
  final int totalPrice;
  final int discountAmount;
  final int addedAt;
  CartItemDto({
    required this.id,
    required this.courseId,
    required this.totalPrice,
    required this.discountAmount,
    required this.addedAt,
  });
  factory CartItemDto.fromJson(Map<String, dynamic> json) =>
      _$CartItemDtoFromJson(json);
}
