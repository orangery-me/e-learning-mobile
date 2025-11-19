// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quizz_question_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizzQuestionDto _$QuizzQuestionDtoFromJson(Map<String, dynamic> json) =>
    QuizzQuestionDto(
      id: json['id'] as String,
      questionText: json['questionText'] as String,
      options:
          (json['options'] as List<dynamic>).map((e) => e as String).toList(),
      correctAnswerIndex: (json['correctAnswerIndex'] as num).toInt(),
      points: (json['points'] as num).toInt(),
      sortOrder: (json['sortOrder'] as num).toInt(),
      createdAt: const DateTimeTimestampConverter()
          .fromJson((json['createdAt'] as num).toInt()),
    );

Map<String, dynamic> _$QuizzQuestionDtoToJson(QuizzQuestionDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'questionText': instance.questionText,
      'options': instance.options,
      'correctAnswerIndex': instance.correctAnswerIndex,
      'points': instance.points,
      'sortOrder': instance.sortOrder,
      'createdAt':
          const DateTimeTimestampConverter().toJson(instance.createdAt),
    };
