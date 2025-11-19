import 'package:e_learning_mobile/common/utils/datetime_converter.dart';
import 'package:e_learning_mobile/data/dtos/quizz/quizz_question_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'quizz_overview_dto.g.dart';

@JsonSerializable()
class QuizzOverviewDto {
  final String id;
  final String lectureId;
  final String title;
  final String description;
  final int timeLimitMinutes;
  final int passingScore;
  final int maxAttempts;
  final int numberQuestions;
  final bool isActive;
  @DateTimeTimestampConverter()
  final DateTime createdAt;
  final List<QuizzQuestionDto> questions;

  QuizzOverviewDto({
    required this.id,
    required this.lectureId,
    required this.title,
    required this.description,
    required this.timeLimitMinutes,
    required this.passingScore,
    required this.maxAttempts,
    required this.numberQuestions,
    required this.isActive,
    required this.createdAt,
    required this.questions,
  });

  Map<String, dynamic> toJson() => _$QuizzOverviewDtoToJson(this);

  factory QuizzOverviewDto.fromJson(Map<String, dynamic> json) =>
      _$QuizzOverviewDtoFromJson(json);
}
