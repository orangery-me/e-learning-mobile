import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
part 'code_exercise_request_dto.g.dart';

@JsonSerializable()
class CodeExerciseRequestDto {
  @JsonKey(name: 'language_id')
  final int languageId;
  @JsonKey(name: 'source_code')
  final String sourceCode;
  final String? stdin;
  @JsonKey(name: 'expected_output')
  final String? expectedOutput;
  @JsonKey(name: 'problem_description')
  final String? problemDescription;
  @JsonKey(name: 'exercise_id')
  final String? exerciseId;

  CodeExerciseRequestDto({
    required this.languageId,
    required this.sourceCode,
    this.exerciseId,
    this.stdin,
    this.expectedOutput,
    this.problemDescription,
  });

  CodeExerciseRequestDto.withAutoExerciseId({
    required this.languageId,
    required this.sourceCode,
    this.stdin,
    this.expectedOutput,
    this.problemDescription,
  }) : exerciseId = const Uuid().v4().replaceAll('-', '');

  factory CodeExerciseRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CodeExerciseRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CodeExerciseRequestDtoToJson(this);
}
