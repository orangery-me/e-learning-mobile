// import 'package:json_annotation/json_annotation.dart';
// part 'code_exercise_response_dto.g.dart';

// class CodeRepsonseStatus {
//   final int id;
//   final String description;

//   CodeRepsonseStatus({
//     required this.id,
//     required this.description,
//   });

//   factory CodeRepsonseStatus.fromJson(Map<String, dynamic> json) {
//     return CodeRepsonseStatus(
//       id: json['id'] as int,
//       description: json['description'] as String,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'description': description,
//       };
// }

// @JsonSerializable()
// class CodeExerciseResponseDto {
//   final String? stdout;
//   final String? time;
//   final int? memory;
//   final String? stderr;
//   final String token;
//   @JsonKey(name: 'compile_output')
//   final String? compileOutput;
//   final String? message;
//   @JsonKey(name: 'status')
//   final CodeRepsonseStatus status;

//   CodeExerciseResponseDto({
//     this.stdout,
//     this.time,
//     this.memory,
//     this.stderr,
//     required this.token,
//     this.compileOutput,
//     this.message,
//     required this.status,
//   });

//   factory CodeExerciseResponseDto.fromJson(Map<String, dynamic> json) =>
//       _$CodeExerciseResponseDtoFromJson(json);

//   Map<String, dynamic> toJson() => _$CodeExerciseResponseDtoToJson(this);
// }

import 'package:e_learning_mobile/data/dtos/code/judge_response/feedback_response_dto.dart';
import 'package:e_learning_mobile/data/dtos/code/judge_response/judge_result_response_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'code_exercise_response_dto.g.dart';

@JsonSerializable()
class CodeExerciseResponseDto {
  @JsonKey(name: 'judge_result')
  final JudgeResultResponseDto judgeResult;
  @JsonKey(name: 'feedback')
  final FeedBackResponseDto? feedbackResult;

  CodeExerciseResponseDto({
    required this.judgeResult,
    this.feedbackResult,
  });

  factory CodeExerciseResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CodeExerciseResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CodeExerciseResponseDtoToJson(this);
}
