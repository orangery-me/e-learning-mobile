import 'package:json_annotation/json_annotation.dart';
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

  CodeExerciseRequestDto({
    required this.languageId,
    required this.sourceCode,
    this.stdin,
    this.expectedOutput,
    this.problemDescription,
  });

  factory CodeExerciseRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CodeExerciseRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CodeExerciseRequestDtoToJson(this);
}
