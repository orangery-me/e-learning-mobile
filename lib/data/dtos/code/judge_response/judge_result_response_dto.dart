import 'package:json_annotation/json_annotation.dart';
part 'judge_result_response_dto.g.dart';

class CodeRepsonseStatus {
  final int id;
  final String description;

  CodeRepsonseStatus({
    required this.id,
    required this.description,
  });

  factory CodeRepsonseStatus.fromJson(Map<String, dynamic> json) {
    return CodeRepsonseStatus(
      id: json['id'] as int,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
      };
}

@JsonSerializable()
class JudgeResultResponseDto {
  final String? stdout;
  final String? time;
  final int? memory;
  final String? stderr;
  final String token;
  @JsonKey(name: 'compile_output')
  final String? compileOutput;
  final String? message;
  @JsonKey(name: 'status')
  final CodeRepsonseStatus status;

  JudgeResultResponseDto({
    this.stdout,
    this.time,
    this.memory,
    this.stderr,
    required this.token,
    this.compileOutput,
    this.message,
    required this.status,
  });

  factory JudgeResultResponseDto.fromJson(Map<String, dynamic> json) =>
      _$JudgeResultResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$JudgeResultResponseDtoToJson(this);
}
