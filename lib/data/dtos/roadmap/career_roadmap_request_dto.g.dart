// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'career_roadmap_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CareerRoadmapRequestDto _$CareerRoadmapRequestDtoFromJson(
        Map<String, dynamic> json) =>
    CareerRoadmapRequestDto(
      role: json['role'] as String,
      goal: json['goal'] as String,
      answers: Map<String, String>.from(json['answers'] as Map),
    );

Map<String, dynamic> _$CareerRoadmapRequestDtoToJson(
        CareerRoadmapRequestDto instance) =>
    <String, dynamic>{
      'role': instance.role,
      'goal': instance.goal,
      'answers': instance.answers,
    };
