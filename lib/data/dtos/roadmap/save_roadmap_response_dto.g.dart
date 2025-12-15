// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_roadmap_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaveRoadmapResponseDto _$SaveRoadmapResponseDtoFromJson(
        Map<String, dynamic> json) =>
    SaveRoadmapResponseDto(
      planId: json['plan_id'] as String,
      userId: json['user_id'] as String,
      role: json['role'] as String,
      goal: json['goal'] as String,
      sections: (json['sections'] as List<dynamic>)
          .map((e) =>
              CareerRoadmapSectionDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      answers: Map<String, String>.from(json['answers'] as Map),
      overallProgress: (json['overall_progress'] as num).toDouble(),
    );

Map<String, dynamic> _$SaveRoadmapResponseDtoToJson(
        SaveRoadmapResponseDto instance) =>
    <String, dynamic>{
      'plan_id': instance.planId,
      'user_id': instance.userId,
      'role': instance.role,
      'goal': instance.goal,
      'sections': instance.sections,
      'answers': instance.answers,
      'overall_progress': instance.overallProgress,
    };
