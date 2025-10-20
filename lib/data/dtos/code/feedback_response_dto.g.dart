// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedback_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedBackResponseDto _$FeedBackResponseDtoFromJson(Map<String, dynamic> json) =>
    FeedBackResponseDto(
      score: (json['score'] as num?)?.toInt(),
      summary: json['summary'] as String?,
      strengths: (json['strengths'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      weaknesses: (json['weaknesses'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      suggestions: (json['suggestions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      codeQualityMetricsDto: json['code_quality'] == null
          ? null
          : CodeQualityMetricsDto.fromJson(
              json['code_quality'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FeedBackResponseDtoToJson(
        FeedBackResponseDto instance) =>
    <String, dynamic>{
      'score': instance.score,
      'summary': instance.summary,
      'strengths': instance.strengths,
      'weaknesses': instance.weaknesses,
      'suggestions': instance.suggestions,
      'code_quality': instance.codeQualityMetricsDto,
    };
