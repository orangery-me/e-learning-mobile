// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_roadmap_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaveRoadmapRequestDto _$SaveRoadmapRequestDtoFromJson(
        Map<String, dynamic> json) =>
    SaveRoadmapRequestDto(
      role: json['role'] as String,
      goal: json['goal'] as String,
      sections: (json['sections'] as List<dynamic>)
          .map((e) =>
              CareerRoadmapSectionDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      answers: Map<String, String>.from(json['answers'] as Map),
    );

Map<String, dynamic> _$SaveRoadmapRequestDtoToJson(
        SaveRoadmapRequestDto instance) =>
    <String, dynamic>{
      'role': instance.role,
      'goal': instance.goal,
      'sections': instance.sections,
      'answers': instance.answers,
    };
