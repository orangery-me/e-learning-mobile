// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quizz_answer_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizzAnswerDto _$QuizzAnswerDtoFromJson(Map<String, dynamic> json) =>
    QuizzAnswerDto(
      questionId: json['questionId'] as String,
      questionText: json['questionText'] as String,
      options:
          (json['options'] as List<dynamic>).map((e) => e as String).toList(),
      selectedAnswerIndex: (json['selectedAnswerIndex'] as num).toInt(),
      correctAnswerIndex: (json['correctAnswerIndex'] as num).toInt(),
      isCorrect: json['isCorrect'] as bool,
      pointsEarned: (json['pointsEarned'] as num).toDouble(),
      maxPoints: (json['maxPoints'] as num).toDouble(),
    );

Map<String, dynamic> _$QuizzAnswerDtoToJson(QuizzAnswerDto instance) =>
    <String, dynamic>{
      'questionId': instance.questionId,
      'questionText': instance.questionText,
      'options': instance.options,
      'selectedAnswerIndex': instance.selectedAnswerIndex,
      'correctAnswerIndex': instance.correctAnswerIndex,
      'isCorrect': instance.isCorrect,
      'pointsEarned': instance.pointsEarned,
      'maxPoints': instance.maxPoints,
    };
