import 'package:e_learning_mobile/common/utils/datetime_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'section_response_dto.g.dart';

@JsonSerializable()
class SectionResponseDto {
  final String sectionId;
  final String courseId;
  final String title;
  final int position;
  @DateTimeTimestampConverter()
  final DateTime createdAt;
  @DateTimeTimestampConverter()
  final DateTime updatedAt;

  factory SectionResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SectionResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SectionResponseDtoToJson(this);

  SectionResponseDto({
    required this.sectionId,
    required this.courseId,
    required this.title,
    required this.position,
    required this.createdAt,
    required this.updatedAt,
  });
}
