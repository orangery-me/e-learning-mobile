import 'package:json_annotation/json_annotation.dart';

part 'feedback_response_dto.g.dart';

class CodeQualityMetricsDto {
  final double efficiency;
  final double readability;
  final double bestPractices;

  CodeQualityMetricsDto({
    required this.efficiency,
    required this.readability,
    required this.bestPractices,
  });

  factory CodeQualityMetricsDto.fromJson(Map<String, dynamic> json) {
    return CodeQualityMetricsDto(
      efficiency: (json['efficiency'] as num).toDouble(),
      readability: (json['readability'] as num).toDouble(),
      bestPractices: (json['best_practices'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'efficiency': efficiency,
        'readability': readability,
        'best_practices': bestPractices,
      };
}

@JsonSerializable()
class FeedBackResponseDto {
  final int? score;
  final String? summary;
  final List<String>? strengths;
  final List<String>? weaknesses;
  final List<String>? suggestions;
  @JsonKey(name: 'code_quality')
  final CodeQualityMetricsDto? codeQualityMetricsDto;

  FeedBackResponseDto({
    this.score,
    this.summary,
    this.strengths,
    this.weaknesses,
    this.suggestions,
    this.codeQualityMetricsDto,
  });
  factory FeedBackResponseDto.fromJson(Map<String, dynamic> json) =>
      _$FeedBackResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FeedBackResponseDtoToJson(this);
}
