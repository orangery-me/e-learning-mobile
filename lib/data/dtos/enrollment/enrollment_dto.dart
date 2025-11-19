import 'package:e_learning_mobile/common/utils/datetime_converter.dart';
import 'package:e_learning_mobile/data/dtos/courses/course_with_instructor_info_response_dto.dart';
import 'package:e_learning_mobile/data/dtos/user/user_info_dto.dart';
import 'package:json_annotation/json_annotation.dart';
part 'enrollment_dto.g.dart';

enum EnrollmentStatus {
  active,
  completed;

  String toJson() => name.toUpperCase();

  factory EnrollmentStatus.fromJson(String? raw) =>
      EnrollmentStatus.values.firstWhere(
        (e) => e.name == raw?.toLowerCase(),
        orElse: () => EnrollmentStatus.active,
      );
}

@JsonSerializable()
class EnrollmentDto {
  final String id;
  final UserInfoDto user;
  final CourseWithInstructorInfoResponseDto course;
  @DateTimeTimestampConverter()
  final DateTime enrollmentDate;
  @DateTimeTimestampConverter()
  final DateTime? completionDate;
  final double progressPercentage;
  final EnrollmentStatus status;
  final int totalWatchTimeMinutes;
  @DateTimeTimestampConverter()
  final DateTime? lastAccessedAt;
  @DateTimeTimestampConverter()
  final DateTime? createdAt;
  @DateTimeTimestampConverter()
  final DateTime? updatedAt;

  EnrollmentDto({
    required this.id,
    required this.user,
    required this.course,
    required this.enrollmentDate,
    this.completionDate,
    required this.progressPercentage,
    required this.status,
    required this.totalWatchTimeMinutes,
    this.lastAccessedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory EnrollmentDto.fromJson(Map<String, dynamic> json) =>
      _$EnrollmentDtoFromJson(json);

  Map<String, dynamic> toJson() => _$EnrollmentDtoToJson(this);
}
