// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProgressDto _$ProgressDtoFromJson(Map<String, dynamic> json) => ProgressDto(
      id: json['id'] as String,
      completionDate: _$JsonConverterFromJson<int, DateTime>(
          json['completion_date'], const DateTimeTimestampConverter().fromJson),
      createdAt: _$JsonConverterFromJson<int, DateTime>(
          json['created_at'], const DateTimeTimestampConverter().fromJson),
      isCompleted: json['isCompleted'] as bool?,
      updatedAt: _$JsonConverterFromJson<int, DateTime>(
          json['updated_at'], const DateTimeTimestampConverter().fromJson),
      lastViewedAt: _$JsonConverterFromJson<int, DateTime>(
          json['last_viewed_at'], const DateTimeTimestampConverter().fromJson),
      enrollmentId: json['enrollment_id'] as String,
      lectureId: json['lecture_id'] as String,
      sectionId: json['section_id'] as String,
      videoUrl: json['videoUrl'] as String?,
      videoPositionSeconds:
          ProgressDto._videoPositionFromJson(json['video_position']),
    );

Map<String, dynamic> _$ProgressDtoToJson(ProgressDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'completion_date': _$JsonConverterToJson<int, DateTime>(
          instance.completionDate, const DateTimeTimestampConverter().toJson),
      'created_at': _$JsonConverterToJson<int, DateTime>(
          instance.createdAt, const DateTimeTimestampConverter().toJson),
      'isCompleted': instance.isCompleted,
      'updated_at': _$JsonConverterToJson<int, DateTime>(
          instance.updatedAt, const DateTimeTimestampConverter().toJson),
      'last_viewed_at': _$JsonConverterToJson<int, DateTime>(
          instance.lastViewedAt, const DateTimeTimestampConverter().toJson),
      'enrollment_id': instance.enrollmentId,
      'lecture_id': instance.lectureId,
      'section_id': instance.sectionId,
      'videoUrl': instance.videoUrl,
      'video_position':
          ProgressDto._videoPositionToJson(instance.videoPositionSeconds),
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
