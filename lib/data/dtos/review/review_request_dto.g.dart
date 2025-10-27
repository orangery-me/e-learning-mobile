// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewRequestDto _$ReviewRequestDtoFromJson(Map<String, dynamic> json) =>
    ReviewRequestDto(
      comment: json['comment'] as String,
      rating: (json['rating'] as num).toInt(),
    );

Map<String, dynamic> _$ReviewRequestDtoToJson(ReviewRequestDto instance) =>
    <String, dynamic>{
      'comment': instance.comment,
      'rating': instance.rating,
    };
