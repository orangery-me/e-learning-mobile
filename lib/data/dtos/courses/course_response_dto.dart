import 'package:json_annotation/json_annotation.dart';

part 'course_response_dto.g.dart';

@JsonSerializable()
class CourseResponseDto {
  final String courseId;
  final String title;
  final String slug;
  final String description;
  final double price;
  final String level;
  final String instructorId;
  // final String instructorName;
  final String category;
  final String image;

  factory CourseResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CourseResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CourseResponseDtoToJson(this);

  CourseResponseDto({
    required this.courseId,
    required this.title,
    required this.slug,
    required this.description,
    required this.price,
    required this.level,
    required this.instructorId,
    // required this.instructorName,
    required this.category,
    required this.image,
  });
}
