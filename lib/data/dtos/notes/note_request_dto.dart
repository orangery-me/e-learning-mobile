import 'package:json_annotation/json_annotation.dart';

part 'note_request_dto.g.dart';

@JsonSerializable()
class NoteCreateRequestDto {
  final String lectureId;
  final String content;
  final int? videoTimestamp;

  NoteCreateRequestDto({
    required this.lectureId,
    required this.content,
    this.videoTimestamp,
  });

  factory NoteCreateRequestDto.fromJson(Map<String, dynamic> json) =>
      _$NoteCreateRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => {
        'content': content,
        if (videoTimestamp != null) 'videoTimestamp': videoTimestamp,
      };
}

@JsonSerializable()
class NoteUpdateRequestDto {
  final String content;
  final int? timestamp;

  NoteUpdateRequestDto({
    required this.content,
    this.timestamp,
  });

  factory NoteUpdateRequestDto.fromJson(Map<String, dynamic> json) =>
      _$NoteUpdateRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => {
        'content': content,
        if (timestamp != null) 'timestamp': timestamp,
      };
}
