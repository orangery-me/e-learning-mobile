// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewResponseDto _$ReviewResponseDtoFromJson(Map<String, dynamic> json) =>
    ReviewResponseDto(
      reviewId: json['reviewId'] as String,
      courseId: json['courseId'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userAvatar: json['userAvatar'] as String,
      rating: (json['rating'] as num).toInt(),
      comment: json['comment'] as String,
      likeCount: (json['likeCount'] as num).toInt(),
      dislikeCount: (json['dislikeCount'] as num).toInt(),
    );

Map<String, dynamic> _$ReviewResponseDtoToJson(ReviewResponseDto instance) =>
    <String, dynamic>{
      'reviewId': instance.reviewId,
      'courseId': instance.courseId,
      'userId': instance.userId,
      'userName': instance.userName,
      'userAvatar': instance.userAvatar,
      'rating': instance.rating,
      'comment': instance.comment,
      'likeCount': instance.likeCount,
      'dislikeCount': instance.dislikeCount,
    };
