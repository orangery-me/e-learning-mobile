// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoteResponseDto _$NoteResponseDtoFromJson(Map<String, dynamic> json) =>
    NoteResponseDto(
      noteId: json['noteId'] as String,
      userId: json['userId'] as String,
      lectureId: json['lectureId'] as String,
      lectureTitle: json['lectureTitle'] as String,
      content: json['content'] as String,
      videoTimestamp: (json['videoTimestamp'] as num?)?.toInt(),
      createdAt: _$JsonConverterFromJson<int, DateTime>(
          json['createdAt'], const DateTimeTimestampConverter().fromJson),
      updatedAt: _$JsonConverterFromJson<int, DateTime>(
          json['updatedAt'], const DateTimeTimestampConverter().fromJson),
      deletedAt: _$JsonConverterFromJson<int, DateTime>(
          json['deletedAt'], const DateTimeTimestampConverter().fromJson),
    );

Map<String, dynamic> _$NoteResponseDtoToJson(NoteResponseDto instance) =>
    <String, dynamic>{
      'noteId': instance.noteId,
      'userId': instance.userId,
      'lectureId': instance.lectureId,
      'lectureTitle': instance.lectureTitle,
      'content': instance.content,
      'videoTimestamp': instance.videoTimestamp,
      'createdAt': _$JsonConverterToJson<int, DateTime>(
          instance.createdAt, const DateTimeTimestampConverter().toJson),
      'updatedAt': _$JsonConverterToJson<int, DateTime>(
          instance.updatedAt, const DateTimeTimestampConverter().toJson),
      'deletedAt': _$JsonConverterToJson<int, DateTime>(
          instance.deletedAt, const DateTimeTimestampConverter().toJson),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
