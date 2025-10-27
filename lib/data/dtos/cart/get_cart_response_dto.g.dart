// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_cart_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetCardResponseDto _$GetCardResponseDtoFromJson(Map<String, dynamic> json) =>
    GetCardResponseDto(
      id: json['id'] as String,
      userId: json['userId'] as String,
      totalItems: (json['totalItems'] as num).toInt(),
      totalAmount: (json['totalAmount'] as num).toInt(),
      discountAmount: (json['discountAmount'] as num).toInt(),
      finalAmount: (json['finalAmount'] as num).toInt(),
      createdAt: (json['createdAt'] as num).toInt(),
      updatedAt: (json['updatedAt'] as num).toInt(),
      items: (json['items'] as List<dynamic>)
          .map((e) => CartItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalSavings: (json['totalSavings'] as num).toInt(),
      uniqueCourses: (json['uniqueCourses'] as num).toInt(),
      isEmpty: json['isEmpty'] as bool,
      hasCoupon: json['hasCoupon'] as bool,
    );

Map<String, dynamic> _$GetCardResponseDtoToJson(GetCardResponseDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'totalItems': instance.totalItems,
      'totalAmount': instance.totalAmount,
      'discountAmount': instance.discountAmount,
      'finalAmount': instance.finalAmount,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'items': instance.items,
      'totalSavings': instance.totalSavings,
      'uniqueCourses': instance.uniqueCourses,
      'isEmpty': instance.isEmpty,
      'hasCoupon': instance.hasCoupon,
    };
