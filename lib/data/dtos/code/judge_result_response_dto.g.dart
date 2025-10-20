// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'judge_result_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JudgeResultResponseDto _$JudgeResultResponseDtoFromJson(
        Map<String, dynamic> json) =>
    JudgeResultResponseDto(
      stdout: json['stdout'] as String?,
      time: json['time'] as String?,
      memory: (json['memory'] as num?)?.toInt(),
      stderr: json['stderr'] as String?,
      token: json['token'] as String,
      compileOutput: json['compile_output'] as String?,
      message: json['message'] as String?,
      status:
          CodeRepsonseStatus.fromJson(json['status'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$JudgeResultResponseDtoToJson(
        JudgeResultResponseDto instance) =>
    <String, dynamic>{
      'stdout': instance.stdout,
      'time': instance.time,
      'memory': instance.memory,
      'stderr': instance.stderr,
      'token': instance.token,
      'compile_output': instance.compileOutput,
      'message': instance.message,
      'status': instance.status,
    };
