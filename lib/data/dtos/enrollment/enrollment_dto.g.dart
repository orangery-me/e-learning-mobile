// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enrollment_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EnrollmentDto _$EnrollmentDtoFromJson(Map<String, dynamic> json) =>
    EnrollmentDto(
      id: json['id'] as String,
      user: UserInfoDto.fromJson(json['user'] as Map<String, dynamic>),
      course: CourseWithInstructorInfoResponseDto.fromJson(
          json['course'] as Map<String, dynamic>),
      enrollmentDate: const DateTimeTimestampConverter()
          .fromJson((json['enrollmentDate'] as num).toInt()),
      completionDate: _$JsonConverterFromJson<int, DateTime>(
          json['completionDate'], const DateTimeTimestampConverter().fromJson),
      progressPercentage: (json['progressPercentage'] as num).toDouble(),
      status: EnrollmentStatus.fromJson(json['status'] as String?),
      totalWatchTimeMinutes: (json['totalWatchTimeMinutes'] as num).toInt(),
      lastAccessedAt: _$JsonConverterFromJson<int, DateTime>(
          json['lastAccessedAt'], const DateTimeTimestampConverter().fromJson),
      createdAt: _$JsonConverterFromJson<int, DateTime>(
          json['createdAt'], const DateTimeTimestampConverter().fromJson),
      updatedAt: _$JsonConverterFromJson<int, DateTime>(
          json['updatedAt'], const DateTimeTimestampConverter().fromJson),
    );

Map<String, dynamic> _$EnrollmentDtoToJson(EnrollmentDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'course': instance.course,
      'enrollmentDate':
          const DateTimeTimestampConverter().toJson(instance.enrollmentDate),
      'completionDate': _$JsonConverterToJson<int, DateTime>(
          instance.completionDate, const DateTimeTimestampConverter().toJson),
      'progressPercentage': instance.progressPercentage,
      'status': instance.status,
      'totalWatchTimeMinutes': instance.totalWatchTimeMinutes,
      'lastAccessedAt': _$JsonConverterToJson<int, DateTime>(
          instance.lastAccessedAt, const DateTimeTimestampConverter().toJson),
      'createdAt': _$JsonConverterToJson<int, DateTime>(
          instance.createdAt, const DateTimeTimestampConverter().toJson),
      'updatedAt': _$JsonConverterToJson<int, DateTime>(
          instance.updatedAt, const DateTimeTimestampConverter().toJson),
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
