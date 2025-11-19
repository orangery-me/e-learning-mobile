import 'package:e_learning_mobile/common/utils/datetime_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'quizz_question_dto.g.dart';

@JsonSerializable()
class QuizzQuestionDto {
  final String id;
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;
  final int points;
  final int sortOrder;
  @DateTimeTimestampConverter()
  final DateTime createdAt;
  QuizzQuestionDto({
    required this.id,
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
    required this.points,
    required this.sortOrder,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => _$QuizzQuestionDtoToJson(this);

  factory QuizzQuestionDto.fromJson(Map<String, dynamic> json) =>
      _$QuizzQuestionDtoFromJson(json);
}
