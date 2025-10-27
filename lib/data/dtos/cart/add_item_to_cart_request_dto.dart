import 'package:json_annotation/json_annotation.dart';
part 'add_item_to_cart_request_dto.g.dart';

@JsonSerializable()
class AddItemToCartRequestDto {
  final double addedPrice;
  final String courseId;

  AddItemToCartRequestDto({
    required this.addedPrice,
    required this.courseId,
  });

  factory AddItemToCartRequestDto.fromJson(Map<String, dynamic> json) =>
      _$AddItemToCartRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AddItemToCartRequestDtoToJson(this);
}
