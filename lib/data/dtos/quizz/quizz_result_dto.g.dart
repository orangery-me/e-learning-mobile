// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quizz_result_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizzResultDto _$QuizzResultDtoFromJson(Map<String, dynamic> json) =>
    QuizzResultDto(
      id: json['id'] as String,
      quizId: json['quizId'] as String,
      quizTitle: json['quizTitle'] as String,
      userId: json['userId'] as String,
      userEmail: json['userEmail'] as String,
      attemptNumber: (json['attemptNumber'] as num).toInt(),
      totalScore: (json['totalScore'] as num).toDouble(),
      maxPossibleScore: (json['maxPossibleScore'] as num).toDouble(),
      scorePercentage: (json['scorePercentage'] as num).toDouble(),
      isPassed: json['isPassed'] as bool,
      submittedAt: DateTime.parse(json['submittedAt'] as String),
      timeTakenMinutes: (json['timeTakenMinutes'] as num).toInt(),
      isCompleted: json['isCompleted'] as bool,
      answers: (json['answers'] as List<dynamic>)
          .map((e) => QuizzAnswerDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$QuizzResultDtoToJson(QuizzResultDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quizId': instance.quizId,
      'quizTitle': instance.quizTitle,
      'userId': instance.userId,
      'userEmail': instance.userEmail,
      'attemptNumber': instance.attemptNumber,
      'totalScore': instance.totalScore,
      'maxPossibleScore': instance.maxPossibleScore,
      'scorePercentage': instance.scorePercentage,
      'isPassed': instance.isPassed,
      'submittedAt': instance.submittedAt.toIso8601String(),
      'timeTakenMinutes': instance.timeTakenMinutes,
      'isCompleted': instance.isCompleted,
      'answers': instance.answers,
    };
