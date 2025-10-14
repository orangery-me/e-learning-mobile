// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lecture_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LectureResponseDto _$LectureResponseDtoFromJson(Map<String, dynamic> json) =>
    LectureResponseDto(
      lectureId: json['lectureId'] as String,
      sectionId: json['sectionId'] as String,
      title: json['title'] as String,
      content: json['content'] as String?,
      position: (json['position'] as num).toInt(),
      videoUrl: json['videoUrl'] as String?,
      duration: (json['duration'] as num?)?.toInt(),
      createdAt: const DateTimeTimestampConverter()
          .fromJson((json['createdAt'] as num).toInt()),
      updatedAt: const DateTimeTimestampConverter()
          .fromJson((json['updatedAt'] as num).toInt()),
    );

Map<String, dynamic> _$LectureResponseDtoToJson(LectureResponseDto instance) =>
    <String, dynamic>{
      'lectureId': instance.lectureId,
      'sectionId': instance.sectionId,
      'title': instance.title,
      'content': instance.content,
      'position': instance.position,
      'videoUrl': instance.videoUrl,
      'duration': instance.duration,
      'createdAt':
          const DateTimeTimestampConverter().toJson(instance.createdAt),
      'updatedAt':
          const DateTimeTimestampConverter().toJson(instance.updatedAt),
    };
