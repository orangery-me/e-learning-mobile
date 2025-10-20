// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoteCreateRequestDto _$NoteCreateRequestDtoFromJson(
        Map<String, dynamic> json) =>
    NoteCreateRequestDto(
      lectureId: json['lectureId'] as String,
      content: json['content'] as String,
      videoTimestamp: (json['videoTimestamp'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NoteCreateRequestDtoToJson(
        NoteCreateRequestDto instance) =>
    <String, dynamic>{
      'lectureId': instance.lectureId,
      'content': instance.content,
      'videoTimestamp': instance.videoTimestamp,
    };

NoteUpdateRequestDto _$NoteUpdateRequestDtoFromJson(
        Map<String, dynamic> json) =>
    NoteUpdateRequestDto(
      content: json['content'] as String,
      timestamp: (json['timestamp'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NoteUpdateRequestDtoToJson(
        NoteUpdateRequestDto instance) =>
    <String, dynamic>{
      'content': instance.content,
      'timestamp': instance.timestamp,
    };
