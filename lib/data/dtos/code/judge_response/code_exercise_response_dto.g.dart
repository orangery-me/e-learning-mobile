// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'code_exercise_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CodeExerciseResponseDto _$CodeExerciseResponseDtoFromJson(
        Map<String, dynamic> json) =>
    CodeExerciseResponseDto(
      judgeResult: JudgeResultResponseDto.fromJson(
          json['judge_result'] as Map<String, dynamic>),
      feedbackResult: json['feedback'] == null
          ? null
          : FeedBackResponseDto.fromJson(
              json['feedback'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CodeExerciseResponseDtoToJson(
        CodeExerciseResponseDto instance) =>
    <String, dynamic>{
      'judge_result': instance.judgeResult,
      'feedback': instance.feedbackResult,
    };
