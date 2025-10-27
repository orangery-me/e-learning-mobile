import 'package:json_annotation/json_annotation.dart';
part 'review_response_dto.g.dart';

@JsonSerializable()
class ReviewResponseDto {
  final String reviewId;
  final String courseId;
  final String userId;
  final String userName;
  final String userAvatar;
  final int rating;
  final String comment;
  final int likeCount;
  final int dislikeCount;
  ReviewResponseDto({
    required this.reviewId,
    required this.courseId,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.rating,
    required this.comment,
    required this.likeCount,
    required this.dislikeCount,
  });
  factory ReviewResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ReviewResponseDtoFromJson(json);
}
