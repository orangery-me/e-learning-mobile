// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItemDto _$CartItemDtoFromJson(Map<String, dynamic> json) => CartItemDto(
      id: json['id'] as String,
      courseId: json['courseId'] as String,
      courseTitle: json['courseTitle'] as String,
      courseImage: json['courseImage'] as String?,
      totalPrice: (json['totalPrice'] as num).toInt(),
      discountAmount: (json['discountAmount'] as num).toInt(),
      addedAt: (json['addedAt'] as num).toInt(),
    );

Map<String, dynamic> _$CartItemDtoToJson(CartItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'courseId': instance.courseId,
      'courseTitle': instance.courseTitle,
      'courseImage': instance.courseImage,
      'totalPrice': instance.totalPrice,
      'discountAmount': instance.discountAmount,
      'addedAt': instance.addedAt,
    };
