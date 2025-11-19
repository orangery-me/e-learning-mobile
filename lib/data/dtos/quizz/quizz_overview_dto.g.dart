// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quizz_overview_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizzOverviewDto _$QuizzOverviewDtoFromJson(Map<String, dynamic> json) =>
    QuizzOverviewDto(
      id: json['id'] as String,
      lectureId: json['lectureId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      timeLimitMinutes: (json['timeLimitMinutes'] as num).toInt(),
      passingScore: (json['passingScore'] as num).toInt(),
      maxAttempts: (json['maxAttempts'] as num).toInt(),
      numberQuestions: (json['numberQuestions'] as num).toInt(),
      isActive: json['isActive'] as bool,
      createdAt: const DateTimeTimestampConverter()
          .fromJson((json['createdAt'] as num).toInt()),
      questions: (json['questions'] as List<dynamic>)
          .map((e) => QuizzQuestionDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$QuizzOverviewDtoToJson(QuizzOverviewDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'lectureId': instance.lectureId,
      'title': instance.title,
      'description': instance.description,
      'timeLimitMinutes': instance.timeLimitMinutes,
      'passingScore': instance.passingScore,
      'maxAttempts': instance.maxAttempts,
      'numberQuestions': instance.numberQuestions,
      'isActive': instance.isActive,
      'createdAt':
          const DateTimeTimestampConverter().toJson(instance.createdAt),
      'questions': instance.questions,
    };
