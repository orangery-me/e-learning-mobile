// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'code_exercise_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CodeExerciseRequestDto _$CodeExerciseRequestDtoFromJson(
        Map<String, dynamic> json) =>
    CodeExerciseRequestDto(
      languageId: (json['language_id'] as num).toInt(),
      sourceCode: json['source_code'] as String,
      stdin: json['stdin'] as String?,
      expectedOutput: json['expected_output'] as String?,
      problemDescription: json['problem_description'] as String?,
    );

Map<String, dynamic> _$CodeExerciseRequestDtoToJson(
        CodeExerciseRequestDto instance) =>
    <String, dynamic>{
      'language_id': instance.languageId,
      'source_code': instance.sourceCode,
      'stdin': instance.stdin,
      'expected_output': instance.expectedOutput,
      'problem_description': instance.problemDescription,
    };
