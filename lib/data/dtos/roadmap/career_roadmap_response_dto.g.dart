// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'career_roadmap_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CareerRoadmapSectionDto _$CareerRoadmapSectionDtoFromJson(
        Map<String, dynamic> json) =>
    CareerRoadmapSectionDto(
      sectionTitle: json['section_title'] as String,
      description: json['description'] as String,
      courseIds: (json['course_ids'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$CareerRoadmapSectionDtoToJson(
        CareerRoadmapSectionDto instance) =>
    <String, dynamic>{
      'section_title': instance.sectionTitle,
      'description': instance.description,
      'course_ids': instance.courseIds,
    };

CareerRoadmapResponseDto _$CareerRoadmapResponseDtoFromJson(
        Map<String, dynamic> json) =>
    CareerRoadmapResponseDto(
      role: json['role'] as String,
      goal: json['goal'] as String,
      sections: (json['sections'] as List<dynamic>)
          .map((e) =>
              CareerRoadmapSectionDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CareerRoadmapResponseDtoToJson(
        CareerRoadmapResponseDto instance) =>
    <String, dynamic>{
      'role': instance.role,
      'goal': instance.goal,
      'sections': instance.sections,
    };
