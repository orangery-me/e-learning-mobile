import 'package:e_learning_mobile/data/dtos/user/user_info_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'course_with_instructor_info_response_dto.g.dart';

@JsonSerializable()
class CourseWithInstructorInfoResponseDto {
  final String courseId;
  final String title;
  final String? slug;
  final String? description;
  final double price;
  final String? level;
  final UserInfoDto instructor;
  final String category;
  final String? image;

  CourseWithInstructorInfoResponseDto({
    required this.courseId,
    required this.title,
    required this.slug,
    required this.description,
    required this.price,
    required this.level,
    required this.instructor,
    required this.category,
    required this.image,
  });

  factory CourseWithInstructorInfoResponseDto.fromJson(
          Map<String, dynamic> json) =>
      _$CourseWithInstructorInfoResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CourseWithInstructorInfoResponseDtoToJson(this);
}
