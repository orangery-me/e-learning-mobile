import 'package:e_learning_mobile/data/dtos/cart/cart_item_dto.dart';
import 'package:json_annotation/json_annotation.dart';
part 'get_cart_response_dto.g.dart';

@JsonSerializable()
class GetCardResponseDto {
  final String id;
  final String userId;
  final int totalItems;
  final int totalAmount;
  final int discountAmount;
  final int finalAmount;
  final int createdAt;
  final int updatedAt;
  final List<CartItemDto> items;
  final int totalSavings;
  final int uniqueCourses;
  final bool isEmpty;
  final bool hasCoupon;
  GetCardResponseDto({
    required this.id,
    required this.userId,
    required this.totalItems,
    required this.totalAmount,
    required this.discountAmount,
    required this.finalAmount,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
    required this.totalSavings,
    required this.uniqueCourses,
    required this.isEmpty,
    required this.hasCoupon,
  });
  factory GetCardResponseDto.fromJson(Map<String, dynamic> json) =>
      _$GetCardResponseDtoFromJson(json);
}
