// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quizz_submit_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizzSubmit _$QuizzSubmitFromJson(Map<String, dynamic> json) => QuizzSubmit(
      answers: (json['answers'] as List<dynamic>)
          .map((e) => QuizzSubmitAnswer.fromJson(e as Map<String, dynamic>))
          .toList(),
      enrollmentId: json['enrollmentId'] as String,
      quizId: json['quizId'] as String,
      startedAt: DateTime.parse(json['startedAt'] as String),
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$QuizzSubmitToJson(QuizzSubmit instance) =>
    <String, dynamic>{
      'answers': instance.answers,
      'enrollmentId': instance.enrollmentId,
      'quizId': instance.quizId,
      'startedAt': instance.startedAt.toIso8601String(),
      'userId': instance.userId,
    };
