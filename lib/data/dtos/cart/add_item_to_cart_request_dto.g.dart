// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_item_to_cart_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddItemToCartRequestDto _$AddItemToCartRequestDtoFromJson(
        Map<String, dynamic> json) =>
    AddItemToCartRequestDto(
      addedPrice: (json['addedPrice'] as num).toDouble(),
      courseId: json['courseId'] as String,
    );

Map<String, dynamic> _$AddItemToCartRequestDtoToJson(
        AddItemToCartRequestDto instance) =>
    <String, dynamic>{
      'addedPrice': instance.addedPrice,
      'courseId': instance.courseId,
    };
