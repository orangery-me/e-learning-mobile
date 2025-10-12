// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'section_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SectionResponseDto _$SectionResponseDtoFromJson(Map<String, dynamic> json) =>
    SectionResponseDto(
      sectionId: json['sectionId'] as String,
      courseId: json['courseId'] as String,
      title: json['title'] as String,
      position: (json['position'] as num).toInt(),
      createdAt: const DateTimeTimestampConverter()
          .fromJson((json['createdAt'] as num).toInt()),
      updatedAt: const DateTimeTimestampConverter()
          .fromJson((json['updatedAt'] as num).toInt()),
    );

Map<String, dynamic> _$SectionResponseDtoToJson(SectionResponseDto instance) =>
    <String, dynamic>{
      'sectionId': instance.sectionId,
      'courseId': instance.courseId,
      'title': instance.title,
      'position': instance.position,
      'createdAt':
          const DateTimeTimestampConverter().toJson(instance.createdAt),
      'updatedAt':
          const DateTimeTimestampConverter().toJson(instance.updatedAt),
    };
