import 'package:e_learning_mobile/common/utils/datetime_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'note_response_dto.g.dart';

@JsonSerializable()
class NoteResponseDto {
  final String noteId;
  final String userId;
  final String lectureId;
  final String lectureTitle;
  final String content;
  final int? videoTimestamp; // seconds in video when noted (optional)
  @DateTimeTimestampConverter()
  final DateTime? createdAt;
  @DateTimeTimestampConverter()
  final DateTime? updatedAt;
  @DateTimeTimestampConverter()
  final DateTime? deletedAt;

  NoteResponseDto({
    required this.noteId,
    required this.userId,
    required this.lectureId,
    required this.lectureTitle,
    required this.content,
    this.videoTimestamp,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory NoteResponseDto.fromJson(Map<String, dynamic> json) =>
      _$NoteResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$NoteResponseDtoToJson(this);
}
