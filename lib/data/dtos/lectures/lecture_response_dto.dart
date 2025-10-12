import 'package:e_learning_mobile/common/utils/datetime_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'lecture_response_dto.g.dart';

@JsonSerializable()
class LectureResponseDto {
  final String lectureId;
  final String sectionId;
  final String title;
  final String? content;
  final int position;
  final String videoUrl;
  final int duration; 
  @DateTimeTimestampConverter()
  final DateTime createdAt;
  @DateTimeTimestampConverter()
  final DateTime updatedAt;

  factory LectureResponseDto.fromJson(Map<String, dynamic> json) =>
      _$LectureResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LectureResponseDtoToJson(this);

  LectureResponseDto({
    required this.lectureId,
    required this.sectionId,
    required this.title,
    required this.content,
    required this.position,
    required this.videoUrl,
    required this.duration,
    required this.createdAt,
    required this.updatedAt,
  });
}
