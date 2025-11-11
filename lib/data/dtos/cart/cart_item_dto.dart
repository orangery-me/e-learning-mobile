import 'package:json_annotation/json_annotation.dart';
part 'cart_item_dto.g.dart';

@JsonSerializable()
class CartItemDto {
  final String id;
  final String courseId;
  final String courseTitle;
  final String? courseImage;
  final int totalPrice;
  final int discountAmount;
  final int addedAt;
  CartItemDto({
    required this.id,
    required this.courseId,
    required this.courseTitle,
    required this.courseImage,
    required this.totalPrice,
    required this.discountAmount,
    required this.addedAt,
  });
  factory CartItemDto.fromJson(Map<String, dynamic> json) =>
      _$CartItemDtoFromJson(json);
}
