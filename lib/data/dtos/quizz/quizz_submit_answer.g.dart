// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quizz_submit_answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizzSubmitAnswer _$QuizzSubmitAnswerFromJson(Map<String, dynamic> json) =>
    QuizzSubmitAnswer(
      questionId: json['questionId'] as String,
      selectedAnswerIndex: (json['selectedAnswerIndex'] as num).toInt(),
    );

Map<String, dynamic> _$QuizzSubmitAnswerToJson(QuizzSubmitAnswer instance) =>
    <String, dynamic>{
      'questionId': instance.questionId,
      'selectedAnswerIndex': instance.selectedAnswerIndex,
    };
